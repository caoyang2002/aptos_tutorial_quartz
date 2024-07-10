---
title: Aptos-Smart-Table
---
[toc]

## 引入模块

```rust
use 0x1::aptos_hash;
use 0x1::error;
use 0x1::math64;
use 0x1::simple_map;
use 0x1::table_with_length;
use 0x1::type_info;
use 0x1::vector;
```

## 结构体 Entry

SmartTable 条目包含键和值。

```rust
struct Entry<K, V> has copy, drop, store
Fields
hash: u64
key: K
value: V
```

## 结构体 SmartTable

```rust
struct SmartTable<K, V> has store
Fields
buckets: table_with_length::TableWithLength<u64, vector<smart_table::Entry<K, V>>>
num_buckets: u64
level: u8
size: u64
split_load_threshold: u8
target_bucket_size: u64
```

## 常数

```rust
const ENOT_EMPTY: u64 = 3;
```
不能销毁非空的哈希映射。

```rust
const ENOT_FOUND: u64 = 1;
```
在智能表中未找到键。

```rust
const EALREADY_EXIST: u64 = 4;
```
键已存在。

```rust
const EEXCEED_MAX_BUCKET_SIZE: u64 = 7;
```
目标桶大小无效。

```rust
const EINVALID_LOAD_THRESHOLD_PERCENT: u64 = 5;
```
触发分割的负载阈值百分比无效。

```rust
const EINVALID_TARGET_BUCKET_SIZE: u64 = 6;
```
智能表容量必须大于0。

```rust
const EZERO_CAPACITY: u64 = 2;
```

## 函数

### `new`

创建一个具有默认配置的空 SmartTable。

```rust
public fun new<K: copy, drop, store, V: store>(): smart_table::SmartTable<K, V>
```

实现

```rust
public fun new<K: copy + drop + store, V: store>(): SmartTable<K, V> {
    new_with_config<K, V>(0, 0, 0)
}
```

### `new_with_config`

使用自定义配置创建一个空 SmartTable。num_initial_buckets: 初始化时桶的数量。0 表示使用默认值。split_load_threshold: 一旦达到，将触发分割的百分比数字。0 表示使用默认值。target_bucket_size: 每个桶的目标条目数，不保证。0 表示未设置，将由合约代码动态分配。

```rust
public fun new_with_config<K: copy, drop, store, V: store>(num_initial_buckets: u64, split_load_threshold: u8, target_bucket_size: u64): smart_table::SmartTable<K, V>
```

实现

```rust
public fun new_with_config<K: copy + drop + store, V: store>(
    num_initial_buckets: u64,
    split_load_threshold: u8,
    target_bucket_size: u64
): SmartTable<K, V> {
    assert!(split_load_threshold <= 100, error::invalid_argument(EINVALID_LOAD_THRESHOLD_PERCENT));
    let buckets = table_with_length::new();
    table_with_length::add(&mut buckets, 0, vector::empty());
    let table = SmartTable {
        buckets,
        num_buckets: 1,
        level: 0,
        size: 0,
        // 默认的分割负载阈值是 75%。
        split_load_threshold: if (split_load_threshold == 0) { 75 } else { split_load_threshold },
        target_bucket_size,
    };
    // 默认的初始桶数是 2。
    if (num_initial_buckets == 0) {
        num_initial_buckets = 2;
    };
    while (num_initial_buckets > 1) {
        num_initial_buckets = num_initial_buckets - 1;
        split_one_bucket(&mut table);
    };
    table
}
```

### `destroy_empty`

销毁空表。如果不是空的，则中止。

```rust
public fun destroy_empty<K, V>(table: smart_table::SmartTable<K, V>)
```

实现

```rust
public fun destroy_empty<K, V>(table: SmartTable<K, V>) {
    assert!(table.size == 0, error::invalid_argument(ENOT_EMPTY));
    let i = 0;
    while (i < table.num_buckets) {
        vector::destroy_empty(table_with_length::remove(&mut table.buckets, i));
        i = i + 1;
    };
    let SmartTable { buckets, num_buckets: _, level: _, size: _, split_load_threshold: _, target_bucket_size: _ } = table;
    table_with_length::destroy_empty(buckets);
}
```

### `destroy`

当 V 有 drop 时，完全销毁表。

