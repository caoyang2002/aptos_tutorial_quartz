---
title: 编码约定
---
# 移动编码惯例

本节列出了 Move 团队认为有帮助的一些基本的Move编码惯例。这些只是建议，如果您喜欢其他格式指南和惯例，您应该随意使用它们。

## 命名[](https://aptos.guide/en/build/smart-contracts/book/coding-conventions#naming)

- **模块名称**：应为小写蛇形，例如，`fixed_point32`，`vector`。
- **类型名称**：如果它们不是本机类型，则应为骆驼大小写，例如`Coin`、`RoleId`。
- **函数名称**：应为小写蛇形，例如， `destroy_empty`。
- **常量名称**：应为骆驼大小写，如果代表错误代码（例如，`EIndexOutOfBounds`），则应以`E`开头，如果代表非错误值（例如，`MIN_STAKE`），则应以蛇形大写开头。

- **通用类型名称**：应是描述性的，或适时的反描述性的，例如，矢量通用类型参数的`T`或`Element`。大多数时候，模块中的“主”类型应该与模块名称相同，例如，`option::Option`，`fixed_point32::FixedPoint32`。
- **模块文件名**：应与模块名称相同，例如`option.move`。
- **脚本文件名**：应为小写蛇形，并应与脚本中“主”函数的名称匹配。
- **混合文件名**：如果文件包含多个模块和/或脚本，文件名应为小写蛇形，其中名称与内部的任何特定模块/脚本不匹配。

## 进口[](https://aptos.guide/en/build/smart-contracts/book/coding-conventions#imports)

- 所有模块`use`语句都应位于模块的顶部。
- 函数应从声明的模块中导入和使用完全限定，而不是在顶层导入。
- 类型应该在顶层导入。存在名称冲突的地方，应酌情用于在本地重命名类型。

例如，如果有一个模块：

```rust
module 0x1::foo {
  struct Foo { }
  const CONST_FOO: u64 = 0;
  public fun do_foo(): Foo { Foo{} }
  // ...
}
```

这将被导入并用作：

```rust
module 0x1::bar {
  use 0x1::foo::{Self, Foo};
 
  public fun do_bar(x: u64): Foo {
    if (x == 10) {
      foo::do_foo()
    } else {
      abort 0
    }
  }
  // ...
}
```

而且，如果在导入两个模块时出现本地名称冲突：

```rust
module 0x1::other_foo {
  struct Foo {}
  // ...
}
 
module 0x1::importer {
  use 0x1::other_foo::Foo as OtherFoo;
  use 0x1::foo::Foo;
  // ...
}
```

## 评论[](https://aptos.guide/en/build/smart-contracts/book/coding-conventions#comments)

- 每个模块、结构和公共函数声明都应该进行注释。
- 移动有文档注释`///`，常规单行注释`//`，阻止注释`/* */`，和阻止文档注释`/** */`。

### 评论示例[](https://aptos.guide/en/build/smart-contracts/book/coding-conventions#comments-example)

文档评论必须位于他们评论的项目正上方。例如，以下内容是有效的：

```rust
/// My awesome module, doc comment can be used here
module 0x42::example { // double slash can be anywhere
 
  // Double slash can be anywhere
 
  /// My awesome constant
  const MY_VALUE: u64 = 5;
 
  /// My awesome error message
  const E_MY_ERROR: u64 = 10;
 
  #[view]
  /// My awesome view function
  fun show_me_the_money() {
    // ...
  }
 
  /* Similarly block comments can be anywhere */
}
```

以下是文档评论的示例`///`将失败

```rust
module 0x42::example {
 
  /// My awesome view function <- must be below the annotation, right above the thing commented
  #[view]
  fun show_me_the_money() {
    // ...
    /// Within a function
  }
 
  /// Not attached to anything
}
```

## 格式化[](https://aptos.guide/en/build/smart-contracts/book/coding-conventions#formatting)

Move团队计划编写一个自动格式化器来强制执行格式化约定。然而，与此同时：

- 应使用四个空格缩进，但`script`和`address`块除外，其内容不应缩进。
- 如果行长于100个字符，则应断行。
- 结构和常量应在模块中的所有函数之前声明。