---
title: 结构体和资源
draft: 
aliases:
  - 结构体和资源
---

# 结构和资源

**结构**是包含类型字段的用户定义数据结构。结构可以存储任何非引用类型，包括其他结构。

如果结构值无法复制且无法删除，我们经常将其称为_资源_。在这种情况下，资源值必须在功能结束时转移所有权。此属性使资源特别适合定义全局存储模式或表示重要值（如令牌）。

默认情况下，结构是线性和短暂的。我们的意思是，它们：不能被复制，不能被删除，也不能存储在全局存储中。这意味着所有值都必须转移所有权（线性），并且值必须在程序执行结束时处理（临时）。我们可以通过提供结构[能力](https://aptos.guide/en/build/smart-contracts/book/abilities)来放松这种行为，这些结构能力允许复制或丢弃值，也可以存储在全局存储中或定义全局存储模式。

## 定义结构[](https://aptos.guide/en/build/smart-contracts/book/structs-and-resources#defining-structs)

结构必须在模块内定义：

```rust
module 0x2::m {
    struct Foo { x: u64, y: bool }
    struct Bar {}
    struct Baz { foo: Foo, }
    //                   ^ note: it is fine to have a trailing comma
}
```

结构不能是递归的，因此以下定义无效：

```rust
module 0x2::m {
  struct Foo { x: Foo }
  //              ^ error! Foo cannot contain Foo
}
```

如上所述：默认情况下，结构声明是线性和短暂的。因此，为了允许该值用于某些操作（复制它，丢弃它，将其存储在全局存储中，或将其用作存储模式），可以通过注释`has <ability>`来授予结构[的能力](https://aptos.guide/en/build/smart-contracts/book/abilities)：

```
module 0x2::m {
  struct Foo has copy, drop { x: u64, y: bool }
}
```

有关更多详细信息，请参阅[注释结构](https://aptos.guide/en/build/smart-contracts/book/abilities#annotating-structs)部分。

### 命名[](https://aptos.guide/en/build/smart-contracts/book/structs-and-resources#naming)

结构必须以大写字母`A`到`Z`开头。在第一个字母之后，结构名称可以包含下划线`_`、字母`a`到`z`、字母`A`到`Z`或数字`0`到9。

```
module 0x2::m {
  struct Foo {}
  struct BAR {}
  struct B_a_z_4_2 {}
}
```

这种从`A`到`Z`开头的命名限制已经到位，为未来的语言功能提供了空间。稍后可能会删除，也可能不会删除。

## 使用结构[](https://aptos.guide/en/build/smart-contracts/book/structs-and-resources#using-structs)

### 创建结构[](https://aptos.guide/en/build/smart-contracts/book/structs-and-resources#creating-structs)

可以通过指示结构名称来创建（或“打包”）结构类型的值，后跟每个字段的值：

```
module 0x2::m {
  struct Foo has drop { x: u64, y: bool }
  struct Baz has drop { foo: Foo }
 
  fun example() {
    let foo = Foo { x: 0, y: false };
    let baz = Baz { foo };
  }
}
```

如果您使用名称与字段相同的局部变量初始化结构字段，您可以使用以下速记：

```
module 0x2::m {
  fun example() {
    let baz = Baz { foo: foo };
    // is equivalent to
    let baz = Baz { foo };
  }
}
```

这有时被称为“字段名称双关语”。

### 通过模式匹配破坏结构[](https://aptos.guide/en/build/smart-contracts/book/structs-and-resources#destroying-structs-via-pattern-matching)

可以通过绑定或分配模式来销毁结构值。

```
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

### 借用结构和字段[](https://aptos.guide/en/build/smart-contracts/book/structs-and-resources#borrowing-structs-and-fields)

`&`和`&mut`运算符可用于创建对结构或字段的引用。这些示例包括一些可选类型注释（例如`: &Foo`）来演示操作的类型。

```
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

可以借用嵌套结构的内部字段：

```
module 0x2::m {
  fun example() {
    let foo = Foo { x: 3, y: true };
    let bar = Bar { foo };
 
    let x_ref = &bar.foo.x;
  }
}
```

您也可以通过引用结构来借用字段：

```
module 0x2::m {
  fun example() {
    let foo = Foo { x: 3, y: true };
    let foo_ref = &foo;
    let x_ref = &foo_ref.x;
    // this has the same effect as let x_ref = &foo.x
  }
}
```

### 阅读和写作领域[](https://aptos.guide/en/build/smart-contracts/book/structs-and-resources#reading-and-writing-fields)

如果您需要读取和复制字段的值，则可以取消引用借入的字段：

```
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

如果该字段是隐式可复制的，点运算符可用于读取结构的字段，而无需任何借用。（只有具有`copy`能力的标量值才能隐式复制。）

```
module 0x2::m {
  fun example() {
    let foo = Foo { x: 3, y: true };
    let x = foo.x;  // x == 3
    let y = foo.y;  // y == true
  }
}
```

点运算符可以链接以访问嵌套字段：

```
module 0x2::m {
  fun example() {
    let baz = Baz { foo: Foo { x: 3, y: true } };
    let x = baz.foo.x; // x = 3;
  }
}
```

然而，对于包含非原始类型的字段，例如向量或其他结构，这是不允许的：

```
module 0x2::m {
  fun example() {
    let foo = Foo { x: 3, y: true };
    let bar = Bar { foo };
    let foo2: Foo = *&bar.foo;
    let foo3: Foo = bar.foo; // error! must add an explicit copy with *&
  }
}
```

这个设计决定背后的原因是，复制矢量或其他结构可能是一个昂贵的操作。对于程序员来说，重要的是要意识到这个副本，并让其他人知道显式语法`*&`。

此外，从字段读取，点语法可用于修改字段，无论该字段是原始类型还是其他结构。

```
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

点语法也通过对结构的引用工作：

```
module 0x2::m {
  fun example() {
    let foo = Foo { x: 3, y: true };
    let foo_ref = &mut foo;
    foo_ref.x = foo_ref.x + 1;
  }
}
```

## 特权结构操作[](https://aptos.guide/en/build/smart-contracts/book/structs-and-resources#privileged-struct-operations)

结构类型`T`上的大多数结构操作只能在声明`T`的模块内执行：

- 结构类型只能在定义结构的模块内创建（“打包”），销毁（“未打包”）。
- 结构的字段只能在定义结构的模块内访问。

遵循这些规则，如果您想在模块之外修改结构，则需要为它们提供公共API。本章末尾包含一些这方面的例子。

然而，结构_类型_始终对另一个模块或脚本可见：

```
// m.move
module 0x2::m {
  struct Foo has drop { x: u64 }
 
  public fun new_foo(): Foo {
    Foo { x: 42 }
  }
}
```

```
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

请注意，结构没有可见性修饰符（例如，`public`或`private`）。

## 所有权[](https://aptos.guide/en/build/smart-contracts/book/structs-and-resources#ownership)

如上所述，在[定义结构中](https://aptos.guide/en/build/smart-contracts/book/structs-and-resources#defining-structs)，结构默认为线性和短暂的。这意味着它们不能被复制或丢弃。在模拟金钱等现实世界资源时，此属性非常有用，因为您不希望金钱被复制或丢失在流通中。

```
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

要修复第二个示例（`fun destroying_resource1`），您需要手动“解压”资源：

```
module 0x2::m {
  struct Foo { x: u64 }
 
  public fun destroying_resource1_fixed() {
    let foo = Foo { x: 100 };
    let Foo { x: _ } = foo;
  }
}
```

回想一下，您只能在定义它的模块中解构资源。这可以用来强制执行系统中的某些不变因素，例如货币的保存。

另一方面，如果您的结构不代表有价值的东西，您可以添加功能`copy`和`drop`，以获得可能从其他编程语言中感觉更熟悉的结构值：

```
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

## 在全球存储中存储资源[](https://aptos.guide/en/build/smart-contracts/book/structs-and-resources#storing-resources-in-global-storage)

只有具有`key`能力的结构才能直接保存在[持久全局存储中](https://aptos.guide/en/build/smart-contracts/book/global-storage-operators)。存储在这些`key`结构中的所有值都必须具有`store`能力。有关更多详细信息，请参阅能力和[全局存储](https://aptos.guide/en/build/smart-contracts/book/global-storage-operators)章节。

## 实例[](https://aptos.guide/en/build/smart-contracts/book/structs-and-resources#examples)

以下是两个简短的示例，说明如何使用结构来表示有价值的数据（在`Coin`的情况下）或更经典的数据（在`Point`和`Circle`的情况下）。

### 示例1：硬币[](https://aptos.guide/en/build/smart-contracts/book/structs-and-resources#example-1-coin)

```
module 0x2::m {
  // We do not want the Coin to be copied because that would be duplicating this "money",
  // so we do not give the struct the 'copy' ability.
  // Similarly, we do not want programmers to destroy coins, so we do not give the struct the
  // 'drop' ability.
  // However, we *want* users of the modules to be able to store this coin in persistent global
  // storage, so we grant the struct the 'store' ability. This struct will only be inside of
  // other resources inside of global storage, so we do not give the struct the 'key' ability.
  struct Coin has store {
    value: u64,
  }
 
  public fun mint(value: u64): Coin {
    // You would want to gate this function with some form of access control to prevent
    // anyone using this module from minting an infinite amount of coins.
    Coin { value }
  }
 
  public fun withdraw(coin: &mut Coin, amount: u64): Coin {
    assert!(coin.balance >= amount, 1000);
    coin.value = coin.value - amount;
    Coin { value: amount }
  }
 
  public fun deposit(coin: &mut Coin, other: Coin) {
    let Coin { value } = other;
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
    let Coin { value } = coin;
    assert!(value == 0, 1001);
  }
}
```

### 示例2：几何[](https://aptos.guide/en/build/smart-contracts/book/structs-and-resources#example-2-geometry)

```
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

```
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