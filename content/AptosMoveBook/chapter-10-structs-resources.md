---
title: 第十章 结构体和资源
date: 2024-07-04
aliases:
  - 第十章 结构体和资源
tags:
  - MoveOnAptos
---
**结构体**是一种用户定义的数据结构，包含类型化的字段。结构体可以存储任何非引用类型，包括其他结构体。

如果结构体的值不能被复制并且不能被丢弃，我们通常称其为**资源**。在这种情况下，资源值必须在函数结束时转移所有权。这个属性使得资源特别适合用于定义全局存储模式或表示重要值（例如 token）。

默认情况下，结构体是线性和短暂的。这意味着它们：不能被复制，不能被丢弃，并且不能存储在全局存储中。这意味着所有值都必须转移所有权（线性），并且在程序执行结束时必须处理这些值（短暂）。我们可以通过赋予结构体[能力](https://aptos.dev/en/build/smart-contracts/book/abilities)来放宽这种行为，这些能力允许值被复制或丢弃，并且也可以存储在全局存储中或定义全局存储模式。

# 1. 定义结构体

结构体必须在模块内定义：

```rust
module 0x2::m {
    struct Foo { x: u64, y: bool }
    struct Bar {}
    struct Baz { foo: Foo, }
    //                   ^ note: it is fine to have a trailing comma
}
```

> 注意：有一个尾随逗号是可以的

结构体不能是递归的，所以以下定义是无效的：

```rust
module 0x2::m {
  struct Foo { x: Foo }
  //              ^ error! Foo cannot contain Foo
}
```

> 错误！Foo 不可以包含自身（Foo）

如上所述：默认情况下，结构体声明是线性和短暂的。因此，为了允许值与特定操作一起使用（复制它、丢弃它、将其存储在全局存储中或将其用作存储模式），可以通过使用 `has <ability>` 来授予结构体[能力](https://aptos.dev/en/build/smart-contracts/book/abilities)：

```rust
module 0x2::m {
    struct Foo has copy, drop {
        x: u64,
        y: bool
    }
}
```

有关更多详细信息，请参见[标记结构体](https://aptos.dev/en/build/smart-contracts/book/abilities#annotating-structs)部分。

## 1.1 命名

结构体名称必须以大写字母`A`到`Z`开始。在第一个字母之后，结构体名称可以包含下划线`_`、小写字母`a`到`z`、大写字母`A`到`Z`或数字`0`到`9`。

```rust
module 0x2::m {
  struct Foo {}
  struct BAR {}
  struct B_a_z_4_2 {}
}
```

这种以`A`到`Z`开头的命名限制是为了给未来的语言特性留出空间。这个限制以后可能会被移除。

# 2. 使用结构体

## 2.1 创建结构体

可以通过指定结构体名称，然后为每个字段指定值来创建结构体类型的值（或称为“打包”）：

```rust
module 0x2::m {
  struct Foo has drop { x: u64, y: bool }
  struct Baz has drop { foo: Foo }
 
  fun example() {
    let foo = Foo { x: 0, y: false };
    let baz = Baz { foo };
  }
}
```

如果你用与字段同名的局部变量来初始化结构体字段，你可以使用以下简写：

```rust
module 0x2::m {
  fun example() {
    let baz = Baz { foo: foo };
    // is equivalent to
    let baz = Baz { foo };
  }
}
```

这有时被称为“字段名称混用”。

## 2.2 通过模式匹配销毁结构体

可以通过绑定或赋值模式来销毁结构体值。

```rust
module 0x2::m {
  struct Foo { x: u64, y: bool }
  struct Bar { foo: Foo }
  struct Baz {}
 
  fun example_destroy_foo() {
    let foo = Foo { x: 3, y: false };
    let Foo { x, y: foo_y } = foo;
    //        ^ shorthand for `x: x`
 
    // two new bindings
    //   x: u64 = 3
    //   foo_y: bool = false
  }
 
  fun example_destroy_foo_wildcard() {
    let foo = Foo { x: 3, y: false };
    let Foo { x, y: _ } = foo;
 
    // only one new binding since y was bound to a wildcard
    //   x: u64 = 3
  }
 
  fun example_destroy_foo_assignment() {
    let x: u64;
    let y: bool;
    Foo { x, y } = Foo { x: 3, y: false };
 
    // mutating existing variables x & y
    //   x = 3, y = false
  }
 
  fun example_foo_ref() {
    let foo = Foo { x: 3, y: false };
    let Foo { x, y } = &foo;
 
    // two new bindings
    //   x: &u64
    //   y: &bool
  }
 
  fun example_foo_ref_mut() {
    let foo = Foo { x: 3, y: false };
    let Foo { x, y } = &mut foo;
 
    // two new bindings
    //   x: &mut u64
    //   y: &mut bool
  }
 
  fun example_destroy_bar() {
    let bar = Bar { foo: Foo { x: 3, y: false } };
    let Bar { foo: Foo { x, y } } = bar;
    //             ^ nested pattern
 
    // two new bindings
    //   x: u64 = 3
    //   y: bool = false
  }
 
  fun example_destroy_baz() {
    let baz = Baz {};
    let Baz {} = baz;
  }
}
```

## 2.3 借用结构体和字段

`&`和`&mut`运算符可以用来创建对结构体或字段的引用。这些示例包括一些可选的类型注释（例如`: &Foo`），以演示操作的类型。

```rust
module 0x2::m {
  fun example() {
    let foo = Foo { x: 3, y: true };
    let foo_ref: &Foo = &foo;
    let y: bool = foo_ref.y;          // reading a field via a reference to the struct
    let x_ref: &u64 = &foo.x;
 
    let x_ref_mut: &mut u64 = &mut foo.x;
    *x_ref_mut = 42;            // modifying a field via a mutable reference
  }
}
```

可以借用嵌套结构体的内部字段：

```rust
module 0x2::m {
  fun example() {
    let foo = Foo { x: 3, y: true };
    let bar = Bar { foo };
 
    let x_ref = &bar.foo.x;
  }
}
```

也可以通过结构体的引用借用字段：

```rust
module 0x2::m {
  fun example() {
    let foo = Foo { x: 3, y: true };
    let foo_ref = &foo;
    let x_ref = &foo_ref.x;
    // this has the same effect as let x_ref = &foo.x
  }
}
```

## 2.4 读取和写入字段

如果需要读取并复制字段的值，然后可以解引用借用的字段：

```rust
module 0x2::m {
  fun example() {
    let foo = Foo { x: 3, y: true };
    let bar = Bar { foo: copy foo };
    let x: u64 = *&foo.x;
    let y: bool = *&foo.y;
    let foo2: Foo = *&bar.foo;
  }
}
```

如果字段是隐式可复制的，可以使用点运算符读取结构体的字段，而无需任何借用。（只有具有`copy`能力的标量值是隐式可复制的。）

```rust
module 0x2::m {
  fun example() {
    let foo = Foo { x: 3, y: true };
    let x = foo.x;  // x == 3
    let y = foo.y;  // y == true
  }
}
```

点运算符可以链式使用以访问嵌套字段：

```rust
module 0x2::m {
  fun example() {
    let baz = Baz { foo: Foo { x: 3, y: true } };
    let x = baz.foo.x; // x = 3;
  }
}
```

然而，这对于包含非原始类型的字段（如向量或另一个结构体）是不允许的：

```rust
module 0x2::m {
  fun example() {
    let foo = Foo { x: 3, y: true };
    let bar = Bar { foo };
    let foo2: Foo = *&bar.foo;
    let foo3: Foo = bar.foo; // error! must add an explicit copy with *&
  }
}
```

这个设计决策的背后原因是复制一个向量或另一个结构体可能是一个昂贵的操作。对于程序员来说，意识到这个复制并使用显式的语法`*&`让其他人知道这一点是重要的。

此外，从字段中读取，点语法也可以用来修改字段，无论字段是原始类型还是其他结构体。

```rust
module 0x2::m {
  fun example() {
    let foo = Foo { x: 3, y: true };
    foo.x = 42;     // foo = Foo { x: 42, y: true }
    foo.y = !foo.y; // foo = Foo { x: 42, y: false }
    let bar = Bar { foo };            // bar = Bar { foo: Foo { x: 42, y: false } }
    bar.foo.x = 52;                   // bar = Bar { foo: Foo { x: 52, y: false } }
    bar.foo = Foo { x: 62, y: true }; // bar = Bar { foo: Foo { x: 62, y: true } }
  }
}
```

点语法也通过结构体的引用有效：

```rust
module 0x2::m {
  fun example() {
    let foo = Foo { x: 3, y: true };
    let foo_ref = &mut foo;
    foo_ref.x = foo_ref.x + 1;
  }
}
```

## 2.5 特权结构体操作

大多数结构体类型`T`的操作只能在声明`T`的模块内执行：

- 结构体类型只能在定义结构体的模块内创建（“打包”）和销毁（“解包”）。
- 结构体的字段只能在定义结构体的模块内访问。

遵循这些规则，如果你想要在模块外部修改你的结构体，你需要为它们提供公共API。本章末尾包含了一些示例。

然而，结构体*类型*始终对另一个模块或脚本可见：

```rust
// m.move
module 0x2::m {
  struct Foo has drop { x: u64 }
 
  public fun new_foo(): Foo {
    Foo { x: 42 }
  }
}
```

```rust
// n.move
module 0x2::n {
  use 0x2::m;
 
  struct Wrapper has drop {
    foo: m::Foo
  }
 
  fun f1(foo: m::Foo) {
    let x = foo.x;
    //      ^ error! cannot access fields of `foo` here
  }
 
  fun f2() {
    let foo_wrapper = Wrapper { foo: m::new_foo() };
  }
}
```

请注意，结构体没有可见性修饰符（例如`public`或`private`）。

## 2.6 所有权

如[定义结构体](https://aptos.dev/en/build/smart-contracts/book/structs-and-resources#defining-structs)部分所述，结构体默认是线性和短暂的。这意味着它们不能被复制或丢弃。当模拟现实世界资源（如货币）时，这个属性非常有用，因为你不想让货币被复制或在流通中丢失。

```rust
module 0x2::m {
  struct Foo { x: u64 }
 
  public fun copying_resource() {
    let foo = Foo { x: 100 };
    let foo_copy = copy foo; // error! 'copy'-ing requires the 'copy' ability
    let foo_ref = &foo;
    let another_copy = *foo_ref // error! dereference requires the 'copy' ability
  }
 
  public fun destroying_resource1() {
    let foo = Foo { x: 100 };
 
    // error! when the function returns, foo still contains a value.
    // This destruction requires the 'drop' ability
  }
 
  public fun destroying_resource2(f: &mut Foo) {
    *f = Foo { x: 100 } // error!
                        // destroying the old value via a write requires the 'drop' ability
  }
}
```

要修复第二个示例（`fun destroying_resource1`），你需要手动“解包”资源：

```rust
module 0x2::m {
  struct Foo { x: u64 }
 
  public fun destroying_resource1_fixed() {
    let foo = Foo { x: 100 };
    let Foo { x: _ } = foo;
  }
}
```

记住，只有在定义它的模块中才能解构资源。这可以用来在系统中强制执行某些不变量，例如货币的守恒。

如果你的结构体不代表有价值的东西，你可以添加`copy`和`drop`能力，得到一个可能更符合其他编程语言习惯的结构体值：

```rust
module 0x2::m {
  struct Foo has copy, drop { x: u64 }
 
  public fun run() {
    let foo = Foo { x: 100 };
    let foo_copy = copy foo;
    // ^ this code copies foo, whereas `let x = foo` or
    // `let x = move foo` both move foo
 
    let x = foo.x;            // x = 100
    let x_copy = foo_copy.x;  // x = 100
 
    // both foo and foo_copy are implicitly discarded when the function returns
  }
}
```

## 2.7 在全局存储中存储资源

只有具有`key`能力的结构体才能直接保存在[持久全局存储](https://aptos.dev/en/build/smart-contracts/book/global-storage-operators)中。所有存储在这些`key`结构体中的值都必须具有`store`能力。有关更多详细信息，请参见[能力](https://aptos.dev/en/build/smart-contracts/book/abilities)和[全局存储](https://aptos.dev/en/build/smart-contracts/book/global-storage-operators)章节。

## 2.8 示例

这里有两个简短的例子，说明如何使用结构体来表示有价值的数据（在`Coin`的情况下）或更传统的数据（在`Point`和`Circle`的情况下）。

### 2.8.1 示例1：有条件的 Coin

```rust
module 0x2::m {
    // 我们不希望Coin被复制，因为那将是复制这笔“钱”，
    // 所以我们没有给结构体'copy'能力。
    // 同样，我们不希望程序员销毁硬币，所以我们没有给结构体'drop'能力。
    // 然而，我们确实希望模块的用户能够将这个硬币存储在持久的全局存储中，
    // 所以我们授予结构体'store'能力。这个结构体只会在全局存储中的其他资源内部，所以我们没有给结构体'key'能力。
    struct Coin has store {
        value: u64,
    }
    public fun mint(value: u64): Coin {
        // 你可能会想要用某种形式的访问控制来限制这个函数，
        // 以防止任何使用这个模块的人铸造无限数量的硬币。
        Coin {
            value
        }
    }
    public fun withdraw(coin: &mut Coin, amount: u64): Coin {
        assert!(coin.value >= amount, 1000);
        coin.value = coin.value - amount;
        Coin {
            value: amount
        }
    }
    public fun deposit(coin: &mut Coin, other: Coin) {
        let Coin {
            value
        } = other;
        coin.value = coin.value + value;
    }
    public fun split(coin: Coin, amount: u64): (Coin, Coin) {
        let other = withdraw(&mut coin, amount);
        (coin, other)
    }
    public fun merge(coin1: Coin, coin2: Coin): Coin {
        deposit(&mut coin1, coin2);
        coin1
    }
    public fun destroy_zero(coin: Coin) {
        let Coin {
            value
        } = coin;
        assert!(value == 0, 1001);
    }
}
```

### 2.8.2 示例2：有条件的 Geometry

```rust
module 0x2::point {
  struct Point has copy, drop, store {
    x: u64,
    y: u64,
  }
 
  public fun new(x: u64, y: u64): Point {
    Point {
      x, y
    }
  }
 
  public fun x(p: &Point): u64 {
    p.x
  }
 
  public fun y(p: &Point): u64 {
    p.y
  }
 
  fun abs_sub(a: u64, b: u64): u64 {
    if (a < b) {
      b - a
    }
    else {
      a - b
    }
  }
 
  public fun dist_squared(p1: &Point, p2: &Point): u64 {
    let dx = abs_sub(p1.x, p2.x);
    let dy = abs_sub(p1.y, p2.y);
    dx*dx + dy*dy
  }
}
```

```rust
module 0x2::circle {
  use 0x2::point::{Self, Point};
 
  struct Circle has copy, drop, store {
    center: Point,
    radius: u64,
  }
 
  public fun new(center: Point, radius: u64): Circle {
    Circle { center, radius }
  }
 
  public fun overlaps(c1: &Circle, c2: &Circle): bool {
    let dist_squared_value = point::dist_squared(&c1.center, &c2.center);
    let r1 = c1.radius;
    let r2 = c2.radius;
    dist_squared_value <= r1*r1 + 2*r1*r2 + r2*r2
  }
}
```


