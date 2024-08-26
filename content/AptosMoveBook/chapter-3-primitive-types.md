---
title: 第三章 原始类型
tags:
  - MoveOnAptos
aliases:
  - 第三章 原始类型
draft: 
description:
---
原始类型包括：整型、布尔、地址、向量、签名、引用、元祖
# 1. 整数

Move 支持六种无符号整数类型：`u8`、`u16`、`u32`、`u64`、`u128`和`u256`。这些类型的值的范围从 0 到一个取决于类型大小的最大值。

| 类型               | 值范围               |
| ---------------- | ----------------- |
| 无符号8位整数，`u8`     | 0 到 $2^8 - 1$     |
| 无符号16位整数，`u16`   | 0 到 $2^{16} - 1$  |
| 无符号32位整数，`u32`   | 0 到 $2^{32} - 1$  |
| 无符号64位整数，`u64`   | 0 到 $2^{64} - 1$  |
| 无符号128位整数，`u128` | 0 到 $2^{128} - 1$ |
| 无符号256位整数，`u256` | 0 到 $2^{256} - 1$ |

## 1.1 字面量

这些类型的字面值可以指定为一系列数字（例如，`112`）或十六进制字面量，例如 `0xFF`。字面量的类型可以作为后缀可选添加，例如 `112u8`。如果没有指定类型，编译器将尝试根据字面量使用的上下文推断类型。如果类型无法推断，它被假定为 `u64`。

数字字面量可以通过下划线分隔以进行分组和提高可读性（例如，`1_234_5678`，`1_000u128`，`0xAB_CD_12_35`）。

>[!NOTE] 重点
>
>如果字面量太大，超出了指定（或推断）的大小范围，将报告错误。

### 示例

```rust
script {
  fun example() {
    // literals with explicit annotations;
    let explicit_u8 = 1u8;
    let explicit_u16 = 1u16;
    let explicit_u32 = 1u32;
    let explicit_u64 = 2u64;
    let explicit_u128 = 3u128;
    let explicit_u256 = 1u256;
    let explicit_u64_underscored = 154_322_973u64;
 
    // literals with simple inference
    let simple_u8: u8 = 1;
    let simple_u16: u16 = 1;
    let simple_u32: u32 = 1;
    let simple_u64: u64 = 2;
    let simple_u128: u128 = 3;
    let simple_u256: u256 = 1;
 
    // literals with more complex inference
    let complex_u8 = 1; // inferred: u8
    // right hand argument to shift must be u8
    let _unused = 10 << complex_u8;
 
    let x: u8 = 38;
    let complex_u8 = 2; // inferred: u8
    // arguments to `+` must have the same type
    let _unused = x + complex_u8;
 
    let complex_u128 = 133_876; // inferred: u128
    // inferred from function argument type
    function_that_takes_u128(complex_u128);
 
    // literals can be written in hex
    let hex_u8: u8 = 0x1;
    let hex_u16: u16 = 0x1BAE;
    let hex_u32: u32 = 0xDEAD80;
    let hex_u64: u64 = 0xCAFE;
    let hex_u128: u128 = 0xDEADBEEF;
    let hex_u256: u256 = 0x1123_456A_BCDE_F;
  }
}
```

## 1.2 操作符

### 1.2.1 算术

