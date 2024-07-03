---
title: 用途和别名
---
# 用途和别名

`use`语法可用于为其他模块中的成员创建别名。可用于创建适用于整个模块或给定表达式块范围的别名。

## 语法[](https://aptos.guide/en/build/smart-contracts/book/uses#syntax)

有几种不同的语法情况`use`。从最简单的开始，我们有以下内容用于创建其他模块的别名

```
use <address>::<module name>;
use <address>::<module name> as <module alias name>;
```

例如

```
script {
  use std::vector;
  use std::vector as V;
}
```

`use std::vector;`引入`std::vector`的别名`vector`。这意味着，在任何你想使用模块名称`std::vector`（假设这种`use`在范围内），你可以使用`vector`。`use std::vector;`等同于`use std::vector as vector;`

同样`use std::vector as V;`将允许您使用`V`而不是`std::vector`

```rust
module 0x42::example {
  use std::vector;
  use std::vector as V;
 
  fun new_vecs(): (vector<u8>, vector<u8>, vector<u8>) {
    let v1 = std::vector::empty();
    let v2 = vector::empty();
    let v3 = V::empty();
    (v1, v2, v3)
  }
}
```

如果您想导入特定的模块成员（例如函数、结构或常量）。您可以使用以下语法。

```rust
use <address>::<module name>::<module member>;
use <address>::<module name>::<module member> as <member alias>;
```

例如

```rust
script {
  use std::vector::empty;
  use std::vector::empty as empty_vec;
}
```

这将允许您在没有完全限定的情况下使用`std::vector::empty`函数。相反，您可以分别使用`empty`和`empty_vec`。同样，`use std::vector::empty;`等同于`use std::vector::empty as empty;`

```rust
module 0x42::example {
  use std::vector::empty;
  use std::vector::empty as empty_vec;
 
  fun new_vecs(): (vector<u8>, vector<u8>, vector<u8>) {
    let v1 = std::vector::empty();
    let v2 = empty();
    let v3 = empty_vec();
    (v1, v2, v3)
  }
}
```

如果您想一次为多个模块成员添加别名，您可以使用以下语法进行操作

```
use <address>::<module name>::{<module member>, <module member> as <member alias> ... };
```

例如

```rust
module 0x42::example {
  use std::vector::{push_back, length as len, pop_back};
 
  fun swap_last_two<T>(v: &mut vector<T>) {
    assert!(len(v) >= 2, 42);
    let last = pop_back(v);
    let second_to_last = pop_back(v);
    push_back(v, last);
    push_back(v, second_to_last)
  }
}
```

如果您需要在模块成员之外向模块本身添加别名，您可以使用`Self`一次性完成。`Self`是指模块的成员。

```rust
script {
  use std::vector::{Self, empty};
}
```

为明确起见，以下所有内容都是等价的：

```rust
script {
  use std::vector;
  use std::vector as vector;
  use std::vector::Self;
  use std::vector::Self as vector;
  use std::vector::{Self};
  use std::vector::{Self as vector};
}
```

如果需要，您可以为任何项目提供任意数量的别名

```rust
module 0x42::example {
  use std::vector::{
    Self,
    Self as V,
    length,
    length as len,
  };
 
  fun pop_twice<T>(v: &mut vector<T>): (T, T) {
    // all options available given the `use` above
    assert!(vector::length(v) > 1, 42);
    assert!(V::length(v) > 1, 42);
    assert!(length(v) > 1, 42);
    assert!(len(v) > 1, 42);
 
    (vector::pop_back(v), vector::pop_back(v))
  }
}
```

## 在里面`module`[](https://aptos.guide/en/build/smart-contracts/book/uses#inside-a-module)

在`module`中，无论声明的顺序如何，所有`use`声明都是可用的。

```rust
module 0x42::example {
  use std::vector;
 
  fun example(): vector<u8> {
    let v = empty();
    vector::push_back(&mut v, 0);
    vector::push_back(&mut v, 10);
    v
  }
 
  use std::vector::empty;
}
```

在模块中声明的别名，可在该模块内使用。

