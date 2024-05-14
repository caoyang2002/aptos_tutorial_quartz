# 翻译标准库

> 思路：
>
> 1. 定翻译规则
> 2. 给翻译示例

`````text
翻译````中的内容，
翻译规则：
1. 翻译完成的内容用 "````"包裹
2. 代码用 “```”包裹，
3. 其原格式是简单的函数名，然后是完整函数签名，最后是完整函数实现，不要更改原格式
4. 如果遇到英文语句， 则结合其下方的代码块将英文语句翻译为中文，
5. 如果代码上方没有解释请添加解释，在解释前面添加："AI注"
6. 原文的 Implementation 上下方都是代码块，请不要修改



以下是示例：
翻译前：

````
Constants

Index out of range.

const EINVALID_INDEX: u64 = 2;
An invalid UTF8 encoding.

const EINVALID_UTF8: u64 = 1;
Function utf8

Creates a new string from a sequence of bytes. Aborts if the bytes do not represent valid utf8.

public fun utf8(bytes: vector<u8>): string::String
Implementation
public fun utf8(bytes: vector<u8>): String {
    assert!(internal_check_utf8(&bytes), EINVALID_UTF8);
    String{bytes}
}

Function log2

public fun log2(x: u64): fixed_point32::FixedPoint32
Implementation
public fun log2(x: u64): FixedPoint32 {
    let integer_part = floor_log2(x);
    // Normalize x to [1, 2) in fixed point 32.
    let y = (if (x >= 1 << 32) {
        x >> (integer_part - 32)
    } else {
        x << (32 - integer_part)
    } as u128);
    let frac = 0;
    let delta = 1 << 31;
    while (delta != 0) {
        // log x = 1/2 log x^2
        // x in [1, 2)
        y = (y * y) >> 32;
        // x is now in [1, 4)
        // if x in [2, 4) then log x = 1 + log (x / 2)
        if (y >= (2 << 32)) { frac = frac + delta; y = y >> 1; };
        delta = delta >> 1;
    };
    fixed_point32::create_from_raw_value (((integer_part as u64) << 32) + frac)
}


````


翻译后：
````
## 常数

超出索引范围

```rust
const EINVALID_INDEX: u64 = 2;
```

无效的UTF8编码。

```rust
const EINVALID_UTF8: u64 = 1;
```

## 函数


### `utf8`

从字节序列创建一个新的字符串。如果字节序列不表示有效的 UTF-8，则会中止。

```rust
public fun utf8(bytes: vector<u8>): string::String
```

实现

```rust
public fun utf8(bytes: vector<u8>): String {
    assert!(internal_check_utf8(&bytes), EINVALID_UTF8);
    String{bytes}
}
```

## 函数

### `log2`

AI注：计算以2为底的对数的函数，名为log2。它接受一个无符号64位整数x作为输入，并返回一个 `fixed_point32::FixedPoint32` 类型的值，这个类型代表了一个定点数，能够以 `32` 位的精度表示一个固定小数点的数值。

```rust
public fun log2(x: u64): fixed_point32::FixedPoint32
```

实现

```rust
public fun log2(x: u64): FixedPoint32 {
    let integer_part = floor_log2(x);
    // Normalize x to [1, 2) in fixed point 32.
    let y = (if (x >= 1 << 32) {
        x >> (integer_part - 32)
    } else {
        x << (32 - integer_part)
    } as u128);
    let frac = 0;
    let delta = 1 << 31;
    while (delta != 0) {
        // log x = 1/2 log x^2
        // x in [1, 2)
        y = (y * y) >> 32;
        // x is now in [1, 4)
        // if x in [2, 4) then log x = 1 + log (x / 2)
        if (y >= (2 << 32)) { frac = frac + delta; y = y >> 1; };
        delta = delta >> 1;
    };
    fixed_point32::create_from_raw_value (((integer_part as u64) << 32) + frac)
}
```

````
清不要把函数签名省略掉

开始翻译：
````
use 0x1::aptos_hash;
use 0x1::error;
use 0x1::math64;
use 0x1::simple_map;
use 0x1::table_with_length;
use 0x1::type_info;
use 0x1::vector;
Struct Entry

SmartTable entry contains both the key and value.

struct Entry<K, V> has copy, drop, store
Fields
hash: u64
key: K
value: V
Struct SmartTable

struct SmartTable<K, V> has store
Fields
buckets: table_with_length::TableWithLength<u64, vector<smart_table::Entry<K, V>>>
num_buckets: u64
level: u8
size: u64
split_load_threshold: u8
target_bucket_size: u64
Constants

