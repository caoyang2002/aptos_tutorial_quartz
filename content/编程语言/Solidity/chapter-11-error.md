---
title: 第十一章 错误处理
---
# require
```solidity
function testRequire(uint _i) public pure{
	// require(布尔条件，报错消息字符串); // bool 为 true 才会输出报错信息
	require(_i >= 0, "i >=0");
	// code
}
```

# revert
```solidity
function testRevert(uint _i) public pure{
	if(_i > 1){
		if(_i > 2) {
			if(_i >10){ //执行条件
				revert("i > 10"); // 执行报错
			}
		}
	}
}
```

# assert
```solidity
uint public num = 123;
function testAssert() public view{
	assert(num == 123); // 断言没有报错信息
}
function foo() public {
	num += 1;
}
```


# gas
> 发生错误的时候，状态会回滚，花费的 Gas 费会退还

# 自定义错误

```solidity
function testCustomError(uint i) public pure{
require(i <= 10,"loooooooooooooooooooooooooooooooong error");
}
```


```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21; 
contract myError {
    error MyError(address caller, uint i); // 参数是可选的
    function testCustomError(uint i) public view{
        if (i > 10){
            revert MyError(msg.sender, i);
        }
    }
}
```

