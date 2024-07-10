---
title: 函数
---

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7; // 指定版本
contract myFunction{
	// 定义一个函数
	// 函数关键字 函数名(参数类型 参数名，参数类型 参数名){}
	function add(uint x,uint y) external pure returns(uint){ // 外部函数，纯函数，不能读写状态变量，只能是局部变量，对链上没有任何读写操作
		return x + y;
	}
	function sub(uint x,uint y) external pure returns(uint) {
		return x - y;
	}
}
```

 - `ecteral`：外部函数
 - `pure`：纯函数，不能读写状态变量，只能是局部变量，对链上没有任何读写操作
 - `returns(uint)` 返回值为 unit 类型

>[!NOTE] 注意
>任何合约都要经过编译和部署

在 solidity 图标的页面编译，在 ethereum 的页面部署，然后测试

>[!TIP] 提示
>按 `ctrl-s` 就会被自动编译

在下方函数名的部分会出现两个方法，
- 测试 `add` 方法：输入 `2,3` 点击 `add`，下方输出：`5`
- 测试 `sub` 方法：输入 `4,3` 点击 `sub`，下方输出：`1`
测试成功


