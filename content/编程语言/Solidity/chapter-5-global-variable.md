---
title: 第五章 全局变量
---
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
contract globalVariables{
	function globalVars() external view returns(address,uint,uint) { // view 与 pure 类型都是只读方法，但是 view 可以读取状态变量和全局变量，
		// 而 pure 不可以，只能读取局部变量
		address sender = msg.sender; // 局部变量，调用者的地址
		uint timestamp = block.timestamp; // 区块的时间戳，如果是写入的方法就是出块的时间
		uint blockNum = block.timestamp; // 当前的区块编号
		return (sender, timestamp,blockNum);
	}
}
```

> 编译和部署

在函数测试部分点击`<方法名>`

输出：
```go
0:address: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4  // 当前用户的地址
1:uint256: 1720235746 // 时间戳
2:uint256: 1720235746 // 区块号
```
