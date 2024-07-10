---
title: 第七章 计数器实践
---
功能：对一个状态变量进行增加和减少的操作

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21; 
contract counter{
    uint public num; // public 表示内部和外部都可以读取这个值
    function add() external returns (uint){ // 外部可视，合约内部的其他函数不能读取
                                            // 这是一个写入方法（对状态变量更改），所以不能有 view 或 pure，否则不能更改，会冲突
        return num += 1;
    }
    function sub() external  returns (uint){ // 这是一个写入方法，所以不能有 view 或 pure
        if(num == 0){ // 检查变量是否等于零，由于 uint 不能为负数，如果为零再减一会报错
            return 0;
        }
        return num -= 1;
    }
}
```