---
title: " 第二十章 Move 语言规范"
draft: 
aliases:
  - 第二十章 Move 语言规范
tags:
  - MoveOnAptos
---
# 1. 概述

此文档描述了**Move 规范语言（MSL）**，这是[Move](https://aptos.dev/en/build/smart-contracts)语言的一个子集，支持对 Move 程序行为的规范。MSL 与[Move 证明器](https://aptos.dev/en/build/smart-contracts/prover)一起工作，这是一个可以静态验证 MSL 规范相对于 Move 程序的正确性的工具。与传统测试相比，MSL 的验证是详尽的，适用于[Move 模块](https://aptos.dev/en/network/glossary#move-module)或[Move 脚本](https://aptos.dev/en/network/glossary#move-script)的所有可能输入和全局状态。同时，MSL 的这种验证足够快速和自动化，以至于它可以在开发工作流程中通常进行测试的类似位置使用（例如，在持续集成中的拉取请求资格认证）。

虽然此时的 Move 编程语言是稳定的，但由 MSL 表示的子集应被视为不断发展的。这对平台稳定性没有影响，因为 MSL 不在生产中运行；然而，MSL 用于离线质量保证，在其中它为不断发展的目标不断改进。

此文档仅描述语言；有关说明，请参阅[使用 Move 证明器](https://aptos.dev/en/build/smart-contracts/prover/prover-guide)。读者应具备 Move 语言的基本知识，以及前置和后置条件规范的基本原理。（例如，请参阅[按合同设计](https://en.wikipedia.org/wiki/Design_by_contract)）。有关规范的示例，我们参考[Aptos 框架](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-framework/doc/overview.md)文档，其中嵌入了规范。

# 2. 表达式

MSL 中的表达式是 Move 程序表达式的子集加上一组附加结构，如下各节所述。

## 2.1 类型系统

MSL 的类型系统与 Move 类似，但有以下区别：

- 整数类型有两种编码：`num`和`bv`（位向量）。如果一个整数（无论是常量还是变量）直接或间接不涉及任何位运算，无论其在 Move 中的类型（`u8`、`u16`、`u32`、`u64`、`u128`和`u256`）如何，它都被视为相同类型。在规范中，这种类型称为`num`，这是一种任意精度的*有符号*整数类型。当 MSL 引用表示`u8`等的 Move 名称时，它将自动扩展为`num`。这允许编写 MSL 表达式，如`x + 1 <= MAX_U128`或`x - y >= 0`，而无需担心溢出或下溢。与`num`不同，`bv`不能也不需要在规范中明确使用：如果一个整数涉及位运算，如`&`、`|`或`^`，它将在后端自动编码为`bv`。此外，`bv`整数具有固定的精度，与它在 Move 中的精度一致（`bv8`、`bv16`、`bv32`、`bv64`、`bv128`和`bv256`）。请注意，在[SMT](https://en.wikipedia.org/wiki/Satisfiability_modulo_theories)求解器（如[Z3](https://github.com/Z3Prover/z3)）中，一般使用`bv`不如使用`num`高效。因此，Move 证明器在使用位运算时有一些限制，如下所述。

- Move 类型`&T`、`&mut T`和`T`对于 MSL 被视为等效。相等性被解释为值相等。无需担心从 Move 程序中解引用引用：这些会根据需要自动解引用。这种简化是可能的，因为 MSL 不能修改 Move 程序中的值，并且程序不能直接推断引用相等性（这消除了在 MSL 中这样做的需要）。（请注意，这也带来了表达能力的限制，即对于[返回`&mut T`的函数](https://aptos.dev/en/build/smart-contracts/prover/spec-lang#expressiveness)。然而，这在实践中很少遇到，并且有解决方法。）

- 有额外的类型`type`，这是所有类型的类型。它只能在量词中使用。

- 有额外的类型`range`，它表示整数范围（以及表示值的符号`n..m`）。

## 2.2 命名

MSL 中的名称解析与 Move 语言的工作方式类似。`use`声明可以为导入的名称引入别名。MSL 函数和变量名称必须以小写字母开头。模式名称被视为类型，必须以大写字母开头。（[模式](https://aptos.dev/en/build/smart-contracts/prover/spec-lang#schemas)是稍后讨论的命名结构）。

Move 函数、MSL 函数、Move 类型和模式共享相同的命名空间，因此如果通过 Move 的`use`子句进行别名，则它们是明确的。由于共同的命名空间，MSL 函数不能与 Move 函数具有相同的名称。这通常通过约定来处理，即在相关的 Move 函数称为`has_access`时，将 MSL 函数前缀为`spec_has_access`。

## 2.3 运算符

MSL 支持除`&`、`&mut`和`*`（解引用）之外的所有 Move 运算符。

除了现有的运算符外，还支持向量下标`v[i]`、切片`v[i..j]`和范围构造`i..j`（整数范围的类型是一个新的内置类型，称为`range`）。此外，布尔蕴涵`p ==> q`被支持，作为比`!p || q`更直观的形式。

## 2.4 函数调用

在 MSL 表达式中，可以像在 Move 中一样调用函数。但是，被调用者必须是[MSL 辅助函数](https://aptos.dev/en/build/smart-contracts/prover/spec-lang#helper-functions)或**纯**Move 函数。

如果 Move 函数不修改全局状态，并且不使用 MSL 表达式中不支持的 Move 表达式功能（如本文档所定义），则认为它是纯函数。

有一个扩展。如果 Move 函数定义包含直接的`assert`，当从 MSL 表达式调用它时，此`assert`将被忽略，并且该函数将被视为纯函数。例如：

```
module 0x42::m {  fun get(addr: address): &T {    assert(exists<T>(addr), ERROR_CODE);    borrow_global<T>(addr)  }}
```

此函数是纯函数，可以从 MSL 表达式调用。`assert`将被忽略，并且该函数将被解释为：

```
module 0x42::m {  spec fun get(addr: address): T { global<T>(addr) }}
```

这是因为 MSL 具有[*部分语义*](https://aptos.dev/en/build/smart-contracts/prover/spec-lang#partial-semantics)。

## 2.5 语句

支持形式为`{ let x = foo(); x + x }`的有限排序，以及 if-then-else。Move 语言的其他语句形式不受支持。

## 2.6 打包和解包

支持打包表达式。目前不支持解包表达式。

## 2.7 量词

支持全称量词和存在量词。一般形式为：

```rust
forall <绑定>,..., <绑定> [ where <表达式> ] : <表达式>exists <绑定>,..., <绑定> [ where <表达式> ] : <表达式>
```

- 绑定可以是`name: <类型>`或`name in <表达式>`的形式。对于第二种形式，表达式必须是`range`或向量。
- 可选的约束`where <表达式>`允许限制量化的范围。`forall x: T where p: q`等价于`forall x: T : p ==> q`，`exists x: T where p: q`等价于`exists x: T : p && q`。

请注意，可以对类型进行量化。例如：

```
forall t: type, addr: address where exists<R<t>>(addr): exists<T<t>>(addr)
```

## 2.8 选择运算符

选择运算符允许选择满足谓词的值：

```
choose a: address where exists<R>(a) && global<R>(a).value > 0
```

如果谓词不满足，选择的结果将是不确定的。（请参阅[部分语义](https://aptos.dev/en/build/smart-contracts/prover/spec-lang#partial-semantics)）。

选择也有一种形式，可以从一组整数中选择*最小值*，如下所示：

```
choose min i: num where in_range(v, i) && v[i] == 2
```

## 2.9 类型转换运算符

在规范语言中，我们可以使用相同的语法`(e as T)`将具有一个整数类型的表达式`e`转换为`T`，另一种大小的整数类型。

## 2.10 移位运算符

规范语言中支持移位运算符`<<`和`>>`，它们与 Move 语言具有相同的语义。至于中止，如果值`v`的宽度为`n`，则`v << m`或`v >> m`将在`m >= n`时中止。

## 2.11 位运算运算符

使用位运算运算符`&`、`|`和`^`的 Move 程序可以在证明器中进行验证，并且这些运算符在规范语言中也受支持。由于编码和效率问题，使用位运算运算符有更多的注意事项：

- 参与位运算的整数在后端被编码为`bv`类型，并且两种整数编码不兼容。例如，如果变量`v`参与位运算，如`v & 2`或`v = a ^ b`，那么当它在算术运算`v * w`或移位运算`v << w`中使用时，`w`将在 Move 程序中隐式转换为`bv`类型。然而，规范语言不支持隐式类型转换，因此用户必须在规范中显式使用内置函数`int2bv`：`v << int2bv(w)`。请注意，由于每个`bv`类型都有固定的长度（从 8 到 256），`num`类型的值不能转换为`bv`。
- `bv`类型的验证效率不高，可能导致超时。因此，如果可能，用户可能更愿意将位运算与其他运算隔离，并且不使用`int2bv`。此外，用户需要使用 pragmas 来明确指定整数类型的函数参数或结构体字段将用于位运算：

```
module 0x42::m {  struct C has drop {    a: u64,    b: u64  }  spec C {    // b，C 的第二个字段，将是 bv 类型    pragma bv = b"1";  }  public fun foo_generic<T>(i: T): T {    i  }   spec foo_generic {    // 如果 T 实例化为数字类型，第一个参数将是 bv 类型    pragma bv = b"0";    // 如果 T 实例化为数字类型，第一个返回值将是 bv 类型    pragma bv_ret = b"0";  }   public fun test(i: C): u64 {    let x1 = foo_generic(C.b);    x1 ^ x1  }   spec test {    // 为生成正确的 boogie 程序，显式类型转换是必须的    ensures result == (0 as u64);  }}
```

请注意，如果泛型函数或结构体的参数或字段被指定为`bv`类型，当实例化类型为整数类型时，它们在函数或结构体的所有实例中都将是`bv`类型。
- 向量和表中的整数类型的值可以编码为`bv`类型；表中的索引和键目前不能是`bv`类型。使用其他类型将导致内部错误。

## 2.12 内置函数

MSL 支持许多内置常量和函数。其中大多数在 Move 语言中不可用：

- `MAX_U8: num`、`MAX_U64: num`、`MAX_U128: num`返回相应类型的最大值。
- `exists<T>(address): bool`如果地址处存在资源 T，则返回 true。
- `global<T>(address): T`返回地址处的资源值。
- `len<T>(vector<T>): num`返回向量的长度。
- `update<T>(vector<T>, num, T): vector<T>`返回一个新的向量，其中给定索引处的元素已被替换。
- `vec<T>(): vector<T>`返回一个空向量。
- `vec<T>(x): vector<T>`返回一个单元素向量。
- `concat<T>(vector<T>, vector<T>): vector<T>`返回参数的连接。
- `contains<T>(vector<T>, T): bool`如果向量中包含元素，则返回 true。
- `index_of<T>(vector<T>, T): num`返回元素在向量中的索引，如果向量不包含它，则返回向量的长度。
- `range<T>(vector<T>): range`返回向量的索引范围。
- `in_range<T>(vector<T>, num): bool`如果数字在向量的索引范围内，则返回 true。
- `in_range<T>(range, num): bool`如果数字在范围内，则返回 true。
- `update_field(S, F, T): S`更新结构体中的字段，保留其他字段的值，其中`S`是某个结构体，`F`是`S`中的字段名称，`T`是此字段的值。
- `old(T): T`在 Move 函数的入口点提供传递参数的值。这在`ensures`后置条件、内联规范块（具有其他限制）和某些形式的不变量中允许，如下所述。
- `TRACE(T): T`在语义上是恒等函数，并导致证明器创建的错误消息中显示参数的值。
- `int2bv(v)`将整数`v`显式转换为其`bv`表示。
- `bv2int(b)`将`bv`整数`b`显式转换为`num`表示。然而，由于效率问题，不鼓励使用它。

内置函数存在于模块的未命名外部作用域中。如果模块定义了函数`len`，则此定义将遮蔽相应的内置函数。在这种情况下，要访问内置函数，可以使用`::len(v)`的表示法。

## 2.13 部分语义

在 MSL 中，表达式具有部分语义。这与 Move 程序表达式形成对比，后者具有完全语义，因为它们要么提供值，要么中止。

依赖于某些变量`X`的表达式`e[X]`对于`X`中变量的某些赋值可能具有已知的解释，但对于其他赋值可能未知。如果子表达式的未知解释对于整体表达式结果不需要其值，则无关紧要。因此，我们说`y!= 0 && x / y > 0`或`x / y > 0 && y!= 0`并不重要：布尔运算符是可交换的。

这个基本原理继承到更高级的语言结构。例如，在规范中，条件的提供顺序并不重要：`aborts_if y!= 0; ensures result == x / y;`与`ensures result == x / y; aborts_if y!= 0;`相同。同样，`aborts_if P; aborts_if Q;`与`aborts_if Q || P`相同。

此外，部分语义的原则继承到[规范辅助函数](https://aptos.dev/en/build/smart-contracts/prover/spec-lang#helper-functions)，它们的行为是透明的。具体来说，内联这些函数等同于调用它们（按表达式传递参数的语义）。

# 3. 规范

规范包含在所谓的*规范块*（缩写为**spec 块**）中，可以作为模块成员出现，也可以在 Move 函数内部。下面显示了各种类型的 spec 块，并将在后续部分进行讨论。

```
module addr::M {  struct Counter has key {    value: u8,  }   public fun increment(a: address) acquires Counter {    let r = borrow_global_mut<Counter>(a);    spec {      // 针对此代码位置的 spec 块      //...    };    r.value = r.value + 1;  }   spec increment {    // 针对函数 increment 的 spec 块    //...  }   spec Counter {    // 针对结构体 Counter 的 spec 块    //...  }   spec schema Schema {    // 声明模式的 spec 块    //...  }   spec fun f(x: num): num {    // 声明辅助函数的 spec 块    //...  }   spec module {    // 针对整个模块的 spec 块    //...  }}
```

除了 Move 函数内部的 spec 块外，spec 块的文本位置无关紧要。此外，结构体、函数或模块的 spec 块可以重复多次，累积内容。

## 3.1 分离规范

除了将规范放入与常规 Move 定义相同的模块中，还可以将它们放入单独的“规范”模块中，该模块可以位于相同或不同的文件中：

```
module addr::M {    //...}spec addr::M {    spec increment { /*... */ }}
```

规范模块的语法与常规模块相同；但是，不允许 Move 函数和结构体。

规范模块必须与它所针对的 Move 模块一起编译，不能单独编译和验证。

如果 Move 定义相距较远（例如在不同的文件中），可以通过添加此函数的签名来扩充 Move 函数的规范，以提供足够的上下文来理解规范。此语法在常规模块和规范模块中均可选启用：

```
module 0x42::m {  public fun increment(a: address) acquires Counter { /*... */ }  //...  spec increment(a: address) { /*... */ }}
```



# 4. 杂注和属性

杂注和属性是影响规范解释的通用机制。它们也是在成为主流语法的一部分之前试验新概念的扩展点。这里我们简要介绍其一般语法；个别实例将在后面讨论。

杂注的一般形式为：

```
module 0x42::m {  spec item {    pragma <名称> = <字面值>;  }}
```

属性的一般形式为：

```
module 0x42::m {  spec item {  <指令> [<名称> = <字面值>] <内容>; // ensures、aborts_if、include 等  }}
```

`<字面值>`可以是 MSL（或 Move 语言）支持的任何值。可以省略值分配，在这种情况下将使用默认值。例如，通常使用`pragma option;`作为`pragma option = true;`的快捷方式。

不是单个杂注或属性，也可以提供一个列表，如`invariant [global, isolated] P`。

## 4.1 杂注继承

模块规范块中的杂注设置的值适用于模块中的所有其他规范块。函数或结构体规范块中的杂注可以为函数或结构体覆盖此值。此外，某些杂注的默认值可以通过证明器配置定义。

例如，我们看一下`verify`杂注。此杂注用于打开或关闭验证。

```
module 0x42::m {  spec module {    pragma verify = false; // 默认情况下，不在此模块中验证规范 ...  }   spec increment {    pragma verify = true; // 但要验证此函数 ...  }}
```

## 4.2 一般杂注和属性

一些杂注控制验证的一般行为。如下表所示。

| 名称                       | 描述                                                  |
| -------------------------- | ------------------------------------------------------------ |
| `verify`                   | 打开或关闭验证。                                          |
| `intrinsic`                | 将函数标记为跳过 Move 实现并使用证明器原生实现。这使函数即使在 Move 中不是原生函数也表现得像原生函数。 |
| `timeout`                  | 为函数或模块设置超时（秒）。覆盖命令行标志提供的超时。 |
| `verify_duration_estimate` | 设置函数验证所需时间的估计（秒）。如果配置的`timeout`小于此值，将跳过验证。 |
| `seed`                     | 为函数或模块设置随机种子。覆盖命令行标志提供的种子。 |

以下属性控制验证的一般行为：

| 名称            | 描述                                          |
| --------------- | ---------------------------------------------------- |
| `[deactivated]` | 从验证中排除相关条件。 |

## 4.3 前置和后置状态

规范块中的多个条件与*前置*和*后置*状态一起工作，将它们相互关联。函数规范就是一个例子：在`ensures P`条件中，通过谓词`P`将函数入口处的前置状态和函数出口处的后置状态相关联。然而，这个概念更通用，也适用于不变量，其中前置状态是在全局更新之前，后置状态是在全局更新之后。

在前置/后置状态有效的上下文中，表达式在后置状态中隐式求值。要在前置状态中求值表达式，可以使用内置函数`old(exp)`，它在前置状态中计算其参数并返回其值。重要的是要理解，`exp`中的每个子表达式也都在前置状态中计算，包括对辅助函数的调用。

这里的“状态”包括对全局资源内存的赋值，以及任何`&mut T`类型的函数参数。示例：

```
module 0x42::m {  fun increment(counter: &mut u64) { *counter = *counter + 1 }  spec increment {    ensures counter == old(counter) + 1;  }   fun increment_R(addr: address) {    let r = borrow_global_mut<R>(addr);    r.value = r.value + 1;  }  spec increment_R {    ensures global<R>(addr).value == old(global<R>(addr).value) + 1;  }}
```

## 4.4 辅助函数

MSL 允许定义辅助函数。然后这些函数可以在表达式中使用。

辅助函数使用以下语法定义：

```
module 0x42::m {  spec fun exists_balance<Currency>(a: address): bool { exists<Balance<Currency>>(a) }}
```

如示例所示，辅助函数可以是泛型的。此外，它们可以访问全局状态。

辅助函数的定义对于[前置或后置状态](https://aptos.dev/en/build/smart-contracts/prover/spec-lang#pre-and-post-state)是中立的。它们在当前活动状态中求值。例如，要查看前置状态中是否存在余额，可以使用`old(exists_balance<Currency>(a))`。因此，在辅助函数的定义中不允许`old(..)`表达式。

辅助函数是部分函数；请参阅[部分语义](https://aptos.dev/en/build/smart-contracts/prover/spec-lang#partial-semantics)的讨论。

### 4.4.1 未解释函数

通过简单地省略函数体，可以将辅助函数定义为**未解释**：

```
module 0x42::m {  spec fun something(x: num): num;}
```

未解释函数是证明器允许为其分配任意含义的函数，只要在给定的验证上下文中保持一致。未解释函数是规范中抽象的有用工具（另请参阅[抽象规范](https://aptos.dev/en/build/smart-contracts/prover/spec-lang#abstract-specifications)）。

### 4.4.2 公理

可以使用**公理**进一步约束辅助函数的含义。目前，公理必须包含在模块规范块中：

```
module 0x42::m {  spec module {    axiom forall x: num: something(x) == x + 1;  }}
```

应谨慎使用公理，因为它们可能通过相互矛盾的假设在规范逻辑中引入不健全性。Move 证明器通过`--check-inconsistency`标志支持检测不健全性的冒烟测试。

## 4.5 Let 绑定

规范块可以包含 let 绑定，为表达式引入名称：

```
module 0x42::m {  fun get_R(account: signer): R { /*... */ }  spec get_R {    let addr = signer::spec_address_of(account);    aborts_if addr!= ROOT;    ensures result == global<R>(addr);  }}
```

在具有前置和后置状态的规范块（如函数规范）中，`let name = e`形式将在前置状态中计算`e`。要在后置状态中计算表达式，请使用`let post name = e`。在这种形式的右侧表达式中，可以使用`old(..)`来引用前置状态。

## 4.6 Aborts_if 条件

`aborts_if`条件是一个规范块成员，只能出现在函数上下文中。它指定函数中止的条件。

在下面的示例中，我们指定函数`increment`在地址`a`处不存在`Counter`资源时中止（请注意，`a`是`increment`的参数名称）。

```
module 0x42::m {  spec increment {    aborts_if!exists<Counter>(a);  }}
```

如果一个函数有多个`aborts_if`条件，这些条件将相互或运算。组合中止条件（由每个单独条件或运算而成）的求值取决于杂注`aborts_if_is_partial`的值。如果此值为假（默认值），则函数*当且仅当*组合中止条件为真时中止。在这种情况下，上述`increment`的中止规范将导致验证错误，因为`increment`可能还有其他中止情况，即增加`Counter.value`会导致溢出。要解决这个问题，可以像这样完成规范：

```
module 0x42::m {  spec increment {    pragma aborts_if_is_partial = false; // 这是默认值，但在此处添加以作说明  aborts_if!exists<Counter>(a);    aborts_if global<Counter>(a).value == 255;  }}
```

如果`aborts_if_is_partial`的值为真，则组合中止条件（或运算后的单个条件）仅*暗示*函数中止。形式上，如果`A`是组合中止条件，那么当`aborts_if_is_partial = true`时，我们有`A ==> function_aborts`；否则我们有`A <==> function_aborts`。因此，以下内容可以验证：

```
module 0x42::m {  spec increment {    pragma aborts_if_is_partial = true;    aborts_if!exists<Counter>(a);  }}
```

> 注意，将`aborts_if_is_partial`设置为真存在一定风险，最佳实践是在公共函数和 Move 脚本的规范被视为最终确定后避免使用它。这是因为在规范最终确定后更改代码可能会添加新的（非平凡的、不希望的）中止情况，而原始规范未预料到，但仍会无声地通过验证。

如果没有为函数指定中止条件，则中止行为未指定。函数可能中止也可能不中止，无论`aborts_if_is_partial`是否设置，验证都不会引发任何错误。要声明函数从不中止，请使用`aborts_if false`。可以使用杂注`aborts_if_is_strict`来更改此行为；这等同于为每个没有显式`aborts_if`子句的函数添加一个`aborts_if false`。

### 4.6.1 带代码的 Aborts_if 条件

`aborts_if`条件可以用代码增强：

```
module 0x42::m {  fun get_value(addr: address): u64 {    aborts(exists<Counter>(addr), 3);    borrow_global<Counter>(addr).value  }  spec get_value {    aborts_if!exists<Counter>(addr) with 3;  }}
```

如果上述函数在给定条件下不以代码`3`中止，则会产生验证错误。

要指定直接的 VM 中止，可以使用特殊常量`EXECUTION_FAILURE`：

```
module 0x42::m {  fun get(addr: address): &Counter acquires Counter {    borrow_global<Counter>(addr)  }  spec get {    aborts_if!exists<Counter>(addr) with EXECUTION_FAILURE;  }}
```

此相同的常量可用于所有其他 VM 失败（除以零、溢出等）。

## 4.7 Aborts_with 条件

`aborts_with`条件允许指定函数可以以哪些代码中止，而与条件无关。它类似于 Java 等语言中的“throws”子句。

```
module 0x42::m {  fun get_one_off(addr: address): u64 {    aborts(exists<Counter>(addr), 3);    borrow_global<Counter>(addr).value - 1  }  spec get_one_off {    aborts_with 3, EXECUTION_FAILURE;  }}
```

如果函数以任何其他或未指定的代码中止，将产生验证错误。

`aborts_with`条件可以与`aborts_if`条件组合。在这种情况下，`aborts_with`指定除`aborts_if`中给出的代码外，函数还可能以哪些其他代码中止：

```
module 0x42::m {  spec get_one_off {    aborts_if!exists<Counter>(addr) with 3;    aborts_with EXECUTION_FAILURE;  }}
```

如果不希望这样，并且`aborts_with`应该独立于`aborts_if`，可以使用属性`[check]`：

```
module 0x42::m {  spec get_one_off {    aborts_if!exists<Counter>(addr) with 3;    aborts_if global<Counter>(addr) == 0 with EXECUTION_FAILURE;     aborts_with [check] 3, EXECUTION_FAILURE;  }}
```

## 4.8 Requires 条件

`requires`条件是规范块成员，为函数假设一个前置条件。如果函数被调用时违反前置条件，Move 证明器将产生验证错误。

`requires`与`aborts_if`不同：在后一种情况下，函数可以被调用，并且它产生的任何中止都会传播到调用者上下文。在`requires`情况下，Move 证明器首先不允许调用该函数。然而，即使验证被跳过，函数仍可以在运行时被调用。正因为如此，`requires`在 Move 规范中很少见，而`aborts_if`更常见。具体来说，应避免在公共 API 中使用`requires`。

`requires`的一个示例是：

```
module 0x42::m {  spec increment {    requires global<Counter>(a).value < 255;  }}
```

## 4.9 Ensures 条件

`ensures`条件假设一个函数成功终止（即不中止）时的后置条件。为此，Move 证明器将验证每个`ensures`。

`ensures`条件的一个示例如下：

```
module 0x42::m {  spec increment {    ensures global<Counter>(a) == old(global<Counter>(a)) + 1;  }}
```

在`ensures`条件的表达式中，可以使用[前置和后置状态](https://aptos.dev/en/build/smart-contracts/prover/spec-lang#pre-and-post-state)中讨论的`old`函数。

## 4.10 Modifies 条件

`modifies`条件用于为函数提供修改全局存储的权限。注释本身包含全局访问表达式的列表。它专门与[不透明函数规范](https://aptos.dev/en/build/smart-contracts/prover/spec-lang#opaque-specifications)一起使用。

```
module 0x42::m {  struct S has key {    x: u64  }   fun mutate_at(addr: address) acquires S {    let s = borrow_global_mut<S>(addr);    s.x = 2;  }  spec mutate_at {    pragma opaque;    modifies global<S>(addr);  }}
```

一般来说，全局访问表达式的形式为`global<type_expr>(address_expr)`。地址值表达式在前述函数的前置状态中求值。

```
module 0x42::m {  fun read_at(addr: address): u64 acquires S {    let s = borrow_global<S>(addr);    s.x  }   fun mutate_S_test(addr1: address, addr2: address): bool acquires T {    assert(addr1!= addr2, 43);    let x = read_at(addr2);    mutate_at(      addr1    ); // 注意，我们正在修改与之前和之后读取的不同的地址  x == read_at(addr2)  }  spec mutate_S_test {    aborts_if addr1 == addr2;    ensures result == true;  }}
```

在函数`mutate_S_test`中，规范块中的断言预计会成立。`mutate_at`上的`modifies`规范的一个好处是，无论`mutate_at`是否内联，都可以证明此断言。

如果在函数上省略了`modifies`注释，则该函数被视为对其执行期间可能修改的那些资源具有所有可能的权限。函数可能修改的所有资源集通过对代码的过程间分析获得。在上面的示例中，`mutate_S_test`没有`modifies`规范，并通过对`mutate_at`的调用修改了资源`S`。因此，它被认为在任何可能的地址都修改了`S`。相反，如果程序员向`mutate_S_test`的规范中添加`modifies global<S>(addr1)`，则会检查对`mutate_at`的调用，以确保授予`mutate_S_test`的修改权限涵盖授予`mutate_at`的权限。

## 4.11 Invariant 条件

不变量条件可以应用于结构体和全局级别。

### 4.11.1 函数不变量

函数上的`invariant`条件只是具有相同谓词的`requires`和`ensures`的快捷方式。

因此，以下规范块：

```
module 0x42::m {  spec increment {    invariant global<Counter>(a).value < 128;  }}
```

......等价于：

```
module 0x42::m {  spec increment {    requires global<Counter>(a).value < 128;    ensures global<Counter>(a).value < 128;  }}
```

### 4.11.2 结构体不变量

当`invariant`条件应用于结构体时，它表示结构体数据的良好形式属性。当前未被修改的此结构体的任何实例都将满足此属性（下文有例外）。

例如，我们可以假设我们的计数器上的不变量，即其值永远不能超过 127：

```
module 0x42::m {  spec Counter {    invariant value < 128;  }}
```

结构体不变量在构造（打包）结构体值时由 Move 证明器检查。当结构体被修改（例如通过`&mut Counter`）时，不变量*不*成立（但请参阅下文的例外）。一般来说，我们将修改视为隐式解包，修改结束视为打包。

Move 语言语义明确地标识了修改开始和结束的点。这源于 Move 的借用语义，并包括通过封闭结构体的修改。（当内部结构体的修改结束时，修改开始的根结构体的修改也结束。）

有一个例外。当在模块 M 中声明的结构体的可变引用传递到 M 的*公共*函数中，该函数本身*不*返回任何其他可变引用（可能从输入参数借用）时，我们将此参数视为“打包”。这意味着，在函数入口处，我们将解包它，在函数出口处，我们将再次打包它，强制不变量。这反映了在 Move 中，结构体数据只能在声明结构体的模块内修改；因此，对于公共函数的外部调用者，可变引用实际上不能被修改，除非再次调用模块 M 的公共函数。在语义中利用这一点是验证问题的一个重要简化。



# 5. 全局不变量

全局不变量作为模块的成员出现。它可以表达关于 Move 程序的全局状态（由内存中存储的资源表示）的条件。例如，下面的不变量声明在任何给定地址存储的 `Counter` 资源永远不能为零：
```
module addr::M {    invariant forall a: addr where exists<Counter>(a): global<Counter>(a).value > 0;}
```

全局不变量在从全局状态读取数据时被假定成立，并在状态更新时被断言（并且可能验证失败）。例如，下面的函数由于计数器值始终大于零，因此永远不会因算术下溢而中止；但是，由于计数器的值可能降为零，因此会产生验证错误：
```
module 0x42::m {  fun decrement_ad(addr: address) acquires Counter {    let counter = borrow_global_mut<Counter>(addr);    let new_value = counter.value - 1;   // 由于 counter.value > 0，不会中止    *counter.value = new_value;          // 由于值可能降为零，验证失败  }}
```

## 5.1 禁用不变量

有时，全局不变量几乎在所有地方都成立，除了函数内部的短暂间隔。在当前的 Move 代码中，这种情况经常发生在设置某些东西（例如账户）并且一起发布多个结构体时。几乎在所有地方，都有一个不变量，即所有结构体都被发布或都未被发布。但是发布结构体的代码必须按顺序进行。在结构体被发布时，会有一些已发布而另一些未发布的情况。

为了验证除小区域外成立的不变量，有一个功能允许用户暂时禁用不变量。考虑以下代码片段：
```
module 0x42::m {  fun setup() {    publish1();    publish2();  }}
```

其中 `publish1` 和 `publish2` 在地址 `a` 发布两个不同的结构体 `T1` 和 `T2` 。

```
module addr::M {    invariant [global] exists<T1>(a) == exists<T2>(a)}
```

照此编写，Move 证明器将在调用 `publish1` 之后和调用 `publish2` 之前报告不变量被违反。如果 `publish1` 或 `publish2` 中的任何一个不存在，Move 证明器也将报告不变量被违反。

默认情况下，全局不变量在触及全局不变量中提到的资源的指令 `I` 之后立即被检查。不变量一侧的 `[suspendable]` 属性与函数规范块中指定的两个杂注一起，提供了关于我们希望检查此不变量的位置的细粒度控制：

- `disable_invariants_in_body`：不变量将在 `I` 所在的函数结束时被检查。
- `delegate_invariants_to_caller`：不变量将由 `I` 所在的函数的所有调用者进行检查。

对于上述示例，我们可以添加杂注 `disable_invariants_in_body`：
```
module 0x42::m {  spec setup {    pragma disable_invariants_in_body;  }}
```

这意味着在 `setup` 执行期间不需要保持不变量，但在进入和退出 `setup` 时假定它们成立。

此杂注改变了 Move 证明器的行为。在进入 `setup` 时假定不变量，但在 `publish1` 和 `publish2` 期间或之后不进行证明。相反，在 `setup` 主体中可能无效的所有不变量在从 `setup` 返回时被断言和证明。此处理的一个后果是，用户可能需要在 `publish1` 和 `publish2` 上提供更强的后置条件，以便能够在退出 `setup` 时证明不变量。

此处理的另一个后果是，在 `publish1` 和 `publish2` 的执行期间不能安全地假定不变量成立（除非 `setup` 主体中没有更改不变量中提到的状态）。因此，如果证明后置条件需要假定不变量，则后置条件将失败。

在示例中，不变量在 `setup` 的调用点成立，但在主体中不成立。对于 `publish1`，不变量不一定在调用点或函数主体中成立。在示例中，这种行为是隐含的，因为 `publish1` 是在禁用不变量的上下文中被调用的。

当在上述示例中的 `setup` 中禁用不变量时，Move 证明器在进入 `publish1` 和 `publish2` 时不能假定它们，并且不应在从这些函数退出时尝试证明它们。对于由 `publish1` 或 `publish2` 调用的任何函数，Move 证明器将自动采用相同的行为，但用户可以声明一个函数被视为 `publish1` 。

例如，如果 `publish2` 仅从上述的 `setup` 函数调用，并且我们没有在 `setup` 中禁用不变量，我们可以使用杂注 `delegate_invariants_to_caller` 来实现类似的效果。
```
module 0x42::m {  spec setup {    pragma delegate_invariants_to_caller;  }}
```

这只有在 `setup` 是私有或 `public (friend)` 函数时才合法。与在 `setup` 中禁用不变量的区别在于，在开始时不会假定不变量，并且在 `setup` 返回的每个调用点都会在之后进行证明。

虽然这两个杂注都在函数主体中禁用不变量，但区别在于 `disable_invariants_in_body` 在进入时假定不变量并在退出时证明，而 `delegate_invariants_to_caller` 两者都不做。

关于如何使用这些杂注存在一些限制。对于将不变量委托给调用者的函数，无论是通过杂注显式委托还是因为函数在已禁用不变量的上下文中被调用而隐式委托，都不能声明 `disable_invariants_in_body` 。（此限制是为了确保处理一致，因为一个杂注假定在调用上下文中不变量成立，而另一个则不成立）。其次，对于公共或脚本函数，将不变量检查委托给其调用者是非法的（因为 Move 证明器不知道所有调用点），除非该函数不可能使不变量无效，因为它不会更改不变量中出现的 `exists` 和 `global` 表达式中提到的任何状态。

## 5.2 更新不变量

全局不变量的 `update` 形式允许表达全局状态更新的[前置状态和后置状态](https://aptos.dev/en/build/smart-contracts/prover/spec-lang#pre-and-post-state)之间的关系。例如，下面的不变量声明每当计数器被更新时，它必须单调递减：
```
module addr::M {    invariant update [global] forall a: addr where old(exists<Counter>(a)) && exists<Counter>(addr):        global<Counter>(a).value <= old(global<Counter>(a));}
```

## 5.3 隔离的全局不变量

全局不变量可以标记为 `[isolated]` ，以表明它与证明程序的其他属性无关。在读取相关全局状态时，不会假定隔离的全局不变量。它仅在状态更新之前被假定，以帮助证明更新后不变量仍然成立。此功能用于在存在许多全局不变量但它们对验证没有直接影响的情况下提高性能。

## 5.4 模块化验证和全局不变量

全局不变量的某些用法会导致无法以模块化方式检查的验证问题。这里的“模块化”意味着可以独立验证一个模块，并证明在所有使用上下文中（如果满足前提条件）都是普遍正确的。

如果全局不变量引用来自多个模块的状态，则可能会出现非模块化验证问题。考虑这样一种情况，模块 `M1` 使用模块 `M2`，并且 `M1` 包含以下不变量，其中辅助函数 `condition` 引用每个相应模块的全局状态：
```
module addr::M1 {    invariant M1::condition() ==> M2::condition();}
```

当我们独立验证 `M1` 时，Move 证明器将确定它还需要验证 `M2` 中的函数，即那些更新 `M2` 内存从而使 `M1` 中的不变量可能失败的函数。

## 5.5 代码中的假设和断言条件

规范块也可能出现在普通 Move 语句块可以出现的任何位置。以下是一个示例：
```
module 0x42::m {  fun simple1(x: u64, y: u64) {    let z;    y = x;    z = x + y;    spec {      assert x == y;      assert z == 2 * x;    }  }}
```

在这样的内联规范块中，仅允许子集的条件：

- `assume` 和 `assert` 语句在任何代码位置都允许。
- 循环 `invariant` 语句仅允许在表示循环头的代码位置。

规范块内的 `assert` 语句表示当控制到达该块时必须成立的条件。如果条件不成立，Move 证明器将报告错误。另一方面，`assume` 语句会阻止违反语句中条件的执行。下面显示的函数 `simple2` 由 Move 证明器验证。但是，如果删除包含 `assume` 语句的第一个规范块，Move 证明器将对第二个规范块中的 `assert` 语句显示违反。
```
module 0x42::m {  fun simple2(x: u64, y: u64) {    let z: u64;    spec {      assume x > y;    };    z = x + y;    spec {      assert z > 2 * y;    }  }}
```

## 5.6 循环不变量

`invariant` 语句编码循环不变量，并且必须放在循环头，如下例所示：
```
module 0x42::m {  fun simple3(n: u64) {    let x = 0;    loop {      spec {        invariant x <= n;      };      if (x < n) {        x = x + 1      } else {        break      }    };    spec {      assert x == n;    }  }}
```

循环不变量被转换为两个 `assert` 语句和一个 `assume` 语句，以促进关于循环属性的归纳推理。细分来说，循环不变量被转换为：

- 一个 `assert` 语句，确认在执行中首次遇到循环时不变量成立 - 建立基本情况。
- 一个 `assume` 语句，编码在循环迭代 `I` 时不变量成立的属性。
- 一个 `assert` 语句，检查在循环迭代 `I+1` 时不变量是否仍然成立。

## 5.7 引用前置状态

偶尔，我们希望在内联规范块中引用可变函数参数的前置状态。在 MSL 中，可以使用 `old(T)` 表达式来实现。与后置条件中 `old(..)` 的语义类似，`assume` 或 `assert` 语句中的 `old(T)` 表达式始终产生函数入口点处 `T` 的值。以下是一个示例，说明了如何在内联规范块中使用 `old(..)`：
```
module 0x42::m {  fun swap(x: &mut u64, y: &mut u64) {    let t = *x;    *x = *y;    *y = t;    spec {      assert x == old(y);      assert y == old(x);    };  }}
```

上述示例很简单，因为相同的属性也可以用后置条件（即 `ensures`）来表达。但是在某些情况下，我们必须使用 `old(..)` 来引用前置状态，特别是在循环不变量的规范中。考虑下面的示例，我们验证 `vector_reverse` 函数是否正确地反转了向量中的所有元素：

```
module 0x42::m {  fun verify_reverse<Element>(v: &mut vector<Element>) {    let vlen = vector::length(v);    if (vlen == 0) return;     let front_index = 0;    let back_index = vlen - 1;    while ({      spec {        assert front_index + back_index == vlen - 1;        assert forall i in 0..front_index: v[i] == old(v)[vlen - 1 - i];        assert forall i in 0..front_index: v[vlen - 1 - i] == old(v)[i];        assert forall j in front_index..back_index + 1: v[j] == old(v)[j];        assert len(v) == vlen;      };      (front_index < back_index)    }) {      vector::swap(v, front_index, back_index);      front_index = front_index + 1;      back_index = back_index - 1;    };  }  spec verify_reverse {    aborts_if false;    ensures forall i in 0..len(v): v[i] == old(v)[len(v) - 1 - i];  }}
```

注意循环不变量中 `old(v)` 的用法。如果没有它们，很难表达在循环迭代时向量部分反转而其余部分不变的不变量。

然而，与 `ensures` 条件中的 `old(T)` 表达式不同，其中 `T` 可以是任何有效的表达式（例如，允许 `old(v[i])`），`assert` 和 `assumes` 语句中的 `old(T)` 表达式仅接受单个变量作为 `T`，并且该变量必须是可变引用类型的函数参数。在上述示例中，不允许 `old(v[i])`，而应使用 `old(v)[i]` 。

## 5.8 规范变量

MSL 支持*规范变量*，在验证社区中也称为*幽灵变量*。这些变量仅在规范中使用，并表示从资源的全局状态派生的信息。一个示例用例是计算系统中所有可用硬币的总和，并指定总和只能在某些情况下更改。

我们通过引入一个规范变量来说明此功能，该变量维护我们正在运行的示例中的所有 `Counter` 资源的总和。首先，通过规范模块块引入规范变量，如下所示：
```
module 0x42::m {  spec module {    global sum_of_counters: num;  }}
```

每当 `Counter` 被打包或解包时，此值将被更新。（回想一下，突变被解释为隐式解包和打包）：

```
module 0x42::m {  spec Counter {    invariant pack sum_of_counters = sum_of_counters + value;    invariant unpack sum_of_counters = sum_of_counters - value;  }}
```

> 注意：`invariant pack` 和 `invariant unpack` 目前尚未实现

现在，例如，我们可能希望指定全局状态中所有 `Counter` 实例的总和永远不会超过特定值。我们可以这样做：
```
module 0x42::m {  spec module {    invariant [global] sum_of_counters < 4711;  }}
```

请注意，规范变量也可以从辅助函数中引用。此外，规范变量可以是泛型的：

```
module 0x42::m {  spec module {    global some_generic_var<T>: num;  }}
```

使用这样的规范变量时，必须提供类型参数，例如 `some_generic_var<u64>` 。实际上，泛型规范变量类似于按类型索引的变量族。

# 6. 模式

模式是通过将属性组合在一起来构建规范结构的一种方式。从语义上讲，它们只是语法糖，扩展为对函数、结构体或模块的条件。

## 6.1 基本模式用法

模式的使用如下：
```
module 0x42::m {  spec schema IncrementAborts {    a: address;    aborts_if!exists<Counter>(a);    aborts_if global<Counter>(a).value == 255;  }   spec increment {    include IncrementAborts;  }}
```

每个模式可以声明一些类型化的变量名称和这些变量的条件列表。所有支持的条件类型都可以在模式中使用。然后可以将模式包含在另一个规范块中：

- 如果该规范块是针对函数或结构体，则模式声明的所有变量名称必须与上下文中兼容类型的现有名称匹配。
- 如果模式包含在另一个模式中，则匹配现有名称并且必须具有相同的类型，但不存在的名称将作为新声明添加到包含上下文中。

当模式包含在另一个规范块中时，将检查它包含的条件在该块中是否允许。例如，将 `IncrementAborts` 模式包含在结构体规范块中将导致编译时错误。

当包含模式时，它声明的名称也可以通过表达式绑定。例如，可以编写 `include IncrementAborts{a: some_helper_address()}` 。实际上，如果 `a` 是范围内的现有名称，不提供绑定等同于编写 `IncrementAborts{a: a}` 。

模式可以是泛型的。泛型模式必须在包含它们的地方完全实例化；模式不支持类型推断。

## 6.2 模式表达式

包含模式时，可以使用有限的布尔运算符集，如下所示：

- `P ==> SchemaExp`：模式中的所有条件都将以 `P ==>..` 为前缀。不基于布尔表达式的条件将被拒绝。
- `if (P) SchemaExp1 else SchemaExp2`：这类似于同时包含 `P ==> SchemaExp1` 和 `!P ==> SchemaExp2` 。
- `SchemaExp1 && SchemaExp2`：这被视为对两个模式表达式的包含。


## 6.3 模式表达式

当包含模式时，可以使用有限的布尔运算符，如下所示：

- `P ==> SchemaExp`：模式中的所有条件都将添加前缀`P ==>..`。不基于布尔表达式的条件将被拒绝。
- `if (P) SchemaExp1 else SchemaExp2`：这类似于同时包含`P ==> SchemaExp1`和`!P ==> SchemaExp2`。
- `SchemaExp1 && SchemaExp2`：这被视为对两个模式表达式的包含。

## 6.4 模式应用操作

模式的主要用例之一是能够给一组属性命名，然后将它们应用于一组函数。这通过`apply`操作符来实现。`apply`规范块成员只能出现在模块规范块中。

`apply`操作符的一般形式是`apply Schema to FunctionPattern,.. except FunctionPattern,..`。这里，`Schema`可以是模式名称或模式名称加上形式类型参数。`FunctionPatterns`由可选的可见性修饰符`public`或`internal`（如果未提供，则两种可见性都匹配）、一个类似 shell 文件模式的名称模式（例如`*`、`foo*`、`foo*bar`等），最后是一个可选的类型参数列表。提供给`Schema`的所有类型参数都必须在此列表中绑定，反之亦然。

`apply`操作符将给定的模式包含在所有匹配模式的函数规范块中，除了通过`except`模式排除的那些。

`apply`操作符的典型用法是为模块中的所有函数提供一些通用的前置条件和后置条件，但有一些例外。例如：
```
module 0x42::m {  spec schema Unchanged {    let resource = global<R>(ADDR);    ensures resource == old(resource);  }   spec module {    // 对除了initialize函数之外的所有函数强制使用Unchanged    apply Unchanged to * except initialize;  }}
```

请注意，虽然使用[全局不变量](https://aptos.dev/en/build/smart-contracts/prover/spec-lang#global-invariants)我们可以表达类似的东西，但我们*不能*表达将不变量限制为仅特定的函数。

## 6.5 不透明规范

使用杂注`opaque`，函数在调用方被声明仅由其规范定义。相反，如果未提供此杂注，则函数的实现将被用作验证调用方的基础。

使用`opaque`要求规范对于当前的验证问题足够完整。没有`opaque`，Move 证明器将把函数的实现作为函数定义的真实来源。但是有`opaque`，如果函数定义的某个方面未指定，则会假定一个任意的含义。例如，对于下面的规范，`increment`函数可能在任意条件下中止：
```
module 0x42::m {  spec increment {    pragma opaque;    // aborts_if!exists<Counter>(a);  // 我们需要添加这个以防止函数任意中止    ensures global<Counter>(a) == old(global<Counter>(a)) + 1;  }}
```

一般来说，`opaque`函数能够实现模块化验证，因为它们从函数的实现中抽象出来，从而导致验证速度更快。

如果一个`opaque`函数修改状态，建议在其规范中使用[`modifies`条件](https://aptos.dev/en/build/smart-contracts/prover/spec-lang#modifies-condition)。如果省略，状态更改的验证将失败。

## 6.6 抽象规范

`[abstract]`属性允许指定一个函数，以便在调用方使用不同于实际实现的抽象语义。如果实现对于验证来说太复杂，而抽象语义足以满足验证目标，这将非常有用。反过来，`[concrete]`属性仍然允许指定根据实现进行验证但不在调用方使用的条件。

考虑下面的哈希函数示例。哈希的实际值与调用者的验证无关，我们使用一个[未解释的辅助函数](https://aptos.dev/en/build/smart-contracts/prover/spec-lang#uninterpreted-functions)，该函数提供由 Move 证明器选择的任意值。我们仍然可以指定具体的实现并验证其正确性：
```
module 0x42::m {  fun hash(v: vector<u8>): u64 {    <<sum up values>>(v)  }  spec hash {    pragma opaque;    aborts_if false;    ensures [concrete] result == << sum up values >> (v);    ensures [abstract] result == spec_hash_abstract(v);  }  spec fun abstract_hash(v: vector<u8>): u64; // 未解释的函数}
```

抽象的合理性是规范制定者的责任，而不是由 Move 证明器验证。

> 注意：抽象/具体属性应该仅与不透明规范一起使用，但即使未与不透明规范一起使用，Move 证明器当前也不会生成错误消息。

> 注意：`modifies`子句当前不支持抽象/具体。此外，如果未给出`modifies`，则无论如何都会根据实现计算修改后的状态，可能与`[abstract]`属性冲突。

## 6.7 文档生成

文件中规范块的组织与文档生成相关 - 尽管与语义无关。

## 6.8 表达能力

Move 规范语言足以表达完整的 Move 语言语义（正式的论证未完成），但有一个例外：返回`&mut T`类型的函数。

考虑以下代码：
```
module 0x42::m {  struct S { x: u64, y: u64 }   fun x_or_y(b: bool, s: &mut S): &mut u64 {    if (b) &mut s.x else &mut s.y  }  spec x_or_y {    ensures b ==> result == s.x;    ensures!b ==> result == s.y;  }}
```

我们无法在 MSL 中指定`x_or_y`的*完整*语义，因为我们无法捕获可变引用的语义。虽然我们可以在函数退出时对引用背后的值进行说明，但诸如`*x_or_y(b, &mut s) = 2`这样的后续效果无法指定。

然而，Move 证明器*确实*理解此类函数的含义 - 限制仅在于我们可以指定的内容。实际上，这意味着我们不能使函数`x_or_y`不透明，必须让验证依赖于 Move 证明器直接处理实现。具体来说，我们可以验证以下内容（然后可以是不透明的）：
```
module 0x42::m {  fun x_or_y_test(s: S): S {    *x_or_y(true, &mut s) = 2;    s  }  spec x_or_y_test {    pragma opaque;    ensures result.x == 2;    ensures result.y == s.y;  }}
```

# 7. 支持资源

- [按合同设计 PRE_POST_REFERENCE](https://en.wikipedia.org/wiki/Design_by_contract)
- [APTOS_FRAMEWORK](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-framework/doc/overview.md)
