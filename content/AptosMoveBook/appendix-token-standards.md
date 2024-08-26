---
title: 附录：Aptos Token 标准
tags:
  - MoveOnAptos
date: 2024-07-05
aliases:
  - 附录：Aptos Token 标准
---
[查看原文](https://learn.aptoslabs.com/example/aptogotchi-intermediate/demo)

# 1. 可替代资产（Fungible Assets，FA）

>[!TIP] 提示
>如果您想了解可替代资产，或者在 Aptos 上相当于 [[ERC-20]] 的内容，这是您应该阅读的教程。

## 1.1 概述

可替代资产是一种可互换且与不能与同类其他资产区分的资产类型，通常代表货币或股票等资产。

### 1.1.1 Coins 与可替代资产（FA）

Aptos 有两个类似 ERC-20 的标准：Coin（传统）和 Fungible Asset。截至 2024 年 4 月，我们正处于从 Coin 到 Fungible Asset 的迁移阶段。Fungible Asset 基于 Object，比 Coin 提供了更多的灵活性和效率。

目前 Aptos 上的 DEX 仅支持 “Coin”，但我们正在努力使其尽快支持 “Fungible Asset”，目标是在 2024 年中期完成。

### 1.1.2 何时使用可替代资产或 Coin？

在我们的[示例](https://aptogotchi-intermediate.aptoslabs.com/)中，Aptogotchi 的食物是我们想要创建许多相同副本以购买、转移和食用的东西。这将是 Aptos Token 标准中 FA 的一个完美用例。

[Aptogotchi 示例源代码](https://github.com/aptos-labs/aptogotchi-intermediate/blob/main/move/sources/food.move)

### 1.1.3 创建可替代资产

```rust
const FOOD_FA_OBJECT_SEED: vector<u8> = b"APTOGOTCHI_FOOD";
struct FoodController has key {
    /// 用于铸造可替代资产。
    fungible_asset_mint_ref: MintRef,
    /// 用于销毁可替代资产。
    fungible_asset_burn_ref: BurnRef,
}
fun create_food_token(creator: &signer) {
    // 创建一个对象，因为简而言之，可替代资产是具有可替代性的对象。
    let constructor_ref = &object::create_named_object(account, FOOD_FA_OBJECT_SEED);
    let food_fa_signer = &object::generate_signer(constructor_ref);
    // 使用该对象创建可替代资产。
    primary_fungible_store::create_primary_store_enabled_fungible_asset(
        constructor_ref,
        option::none(),
        string::utf8(FOOD_NAME),
        string::utf8(FOOD_SYMBOL),
        0,
        string::utf8(FOOD_URI),
        string::utf8(PROJECT_URI),
    );
    let fungible_asset_mint_ref = fungible_asset::generate_mint_ref(constructor_ref);
    let fungible_asset_burn_ref = fungible_asset::generate_burn_ref(constructor_ref);
    // 将 FA 引用作为 FoodController 资源存储在食物对象下。
    move_to(food_fa_signer, FoodController {
        fungible_asset_mint_ref,
        fungible_asset_burn_ref,
    });
}
```

### 1.1.4 参考

**引用**（refs）是在 Aptos 中跨不同标准实现粒度权限控制的手段。在 FA 标准中，我们有三种引用：

- `MintRef` - 可以使用此引用 mint 更多资产。
- `TransferRef` - 在持有相同元数据的 `FungibleStore` 中的 `frozen` 翻转。如果为真，则存储 `frozen`，因此在不使用引用的情况下，任何人都无法向此存储 `deposit` 或 `withdraw`
- `BurnRef` - 可以使用此引用 burn 资产。

### 1.1.5 铸造 / 销毁 Fungible Tokens

用户只有在持有 `MintRef` 和 `BurnRef` 时才能执行铸造和销毁。在 Aptogotchi 应用中，我们针对购买食物和食用食物功能调用这两个函数。

```rust
public(friend) fun mint_food(user: &signer, amount: u64) acquires FoodToken {
    let food_token = borrow_global<FoodToken>(get_food_token_address());
    let fungible_asset_mint_ref = &food_token.fungible_asset_mint_ref;
    primary_fungible_store::deposit(
        address_of(user),
        fungible_asset::mint(fungible_asset_mint_ref, amount),
    );
}
public(friend) fun burn_food(user: &signer, amount: u64) acquires FoodToken {
    let food_token = borrow_global<FoodToken>(get_food_token_address());
    primary_fungible_store::burn(&food_token.fungible_asset_burn_ref, address_of(user), amount);
}
```

### 1.1.6 检查余额

通过输入所有者地址和 token 类型，我们可以直接调用 `primary_fungible_store::balance` 来获取资产余额。

```rust
#[view]
/// 返回所有者的食物令牌余额
public fun get_food_balance(owner_addr: address): u64 {
    let food_token = object::address_to_object<FoodToken>(get_food_token_address());
    primary_fungible_store::balance(owner_addr, food_token)
}
```

### 1.1.7 为您的可替代令牌添加价格

我们可以为可替代令牌设置价格，并启动从用户到合同（或单独的费用收集器）的硬币转移。

请注意，`buy_food` 函数在 `main` 模块中定义，而不是在 `food` 模块中。为确保只有 `main` 模块可以调用`mint_food` 和 `burn_food`，我们将这两个函数标记为 `public (friend)`，并将 `main` 声明为 `food` 模块的 `friend`

```rust
module aptogotchi::food {
    friend aptogotchi::main;
    public(friend) fun mint_food(user: &signer, amount: u64) acquires FoodToken {
        //...
    }
    public(friend) fun burn_food(user: &signer, amount: u64) acquires FoodToken {
        //...
    }
}

module aptogotchi::main{
    use aptogotchi::food;
    public entry fun buy_food(owner: &signer, amount: u64) {
        // 为食物收取价格
        coin::transfer<AptosCoin>(owner, @aptogotchi, UNIT_PRICE * amount);
        food::mint_food(owner, amount);
    }
}
```




# 2. 数字资产（Digital Assets）

>[!TIP] 提示
>如果您想了解 NFT（非同质化代币），或者 Aptos 上相当于 [[ERC-721]] 的内容，这是您应当阅读的教程。

## 2.1 概述

**数字资产** 推荐给任何想要构建 NFT（非同质化代币）的新集合或协议使用。它提供了可扩展性以定制更丰富的功能。

在这里，我们将重点关注组合性方面。

### 2.1.1 为什么选择数字资产？

数字资产使用 [Aptos 对象](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-framework/sources/object.move)，而不是传统上在 Move 中使用的账户资源。这允许在账户之外存储数据，并以这种方式增加灵活性。

- token 可以轻松地用自定义数据和功能进行扩展，而无需对框架进行任何更改。
- 转移仅仅是引用更新。
- 无需选择即可直接转移。
- NFT 可以拥有其他 NFT，增加了易于组合性。
- 灵魂绑定 token 可以轻松得到支持。

如果您熟悉 Aptos 代币 V1（旧标准），那么数字资产是我们强烈推荐使用的新标准。

[Aptogotchi 示例源代码](https://github.com/aptos-labs/aptogotchi-intermediate/blob/main/move/sources/aptogotchi.move)

### 2.1.2 数字资产组合

- 数字资产是对象，并且可以被另一个对象拥有。这意味着我们可以将多个 NFT 组合成一个单一的 NFT。
- 在我们的示例中，用户可以铸造一个领结作为 NFT。当 Aptogotchi 佩戴领结时，领结 NFT 的所有权从用户转移到 Aptogotchi NFT。

```rust
public entry fun create_accessory(user: &signer, category: String) acquires ObjectController {
    let uri = string::utf8(ACCESSORY_COLLECTION_URI);
    let description = string::utf8(ACCESSORY_COLLECTION_DESCRIPTION);
    let constructor_ref = token::create_named_token(
        &get_app_signer(get_app_signer_address()),
        string::utf8(ACCESSORY_COLLECTION_NAME),
        description,
        get_accessory_token_name(&address_of(user), category),
        option::none(),
        uri,
    );
    let token_signer = object::generate_signer(&constructor_ref);
    let transfer_ref = object::generate_transfer_ref(&constructor_ref);
    let category = string::utf8(ACCESSORY_CATEGORY_BOWTIE);
    let id = 1;
    let accessory = Accessory {
        category,
        id,
    };
    move_to(&token_signer, accessory);
    object::transfer_with_ref(object::generate_linear_transfer_ref(&transfer_ref), address_of(user));
}
```

- 用户还可以通过将领结从 Aptogotchi 转移回给自己来分解 Aptogotchi 和领结。这样，领结将再次出现在用户的钱包中。

```rust
public entry fun unwear_accessory(owner: &signer, category: String) acquires ObjectController {
    let owner_addr = &address_of(owner);
    // 按类别检索配饰对象
    let accessory_address = get_accessory_address(owner_addr, category);
    let has_accessory = exists<Accessory>(accessory_address);
    if (has_accessory == false) {
        assert!(false, error::unavailable(EACCESSORY_NOT_AVAILABLE));
    };
    let accessory = object::address_to_object<Accessory>(accessory_address);
    object::transfer(owner, accessory, address_of(owner));
}
```

### 2.1.3 数字资产转移

对于数字资产，转移是引用的更新。没有数据从一个账户移动到另一个账户。

有 3 个 API 可用于转移代币：

- 由于数字资产是对象，当操作由所有者执行时，我们可以使用 `object::transfer`。
- 当持有 `transferRef` 时，我们还可以使用 `object::transfer_with_ref(transfer_ref, to_addr)` 进行转移。这允许管理员在实际上不拥有代币的情况下转移代币。
- 如果我们将所有权转移到一个对象而不是用户，我们可以使用 `object::transfer_to_object(owner, object, to_object)`。

```rust
public entry fun wear_accessory(owner: &signer, category: String) acquires ObjectController {
    let owner_addr = &address_of(owner);
    // 检索 Aptogotchi 对象
    let token_address = get_aptogotchi_address(owner_addr);
    let gotchi = object::address_to_object<Aptogotchi>(token_address);
    // 按类别检索配饰对象
    let accessory_address = get_accessory_address(owner_addr, category);
    let accessory = object::address_to_object<Accessory>(accessory_address);
    object::transfer_to_object(owner, accessory, gotchi);
}
```



# 3. 对象模型

对象是数字资产和可替代资产的构建基石。虽然在不深入了解对象的情况下创建和使用这些资产是可行的，但拥有这方面的知识能够显著增强您有效管理和使用它们的能力。

## 3.1 概述

**对象**是 Aptos Move 中的核心原语，通过 `0x1::object` 中的对象模块创建。对象支持**数字资产标准**和**可替代资产标准**。

对象是存储在单个地址内的资源的容器。这些资源通常代表经常一起访问的相关数据，并且应该存储在单个地址中以实现数据局部性和节省成本。

### 3.1.1 对象创建

对象创建函数都返回一个临时的 `ConstructorRef`，它不能被存储。`ConstructorRef` 允许向对象添加资源。`ConstructorRef` 还可用于生成

```rust
/// 创建一个可以删除的对象。
public fun create_object(creator: &signer): ConstructorRef;
/// 创建一个不可删除的对象。
public fun create_sticky_object(creator: &signer): ConstructorRef;
/// 创建一个不可删除的命名对象。
/// 知道用于创建它们的种子，可以全局查询命名对象。
public fun create_named_object(creator: &signer, seed: vector<u8>): ConstructorRef;
/// 使用创建者地址和种子获取命名对象的地址。
public fun create_object_address(source: &address, seed: vector<u8>): address;
```

### 3.1.2 对象能力

有一些能力（或 `引用`）我们经常用于管理对象，它们只能在对象创建时使用构造函数引用生成：

```rust
/// 生成从全局存储中删除对象的引用。
public fun generate_delete_ref(ref: &ConstructorRef): DeleteRef;
/// 生成向对象添加新事件和资源的引用。
public fun generate_extend_ref(ref: &ConstructorRef): ExtendRef;
/// 生成管理对象转移的引用。
public fun generate_transfer_ref(ref: &ConstructorRef): TransferRef;
```

### 3.1.3 扩展对象

在 Aptogotchi 中，我们有一个函数 `upgrade_aptogotchi_with_battle_extension`，持有者可以调用它用新的战斗扩展来升级他们的 Aptogotchi。此函数将使用 Aptogotchi NFT 对象的 `extend_ref` 向对象添加新资源。

```rust
struct AptogotchiBattleExt has key {
    attack_point: u64,
    defence_point: u64,
}
#[view]
public fun get_aptogotchi_address(creator_addr: address): (address) {
    let token_address = token::create_token_address(
        &get_app_signer_address(),
        &string::utf8(APTOGOTCHI_COLLECTION_NAME),
        &get_aptogotchi_token_name(creator_addr),
    );
    token_address
}
public entry fun upgrade_aptogotchi_with_battle_extension(owner: &signer) acquires Aptogotchi {
    let owner_addr = address_of(owner);
    assert!(has_aptogotchi(owner_addr), error::unavailable(E_APTOGOTCHI_DOES_NOT_EXIST));
    let gotchi_address = get_aptogotchi_address(owner_addr);
    // 每个地址最多只能持有同一类型的 1 个资源
    assert!(!has_battle_ext(gotchi_address), E_BATTLE_EXTENSION_EXISTS);
    let gotchi = borrow_global<Aptogotchi>(gotchi_address);
    let gotchi_signer = generate_signer_for_extending(&gotchi.extend_ref);
    move_to(&gotchi_signer, AptogotchiBattleExt {
        attack_point: 1,
        defence_point: 2,
    });
}
```

# 4. 教程完成

恭喜您完成了本教程！[分叉源代码](https://github.com/aptos-labs/aptogotchi-intermediate/fork)并开始个性化您自己的 Aptogotchi dApp。您可以随意添加新功能并扩展其能力。

**下一步：自己尝试**

想要快速构建一个生产就绪的端到端 “数字资产” 或 “可替代资产” dapp？了解更多关于我们的[create-aptos-dapp](https://aptos.dev/create-aptos-dapp/index)工具，以便在 Aptos 网络上轻松引导。