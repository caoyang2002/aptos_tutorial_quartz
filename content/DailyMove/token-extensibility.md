---
title: 如何更改 Token 的 URI
---
```yaml
original: 
  author: Greg
  url: https://x.com/Greg_Nazario/status/1757283491468005672
note: 纯机翻、未核对
```

>[!NOTE] 问题
> 最新的一集来自一位 builder 向我提问：
> 
> “在 token 创建后，我如何改变 token 的 URI ？”
> 
> 实际的代码示例展示了如何改变 URI，然后扩展到了扩展token / 对象，甚至在源代码中 burn 它们。
>
> 你是否一直在想，人们在 Aptos NFTs 上谈论的这种可扩展性是什么？

让我们通过一个简单的例子，由创建者分配 point 给 token 来解释。让我们在 [DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)中深入了解它

通常对于一个应用程序，人们可能认为他们必须从一开始就把所有的数据搞定，我们明白有时作为创建者，你希望能够稍后修改事物。

Digital Asset 标准和 Aptos 上的 Object 标准的伟大之处在于，对象可以被扩展。

在下面，你可以看到一个集合，这个集合简单地存储扩展和变异器引用以后来修改功能。这些必须在创建时指定。

![https://pbs.twimg.com/media/GGMd8CAbUAEijHQ?format=jpg&name=medium](https://pbs.twimg.com/media/GGMd8CAbUAEijHQ?format=jpg&name=medium)

MutatorRef 对于 token / collection 而言是特殊的。在这种情形下，collection 的 MutatorRef 允许进行诸如设置集合的 URI 或描述等操作。 

在这种情况下，我们有点小狡猾，我们允许集合的创建者和所有者都对其进行更改。

![https://pbs.twimg.com/media/GGMeIa5aQAAgcFK?format=jpg&name=medium](https://pbs.twimg.com/media/GGMeIa5aQAAgcFK?format=jpg&name=medium)

然而，`ExtendRef` 更加强大。我们实际上可以在事后向 `collection` 添加积分。

就像积分已经在 `collection` 中一样，具有可扩展性！

![https://pbs.twimg.com/media/GGMeZolbgAAiNxW?format=jpg&name=900x900](https://pbs.twimg.com/media/GGMeZolbgAAiNxW?format=jpg&name=900x900)

![https://pbs.twimg.com/media/GGMehH8bQAA7m6F?format=png&name=900x900](https://pbs.twimg.com/media/GGMehH8bQAA7m6F?format=png&name=900x900)

但是，token 呢？

`token` 也可以通过扩展引用、`mutator ref` 和 `burn ref` 来扩展和修改。这些必须在创建时指定。

![https://pbs.twimg.com/media/GGMe0fmaMAA6eME?format=jpg&name=medium](https://pbs.twimg.com/media/GGMe0fmaMAA6eME?format=jpg&name=medium)

扩展引用让我们可以做一些令人惊奇的事情！我们实际上可以检查集合是否设置了积分，并分发它们并扩展 `token`

这意味着我们可以为游戏和其他有趣的 token 扩展后续添加许多功能。

![https://pbs.twimg.com/media/GGMfKe5aYAAJ8_K?format=jpg&name=medium](https://pbs.twimg.com/media/GGMfKe5aYAAJ8_K?format=jpg&name=medium)

`mutator` 引用让我们可以更改 URI、描述和名称，而 `burn` 引用让我们可以 burn 代币！

![https://pbs.twimg.com/media/GGMfbMlaEAAJ5VF?format=jpg&name=medium](https://pbs.twimg.com/media/GGMfbMlaEAAJ5VF?format=jpg&name=medium)



![https://pbs.twimg.com/media/GGMfdQyasAA7-9i?format=jpg&name=small](https://pbs.twimg.com/media/GGMfdQyasAA7-9i?format=jpg&name=small)

查看函数也可以使用这些扩展，这使得它完全可以扩展到任何应用程序。

![https://pbs.twimg.com/media/GGMfnceaMAAWCM1?format=jpg&name=medium](https://pbs.twimg.com/media/GGMfnceaMAAWCM1?format=jpg&name=medium)

感谢阅读这一集[DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)如往常一样，查看这里的源代码： [modify_nfts.move#L179-L195](https://github.com/aptos-labs/daily-move/blob/main/snippets/modifying-nfts/sources/modify_nfts.move#L179-L195)

>[!WARNING] 警告
>中文注释在 Move 源码中不可被编译


```rust
// 修改NFTs
// 这是一个示例，展示了如何修改 NFT 和 collection的属性。

module deploy_addr::modify_nfts {

    use std::option;
    use std::signer;
    use std::string;
    use std::string::String;
    use aptos_framework::object;
    use aptos_framework::object::Object;
    use aptos_token_objects::aptos_token;
    use aptos_token_objects::collection;
    use aptos_token_objects::token;

    /// 只有创建者可以更改 AptosToken 的 URI
    const E_NOT_CREATOR: u64 = 1;
    /// 只有创建者或所有者可以更改 Token 的 URI
    const E_NOT_CREATOR_OR_OWNER: u64 = 2;
    /// 集合点已初始化
    const E_COLLECTION_ALREADY_EXTENDED: u64 = 3;
    /// 集合点尚未初始化
    const E_COLLECTION_NOT_EXTENDED: u64 = 4;
    /// 集合没有足够的点数分配给token
    const E_NOT_ENOUGH_POINTS: u64 = 5;

    /// 集合最大供应量
    const MAX_SUPPLY: u64 = 10000;

    /// 我们这里使用的URI用于演示，这可以是任何东西，mp4、ipfs、svg、png、gif、jpg等。
    const URI: vector<u8> = b"https://aptosfoundation.org/_next/static/media/globe.f620f2d6.svg";

    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    /// 用于控制集合属性的项目的结构体
    struct CollectionController has key {
        extend_ref: object::ExtendRef,
        mutator_ref: collection::MutatorRef,
    }

    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    /// 表示集合扩展的结构体
    struct CollectionPoints has key {
        total_points: u64
    }

    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    /// 用于控制token属性的项目的结构体
    struct TokenController has key {
        extend_ref: object::ExtendRef,
        mutator_ref: token::MutatorRef,
        burn_ref: token::BurnRef,
    }

    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    /// 表示token扩展的结构体
    struct TokenPoints has key {
        points: u64
    }

    /// 创建一个集合，大部分项目都默认设置，以便于此函数使用
    entry fun create_simple_collection(caller: &signer, collection_name: String, description: String) {
        aptos_token::create_collection(
            caller,
            description,
            MAX_SUPPLY,
            collection_name,
            string::utf8(URI),
            true, // 集合描述可变
            true, // 集合版税可变
            true, // 集合URI可变
            true, // token描述可变
            true, // token名称可变
            true, // token属性可变
            true, // Token URI可变
            true, // token可烧毁
            true, // token可冻结
            0, // 版税分子
            100, // 版式分母
        );
    }

    entry fun mint_simple_token(creator: &signer, collection: String, token_name: String) {
        aptos_token::mint(
            creator,
            collection,
            string::utf8(b""), // 描述
            token_name,
            string::utf8(URI),
            vector[], // 属性键
            vector[], // 属性类型
            vector[], // 属性值
        )
    }

    /// 让我们创建一个自定义集合，这个集合没有版税，并且类似于
    entry fun create_custom_collection(caller: &signer, collection_name: String, description: String) {
        // 创建集合
        let constructor_ref = collection::create_fixed_collection(
            caller,
            description,
            MAX_SUPPLY,
            collection_name,
            option::none(), // 没有版税
            string::utf8(URI),
        );

        // 在这里，您可以扩展集合以做任何事情，对象的神奇之处！

        // 存储mutator ref以稍后修改集合属性
        // 生成extend ref以稍后扩展集合
        let extend_ref = object::generate_extend_ref(&constructor_ref);
        let mutator_ref = collection::generate_mutator_ref(&constructor_ref);
        let object_signer = object::generate_signer(&constructor_ref);
        move_to(&object_signer, CollectionController { extend_ref, mutator_ref });
    }

    /// 向集合添加积分
    entry fun add_points_to_collection(
        caller: &signer,
        collection: Object<CollectionController>,
        total_points: u64,
    ) acquires CollectionController {
        // 检查集合是否已经扩展
        let collection_address = object::object_address(&collection);
        assert!(!exists<CollectionPoints>(collection_address), E_COLLECTION_ALREADY_EXTENDED);

        // 创建者或所有者可以为扩展向集合添加积分
        let caller_address = signer::address_of(caller);
        let is_owner = object::is_owner(collection, caller_address);
        let is_creator = caller_address == collection::creator(collection);
        assert!(is_owner || is_creator, E_NOT_CREATOR_OR_OWNER);

        // 扩展集合对象，现在有一个积分系统
        let controller = borrow_global<CollectionController>(collection_address);
        let object_signer = object::generate_signer_for_extending(&controller.extend_ref);
        move_to(&object_signer, CollectionPoints {
            total_points
        })
    }

    /// 让NFT的所有者或创建者更改URI
    entry fun change_custom_collection_uri(
        caller: &signer,
        collection: Object<CollectionController>,
        new_uri: String
    ) acquires CollectionController {
        // 验证调用者是NFT的所有者或创建者
        let caller_address = signer::address_of(caller);
        let is_owner = object::is_owner(collection, caller_address);
        let is_creator = caller_address == collection::creator(collection);
        assert!(is_owner || is_creator, E_NOT_CREATOR_OR_OWNER);

        // 在token上设置URI
        let token_address = object::object_address(&collection);
        let mutator_ref = &borrow_global<CollectionController>(token_address).mutator_ref;
        collection::set_uri(mutator_ref, new_uri);
    }

    /// 让我们创建一个自定义代币，看起来类似于AptosToken
    entry fun create_custom_token(caller: &signer, collection_name: String, token_name: String) {
        // 以完全可并行化的方式创建代币
        let constructor_ref = token::create(
            caller,
            collection_name,
            string::utf8(b""), // 描述
            token_name,
            option::none(), // 无版税
            string::utf8(URI),
        );

        // 在这里，您可以扩展代币以执行任何操作，包括使其可替代！

        // 创建一个mutator引用，以便以后更改属性
        // 并创建一个burn引用，以便以后燃烧代币
        // 扩展引用，以便以后扩展代币
        let extend_ref = object::generate_extend_ref(&constructor_ref);
        let mutator_ref = token::generate_mutator_ref(&constructor_ref);
        let burn_ref = token::generate_burn_ref(&constructor_ref);
        let object_signer = object::generate_signer(&constructor_ref);
        move_to(&object_signer, TokenController { extend_ref, burn_ref, mutator_ref });
    }

    /// 让NFT的所有者或创建者更改URI
    entry fun change_custom_token_uri(
        caller: &signer,
        token: Object<TokenController>,
        new_uri: String
    ) acquires TokenController {
        // 验证调用者是NFT的所有者还是创建者
        let caller_address = signer::address_of(caller);
        let is_owner = object::is_owner(token, caller_address);
        let is_creator = caller_address == token::creator(token);
        assert!(is_owner || is_creator, E_NOT_CREATOR_OR_OWNER);

        // 在代币上设置URI
        let token_address = object::object_address(&token);
        let mutator_ref = &borrow_global<TokenController>(token_address).mutator_ref;
        token::set_uri(mutator_ref, new_uri);
    }

    /// 燃烧代币！让所有者或创建者来执行
    entry fun burn_custom_token(
        caller: &signer,
        token: Object<TokenController>
    ) acquires TokenController, TokenPoints {
        // 验证调用者是NFT的所有者还是创建者
        let caller_address = signer::address_of(caller);
        let is_owner = object::is_owner(token, caller_address);
        let is_creator = caller_address == token::creator(token);
        assert!(is_owner || is_creator, E_NOT_CREATOR_OR_OWNER);

        // 如果代币已扩展，则燃烧积分！
        let token_address = object::object_address(&token);
        if (exists<TokenPoints>(token_address)) {
            let TokenPoints {
                points: _
            } = move_from<TokenPoints>(token_address);
        };

        // 燃烧代币
        // 具体来说，我们想要move_from，以便我们可以清理对象的所有资源
        let TokenController {
            burn_ref,
            extend_ref: _, // 销毁扩展引用
            mutator_ref: _, // 也销毁mutator引用
        } = move_from<TokenController>(token_address);
        token::burn(burn_ref)
    }

    /// 让创建者向代币添加积分
    entry fun extend_token(
        caller: &signer,
        token: Object<TokenController>,
        points: u64,
    ) acquires TokenController, CollectionPoints, TokenPoints {
        // 验证调用者是NFT的创建者
        let caller_address = signer::address_of(caller);
        let is_creator = caller_address == token::creator(token);
        assert!(is_creator, E_NOT_CREATOR);

        // 确保代币附加了积分
        let token_address = object::object_address(&token);
        if (!exists<TokenPoints>(token_address)) {
            let token_controller = borrow_global<TokenController>(token_address);
            let object_signer = object::generate_signer_for_extending(&token_controller.extend_ref);
            move_to(&object_signer, TokenPoints {
                points: 0
            });
        };

        // 检索共享积分
        let collection = token::collection_object(token);
        let collection_address = object::object_address(&collection);
        let collection_points = borrow_global_mut<CollectionPoints>(collection_address);

        // 确保我们有足够的积分给予代币
        assert!(collection_points.total_points >= points, E_NOT_ENOUGH_POINTS);

        // 将积分转移到代币
        collection_points.total_points = collection_points.total_points - points;
        let token_points = borrow_global_mut<TokenPoints>(token_address);
        token_points.points = token_points.points + points;
    }

    #[view]
    public fun collection_points(collection: Object<CollectionController>): u64 acquires CollectionPoints {
        let collection_address = object::object_address(&collection);
        if (exists<CollectionPoints>(collection_address)) {
            borrow_global<CollectionPoints>(collection_address).total_points
        } else {
            0
        }
    }

    #[view]
    public fun token_points(token: Object<TokenController>): u64 acquires TokenPoints {
        let token_address = object::object_address(&token);
        if (exists<TokenPoints>(token_address)) {
            borrow_global<TokenPoints>(token_address).points
        } else {
            0
        }
    }
}
```