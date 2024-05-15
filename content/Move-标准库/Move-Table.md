---
title: Table
draft: true
---

# Module 0x1::table

## 结构体

### `Table`

Table 类型

```rust
struct Table<K: copy, drop, V> has store
```

字段

```rust
handle: address
```

## 资源

### `Box`

Wrapper for values. Required for making values appear as resources in the implementation.

```rust
struct Box<V> has drop, store, key
```

字段

```rust
val: V
```

## 函数

### `new`

创建一个新的 Table

```rust
public fun new<K: copy, drop, V: store>(): table::Table<K, V>
```

实现

```rust
public fun new<K: copy + drop, V: store>(): Table<K, V> {
    Table {
        handle: new_table_handle<K, V>(),
    }
}
```

### `add`

Add a new entry to the table. Aborts if an entry for this key already exists. The entry itself is not stored in the table, and cannot be discovered from it.

```rust
public fun add<K: copy, drop, V>(table: &mut table::Table<K, V>, key: K, val: V)
```

实现

```rust
public fun add<K: copy + drop, V>(table: &mut Table<K, V>, key: K, val: V) {
    add_box<K, V, Box<V>>(table, key, Box { val })
}
```

### `borrow`

Acquire an immutable reference to the value which key maps to. Aborts if there is no entry for key.

```rust
public fun borrow<K: copy, drop, V>(table: &table::Table<K, V>, key: K): &V
```

实现

```rust
public fun borrow<K: copy + drop, V>(table: &Table<K, V>, key: K): &V {
    &borrow_box<K, V, Box<V>>(table, key).val
}
```

### `borrow_with_default`

Acquire an immutable reference to the value which key maps to. Returns specified default value if there is no entry for key.

```rust
public fun borrow_with_default<K: copy, drop, V>(table: &table::Table<K, V>, key: K, default: &V): &V
```

实现

```rust
public fun borrow_with_default<K: copy + drop, V>(table: &Table<K, V>, key: K, default: &V): &V {
    if (!contains(table, copy key)) {
        default
    } else {
        borrow(table, copy key)
    }
}
```

### `borrow_mut`

Acquire a mutable reference to the value which key maps to. Aborts if there is no entry for key.

```rust
public fun borrow_mut<K: copy, drop, V>(table: &mut table::Table<K, V>, key: K): &mut V
```

实现

```rust
public fun borrow_mut<K: copy + drop, V>(table: &mut Table<K, V>, key: K): &mut V {
    &mut borrow_box_mut<K, V, Box<V>>(table, key).val
}
```

### `borrow_mut_with_default`

获取键映射到的值的可变引用。如果键没有对应的条目，则首先插入键值对（key, default）。

```rust
public fun borrow_mut_with_default<K: copy, drop, V: drop>(table: &mut table::Table<K, V>, key: K, default: V): &mut V
```

实现

```rust
public fun borrow_mut_with_default<K: copy + drop, V: drop>(table: &mut Table<K, V>, key: K, default: V): &mut V {
    if (!contains(table, copy key)) {
        add(table, copy key, default)
    };
    borrow_mut(table, key)
}
```

### `upsert`

如果键没有对应的条目，则插入键值对（key, value）。否则，更新键对应条目的值为 value。

```rust
public fun upsert<K: copy, drop, V: drop>(table: &mut table::Table<K, V>, key: K, value: V)
```

实现

```rust
public fun upsert<K: copy + drop, V: drop>(table: &mut Table<K, V>, key: K, value: V) {
    if (!contains(table, copy key)) {
        add(table, copy key, value)
    } else {
        let ref = borrow_mut(table, key);
        *ref = value;
    };
}
```

### `remove`

从表中移除键对应的条目并返回其值。如果键没有对应的条目，则会中止。

```rust
public fun remove<K: copy, drop, V>(table: &mut table::Table<K, V>, key: K): V
```

实现

```rust
public fun remove<K: copy + drop, V>(table: &mut Table<K, V>, key: K): V {
    let Box { val } = remove_box<K, V, Box<V>>(table, key);
    val
}
```

### `contains`

如果表包含键的条目，则返回 true。

```rust
public fun contains<K: copy, drop, V>(table: &table::Table<K, V>, key: K): bool
```

实现

```rust
public fun contains<K: copy + drop, V>(table: &Table<K, V>, key: K): bool {
    contains_box<K, V, Box<V>>(table, key)
}
```

### `destroy`

```rust
public(friend) fun destroy<K: copy, drop, V>(table: table::Table<K, V>)
```

实现

