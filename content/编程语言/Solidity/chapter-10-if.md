---
title: 第十章 条件控制
---
# if-else
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21; 
contract condition {
    function myIf(uint x) external pure returns (uint){
        if (x < 10){
            return 1;
        }else if(x < 20){
            return 2;
        }else {
            return 3;
        }
    }
}
```

# 三元控制符

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21; 
contract condition {
    function ternary(uint x) external pure returns (uint){
        return x < 10 ? 1 : 2
    }
}
```


# 案例：累加器
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21; 
contract cycle {
    function loops() external pure {
        for (uint i = 0; i < 10; i++){
            // code
            if(i == 3){
                continue;
            }
            // more code 
            if(i == 9){
                break;
            }
        }
        // while (true){ // 无限循环，
        //     //  code
        // }
        uint j = 0;
        while (j < 10){
            j++;
        }
    }
    function sum(uint _n) external pure returns (uint){ // _n 中的下划线：表示局部变量或者是一个私有变量。这个约定并不是强制性的，但它是一种编程习惯，可以帮助开发者区分变量的作用域
        uint s;
        for(uint i = 1; i <= _n; i++){
            s += i;
        }
        return s;
    }
}
```