源码： https://github.com/aptos-labs/aptos-core/tree/main/aptos-move/move-examples/hello_blockchain

```rust
module hello_blockchain::message {  
    use std::error;  
    use std::signer;  
    use std::string;  
    use aptos_framework::event;  
  
    //:!:>resource  
    struct MessageHolder has key {  
        message: string::String,  
    }  
    //<:!:resource  
  
    #[event]  
    struct MessageChange has drop, store {  
        account: address,  
        from_message: string::String,  
        to_message: string::String,  
    }  
  
    /// There is no message present  
    const ENO_MESSAGE: u64 = 0;  
  
    #[view]  
    public fun get_message(addr: address): string::String acquires MessageHolder {  
        assert!(exists<MessageHolder>(addr), error::not_found(ENO_MESSAGE));  
        borrow_global<MessageHolder>(addr).message  
    }  
  
    public entry fun set_message(account: signer, message: string::String)  
    acquires MessageHolder {  
        let account_addr = signer::address_of(&account);  
        if (!exists<MessageHolder>(account_addr)) {  
            move_to(&account, MessageHolder {  
                message,  
            })  
        } else {  
            let old_message_holder = borrow_global_mut<MessageHolder>(account_addr);  
            let from_message = old_message_holder.message;  
            event::emit(MessageChange {  
                account: account_addr,  
                from_message,  
                to_message: copy message,  
            });  
            old_message_holder.message = message;  
        }  
    }  
  
    #[test(account = @0x1)]  
    public entry fun sender_can_set_message(account: signer) acquires MessageHolder {  
        let addr = signer::address_of(&account);  
        aptos_framework::account::create_account_for_test(addr);  
        set_message(account, string::utf8(b"Hello, Blockchain"));  
  
        assert!(  
            get_message(addr) == string::utf8(b"Hello, Blockchain"),  
            ENO_MESSAGE  
        );  
    }  
}
```

这是一个输出 `Hello, Blockchain` 的 Move 程序

# 创建

```bash
mkdir hello_blockchain
cd hello_blockchain
aptos move init --name hello_blockchain
aptos init --network testnet
```

你会得到你的链上地址。看起来像这样：

```bash
0xfbc3f1d4d60af3306c04f1acaed1aa54d0dc951a87fc91e8c2e571c25428ce3f
```

# 配置 Move.toml

>[!TIP] 说明
>`Move.toml` 是 Move on Aptos 的配置文件，这一步我们需要配置刚才获得的链上地址，以简化编译和发布模块的操作

```rust title="Move.toml"
[package]
name = "hello_blockchain"
version = "1.0.0"
authors = []

[addresses]
// here
hello_blockchain = "0xfbc3f1d4d60af3306c04f1acaed1aa54d0dc951a87fc91e8c2e571c25428ce3f"

[dev-addresses]

[dependencies.AptosFramework]
git = "https://github.com/aptos-labs/aptos-core.git"
rev = "mainnet"
subdir = "aptos-move/framework/aptos-framework"

[dev-dependencies]
```

>[!WARNING] 警告
>源码中的注释需要使用英文字符，否则会在编译阶段出错

# 创建源码文件并写入

```bash
vim hello_blockchain.move
```

然后粘贴最上方的源码

>[!TIP] 提示
>如果粘贴的格式有误，你可以使用先输入 `:set paste`  然后再粘贴

运行

```bash
aptos move test
```

输出：

```bash
$ aptos move test
INCLUDING DEPENDENCY AptosFramework
INCLUDING DEPENDENCY AptosStdlib
INCLUDING DEPENDENCY MoveStdlib
BUILDING hello_blockchain
Running Move unit tests
[ PASS ] 0xfbc3f1d4d60af3306c04f1acaed1aa54d0dc951a87fc91e8c2e571c25428ce3f::message::sender_can_set_message
Test result: **OK**. Total tests: 1; passed: 1; failed: 0
{
  "Result": "Success"
}
```

源码解析：

```rust
module hello_blockchain::message {  }
```

这里定义一个模块，其中 `hello_blockchain` 是一个地址，他被我们定义在 `Move.toml` 中，如果不在 `Move.toml` 中定义这个地址，那么我们就需要使用以下命令来使用测试模块

```bash
aptos move test --named-addresses hello_blockchain="0xfbc3f1d4d60af3306c04f1acaed1aa54d0dc951a87fc91e8c2e571c25428ce3f"
```

```rust title="hello_blockchain.move"
use std::error;  
use std::signer;  
use std::string;  
use aptos_framework::event;  
```

这表示需要用到的外部模块，其中模块的位置同样是在 `Move.toml` 中配置的

