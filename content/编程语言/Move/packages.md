---
title: 包
---
# 包

软件包允许Move程序员更轻松地重用代码，并在项目之间共享代码。Move软件包系统允许程序员轻松执行以下操作：

- 定义一个包含移动代码的软件包；
- 通过[命名地址](https://aptos.guide/en/build/smart-contracts/book/address)参数化软件包；
- 在其他移动代码中导入和使用软件包，并实例化命名地址；
- 构建软件包并从软件包生成相关的编译工件；以及
- 使用围绕编译的移动工件的通用界面工作。

## 软件包布局和清单语法[](https://aptos.guide/en/build/smart-contracts/book/packages#package-layout-and-manifest-syntax)

Move软件包源目录包含一个`Move.toml`软件包清单文件以及一组子目录：

_必须_存在标记为`required`的目录，才能将目录视为移动包并进行编译。可选目录可以存在，如果存在，将包含在编译过程中。根据构建软件包的模式（`test`或`dev`），还将包含`tests`和`examples`目录。

`sources`目录可以包含移动模块和移动脚本（移动脚本和包含脚本函数的模块）。`examples`目录可以保存额外的代码，仅用于开发和/或教程目的，这些代码在`test`或`dev`模式之外编译时不会包括在内。

支持`scripts`目录，因此如果软件包作者需要，可以将移动脚本与模块分开。如果存在`scripts`目录，将始终包含用于编译。文档将使用`doc_templates`目录中存在的任何文档模板构建。

### Move.toml[](https://aptos.guide/en/build/smart-contracts/book/packages#movetoml)

Move软件包清单在`Move.toml`文件中定义，并具有以下语法。可选字段标有`*`，`+`表示一个或多个元素：

Move.toml

```toml title="Move.toml"
[package]
name = <string>                  # e.g., "MoveStdlib"
version = "<uint>.<uint>.<uint>" # e.g., "0.1.1"
license* = <string>              # e.g., "MIT", "GPL", "Apache 2.0"
authors* = [<string>]            # e.g., ["Joe Smith (joesmith@noemail.com)", "Jane Smith (janesmith@noemail.com)"]
 
[addresses]  # (Optional section) Declares named addresses in this package and instantiates named addresses in the package graph
# One or more lines declaring named addresses in the following format
<addr_name> = "_" | "<hex_address>" # e.g., std = "_" or my_addr = "0xC0FFEECAFE"
 
[dependencies] # (Optional section) Paths to dependencies and instantiations or renamings of named addresses from each dependency
# One or more lines declaring dependencies in the following format
<string> = { local = <string>, addr_subst* = { (<string> = (<string> | "<hex_address>"))+ } } # local dependencies
<string> = { git = <URL ending in .git>, subdir=<path to dir containing Move.toml inside git repo>, rev=<git commit hash>, addr_subst* = { (<string> = (<string> | "<hex_address>"))+ } } # git dependencies
 
[dev-addresses] # (Optional section) Same as [addresses] section, but only included in "dev" and "test" modes
# One or more lines declaring dev named addresses in the following format
<addr_name> = "_" | "<hex_address>" # e.g., std = "_" or my_addr = "0xC0FFEECAFE"
 
[dev-dependencies] # (Optional section) Same as [dependencies] section, but only included in "dev" and "test" modes
# One or more lines declaring dev dependencies in the following format
<string> = { local = <string>, addr_subst* = { (<string> = (<string> | <address>))+ } }
```

一个具有一个本地依赖项和一个git依赖项的最小软件包清单示例：

```toml
[package]
name = "AName"
version = "0.0.0"
```

一个更标准的软件包清单的示例，该清单还包括移动标准库，并从中实例化命名地址`Std`，地址值为`0x1`：

```toml
[package]
name = "AName"
version = "0.0.0"
license = "Apache 2.0"
 
[addresses]
address_to_be_filled_in = "_"
specified_address = "0xB0B"
 
[dependencies]
# Local dependency
LocalDep = { local = "projects/move-awesomeness", addr_subst = { "std" = "0x1" } }
# Git dependency
MoveStdlib = { git = "https://github.com/diem/diem.git", subdir="language/move-stdlib", rev = "56ab033cc403b489e891424a629e76f643d4fb6b" }
 
[dev-addresses] # For use when developing this module
address_to_be_filled_in = "0x101010101"
```

软件包清单中的大多数部分不言自明，但命名地址可能有点难以理解，因此值得更详细地研究它们。

## 编译期间命名的地址[](https://aptos.guide/en/build/smart-contracts/book/packages#named-addresses-during-compilation)

回想一下，Move有[命名地址](https://aptos.guide/en/build/smart-contracts/book/address)，并且不能在Move中声明命名地址。因此，到目前为止，命名地址及其值需要传递给命令行上的编译器。使用Move软件包系统，不再需要此，您可以在软件包中声明命名地址，实例化范围内的其他命名地址，并从Move软件包系统清单文件中的其他软件包中重命名命名地址。让我们分别浏览一下以下每一项：

### 声明[](https://aptos.guide/en/build/smart-contracts/book/packages#declaration)

假设我们在`example_pkg/sources/A.move`中有一个移动模块，如下所示：

```rust title="A.move"
module named_addr::A {
  public fun x(): address { @named_addr }
}
```

我们可以在`example_pkg/Move.toml`中以两种不同的方式声明命名地址`named_addr`。第一个：

```toml
[package]
name = "ExamplePkg"# ...
[addresses]
named_addr = "_"
```

在软件包`ExamplePkg`中声明`named_addr`为命名地址，并且该_地址可以是任何有效的地址值_。因此，导入软件包可以选择命名地址`named_addr`的值作为它想要的任何地址。直观上，您可以将此视为通过命名地址`named_addr`参数化软件包`ExamplePkg`，然后稍后可以通过导入软件包实例化软件包。

`named_addr`也可以声明为：

```toml
[package]
name = "ExamplePkg"
# ...
[addresses]
named_addr = "0xCAFE"
```

其中指出，命名地址`named_addr`正好是`0xCAFE`，不能更改。这很有用，因此其他导入软件包可以使用此命名地址，而无需担心分配给它的确切值。

使用这两种不同的声明方法，有关命名地址的信息可以通过两种方式在软件包图中流动：

- 前者（“未分配的命名地址”）允许命名地址值从导入站点流向声明站点。
- 后者（“分配的命名地址”）允许命名地址值从软件包图中的声明站点向上流向使用站点。

通过这两种在软件包图中流动命名地址信息的方法，围绕范围界定和重命名的规则变得非常重要。

## 命名地址的范围界定和重命名[](https://aptos.guide/en/build/smart-contracts/book/packages#scoping-and-renaming-of-named-addresses)

如果：如果：包`P`中的命名地址`N`在范围内：

1. 它声明了一个命名地址`N`；或
2. `P`传递依赖项之一中的软件包声明命名地址`N`，在软件包图中，`P`和`N`的声明软件包之间有一个依赖路径，没有重命名`N`。

Additionally, every named address in a package is exported. Because of this and the above scoping rules each package can be viewed as coming with a set of named addresses that will be brought into scope when the package is imported, e.g., if the `ExamplePkg` package was imported, that importation would bring into scope the `named_addr` named address. Because of this, if `P` imports two packages `P1` and `P2` both of which declare a named address `N` an issue arises in `P`: which “`N`” is meant when `N` is referred to in `P`? The one from `P1` or `P2`? To prevent this ambiguity around which package a named address is coming from, we enforce that the sets of scopes introduced by all dependencies in a package are disjoint, and provide a way to _rename named addresses_when the package that brings them into scope is imported.

导入时重命名命名地址可以按照上述`P`、`P1`和`P2`示例进行如下操作：

```toml
[package]
name = "P"
# ...
[dependencies]
P1 = { local = "some_path_to_P1", addr_subst = { "P1N" = "N" } }
P2 = { local = "some_path_to_P2"  }
```

通过重命名，`N`指的是来自`P2`的`N`，`P1N`将指来自`P1`的`N`：

```rust
module N::A {
    public fun x(): address { @P1N }
}
```

重要的是要注意，_重命名不是本地_的：一旦命名地址`N`在packageP中重命名为`N2`所有导入`P`的软件包都不会看到`N`，而只会看到`N2`除非从`P`外部重新引入`N`。这就是为什么本节开头的范围界定规则中的规则（2）指定了“`P`和`N`的声明包之间的包图中的依赖路径，没有`N`的重命名”。

### 实例化[](https://aptos.guide/en/build/smart-contracts/book/packages#instantiation)

命名地址可以在软件包图中多次实例化，只要它始终具有相同的值。如果相同的命名地址（无论重命名）在软件包图中以不同的值实例化，则为错误。

只有当所有命名地址解析为一个值时，才能编译移动包。如果软件包希望公开一个未刻录的命名地址，这会带来问题。这就是`[dev-addresses]`部分解决的问题。本节可以为命名地址设置值，但不能引入任何命名地址。此外，只有根包中的`[dev-addresses]`包含在`dev`模式下。例如，具有以下清单的根包不会在`dev`模式之外编译，因为`named_addr`将不会被实例化：

```toml
[package]
name = "ExamplePkg"
# ...
[addresses]
named_addr = "_"
 
[dev-addresses]
named_addr = "0xC0FFEE"
```

## 用法、工件和数据结构[](https://aptos.guide/en/build/smart-contracts/book/packages#usage-artifacts-and-data-structures)

移动包系统附带一个命令行选项，作为移动CLI`move <flags> <command> <command_flags>`的一部分。除非提供特定路径，否则所有软件包命令都将在当前工作目录中运行。Move CLI的命令和标志的完整列表可以通过运行`move --help`找到。

### 用法[](https://aptos.guide/en/build/smart-contracts/book/packages#usage)

软件包可以通过Move CLI命令编译，也可以作为Rust中的库命令，使用函数`compile_package`。这将创建一个`CompiledPackage`，将编译的字节码与其他编译工件（源地图、文档、ABI）一起保存在内存中。此`CompiledPackage`可以转换为`OnDiskPackage`，反之亦然——后者是文件系统中以以下格式布局的`CompiledPackage`的数据：

有关这些数据结构以及如何将Move软件包系统用作Rust库的更多信息，请参阅`move-package`箱。

## 使用字节码进行依赖[](https://aptos.guide/en/build/smart-contracts/book/packages#using-bytecode-for-dependencies)

当这些依赖项的移动源代码在本地不可用时，移动字节码可以用作依赖项。要使用此功能，您需要在同一级别的目录中放置文件，然后在相应的`Move.toml`文件中指定其路径。

## 要求和限制[](https://aptos.guide/en/build/smart-contracts/book/packages#requirements-and-limitations)

使用本地字节码作为依赖项需要在本地下载字节码文件，并且必须在`Move.toml`或通过`--named-addresses`中指定每个命名地址的实际地址。

请注意，`aptos move prove`和`aptos move test`命令目前都不支持字节码作为依赖项。

## 推荐结构[](https://aptos.guide/en/build/smart-contracts/book/packages#recommended-structure)

我们用一个例子来说明使用此功能的开发流程。假设我们想编译软件包`A`。软件包布局是：

`A.move`定义如下，取决于模块`Bar`和`Foo`：

A/AModule.move

```rust
module A::AModule {
    use B::Bar;
    use C::Foo;
    public fun foo(): u64 {
        Bar::foo() + Foo::bar()
    }
}
```

假设`Bar`和`Foo`的来源不可用，但相应的字节码`Bar.mv`和`Foo.mv`在本地可用。要将它们用作依赖项，我们会：

为`Bar`和`Foo`指定`Move.toml`。请注意，命名地址已经用字节码中的实际地址实例化了。在我们的示例中，`C`的实际地址已经绑定到`0x3`。因此，`[addresses]`必须将`C`指定为`0x3`，如下所示：

工作区/C/Move.toml

```toml
[package]
name = "Foo"
version = "0.0.0"
 
[addresses]
C = "0x3"
```

将字节码文件和相应的`Move.toml`文件与`build`子目录中的字节码放在同一目录中。请注意，**需要**一个空的`sources`目录。例如，文件夹`B`（用于软件包`Bar`）和`C`（用于软件包`Foo`）的布局将类似于：

Specify `[dependencies]` in the `Move.toml` of the target (first) package with the location of the dependent (secondary) packages. For instance, assuming all three package directories are at the same level, `Move.toml` of `A` would resemble:

工作区/A/Move.toml

```toml
[package]
name = "A"
version = "0.0.0"
 
[addresses]
A = "0x2"
 
[dependencies]
Bar = { local = "../B" }
Foo = { local = "../C" }
```

请注意，如果搜索路径中同时存在同一软件包的字节码和源代码，编译器将抱怨声明重复。