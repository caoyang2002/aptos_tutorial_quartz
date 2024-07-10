---
title: 第七章 条件语句
aliases:
  - 第七章 条件语句
---

# 条件语句

`if` 表达式指定只有在某个条件为真时才应计算某些代码。例如：

```rust
script {
  fun example() {
    if (x > 5) x = x - 5
  }
}
```

条件必须是 `bool` 类型的表达式。

`if` 表达式可以选择包含一个 `else` 子句，用于指定当条件为假时要计算的另一个表达式。

```rust
script {
  fun example() {
    if (y <= 10) y = y + 1 else y = 10
  }
}
```

要么“真”分支，要么“假”分支将被计算，但不会两者都计算。任何一个分支都可以是单个表达式或表达式块。

条件表达式可能会产生值，以便 `if` 表达式具有结果。

```rust
script {
  fun example() {
    let z = if (x < 100) x else 100;
  }
}
```

真分支和假分支中的表达式必须具有兼容的类型。例如：

```rust
script {
  fun example() {
    // x and y must be u64 integers
    let maximum: u64 = if (x > y) x else y;
 
    // ERROR! branches different types
    let z = if (maximum < 10) 10u8 else 100u64;
 
    // ERROR! branches different types, as default false-branch is () not u64
    if (maximum >= 10) maximum;
  }
}
```

如果未指定 `else` 子句，则假分支默认为单位值。以下是等效的：

```rust
script {
  fun example() {
    if (condition) true_branch // implied default: else ()
    if (condition) true_branch else ()
  }
}
```

通常，[条件语句](https://aptos.dev/en/build/smart-contracts/book/conditionals) 与表达式块结合使用。

```rust
script {
  fun example() {
    let maximum = if (x > y) x else y;
    if (maximum < 10) {
        x = x + 10;
        y = y + 10;
    } else if (x >= 10 && y >= 10) {
        x = x - 10;
        y = y - 10;
    }
  }
}
 
```

## 条件语句的语法

> *if-expression* → **if (** *expression* **)** *expression* *else-clause**opt*

> *else-clause* → **else** *expression*