```rust
public(friend) fun destroy<K: copy + drop, V>(table: Table<K, V>) {
    destroy_empty_box<K, V, Box<V>>(&table);
    drop_unchecked_box<K, V, Box<V>>(table)
}
```

### `new_table_handle`

```rust
fun new_table_handle<K, V>(): address
```

实现

```rust
native fun new_table_handle<K, V>(): address;
```

### `add_box`

```rust
fun add_box<K: copy, drop, V, B>(table: &mut table::Table<K, V>, key: K, val: table::Box<V>)
```

实现

```rust
native fun add_box<K: copy + drop, V, B>(table: &mut Table<K, V>, key: K, val: Box<V>);
```

### `borrow_box`

```rust
fun borrow_box<K: copy, drop, V, B>(table: &table::Table<K, V>, key: K): &table::Box<V>
```

实现

```rust
native fun borrow_box<K: copy + drop, V, B>(table: &Table<K, V>, key: K): &Box<V>;
```

### `borrow_box_mut`

```rust
fun borrow_box_mut<K: copy, drop, V, B>(table: &mut table::Table<K, V>, key: K): &mut table::Box<V>
```

实现

```rust
native fun borrow_box_mut<K: copy + drop, V, B>(table: &mut Table<K, V>, key: K): &mut Box<V>;
```

### `contains_box`

```rust
fun contains_box<K: copy, drop, V, B>(table: &table::Table<K, V>, key: K): bool
```

实现

```rust
native fun contains_box<K: copy + drop, V, B>(table: &Table<K, V>, key: K): bool;
```

### `remove_box`

```rust
fun remove_box<K: copy, drop, V, B>(table: &mut table::Table<K, V>, key: K): table::Box<V>
```

实现

```rust
native fun remove_box<K: copy + drop, V, B>(table: &mut Table<K, V>, key: K): Box<V>;
```

### `destroy_empty_box`

```rust
fun destroy_empty_box<K: copy, drop, V, B>(table: &table::Table<K, V>)
```

实现

```rust
native fun destroy_empty_box<K: copy + drop, V, B>(table: &Table<K, V>);
```

### `drop_unchecked_box`

```rust
fun drop_unchecked_box<K: copy, drop, V, B>(table: table::Table<K, V>)
```

实现

```rust
native fun drop_unchecked_box<K: copy + drop, V, B>(table: Table<K, V>);
```

## 规范

### `Table`

```rust
struct Table<K: copy, drop, V> has store
```

`handle: address`

```rust
pragma intrinsic = map,
    map_new = new,
    map_destroy_empty = destroy,
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
    map_spec_has_key = spec_contains;
```

## 函数

### `new`

```rust
public fun new<K: copy, drop, V: store>(): table::Table<K, V>
```

```rust
pragma intrinsic;
```

### `add`

```rust
public fun add<K: copy, drop, V>(table: &mut table::Table<K, V>, key: K, val: V)
```

```rust
pragma intrinsic;
```

### `borrow`

```rust
public fun borrow<K: copy, drop, V>(table: &table::Table<K, V>, key: K): &V
```

```rust
pragma intrinsic;
```

### `borrow_mut`

```rust
public fun borrow_mut<K: copy, drop, V>(table: &mut table::Table<K, V>, key: K): &mut V
```

```rust
pragma intrinsic;
```

### `borrow_mut_with_default`

```rust
public fun borrow_mut_with_default<K: copy, drop, V: drop>(table: &mut table::Table<K, V>, key: K, default: V): &mut V
```

```rust
pragma intrinsic;
```

### `upsert`

```rust
public fun upsert<K: copy, drop, V: drop>(table: &mut table::Table<K, V>, key: K, value: V)
```

```rust
pragma intrinsic;
```

### `remove`

```rust
public fun remove<K: copy, drop, V>(table: &mut table::Table<K, V>, key: K): V
```

```rust
pragma intrinsic;
```

### `contains`

```rust
public fun contains<K: copy, drop, V>(table: &table::Table<K, V>, key: K): bool
```

```rust
pragma intrinsic;
```



本地函数

```rust
native fun spec_contains<K, V>(t: Table<K, V>, k: K): bool;
```

```rust
native fun spec_remove<K, V>(t: Table<K, V>, k: K): Table<K, V>;
```

```rust
native fun spec_set<K, V>(t: Table<K, V>, k: K, v: V): Table<K, V>;
```

```rust
native fun spec_get<K, V>(t: Table<K, V>, k: K): V;
```

实现

```rust
public(friend) fun destroy<K: copy, drop, V>(table: table::Table<K, V>) {}
```


