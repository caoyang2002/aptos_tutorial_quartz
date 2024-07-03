---
title: 签名者
draft: 
aliases:
  - 签名者
date: 2024-07-03
description: 签名者
tags:
  - Move
---
# 签名者

`signer`是一个内置的移动资源类型。`signer`是一种允许持有人代表特定`address`行事[的能力](https://en.wikipedia.org/wiki/Object-capability_model)。您可以将本机实现视为：

```
module 0x1::signer {  struct signer has drop { a: address }}
```

`signer`有点类似于Unix [UID](https://en.wikipedia.org/wiki/User_identifier)，因为它代表通过Move_之外_的代码进行身份验证的用户（例如，通过检查加密签名或密码）。

## 比较到`address`[](https://aptos.guide/en/build/smart-contracts/book/signer#comparison-to-address)

Move程序可以使用地址文字创建任何`address`值，无需特殊许可：

```
script {  
	fun example() {    
	let a1 = @0x1;    
	let a2 = @0x2;    
	// ... and so on for every other possible address  
	}
}
```

然而，`signer`值是特殊的，因为它们不能通过文字或指令创建——只能由Move VM创建。在虚拟机运行具有类型`signer`参数的脚本之前，它将自动创建`signer`值并将其传递到脚本中：

```rust
script {    
	use std::signer;    
	fun main(s: signer) {        
		assert!(signer::address_of(&s) == @0x42, 0);    
	}
}
```

如果脚本从`0x42`以外的任何地址发送，此脚本将以代码`0`中止。

移动脚本可以有任意数量的`signer`，只要`signer`是任何其他参数的前缀。换句话说，所有`signer`论点必须放在第一位：

```rust
script {    
	use std::signer;    
	fun main(s1: signer, s2: signer, x: u64, y: u8) {        
		// ...    
	}
}
```

这对于实现以多方权威原子方式行动_的多签名脚本_非常有用。例如，上述脚本的扩展可以在`s1`和`s2`之间执行原子货币互换。

## `signer`操作符

`std::signer`标准库模块在`signer`值上提供两个实用功能：

|功能|描述|
|---|---|
|`signer::address_of(&signer): address`|返回由此`&signer`包装的`address`。|
|`signer::borrow_address(&signer): &address`|返回对this`&signer`包装的`address`的引用。|

此外，`move_to<T>(&signer, T)`[全局存储运算符](https://aptos.guide/en/build/smart-contracts/book/global-storage-operators)需要`&signer`参数在`signer.address`帐户下发布资源`T`。这确保了只有经过身份验证的用户才能选择在其`address`下发布资源。

## 所有权

与简单的标量值不同，`signer`值不可复制，这意味着它们不能从任何操作中复制，无论是通过显式[`copy`](https://aptos.guide/en/build/smart-contracts/book/variables#move-and-copy)指令还是通过[取消引用`*`](https://aptos.guide/en/build/smart-contracts/book/references#reading-and-writing-through-references)。