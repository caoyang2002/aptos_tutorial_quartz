---
title: 第三章 状态变量
---

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7; // 指定版本
contract statusVariables{
	// uint public myUint; // 定义一个状态变量
	uint public myUint = 123; // 定义一个状态变量，同时赋予一个初始值
	function foo() external {
		uint nitStatusVeriable = 456; // 变量的值只能在调用 foo 函数的时候，才会在虚拟机的内存中产生，不会记录在链上
	}
}
```

