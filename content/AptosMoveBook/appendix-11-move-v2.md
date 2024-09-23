---
title: move v2
tags:
  - aptos
---
# Aptos Move v2

## 总览

- `Enum Types`
  - 枚举类型增加了在一个可存储类型中定义不同数据布局变体的选项
- `Receiver Style Functions`
  - 接收者风格函数增加了以熟悉的符号 `value.func(arg)` 调用函数的能力。它们在本节中有详细描述
- `Index Notation`
  - 索引符号（Index Notation）允许使用 `&mut vector[index]` 或 `&mut Resource[addr]` 等符号访问向量和资源存储的元素
- `Positional Structs`
  - 位置结构（Positional Structs）允许定义包装类型，例如 `struct Wrapped(u64)`。位置结构在此处有描述。枚举变体也允许是位置结构
- `Dot-dot pattern wildcards`
  - 点点模式通配符（Dot-dot pattern wildcards）使得像 `let Struct{x, ..} = value` 这样的语句可以匹配数据的选择性部分。它们在此处有描述。这些模式也适用于枚举变体
- `Package visibility`
  - 包可见性（Package visibility）允许声明一个函数在包内的任何地方可见，但在包外不可见。友元函数（Friend functions）仍然受支持，尽管包可见性在许多情况下更为合适。作为一种更简洁的符号，包和友元函数可以简单地声明为 `package fun` 或 `friend fun`，而不是较长的 `public(package) fun` 和 `public(friend) fun`。此功能在此处有文档说明。
- `Assert abort code optional`
  - `assert!` 宏现在可以只使用一个参数，即省略中止代码，在这种情况下，将选择默认代码。
- `New Cast Syntax`
  - 直到现在，类型转换必须始终在括号中，例如 `function((x as u256))`。这个要求现在被取消了，类型转换可以作为顶级表达式而不需要括号，例如 `function(x as u256)`。在表达式中仍然需要写 `(x as u64) + (y as u64)`。这同样适用于新的枚举变体测试，例如 `data is VersionedData::V1`

## `Enum Types`

可以通过 `enum` 关键字定义 `Enum Type `

### Enum variants with fields

Rust 中常见的 `Enum`:

```
enum Shape {
    Circle{radius: u64},
    Rectangle{width: u64, height: u64}
}

let data = Shape::Circle{radius: 10};
```

### `Unit variants`

常见的 `Enum`:

```
enum Color {
  Red, Blue, Green
}

let color = Color::Blue;
```

### `Enum with abilities`

`Enum` 与 `Struct` 类似，也可以具有 abilities

```
enum Color has copy, drop, store, key { Red, Blue, Green }
```

带有 `Key` 的 `Enum` 可以 `move_to()` `move_from()` `borrow_global` `borrow_global_mut`

```
enum VersionedData has key {
  V1{name: String}
  V2{name: String, age: u64}
}
```

与 `Struct` 类似， `Enum` 也可以带有泛型

```
enum Result<T> has copy, drop, store {
  Err(u64),
  Ok(T)
}
```

### `Match`

可以使用 `match` 匹配 `enum`

不可变 `Enum`:

```
fun area(self: &Rectangle): u64 {
    match (self) {
        Circle{ radius }           => mul_with_pi(*radius * *radius),
        Rectangle{ width, height } => *width * *height
    }
}
```

可变 `Enum`:

```
fun scale_radius(self: &mut Rectangle, factor:  u64) {
    match (self) {
        Circle{ radius: r } => *r = *r * factor,
        _                 => {} // do nothing if not a Circle
  }
}
```

### `Is`

可以使用 `is` 检查是否是某个值

```
let data: VersionedData;
if (data is VersionedData::V1) { .. }
```

可以用 `|` 同时检查多个值

```
assert!(data is V1 | V2);
```

### Enum 合约升级增加字段

Enum 可以增加字段，但不能减少字段和修改顺序

```
enum VersionedData has key {
  V1{name: String}
}
 
to

enum VersionedData has key {
  V1{name: String}
  V2{name: String, age: u64}
}
```

