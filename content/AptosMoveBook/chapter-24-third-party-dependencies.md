---
title: 第二十四章 第三方依赖
aliases:
  - 第二十四章 第三方依赖
link: https://aptos.dev/en/build/smart-contracts/third-party-dependencies
tags:
  - MoveOnAptos
---
第三方依赖是受控模块与之交互的外部模块。通常，这些外部模块存在于不同的账户下。

# 多 DEX 路由器示例

多 DEX 路由器积极利用第三方依赖。不是提交多个交易来与不同的 DEX 及其在交换路线内的各个入口函数进行交互，一个模块（或脚本）可以将所有独立的 DEX 调用合并到一个单一的、原子的交易中。多 DEX 路由器引用并调用每个第三方 DEX 模块中存在的函数来实现这一点。

# 来源

第三方依赖的可靠性和可用信息的数量会因其来源而有所不同。具体来说，一些情况下的文档可能不存在，逻辑也可能被重构。

应始终优先选择与链上部署模块相对应的经过验证的源代码，如 Git 仓库和本地源代码。如果这些都不可用，还有其他依赖可用代码的选项，如反编译代码、字节码和 ABI 生成的代码。

# Git 仓库

默认的 `Move.toml` 将 `AptosFramework` 作为一个 `Git` 仓库依赖项：

`Move.toml`
```toml
[dependencies.AptosFramework]
git = "<https://github.com/aptos-labs/aptos-core.git>"
rev = "mainnet"
subdir = "aptos-move/framework/aptos-framework"
```

当运行 Aptos CLI 命令时，会自动获取并针对依赖项的更新进行编译。

# 本地源代码

第三方源代码可以包含在 sources 目录中。本质上与自定义代码的处理方式相同。

对第三方依赖的任何升级都需要手动获取。

# 反编译代码

可以使用 Revela 编译器根据一个包的字节码重建 Move 代码：

```bash
aptos move decompile --package-path ./bytecode_modules
```

相应的 `{ModuleName}.mv.move` 文件将在 bytecode_modules 中生成。

```file
xxx
```

将文件类型更改为 `{ModuleName}.move` 并将其放置在工作区的 sources 目录中后，将其作为本地源文件引用。

```file
xxx
```

>[!NOTE]
>反编译代码将保留链上执行的行为，但会被重构。

## 字节码

Aptos CLI 允许下载一个包的字节码。

```bash
aptos move download --account {account_addr} --bytecode --package {package_name} 
```

每个字节码依赖项都需要自己的包，其结构为：

- `Move.toml` 文件，预定义了包地址。
- `build/{ModuleName}/bytecode_modules` 目录，其中包含字节码。
- 空的 sources 目录。
- 
在受控包的 Move.toml 中包含依赖项后，受控模块可以引用该依赖项。

`Aptos token 示例`

一个受控的 `invoking_code.move` 模块与外部的 `aptos_token` 模块相互作用：

```rust
module invoker::invoking_code {
    use aptos_token_objects_addr::aptos_token;
 
    public entry fun wrapper_add_property(): u64 {
        aptos_token::add_property(...);
    }
}
```

下面的命令从主网获取必要的 AptosTokenObjects 包字节码：

```bash
aptos move download --account 0x4 \
--bytecode --package AptosTokenObjects \
--output-dir ./aptos_token_bytecode_output/
```

```file
xxx
```

所创建的 aptos_token 的依赖包结构和内容是：

```file
xxx
```

```toml
[package]
name = "aptos_token"
version = "0.0.0"
[addresses]
aptos_token_module_addr = "0x4"
```

来自受控的 `invoking_code.move` 模块的依赖项列表将包含对字节码包的本地引用，从而能够进行编译。

```toml
[package]
name = "invoking_code"
[addresses]
invoker = "_"
[dependencies]
aptos_token = { local = "../aptos_token_objects_addr" }
```
# ABI

可以通过读取一个包的 ABI 手动创建 Move 接口代码。值得注意的是，虽然函数头必须精确，但内部逻辑不是。

>[!NOTE]
>所有可用的公共和入口方法都在 ABI 中定义了它们的名称、参数、返回值等。结构体和资源也将包括在内。

之后，接口代码被视为等同于本地源代码。

`Aptos token 示例`

以下是从 [Aptos Explorer](https://explorer.aptoslabs.com/account/0x0000000000000000000000000000000000000000000000000000000000000004/modules/code/aptos_token?network=mainnet#:~:text=1114-,ABI,-{): 获取的 `AptosTokenObjects` ABI 的一部分。

```json
{
	"address": "0x4",
	"name": "aptos_token",
	"friends": [],
	"exposed_functions": [
	    {
	    "name": "add_property",
	    "visibility": "public",
	    "is_entry": true,
	    "is_view": false,
	    "generic_type_params": [
	        {
	        "constraints": [
	            "key"
	        ]
	        }
	    ],
	    "params": [
	        "&signer",
	        "0x1::object::Object<T0>",
	        "0x1::string::String",
	        "0x1::string::String",
	        "vector<u8>"
	    ],
	    "return": []
	    },
	    ...
	]
}
```

一个接口 Move 文件可以手写并被视为源文件。看起来像：

```rust
module 0x4::aptos_token {
    // ...
    public entry fun add_property<T: key>(
        creator: &signer,
        token: Object<T>,
        key: String,
        type: String,
        value: vector<u8>,
    ) acquires AptosCollection, AptosToken {
        abort 0
    }
}
```