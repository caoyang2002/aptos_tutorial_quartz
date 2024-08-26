---
title: 第十五章 友元
aliases:
  - 第十五章 友元
tags:
  - MoveOnAptos
---
# 友元

`friend` 语法用于声明当前模块信任的模块。受信任的模块被允许调用当前模块中标记为`public(friend)` 可见性的任何函数。有关函数可见性的详细信息，请参阅[函数](https://aptos.dev/en/build/smart-contracts/book/functions)中的**可见性**部分。

## 友元声明

模块可以通过友元声明语句将其他模块声明为友元，格式如下：

- `friend <address::name>` — 使用完全限定的模块名称进行友元声明，如下例所示，或者

```rust
module 0x42::a {
    friend 0x42::b;
}
```

- `friend <module-name-alias>` — 使用模块名称别名进行友元声明，其中模块别名是通过`use`语句引入的。

```rust
module 0x42::a {
    use 0x42::b;
    friend b;
}
```

一个模块可以有多个友元声明，所有友元模块的并集形成友元列表。在下面的例子中，`0x42::B`和`0x42::C`都被视为`0x42::A`的友元。

```rust
module 0x42::a {
    friend 0x42::b;
    friend 0x42::c;
}
```

与`use`语句不同，`friend`只能在模块作用域内声明，不能在表达式块作用域内声明。`friend`声明可以位于任何顶层结构（例如`use`、`function`、`struct`等）允许的位置。然而，为了可读性，建议将友元声明放在模块定义的开头附近。

请注意，友元概念不适用于Move脚本：

- Move 脚本不能声明 `friend` 模块，因为这样做没有意义：没有机制可以调用脚本中定义的函数。
- Move 模块也不能声明 `friend` 脚本，因为脚本是短暂的代码片段，永远不会发布到全局存储中。

### 友元声明规则

友元声明受以下规则的约束：

- 一个模块不能声明自己为友元。

```rust
module 0x42::m {
    friend Self; // ERROR!
    // ^^^^ Cannot declare the module itself as a friend
}
```

- 友元模块必须为编译器所知

```rust
module 0x42::m {
    friend 0x42::nonexistent; // ERROR!
    //     ^^^^^^^^^^^^^^^^^ Unbound module '0x42::nonexistent'
}
```

- 友元模块必须在相同的账户地址内。（注意：这不是技术要求，而是可能稍后放宽的政策决定。）

```rust
module 0x42::m {}
module 0x43::n {
    friend 0x42::m; // ERROR!
    //       ^^^^^^^ Cannot declare modules out of the current address as a friend
}
```

- 友元关系不能创建循环模块依赖。

不允许在友元关系中存在循环，例如`0x2::a`友元`0x2::b`友元`0x2::c`友元`0x2::a`的关系是不允许的。更一般地说，声明一个友元模块会向当前模块添加对友元模块的依赖（因为目的是让友元在当前模块中调用函数）。如果那个友元模块已经被使用，无论是直接还是间接，就会创建依赖循环。

```rust
address 0x2 {
    module a {
        use 0x2::c;
        friend 0x2::b;
        public fun a() {
            c::c()
        }
    }
    module b {
        friend 0x2::c; // ERROR!
        // ^^^^^^ This friend relationship creates a dependency cycle: '0x2::b' is a friend of '0x2::a' uses '0x2::c' is a friend of '0x2::b'
    }
    module c {
        public fun c() {}
    }
}
```

- 一个模块的友元列表不能包含重复项。

```rust
address 0x42 {
    module a {}
    module m {
        use 0x42::a as aliased_a;
        friend 0x42::A;
        friend aliased_a; // ERROR!
        // ^^^^^^^^ Duplicate friend declaration '0x42::a'. Friend declarations in a module must be unique
    }
}
```
