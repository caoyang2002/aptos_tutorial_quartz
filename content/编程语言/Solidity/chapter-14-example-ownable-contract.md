---
title: 第十四章 合约实战
---
# 

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21; 
contract Ownable{
    address public owner;
    // 使用构造器初始化 owner
    constructor(){
        owner = msg.sender;
    }
    // 
    modifier onlyOwner(){
        require(msg.sender == owner,"not owner");
        _;
    }
    function setOwner(address _newOwner) external onlyOwner{
        require(_newOwner != address(0),"invalid address");
        owner = _newOwner;
    }
    function onlyOwnerCanCallThisFunc() external onlyOwner{
        // code
    }
    function anyoneCanCall() external {
        // code 
    }
}
```

