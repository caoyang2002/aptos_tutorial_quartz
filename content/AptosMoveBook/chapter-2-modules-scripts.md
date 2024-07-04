---
title: 第二章 模块与脚本
aliases:
  - 第二章 模块与脚本
draft: 
description: Move 中的模块和脚本
tags:
  - module
  - script
---
Move 有两种不同类型的程序：**模块**和**脚本**。
模块是一类库，它们定义了结构体类型以及作用于这些类型的函数。结构体类型定义了 Move 全局存储的规则，而模块函数定义了更新存储的规则。模块本身也存储在全局存储中。脚本是类似于传统语言中主函数的可执行入口点。脚本通常调用已发布模块的函数来对全局存储进行更新。脚本是临时的代码片段，不会发布在全局存储中。

一个 Move 源文件（或编译单元）可以包含多个模块和脚本。然而，发布模块或执行脚本是不同的虚拟机操作。

要学习如何发布和执行Move脚本，请按照 Move 脚本章节的示例进行操作。

# 1. 脚本
脚本具有以下结构：

```rust
script {
    <use>*
    <constants>*
    fun <identifier><[type parameters: constraint]*>([identifier: type]*) <function_body>
}
```


脚本必须以 `use` 声明开头，然后是常量，最后是 `main` 函数声明。`main` 函数的名称并不必须是 “main”名称，它是脚本中唯一的函数，可以有任意数量的参数，并且不能有返回值。这里有一个包含这些规则的示例：

```rust
script {
    // 导入在名为std的账户地址下发布的调试模块。
    use std::debug;
   
    const ONE: u64 = 1;
   
    fun main(x: u64) {
        let sum = x + ONE;
        debug::print(&sum)
    }
}
```

脚本的能力非常有限 —— 它们不能声明友元（friend），结构体类型或访问全局存储。它们的主要目的是调用模块函数。

# 2. 模块（modules）
模块具有以下语法：

```rust
module <address>::<identifier> { // 这里的 <address> 是一个有效的地址
    (<use> | <friend> | <type> | <function> | <constant>)*
}
```

其中 `<address>` 是一个有效的名称或字面量地址。

例如：

```rust
module 0x42::example { // 字面量地址
    struct Example has copy, drop { i: u64 }
   
    use std::debug;
    friend 0x42::another_example;
   
    const ONE: u64 = 1;
   
    public fun print(x: u64) {
        let sum = x + ONE;
        let example = Example { i: sum };
        debug::print(&sum)
    }
}
```

`module 0x42::example` 部分指定模块 example 将在全局存储中的账户地址 `0x42` 下发布。

模块也可以使用命名地址声明。例如：

```rust
module example_addr::example {
    struct Example has copy, drop { a: address }
   
    use std::debug;
    friend example_addr::another_example;
   
    public fun print() {
        let example = Example { a: @example_addr };
        debug::print(&example)
    }
}
```

由于命名地址仅在源语言级别和编译期间存在，命名地址将在字节码级别完全替换为它们实际的字面量值。例如，如果我们有以下代码：

```rust
script {
    fun example() {
        my_addr::m::foo(@my_addr); // 在编译时 my_addr 会被替换为字面量地址
    }
}
```

并且我们将 `my_addr` 设置为 `0xC0FFEE` 进行编译，那么它在操作上等同于以下操作：

```rust
script {
    fun example() {
        0xC0FFEE::m::foo(@0xC0FFEE); // 字面量地址
    }
}
```

>[!TIP] 提示
>然而，在源代码级别，这些并不等价 —— 函数 `m::foo` 必须通过 `my_addr` 命名地址访问，而不是通过分配给该地址的数值。

模块名称只能以字母 `a` 到 `z` 或 `A` 到 `Z` 作为开头。在第一个字符之后，模块名称可以包含下划线 `_`、字母 `a` 到 `z` 、字母 `A` 到 `Z` 或数字 `0` 到 `9`

```rust
module my_module {}
module foo_bar_42 {}
module f_4{}
```

通常，模块名称以小写字母开头。一个名为 `my_module` 的模块应该存储在一个名为 `my_module.move` 的源文件中。

- 模块内的所有元素可以以任何顺序出现。
- 一个模块（module）是类型（type）和函数（function）的集合。
- `use` 关键字用于从其他模块导入类型（type）。
- `friend` 关键字指定受信任的模块列表。`const` 关键字定义可以在模块函数中使用的**私有**常量。