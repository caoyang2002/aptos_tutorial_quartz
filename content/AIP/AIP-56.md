---
title: AIP-56 资源访问控制
aliases:
  - AIP-56 资源访问控制
draft: 
tags:
  - AIP
description: aptos 优化提案 56 号
date: 2024-07-04
---
```yaml
aip: 56
title: 资源访问控制
author: wg@aptoslabs.com
discussions-to (*可选): TODO
Status: Draft 
last-call-end-date (*可选): <mm/dd/yyyy TBD>
type: Standard
created: <10/11/2023>
```

[TOC]

# AIP-56 - 资源访问控制

## 一、概述

在 Move 中，函数可以访问任意资源，只要它们可以访问允许操作资源的公共 API。关于这一点存在多个问题，如[动机](#二、动机)部分所讨论的。本AIP提议对 Move 语言进行扩展，以实现对资源进行细粒度的访问控制。这通过一种向下兼容的方式泛化了 Move 中熟悉的`acquires T`声明来实现。所得到的访问控制规则的评估主要是**动态**的，但旨在未来变得静态。动态优先的方法是自然的，因为“偏执”VM模式的冗余原则使得动态检查是必要的。

### 1. 目标

本AIP旨在实现以下目标：

- 有机地扩展 Move 语言以支持访问控制，完全向下兼容
- 启用新的并行化（parallelization ）和分片（sharding）策略
- 通过访问控制声明增加用户和审计人员对事务和函数效果的信心
- 通过将访问控制作为类型的一部分，实现安全的动态调度。

### 2. 不在范围内

该功能仅在即将推出的 Aptos Move 编译器（AMC，又称“compiler v2”）中受支持。

最初将不会实现对访问控制的静态分析，但预计在 AMC 推出测试版后准备就绪。

## 二、动机

只要 Move 函数具有访问允许此操作的模块 API 的权限，并且拥有签名者，它就可以读取、写入和创建任意资源。然而，这种做法存在多个问题：

- 过去已经确定它是一个安全风险。例如，一个获取签名者然后委托给一些其他知名合约的交易 —— 一个提供给某些用户的“助手”包装器 -- 可以在用户账户下，并且是用户不知情的情况下创建任意资源，包括部署代码。
- 交易的未指定读 / 写行为使得对区块执行的并行化和实施分片策略变得更加困难。
- 很难推断函数和交易的副作用。这既适用于审计人员，也适用于 Move 证明器等形式分析。推断的唯一方式是查看代码。
- 由于查看代码是推断效果的唯一方式，_调用未知_代码（跨信任边界的动态调度）是不安全的，因此目前在 Move 中被禁止。

## 三、影响

在中期，预计在两个方面会产生重大影响：一方面是分片和并行化，另一方面是启用其他新的语言特性，如动态调度。

## 四、备选方案

在 Solana 中，在交易前必须先声明它从哪些账户读取或写入。类似地，在 Sui Move 中，交易前先要声明它访问哪些对象。使用 Aptos Objects 作为这里提出的基础已经进行了讨论。可以说，这里描述的方法更接近于核心 Move 语言，因为它不依赖于对象等库扩展。这种方法也更通用，因为它允许各种不同的访问模式，包括拒绝。



## 五、规范

### 1. 源语言

Move 中现有的 `acquires T` 符号将被扩展语法替换：

```rust
fun f() acquires R { .. }                      // 当前：读取或写入任何地址；仅对模块本地可见
fun f() reads M1::R writes M2::T { .. }        // 新的访问类型 -- 注意引用其他模块中的类型
fun f<T> acquires R<T> { .. }                  // 支持类型实例化
fun f() acquires 0x42::* { .. }                // 通配符
fun f(x: T) acquires *(address_of(x)) { .. }   // 数据依赖
fun f() acquires !0x1::* { .. }                // 否定
fun f() pure { .. }                            // 纯函数，没有访问
```

如果一个函数有多个访问子句，解释如下：正（非否定）子句构建一个并集，否定子句构建一个交集。因此，在 `reads A !writes B reads C !writes D` 中，如果是对 `A` 或 `B` 的读取，并且如果不是对 `C` 和 `D` 的写入，则允许访问。有关详细信息，请参阅[语义](##3. 语义)部分。

> If a function has multiple access clauses the interpretation is as follows: positive (non-negated) clauses build a union, and negative clauses an intersection. Therefore, in `reads A !writes B reads C !writes D`, access is allowed if it is a read of either `A` or of `B`, _and_ if it is not a write to `C` and `D`. For details, see the [Semantics](#semantics) section.

### 2. 文件格式

现有的 `FunctionHandle` 通过一个字段扩展，该字段包含一个可选的访问规范列表。每个访问规范器由一种类型（读/写/..）、一个资源说明符和一个地址说明符组成。这两种数据类型被选择来表示源语言中看到的各种形式的模式。有关详细信息，请参见实现。



### 3. 语义

#### 3.1 访问规范器子集

访问规范器的概念语法如下：

```rust
AccessSpecifier := { AccessSpecifierClause } 
AccessSpecifierClause := [ ! ] Kind ResourceSpecifier AddressSpecifier
ResourceSpecifier := * | Address::* | Address::Module::* | Address::Module::Resource [ TypeArgs ]
AddressSpecifier := * | Address | Parameter | Function Parameter
Kind := acquires | reads | writes
```

指定访问规范器语义的基本函数是 _包含_（在此处表示为 `in`）。就语义而言，假定依赖于参数或参数函数的地址标识符已经根据函数的具体参数解析为具体地址。在下面的定义中，`K`代表访问类型（读取，写入，获取），`A`代表模块地址，`M`代表模块名称，`R`代表资源名称，`<T>`代表类型实例化，`X`代表资源地址。此外，小写字母 `a` 表示完全访问，`s1` 和 `t1` 表示访问规范器子句。

```rust
K A::M::R<T>(X)   in *
K A::M::R<T>(X)   in A::*           
K A::M::R<T>(X)   in A::M::*       
K A::M::R<T>(X)   in A::M::R      
K A::M::R<T>(X)   in A::M::R<T>
K A::M::R<T>(X)   in A::M::R<T>(X)
a                 in s1, s2, .., !t1, !t2, ..
                    当且仅当 (a 在 s1 或 a 在 s2 或 ..) 
                         且不 (a 在 t1) 且不 (a 在 t2) 且不 ..
```

基于包含关系，另外两个运算符也很重要：联接（用 `*` 表示）和包含关系（用 `>=` 表示）。从集合的角度来看，联接是交集，包含关系是超集。定义如下：

```rust
对于所有 s1, s2:     s1 >= s2       <==> (对于所有 a: a 在 a2 中 ==> a 在 a1 中)
对于所有 s1, s2, s:  s == s1 * s2   <==> (对于所有 a: a 在 s <==> a 在 s1 且 a 在 s2) 
```

#### 3.2 运行时评估

在运行时，维护一个保存的访问规范器栈（stack）以及一个活动的当前访问规范器（specifier）。当进入具有访问规范器的函数时，当前活动集将保存到栈（stack）中。然后，它的值与当前函数的值进行 _联接_（上面的 `*` 运算符）。如果联接的结果不包含被调用函数的规范器，则执行中止：

```rust
access_stack.push(active_accces)
active_access := active_access * function_access
let call_allowed := active_access.subsumes(function_access)
if !(active_access >= function_access) {
    abort
}
```
请注意，当进入一个可能有不允许访问的函数时，我们不能简单地总是中止执行，原因有两点：

- 该函数可能根本没有任何规范器。在这种情况下，`active_access` 在函数进入时保持不变，并且在发生实际访问时进行检查。
- 对包含关系 (`>=`) 的实现允许是一种过度近似。这是因为规范器中存在拒绝（negation），使得包含关系的检查变得困难。因此，我们可能无法确定 `active_access >= function_access`。这种情况在语义上仍然合理，因为与根本没有规范器的函数类似，访问在发生时仍然会进行检查。

在执行期间，每当访问资源时（move_to、move_from、exists、borrow_global、borrow_global_mut），都会针对当前活动访问规范器检查该操作，如果访问不被允许，则执行中止。

请注意，除非涉及到信任边界（事务和公共函数），我们很少指望用户编写访问规范器，因此一般情况下堆栈不会很深。

#### 3.3 Gas 成本

访问规范器需要进行计费，以防止它们被滥用。这与Aptos当前如何处理偏执模式（paranoid mode）不同。因为这个特性为用户增加了额外的效用，所以对其进行计费（metering）是合理的。

#### 3.4 兼容性

由于访问规范器被编码在从导入模块复制的 `FunctionHandle` 实例中，当依赖关系升级时，它们会过时。升级的兼容性规则是访问规范器只能被约束，即 `S_v1 >= S_v2 >= ...`

由于访问规范器被编码在从导入模块复制的 `FunctionHandle` 实例中，所以当依赖项升级时，它们会变得过时。升级的兼容性规则是访问规范器只能被约束，也就是说 `S_v1 >= S_v2 >= ...`。

## 六、参考实现

请参阅 [PR #10480](https://github.com/aptos-labs/aptos-core/pull/10480) 以获取编译器实现。

请参阅 [PR #10544](https://github.com/aptos-labs/aptos-core/pull/10544) 以获取虚拟机实现。

## 七、测试

可以通过单元测试很好地测试访问规范器的行为。预计会有重大的覆盖率。

## 八、风险和缺点

特定风险包括开发者的选择和工程复杂性。这个特性需要有很好的文档，并提供直观的示例。我们还可以构建工具，自动为公共函数推导访问规范器，从而减轻工作量。

## 九、未来潜力

### 1. 静态分析

静态分析可以逐步实施 -- 这意味着不需要在编译时评估所有方面。然而，静态分析越好，用户体验越好。

对于静态分析，很可能需要强制要求公共函数的访问规范器。否则，这在技术上是不可行的。

标准的函数间数据流分析应该能够计算访问。在以下情况，它会产生错误，类似于当前语言版本中的 `acquires` 检查：

- 如果在当前上下文中访问不允许的资源
- 如果调用了访问更多资源的函数，超过了上下文中允许的范围
- 如果访问规范器声明不完整

### 2. 高阶函数

跨信任边界调用的高阶函数可以使用访问规范器更安全地实现。为此，函数类型可以指定访问规范器。例如：

```rust
module myaddr::m {
  public entry fun transfer_with_callback(
     s: signer, ..., 
     call_back: ||() !acquires myaddr::*, *(address_of(s))
  ) 
  { .. }
}
```
函数类型 `||()` 被标注为传入的函数不能访问模块中声明的任何资源，也不能访问在签名者地址下发布的资源。这有效地防止了重入（ re-entrance）。通常情况下，给定函数类型 `f: |T|R S`，其中 `S` 是一个访问规范器，类型规则要求对于任何传入的函数参数类型 `|T|R S'`，都必须满足 `S >= S'`。

## 十、时间线

### 1. 建议的实现时间线

预计将于 23 年底实现。然而，对公众可用性的影响取决于新的 Aptos Move 编译器的准备情况。

### 2. 建议的开发者平台支持时间线

与新的 Aptos Move 编译器一起。

### 3. 建议的部署时间线

与新的 Aptos Move 编译器一起。

## 十一、安全考虑

这个功能在安全上非常重要，因为审计人员和工具需要能够假定访问规范器按预期工作。测试需要全面。还需要对运行时部分进行审计。除了功能上的正确性，还需要考虑运行时访问控制检查的潜在安全风险：

- 检查是否可能花费非常长的时间并导致拒绝服务攻击（DoS）？
- 如果涉及数据类型的构造，是否可能耗尽 RAM？

## 十二、待解决问题

- 我们是否应该区分更多的访问类型（除了读写 `move_to` 和 `move_from` 之外）？
- 是否应该强制要求对公共函数设置访问规范器（采取一些老规则保留的方法）？