这些类型都支持相同的一组检查算术操作。对于所有这些操作，两个参数（左右操作数）*必须*是相同的类型。如果您需要在不同类型的值上进行操作，您将需要首先执行[强制转换](https://aptos.dev/en/build/smart-contracts/book/integers#casting)。同样，如果您期望操作的结果对于整数类型来说太大，那么在执行操作之前先执行一个[强制转换](https://aptos.dev/en/build/smart-contracts/book/integers#casting)到更大的大小。

所有的算术操作都会中止而不是以数学整数不会表现出的方式（例如，溢出、下溢、除以零）。

| 语法  | 操作   | 中止条件         |
| --- | ---- | ------------ |
| `+` | 加法   | 结果对于整数类型来说太大 |
| `-` | 减法   | 结果小于零        |
| `*` | 乘法   | 结果对于整数类型来说太大 |
| `%` | 模除   | 除数是 `0`      |
| `/` | 截断除法 | 除数是 `0`      |

### 1.2.2 位运算

整数类型支持以下位运算，这些操作将每个数字视为一系列单独的位，可以是 `0` 或 `1`，而不是数值整数。

位运算不会中止。

| 语法  | 操作  | 描述            |
| --- | --- | ------------- |
| `&` | 位与  | 对每个位进行布尔与操作   |
| \|  | 位或  | 对每个位进行布尔或操作   |
| `^` | 位异或 | 对每个位进行布尔互斥或操作 |


### 1.2.3 位位移

与位运算类似，每种整数类型都支持位位移。但与其他操作不同，右侧操作数（要移位的位数）必须*总是*是 `u8`，并且不需要与左侧操作数（要移位的数字）匹配。

如果移位的位数大于或等于 `u8`、`u16`、`u32`、`u64`、`u128` 和 `u256` 分别的 `8`、`16`、`32`、`64`、`128` 或 `256`，位位移可以中止。

| 语法 | 操作     | 中止条件                                                    |
| ---- | -------- | ---------------------------------------------------------- |
| `<<` | 左移位   | 要移位的位数大于整数类型的大小                             |
| `>>` | 右移位   | 要移位的位数大于整数类型的大小                             |

### 1.2.4 比较

整数类型是Move中*唯一*可以使用比较运算符的类型。两个参数需要是相同的类型。如果您需要比较不同类型的整数，您将需要[强制转换](https://aptos.dev/en/build/smart-contracts/book/integers#casting)其中一个。

比较操作不会中止。

| 语法 | 操作                  |
| ---- | --------------------- |
| `<`  | 小于                  |
| `>`  | 大于                  |
| `<=` | 小于或等于            |
| `>=` | 大于或等于            |

### 1.2.5 等式

像Move中所有具有[`drop`](https://aptos.dev/en/build/smart-contracts/book/abilities)能力的类型一样，所有整数类型都支持[“等于”](https://aptos.dev/en/build/smart-contracts/book/equality)和[“不等于”](https://aptos.dev/en/build/smart-contracts/book/equality)操作。两个参数需要是相同的类型。如果您需要比较不同类型的整数，您将需要[强制转换](https://aptos.dev/en/build/smart-contracts/book/integers#casting)其中一个。

等式操作不会中止。

| 语法 | 操作    |
| ---- | ------- |
| `==` | 等于    |
| `!=` | 不等于 |

有关更多详细信息，请参见[等式](https://aptos.dev/en/build/smart-contracts/book/equality)部分。

## 1.3 强制转换

一种大小的整数类型可以强制转换为另一种大小的整数类型。

>[!TIP] 提示
>
>整数是 Move 中唯一支持强制转换的类型。

强制转换**不会**截断。如果结果对于指定的类型来说太大，强制转换将中止。

| 语法         | 操作                       | 中止条件             |
| ---------- | ------------------------ | ---------------- |
| `(e as T)` | 将整数表达式 `e` 强制转换为整数类型 `T` | `e` 太大，无法表示为 `T` |

这里，`e` 的类型必须是 `8`、`16`、`32`、`64`、`128` 或 `256`，而 `T` 必须是 `u8`、`u16`、`u32`、`u64`、`u128` 或 `u256`。

例如：

- `(x as u8)`
- `(y as u16)`
- `(873u16 as u32)`
- `(2u8 as u64)`
- `(1 + 3 as u128)`
- `(4/2 + 12345 as u256)`

## 1.4 所有权

如同该语言中内置的其他标量值，整数值是可以被隐式复制的，这意味着它们可以在没有诸如 [`copy`](https://aptos.dev/en/build/smart-contracts/book/variables#move-and-copy) 这样的显式指令的情况下被复制。


# 2. 布尔

`bool` 是 Move 中用于布尔 `true` 和 `false` 值的基本类型。

## 2.1 字面值

`bool` 的字面值要么是 `true` 要么是 `false`。

## 2.2 操作符

### 2.2.1 逻辑

`bool` 支持三种逻辑操作：

| 语法   | 描述    | 等效表达式                              |
| ---- | ----- | ---------------------------------- |
| `&&` | 短路逻辑与 | `p && q` 等效于 `if (p) q else false` |
| \|   | 短路逻辑或 | p  \|  q 等效于 `if (p) true else q`  |
| `!`  | 逻辑非   | `!p` 等效于 `if (p) false else true`  |

### 控制流

`bool` 值在 Move 的几个控制流结构中使用：

- [`if (bool) {... }`](https://aptos.dev/en/build/smart-contracts/book/conditionals)
- [`while (bool) {.. }`](https://aptos.dev/en/build/smart-contracts/book/loops)
- [`assert!(bool, u64)`](https://aptos.dev/en/build/smart-contracts/book/abort-and-assert)

## 所有权

与该语言内置的其他标量值相同，布尔值是可以隐式复制的，这意味着它们可以在没有诸如 [`copy`](https://aptos.dev/en/build/smart-contracts/book/variables#move-and-copy) 这样的显式指令的情况下被复制。


# 3. 地址

`address` 是 Move 中的一个内置类型，用于表示全局存储中的地址（有时称为账户）。`address` 值是一个 256 位（32 字节）的标识符。可以在指定的地址存储两个东西：[模块](https://aptos.dev/en/build/smart-contracts/book/modules-and-scripts) 和 [资源](https://aptos.dev/en/build/smart-contracts/book/structs-and-resources)。

尽管在底层 `address` 是一个 256 位整数，但 Move 的地址故意是不透明的 —— 它们不能通过整数创建，也不支持算术运算，并且不能被修改。即使可能有有趣的程序会使用这样的功能（例如，C 语言中的指针运算有着类似的作用），但 Move 不允许这种动态行为，因为它从一开始就被设计为支持静态验证。

您可以使用运行时地址值（`address` 类型的值）访问该地址的资源。您**不能**通过运行时的地址值访问模块。

## 3.1 地址及其语法

地址有两种类型，命名地址的或数字地址（字面量）。命名地址的语法遵循 Move 中任何命名标识符的规则。数字地址的语法不限于十六进制编码的值，任何有效的 [`u256` 数值](https://aptos.dev/en/build/smart-contracts/book/integers) 都可以用作地址值，例如，`42`、`0xCAFE` 和 `2021` 都是有效的数字地址字面值。

为了区分地址何时在表达式上下文中使用，使用地址的语法根据其使用的上下文而有所不同：

- 当地址用作表达式时，地址必须以 `@` 字符为前缀，即  [`@<数字值>`](https://aptos.dev/en/build/smart-contracts/book/integers) 或 `@<命名地址标识符>`。
- 在表达式上下文之外，地址可以不写前面的 `@` 字符，即  [`<数字值>`](https://aptos.dev/en/build/smart-contracts/book/integers) 或 `<命名地址标识符>`。

>[!TIP] 提示 
>一般来说，您可以将 `@` 视为将地址从命名空间转换为表达式的运算符。

## 3.2 命名地址

命名地址是一个功能，允许在使用地址的任何位置使用标识符代替数字值，而不仅仅是在值级别。命名地址在 Move 包中作为顶级元素（在模块和脚本之外）声明和绑定，或作为参数传递给 Move 编译器。

命名地址仅存在于源语言级别，并将在字节码级别完全替换为其值。因此，模块和模块成员**必须**通过模块的命名地址访问，而不是通过在编译期间分配给命名地址的数字值访问，例如，`use my_addr::foo` 与 `use 0x2::foo` 不等价，即使 Move 程序是使用 `my_addr` 设置为 `0x2` 进行编译的。这一区别在 [模块和脚本](https://aptos.dev/en/build/smart-contracts/book/modules-and-scripts) 部分有更详细的讨论。

### 3.2.1 示例

```rust
script {
  fun example() {
    let a1: address = @0x1; // 简写表示 0x0000000000000000000000000000000000000000000000000000000000000001
    let a2: address = @0x42; // 简写表示 0x0000000000000000000000000000000000000000000000000000000000000042
    let a3: address = @0xDEADBEEF; // 简写表示 0x00000000000000000000000000000000000000000000000000000000DEADBEEF
    let a4: address = @0x000000000000000000000000000000000000000000000000000000000000000A;
    let a5: address = @std; // 将命名地址 `std` 的值赋给 `a5`
    let a6: address = @66;
    let a7: address = @0x42;
  }
}

module 66::some_module {   // 不在表达式上下文中，所以不需要 @
    use 0x1::other_module; // 不在表达式上下文中，所以不需要 @
    use std::vector;       // 可以使用命名地址作为命名空间项目时使用其他模块
    ...
}

module std::other_module {  // 可以使用命名地址作为命名空间项目来声明模块
    ...
}
```

## 3.3 全局存储操作

`address` 值的主要目的是与全局存储操作进行交互。

`address` 值与 `exists`、`borrow_global`、`borrow_global_mut` 和 `move_from` [操作](https://aptos.dev/en/build/smart-contracts/book/global-storage-operators) 一起使用。

唯一不使用 `address` 的全局存储操作是 `move_to`，它使用 [`signer`](https://aptos.dev/en/build/smart-contracts/book/signer)。

## 3.4 所有权

如同该语言中内置的其他标量值，`address` 值是可以被隐式复制的，这意味着它们可以在没有诸如 [`copy`](https://aptos.dev/en/build/smart-contracts/book/variables#move-and-copy) 这样的显式指令的情况下被复制。


# 4. 向量

`vector<T>` 是 Move 提供的唯一原始集合类型。`vector<T>` 是 `T` 的同构集合，可以通过在“末尾”推入或弹出值来增加或减少。

`vector<T>` 可以用任何类型 `T` 实例化。例如，`vector<u64>`、`vector<address>`、`vector<0x42::MyModule::MyResource>` 和 `vector<vector<u8>>` 都是有效的向量类型。

## 4.1 字面值

### 4.1.1 通用 `vector` 字面值

任何类型的向量都可以使用 `vector` 字面值创建。

| 语法                   | 类型                                                                      | 描述                       |
| -------------------- | ----------------------------------------------------------------------- | ------------------------ |
| `vector[]`           | `vector[]: vector<T>` ，其中 `T` 是任何单个非引用类型                                | 一个空向量                    |
| `vector[e1,..., en]` | `vector[e1,..., en]: vector<T>` ，其中 `e_i: T` ，使得 `0 < i <= n` 且 `n > 0` | 一个具有 `n` 个元素（长度为 `n`）的向量 |

在这些情况下，`vector` 的类型是推断出来的，要么从元素类型推断，要么从向量的使用情况推断。如果类型无法推断，或者只是为了更清晰，可以明确指定类型：

```rust
vector<T>[]: vector<T>vector<T>[e1,..., en]: vector<T>
```


#### 4.1.1.1示例向量字面值

```
script {  fun example() {    (vector[]: vector<bool>);    (vector[0u8, 1u8, 2u8]: vector<u8>);    (vector<u128>[]: vector<u128>);    (vector<address>[@0x42, @0x100]: vector<address>);  }}
```



### 4.1.2 `vector<u8>` 字面值

在 Move 中，向量的一个常见用例是表示“字节数组”，用 `vector<u8>` 表示。这些值通常用于加密目的，例如公钥或哈希结果。这些值非常常见，因此提供了特定的语法以使值更具可读性，而不必使用 `vector[]`，其中每个单独的 `u8` 值都以数字形式指定。

目前有两种支持的 `vector<u8>` 字面值类型，**字节字符串**和**十六进制字符串**。

#### 4.1.2.1 字节字符串

字节字符串是以 `b` 为前缀的引号字符串字面值，例如 `b"Hello!\n"` 。

这些是允许转义序列的 ASCII 编码字符串。目前，支持的转义序列是：

| 转义序列   | 描述                     |
| ------ | ---------------------- |
| `\n`   | 换行（或换行符）               |
| `\r`   | 回车                     |
| `\t`   | 制表符                    |
| `\\`   | 反斜杠                    |
| `\0`   | 空值                     |
| `\"`   | 引号                     |
| `\xHH` | 十六进制转义，插入十六进制字节序列 `HH` |

#### 4.1.2.2 十六进制字符串

十六进制字符串是以 `x` 为前缀的引号字符串字面值，例如 `x"48656C6C6F210A"` 。

每个字节对，范围从 `00` 到 `FF`，都被解释为十六进制编码的 `u8` 值。因此，每个字节对对应于生成的 `vector<u8>` 中的单个条目。

#### 4.1.2.3 示例字符串字面值

```rust
script {
  fun byte_and_hex_strings() {
    assert!(b"" == x"", 0);
    assert!(b"Hello!\n" == x"48656C6C6F210A", 1);
    assert!(b"\x48\x65\x6C\x6C\x6F\x21\x0A" == x"48656C6C6F210A", 2);
    assert!(
        b"\"Hello\tworld!\"\n \r \\Null=\0" ==
            x"2248656C6C6F09776F726C6421220A200D205C4E756C6C3D00",
        3
    );
  }
}
```

## 4.2 操作

通过 Move 标准库中的 `std::vector` 模块为 `vector` 提供了若干操作，如下所示。随着时间推移，可能会添加更多操作。关于 `vector` 的最新文档可在此处找到。

`vector` 通过 Move 标准库中的 `std::vector` 模块提供了若干操作，如下所示。随着时间的推移，可能会添加更多操作。关于 `vector` 的最新文档可在 [此处](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/move-stdlib/doc/vector.mdx#0x1_vector) 找到。

| 函数       | 描述                                                  | 是否会引发异常？           |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------ |
| `vector::empty<T>(): vector<T>`                              | 创建一个可以存储 `T` 类型值的空向量     | 从不                                      |
| `vector::is_empty<T>(): bool`                                | 如果向量 `v` 没有元素则返回 `true`，否则返回 `false`  | 从不                                      |
| `vector::singleton<T>(t: T): vector<T>`                      | 创建一个大小为 1 且包含 `t` 的向量                     | 从不                                      |
| `vector::length<T>(v: &vector<T>): u64`                      | 返回向量 `v` 的长度                          | 从不                                      |
| `vector::push_back<T>(v: &mut vector<T>, t: T)`              | 将 `t` 添加到 `v` 的末尾                                    | 从不                                      |
| `vector::pop_back<T>(v: &mut vector<T>): T`                  | 移除并返回 `v` 中的最后一个元素                    | 如果 `v` 为空                            |
| `vector::borrow<T>(v: &vector<T>, i: u64): &T`               | 返回索引 `i` 处的 `T` 的不可变引用        | 如果 `i` 不在范围内                    |
| `vector::borrow_mut<T>(v: &mut vector<T>, i: u64): &mut T`   | 返回索引 `i` 处的 `T` 的可变引用           | 如果 `i` 不在范围内                    |
| `vector::destroy_empty<T>(v: vector<T>)`                     | 删除 `v`                                                   | 如果 `v` 不为空                        |
| `vector::append<T>(v1: &mut vector<T>, v2: vector<T>)`       | 将 `v2` 中的元素添加到 `v1` 的末尾                  | 从不                                      |
| `vector::reverse_append<T>(lhs: &mut vector<T>, other: vector<T>)` | 将 `other` 向量中的所有元素以在 `other` 中出现的相反顺序推送到 `lhs` 向量中 | 从不                                      |
| `vector::contains<T>(v: &vector<T>, e: &T): bool`            | 如果 `e` 在向量 `v` 中，则返回 `true`。否则，返回 `false` | 从不                                      |
| `vector::swap<T>(v: &mut vector<T>, i: u64, j: u64)`         | 交换向量 `v` 中索引为 `i` 和 `j` 的元素 | 如果 `i` 或 `j` 不在范围内             |
| `vector::reverse<T>(v: &mut vector<T>)`                      | 原地反转向量 `v` 中元素的顺序 | 从不                                      |
| `vector::reverse_slice<T>(v: &mut vector<T>, l: u64, r: u64)` | 原地反转向量 `v` 中 `[l, r)` 范围内元素的顺序 | 从不                                      |
| `vector::index_of<T>(v: &vector<T>, e: &T): (bool, u64)`     | 如果 `e` 在向量 `v` 中且位于索引 `i` 处，则返回 `(true, i)`。否则，返回 `(false, 0)` | 从不                                      |
| `vector::insert<T>(v: &mut vector<T>, i: u64, e: T)`         | 在位置 `0 <= i <= length` 插入一个新元素 `e`，使用 `O(length - i)` 时间 | 如果 `i` 不在范围内                    |
| `vector::remove<T>(v: &mut vector<T>, i: u64): T`            | 移除向量 `v` 中索引为 `i` 的元素，并移动所有后续元素。这是 `O(n)` 操作且保留向量中元素的顺序 | 如果 `i` 不在范围内                    |
| `vector::swap_remove<T>(v: &mut vector<T>, i: u64): T`       | 将向量 `v` 中索引为 `i` 的元素与最后一个元素交换，然后弹出该元素，这是 `O(1)` 操作，但不保留向量中元素的顺序 | 如果 `i` 不在范围内                    |
| `vector::trim<T>(v: &mut vector<T>, new_len: u64): u64`      | 将向量 `v` 修剪为较小的大小 `new_len` 并按顺序返回被移除的元素 | 如果 `new_len` 大于 `v` 的长度 |
| `vector::trim_reverse<T>(v: &mut vector<T>, new_len: u64): u64` | 将向量 `v` 修剪为较小的大小 `new_len` 并以相反的顺序返回被移除的元素 | 如果 `new_len` 大于 `v` 的长度 |
| `vector::rotate<T>(v: &mut vector<T>, rot: u64): u64`        | `rotate(&mut [1, 2, 3, 4, 5], 2) -> [3, 4, 5, 1, 2]` 原地操作，返回分割点，例如在此示例中为 3 | 从不                                      |
| `vector::rotate_slice<T>(v: &mut vector<T>, left: u64, rot: u64, right: u64): u64` | 在原地旋转 `[left, right)` 范围内的切片，其中 `left <= rot <= right`，返回分割点 | 从不                                      |

示例

```rust
script {
  use std::vector;

  fun example() {
    let v = vector::empty<u64>();
    vector::push_back(&mut v, 5);
    vector::push_back(&mut v, 6);

    assert!(*vector::borrow(&v, 0) == 5, 42);
    assert!(*vector::borrow(&v, 1) == 6, 42);
    assert!(vector::pop_back(&mut v) == 6, 42);
    assert!(vector::pop_back(&mut v) == 5, 42);
  }
}
```
### 4.2.1 销毁和复制向量
`vector<T>` 的某些行为取决于元素类型 `T` 的能力。例如，包含没有 `drop`能力的元素的向量不能像上面示例中的 `v` 那样被隐式舍弃 —— 它们必须使用 `vector::destroy_empty` 显式销毁。

请注意，除非 `vec` 包含零个元素，否则 `vector::destroy_empty` 将在运行时导致程序终止：

```rust
script {
  fun destroy_any_vector<T>(vec: vector<T>) {
    vector::destroy_empty(vec) // 删除此行将导致编译器错误
  }
}
```

但对销毁包含具有 `drop` 的元素的向量不会发生错误：

```rust
script {
  fun destroy_droppable_vector<T: drop>(vec: vector<T>) {
    // 有效！
    // 无需明确执行任何操作来销毁向量
  }
}
```

同样，除非元素类型具有 `copy`，否则向量不能被复制。换句话说，当且仅当 `T` 具有 `copy` 时，`vector<T>` 才具有 `copy` 。

有关更多详细信息，请参阅关于类型能力和泛型的部分。
on [type abilities](https://aptos.dev/en/build/smart-contracts/book/abilities) and [generics](https://aptos.dev/en/build/smart-contracts/book/generics).

## 4.3 所有权

如上文所述，只有当元素可以被复制时，`vector` 值才能被复制。

# 5. 签名者

`signer` 是 Move 内置的资源类型。`signer` 是一种 [能力](https://en.wikipedia.org/wiki/Object-capability_model)，允许持有者代表特定的 `address` 行事。您可以将原生实现视为：

```rust
module 0x1::signer {  
	struct signer has drop {
		a: address 
	}
}
```

`signer` 有点类似于 Unix 中的 [UID](https://en.wikipedia.org/wiki/User_identifier)，因为它代表通过 Move 之外的代码（例如，通过检查加密签名或密码）进行对用户身份的验证。

## 5.1 与 `address` 的比较

Move 程序可以使用地址字面值在没有特殊权限的情况下创建任何 `address` 值：

```rust
script {
  fun example() {
    let a1 = @0x1;
    let a2 = @0x2;
    //... 以及其他所有可能的地址  
  }
}
```

然而，`signer` 值是特殊的，因为它们不能通过字面值或指令创建——只能由 Move VM 创建。在 VM 运行具有 `signer` 类型参数的脚本之前，它将自动创建 `signer` 值并将它们传递到脚本中：

```rust
script {
    use std::signer;
    fun main(s: signer) {
        assert!(signer::address_of(&s) == @0x42, 0);
    }
}
```

如果此脚本是从除 `0x42` 以外的任何地址发送的，则该脚本将以代码 `0` 中止。

只要 `signer` 是任何其他参数的前缀，Move 脚本就可以有任意数量的 `signer`。换句话说，所有的 `signer` 参数都必须排在前面：

```rust
script {
    use std::signer;
    fun main(s1: signer, s2: signer, x: u64, y: u8) {
        // ...
    }
}
```

这对于实现 **多签脚本** 非常有用，这些脚本可以以多个参与方的权威进行原子操作。例如，上述脚本的扩展可以在 `s1` 和 `s2` 之间执行原子货币交换。

## 5.2 `signer` 操作符

`std::signer` 标准库模块为 `signer` 值提供了两个实用函数：

| 函数                                    | 描述                                                  |
| ------------------------------------------- | ------------------------------------------------------------ |
| `signer::address_of(&signer): address`      | 返回此 `&signer` 所封装的 `address`。              |
| `signer::borrow_address(&signer): &address` | 返回对此 `&signer` 所封装的 `address` 的引用。 |

此外，`move_to<T>(&signer, T)` [全局存储操作符](https://aptos.dev/en/build/smart-contracts/book/global-storage-operators) 需要一个 `&signer` 参数，以便在 `signer.address` 的账户下发布资源 `T`。这确保只有经过身份验证的用户才能选择在其 `address` 下发布资源。

## 5.3 所有权

与简单的标量值不同，`signer` 值不可复制，这意味着它们不能通过任何操作进行复制，无论是通过显式的 [`copy`](https://aptos.dev/en/build/smart-contracts/book/variables#move-and-copy) 指令还是通过 [解引用 `*`](https://aptos.dev/en/build/smart-contracts/book/references#reading-and-writing-through-references)。



# 6. 引用

Move 有两种引用类型：不可变的 `&` 和可变的 `&mut`。

不可变引用是只读的，不能修改原始值（或其任何字段）。可变引用允许通过该引用进行修改。Move 的类型系统执行所有权规则，以防止引用错误。

有关引用规则的更多详细信息，请参阅 [结构体和资源](https://aptos.dev/en/build/smart-contracts/book/structs-and-resources)

## 6.1 引用操作符

Move 提供了用于创建和扩展引用以及将可变引用转换为不可变引用的操作符。在此处和其他地方，我们使用符号 `e: T` 表示“表达式 `e` 具有类型 `T`”。

| 语法          | 类型                               | 描述                         |
| ----------- | -------------------------------- | -------------------------- |
| `&e`        | `&T` ，其中 `e: T` 且 `T` 是非引用类型     | 创建对 `e` 的不可变引用             |
| `&mut e`    | `&mut T` ，其中 `e: T` 且 `T` 是非引用类型 | 创建对 `e` 的可变引用。             |
| `&e.f`      | `&T` ，其中 `e.f: T`                | 创建对结构体 `e` 的字段 `f` 的不可变引用。 |
| `&mut e.f`  | `&mut T` ，其中 `e.f: T`            | 创建对结构体 `e` 的字段 `f` 的可变引用。  |
| `freeze(e)` | `&T` ，其中 `e: &mut T`             | 将可变引用 `e` 转换为不可变引用。        |

`&e.f` 和 `&mut e.f` 操作符既可以用于创建对结构体的新引用，也可以用于扩展现有引用：

```rust
script {
  fun example() {
    let s = S { f: 10 };
    let f_ref1: &u64 = &s.f; // works
    let s_ref: &S = &s;
    let f_ref2: &u64 = &s_ref.f; // also works
  }
}
```

只要两个结构体在同一个模块中，具有多个字段的引用表达式就可以工作：

```rust
module 0x42::example {
  struct A { b: B }
  struct B { c : u64 }
 
  fun f(a: &A): &u64 {
    &a.b.c
  }
}
```

最后，请注意不允许引用的引用：

```rust
script {
  fun example() {
    let x = 7;
    let y: &u64 = &x;
    let z: &&u64 = &y; // will not compile
  }
}
```

## 6.2 通过引用读写

可变引用和不可变引用都可以读取以生成所引用值的副本。

只有可变引用可以写入。写入 `*x = v` 会舍弃之前存储在 `x` 中的值，并将其更新为 `v`。

这两个操作都使用类似 C 的 `*` 语法。但是，请注意读取是一个表达式，而写入是一个必须出现在等号左侧的修改操作。

| 语法     | 类型                                | 描述                         |
| ---------- | ----------------------------------- | ----------------------------------- |
| `*e`       | `T` ，其中 `e` 是 `&T` 或 `&mut T`   | 读取 `e` 所指向的值    |
| `*e1 = e2` | `()` ，其中 `e1: &mut T` 且 `e2: T` | 使用 `e2` 更新 `e1` 中的值。 |

为了读取引用，底层类型必须具有 [`copy` 能力](https://aptos.dev/en/build/smart-contracts/book/abilities)，因为读取引用会创建值的新副本。此规则防止资源值的复制：

```rust
module 0x42::coin {
  struct Coin {} // Note does not have copy
 
  fun copy_resource_via_ref_bad(c: Coin) {
      let c_ref = &c;
      let counterfeit: Coin = *c_ref; // not allowed!
      pay(c);
      pay(counterfeit);
  }
}
```

反之：为了写入引用，底层类型必须具有 [`drop` 能力](https://aptos.dev/en/build/smart-contracts/book/abilities)，因为写入引用会舍弃（或“释放”）旧值。此规则防止资源值的销毁：

```rust
module 0x42::coin {
  struct Coin {} // Note does not have drop
 
  fun destroy_resource_via_ref_bad(ten_coins: Coin, c: Coin) {
      let ref = &mut ten_coins;
      *ref = c; // not allowed--would destroy 10 coins!
  }
}
```


## 6.3 `freeze` 推断

在期望不可变引用的上下文中可以使用可变引用：

```rust
script {
  fun example() {
    let x = 7;
    let y: &u64 = &mut x;
  }
}
```

这是因为在幕后，编译器会在需要的地方插入 `freeze` 指令。以下是更多 `freeze` 推断实际应用的示例：

```
module 0x42::example {
  fun takes_immut_returns_immut(x: &u64): &u64 { x }

  // 在返回值上进行 `freeze` 推断
  fun takes_mut_returns_immut(x: &mut u64): &u64 { x }

  fun expression_examples() {
    let x = 0;
    let y = 0;
    takes_immut_returns_immut(&x); // 没有推断
    takes_immut_returns_immut(&mut x); // 推断为 `freeze(&mut x)`
    takes_mut_returns_immut(&mut x); // 没有推断

    assert!(&x == &mut y, 42); // 推断为 `freeze(&mut y)`
  }

  fun assignment_examples() {
    let x = 0;
    let y = 0;
    let imm_ref: &u64 = &x;

    imm_ref = &x; // 没有推断
    imm_ref = &mut y; // 推断为 `freeze(&mut y)`
  }
}
```

### 6.3.1 子类型

通过这种 `freeze` 推断，Move 类型检查器可以将 `&mut T` 视为 `&T` 的子类型。如上所示，这意味着在任何使用 `&T` 值的表达式中，也可以使用 `&mut T` 值。此术语用于错误消息中，以简洁地指示在提供 `&T` 的地方需要 `&mut T` 。例如

```
module 0x42::example {
  fun read_and_assign(store: &mut u64, new_value: &u64) {
    *store = *new_value
  }
 
  fun subtype_examples() {
    let x: &u64 = &0;
    let y: &mut u64 = &mut 1;
 
    x = &mut 1; // 有效
    y = &2; // 无效!
 
    read_and_assign(y, x); // 有效
    read_and_assign(x, y); // 无效!
  }
}
```

将产生以下错误消息

```
error:
 
    ┌── example.move:12:9 ───
    │
 12 │         y = &2; // invalid!
    │         ^ Invalid assignment to local 'y'
    ·
 12 │         y = &2; // invalid!
    │             -- The type: '&{integer}'
    ·
  9 │         let y: &mut u64 = &mut 1;
    │                -------- Is not a subtype of: '&mut u64'
    │
 
error:
 
    ┌── example.move:15:9 ───
    │
 15 │         read_and_assign(x, y); // invalid!
    │         ^^^^^^^^^^^^^^^^^^^^^ Invalid call of '0x42::example::read_and_assign'. Invalid argument for parameter 'store'
    ·
  8 │         let x: &u64 = &0;
    │                ---- The type: '&u64'
    ·
  3 │     fun read_and_assign(store: &mut u64, new_value: &u64) {
    │                                -------- Is not a subtype of: '&mut u64'
    │
```

目前唯一具有子类型的其他类型是 [元组](https://aptos.dev/en/build/smart-contracts/book/tuples)

## 6.4 所有权

即使存在相同引用的现有副本或扩展，可变引用和不可变引用始终可以被复制和扩展：

```
script {
  fun reference_copies(s: &mut S) {
    let s_copy1 = s; // 可以
    let s_extension = &mut s.f; // 也可以
    let s_copy2 = s; // 仍然可以
    // ...
  }
}
```

对于熟悉 Rust 所有权系统的程序员来说，这可能令人惊讶，因为 Rust 会拒绝上述代码。Move 的类型系统在 [副本](https://aptos.dev/en/build/smart-contracts/book/variables#move-and-copy) 的处理上更宽松，但在写入之前确保可变引用的唯一所有权方面同样严格。

### 6.4.1 引用不能存储

引用和元组是唯一不能作为结构体字段值存储的类型，这也意味着它们不能存在于全局存储中。Move 程序终止时，在程序执行期间创建的所有引用都将被销毁；它们完全是临时的。对于没有 `store` [能力](https://aptos.dev/en/build/smart-contracts/book/abilities) 的类型的值，此不变量也适用，但请注意，引用和元组从一开始就根本不允许在结构体中。

这是 Move 和 Rust 的另一个区别，Rust 允许在结构体中存储引用。

目前，Move 不支持这一点，因为引用不能 [序列化](https://en.wikipedia.org/wiki/Serialization)，但每个 Move 值都必须可序列化。此要求来自 Move 的[持久全局存储](https://aptos.dev/en/build/smart-contracts/book/global-storage-structure)，它需要对值进行序列化，以便在程序执行之间持久保存它们。

可以想象一个更复杂、更具表现力的类型系统，它允许在结构体中存储引用并且禁止这些结构体存在于全局存储中。我们也许可以允许在没有 `store` [能力](https://aptos.dev/en/build/smart-contracts/book/abilities) 的结构体中存在引用，但这并不能完全解决问题：Move 有一个相当复杂的用于跟踪静态引用安全性的系统，并且类型系统的这一方面也必须扩展以支持在结构体中存储引用。简而言之，Move 的类型系统（特别是围绕引用安全性的方面）必须扩展以支持存储引用。但随着语言的发展，我们一直在关注。


# 7. 元组和单元

Move 并不像人们从其他具有元组作为一等值的语言中所期望的那样完全支持元组。然而，为了支持多个返回值，Move 具有类似元组的表达式。这些表达式在运行时不会产生具体的值（字节码中没有元组），因此它们非常有限：它们只能出现在表达式中（通常在函数的返回位置）；它们不能绑定到局部变量；它们不能存储在结构体中；并且元组类型不能用于实例化泛型类型。

同样，单元 `()` 是 Move 源语言创建的一种基于表达式的类型。单元值 `()` 在运行时不会产生任何值。我们可以将 `unit()` 视为一个空元组，并且适用于元组的任何限制也适用于单元。

考虑到这些限制，语言中存在元组可能会让人感到奇怪。但是在其他语言中，元组最常见的用例之一是允许函数返回多个值。一些语言通过强制用户编写包含多个返回值的结构体来设法解决这个问题。然而，在 Move 中，您**不能在结构体中放置引用**。这就要求 Move 支持多个返回值。这些多个返回值在字节码级别都被压入栈中。在源代码级别，这些多个返回值使用元组表示。


## 7.1 字面量 
元组是通过括号内由逗号分隔的表达式列表创建的。

| 语法             | 类型                                                                    | 描述                                  |
| -------------- | --------------------------------------------------------------------- | ----------------------------------- |
| `()`           | `(): ()`                                                              | 单元，空元组，或元组的元数为 0 的元组                |
| `(e1,..., en)` | `(e1,..., en): (T1,..., Tn)` ，其中 `e_i: Ti` ，使得 `0 < i <= n` 且 `n > 0` | 一个 `n` 元组，元数为 `n` 的元组，具有 `n` 个元素的元组 |

请注意，`(e)` 没有类型 `(e): (t)` ，换句话说，不存在只有一个元素的元组。如果括号内只有一个元素，括号仅用于消除模糊性，没有其他特殊含义。 有时，具有两个元素的元组被称为“对”，具有三个元素的元组被称为“三元组”。

### 7.1.1 示例

```rust
module 0x42::example {
  // 这三个函数都是等价的

  // 当未提供返回类型时，默认为 `()`
  fun returns_unit_1() { }

  // 在空表达式块中有一个隐式的 () 值
  fun returns_unit_2(): () { }

  // `returns_unit_1` 和 `returns_unit_2` 的显式版本
  fun returns_unit_3(): () { () }


  fun returns_3_values(): (u64, bool, address) {
    (0, false, @0x42)
  }
  fun returns_4_values(x: &u64): (&u64, u8, u128, vector<u8>) {
    (x, 0, 1, b"foobar")
  }
}
```

## 7.2 操作

目前对元组唯一能做的操作是解构。

### 7.2.1 解构

对于任何大小的元组，它们都可以在 `let` 绑定或赋值中进行解构。

例如：

```
module 0x42::example {
  // 这三个函数是等价的
  fun returns_unit() {}
  fun returns_2_values(): (bool, bool) { (true, false) }
  fun returns_4_values(x: &u64): (&u64, u8, u128, vector<u8>) { (x, 0, 1, b"foobar") }
 
  fun examples(cond: bool) {
    let () = ();
    let (x, y): (u8, u64) = (0, 1);
    let (a, b, c, d) = (@0x0, 0, false, b"");
 
    () = ();
    (x, y) = if (cond) (1, 2) else (3, 4);
    (a, b, c, d) = (@0x1, 1, true, b"1");
  }
 
  fun examples_with_function_calls() {
    let () = returns_unit();
    let (x, y): (bool, bool) = returns_2_values();
    let (a, b, c, d) = returns_4_values(&0);
 
    () = returns_unit();
    (x, y) = returns_2_values();
    (a, b, c, d) = returns_4_values(&1);
  }
}
```

有关更多详细信息，请参阅 [Move 变量](https://aptos.dev/en/build/smart-contracts/book/variables)。

## 7.3 子类型化

与引用一起，元组是 Move 中唯一具有[子类型化](https://en.wikipedia.org/wiki/Subtyping)的其他类型。元组具有子类型化，仅在它们与引用（以协变形式）具有子类型化关系的意义上。

例如：

```
script {
  fun example() {
    let x: &u64 = &0;
    let y: &mut u64 = &mut 1;

    // (&u64, &mut u64) 是 (&u64, &u64) 的子类型
    // 因为 &mut u64 是 &u64 的子类型
    let (a, b): (&u64, &u64) = (x, y);

    // (&mut u64, &mut u64) 是 (&u64, &u64) 的子类型
    // 因为 &mut u64 是 &u64 的子类型
    let (c, d): (&u64, &u64) = (y, y);

    // 错误！(&u64, &mut u64) 不是 (&mut u64, &mut u64) 的子类型
    // 因为 &u64 不是 &mut u64 的子类型
    let (e, f): (&mut u64, &mut u64) = (x, y);
  }
}
```

## 7.4 所有权

如上所述，元组值在运行时实际上并不存在。并且由于这个原因，目前它们不能存储到局部变量中（但很可能这个功能很快就会到来）。因此，目前元组只能被移动，因为复制它们首先需要将它们放入局部变量中。
