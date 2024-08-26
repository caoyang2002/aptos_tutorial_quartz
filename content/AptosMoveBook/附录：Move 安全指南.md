---
title: 附录：Move 安全指南
aliases:
  - 附录：Move 安全指南
---
Move 语言在设计上注重安全性，并固有地提供了若干特性，包括类型系统和线性逻辑。尽管如此，其新颖性和某些业务逻辑的复杂性意味着开发人员可能并不总是熟悉 Move 的安全编码模式，这可能会导致漏洞。

本指南通过详细阐述常见的反模式及其安全替代方案来解决这一差距。它提供了实际示例来说明安全问题如何产生，并推荐了安全编码的最佳实践。本指南旨在提高开发人员对 Move 安全机制的理解，并确保智能合约的稳健开发。

# 1. 访问控制

## 1.1 对象所有权检查

每个 `Object<T>` 都可以被任何人访问，这意味着任何 `Object<T>` 都可以传递给任何函数，即使调用者并不拥有它。重要的是要验证 `signer` 是对象的合法所有者。

### 不安全代码示例

在这个模块中，用户在执行某些操作之前必须购买订阅。用户调用注册函数获取一个 `Object<Subscription>`，之后可以使用它来执行操作。

`object_example.move`
```rust
module 0x42::example {
 
    struct Subscription has key {
        end_subscription: u64
    }
 
    entry fun registration(user: &signer, end_subscription: u64) {
        let price = calculate_subscription_price(end_subscription);
        payment(user,price);
 
        let user_address = address_of(user);
        let constructor_ref = object::create_object(user_address);
        let subscription_signer = object::generate_signer(&constructor_ref);
        move_to(&subscription_signer, Subscription { end_subscription });
    }
 
    entry fun execute_action_with_valid_subscription(
        user: &signer, obj: Object<Subscription>
    ) acquires Subscription {
        let object_address = object::object_address(&obj);
        let subscription = borrow_global<Subscription>(object_address);
        assert!(subscription.end_subscription >= aptos_framework::timestamp::now_seconds(),1);
        // Use the subscription
        [...]
    }
}
```

在这个不安全的示例中，`execute_action_with_valid_subscription` 没有验证用户是否拥有传递给它的 `obj`。因此，任何人都可以使用其他人的订阅，绕过支付要求。

#### 安全代码示例

确保 `signer` 拥有对象。

`object_example.move`
```rust
module 0x42::example {
 
    struct Subscription has key {
        end_subscription: u64
    }
 
    entry fun registration(user: &signer, end_subscription: u64) {
        let price = calculate_subscription_price(end_subscription);
        payment(user,price);
 
        let user_address = address_of(user);
        let constructor_ref = object::create_object(user_address);
        let subscription_signer = object::generate_signer(&constructor_ref);
        move_to(&subscription_signer, Subscription { end_subscription });
    }
 
    entry fun execute_action_with_valid_subscription(
        user: &signer, obj: Object<Subscription>
    ) acquires Subscription {
        //ensure that the signer owns the object.
        assert!(object::owner(&obj)==address_of(user),ENOT_OWNWER);
        let object_address = object::object_address(&obj);
        let subscription = borrow_global<Subscription>(object_address);
        assert!(subscription.end_subscription >= aptos_framework::timestamp::now_seconds(),1);
        // Use the subscription
        [...]
    }
}
```

## 全局存储访问控制

接受 `&signer` 并不总是足以用于访问控制目的。在执行敏感操作时，一定要断言 `signer` 是预期的账户。

未经适当授权的用户可以执行特权操作。

### 不安全代码示例

此代码片段允许任何调用 `delete` 函数的用户删除一个 `Object`，而不验证调用者是否具有必要的权限。

```rust
module 0x42::example {
  struct Object has key{
    data: vector<u8>
  }
 
  public fun delete(user: &signer, obj: Object) {
    let Object { data } = obj;
  }
}
```

#### 安全代码示例

更好的替代方案是使用 Move 提供的全局存储，直接从 `signer::address_of(signer)` 借用数据。这种方法确保了强大的访问控制，因为它只访问交易的 `signer` 地址中包含的数据。这种方法最大限度地降低了访问控制错误的风险，确保只有 `signer` 拥有的数据可以被操作。

