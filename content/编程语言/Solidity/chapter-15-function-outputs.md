---
title: 第十五章 函数返回值
---
# 返回方式

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21; 
contract FunctionOutouts{
    function returnMany() public pure returns(uint, bool){ // 公开的函数，内部和外部都可以调用，纯函数，不需要读取状态变量
        return (1,true);
    }
    // 给返回值命名
    function named() public pure returns(uint x, bool b){ 
        return (1,true);
    }
    // 隐式返回
    function assigned() public pure returns (uint x, bool b){
        x = 1;
        b = true;
    }
}
```



# 接受函数返回值

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21; 
contract FunctionOutouts{
    function returnMany() public pure returns(uint, bool){ // 公开的函数，内部和外部都可以调用，纯函数，不需要读取状态变量
        return (1,true);
    }
    // 接受返回值，（解构）
    function destructingAssigments() public pure{
        (uint x,bool b) = returnMany();
    }
    // 只用其中一个，逗号不能删
     function useOneReturn() public pure{
        ( ,bool b) = returnMany();
    }

}
```