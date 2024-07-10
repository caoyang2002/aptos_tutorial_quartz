---
title: 第八章 变量的默认值
---
```solidity 
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21; 
contract counter{
    bool public b; // false 
    uint public u; // 0
    int public i; // 0
    address public a; // 0x0000000000000000000000000000000000000000  40个零
    bytes32 public b32; // 0x0000000000000000000000000000000000000000000000000000000000000000 64个零   
}
```