```rust title="Move.toml"
[dependencies.AptosFramework]
git = "https://github.com/aptos-labs/aptos-core.git"
rev = "mainnet"
subdir = "aptos-move/framework/aptos-framework"
```

这里表示，外部模块在 `https://github.com/aptos-labs/aptos-core.git` 仓库的 `aptos-move/framework/aptos-framework` 目录下寻找

```rust
//:!:>resource  
struct MessageHolder has key {  
	message: string::String,  
}  
//<:!:resource  
```

这里定义了一个结构体，这个结构体有 `key` 能力，结构体中的字段为 `message` 类型是 `string::String`，具有 `key` 能力的结构体表示这是一个资源

>[!NOTE] 笔记
> 结构体的能力包括：`store` 、 `key` 、 `drop` 、 `copy`，他们都需要使用 `has` 关键字声明
> - `copy`：允许具有此能力的类型的值被复制。
> - `drop`：允许具有此能力的类型的值被弹出 / 丢弃。
> - `store`：允许具有此能力的类型的值存在于全局存储中的结构体内。
> - `key`：允许类型作为全局存储操作的键。
> 
>如果结构体的**值不能被复制并且不能被丢弃，我们通常称其为资源**。在这种情况下，资源值必须在函数结束时转移所有权。这个属性使得资源特别适合用于定义全局存储模式或表示重要值（例如 token）。




```rust
#[event]  
struct MessageChange has drop, store {  
	account: address,  
	from_message: string::String,  
	to_message: string::String,  
}  
```

这个结构体比较特殊，它被添加了 `#[event]` 注解，后续可以通过 `0x1::event::emit(实例化结构体名称)` 触发，这些被触发的事件可以在区块链浏览器以及 api 中被查询到。

接下来定义了一个常量：

```rust
 const ENO_MESSAGE: u64 = 0;
```

然后定义的是 `#[view]`，表示它能够在区块链浏览器中显示

```rust
#[view]  
public fun get_message(addr: address): string::String acquires MessageHolder {  
	assert!(exists<MessageHolder>(addr), error::not_found(ENO_MESSAGE));  
	borrow_global<MessageHolder>(addr).message  
}  
```

`#[view]` 修饰的函数不能更改存储；它们只能读取数据，提供了一种安全的方式来访问信息，而不会有更改状态的风险。

```rust
public entry fun set_message(account: signer, message: string::String)  acquires MessageHolder {  
	let account_addr = signer::address_of(&account);  
	if (!exists<MessageHolder>(account_addr)) {  
		move_to(&account, MessageHolder {  
			message,  
		})  
	} else {  
		let old_message_holder = borrow_global_mut<MessageHolder>(account_addr);  
		let from_message = old_message_holder.message;  
		event::emit(MessageChange {  
			account: account_addr,  
			from_message,  
			to_message: copy message,  
		});  
		old_message_holder.message = message;  
	}  
}  
```

这是一个设置信息的函数 `set_message`，参数为签名者类型和字符串类型，它需要使用 `MessageHolder` 结构体，。

首先是检查这个账户地址是否存在：
- 如果不存在就把这个地址移动到 `MessageHolder` 结构体下。
- 如果存在，先从结构体中借出这个地址的可变应用，然后触发事件，`to_message: copy message,` 表复制参数中的 `message` 到 `to_message`

```rust
#[test(account = @0x1)]  
public entry fun sender_can_set_message(account: signer) acquires MessageHolder {  
	let addr = signer::address_of(&account);  
	aptos_framework::account::create_account_for_test(addr);  
	set_message(account, string::utf8(b"Hello, Blockchain"));  

	assert!(  
		get_message(addr) == string::utf8(b"Hello, Blockchain"),  
		ENO_MESSAGE  
	);  
}  
```

这里定义了一个 `sender_can_message()` 函数，它需要使用 `MessageHolder` 结构体，需要传入一个签名者。上方的`#[test(account = @0x1)]` 表示者是一个测试方法，除了测试编译 `aptos move test`，这个函数不会被包含在编译的字节码中。

然后定义了一个变量 `addr` 这个变量是签名者地址。之后是设置信息，通过调用 `set_message()`，并设置了断言 —— 设置的字符串与 “Hello, Blockchain” 不同的时候，返回错误码 `0`，并断言。

>[!NOTE] 笔记
>你可能注意到了 `entry` 和 `public` 这是两个权限的声明，表示谁可以调用这个函数：
>
> - `public` 函数可以被任何已发布的模块或脚本调用。
>
> - `entry` 修饰符用于指示交易的入口点。具有 `entry` 修饰符的函数在向区块链提交交易时作为执行的起点。

