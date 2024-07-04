---
title: 第六章 终止和断言
---
[`return`](https://aptos.dev/en/build/smart-contracts/book/functions) 和 `abort` 是两种控制流结构，用于结束执行，一个用于当前函数，一个用于整个事务。

更多关于`return` 的信息可以在 [链接](https://aptos.dev/en/build/smart-contracts/book/functions)部分找到

# 1. `abort`

`abort` 是一个表达式，它接受一个参数：一个 `u64` 类型的**终止代码**。例如：

```rust
abort 42
```

`abort` 表达式会停止当前函数的执行，并回滚当前事务对全局状态所做的所有更改。没有机制来“捕获”或以其他方式处理 `abort`。

幸运的是，在 Move 中，事务是全有或全无的，这意味着只有在事务成功时，才会一次性对全局存储进行任何更改。由于这种事务性的更改规则，在 `abort` 之后，无需担心撤销更改。虽然这种方法缺乏灵活性，但它非常简单且可预测。

与 [`return`](https://aptos.dev/en/build/smart-contracts/book/functions) 类似，`abort` 对于在某些条件无法满足时退出控制流很有用。

在这个示例中，该函数将从向量中弹出两个项目，但如果向量没有两个项目，则会提前终止

```rust
script {
  use std::vector;
  fun pop_twice<T>(v: &mut vector<T>): (T, T) {
      if (vector::length(v) < 2) abort 42;
 
      (vector::pop_back(v), vector::pop_back(v))
  }
}
```

这在控制流结构的内部更有用。例如，这个函数检查向量中的所有数字是否小于指定的 `bound`。否则终止

```rust
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

# 2. `assert`

`assert` 是由 Move 编译器提供的一个内置的、类似宏的操作。它接受两个参数，一个 `bool` 类型的条件和一个 `u64` 类型的代码

```rust
assert!(condition: bool, code: u64)
```

由于该操作是一个宏，它必须使用 `!` 来调用。这是为了表明 `assert` 的参数是按表达式调用的。换句话说，`assert` 不是一个普通的函数，在字节码级别不存在。它在编译器内部被替换为

```rust
if (condition) () else abort code
```

`assert` 比单独使用 `abort` 更常用。上面的 `abort` 示例可以使用 `assert` 重写

```rust
script {
  use std::vector;
  fun pop_twice<T>(v: &mut vector<T>): (T, T) {
      assert!(vector::length(v) >= 2, 42); // Now uses 'assert'
 
      (vector::pop_back(v), vector::pop_back(v))
  }
}
```

和

```rust
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

请注意，由于该操作被替换为这个 `if-else`，`code` 的参数并不总是被计算。例如：

```rust
assert!(true, 1 / 0)
```

不会导致算术错误，它等同于

```rust
if (true) () else (1 / 0)
```

所以算术表达式永远不会被计算！

# 3. Move VM 中的终止代码

当使用 `abort` 时，了解 `u64` 代码将如何被 VM 使用是很重要的。

通常，在成功执行后，Move VM 会为对全局存储所做的更改（添加/删除资源、更新现有资源等）生成一个更改集。

如果达到 `abort`，VM 将指示一个错误。该错误将包括两条信息：

- 产生终止的模块（地址和名称）
- 终止代码。

例如

```rust
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

如果一个事务，例如上面的脚本 `always_aborts`，调用 `0x2::example::aborts`，VM 将产生一个错误，指示模块 `0x2::example` 和代码 `42`。

这对于在一个模块中有多个终止分组在一起很有用。

在这个示例中，模块在多个函数中使用了两个单独的错误代码

```rust
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

# 4. `abort` 的类型

`abort i`表达式可以是任何类型！这是因为这两种结构都打破了正常的控制流，所以它们永远不需要计算出该类型的值。

以下情况没有用处，但它们会通过类型检查

```rust
let y: address = abort 0;
```

这种行为在某些情况下可能会有所帮助，例如您有一个分支指令，在某些分支上产生一个值，但并非所有分支。例如：

```rust
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