Cannot destroy non-empty hashmap

const ENOT_EMPTY: u64 = 3;
Key not found in the smart table

const ENOT_FOUND: u64 = 1;
Key already exists

const EALREADY_EXIST: u64 = 4;
Invalid target bucket size.

const EEXCEED_MAX_BUCKET_SIZE: u64 = 7;
Invalid load threshold percent to trigger split.

const EINVALID_LOAD_THRESHOLD_PERCENT: u64 = 5;
Invalid target bucket size.

const EINVALID_TARGET_BUCKET_SIZE: u64 = 6;
Smart table capacity must be larger than 0

const EZERO_CAPACITY: u64 = 2;
Function new

Create an empty SmartTable with default configurations.

public fun new<K: copy, drop, store, V: store>(): smart_table::SmartTable<K, V>
Implementation
public fun new<K: copy + drop + store, V: store>(): SmartTable<K, V> {
    new_with_config<K, V>(0, 0, 0)
}
Function new_with_config

Create an empty SmartTable with customized configurations. num_initial_buckets: The number of buckets on initialization. 0 means using default value. split_load_threshold: The percent number which once reached, split will be triggered. 0 means using default value. target_bucket_size: The target number of entries per bucket, though not guaranteed. 0 means not set and will dynamically assgined by the contract code.

public fun new_with_config<K: copy, drop, store, V: store>(num_initial_buckets: u64, split_load_threshold: u8, target_bucket_size: u64): smart_table::SmartTable<K, V>
Implementation
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
        // The default split load threshold is 75%.
        split_load_threshold: if (split_load_threshold == 0) { 75 } else { split_load_threshold },
        target_bucket_size,
    };
    // The default number of initial buckets is 2.
    if (num_initial_buckets == 0) {
        num_initial_buckets = 2;
    };
    while (num_initial_buckets > 1) {
        num_initial_buckets = num_initial_buckets - 1;
        split_one_bucket(&mut table);
    };
    table
}
Function destroy_empty

Destroy empty table. Aborts if it's not empty.

public fun destroy_empty<K, V>(table: smart_table::SmartTable<K, V>)
Implementation
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
Function destroy

Destroy a table completely when V has drop.

public fun destroy<K: drop, V: drop>(table: smart_table::SmartTable<K, V>)
Implementation
public fun destroy<K: drop, V: drop>(table: SmartTable<K, V>) {
    clear(&mut table);
    destroy_empty(table);
}
Function clear

Clear a table completely when T has drop.

public fun clear<K: drop, V: drop>(table: &mut smart_table::SmartTable<K, V>)
Implementation
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
Function add

Add (key, value) pair in the hash map, it may grow one bucket if current load factor exceeds the threshold. Note it may not split the actual overflowed bucket. Instead, it was determined by num_buckets and level. For standard linear hash algorithm, it is stored as a variable but num_buckets here could be leveraged. Abort if key already exists. Note: This method may occasionally cost much more gas when triggering bucket split.

