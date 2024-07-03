---
title: 模块和脚本
draft: 
aliases:
  - 模块和脚本
date: 2024-07-03
description: Move 语言模块和脚本
tags:
  - Move
---
# 模块和脚本

Move有两种不同类型的程序：**模块**和**脚本**。模块是定义结构类型的库，以及对这些类型进行操作的函数。结构类型定义了Move[全局存储](https://aptos.guide/en/build/smart-contracts/book/global-storage-structure)的模式，模块函数定义了更新存储的规则。模块本身也存储在全局存储中。脚本是一个可执行的入口点，类似于传统语言中 `main` 函数。脚本通常调用已发布模块的函数，这些函数执行对全局存储的更新。脚本是临时代码片段，不会发布在全局存储中。

Move 源文件（或**编译单元**）可能包含多个模块和脚本。然而，发布模块或执行脚本是单独的虚拟机操作。

# 语法

## 脚本

要了解如何发布和执行移动脚本，请遵循[移动脚本](https://aptos.guide/en/build/smart-contracts/scripts/script-tutorial)示例。

脚本具有以下结构：

```
script {    
	<use>*    
	<constants>*    
	fun <identifier><[type parameters: constraint]*>([identifier: type]*) <function_body>
}
```

`script`块必须从其所有[`use`](https://aptos.guide/en/build/smart-contracts/book/uses)声明开始，然后是任何[常量](https://aptos.guide/en/build/smart-contracts/book/constants)和（最后）主[函数](https://aptos.guide/en/build/smart-contracts/book/functions)声明。主函数可以具有任何名称（即不需要调用 `main`），是脚本块中唯一的函数，可以具有任意数量的参数，并且不得返回值。以下是每个组件的示例：

```
script {    
	// Import the debug module published at the named account address std.    
	use std::debug;     
	const ONE: u64 = 1;     
	fun main(x: u64) {        
		let sum = x + ONE;        
		debug::print(&sum)    
	}
}
```

脚本的权力非常有限——它们不能声明友元、结构类型或访问全局存储。它们的主要目的是调用模块函数。

## 模块

一个模块具有以下语法：

```
module <address>::<identifier> {    
	(<use> | <friend> | <type> | <function> | <constant>)*
}
```

其中`<address>`是一个有效的[命名地址或字面地址](https://aptos.guide/en/build/smart-contracts/book/address)。

例如：

```
module 0x42::example {    
	struct Example has copy, drop { i: u64 }     
	use std::debug;    
	friend 0x42::another_example;     
	const ONE: u64 = 1;     
	public fun print(x: u64) {        
	let sum = x + ONE;        
	let example = Example { i: sum };        
	debug::print(&sum)    
	}
}
```

`module 0x42::example`部分指定模块`example`将在[全局存储](https://aptos.guide/en/build/smart-contracts/book/global-storage-structure)中的[帐户地址](https://aptos.guide/en/build/smart-contracts/book/address)`0x42`下发布。

模块也可以使用[命名地址](https://aptos.guide/en/build/smart-contracts/book/address)进行声明。例如：

```rust
module example_addr::example {    
	struct Example has copy, drop { 
		a: address 
	}     
	use std::debug;    
	friend example_addr::another_example;     
	public fun print() {        
		let example = Example { 
			a: @example_addr 
		};        
		debug::print(&example)    
	}
}
```

由于命名地址仅存在于源语言级别和编译过程中，因此命名地址将完全取代其在字节码级别的值。例如，如果我们有以下代码：

```rust
script {    
	fun example() {        
		my_addr::m::foo(@my_addr);    
	}
}
```

我们编译它时将`my_addr`设置为`0xC0FFEE`，然后它在操作上相当于以下内容：

```rust
script {    
	fun example() {        
		0xC0FFEE::m::foo(@0xC0FFEE);    
	}
}
```

然而，在源级别，这些_不是等价_的——函数`m::foo`必须通过themy`my_addr`命名地址访问，而不是通过分配给该地址的数值访问。

模块名称可以以字母`a`到`z`或字母`A`到`Z`开头。在第一个字符之后，模块名称可以包含下划线`_`、字母`a`到`z`、字母`A`到`Z`或数字`0`到9。

```rust
module my_module {}
module foo_bar_42 {}
```

通常，模块名称以小写字母开头。名为`my_module`的模块应存储在名为`my_module.move`的源文件中。

`module`块内的所有元素都可以以任何顺序出现。从根本上说，模块是[`types`](https://aptos.guide/en/build/smart-contracts/book/structs-and-resources)和[`functions`](https://aptos.guide/en/build/smart-contracts/book/functions)集合。[`use`](https://aptos.guide/en/build/smart-contracts/book/uses)关键字用于从其他模块导入类型。[`friend`](https://aptos.guide/en/build/smart-contracts/book/friends)关键字指定了受信任模块的列表。[`const`](https://aptos.guide/en/build/smart-contracts/book/constants)关键字定义了可用于模块函数的私有常量。