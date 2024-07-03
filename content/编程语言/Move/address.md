---
title: 地址
draft: 
aliases:
  - 地址
date: 2024-07-03
description: move 地址
tags:
  - Move
---
# 地址

`address`是Move中的内置类型，用于表示全局存储中的位置（有时称为帐户）。`address`值是一个256位（32字节）标识符。在给定的地址，可以存储两样东西：[模块](https://aptos.guide/en/build/smart-contracts/book/modules-and-scripts)和[资源](https://aptos.guide/en/build/smart-contracts/book/structs-and-resources)。

虽然`address`是引擎盖下的256位整数，但移动地址是故意不透明的——它们不能从整数创建，它们不支持算术运算，也不能修改。尽管可能有有趣的程序会使用这样的功能（例如，C中的指针算术填补了类似的利基），但Move不允许这种动态行为，因为它从头开始设计，以支持静态验证。

您可以使用运行时地址值（`address`类型值）来访问该地址的资源。您_无法_在运行时通过地址值访问模块。

## 地址及其语法

地址有两种口味，命名或数字。命名地址的语法遵循Move中任何命名标识符的相同规则。数字地址的语法不限于十六进制编码的值，任何有效的[`u256`数字值](https://aptos.guide/en/build/smart-contracts/book/integers)都可以用作地址值，例如，`42`、`0xCAFE`和`2021`都是有效的数字地址文本。

为了区分地址在表达式上下文中是否使用，使用地址时的语法因使用上下文而异：

- 当地址用作表达式时，地址必须以`@`字符为前缀，即[`@<numerical_value>`](https://aptos.guide/en/build/smart-contracts/book/integers)或`@<named_address_identifier>`。
- 在表达式上下文之外，地址可以写入不带前导`@`字符，即[`<numerical_value>`](https://aptos.guide/en/build/smart-contracts/book/integers)或`<named_address_identifier>`。

一般来说，你可以把`@`想象成一个运算符，将地址从命名空间项转为表达式项。

## 命名地址

命名地址是一种功能，允许在任何使用地址的地方使用标识符代替数值，而不仅仅是在值级别。命名地址在Move Packages中声明并绑定为顶级元素（模块和脚本之外），或作为参数传递给Move编译器。

命名地址仅存在于源语言级别，并将在字节码级别完全取代其值。因此，模块和模块成员必须通过模块的命名地址访问，而不是通过编译期间分配给命名地址的数值访问，例如，即使Move程序将`my_addr`设置为`0x2`，`use my_addr::foo`_也不_等价于`use 0x2::foo`。在[模块和脚本](https://aptos.guide/en/build/smart-contracts/book/modules-and-scripts)部分中更详细地讨论了这种区别。

### 实例[](https://aptos.guide/en/build/smart-contracts/book/address#examples)

```rust
script {  
	fun example() {    
		let a1: address = @0x1; // shorthand for 0x0000000000000000000000000000000000000000000000000000000000000001    
		let a2: address = @0x42; // shorthand for 0x0000000000000000000000000000000000000000000000000000000000000042    
		let a3: address = @0xDEADBEEF; // shorthand for 0x00000000000000000000000000000000000000000000000000000000DEADBEEF    
		let a4: address = @0x000000000000000000000000000000000000000000000000000000000000000A;    
		let a5: address = @std; // Assigns `a5` the value of the named address `std`    
		let a6: address = @66;    
		let a7: address = @0x42;  
	}
} 
module 66::some_module {   // Not in expression context, so no @ needed    
	use 0x1::other_module; // Not in expression context so no @ needed    
	use std::vector;       // Can use a named address as a namespace item when using other modules    
	...
}
module std::other_module {  // Can use a named address as a namespace item to declare a module    ...
}
```

## 全局存储操作符

`address` 值的主要目的是与全局存储操作交互。

`address` values are used with the `exists`, `borrow_global`, `borrow_global_mut`, and `move_from`[operations](https://aptos.guide/en/build/smart-contracts/book/global-storage-operators).

唯一**不使用**`address`全局存储操作是n`move_to`，它使用[`signer`](https://aptos.guide/en/build/smart-contracts/book/signer)。

## 所有权

与语言内置的其他标量值一样，`address`值是隐式可复制的，这意味着它们可以在没有[`copy`](https://aptos.guide/en/build/smart-contracts/book/variables#move-and-copy)等显式指令的情况下复制。