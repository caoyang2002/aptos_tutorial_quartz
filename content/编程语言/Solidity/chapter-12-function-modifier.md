---
title: 第十二章 函数修改器
---
# 基础语法

## 原始函数
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21; 
contract functionModifier{
    bool public paused;
    uint public count;
    function setPause(bool _paused) external {
        paused = _paused;
    }
    function inc() external {
        require(!paused,"paused"); // 重复代码
        count += 1;
    }
    function dec() external {
        require(!paused,"paused"); // 重复代码
        count -= 1;
    }
}
```

## 使用函数修改器

```solidity
// 使用函数修改器

modifier whenNotPaused(){

require(!paused,"paused");

_; // 调用这个方法的方法体中的代码运行的地方，这里表示在先运行 require 再运行其他的方法

}
```

## 完整代码

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21; 
contract functionModifier{
    bool public paused;
    uint public count;
    function setPause(bool _paused) external {
        paused = _paused;
    }

    // 使用函数修改器
    modifier whenNotPaused(){
        require(!paused,"paused");
        _; // 调用这个方法的方法体中的代码运行的地方，这里表示在先运行 require 再运行其他的方法
    }

    function inc() external whenNotPaused{ // 由于 _; 在后，所以会先进入修改器
        require(!paused,"paused");
        count += 1;
    }
    function dec() external whenNotPaused{ // 同上  
        count -= 1;
    }
}
```


# 输入

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21; 
contract functionModifier{
    bool public paused;
    uint public count;


    modifier cap(uint _x){
        require(_x < 100,"x >= 100");
        _;
    }
    function incBy(uint _x) external cap(_x){
        count += _x;
    }
}
```

# 三明治

函数中的其他代码加在修改器的中间运行

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21; 
contract functionModifier{
    bool public paused;
    uint public count;

    modifier sandwich(){
        // code 
        count += 10;
        _;
        // more code 
        count *= 2;
    }
    function foo() external sandwich(){
        count += 1;
    }
}
```