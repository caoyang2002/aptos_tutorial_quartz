---
title: 第十三章 构造函数
---
# 构建函数

在合约部署的时候调用一次，之后就再也不能调用了，用于初始化变量

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21; 
contract myConstructor{
    address public owner;
    uint public x;
    constructor(uint _x){
        owner = msg.sender;
        x = _x;
    }
}
```

>[!TIP] 提示
>部署的时候需要输出一个参数，这是构造函数的参数

