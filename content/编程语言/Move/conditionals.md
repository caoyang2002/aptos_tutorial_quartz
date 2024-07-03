---
title: 条件
---
# 条件

`if`表达式指定，只有当某个条件为真时，才应评估某些代码。例如：

```
script {
  fun example() {
    if (x > 5) x = x - 5
  }
}
```

条件必须是`bool`类型的表达式。

An `if` expression can optionally include an `else` clause to specify another expression to evaluate when the condition is false.

```
script {
  fun example() {
    if (y <= 10) y = y + 1 else y = 10
  }
}
```

“真”分支或“假”分支都会被评估，但不会同时评估。任何分支都可以是单个表达式，也可以是表达式块。

条件表达式可以产生值，以便`if`表达式有结果。

```
script {
  fun example() {
    let z = if (x < 100) x else 100;
  }
}
```

真分支和假分支中的表达式必须具有兼容的类型。例如：

```
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

If the `else` clause is not specified, the false branch defaults to the unit value. The following are equivalent:

```
script {
  fun example() {
    if (condition) true_branch // implied default: else ()
    if (condition) true_branch else ()
  }
}
```

通常，[`if`表达式](https://aptos.guide/en/build/smart-contracts/book/conditionals)与表达式块一起使用。

```
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

## 条件语法[](https://aptos.guide/en/build/smart-contracts/book/conditionals#grammar-for-conditionals)

> _if-expression_ → **if (** _expression_ **)** _expression_ _else-clauseopt_

> _else-clause_ → **else** _表达式_