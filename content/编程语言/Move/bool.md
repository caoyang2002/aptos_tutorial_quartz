---
title: 布尔
draft: 
aliases:
  - 布尔
date: 2024-07-03
description: move 中的布尔
---
# 布尔

`bool`是布尔`true`和`false`值的Move的原始类型。

## 文字[](https://aptos.guide/en/build/smart-contracts/book/bool#literals)

`bool`的字面字要么是`true`，要么`false`。

## 操作符

### 逻辑操作符

`bool`支持三种逻辑操作：

| 语法   | 描述    | 等效表达式                            |
| ---- | ----- | -------------------------------- |
| `&&` | 短路逻辑和 | `p && q`相当于`if (p) q else false` |
| \|   | 短路逻辑或 | p \| q相当于`if (p) true else q`    |
| `!`  | 逻辑否定  | `!p`相当于`if (p) false else true`  |

### 控制流

`bool`值用于Move的几个控制流结构中：
```rust
if (bool){
	// code
}
while (bool){
	// code
}
assert!(bool, u64)
```

- [`if (bool) { ... }`](https://aptos.guide/en/build/smart-contracts/book/conditionals)
- [`while (bool) { .. }`](https://aptos.guide/en/build/smart-contracts/book/loops)
- [`assert!(bool, u64)`](https://aptos.guide/en/build/smart-contracts/book/abort-and-assert)

## 所有权

与该语言内置的其他标量值一样，布尔值是可隐式复制的，这意味着它们可以在没有明确指令（如[`copy`](https://aptos.guide/en/build/smart-contracts/book/variables#move-and-copy)）的情况下复制。