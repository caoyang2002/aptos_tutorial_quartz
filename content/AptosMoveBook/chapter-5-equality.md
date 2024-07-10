---
title: 第五章 等式判断
aliases:
  - 第五章 等式判断
---

# 相等性

Move 支持两种相等性操作 `==` 和 `!=`

## 操作

| 语法 | 操作 | 描述 |
| ------ | --------- | ------------------------------------------------------------ |
| `==` | 相等 | 如果两个操作数具有相同的值，则返回 `true`，否则返回 `false` |
| `!=` | 不相等 | 如果两个操作数具有不同的值，则返回 `true`，否则返回 `false` |

### 类型

相等（`==`）和不相等（`!=`）操作仅在两个操作数是相同类型时才有效

```rust
script {
  fun example() {
    0 == 0; // `true`
    1u128 == 2u128; // `false`
    b"hello" != x"00"; // `true`
  }
}
```

相等性和非相等性也适用于用户定义的类型！

```rust
module 0x42::example {
    struct S has copy, drop { f: u64, s: vector<u8> }
 
    fun always_true(): bool {
        let s = S { f: 0, s: b"" };
        // parens are not needed but added for clarity in this example
        (copy s) == s
    }
 
    fun always_false(): bool {
        let s = S { f: 0, s: b"" };
        // parens are not needed but added for clarity in this example
        (copy s) != s
    }
}
```

如果操作数具有不同的类型，则会出现类型检查错误

```rust
script {
  fun example() {
    1u8 == 1u128; // ERROR!
    //     ^^^^^ expected an argument of type 'u8'
    b"" != 0; // ERROR!
    //     ^ expected an argument of type 'vector<u8>'
  }
}
```

### 引用的类型

在比较 [引用](https://aptos.dev/en/build/smart-contracts/book/references) 时，引用的类型（不可变或可变）并不重要。这意味着您可以比较具有相同底层类型的不可变 `&` 引用和可变 `&mut` 引用。

```rust
script {
  fun example() {
    let i = &0;
    let m = &mut 1;
 
    i == m; // `false`
    m == i; // `false`
    m == m; // `true`
    i == i; // `true`
  }
}
```

上述等同于在需要时对每个可变引用应用显式冻结

```rust
script {
  fun example() {
    let i = &0;
    let m = &mut 1;
 
    i == freeze(m); // `false`
    freeze(m) == i; // `false`
    m == m; // `true`
    i == i; // `true`
  }
}
```

但同样，底层类型必须是相同类型

```rust
script {
  fun example() {
    let i = &0;
    let s = &b"";
 
    i == s; // ERROR!
    //   ^ expected an argument of type '&u64'
  }
}
```

## 限制

`==` 和 `!=` 在比较值时都会消耗该值。因此，类型系统强制该类型必须具有 [`drop`](https://aptos.dev/en/build/smart-contracts/book/abilities)。回想一下，如果没有 [`drop` 能力](https://aptos.dev/en/build/smart-contracts/book/abilities)，所有权必须在函数结束时转移，并且此类值只能在其声明模块内显式销毁。如果直接使用相等 `==` 或不相等 `!=` 操作，该值将被销毁，这将破坏 [`drop` 能力](https://aptos.dev/en/build/smart-contracts/book/abilities) 的安全保证！

```rust
module 0x42::example {
  struct Coin has store { value: u64 }
  fun invalid(c1: Coin, c2: Coin) {
    c1 == c2 // ERROR!
//  ^^    ^^ These resources would be destroyed!
  }
}
```

但是，程序员可以 *总是* 首先借用该值而不是直接比较该值，并且引用类型具有 [`drop` 能力](https://aptos.dev/en/build/smart-contracts/book/abilities)。例如

```rust
module 0x42::example {
  struct Coin has store { value: u64 }
  fun swap_if_equal(c1: Coin, c2: Coin): (Coin, Coin) {
    let are_equal = &c1 == &c2; // valid
    if (are_equal) (c2, c1) else (c1, c2)
  }
}
```

## 避免额外的复制

虽然程序员 **可以** 比较任何其类型具有 [`drop`](https://aptos.dev/en/build/smart-contracts/book/abilities) 的值，但程序员通常应通过引用进行比较以避免昂贵的复制。

```rust
script {
  fun example() {
    let v1: vector<u8> = function_that_returns_vector();
    let v2: vector<u8> = function_that_returns_vector();
    assert!(copy v1 == copy v2, 42);
    //     ^^^^       ^^^^
    use_two_vectors(v1, v2);
 
    let s1: Foo = function_that_returns_large_struct();
    let s2: Foo = function_that_returns_large_struct();
    assert!(copy s1 == copy s2, 42);
    //     ^^^^       ^^^^
    use_two_foos(s1, s2);
  }
}
```

此代码完全可以接受（假设 `Foo` 具有 [`drop`](https://aptos.dev/en/build/smart-contracts/book/abilities)），只是效率不高。突出显示的复制可以删除并替换为借用

```rust
script {
  fun example() {
    let v1: vector<u8> = function_that_returns_vector();
    let v2: vector<u8> = function_that_returns_vector();
    assert!(&v1 == &v2, 42);
    //     ^      ^
    use_two_vectors(v1, v2);
 
    let s1: Foo = function_that_returns_large_struct();
    let s2: Foo = function_that_returns_large_struct();
    assert!(&s1 == &s2, 42);
    //     ^      ^
    use_two_foos(s1, s2);
  }
}
```

`==` 本身的效率保持不变，但删除了 `copy`，因此程序更高效。