```rust
module 0x42::example {
  struct Object has key{
    data: vector<u8>
  }
 
  public fun delete(user: &signer) {
    let Object { data } = move_from<Object>(signer::address_of(user));
  }
}
```

# 2. 函数可见性

遵循最小权限原则：

- 始终从私有函数开始，根据业务逻辑的需要更改其可见性。
- 对于仅打算从 Aptos CLI 或 SDK 中使用的函数，使用 `entry`。
- 对于只能由特定模块访问的函数，使用 `friend`。
- 对于从存储中读取数据而不更改状态的函数，使用 `#[view]` 修饰。`#[view]` 函数可以间接调用，在这种情况下它们可能会更改存储。

函数可见性决定了谁可以调用一个函数。这是实施访问控制的一种方式，对于智能合约安全至关重要：

- 私有函数只能在其定义的模块内调用。它们不能从其他模块或 CLI / SDK 访问，这可以防止与合约内部的意外交互。

```rust
module 0x42::example {
  fun sample_function() { /* ... */ }
}
```

- `public(friend)` 函数在此基础上进行了扩展，允许指定的“友元”模块调用该函数，在限制一般访问的同时实现不同合约之间的受控交互。

```rust
module 0x42::example {
  friend package::mod;
 
  public(friend) fun sample_function() { /* ... */ }
}
```

- `public` 函数可以被任何已发布的模块或脚本调用。

```rust
module 0x42::example {
  public fun sample_function() { /* ... */ }
}
```

- `#[view]` 修饰的函数不能更改存储；它们只能读取数据，提供了一种安全的方式来访问信息，而不会有更改状态的风险。

```rust
module 0x42::example {
  #[view]
  public fun read_only() { /* ... */ }
}
```

- 在 Move 中，`entry` 修饰符用于指示交易的入口点。具有 `entry` 修饰符的函数在向区块链提交交易时作为执行的起点。

```rust
module 0x42::example {
  entry fun f(){}
}
```

总结：

|                  | 模块本身 | 其他模块         | Aptos CLI/SDK |
| ---------------- | ---- | ------------ | ------------- |
| 私有               | ✅    | ⛔            | ⛔             |
| `public(friend)` | ✅    | ✅ 如果是友元 ⛔ 否则 | ⛔             |
| `public`         | ✅    | ✅            | ⛔             |
| `entry`          | ✅    | ⛔            | ✅             |

这种分层的可见性确保只有授权的实体可以执行某些函数，大大降低了破坏合约完整性的漏洞或攻击的风险。

请注意，可以将 `entry` 与 `public` 或 `public(friend)` 结合使用

```rust
module 0x42::example {
  public(friend) entry fun sample_function() { /* ... */ }
}
```

在这种情况下，`sample_function` 可以被任何声明为友元的 Aptos CLI/SDK 模块调用。

#### 影响

遵循此原则可确保函数不过度暴露，将函数访问的范围限制在业务逻辑所需的范围内。

# 3. 类型和数据结构

## 3.1 泛型类型检查

