---
title: 第四章 局部变量
---
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
contract localVariables{
	uint public i; // 定义状态变量
	bool public b; // 定义状态变量
	address public myAddress; // 定义状态变量
	
	function foo() external {
		uint x = 123; // 局部变量，只在函数的内部生效
		bool f = false; // 局部变量，只在函数的内部生效
		x += 256;
		f = true;
		
		i = 123; // 更改状态变量
		b = true; // 更改状态变量
		myAddress = address(1); // 更改状态变量
	}
}
```