```rust
public fun destroy<K: drop, V: drop>(table: smart_table::SmartTable<K, V>)
```

实现

```rust
public fun destroy<K: drop, V: drop>(table: SmartTable<K, V>) {
    clear(&mut table);
    destroy_empty(table);
}
```

### `clear`

当 T 有 drop 时，完全清除表。

```rust
public fun clear<K: drop, V: drop>(table: &mut smart_table::SmartTable<K, V>)
```

实现

```rust
public fun clear<K: drop, V: drop>(table: &mut SmartTable<K, V>) {
    *table_with_length::borrow_mut(&mut table.buckets, 0) = vector::empty();
    let i = 1;
    while (i < table.num_buckets) {
        table_with_length::remove(&mut table.buckets, i);
        i = i + 1;
    };
    table.num_buckets = 1;
    table.level = 0;
    table.size = 0;
}
```

### `add`

在哈希映射中添加 (key, value) 对，如果当前负载因子超过阈值，可能会增加一个桶。注意它可能不会分割实际溢出的桶。相反，它由 num_buckets 和 level 决定。对于标准线性哈希算法，它被存储为一个变量，但这里的 num_buckets 可以利用。如果键已存在，则中止。注意：当触发桶分割时，此方法可能会偶尔消耗更多的 gas。

```rust
public fun add<K, V>(table: &mut smart_table::SmartTable<K, V>, key: K, value: V)
```

实现

```rust
public fun add<K, V>(table: &mut SmartTable<K, V>, key: K, value: V) {
    let hash = sip_hash_from_value(&key);
    let index = bucket_index(table.level, table.num_buckets, hash);
    let bucket = table_with_length::borrow_mut(&mut table.buckets, index);
    // 我们在这里为每个桶设置了一个上限限制，一个上限（10000），通常没人会达到。
    assert!(vector::length(bucket) <= 10000, error::permission_denied(EEXCEED_MAX_BUCKET_SIZE));
    assert!(vector::all(bucket, | entry | {
        let e: &Entry<K, V> = entry;
        &e.key != &key
    }), error::invalid_argument(EALREADY_EXIST));
    let e = Entry { hash, key, value };
    if (table.target_bucket_size == 0) {
        let estimated_entry_size = max(size_of_val(&e), 1);
        table.target_bucket_size = max(1024 /* free_write_quota */ / estimated_entry_size, 1);
    };
    vector::push_back(bucket, e);
    table.size = table.size + 1;

    if (load_factor(table) >= (table.split_load_threshold as u64)) {
        split_one_bucket(table);
    }
}
```

### `add_all`

将多个键/值对添加到智能表中。键不能已经存在。

```rust
public fun add_all<K, V>(table: &mut smart_table::SmartTable<K, V>, keys: vector<K>, values: vector<V>)
```

实现

```rust
public fun add_all<K, V>(table: &mut SmartTable<K, V>, keys: vector<K>, values: vector<V>) {
    vector::zip(keys, values, |key, value| { add(table, key, value); });
}
```

### `unzip_entries`

```rust
fun unzip_entries<K: copy, V: copy>(entries: &vector<smart_table::Entry<K, V>>): (vector<K>, vector<V>)
```

实现

```rust
inline fun unzip_entries<K: copy, V: copy>(entries: &vector<Entry<K, V>>): (vector<K>, vector<V>) {
    let keys = vector[];
    let values = vector[];
    vector::for_each_ref(entries, |e|{
        let entry: &Entry<K, V> =  e;
        vector::push_back(&mut keys, entry.key);
        vector::push_back(&mut values, entry.value);
    });
    (keys, values)
}
```

### `to_simple_map`

将智能表转换为 simple_map，这通常应该由视图函数调用，以获得整个表的原子视图。免责声明：这个函数可能成本很高，因为智能表的大小可能非常庞大。请自行斟酌使用。

```rust
public fun to_simple_map<K: copy, drop, store, V: copy, store>(table: &smart_table::SmartTable<K, V>): simple_map::SimpleMap<K, V>
```

实现

```rust
public fun to_simple_map<K: store + copy + drop, V: store + copy>(
    table: &SmartTable<K, V>,
): SimpleMap<K, V> {
    let i = 0;
    let res = simple_map::new<K, V>();
    while (i < table.num_buckets) {
        let (keys, values) = unzip_entries(table_with_length::borrow(&table.buckets, i));
        simple_map::add_all(&mut res, keys, values);
        i = i + 1;
    };
    res
}
```