## `Receiver Style Functions`

使用 `value.func(arg)` 调用函数

```
module 0x42::example {
    struct S {}
 
    fun foo(self: S, x: u64) { /* ... */ }
 
    fun foo_borrow(self: &S, x: u64) { /* ... */ }

    fun foo_borrow_mut(self: &mut S, x: u64) { /* ... */ }
 
    fun example() {
        let s = S {};
        s.foo_borrow(1);
        s.foo_borrow_mut(1);
        s.foo(1);
    }
}
```

## Index Notation

### Vector

使用 `vector` 时用 `[]` 读取变量

| Indexing Syntax   | Vector Operation                           |
| ----------------- | ------------------------------------------ |
| `&v[i]`           | `vector::borrow(&v, i)`                    |
| `&mut v[i]`       | `vector::borrow_mut(&mut v, i)`            |
| `v[i]`            | `*vector::borrow(&v, i)`                   |
| `v[i] = x`        | `*vector::borrow_mut(&mut v, i) = x`       |
| `&v[i].field`     | `&vector::borrow(&v, i).field`             |
| `&mut v[i].field` | `&mut vector::borrow_mut(&mut v, i).field` |
| `v[i].field`      | `vector::borrow(&v, i).field`              |
| `v[i].field = x`  | `vector::borrow_mut(&mut v, i).field = x`  |

## Global

使用 `[]` 替换 `borrow_global` and `borrow_global_mut`

| Indexing Syntax         | Storage Operation                          |
| ----------------------- | ------------------------------------------ |
| `&T[address]`           | `borrow_global<T>(address)`                |
| `&mut T[address]`       | `borrow_global_mut<T>(address)`            |
| `T[address]`            | `*borrow_global<T>(address)`               |
| `T[address] = x`        | `*borrow_global_mut<T>(address) = x`       |
| `&T[address].field`     | `&borrow_global<T>(address).field`         |
| `&mut T[address].field` | `&mut borrow_global_mut<T>(address).field` |
| `T[address].field`      | `borrow_global<T>(address).field`          |
| `T[address].field = x`  | `borrow_global_mut<T>(address).field = x`  |

## Positional Structs

### Tuple struct

支持创建元组结构体

```
module 0x2::m {
    struct Pair(u64, u8) has copy, drop;

    fun work() {
        let value = Pair(1, true);
        assert!( value.0 == 1 && value.1 == true );
        let Pair(number, boolean) = value;
        assert!(number == 1 && boolean == true);
    }
}
```

### Pure Type Struct

纯类型结构体

```
module 0x2::m {
  struct TypeTag has copy, drop;
}
```

### Rest field pattern

支持解构剩余字段

```
module 0x2::m {
  struct Foo{ x: u8, y: u16, z: u32 }
  struct Bar(u8, u16, u32);
  
  fun foo_get_x(self: &Foo): u16 { 
    let Foo{y, ..} = self;
    x
  }
  
  fun bar_get_0(self: &Foo): u8 { 
    let Bar(x, ..) = self;
    x
  }
  
  fun bar_get_2(self: &Foo): u52 { 
    // For positional structs, one can also put the 
    // .. at the beginning.
    let Bar(.., z) = self;
    z
  }
}
```

## Package visibility

支持代码包的可见的关键字，如下 `foo` 可以在当前 package 任意模块中调用

```
module 0x42::m {
  package fun foo(): u64 { 0 }
}
 
module 0x42::other {
  fun calls_m_foo(): u64 {
    0x42::m::foo() // valid
  }
}
```

## Assert!

新增 `assert!` 宏定义，支持自定义 `abort code` 和默认 `code = 0xCA26CBD9BE0B0000`

```
assert!(condition: bool, code: u64)
assert!(condition: bool) // Since Move 2.0
```

## New Cast Syntax

强制类型转换无需外加 `()`

```
module 0x42::m {
    fun foo(i: u128): u64 { 0 }

    fun test(){
        let a: u64 = 10;
        
        foo( ( a as u128 ) );   // Old
        foo( a as u128 );       // Since Move 2.0
    }
}
```

- 