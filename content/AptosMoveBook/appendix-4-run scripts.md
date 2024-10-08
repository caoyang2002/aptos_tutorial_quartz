---
title: 附录四：运行脚本
aliases:
  - 附录四：运行脚本
---
# Move 脚本

本教程解释了如何编写和执行 Move 脚本。您可以使用 Move 脚本在已发布的 Move 模块接口上执行一系列命令。

有关脚本的更多信息，请参见[Move脚本文档]()。

# 脚本示例

以下示例调用 `aptos_coin.move` 模块上的函数，以确认目标账户的余额是否小于 `desired_balance`，如果是，则将其补充到 `desired_balance`。

```rust
script {
    use std::signer;
    use aptos_framework::aptos_account;
    use aptos_framework::aptos_coin;
    use aptos_framework::coin;
 
    fun main(src: &signer, dest: address, desired_balance: u64) {
        let src_addr = signer::address_of(src);
 
        addr::my_module::do_nothing();
 
        let balance = coin::balance<aptos_coin::AptosCoin>(src_addr);
        if (balance < desired_balance) {
            aptos_account::transfer(src, dest, desired_balance - balance);
        };
    }
}
```

# 确定目标
现在您已经知道您想要完成什么，您需要确定：

1. 我把这些文件放在哪里？
2. 我给它们命名为什么？
3. 我需要 `Move.toml` 吗？
4. 我如何使用 CLI 运行我的脚本？

让我们通过使用 Aptos CLI 的分步教程来运行 Move 脚本。



# 开始

## 首先创建一个新目录

```bash
mkdir testing
cd testing
```



## 设置 Aptos CLI 并创建一个账户：

```
aptos init --network testnet
```

您可以重复使用现有的私钥（看起来像这样）：

```bash
0x754c1acc2425a06cf70076268f9fb087504c96393e6a3615595402fc1e11d713
```

或者您生成一个新的私钥，作为设置账户的一部分。假设您的账户看起来像下面的例子：

`.aptos/congif.yaml`
```yaml
---
profiles:
  default:
    private_key: "0x3e78bb2ea31fb67100050aab18623ae6bbbdbe8ba6ca5efc74ea6a6935183965"
    public_key: "0x64daf96ff53d74d348194f62cebbb576ef815d893a87109daa0b0e1ea5a213db"
    account: 754c1acc2425a06cf70076268f9fb087504c96393e6a3615595402fc1e11d713
    rest_url: "https://fullnode.testnet.aptoslabs.com"
    faucet_url: "https://faucet.testnet.aptoslabs.com"
```



## 初始化一个新的 Move 项目：

```bash
aptos move init --name run_script
```

在当前目录的 `sources/` 子目录中创建一个包含上面示例脚本的 `my_script.move` 文件。同时，根据下面的例子创建一个 `my_module.move` 文件：

`sources/my_script.move`
```rust
script {
    use std::signer;
    use aptos_framework::aptos_account;
    use aptos_framework::aptos_coin;
    use aptos_framework::coin;
 
    fun main(src: &signer, dest: address, desired_balance: u64) {
        let src_addr = signer::address_of(src);
 
        addr::my_module::do_nothing();
 
        let balance = coin::balance<aptos_coin::AptosCoin>(src_addr);
        if (balance < desired_balance) {
            aptos_account::transfer(src, dest, desired_balance - balance);
        };
    }
}
```

`sources/my_module.move`
```
module addr::my_module {
    public entry fun do_nothing() { }
}
```

这将产生以下文件结构：
```rust
.
├── Move.toml
├── scripts
├── sources
│   ├── my_module.move
│   └── my_script.move
└── tests
```



## 编译脚本

```bash
aptos move compile --named-addresses addr=754c1acc2425a06cf70076268f9fb087504c96393e6a3615595402fc1e11d713
```

因为在 `my_module.move` 代码中我们已经引用了这个名为 `addr` 的命名地址，所以编译器能够知道这是什么。

>[!TIP]
> 使用命名地址参数编译（这是更通用的方式）：
> 
> 打开 `Move.toml` 文件，写入：
> ```bash
> [addresses]
> addr = "754c1acc2425a06cf70076268f9fb087504c96393e6a3615595402fc1e11d713"
> ```
> 
> 只需要执行
> 
>```
> aptos move compile 
>```
>

输出看起来是这样的：

