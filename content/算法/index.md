---
title: 算法
---

> 参考：
>
> [LeetCode Wiki](https://doocs.github.io/leetcode/)

[toc]



# 目录

- [[两数之和]]

    > 最优解法：hash 表
    >
    > 解法一：对于每个元素nums[i]，遍历右侧元素是否存在target-nums[i]。时间复杂度o(n^2)
    > 解法二：先对数组排序，然后双指针分别指向数组开头和结尾，两元素相加，若和>target，则右指针左移，若和<target，则左指针右移，直至找到答案。时间复杂度取决于排序方法
