---
title: "Rust 的基础知识"
author: caoyang2002
---

[toc]

- 官网：https://www.rust-lang.org/zh-CN/

# 1. 安装与更新

## Windows

安装

`x86_64-pc-windows-msvc`

`x86_64-pc-windows-gnu` 

组件

`rustup component`  有一些组件名称不同，可能有 msvc 后缀

cargo 配置

`C://User/<your_user_name>/.cargo/config`

## Linux / Mac

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

## 1. 更新 rust

- `rustup update`  更新
- `rustup self uninstall`  卸载
- `rustup component add rustfmt`  添加组件
- `rustup --version`  查看当前版本
- `rustup show`  查看安装的所有版本



`rustup install nightly` 安装夜版（开发版）

`rustup default nightly` 更改为夜版

`rustup default stable`  更改为稳定版

## 2. Rust 编译器

- `rustc --version`  查看版本
- `rustc -o output_filename filename.rs`  编译生成二进制文件
- `rustc --create-type lib filename.rs`  编译生成库文件

## 3. 开发环境

- vscode
    - rust-analyzer
    - Error Lens

## 4. Rust 的包管理工具 Cargo

- 隐式地使用 rustc 进行编译
- 命令：
    - 创建 `cargo new project_name`
    - 创建一个新的 Rust 库项目 `cargo new --lib project_name`
    - 构建项目（生成二进制可执行文件或库文件）`cargo build`
    - 生成优化的可执行文件，常用于生产环境 `cargo build --release`
    - 检测  `cargo check`
    - 运行  `cargo run` 
    - 运行  `cargo run` 
    - 测试 `cargo test`





## 5. `cargo.toml` 配置文件

```toml
[package] 
name = "rysigy"
version = "0.1.0"
edition = "2021"

# See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html

[dependencies]
# 在这里写，无论是 build 还是 dev 都会被加载
```

- [package] 设置项目名、版本等
- [dependencies] 设置依赖
    - [build-dependencies]  列出了在构建项目时需要的依赖项
        - 用于适配环境，一班不需要配置这项
    - [dev-dependencoes] 列出了只在开发时需要的依赖项
        - 用于测试


# 2. 获取 Rust 第三方库与国内源

## 2.1 直接下载

https://crates.io/

例如下载 `rand`

- 搜索 `rand`

- 在右侧的 `install` 中

    - ```rust
        Install
        
        Run the following Cargo command in your project directory:
        
        cargo add rand
        
        Or add the following line to your Cargo.toml:
        
        rand = "0.8.5"  # 点击复制
        ```

    - 粘贴在 `cargo.toml`  中

        ```toml
        [dependencies]
        rand = "0.8.5"
        ```

    - 保存，自动加载

- 下方的 `Documentation` 中提供了文档

    Documentation:

    - [The Rust Rand Book](https://rust-random.github.io/book)
    - [API reference (master branch)](https://rust-random.github.io/rand)
    - [API reference (docs.rs)](https://docs.rs/rand)  这是文档

```rust
use rand::prelude::*;

if rand::random() { // generates a boolean
    // Try printing a random unicode code point (probably a bad idea)!
    println!("char: {}", rand::random::<char>());
}

let mut rng = rand::thread_rng();
let y: f64 = rng.gen(); // generates a float between 0 and 1

let mut nums: Vec<i32> = (1..100).collect();
nums.shuffle(&mut rng);
```

​    

## 使用插件

> 安装  `cargo install cargo-edit`

**现在 cargo 已经自带这个功能了**



添加库  `cargo add dependency_name` ，默认安装最新的

- 安装指定版本  `cargo add dependency_name@1.2.3`

- 添加开发时用的依赖库  `cargo add --dev dependency_name`

- 添加构建时用的依赖库  `cargo add --build dependency_name`

删除库   `cargo rm dependency_name`

>  例如：
>
> 添加 rand 库
>
> `cargo add rand`
>
> 删除库
>
> `cargo rm rand`
>
> 安装 0.7 版本
>
> `cargo rand@0.7`
>
> 安装到 dev
>
> `cargo add --dev rand`
>
> 删除 dev 的库
>
> `cargo rm --dev rand`



## 设置国内源

推荐 [rsproxy.cn](https://rsproxy.cn)

文件  `~/.cargo/config`

```toml
[source.crates-io]
replace-with = 'rsproxy-sparse'
[source.rsproxy]
registry = "https://rsproxy.cn/crates.io-index"
[source.rsproxy-sparse]
registry = "sparse+https://rsproxy.cn/index/"
[registries.rsproxy]
index = "https://rsproxy.cn/crates.io-index"
[net]
git-fetch-with-cli = true
```


# 错误

```bash
$ rustup update
info: syncing channel updates for 'stable-aarch64-apple-darwin'
error: could not download file from 'https://static.rust-lang.org/dist/channel-rust-stable.toml.sha256' to '/Users/caoyang/.rustup/tmp/a8e9zeo21_hs07fn_file'
info: checking for self-update
error: could not download file from 'https://static.rust-lang.org/rustup/release-stable.toml' to '/var/folders/lk/1mc2q1150j9btq1mbn_s32v40000gn/T/rustup-updateohYPD2/release-stable.toml': failed to make network request: error sending request for url (https://static.rust-lang.org/rustup/release-stable.toml): error trying to connect: connection closed via error: error trying to connect: connection closed via error: connection closed via error
```

> 网络故障