此外，引入的别名不能与其他模块成员冲突。有关更多详细信息，请参阅[独特性](https://aptos.guide/en/build/smart-contracts/book/uses#uniqueness)

## 在一个表情里面[](https://aptos.guide/en/build/smart-contracts/book/uses#inside-an-expression)

您可以在任何表达式块的开头添加`use`声明

```rust
module 0x42::example {
 
  fun example(): vector<u8> {
    use std::vector::{empty, push_back};
 
    let v = empty();
    push_back(&mut v, 0);
    push_back(&mut v, 10);
    v
  }
}
```

与`let`一样，在表达式块`use`引入的别名在该块末尾被删除。

```rust
module 0x42::example {
 
  fun example(): vector<u8> {
    let result = {
      use std::vector::{empty, push_back};
      let v = empty();
      push_back(&mut v, 0);
      push_back(&mut v, 10);
      v
    };
    result
  }
}
```

在块结束后尝试使用别名将导致错误

```rust
module 0x42::example {
  fun example(): vector<u8> {
    let result = {
      use std::vector::{empty, push_back};
      let v = empty();
      push_back(&mut v, 0);
      push_back(&mut v, 10);
      v
    };
    let v2 = empty(); // ERROR!
//           ^^^^^ unbound function 'empty'
    result
  }
}
```

任何`use`都必须是块中的第一个项目。如果`use`是在任何表达式或`let`之后，将导致解析错误

```rust
script {
  fun example() {
    {
      let x = 0;
      use std::vector; // ERROR!
      let v = vector::empty();
    }
  }
}
 
```

## 命名规则[](https://aptos.guide/en/build/smart-contracts/book/uses#naming-rules)

别名必须遵循与其他模块成员相同的规则。这意味着结构或常量的别名必须以`A`开头`Z`

```rust
address 0x42 {
  module data {
    struct S {}
    const FLAG: bool = false;
    fun foo() {}
  }
  module example {
    use 0x42::data::{
      S as s, // ERROR!
      FLAG as fLAG, // ERROR!
      foo as FOO,  // valid
      foo as bar, // valid
    };
  }
}
```

## 独特性[](https://aptos.guide/en/build/smart-contracts/book/uses#uniqueness)

在给定范围内，`use`声明引入的所有别名必须是唯一的。

对于一个模块，这意味着`use`引入的别名不能重叠

```rust
module 0x42::example {
  use std::vector::{empty as foo, length as foo}; // ERROR!
  //                                        ^^^ duplicate 'foo'
 
  use std::vector::empty as bar;
  use std::vector::length as bar; // ERROR!
  //                         ^^^ duplicate 'bar'
}
```

而且，它们不能与模块的任何其他成员重叠

```rust
address 0x42 {
  module data {
    struct S {}
  }
  module example {
    use 0x42::data::S;
 
    struct S { value: u64 } // ERROR!
    //     ^ conflicts with alias 'S' above
  }
}
```

在表达式块内，它们不能相互重叠，但它们可以从外部范围中[阴影](https://aptos.guide/en/build/smart-contracts/book/uses#shadowing)其他别名或名称

## 阴影[](https://aptos.guide/en/build/smart-contracts/book/uses#shadowing)

`use`表达式块内的别名可以从外部范围中隐藏名称（模块成员或别名）。与本地人的阴影一样，阴影在表达式块的末尾结束；

```rust
module 0x42::example {
 
  struct WrappedVector { vec: vector<u64> }
 
  fun empty(): WrappedVector {
    WrappedVector { vec: std::vector::empty() }
  }
 
  fun example1(): (WrappedVector, WrappedVector) {
    let vec = {
      use std::vector::{empty, push_back};
      // 'empty' now refers to std::vector::empty
 
      let v = empty();
      push_back(&mut v, 0);
      push_back(&mut v, 1);
      push_back(&mut v, 10);
      v
    };
    // 'empty' now refers to Self::empty
 
    (empty(), WrappedVector { vec })
  }
 
  fun example2(): (WrappedVector, WrappedVector) {
    use std::vector::{empty, push_back};
    let w: WrappedVector = {
      use 0x42::example::empty;
      empty()
    };
    push_back(&mut w.vec, 0);
    push_back(&mut w.vec, 1);
    push_back(&mut w.vec, 10);
 
    let vec = empty();
    push_back(&mut vec, 0);
    push_back(&mut vec, 1);
    push_back(&mut vec, 10);
 
    (w, WrappedVector { vec })
  }
}
```

## 未使用的用途或别名[](https://aptos.guide/en/build/smart-contracts/book/uses#unused-use-or-alias)

未使用`use`将导致错误

```rust
module 0x42::example {
  use std::vector::{empty, push_back}; // ERROR!
  //                       ^^^^^^^^^ unused alias 'push_back'
 
  fun example(): vector<u8> {
    empty()
  }
}
```