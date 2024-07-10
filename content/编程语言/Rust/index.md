---
title: Rust 教程
---
<a name="readme-top"/>

目录
<details>
<summary><kbd>展开</kbd></summary>


![Top Langs](https://github-readme-stats.vercel.app/api/top-langs/?username=anuraghazra&exclude_repo=github-readme-stats,anuraghazra.github.io)

- [一、配置](#一配置)
- [二、基础语法](#二基础语法)
- [三、进阶语法](#三进阶语法)
- [四、源码解析](#四源码解析)
- [附录-基本类型](1-基本类型)

</details>

# 一、配置

<div align="right">

[![](https://img.shields.io/badge/-BACK_TO_TOP-151515?style=flat-square)](#readme-top)

</div>

1. **安装 Rust**（如果你还没有安装）：
   Rust 提供了一个包管理器和构建工具，称为 Cargo。你可以从 Rust 官方网站获取安装指南：[https://www.rust-lang.org/tools/install](https://www.rust-lang.org/tools/install)。

2. **使用 Cargo 创建新项目**：
   打开终端或命令提示符，然后运行以下命令来创建一个新的 Rust 项目：

   ```bash
   cargo new project_name
   ```

   将 `project_name` 替换为你的项目名称。

3. **切换到项目目录**：
   使用 `cd` 命令切换到你的项目目录：

   ```bash
   cd project_name
   ```

4. **构建项目**：
   你可以运行以下命令来构建项目：

   ```bash
   cargo build
   ```

   这个命令会编译你的项目并生成目标文件，通常在 `target/debug` 目录下。

5. **运行项目**：
   使用以下命令运行你的项目：

   ```bash
   cargo run
   ```

   如果项目中有一个名为 `main` 的函数和一个可执行的二进制文件，这个命令将会构建并运行它。

6. **运行单元测试**：
   你可以运行以下命令来执行项目的单元测试：

   ```bash
   cargo test
   ```

7. **打开项目**：
   如果你想在文本编辑器或 IDE 中打开项目，可以使用以下命令：

   ```bash
   cargo open
   ```

   这个命令会使用默认的文件管理器打开项目目录。

8. **查看项目结构**：
   Cargo 创建的项目通常包含以下结构：

   ```
   project_name/
   ├── Cargo.toml
   ├── src
   │   └── main.rs
   └── .gitignore
   ```

    - `Cargo.toml`：项目的配置文件，包含了项目的元数据和依赖信息。
    - `src`：源代码目录，包含项目的所有源文件。
    - `main.rs`：默认的入口文件，包含 Rust 程序的 `main` 函数。
    - `.gitignore`：一个文件，用于指定 Git 忽略的文件和路径。

按照这些步骤，你现在应该有一个基本的 Rust 项目，可以开始编写和构建你的 Rust 程序了。


# 二、基础语法

<div align="right">

[![](https://img.shields.io/badge/-BACK_TO_TOP-151515?style=flat-square)](#readme-top)

</div>

参考

- 推荐：[Rust语言圣经](https://course.rs/basic/intro.html)
- 

## 变量

```rust
fn main() {
   let x = 10; // x 是不可重复赋值的
   x = 20; // error
   let mut y = 10; // x 可以重复赋值，mut 表示可以更改
   y = 20; // success
}
```

```rust
fn main() {
    // 字符串类型
    let spaces = "   ";
    // usize数值类型
    let spaces = spaces.len();
}
```

这种结构是允许的，因为第一个 spaces 变量是一个字符串类型，第二个 spaces 变量是一个全新的变量且和第一个具有相同的变量名，且是一个数值类型。

所以变量遮蔽可以帮我们节省些脑细胞，不用去想如 spaces_str 和 spaces_num 此类的变量名；相反我们可以重复使用更简单的 spaces 变量名。

如果你用 let mut :

```rust
fn main(){
   let mut spaces = "   ";
   spaces = spaces.len();
}

// 编译错误
// spaces = spaces.len();
//          ^^^^^^^^^^^^ expected `&str`, found `usize`
```

mut 只是可以修改值，而不能修改类型。


变量不使用会出现警告，可以使用 `_` 忽略它

```rust
fn main() {
   let _x = 5; // 不会警告“未使用”  
   let y = 10; // 警告“未使用”
}
```

解构：多个变量赋值

```rust
fn main() {
   let (a, mut b): (bool,bool) = (true, false);
   // 定义的变量：
   // a = true,不可变; 
   // b = false，可变
   println!("a = {:?}, b = {:?}", a, b);

   b = true;
   assert_eq!(a, b);
}
```

关于 `:?`

```rust
use std::fmt;

struct Point {
    x: i32,
    y: i32,
}

impl fmt::Debug for Point {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "Debug: Point(x: {}, y: {})", self.x, self.y)
    }
}

impl fmt::Display for Point {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "Display: Point({}, {})", self.x, self.y)
    }
}

fn main() {
    let point = Point { x: 10, y: 20 };
    println!("a = {:?}, b = {:?}", point, point); // 使用 Debug 格式化
    println!("a = {}, b = {}", point, point);    // 使用 Display 格式化
}

// a = Debug: Point(x: 10, y: 20), b = Debug: Point(x: 10, y: 20)
// a = Display: Point(10, 20), b = Display: Point(10, 20)
```


常量

```rust
// #![allow(unused)] 放在代码文件的顶部，表示对整个 crate（Rust 项目的模块化单元）启用 unused 属性。
// 这意味着编译器将不会对整个 crate 中的未使用项发出警告。
#![allow(unused)] // 如果没有 #![allow(unused)] 属性宏，编译器会发出警告，因为常量 MAX_POINTS 被声明了但没有在代码中使用。
fn main() {
   const MAX_POINTS: u32 = 100_000;
}
```

作用域：变量屏蔽

```rust
fn main() {
   let x = 5;
   // 在main函数的作用域内对之前的x进行遮蔽
   let x = x + 1;

   {
      // 在当前的花括号作用域内，对之前的x进行遮蔽
      let x = x * 2;
      println!("The value of x in the inner scope is: {}", x);
   }

   println!("The value of x is: {}", x);
}

// The value of x in the inner scope is: 12
// The value of x is: 6
```

这和 mut 变量的使用是不同的，第二个 let 生成了完全不同的新变量，两个变量只是恰好拥有同样的名称，涉及一次内存对象的再分配。

而 mut 声明的变量，可以修改同一个内存地址上的值，并不会发生内存对象的再分配，性能要更好。




# 三、进阶语法

<div align="right">

[![](https://img.shields.io/badge/-BACK_TO_TOP-151515?style=flat-square)](#readme-top)

</div>

## 闭包
参考
- [知乎参考](https://zhuanlan.zhihu.com/p/75429819)
- 推荐：[Rust语言圣经](https://course.rs/advance/functional-programing/closure.html)

闭包是一种匿名函数，它可以赋值给变量也可以作为参数传递给其它函数，不同于函数的是，它允许捕获调用者作用域中的值，例如：
```rust
fn main() {
    let x = 1;
    let sum = |y| x + y;
    assert_eq!(3, sum(2));
}

// 3
```
上面的代码展示了非常简单的闭包 sum，它拥有一个入参 y，同时捕获了作用域中的 x 的值，因此调用 sum(2) 意味着将 2（参数 y）跟 1（x）进行相加，最终返回它们的和：3。

可以看到 sum 非常符合闭包的定义：可以赋值给变量，允许捕获调用者作用域中的值。

语法

```rust
|param1, param2,...| {
    语句1;
    语句2;
    返回表达式
}
```
如果只有一个参数
```rust
|param1| 返回表达式
```



```rust
|| 42;
|x| x + 1;
|x:i32| x + 1;
|x:i32| -> i32 { x + 1 };
```

#### 关于 `->` 的解释

在 Rust 中，`->` 符号用于函数签名中，它将函数的参数列表与返回类型分隔开。在你提供的代码示例中：

```rust
let sum = |x: i32, y: i32| -> i32 {
    x + y
};
```

这里定义了一个名为 `sum` 的闭包（匿名函数），其语法分解如下：

1. `let sum`：声明一个名为 `sum` 的变量。

2. `=`：赋值操作符。

3. `|x: i32, y: i32|`：这是闭包的参数列表，其中 `x` 和 `y` 是参数名，而 `: i32` 指定了这些参数的类型为 32 位整数（`i32`）。

4. `-> i32`：这指定了闭包的返回类型，即这个闭包返回一个 `i32` 类型的值。

5. `{ x + y }`：闭包的主体，这里简单地将两个参数相加并返回结果。

6. `;`：语句结束符。

整体来看，这行代码定义了一个闭包，它接受两个 `i32` 类型的参数并返回它们相加的结果。这个闭包被赋值给了变量 `sum`，之后可以通过 `sum` 来调用这个闭包。

在 Rust 中，闭包通常用于实现回调函数，或者当你需要传递一些特定行为作为参数传递给其他函数时。闭包可以捕获并存储对它们创建时所在作用域中变量的引用，这使得它们非常灵活和强大。



# 四、源码解析

<div align="right">

[![](https://img.shields.io/badge/-BACK_TO_TOP-151515?style=flat-square)](#readme-top)

</div>

```rust
|s| s.split_whitespace().collect::<Vec<_>>()
```
在 Rust 中，这个表达式 `|s| s.split_whitespace().collect::<Vec<_>>()` 是一个闭包，它作为参数传递给像 `map` 这样的迭代器适配器。下面是这个闭包的逐部分解释：

1. `|s|`：这是一个闭包的参数部分，其中 `s` 是闭包的参数，它将接收迭代器中的每个元素。

2. `s.split_whitespace()`：这个方法将字符串 `s` 分割成多个子字符串，分割点是任意数量的空白字符。它返回一个迭代器，迭代器中的每个元素都是 `s` 中的一个单词。

3. `.collect::<Vec<_>>()`：`collect` 是一个迭代器适配器，它将迭代器中的元素收集到一个集合中。这里使用了 `Vec<_>` 作为泛型参数，表示收集的结果是一个动态数组（`Vec`），其中 `_` 是一个类型占位符，它告诉 Rust 编译器从迭代器中的元素类型推断出具体的类型。

将这些组合起来，`|s| s.split_whitespace().collect::<Vec<_>>()` 的作用是：对迭代器中的每个元素 `s` 应用 `split_whitespace()` 方法来分割字符串，然后使用 `collect::<Vec<_>>()` 将分割后的单词收集到一个 `Vec`（向量）中。这个闭包通常用在迭代器的 `map` 方法中，将每个迭代器元素（在这个上下文中是一个字符串切片）转换成一个单词的向量。

例如，如果你有一个包含多行文本的字符串，并且你想将每一行分割成单词，然后收集这些单词到一个向量中，你可以这样做：

```rust
let text = "hello world\nrust is fun";
let lines_and_words: Vec<Vec<&str>> = text
    .lines() // 创建一个迭代器，其中包含文本的行
    .map(|s| s.split_whitespace().collect::<Vec<&str>>()) // 对每一行应用闭包
    .collect(); // 收集结果
```

在这个例子中，`lines_and_words` 将是一个包含每一行单词向量的向量。


# 五、附录

## 1. 基本类型

- 数值类型: 有符号整数 (i8, i16, i32, i64, isize)、 无符号整数 (u8, u16, u32, u64, usize) 、浮点数 (f32, f64)、以及有理数、复数
- 字符串：字符串字面量和字符串切片 &str
- 布尔类型： true和false
- 字符类型: 表示单个 Unicode 字符，存储为 4 个字节
- 单元类型: 即 () ，其唯一的值也是 ()




<div align="right">

[![](https://img.shields.io/badge/-BACK_TO_TOP-151515?style=flat-square)](#readme-top)

</div>