泛型可用于针对不同的输入数据类型定义函数和结构体。使用它们时，确保泛型类型是有效的并且符合预期。[阅读更多](https://aptos.dev/en/build/smart-contracts/book/generics) 关于泛型。

未检查的泛型可能导致未经授权的操作或交易中止，可能损害协议的完整性。
### 3.1.1 不安全代码示例

下面的代码概述了一个简化版的闪电贷。

在 `flash_loan<T>` 函数中，用户可以借入给定数量的硬币类型 **`T`** 以及一个记录借入金额加上在交易结束前应返回给协议的费用的 `Receipt`。

`repay_flash_loan<T>` 函数接受一个 `Receipt` 和一个 `Coin<T>` 作为参数。该函数从 `Receipt` 中提取还款金额，并断言返回的 `Coin<T>` 的值大于或等于 `Receipt` 中指定的金额，但是没有检查返回的 `Coin<T>` 是否与最初借出的 `Coin<T>` 相同，从而允许使用价值较低的硬币来偿还贷款。

```rust
module 0x42::example {
  struct Coin<T> {
    amount: u64
  }
 
  struct Receipt {
    amount: u64
  }
 
  public fun flash_loan<T>(user: &signer, amount: u64): (Coin<T>, Receipt) {
    let (coin, fee) = withdraw(user, amount);
    ( coin, Receipt {amount: amount + fee} )
  }
 
  public fun repay_flash_loan<T>(rec: Receipt, coins: Coin<T>) {
    let Receipt{ amount } = rec;
    assert!(coin::value<T>(&coin) >= rec.amount, 0);
    deposit(coin);
  }
}
```

### 3.1.2 安全代码示例

下面的 Aptos 框架示例创建了一个由两个泛型类型 `K` 和 `V` 组成的键值表。其相关的 `add` 函数接受一个 `Table<K, V>` 对象、一个 `key` 和 `value`，类型分别为 `K` 和 `V`。`phantom` 语法确保键和值的类型不能与表中的不同，防止类型不匹配。[阅读更多](https://aptos.dev/en/build/smart-contracts/book/generics#phantom-type-parameters) 关于 `phantom` 类型参数。

```rust
module 0x42::example {
  struct Table<phantom K: copy + drop, phantom V> has store {
    handle: address,
  }
 
  public fun add<K: copy + drop, V>(table: &mut Table<K, V>, key: K, val: V) {
    add_box<K, V, Box<V>>(table, key, Box { val })
  }
}
```

鉴于 Move 语言设计的类型检查，我们可以优化我们的闪电贷协议的代码。下面的代码确保传递给 `repay_flash_loan` 的硬币与最初借出的硬币相匹配。

```rust
module 0x42::example {
  struct Coin<T> {
    amount: u64
  }
  struct Receipt<phantom T> {
    amount: u64
  }
 
  public fun flash_loan<T>(_user: &signer, amount:u64): (Coin<T>, Receipt<T>) {
    let (coin, fee) = withdraw(user, amount);
    (coin,Receipt { amount: amount + fee})
  }
 
  public fun repay_flash_loan<T>(rec: Receipt<T>, coins: Coin<T>) {
    let Receipt{ amount } = rec;
    assert!(coin::value<T>(&coin) >= rec.amount, 0);
    deposit(coin);
  }
}
```

# 4. 资源管理和无界执行

有效的资源管理和防止无界执行对于维护协议中的安全性和 Gas 效率很重要。在合约设计中必须考虑这些方面：

1. 避免迭代一个允许无限制条目的公开可访问结构，其中任何数量的用户都可以不受限制地贡献。
2. 将用户特定的资产，如硬币和 NFT，存储在各个用户账户中。
3. 将模块或包相关的信息保留在对象中，与用户数据分开。
4. 而不是在单个共享的全局空间中组合所有用户操作，按单个用户将它们分开。

## 4.1 影响

忽略这些方面可能会允许攻击者耗尽 Gas 并中止交易。这可能会阻塞应用程序的功能。

## 4.2 不安全代码示例

下面的代码显示了一个循环遍历每个开放订单的函数，可能会因注册许多订单而被阻塞：

```rust
module 0x42::example {
  public fun get_order_by_id(order_id: u64): Option<Order> acquires OrderStore {
    let order_store = borrow_global_mut<OrderStore>(@admin);
    let i = 0;
    let len = vector::length(&order_store.orders);
    while (i < len) {
      let order = vector::borrow<Order>(&order_store.orders, i);
      if (order.id == order_id) {
        return option::some(*order)
      };
      i = i + 1;
    };
    return option::none<Order>()
  }
  //O(1) in time and gas operation.
  public entry fun create_order(buyer: &signer) { /* ... */ }
}
```

#### 安全代码示例

建议以这样的方式构建订单管理系统，即每个用户的订单都存储在他们各自的账户中，而不是在一个单一的全局订单存储中。这种方法不仅通过隔离用户数据增强了安全性，还通过分布数据负载提高了可扩展性。而不是使用 **`borrow_global_mut<OrderStore>(@admin)`** 来访问全局存储，订单应该通过各个用户的账户来访问。

```rust
module 0x42::example {
  public fun get_order_by_id(user: &signer, order_id: u64): Option<Order> acquires OrderStore {
    let order_store = borrow_global_mut<OrderStore>(signer::address_of(user));
    if (smart_table::contains(&order_store.orders, order_id)) {
      let order = smart_table::borrow(&order_store.orders, order_id);
      option::some(*order)
    } else {
      option::none<Order>()
    }
  }
}
```

还建议使用针对正在执行的操作的特定需求定制的高效数据结构。例如，在这种情况下，`SmartTable` 可能特别有效。

# 5. Move 的能力

Move 的能力是一组权限，控制对语言内数据结构的可能操作。智能合约开发人员必须谨慎处理这些能力，确保仅在必要时分配它们，并理解它们的影响以防止安全漏洞。

| 能力 | 描述                                                  |
| ------- | ------------------------------------------------------------ |
| `copy`    | 允许值的复制，允许它们在合约内多次使用。 |
| `drop`    | 允许从内存中丢弃值，这对于控制资源和防止泄漏是必要的。 |
| `store`   | 使数据能够保存在全局存储中，对于跨交易持久化数据至关重要。 |
| `key`     | 授予数据在全局存储操作中作为键的能力，对于数据检索和操作很重要。 |

[阅读更多](https://aptos.dev/en/build/smart-contracts/book/abilities) 关于能力。

能力的不正确使用可能导致安全问题，如未经授权的敏感数据复制（`copy`）、资源泄漏（`drop`）和全局存储处理不当（`store`）。

## 5.1 不安全代码示例

```rust
module 0x42::example {
  struct Token has copy { }
  struct FlashLoan has drop { }
}
```

- `Token` 的 `copy` 能力允许令牌被复制，可能导致双重支出和令牌供应的膨胀，从而可能使货币贬值。
- `FlashLoan` 结构体中的 `drop` 能力可能允许借款人在还款前销毁它来摆脱贷款。

# 6. 算术运算

## 6.1 除法精度

降低精度的算术运算（通过向下舍入）可能导致协议低估这些计算的结果。

Move 包括六种无符号整数数据类型：`u8`、`u16`、`u32`、`u64`、`u128` 和 `u256`。Move 中的除法运算截断任何小数部分，实际上是向下舍入到最接近的整数，这可能导致协议低估此类计算的结果。

计算中的舍入误差可能产生广泛的影响，可能导致财务不平衡、数据不准确和错误的决策过程。这些误差可能导致收入损失、不当收益，甚至在某些情况下构成安全风险，具体取决于上下文。准确和精确的计算对于维持系统的可靠性和用户的信心至关重要。

## 6.2 不安全代码示例

```rust
module 0x42::example {
  public fun calculate_protocol_fees(size: u64): (u64) {
    return size * PROTOCOL_FEE_BPS / 10000
  }
}
```

如果 `size` 小于 `10000 / PROTOCOL_FEE_BPS`，费用将向下舍入为 0，实际上使用户能够在不产生任何费用的情况下与协议交互。

## 6.3 安全代码示例

以下示例概述了缓解代码中问题的两种不同策略：

- 设置一个大于 `10000 / PROTOCOL_FEE_BPS` 的最小订单大小阈值，确保费用永远不会向下舍入为零。

```rust
module 0x42::example {
  const MIN_ORDER_SIZE: u64 = 10000 / PROTOCOL_FEE_BPS + 1;
 
  public fun calculate_protocol_fees(size: u64): (u64) {
    assert!(size >= MIN_ORDER_SIZE, 0);
    return size * PROTOCOL_FEE_BPS / 10000
  }
}
```

- 检查费用是否非零，并专门处理这种情况，例如设置最低费用或拒绝交易。

```rust
module 0x42::example {
  public fun calculate_protocol_fees(size: u64): (u64) {
    let fee = size * PROTOCOL_FEE_BPS / 10000;
    assert!(fee > 0, 0);
    return fee;
  }
}
```

## 6.4 整数考虑

在 Move 中，围绕整数运算的安全性旨在防止溢出和下溢，这可能导致意外行为或漏洞。具体来说：

- 加法（`+`）和乘法（`*`）如果结果对于整数类型太大，将导致程序中止。在这种情况下，程序会立即终止。
- 减法（`-`）如果结果小于零，将导致程序中止。
- 除法（`/`）如果除数为零，将导致程序中止。
- 左移（`<<`），独特的是，在溢出时不会中止。这意味着如果移位的位超过整数类型的存储容量，程序不会终止，从而导致不正确的值或不可预测的行为。

[阅读更多](https://aptos.dev/en/build/smart-contracts/book/integers#operations) 关于操作。

不良操作可能意外地改变智能合约的正确执行，要么导致不必要的中止，要么计算出不准确的数据。

# 7. Aptos 对象

## 7.1 `ConstructorRef` 泄漏

创建对象时，确保永远不要暴露对象的 `ConstructorRef`，因为它允许向对象添加资源。`ConstructorRef` 还可以用于生成其他能力（或“Refs”），用于更改或转移对象的所有权。[阅读更多](https://aptos.dev/en/build/smart-contracts/objects/creating-objects) 关于对象能力。

## 7.2 易受攻击的代码示例

例如，如果 `mint` 函数返回 NFT 的 `ConstructorRef`，它可以转换为 `TransferRef`，存储在全局存储中，并允许原始所有者在出售后将 NFT 转回。

```rust
module 0x42::example {
  use std::string::utf8;
 
  public fun mint(creator: &signer): ConstructorRef {
    let constructor_ref = token::create_named_token(
        creator,
        string::utf8(b"Collection Name"),
        string::utf8(b"Collection Description"),
        string::utf8(b"Token"),
        option::none(),
        string::utf8(b"https://mycollection/token.jpeg"),
    );
    constructor_ref
  }
}
```

## 7.3 安全代码示例

在 `mint` 函数中不要返回 `CostructorRef`：

```rust
module 0x42::example {
  use std::string::utf8;
 
  public fun mint(creator: &signer) {
    let constructor_ref = token::create_named_token(
        creator,
        string::utf8(b"Collection Name"),
        string::utf8(b"Collection Description"),
        string::utf8(b"Token"),
        option::none(),
        string::utf8(b"https://mycollection/token.jpeg"),
    );
  }
}
```

# 8. 对象账户

在 Aptos 框架中，多个 `key` 型资源可以存储在单个对象账户中。

然而，对象应该隔离到不同的账户，否则对账户内一个对象的修改可能会影响整个集合。

例如，转移一个资源意味着转移所有组成员，因为转移函数作用于 `ObjectCore`，它本质上是账户中所有资源的通用标签。

[阅读更多](https://aptos.dev/en/build/smart-contracts/objects) 关于 Aptos 对象。

## 8.1 不安全代码示例

`mint_two` 函数让 `sender` 为自己创建一个 `Monkey` 并向 `recipient` 发送一个 `Toad`。

由于 `Monkey` 和 `Toad` 属于同一个对象账户，结果是这两个对象现在都归 `recipient` 所有。

```rust
module 0x42::example {
  #[resource_group(scope = global)]
  struct ObjectGroup { }
 
  #[resource_group_member(group = 0x42::example::ObjectGroup)]
  struct Monkey has store, key { }
 
  #[resource_group_member(group = 0x42::example::ObjectGroup)]
  struct Toad has store, key { }
 
  fun mint_two(sender: &signer, recipient: &signer) {
    let constructor_ref = &object::create_object_from_account(sender);
    let sender_object_signer = object::generate_signer(constructor_ref);
    let sender_object_addr = object::address_from_constructor_ref(constructor_ref);
 
    move_to(sender_object_signer, Monkey{});
    move_to(sender_object_signer, Toad{});
    let monkey_object: Object<Monkey> = object::address_to_object<Monkey>(sender_object_addr);
    object::transfer<Monkey>(sender, monkey_object, signer::address_of(recipient));
  }
}
```

## 8.2 安全代码示例

在这个例子中，对象应该存储在单独的对象账户中：

```rust
module 0x42::example {
  #[resource_group(scope = global)]
  struct ObjectGroup { }
 
  #[resource_group_member(group = 0x42::example::ObjectGroup)]
  struct Monkey has store, key { }
 
  #[resource_group_member(group = 0x42::example::ObjectGroup)]
  struct Toad has store, key { }
 
  fun mint_two(sender: &signer, recipient: &signer) {
    let sender_address = signer::address_of(sender);
 
    let constructor_ref_monkey = &object::create_object(sender_address);
    let constructor_ref_toad = &object::create_object(sender_address);
    let object_signer_monkey = object::generate_signer(&constructor_ref_monkey);
    let object_signer_toad = object::generate_signer(&constructor_ref_toad);
 
    move_to(object_signer_monkey, Monkey{});
    move_to(object_signer_toad, Toad{});
 
    let object_address_monkey = signer::address_of(&object_signer_monkey);
 
    let monkey_object: Object<Monkey> = object::address_to_object<Monkey>(object_address_monkey);
    object::transfer<Monkey>(sender, monkey_object, signer::address_of(recipient));
  }
}
```

# 9. 业务逻辑

## 9.1 抢跑

抢跑涉及通过利用对他人已做出的未来行动的了解而在他人之前执行交易。这种策略给抢跑者带来不公平的优势，因为他们可以预测并从这些待处理交易的结果中获益。

抢跑可能破坏去中心化应用的公平性和完整性。它可能导致资金损失、游戏中的不公平优势、操纵市场价格以及对平台的普遍信任丧失。

## 9.2 不安全代码示例

在彩票场景中，用户通过从 1 到 100 中选择一个数字参与。在某个时刻，游戏管理员调用 `set_winner_number` 函数设置中奖号码。随后，在单独的交易中，管理员通过 `evaluate_bets_and_determine_winners` 审查所有玩家的投注来确定获胜者。

观察到 `set_winner_number` 设置的中奖号码的抢跑者可以在 `evaluate_bets_and_determine_winners` 执行之前尝试提交后期投注或修改现有投注以匹配中奖号码。

```rust
module 0x42::example {
  struct LotteryInfo {
    winning_number: u8,
    is_winner_set: bool,
  }
 
  struct Bets { }
 
  public fun set_winning_number(admin: &signer, winning_number: u8) {
    assert!(signer::address_of(admin) == @admin, 0);
    assert!(winning_number < 10,0);
    let lottery_info = LotteryInfo { winning_number, is_winner_set: true };
    move_to<LotteryInfo>(admin, lottery_info);
  }
 
  public fun evaluate_bets_and_determine_winners(admin: &signer) acquires LotteryInfo, Bets {
    assert!(signer::address_of(admin) == @admin, 0);
    let lottery_info = borrow_global<LotteryInfo>(admin);
    assert(lottery_info.is_winner_set, 1);
 
    let bets = borrow_global<Bets>(admin);
    let winners: vector<address> = vector::empty();
 
    let winning_bets_option = smart_table::borrow_with_default(&bets.bets, lottery_info.winning_number, &vector::empty());
 
    vector::iter(winning_bets_option, |bet| {
       vector::push_back(&mut winners, bet.player);
    });
    distribute_rewards(&winners);
  }
}
```

## 9.3 安全代码示例

避免抢跑的有效策略可以是实现一个 `finalize_lottery` 函数，在单个交易中揭示答案并结束游戏，并将其他函数设为私有。这种方法保证一旦答案被披露，系统不再接受任何新的答案，从而消除抢跑的机会。

```rust
module 0x42::example {
  public fun finalize_lottery(admin: &signer, winning_number: u64) {
    set_winner_number(admin, winning_number);
    evaluate_bets_and_determine_winners(admin);
  }
 
  fun set_winning_number(admin: &signer, winning_number: u64) { }
 
  fun evaluate_bets_and_determine_winners(admin: &signer) acquires LotteryInfo, Bets { }
}
```

# 10. 价格预言机操纵

在 DeFi 应用中，使用代币对的流动性比率来确定交易价格的价格预言机可能容易受到操纵。这种脆弱性源于市场参与者持有大量代币时可以影响流动性比率。当这些参与者战略性地增加或减少其代币持有量时，可能会影响流动性比率，从而影响价格预言机确定的价格，可能耗尽资金池。

我们建议使用多个预言机来确定价格。

## 10.1 安全代码示例

例如，Thala 利用分层预言机设计。该系统有一个主预言机和一个次预言机。如果其中一个预言机失败，另一个根据复杂的切换逻辑作为备份。该系统在设计时考虑了对抗情况，并始终努力提供高精度的价格源，同时尽量减少治理交互。

有关更深入的信息，请参考 [Thala 的文档](https://docs.thala.fi/thala-protocol-design/move-dollar-mod/oracles)。

## 10.2 代币标识符冲突

在处理代币时，确保用于比较代币结构体以建立确定性排序的方法不会导致冲突。将地址、模块和结构体名称连接到一个向量是不够的，因为它无法区分应该被视为唯一的相似名称。

因此，协议可能会由于代币结构体比较中的冲突而错误地拒绝合法的交换对，从而损害交换操作的完整性，导致资金损失。

## 10.3 不安全代码示例

`get_pool_address` 函数为与可替代资产的交易对相关的流动性池创建一个唯一的地址。它生成并返回一个作为指定两个代币的流动性池的独特标识符的地址。

然而，用户可以自由创建具有任何他们选择的符号的 `Object<Metadata>`。这种灵活性可能导致创建模仿其他现有实例的 `Object<Metadata>` 实例。这个问题可能导致种子冲突，进而导致池地址生成的冲突。

```rust
module 0x42::example {
  public fun get_pool_address(token_1: Object<Metadata>, token_2: Object<Metadata>): address {
    let token_symbol = string::utf8(b"LP-");
    string::append(&mut token_symbol, fungible_asset::symbol(token_1));
    string::append_utf8(&mut token_symbol, b"-");
    string::append(&mut token_symbol, fungible_asset::symbol(token_2));
    let seed = *string::bytes(&token_symbol);
    object::create_object_address(&@swap, seed)
  }
}
```

#### 安全代码示例

`object::object_address` 为每个 `Object<Metadata>` 返回一个唯一标识符

```rust
module 0x42::example {
  public fun get_pool_address(token_1: Object<Metadata>, token_2: Object<Metadata>): address {
    let seeds = vector[];
    vector::append(&mut seeds, bcs::to_bytes(&object::object_address(&token_1)));
    vector::append(&mut seeds, bcs::to_bytes(&object::object_address(&token_2)));
    object::create_object_address(&@swap, seed)
  }
}
```

# 11. 操作

------

## 11.1 暂停功能

协议应该具有有效暂停操作的能力。对于不可变协议，内置的暂停功能是必要的。可升级协议可以通过智能合约功能或协议升级来实现暂停。团队应该配备自动化工具，以便快速有效地执行此过程。

缺少暂停机制可能导致长期暴露于漏洞，可能导致重大损失。有效的暂停功能允许对安全威胁、错误或其他关键问题做出快速响应，最大限度地降低利用的风险，并确保用户资产和协议完整性的安全。

## 11.2 安全代码示例

如何集成暂停功能的示例

```rust
module 0x42::example {
  struct State {
    is_paused: bool,
  }
 
  public entry fun pause_protocol(admin: &signer) {
    let state = borrow_global_mut<State>(@protocol_address);
    state.is_paused = true;
  }
 
  public entry fun resume_protocol(admin: &signer) {
    let state = borrow_global_mut<State>(@protocol_address);
    state.is_paused = false;
  }
 
  public fun main(user: &signer) {
    let state = borrow_global<State>(@protocol_address);
    assert!(!state.is_paused, 0);
    // ...
  }
}
```

## 11.3 智能合约发布密钥管理

在测试网和主网使用相同的账户存在安全风险，因为测试网的私钥通常存储在不太安全的环境中（例如笔记本电脑），更容易暴露或泄露。攻击者获取测试网智能合约的私钥将能够升级主网的智能合约。

# 12. 随机性

有关随机性以及为什么它对于防止随机数的可预测性至关重要的更多信息，请参考此页面：[随机性指南](https://aptos.dev/guides/randomness/)。

## 12.1 随机性 - 测试中止攻击

> 在 Aptos 中，我们始终将安全放在首位。在编译期间，我们确保公共函数不会调用任何随机性 API。但是，我们仍然允许用户通过在公共函数中添加属性 `#[lint::allow_unsafe_randomness]` 来做出此选择。

如果一个 `public` 函数直接或间接调用随机性 API，恶意用户可以滥用此函数的可组合性，如果结果不符合期望则中止交易。这允许用户不断尝试，直到获得有利的结果，从而破坏了随机性。

### 12.1.1 易受攻击的代码示例

`randomness_example.move`
```rust
module user::lottery {
    fun mint_to_user(user: &signer) {
        move_to(user, WIN {});
    }
 
    #[lint::allow_unsafe_randomness]
    public entry fun play(user: &signer) {
        let random_value = aptos_framework::randomness::u64_range(0, 100);
        if (random_value == 42) {
            mint_to_user(user);
        }
    }
}
```

在这个示例中，`play` 函数是 `public` 的，允许它与其他模块组合。恶意用户可以调用此函数，然后检查是否获胜。如果没有获胜，他们可以中止交易并再次尝试。

`randomness_example.move`
```rust
module attacker::exploit {
    entry fun exploit(attacker: &signer) {
        @user::lottery::play(attacker);
        assert!(exists<@user::lottery::WIN>(address_of(attacker)));
    }
}
```

要解决可能的问题，只需将直接或间接调用随机性 API 的所有函数的可见性设置为 `entry` 而不是 `public` 或 `public entry` 即可。

### 12.1.2 安全代码示例

randomness_example.move

```rust
module user::lottery {
    fun mint_to_user(user: &signer) {
        move_to(user, WIN {});
    }
 
    #[lint::allow_unsafe_randomness]
    entry fun play(user: &signer) {
        let random_value = aptos_framework::randomness::u64_range(0, 100);
        if (random_value == 42) {
            mint_to_user(user);
        }
    }
}
```

## 12.2 随机性 -  低 Gas 攻击

当函数中的不同代码路径消耗不同数量的燃气时，攻击者可以操纵燃气限制来影响结果。让我们看一个不同路径消耗不同燃气量的示例。

### 12.2.1 易受攻击的代码示例

`randomness_example.move`
```rust
module user::lottery {
 
    //transfer 10 aptos from admin to user
    fun win(user: &signer) {
        let admin_signer = &get_admin_signer();
        let aptos_metadata = get_aptos_metadata();
        primary_fungible_store::transfer(admin_signer, aptos_metadata, address_of(user),10);
    }
 
    //transfer 10 aptos from user to admin, then 1 aptos from admin to fee_admin
    fun lose(user: &signer) {
 
        //user to admin
        let aptos_metadata = get_aptos_metadata();
        primary_fungible_store::transfer(user, aptos_metadata, @admin, 10);
 
        //admin to fee_admin
        let admin_signer = &get_admin_signer();
        primary_fungible_store::transfer(admin_signer, aptos_metadata, @fee_admin, 1);
    }
 
    #[randomness]
    entry fun play(user: &signer) {
        let random_value = aptos_framework::randomness::u64_range(0, 100);
        if (random_value == 42) {
            win(user);
        } else {
            lose(user);
        }
    }
}
```

在这个彩票示例中，`win` 和 `lose` 消耗不同数量的燃气。`lose` 函数消耗的燃气比 `win` 函数多。攻击者可以设置足够 `win` 但不足 `lose` 的最大燃气限制。这会在采取 `lose` 路径时强制交易中止，确保用户永远不会执行 `lose` 路径。然后，用户可以反复调用该函数，直到获胜。

### 12.2.2 安全代码示例

有不同的方法来保护代码：

1. 确保更好的结果使用更多或相同的燃气作为更差的结果。
2. 只允许管理员地址调用随机性 API。
3. 确保入口函数无论随机结果如何都能工作。这可以通过提交随机结果，然后在不同的交易中使用随机结果来提供操作来处理。避免基于随机性的即时操作以保持燃气使用的一致性。

> 我们将来会提供更多的功能，以使更复杂的代码能够抵御低 Gas 攻击。

