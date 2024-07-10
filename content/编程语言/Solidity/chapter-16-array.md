---
title: 第十六章 数组
---
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21; 
contract Array{
    // 动态数组
    uint[] public nums = [1,2,3]; 
    // 定长数组
    uint[3] public numsFixed = [4,5,6];

    function useArray() external {
        nums.push(4); // [1,2,3,4] 最后的位置增加一个数字
        // 访问数组中的值
        uint x = nums[1]; // 所以从 0 开始
        nums[2] = 7; // [1,2,7,4]
        delete nums[1]; // [1,,0,7,4] 不能删除数组的长度
        //弹出方法删除数组，并减短数组
        nums.pop(); // [1,0,7]
        // 获取数组长度
        uint len = nums.length;

        // 在内存中创建数组 （在内存中不能创建动态数组）
        uint[] memory a = new uint[](5)
        // 不能使用改变长度的方法：a.pop()  a.push()
        // 
        // 根据索引修改值
        a[1] = 123;
    }
    // 返回所有元素
    function returnArray() external view returns(uint[] memory){
        // code 
        return nums
    }
}
```

- `arr.pop()` 弹出最后一个车数组元素
- `arr.push()` 放入元素到数组末尾
- `arr.length` 获取数组长度
- `delete arr[index]` 将置顶索引的数组恢复为默认值

# 删除数组元素

## 移动删除

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21; 
contract ArrayShift{
    uint[] public arr;
    function example() public {
        arr = [1,2,3,4,5,6];
        // delete arr[1];// [1,0,3,4,5,6]
    }
    // 删除元素后，数组元素减少 
    // 删除 2，[1,3,4,5,6]
    function remove(uint _index) public {
        require(_index < arr.length, "index out of bound");
        arr[_index] = arr[arr.length];
        for(uint i = _index; i < arr.length - 1; i++){
            // 移动数组
            arr[i] = arr[i +1];
        }
         arr.pop();
    }

    function test() external {
        arr = [1,2,3,4,5];
        remove(2);
        // [1,2,4,5]
        assert(arr[0] == 1);
        assert(arr[1] == 2);
        assert(arr[2] == 4);
        assert(arr[3] == 5);
        assert(arr.length == 4);

        arr = [1];
        remove(0);
        assert(arr.length == 0);
    }
}
```

	

>[!NOTE] 注意
>这种方法很费 Gas 

>[!ERROR] Gas 不够了
>The transaction has been reverted to the initial state.
Note: The called function should be payable if you send value and the value you send should be less than your current balance.
You may want to cautiously increase the gas limit if the transaction went out of gas.
交易已回滚到初始状态。
注意：如果你发送了价值，被调用的函数应该是可支付的，并且你发送的价值应该小于你当前的余额。
如果交易耗尽了气体，你可能需要谨慎地增加气体限制。



## 替换删除

```solidity

```