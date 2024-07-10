---
title: 第二十五章 事件
---
事件在交易执行期间被触发。每个 Move 模块都可以定义自己的事件，并选择在模块执行时触发事件的时机。Aptos Move 支持两种形式的事件：**模块事件** 和 **`EventHandle` 事件**。模块事件是现代的事件机制，并在框架 1.7 版本中推出。EventHandle 事件已被弃用，并随原始框架推出。由于区块链的工作方式，EventHandle 事件可能永远不会从 Aptos 中完全删除。

# 1. 模块事件

模块事件是由结构体类型标识的全局事件流。要定义一个事件结构体，将属性 `#[event]` 添加到具有 `drop` 和 `store` 能力的普通 Move 结构体上。例如，

```rust title="一个表示硬币转移的示例模块事件结构体"
/// 0xcafe::my_module_name
/// An example module event struct denotes a coin transfer.
#[event]
struct TransferEvent has drop, store {
    sender: address,
    receiver: address,
    amount: u64
}
```

然后创建并触发事件：

```rust
// Define an event.
let event = TransferEvent {
    sender: 0xcafe,
    receiver: 0xface,
    amount: 100
};
// Emit the event just defined.
0x1::event::emit(event);
```

示例模块事件可在此处获取[这里](https://explorer.aptoslabs.com/txn/682252266/events?network=testnet)。索引 0、1、2 是三种类型为 `0x66c34778730acbb120cefa57a3d98fd21e0c8b3a51e9baee530088b2e444e94c::event::MyEvent` 的模块事件。出于 API 兼容性，模块事件包含字段 `Account Address`、`Creation Number` 和 `Sequence Number`，所有这些字段都设置为 0。

![模块事件示例](https://aptos.dev/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fmodule-event.0f634746.png&w=3840&q=75)

# 2. 测试中的访问

事件在每个交易中存储在一个单独的称为事件累加器的默克尔树中。由于它是临时的，因此独立于状态树，在生产中执行交易时，MoveVM 没有读取事件的权限。但在测试中，Aptos Move 支持两个原生函数，用于读取触发的事件以进行测试和调试目的：

```rust
/// Return all emitted module events with type T as a vector.
# [test_only]
public native fun emitted_events<T: drop + store>(): vector<T>;
 
/// Return true iff `msg` was emitted.
# [test_only]
public fun was_event_emitted<T: drop + store>(msg: & T): bool
```

# 3. API 访问

使用 [GraphQL API](https://aptos.dev/en/build/guides/system-integrators-guide#production-network-access) 支持查询模块事件和 `EventHandle` 事件。

# 4. Event-Handle 事件（已弃用）

作为我们的遗留部分，Aptos 继承了来自 `EventHandles` 的 `Libra/Diem` 事件流。每个 `EventHandle` 由全局唯一值、`GUID` 和每个事件的序列号标识，并存储在一个资源中。流中的每个事件都有一个从 `EventHandle` 序列号派生的唯一序列号。

例如，在 [硬币转移](https://learn.aptoslabs.com/my-first-series/transaction) 期间，发送方和接收方的账户将分别触发 `SentEvent` 和 `ReceivedEvent`。此数据存储在分类账中，并可以通过 REST 接口的 [按事件句柄获取事件](https://api.devnet.aptoslabs.com/v1/spec#/operations/get_events_by_event_handle) 进行查询。

假设一个账户 `0xc40f1c9b9fdc204cf77f68c9bb7029b0abbe8ad9e5561f7794964076a4fbdcfd` 已向另一个账户发送硬币，则可以向 REST 接口发出以下查询：`https://api.devnet.aptoslabs.com/v1/accounts/c40f1c9b9fdc204cf77f68c9bb7029b0abbe8ad9e5561f7794964076a4fbdcfd/events/0x1::coin::CoinStore<0x1::aptos_coin::AptosCoin>/withdraw_events`。输出将是存储在该账户上的所有 `WithdrawEvent`，看起来像

```json
[
  {
    "key": "0x0000000000000000caa60eb4a01756955ab9b2d1caca52ed",
    "sequence_number": "0",
    "type": "0x1::coin::WithdrawEvent",
    "data": {
      "amount": "1000"
    }
  }
]
```

每个注册的事件都有一个唯一的 `key`。键 `0x0000000000000000caa60eb4a01756955ab9b2d1caca52ed` 映射到在账户 `0xc40f1c9b9fdc204cf77f68c9bb7029b0abbe8ad9e5561f7794964076a4fbdcfd` 上注册的事件 `0x1::coin::CoinStore<0x1::aptos_coin::AptosCoin>/sent_events`。然后，可以使用此键直接进行事件查询，例如 `https://api.devnet.aptoslabs.com/v1/events/0x0000000000000000caa60eb4a01756955ab9b2d1caca52ed`。

这些代表事件流，或者一个事件列表，每个条目包含一个从 `0` 开始顺序递增的 `sequence_number`、一个 `type` 和 `data`。每个事件必须由某种 `type` 定义。可能有多个由相同或相似 `type` 定义的事件，尤其是在使用泛型时。事件具有相关的 `data`。一般原则是包括所有在执行更改数据并触发事件的交易之前和之后理解底层资源变化所需的数据。

# 5. 迁移到模块事件

随着模块事件的发布，EventHandle 事件已被弃用。为支持迁移到模块事件，项目应在当前触发 EventHandle 事件的任何地方触发模块事件。一旦外部系统充分采用模块事件，可能不再需要触发遗留事件。

请注意，EventHandle 事件不能也不会被删除，因此无法升级的项目将能够继续使用它们。
