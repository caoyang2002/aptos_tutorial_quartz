---
title: 原始类型
draft: 
aliases:
  - 原始类型
date: 2024-07-03
description: move 原始类型
tags:
  - Move
---
# 整数

Move支持六种无符号整数类型：`u8`、`u16`、`u32`、`u64`、`u128`和`u256`。这些类型的值从0到最大值不等，这取决于类型的大小。

|类型|价值范围|
|---|---|
|无符号的8位整数，`u8`|0到28 - 1|
|无符号16位整数，`u16`|0到216 - 1|
|无符号32位整数，`u32`|0到232-1|
|无符号64位整数，`u64`|0到264 - 1|
|无符号128位整数，`u128`|0到2128 - 1|
|无符号256位整数，`u256`|0到2256 - 1|

# 字面量

这些类型的字面值被指定为数字序列（例如，`112`）或作为十六进制文字，例如`0xFF`。文字的类型可以选择添加为后缀，例如`112u8`。如果未指定类型，编译器将尝试从使用文字的上下文中推断类型。如果无法推断类型，则假定为beu`u64`。

数字文字可以用下划线分隔，以便分组和可读性。（例如，`1_234_5678`，`1_000u128`，`0xAB_CD_12_35`）。

如果文字对于其指定（或推断）的大小范围来说太大，则会报告错误。

## 实例

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
	let complex_u8 = 1; 
	// inferred: u8    
	// right hand argument to shift must be u8    
	let _unused = 10 << complex_u8;     
	let x: u8 = 38;    
	let complex_u8 = 2; 
	// inferred: u8    
	// arguments to `+` must have the same type    
	let _unused = x + complex_u8;     
	let complex_u128 = 133_876; 
	// inferred: u128    
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

# 操作符

### 算术运算符

这些类型中的每一个都支持同一组经过检查的算术运算。对于所有这些操作，两个参数（左侧和右侧操作数）**必须**是同一类型。如果您需要对不同类型的值进行操作，则需要首先执行[转换](https://aptos.guide/en/build/smart-contracts/book/integers#casting)。同样，如果您预计操作结果对整数类型来说太大，请在执行操作之前执行更大尺寸的[转换](https://aptos.guide/en/build/smart-contracts/book/integers#casting)。

所有算术运算都会中止，而不是以数学整数不会的行为方式（例如，溢出、下流、除以零）。

| 语法  | 操作    | 中止如果          |
| --- | ----- | ------------- |
| `+` | 添加    | 结果对于整数类型来说太大了 |
| `-` | 减法    | 结果小于零         |
| `*` | 乘法    | 结果对于整数类型来说太大了 |
| `%` | 模块化划分 | 除数是`0`        |
| `/` | 截断分割  | 除数是`0`        |

### 位运算符

整数类型支持以下按位操作，将每个数字视为一系列单独的位，0或1，而不是数值整数值。

按位操作不会中止。

| 语法  | 操作    | 描述             |
| --- | ----- | -------------- |
| `&` | 按位和   | 按配对执行布尔值和每个位   |
| \|  | 按位或   | 按配对执行布尔值或每个位   |
| `^` | 按位xor | 执行布尔排他性或对每个位配对 |

## 位移
与按位运算类似，每个整数类型都支持位移。但与其他操作不同，右侧操作数（移动多少位）必须_始终_是`u8`，并且不需要匹配左侧操作数（您正在移动的数字）。

位移动操作可以在移动位数大于或等于相应类型位宽时中止，对于`u8`、`u16`、`u32`、`u64`、`u128`和`u256`类型，分别对应8位、16位、32位、64位、128位和256位。


|语法|操作|中止，如果|
|---|---|---|
|`<<`|向左移动|要移动的位数大于整数类型的大小|
|`>>`|向右转|要移动的位数大于整数类型的大小|

# 比较

整数类型是Move中唯一可以使用比较运算符的类型。两个参数需要是同一类型的。如果您需要比较不同类型的整数，则需要先[投](https://aptos.guide/en/build/smart-contracts/book/integers#casting)一个整数。

比较操作不会中止。

|语法|操作|
|---|---|
|`<`|小于|
|`>`|大于|
|`<=`|小于或等于|
|`>=`|大于或等于|

### 平等

与所有在Move中[`drop`](https://aptos.guide/en/build/smart-contracts/book/abilities)的类型一样，所有整数类型都支持[“相等”](https://aptos.guide/en/build/smart-contracts/book/equality)和[“不相等”](https://aptos.guide/en/build/smart-contracts/book/equality)操作。两个参数需要是同一类型的。如果您需要比较不同类型的整数，则需要先[投](https://aptos.guide/en/build/smart-contracts/book/integers#casting)一个整数。

平等行动不会中止。

|语法|操作|
|---|---|
|`==`|平等|
|`!=`|不平等|

有关更多详细信息，请参阅关于[平等](https://aptos.guide/en/build/smart-contracts/book/equality)的部分

## 铸造[](https://aptos.guide/en/build/smart-contracts/book/integers#casting)

一种大小的整数类型可以转换为另一种大小的整数类型。整数是Move中唯一支持转换的类型。

演员**不会**截断。如果结果对指定类型来说太大，施法将中止

|语法|操作|中止，如果|
|---|---|---|
|`(e as T)`|将整数表达式`e`转换为整数类型`T`|`e`太大了，无法表示为`T`|

在这里，变量 `e` 的类型必须是 8、16、32、64、128 或 256，而 `T` 必须是 `u8`、`u16`、`u32`、`u64`、`u128` 或 `u256`。


例如：

- `(x as u8)`
- `(y as u16)`
- `(873u16 as u32)`
- `(2u8 as u64)`
- `(1 + 3 as u128)`
- `(4/2 + 12345 as u256)`

## 所有权

与语言内置的其他标量值一样，整数值是隐式复制的，这意味着它们可以在没有显式指令（如[`copy`](https://aptos.guide/en/build/smart-contracts/book/variables#move-and-copy)）的情况下复制。