public fun add<K, V>(table: &mut smart_table::SmartTable<K, V>, key: K, value: V)
Implementation
public fun add<K, V>(table: &mut SmartTable<K, V>, key: K, value: V) {
    let hash = sip_hash_from_value(&key);
    let index = bucket_index(table.level, table.num_buckets, hash);
    let bucket = table_with_length::borrow_mut(&mut table.buckets, index);
    // We set a per-bucket limit here with a upper bound (10000) that nobody should normally reach.
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
Function add_all

Add multiple key/value pairs to the smart table. The keys must not already exist.

public fun add_all<K, V>(table: &mut smart_table::SmartTable<K, V>, keys: vector<K>, values: vector<V>)
Implementation
public fun add_all<K, V>(table: &mut SmartTable<K, V>, keys: vector<K>, values: vector<V>) {
    vector::zip(keys, values, |key, value| { add(table, key, value); });
}
Function unzip_entries

fun unzip_entries<K: copy, V: copy>(entries: &vector<smart_table::Entry<K, V>>): (vector<K>, vector<V>)
Implementation
inline fun unzip_entries<K: copy, V: copy>(entries: &vector<Entry<K, V>>): (vector<K>, vector<V>) {
    let keys = vector[];
    let values = vector[];
    vector::for_each_ref(entries, |e|{
        let entry: &Entry<K, V> = e;
        vector::push_back(&mut keys, entry.key);
        vector::push_back(&mut values, entry.value);
    });
    (keys, values)
}
Function to_simple_map

Convert a smart table to a simple_map, which is supposed to be called mostly by view functions to get an atomic view of the whole table. Disclaimer: This function may be costly as the smart table may be huge in size. Use it at your own discretion.

public fun to_simple_map<K: copy, drop, store, V: copy, store>(table: &smart_table::SmartTable<K, V>): simple_map::SimpleMap<K, V>
Implementation
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
Function split_one_bucket

Decide which is the next bucket to split and split it into two with the elements inside the bucket.

fun split_one_bucket<K, V>(table: &mut smart_table::SmartTable<K, V>)
Implementation
fun split_one_bucket<K, V>(table: &mut SmartTable<K, V>) {
    let new_bucket_index = table.num_buckets;
    // the next bucket to split is num_bucket without the most significant bit.
    let to_split = new_bucket_index ^ (1 << table.level);
    table.num_buckets = new_bucket_index + 1;
    // if the whole level is splitted once, bump the level.
    if (to_split + 1 == 1 << table.level) {
        table.level = table.level + 1;
    };
    let old_bucket = table_with_length::borrow_mut(&mut table.buckets, to_split);
    // partition the bucket, [0..p) stays in old bucket, [p..len) goes to new bucket
    let p = vector::partition(old_bucket, |e| {
        let entry: &Entry<K, V> = e; // Explicit type to satisfy compiler
        bucket_index(table.level, table.num_buckets, entry.hash) != new_bucket_index
    });
    let new_bucket = vector::trim_reverse(old_bucket, p);
    table_with_length::add(&mut table.buckets, new_bucket_index, new_bucket);
}
Function bucket_index

Return the expected bucket index to find the hash. Basically, it use different base 1 << level vs 1 << (level + 1) in modulo operation based on the target bucket index compared to the index of the next bucket to split.

fun bucket_index(level: u8, num_buckets: u64, hash: u64): u64
Implementation
fun bucket_index(level: u8, num_buckets: u64, hash: u64): u64 {
    let index = hash % (1 << (level + 1));
    if (index < num_buckets) {
        // in existing bucket
        index
    } else {
        // in unsplitted bucket
        index % (1 << level)
    }
}
Function borrow

Acquire an immutable reference to the value which key maps to. Aborts if there is no entry for key.

public fun borrow<K: drop, V>(table: &smart_table::SmartTable<K, V>, key: K): &V
Implementation
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
Function borrow_with_default

Acquire an immutable reference to the value which key maps to. Returns specified default value if there is no entry for key.

public fun borrow_with_default<K: copy, drop, V>(table: &smart_table::SmartTable<K, V>, key: K, default: &V): &V
Implementation
public fun borrow_with_default<K: copy + drop, V>(table: &SmartTable<K, V>, key: K, default: &V): &V {
    if (!contains(table, copy key)) {
        default
    } else {
        borrow(table, copy key)
    }
}
Function borrow_mut

Acquire a mutable reference to the value which key maps to. Aborts if there is no entry for key.

public fun borrow_mut<K: drop, V>(table: &mut smart_table::SmartTable<K, V>, key: K): &mut V
Implementation
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
Function borrow_mut_with_default

Acquire a mutable reference to the value which key maps to. Insert the pair (key, default) first if there is no entry for key.

public fun borrow_mut_with_default<K: copy, drop, V: drop>(table: &mut smart_table::SmartTable<K, V>, key: K, default: V): &mut V
Implementation
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
Function contains

Returns true iff table contains an entry for key.

public fun contains<K: drop, V>(table: &smart_table::SmartTable<K, V>, key: K): bool
Implementation
public fun contains<K: drop, V>(table: &SmartTable<K, V>, key: K): bool {
    let hash = sip_hash_from_value(&key);
    let index = bucket_index(table.level, table.num_buckets, hash);
    let bucket = table_with_length::borrow(&table.buckets, index);
    vector::any(bucket, | entry | {
        let e: &Entry<K, V> = entry;
        e.hash == hash && &e.key == &key
    })
}
Function remove

Remove from table and return the value which key maps to. Aborts if there is no entry for key.

public fun remove<K: copy, drop, V>(table: &mut smart_table::SmartTable<K, V>, key: K): V
Implementation
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
Function upsert

Insert the pair (key, value) if there is no entry for key. update the value of the entry for key to value otherwise

public fun upsert<K: copy, drop, V: drop>(table: &mut smart_table::SmartTable<K, V>, key: K, value: V)
Implementation
public fun upsert<K: copy + drop, V: drop>(table: &mut SmartTable<K, V>, key: K, value: V) {
    if (!contains(table, copy key)) {
        add(table, copy key, value)
    } else {
        let ref = borrow_mut(table, key);
        *ref = value;
    };
}
Function length

Returns the length of the table, i.e. the number of entries.

public fun length<K, V>(table: &smart_table::SmartTable<K, V>): u64
Implementation
public fun length<K, V>(table: &SmartTable<K, V>): u64 {
    table.size
}
Function load_factor

Return the load factor of the hashtable.

public fun load_factor<K, V>(table: &smart_table::SmartTable<K, V>): u64
Implementation
public fun load_factor<K, V>(table: &SmartTable<K, V>): u64 {
    table.size * 100 / table.num_buckets / table.target_bucket_size
}
Function update_split_load_threshold

Update split_load_threshold.

public fun update_split_load_threshold<K, V>(table: &mut smart_table::SmartTable<K, V>, split_load_threshold: u8)
Implementation
public fun update_split_load_threshold<K, V>(table: &mut SmartTable<K, V>, split_load_threshold: u8) {
    assert!(
        split_load_threshold <= 100 && split_load_threshold > 0,
        error::invalid_argument(EINVALID_LOAD_THRESHOLD_PERCENT)
    );
    table.split_load_threshold = split_load_threshold;
}
Function update_target_bucket_size

Update target_bucket_size.

public fun update_target_bucket_size<K, V>(table: &mut smart_table::SmartTable<K, V>, target_bucket_size: u64)
Implementation
public fun update_target_bucket_size<K, V>(table: &mut SmartTable<K, V>, target_bucket_size: u64) {
    assert!(target_bucket_size > 0, error::invalid_argument(EINVALID_TARGET_BUCKET_SIZE));
    table.target_bucket_size = target_bucket_size;
}
Function for_each_ref

Apply the function to a reference of each key-value pair in the table.

public fun for_each_ref<K, V>(table: &smart_table::SmartTable<K, V>, f: |(&K, &V)|())
Implementation
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
Function for_each_mut

Apply the function to a mutable reference of each key-value pair in the table.

public fun for_each_mut<K, V>(table: &mut smart_table::SmartTable<K, V>, f: |(&K, &mut V)|())
Implementation
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
Function map_ref

Map the function over the references of key-value pairs in the table without modifying it.

public fun map_ref<K: copy, drop, store, V1, V2: store>(table: &smart_table::SmartTable<K, V1>, f: |&V1|V2): smart_table::SmartTable<K, V2>
Implementation
public inline fun map_ref<K: copy + drop + store, V1, V2: store>(
    table: &SmartTable<K, V1>,
    f: |&V1|V2
): SmartTable<K, V2> {
    let new_table = new<K, V2>();
    for_each_ref(table, |key, value| add(&mut new_table, *key, f(value)));
    new_table
}
Function any

Return true if any key-value pair in the table satisfies the predicate.

public fun any<K, V>(table: &smart_table::SmartTable<K, V>, p: |(&K, &V)|bool): bool
Implementation
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
Function borrow_kv

public fun borrow_kv<K, V>(e: &smart_table::Entry<K, V>): (&K, &V)
Implementation
public fun borrow_kv<K, V>(e: &Entry<K, V>): (&K, &V) {
    (&e.key, &e.value)
}
Function borrow_kv_mut

public fun borrow_kv_mut<K, V>(e: &mut smart_table::Entry<K, V>): (&mut K, &mut V)
Implementation
public fun borrow_kv_mut<K, V>(e: &mut Entry<K, V>): (&mut K, &mut V) {
    (&mut e.key, &mut e.value)
}
Function num_buckets

public fun num_buckets<K, V>(table: &smart_table::SmartTable<K, V>): u64
Implementation
public fun num_buckets<K, V>(table: &SmartTable<K, V>): u64 {
    table.num_buckets
}
Function borrow_buckets

public fun borrow_buckets<K, V>(table: &smart_table::SmartTable<K, V>): &table_with_length::TableWithLength<u64, vector<smart_table::Entry<K, V>>>
Implementation
public fun borrow_buckets<K, V>(table: &SmartTable<K, V>): &TableWithLength<u64, vector<Entry<K, V>>> {
    &table.buckets
}
Function borrow_buckets_mut

public fun borrow_buckets_mut<K, V>(table: &mut smart_table::SmartTable<K, V>): &mut table_with_length::TableWithLength<u64, vector<smart_table::Entry<K, V>>>
Implementation
public fun borrow_buckets_mut<K, V>(table: &mut SmartTable<K, V>): &mut TableWithLength<u64, vector<Entry<K, V>>> {
    &mut table.buckets
}
Specification

Struct SmartTable

struct SmartTable<K, V> has store
buckets: table_with_length::TableWithLength<u64, vector<smart_table::Entry<K, V>>>
num_buckets: u64
level: u8
size: u64
split_load_threshold: u8
target_bucket_size: u64
pragma intrinsic = map,
    map_new = new,
    map_destroy_empty = destroy_empty,
    map_len = length,
    map_has_key = contains,
    map_add_no_override = add,
    map_add_override_if_exists = upsert,
    map_del_must_exist = remove,
    map_borrow = borrow,
    map_borrow_mut = borrow_mut,
    map_borrow_mut_with_default = borrow_mut_with_default,
    map_spec_get = spec_get,
    map_spec_set = spec_set,
    map_spec_del = spec_remove,
    map_spec_len = spec_len,
map_spec_has_key = spec_contains;
Function new_with_config

public fun new_with_config<K: copy, drop, store, V: store>(num_initial_buckets: u64, split_load_threshold: u8, target_bucket_size: u64): smart_table::SmartTable<K, V>
pragma verify = false;
Function destroy

public fun destroy<K: drop, V: drop>(table: smart_table::SmartTable<K, V>)
pragma verify = false;
Function clear

public fun clear<K: drop, V: drop>(table: &mut smart_table::SmartTable<K, V>)
pragma verify = false;
Function add_all

public fun add_all<K, V>(table: &mut smart_table::SmartTable<K, V>, keys: vector<K>, values: vector<V>)
pragma verify = false;
Function to_simple_map

public fun to_simple_map<K: copy, drop, store, V: copy, store>(table: &smart_table::SmartTable<K, V>): simple_map::SimpleMap<K, V>
pragma verify = false;
Function split_one_bucket

fun split_one_bucket<K, V>(table: &mut smart_table::SmartTable<K, V>)
pragma verify = false;
Function bucket_index

fun bucket_index(level: u8, num_buckets: u64, hash: u64): u64
pragma verify = false;
Function borrow_with_default

public fun borrow_with_default<K: copy, drop, V>(table: &smart_table::SmartTable<K, V>, key: K, default: &V): &V
pragma verify = false;
Function load_factor

public fun load_factor<K, V>(table: &smart_table::SmartTable<K, V>): u64
pragma verify = false;
Function update_split_load_threshold

public fun update_split_load_threshold<K, V>(table: &mut smart_table::SmartTable<K, V>, split_load_threshold: u8)
pragma verify = false;
Function update_target_bucket_size

public fun update_target_bucket_size<K, V>(table: &mut smart_table::SmartTable<K, V>, target_bucket_size: u64)
pragma verify = false;
Function borrow_kv

public fun borrow_kv<K, V>(e: &smart_table::Entry<K, V>): (&K, &V)
pragma verify = false;
Function borrow_kv_mut

public fun borrow_kv_mut<K, V>(e: &mut smart_table::Entry<K, V>): (&mut K, &mut V)
pragma verify = false;
Function num_buckets

public fun num_buckets<K, V>(table: &smart_table::SmartTable<K, V>): u64
pragma verify = false;
Function borrow_buckets

public fun borrow_buckets<K, V>(table: &smart_table::SmartTable<K, V>): &table_with_length::TableWithLength<u64, vector<smart_table::Entry<K, V>>>
pragma verify = false;
Function borrow_buckets_mut

public fun borrow_buckets_mut<K, V>(table: &mut smart_table::SmartTable<K, V>): &mut table_with_length::TableWithLength<u64, vector<smart_table::Entry<K, V>>>
pragma verify = false;
native fun spec_len<K, V>(t: SmartTable<K, V>): num;
native fun spec_contains<K, V>(t: SmartTable<K, V>, k: K): bool;
native fun spec_set<K, V>(t: SmartTable<K, V>, k: K, v: V): SmartTable<K, V>;
native fun spec_remove<K, V>(t: SmartTable<K, V>, k: K): SmartTable<K, V>;
native fun spec_get<K, V>(t: SmartTable<K, V>, k: K): V;
````
`````

