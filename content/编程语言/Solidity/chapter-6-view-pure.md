---
title: 第六章 章只读函数
---
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7; 
contract viewPurefunction{
    uint public num;
    function viewFunc() external view returns (uint){ // view 读取状态变量,如果是读取链上信息就必须用 view
        return num;
    }
    function pureFunc() external pure returns (uint){ // 只能读局部变量，或者不读
        return 1;
    }
    function addToNum(uint x) external view returns (uint){ // 读取了链上的信息
        return num + x;
    }
    function add(uint x,uint y)external pure returns (uint){ // 没有读取链上信息
        return x + y;
    }
}
```