### `split_one_bucket`

决定下一个要分割的桶，并将其分割为两个，桶内的元素也一并分割。

```rust
fun split_one_bucket<K, V>(table: &mut smart_table::SmartTable<K, V>)
```

实现

```rust
fun split_one_bucket<K, V>(table: &mut SmartTable<K, V>) {
    let new_bucket_index = table.num_buckets;
    // 下一个要分割的桶是 num_bucket 没有最高有效位。
    let to_split = new_bucket_index ^ (1 << table.level);
    table.num_buckets = new_bucket_index + 1;
    // 如果整个级别已经分割过一次，那么提升级别。
    if (to_split + 1 == 1 << table.level) {
        table.level = table.level + 1;
    };
    let old_bucket = table_with_length::borrow_mut(&mut table.buckets, to_split);
    // 分割桶，[0..p) 保留在旧桶中，[p..len) 移至新桶
    let p = vector::partition(old_bucket, |e| {
        let entry: &Entry<K, V> = e; // 显式类型以满足编译器
        bucket_index(table.level, table.num_buckets, entry.hash) != new_bucket_index
    });
    let new_bucket = vector::trim_reverse(old_bucket, p);
    table_with_length::add(&mut table.buckets, new_bucket_index, new_bucket);
}
```

### `bucket_index`

返回预期的桶索引以找到哈希。基本上，它根据目标桶索引与下一个要分割的桶的索引的比较，使用不同的基数 1 << level 与 1 << (level + 1) 在模运算中。

```rust
fun bucket_index(level: u8, num_buckets: u64, hash: u64): u64
```

实现

```rust
fun bucket_index(level: u8, num_buckets: u64, hash: u64): u64 {
    let index = hash % (1 << (level + 1));
    if (index < num_buckets) {
        // 在现有的桶中
        index
    } else {
        // 在未分割的桶中
        index % (1 << level)
    }
}
```

### `borrow`

获取 key 映射到的 value 的不可变引用。如果没有 key 的条目，则中止。

```rust
public fun borrow<K: drop, V>(table: &smart_table::SmartTable<K, V>, key: K): &V
```

实现

```rust
public fun borrow<K: drop, V>(table: &SmartTable<K, V>, key: K): &V {
    let index = bucket_index(table.level, table.num_buckets, sip_hash_from_value(&key));
    let bucket = table_with_length::borrow(&table.buckets, index);
    let i = 0;
    let len = vector::length(bucket);
    while (i < len) {
        let entry = vector::borrow(bucket, i);
        if (&entry.key == &key) {
            return &entry.value
        };
        i = i + 1;
    };
    abort error::invalid_argument(ENOT_FOUND)
}
```

### `borrow_with_default`

获取 key 映射到的值的不可变引用。如果没有键的条目，则返回指定的默认值。

```rust
public fun borrow_with_default<K: copy, drop, V>(table: &smart_table::SmartTable<K, V>, key: K, default: &V): &V
```

实现

```rust
public fun borrow_with_default<K: copy + drop, V>(table: &SmartTable<K, V>, key: K, default: &V): &V {
    if (!contains(table, copy key)) {
        default
    } else {
        borrow(table, copy key)
    }
}
```

### `borrow_mut`

获取 key 映射到的值的可变引用。如果没有键的条目，则中止。

```rust
public fun borrow_mut<K: drop, V>(table: &mut smart_table::SmartTable<K, V>, key: K): &mut V
```

实现

```rust
public fun borrow_mut<K: drop, V>(table: &mut SmartTable<K, V>, key: K): &mut V {
    let index = bucket_index(table.level, table.num_buckets, sip_hash_from_value(&key));
    let bucket = table_with_length::borrow_mut(&mut table.buckets, index);
    let i = 0;
    let len = vector::length(bucket);
    while (i < len) {
        let entry = vector::borrow_mut(bucket, i);
        if (&entry.key == &key) {
            return &mut entry.value
        };
        i = i + 1;
    };
    abort error::invalid_argument(ENOT_FOUND)
}
```

### `borrow_mut_with_default`

获取 key 映射到的值的可变引用。如果没有键的条目，则首先插入 (key, default) 对。

