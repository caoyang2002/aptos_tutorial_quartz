---
title: 实现一个计数器
---
```rust
 token::index<Token>(object::object_from_constructor_ref(&token_cref));
```


```
// 如果/当需要访问创建它的交易中的代币索引，
// 以设置额外的特定于应用程序的字段，才需要添加此方法。
//
// 此方法允许并行铸造，使其高效。
// fun index_snapshot<T: key>(token: &Object<T>): AggregatorSnapshot<u64> acquires Token, TokenIdentifiers {
//     let token_address = object::object_address(token);
//     if (exists<TokenIdentifiers>(token_address)) {
//         aggregator_v2::copy_snapshot(&borrow_global<TokenIdentifiers>(token_address).index)
//     } else {
//         aggregator_v2::create_snapshot(borrow(token).index)
//     }
// }

// 避免在代币被铸造的同一交易中使用此方法，
// 因为这将禁止并行执行交易。
#[view]
public fun index<T: key>(token: Object<T>): u64 acquires Token, TokenIdentifiers {
    let token_address = object::object_address(&token);
    // 检查 `token_address` 是否存在于 `TokenIdentifiers` 资源中：
    if (exists<TokenIdentifiers>(token_address)) {
        aggregator_v2::read_snapshot(&borrow_global<TokenIdentifiers>(token_address).index)
    } else {
        borrow(&token).index
    }
}
```