---
title: 第十四章 别名
aliases:
  - 第十四章 别名
draft: false
description: Aptos 上 Move 的别名
tags:
  - MoveOnAptos
date: 2024-07-04
---
`use`语法可以用来为其他模块中的成员创建别名。`use`可以用于创建在整个模块中有效或在特定表达式块范围内有效的别名。

# 1. 语法

`use`有几种不同的语法形式。从最简单的开始，我们有以下用于为其他模块创建别名的语法：

```rust
use <address>::<module name>;
use <address>::<module name> as <module alias name>;
```

例如：

```rust
script {
  use std::vector;
  use std::vector as V;
}
```

`use std::vector;`引入了`std::vector`的别名`vector`。这意味着在任何你想要使用模块名`std::vector`的地方（假设这个`use`在作用域内），你可以使用`vector`代替。`use std::vector;`等同于`use std::vector as vector;`

类似地，`use std::vector as V;`将允许你使用`V`代替`std::vector`。

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

如果你想导入特定的模块成员（例如函数、结构体或常量），你可以使用以下语法：

```rust
use <address>::<module name>::<module member>;
use <address>::<module name>::<module member> as <member alias>;
```

例如：

```rust
script {
  use std::vector::empty;
  use std::vector::empty as empty_vec;
}
```

这将允许你使用函数`std::vector::empty`而不需要完全限定名称。相反，你可以分别使用`empty`和`empty_vec`。再次说明，`use std::vector::empty;`等同于`use std::vector::empty as empty;`

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

如果你想一次性为多个模块成员添加别名，你可以使用以下语法：

```rust
use <address>::<module name>::{<module member>, <module member> as <member alias> ... };
```

例如：

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

如果你需要除了模块成员之外为模块本身添加别名，你可以在单个`use`中使用`Self`。`Self`是一种引用模块的成员。

```rust
script {
  use std::vector::{Self, empty};
}
```

为了清晰起见，以下所有都是等价的：

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

如果需要，你可以为任何项目拥有尽可能多的别名。

```rust
module 0x42::example {
  use std::vector::{Self, Self as V, length, length as len};
  fun pop_twice<T>(v: &mut vector<T>): (T, T) {
    // 以上 `use` 给出的所有选项都可用
    assert!(vector::length(v) > 1, 42);
    assert!(V::length(v) > 1, 42);
    assert!(length(v) > 1, 42);
    assert!(len(v) > 1, 42);
    (vector::pop_back(v), vector::pop_back(v))
  }
}
```

#  2. 在 `module` 内部

在一个`module`内部，所有`use`声明都可以使用，无论声明的顺序如何。

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

由`use`声明的别名在该模块内可用。

此外，引入的别名不能与其他模块成员冲突。有关更多详细信息，请参见[唯一性](https://aptos.dev/en/build/smart-contracts/book/uses#uniqueness)。

# 3. 在表达式内部

你可以在任何表达式块的开头添加`use`声明。

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

与`let`一样，在表达式块中引入的别名在该块结束时会被移除。

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

块结束后尝试使用别名将导致错误。

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

任何`use`必须是块中的第一项。如果`use`在任何表达式或`let`之后，它将导致解析错误。

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

# 4. 命名规则

别名必须遵循与其他模块成员相同的规则。这意味着对结构体或常量的别名必须以`A`到`Z`开头。

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
      foo as FOO, // valid
      foo as bar, // valid
    };
  }
}
```

# 4. 唯一性

在给定的作用域内，由`use`声明引入的所有别名必须是唯一的。

对于一个模块，这意味着由`use`引入的别名不能重叠

```rust
module 0x42::example {
  use std::vector::{empty as foo, length as foo}; // ERROR!
  //                                        ^^^ duplicate 'foo'
  use std::vector::empty as bar;
  use std::vector::length as bar; // ERROR!
  //                         ^^^ duplicate 'bar'
}
```

并且，它们不能与模块的其他任何成员重叠

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

在表达式块内，它们不能彼此重叠，但它们可以遮蔽[shadow](https://aptos.dev/en/build/smart-contracts/book/uses#shadowing) 来自外部作用域的其他别名或名称。

# 5. 遮蔽

表达式块内的`use`别名可以遮蔽来自外部作用域的名称（模块成员或别名）。与局部变量的遮蔽一样，遮蔽在表达式块结束时结束。

```rust
module 0x42::example {
  struct WrappedVector {
    vec: vector<u64>
  }
  fun empty(): WrappedVector {
    WrappedVector {
      vec: std::vector::empty()
    }
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

# 6. 未使用的 `use` 或别名

未使用的`use`将导致错误。

```rust
module 0x42::example {
  use std::vector::{empty, push_back}; // ERROR!
  //                       ^^^^^^^^^ unused alias 'push_back'
  fun example(): vector<u8> {
    empty()
  }
}
```