```rust
public fun borrow_mut_with_default<K: copy, drop, V: drop>(table: &mut smart_table::SmartTable<K, V>, key: K, default: V): &mut V
```

实现

```rust
public fun borrow_mut_with_default<K: copy + drop, V: drop>(
    table: &mut SmartTable<K, V>,
    key: K,
    default: V
): &mut V {
    if (!contains(table, copy key)) {
        add(table, copy key, default)
    };
    borrow_mut(table, key)
}
```

### `contains`

如果表包含键的条目，则返回 true。

```rust
public fun contains<K: drop, V>(table: &smart_table::SmartTable<K, V>, key: K): bool
```

实现

```rust
public fun contains<K: drop, V>(table: &SmartTable<K, V>, key: K): bool {
    let hash = sip_hash_from_value(&key);
    let index = bucket_index(table.level, table.num_buckets, hash);
    let bucket = table_with_length::borrow(&table.buckets, index);
    vector::any(bucket, | entry | {
        let e: &Entry<K, V> = entry;
        e.hash == hash && &e.key == &key
    })
}
```

### `remove`

从表中移除并返回 key 映射到的值。如果没有键的条目，则中止。

```rust
public fun remove<K: copy, drop, V>(table: &mut smart_table::SmartTable<K, V>, key: K): V
```

实现

```rust
public fun remove<K: copy + drop, V>(table: &mut SmartTable<K, V>, key: K): V {
    let index = bucket_index(table.level, table.num_buckets, sip_hash_from_value(&key));
    let bucket = table_with_length::borrow_mut(&mut table.buckets, index);
    let i = 0;
    let len = vector::length(bucket);
    while (i < len) {
        let entry = vector::borrow(bucket, i);
        if (&entry.key == &key) {
            let Entry { hash: _, key: _, value } = vector::swap_remove(bucket, i);
            table.size = table.size - 1;
            return value
        };
        i = i + 1;
    };
    abort error::invalid_argument(ENOT_FOUND)
}
```

### `upsert`

如果键没有条目，则插入 (key, value) 对。否则，将键的条目值更新为 value。

```rust
public fun upsert<K: copy, drop , V: drop>(table: &mut smart_table::SmartTable<K, V>, key: K, value: V)
```

实现

```rust
public fun upsert<K: copy + drop, V: drop>(table: &mut SmartTable<K, V>, key: K, value: V) {
    if (!contains(table, copy key)) {
        add(table, copy key, value)
    } else {
        let ref = borrow_mut(table, key);
        *ref = value;
    };
}
```

### `length`

返回表的长度，即条目数。

```rust
public fun length<K, V>(table: &smart_table::SmartTable<K, V>): u64
```

实现

```rust
public fun length<K, V>(table: &SmartTable<K, V>): u64 {
    table.size
}
```

### `load_factor`

返回哈希表的负载因子。

```rust
public fun load_factor<K, V>(table: &smart_table::SmartTable<K, V>): u64
```

实现

```rust
public fun load_factor<K, V>(table: &SmartTable<K, V>): u64 {
    table.size * 100 / table.num_buckets / table.target_bucket_size
}
```

### `update_split_load_threshold`

更新 split_load_threshold。

```rust
public fun update_split_load_threshold<K, V>(table: &mut smart_table::SmartTable<K, V>, split_load_threshold: u8)
```

实现

```rust
public fun update_split_load_threshold<K, V>(table: &mut SmartTable<K, V>, split_load_threshold: u8) {
    assert!(
        split_load_threshold <= 100 && split_load_threshold > 0,
        error::invalid_argument(EINVALID_LOAD_THRESHOLD_PERCENT)
    );
    table.split_load_threshold = split_load_threshold;
}
```

### `update_target_bucket_size`

更新 target_bucket_size。

```rust
public fun update_target_bucket_size<K, V>(table: &mut smart_table::SmartTable<K, V>, target_bucket_size: u64)
```

实现

```rust
public fun update_target_bucket_size<K, V>(table: &mut SmartTable<K, V>, target_bucket_size: u64) {
    assert!(target_bucket_size > 0, error::invalid_argument(EINVALID_TARGET_BUCKET_SIZE));
    table.target_bucket_size = target_bucket_size;
}
```

### `for_each_ref`

对表中的每个键值对的引用应用函数。