```json
Compiling, may take a little while to download git dependencies...
UPDATING GIT DEPENDENCY https://github.com/aptos-labs/aptos-core.git
INCLUDING DEPENDENCY AptosFramework
INCLUDING DEPENDENCY AptosStdlib
INCLUDING DEPENDENCY MoveStdlib
BUILDING run_script
{
  "Result": [
    "754c1acc2425a06cf70076268f9fb087504c96393e6a3615595402fc1e11d713::my_module"
  ]
}
```

> 这一步会生成编译模块和脚本，其中脚本为： `build/run_script/bytecode_scripts/main.mv`



## 发布模块

> 其实发布模块的时候也会编译，上一步的“编译模块”其实有一点多余。

```bash
aptos move publish
```

```bash
Compiling, may take a little while to download git dependencies...
UPDATING GIT DEPENDENCY https://github.com/aptos-labs/aptos-core.git
INCLUDING DEPENDENCY AptosFramework
INCLUDING DEPENDENCY AptosStdlib
INCLUDING DEPENDENCY MoveStdlib
BUILDING run_script
package size 728 bytes
Do you want to submit a transaction for a range of [12450 - 18600] Octas at a gas unit price of 150 Octas? [yes/no] >
$ yes  # 你需要在这里输入 yes 或者 y
{
  "Result": {
    "transaction_hash": "0x9a2a058affc3237bd5d427a7d45209d0a95ccf019467083b89dc11f5dd1942d8",
    "gas_used": 83,
    "gas_unit_price": 150,
    "sender": "754c1acc2425a06cf70076268f9fb087504c96393e6a3615595402fc1e11d713",
    "sequence_number": 2,
    "success": true,
    "timestamp_us": 1720006799741145,
    "version": 3150901501,
    "vm_status": "Executed successfully"
  }
}
```

>[!NOTE]
>
> 一定要发布这个模块到链上，否则会出现模块不存在的错误：
>
> ```bash
> {
>   "Error": "Simulation failed with status: LINKER_ERROR\nExecution failed with message: Linker Error: Module 754c1acc2425a06cf70076268f9fb087504c96393e6a3615595402fc1e11d713::my_module doesn't exist"
> }
> ```
>



## 运行脚本

```bash
aptos move run-script --compiled-script-path build/run_script/bytecode_scripts/main.mv --args address:0x5dcb60faa729186d2bf13e21241e5edd0222c69ccb4973324511c21ee19a3626 --args u64:5
```
>[!TIP]
>注意编译脚本的路径在 `build/run_script/` 下，而不是 `build/my_script/`。这是因为它使用`Move.toml` 中包含的项目的名称，即我们运行 `aptos move init --name run_script` 时的`run_script` 


> 你可能注意到了这个没见过的地址，这是一个示例地址，即模块中检测余额的地址，也可以替换为你自己的地址
>
> ```bash
> 0x5dcb60faa729186d2bf13e21241e5edd0222c69ccb4973324511c21ee19a3626
> ```

```bash
Do you want to submit a transaction for a range of [1200 - 1800] Octas at a gas unit price of 100 Octas? [yes/no] >
$ yes  # 你需要在这里输入 yes 或者 y
{
  "Result": {
    "transaction_hash": "0x916c88e5b41347ce5e2dba462afda544ef77ed602a715a2b3301a550740b2024",
    "gas_used": 8,
    "gas_unit_price": 150,
    "sender": "754c1acc2425a06cf70076268f9fb087504c96393e6a3615595402fc1e11d713",
    "sequence_number": 1,
    "success": true,
    "timestamp_us": 1720006544105831,
    "version": 3149726659,
    "vm_status": "Executed successfully"
  }
}
```


请参阅本文档使用的[代码](https://github.com/banool/move-examples/tree/main/run_script)。完整的示例解释了如何使用依赖于用户创建的 `Move` 模块的 `Move` 脚本。

另见如何在 `Aptos Developer Discussions` 中使用 [Rust SDK](https://github.com/aptos-labs/aptos-developer-discussions/discussions/24) 而不是 Aptos CLI 进行此操作。



# 高级

您可以以更简单的方式执行脚本；而不是分别运行 `aptos move compile` 和 `aptos move run-script --compiled-script-path`，您可以直接这样做：

```
aptos move run-script --script-path sources/my_script.move --args address:0x5dcb60faa729186d2bf13e21241e5edd0222c69ccb4973324511c21ee19a3626 --args u64:5
```

这将用单个 CLI 命令执行两个步骤，但可能存在一些问题。因此，我们目前建议使用前两个步骤的方法。
