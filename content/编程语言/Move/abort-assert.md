---
title: 中止和断言
---
# 中止和断言

[`return`](https://aptos.guide/en/build/smart-contracts/book/functions)和`abort`是结束执行的两个控制流构造，一个用于当前函数，一个用于整个事务。

有关[`return`](https://aptos.guide/en/build/smart-contracts/book/functions)的更多信息[可以在链接部分找到](https://aptos.guide/en/build/smart-contracts/book/functions)

## `abort`[](https://aptos.guide/en/build/smart-contracts/book/abort-and-assert#abort)

`abort`是一个接受一个参数的表达式：`u64`类型的**中止代码**。例如：

```
abort 42
```

`abort`表达式停止当前函数的执行，并恢复当前事务对全局状态所做的所有更改。没有“捕获”或以其他方式处理`abort`的机制。

幸运的是，在Move中，交易要么全有，要么全无，这意味着只有当事务成功时，才会一次性对全局存储进行任何更改。由于这种更改的交易承诺，在中止后，无需担心会退回更改。虽然这种方法缺乏灵活性，但它非常简单和可预测。

与[`return`](https://aptos.guide/en/build/smart-contracts/book/functions)类似，当某些条件无法满足时`abort`对于退出控制流很有用。

在本例中，该函数将从向量中弹出两个项目，但如果向量没有两个项目，则会提前中止

```
script {
  use std::vector;
  fun pop_twice<T>(v: &mut vector<T>): (T, T) {
      if (vector::length(v) < 2) abort 42;
 
      (vector::pop_back(v), vector::pop_back(v))
  }
}
```

这在控制流结构的深处甚至更有用。例如，该函数检查向量中的所有数字都小于指定的`bound`。否则会流产

```
script {
  use std::vector;
  fun check_vec(v: &vector<u64>, bound: u64) {
      let i = 0;
      let n = vector::length(v);
      while (i < n) {
          let cur = *vector::borrow(v, i);
          if (cur > bound) abort 42;
          i = i + 1;
      }
  }
}
```

### `assert`[](https://aptos.guide/en/build/smart-contracts/book/abort-and-assert#assert)

`assert`是由Move编译器提供的内置的类似宏的操作。它需要两个参数，一个是`bool`类型的条件，一个是类型的代码`u64`

```
assert!(condition: bool, code: u64)
```

由于操作是宏，因此必须用`!`调用它。这是为了传达要`assert`的参数是按表达式调用的。换句话说，`assert`不是一个正常函数，在字节码级别不存在。它在编译器内部被替换为

```
if (condition) () else abort code
```

`assert`比单独`abort`更常用。上面的`abort`示例可以使用`assert`

```
script {
  use std::vector;
  fun pop_twice<T>(v: &mut vector<T>): (T, T) {
      assert!(vector::length(v) >= 2, 42); // Now uses 'assert'
 
      (vector::pop_back(v), vector::pop_back(v))
  }
}
```

和

```
script {
  use std::vector;
  fun check_vec(v: &vector<u64>, bound: u64) {
      let i = 0;
      let n = vector::length(v);
      while (i < n) {
          let cur = *vector::borrow(v, i);
          assert!(cur <= bound, 42); // Now uses 'assert'
          i = i + 1;
      }
  }
}
```

请注意，由于操作被替换为这个`if-else`，因此`code`的参数并不总是被计算。例如：

```
assert!(true, 1 / 0)
```

不会导致算术错误，它相当于

```
if (true) () else (1 / 0)
```

所以算术表达式永远不会被评估！

### 在Move VM中中止代码[](https://aptos.guide/en/build/smart-contracts/book/abort-and-assert#abort-codes-in-the-move-vm)

使用`abort`时，了解虚拟机将如何使用`u64`代码很重要。

通常，在成功执行后，Move VM为全局存储所做的更改（添加/删除资源、现有资源的更新等）生成一个更改集。

如果达到`abort`，虚拟机将指示错误。该错误将包括两条信息：

- 产生中止的模块（地址和名称）
- 中止代码。

例如

```
module 0x42::example {
  public fun aborts() {
    abort 42
  }
}
 
script {
  fun always_aborts() {
    0x2::example::aborts()
  }
}
```

如果一个事务，如上面的脚本 `always_aborts`，调用`0x2::example::aborts`，虚拟机将产生一个错误，指示模块`0x2::example`和代码`42`。

这对于在模块内将多个中止分组在一起很有用。

在本例中，该模块有两个单独的错误代码，用于多个函数

```
module 0x42::example {
 
  use std::vector;
 
  const EMPTY_VECTOR: u64 = 0;
  const INDEX_OUT_OF_BOUNDS: u64 = 1;
 
  // move i to j, move j to k, move k to i
  public fun rotate_three<T>(v: &mut vector<T>, i: u64, j: u64, k: u64) {
    let n = vector::length(v);
    assert!(n > 0, EMPTY_VECTOR);
    assert!(i < n, INDEX_OUT_OF_BOUNDS);
    assert!(j < n, INDEX_OUT_OF_BOUNDS);
    assert!(k < n, INDEX_OUT_OF_BOUNDS);
 
    vector::swap(v, i, k);
    vector::swap(v, j, k);
  }
 
  public fun remove_twice<T>(v: &mut vector<T>, i: u64, j: u64): (T, T) {
    let n = vector::length(v);
    assert!(n > 0, EMPTY_VECTOR);
    assert!(i < n, INDEX_OUT_OF_BOUNDS);
    assert!(j < n, INDEX_OUT_OF_BOUNDS);
    assert!(i > j, INDEX_OUT_OF_BOUNDS);
 
    (vector::remove<T>(v, i), vector::remove<T>(v, j))
  }
}
```

## 类型`abort`[](https://aptos.guide/en/build/smart-contracts/book/abort-and-assert#the-type-of-abort)

`abort i`表达式可以有任何类型！这是因为两个结构都打破了正常的控制流，因此它们永远不需要评估该类型的值。

以下内容没有用，但他们会键入检查

```
let y: address = abort 0;
```

在您有分支指令在某些分支上产生值（但不是所有分支）的情况下，这种行为可能会有所帮助。例如：

```
script {
  fun example() {
    let b =
        if (x == 0) false
        else if (x == 1) true
        else abort 42;
    //       ^^^^^^^^ `abort 42` has type `bool`
  }
}
```