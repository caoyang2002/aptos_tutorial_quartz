# 平等

移动支持两个相等操作`==`和`!=`

## 运营[](https://aptos.guide/en/build/smart-contracts/book/equality#operations)

|语法|操作|描述|
|---|---|---|
|`==`|平等|如果两个操作数具有相同的值，则返回`true`，否则返回`false`|
|`!=`|不平等|如果两个操作数的值不同，则返回`true`，否则返回`false`|

### 打字[](https://aptos.guide/en/build/smart-contracts/book/equality#typing)

相等（`==`）和不相等（`!=`）只有当两个操作数类型相同时，操作才有效

```
script {
  fun example() {
    0 == 0; // `true`
    1u128 == 2u128; // `false`
    b"hello" != x"00"; // `true`
  }
}
```

平等和非平等也适用于用户定义的类型！

```
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

如果操作数具有不同的类型，则存在类型检查错误

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

### 用参考资料打字[](https://aptos.guide/en/build/smart-contracts/book/equality#typing-with-references)

比较[引用](https://aptos.guide/en/build/smart-contracts/book/references)时，引用的类型（不可变或可变）无关紧要。这意味着您可以将不可变`&`引用与相同底层类型的可变`&mut`进行比较。

```
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

以上等同于在需要时对每个可变引用进行显式冻结

```
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

但同样，底层类型必须是相同的类型

```
script {
  fun example() {
    let i = &0;
    let s = &b"";
 
    i == s; // ERROR!
    //   ^ expected an argument of type '&u64'
  }
}
```

## 限制[](https://aptos.guide/en/build/smart-contracts/book/equality#restrictions)

`==`和`!=`在比较它们时消耗该值。因此，类型系统强制要求类型必须有[`drop`](https://aptos.guide/en/build/smart-contracts/book/abilities)。回想一下，如果没有[`drop`能力](https://aptos.guide/en/build/smart-contracts/book/abilities)，所有权必须在功能结束时转移，并且此类值只能在其声明模块内明确销毁。如果这些直接与平等`==`或非平等一起使用`!=`，该值将被销毁，这将打破[`drop`能力](https://aptos.guide/en/build/smart-contracts/book/abilities)安全保证！

```
module 0x42::example {
  struct Coin has store { value: u64 }
  fun invalid(c1: Coin, c2: Coin) {
    c1 == c2 // ERROR!
//  ^^    ^^ These resources would be destroyed!
  }
}
```

但是，程序员_总是_可以先借用值，而不是直接比较值，并且引用类型具有[`drop`能力](https://aptos.guide/en/build/smart-contracts/book/abilities)。例如

```
module 0x42::example {
  struct Coin has store { value: u64 }
  fun swap_if_equal(c1: Coin, c2: Coin): (Coin, Coin) {
    let are_equal = &c1 == &c2; // valid
    if (are_equal) (c2, c1) else (c1, c2)
  }
}
```

## 避免额外的副本[](https://aptos.guide/en/build/smart-contracts/book/equality#avoid-extra-copies)

虽然程序员_可以_比较任何类型[`drop`](https://aptos.guide/en/build/smart-contracts/book/abilities)的值，但程序员通常应该通过引用进行比较，以避免昂贵的副本。

```
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

这个代码是完全可以接受的（假设`Foo`有[`drop`](https://aptos.guide/en/build/smart-contracts/book/abilities)），只是效率不高。突出显示的副本可以删除并替换为借阅

```
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

`==`本身的效率保持不变，但`copy`被删除，因此程序更有效率。