```rust
public fun for_each_ref<K, V>(table: &smart_table::SmartTable<K, V>, f: |(&K, &V)|())
```

实现

```rust
public inline fun for_each_ref<K, V>(table: &SmartTable<K, V>, f: |&K, &V|) {
    let i = 0;
    while (i < aptos_std::smart_table::num_buckets(table)) {
        vector::for_each_ref(
            aptos_std::table_with_length::borrow(aptos_std::smart_table::borrow_buckets(table), i),
            |elem| {
                let (key, value) = aptos_std::smart_table::borrow_kv(elem);
                f(key, value)
            }
        );
        i = i + 1;
    }
}
```

### `for_each_mut`

对表中每个键值对的可变引用应用函数。

```rust
public fun for_each_mut<K, V>(table: &mut smart_table::SmartTable<K, V>, f: |(&K, &mut V)|())
```

实现

```rust
public inline fun for_each_mut<K, V>(table: &mut SmartTable<K, V>, f: |&K, &mut V|) {
    let i = 0;
    while (i < aptos_std::smart_table::num_buckets(table)) {
        vector::for_each_mut(
            table_with_length::borrow_mut(aptos_std::smart_table::borrow_buckets_mut(table), i),
            |elem| {
                let (key, value) = aptos_std::smart_table::borrow_kv_mut(elem);
                f(key, value)
            }
        );
        i = i + 1;
    };
}
```

### `map_ref`

在不修改表的情况下，对表中的键值对引用应用函数。

```rust
public fun map_ref<K: copy, drop, store, V1, V2: store>(table: &smart_table::SmartTable<K, V1>, f: |&V1|V2): smart_table::SmartTable<K, V2>
```

实现

```rust
public inline fun map_ref<K: copy + drop + store, V1, V2: store>(
    table: &SmartTable<K, V1>,
    f: |&V1|V2
): SmartTable<K, V2> {
    let new_table = new<K, V2>();
    for_each_ref(table, |key, value| add(&mut new_table, *key, f(value)));
    new_table
}
```

### `any`

如果表中的任何键值对满足条件，则返回 true。

```rust
public fun any<K, V>(table: &smart_table::SmartTable<K, V>, p: |(&K, &V)|bool): bool
```

实现

```rust
public inline fun any<K, V>(
    table: &SmartTable<K, V>,
    p: |&K, &V|bool
): bool {
    let found = false;
    let i = 0;
    while (i < aptos_std::smart_table::num_buckets(table)) {
        found = vector::any(table_with_length::borrow(aptos_std::smart_table::borrow_buckets(table), i), |elem| {
            let (key, value) = aptos_std::smart_table::borrow_kv(elem);
            p(key, value)
        });
        if (found) break;
        i = i + 1;
    };
    found
}
```

### `borrow_kv`

辅助函数用于规避内联函数的作用域问题。

```rust
public fun borrow_kv<K, V>(e: &smart_table::Entry<K, V>): (&K, &V)
```

实现

```rust
public fun borrow_kv<K, V>(e: &Entry<K, V>): (&K, &V) {
    (&e.key, &e.value)
}
```

### `borrow_kv_mut`

```rust
public fun borrow_kv_mut<K, V>(e: &mut smart_table::Entry<K, V>): (&mut K, &mut V)
```

实现

```rust
public fun borrow_kv_mut<K, V>(e: &mut Entry<K, V>): (&mut K, &mut V) {
    (&mut e.key, &mut e.value)
}
```

### `num_buckets`

```rust
public fun num_buckets<K, V>(table: &smart_table::SmartTable<K, V>): u64
```

实现

```rust
public fun num_buckets<K, V>(table: &SmartTable<K, V>): u64 {
    table.num_buckets
}
```

### `borrow_buckets`

```rust
public fun borrow_buckets<K, V>(table: &smart_table::SmartTable<K, V>): &table_with_length::TableWithLength<u64, vector<smart_table::Entry<K, V>>>
```

实现

```rust
public fun borrow_buckets<K, V>(table: &SmartTable<K, V>): &TableWithLength<u64, vector<Entry<K, V>>> {
    &table.buckets
}
```

### `borrow_buckets_mut`

```rust
public fun borrow_buckets_mut<K, V>(table: &mut smart_table::SmartTable<K, V>): &mut table_with_length::TableWithLength<u64, vector<smart_table::Entry<K, V>>>
```

