---
title: 算法
---

> 参考：
>
> [LeetCode Wiki](https://doocs.github.io/leetcode/)

# 目录

- [[两数之和]]

    > 最优解法：使用 hash 表，遍历右侧元素 `diff = target-nums[i]`，检查 `diff` 是否在 hash 表中，如果不在，就算加入`num[i]` 和索引；如果在，就返回索引，时间复杂度 $O(n)$
    >
    > 解法二：对于每个元素 `nums[i]`，遍历右侧元素是否存在 `target-nums[i]`。时间复杂度 $O(n^2)$
    >
    > 解法三：先对数组排序，然后双指针分别指向数组开头和结尾，两元素相加，若`sum > target`，则右指针左移，若 `sum < target`，则左指针右移，直至找到答案。时间复杂度取决于排序方法
    
- [[两数相加]]