实现

```rust
public fun borrow_buckets_mut<K, V>(table: &mut SmartTable<K, V>): &mut TableWithLength<u64, vector<Entry<K, V>>> {
    &mut table.buckets
}
```

## 规范（Specification）

### 结构体 SmartTable

```rust
struct SmartTable<K, V> has store
buckets: table_with_length::TableWithLength<u64, vector<smart_table::Entry<K, V>>>
num_buckets: u64
level: u8
size: u64
split_load_threshold: u8
target_bucket_size: u64
```

### 函数 `new_with_config`

```rust
public fun new_with_config<K: copy, drop, store, V: store>(num_initial_buckets: u64, split_load_threshold: u8, target_bucket_size: u64): smart_table::SmartTable<K, V>
```

pragma verify = false;

### 函数 `destroy`

```rust
public fun destroy<K: drop, V: drop>(table: smart_table::SmartTable<K, V>)
```

pragma verify = false;

### 函数 `clear`

```rust
public fun clear<K: drop, V: drop>(table: &mut smart_table::SmartTable<K, V>)
```

pragma verify = false;

### 函数 `add_all`

```rust
public fun add_all<K, V>(table: &mut smart_table::SmartTable<K, V>, keys: vector<K>, values: vector<V>)
```

pragma verify = false;

### 函数 `to_simple_map`

```rust
public fun to_simple_map<K: copy, drop, store, V: copy, store>(table: &smart_table::SmartTable<K, V>): simple_map::SimpleMap<K, V>
```

pragma verify = false;

### 函数 `split_one_bucket`

```rust
fun split_one_bucket<K, V>(table: &mut smart_table::SmartTable<K, V>)
```

pragma verify = false;

### 函数 `bucket_index`

```rust
fun bucket_index(level: u8, num_buckets: u64, hash: u64): u64
```

pragma verify = false;

### 函数 `borrow_with_default`

```rust
public fun borrow_with_default<K: copy, drop, V>(table: &smart_table::SmartTable<K, V>, key: K, default: &V): &V
```

pragma verify = false;

### 函数 `load_factor`

```rust
public fun load_factor<K, V>(table: &smart_table::SmartTable<K, V>): u64
```

pragma verify = false;

### 函数 `update_split_load_threshold`

```rust
public fun update_split_load_threshold<K, V>(table: &mut smart_table::SmartTable<K, V>, split_load_threshold: u8)
```

pragma verify = false;

### 函数 `update_target_bucket_size`

```rust
public fun update_target_bucket_size<K, V>(table: &mut smart_table::SmartTable<K, V>, target_bucket_size: u64)
```

pragma verify = false;

### 函数 `borrow_kv`

```rust
public fun borrow_kv<K, V>(e: &smart_table::Entry<K, V>): (&K, &V)
```

pragma verify = false;

### 函数 `borrow_kv_mut`

```rust
public fun borrow_kv_mut<K, V>(e: &mut smart_table::Entry<K, V>): (&mut K, &mut V)
```

pragma verify = false;

### 函数 `num_buckets`

```rust
public fun num_buckets<K, V>(table: &smart_table::SmartTable<K, V>): u64
```

pragma verify = false;

### 函数 `borrow_buckets`

```rust
public fun borrow_buckets<K, V>(table: &smart_table::SmartTable<K, V>): &table_with_length::TableWithLength<u64, vector<smart_table::Entry<K, V>>>
```

pragma verify = false;

### 函数 `borrow_buckets_mut`

```rust
public fun borrow_buckets_mut<K, V>(table: &mut smart_table::SmartTable<K, V>): &mut table_with_length::TableWithLength<u64, vector<smart_table::Entry<K, V>>>
```

pragma verify = false;

### 原生函数（native functions）

```rust
native fun spec_len<K, V>(t: SmartTable<K, V>): num;
native fun spec_contains<K, V>(t: SmartTable<K, V>, k: K): bool;
native fun spec_set<K, V>(t: SmartTable<K, V>, k: K, v: V): SmartTable<K, V>;
native fun spec_remove<K, V>(t: SmartTable<K, V>, k: K): SmartTable<K, V>;
native fun spec_get<K, V>(t: SmartTable<K, V>, k: K): V;
```
