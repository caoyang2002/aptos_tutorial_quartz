---
title: Move-stdlib-String
---

[toc]



# Module 0x1::string

`string` 模块定义了表示 `UTF8` 编码字符串的 `String` 类型。

```rust
use 0x1::option;
use 0x1::vector;
```

## 结构体 String

一个字符串包含一系列字节，保证是 UTF-8 格式。

```rust
struct String has copy, drop, store
```

### 字段

```rust
bytes: vector<u8>
```

## 常数

### 索引越界

```rust
const EINVALID_INDEX: u64 = 2;
```

### 无效的 UTF-8 编码

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

### `try_utf8`

尝试从字节序列创建一个新的字符串。

```rust
public fun try_utf8(bytes: vector<u8>): option::Option<string::String>
```

实现

```rust
public fun try_utf8(bytes: vector<u8>): Option<String> {
    if (internal_check_utf8(&bytes)) {
        option::some(String{bytes})
    } else {
        option::none()
    }
}
```

### `bytes`

返回底层字节向量的引用。

```rust
public fun bytes(s: &string::String): &vector<u8>
```

实现

```rust
public fun bytes(s: &String): &vector<u8> {
    &s.bytes
}
```

### `is_empty`

检查此字符串是否为空。

```rust
public fun is_empty(s: &string::String): bool
```

实现

```rust
public fun is_empty(s: &String): bool {
    vector::is_empty(&s.bytes)
}
```

### `length`

返回此字符串的长度，以字节为单位。

```rust
public fun length(s: &string::String): u64
```

实现

```rust
public fun length(s: &String): u64 {
    vector::length(&s.bytes)
}
```

### `append`

追加一个字符串。

```rust
public fun append(s: &mut string::String, r: string::String)
```

实现

```rust
public fun append(s: &mut String, r: String) {
    vector::append(&mut s.bytes, r.bytes)
}
```

### `append_utf8`

追加必须为有效 UTF-8 格式的字节。

```rust
public fun append_utf8(s: &mut string::String, bytes: vector<u8>)
```

实现

```rust
public fun append_utf8(s: &mut String, bytes: vector<u8>) {
    append(s, utf8(bytes))
}
```

### `insert`

在给定字符串的字节索引处插入另一个字符串。索引必须位于有效的 UTF-8 字符边界。

```rust
public fun insert(s: &mut string::String, at: u64, o: string::String)
```

实现

```rust
public fun insert(s: &mut String, at: u64, o: String) {
    let bytes = &s.bytes;
    assert!(at <= vector::length(bytes) && internal_is_char_boundary(bytes, at), EINVALID_INDEX);
    let l = length(s);
    let front = sub_string(s, 0, at);
    let end = sub_string(s, at, l);
    append(&mut front, o);
    append(&mut front, end);
    *s = front;
}
```

### `sub_string`

使用给定的字节索引返回一个子字符串，其中 i 是第一个字节的位置，j 是不包括的第一个字节的开始（或字符串的长度）。索引必须位于有效的 UTF-8 字符边界，保证结果是有效的 UTF-8。

```rust
public fun sub_string(s: &string::String, i: u64, j: u64): string::String
```

实现

```rust
public fun sub_string(s: &String, i: u64, j: u64): String {
    let bytes = &s.bytes;
    let l = vector::length(bytes);
    assert!(
        j <= l && i <= j && internal_is_char_boundary(bytes, i) && internal_is_char_boundary(bytes, j),
        EINVALID_INDEX
    );
    String { bytes: internal_sub_string(bytes, i, j) }
}
```

### `index_of`

计算字符串第一次出现的索引。如果没有找到出现，则返回 length(s)。

```rust
public fun index_of(s: &string::String, r: &string::String): u64
```

实现

```rust
public fun index_of(s: &String, r: &String): u64 {
    internal_index_of(&s.bytes, &r.bytes)
}
```

### `internal_check_utf8`

```rust
public fun internal_check_utf8(v: &vector<u8>): bool
```

实现

```rust
public native fun internal_check_utf8(v: &vector<u8>): bool;
```

### `internal_is_char_boundary`

```rust
fun internal_is_char_boundary(v: &vector<u8>, i: u64): bool
```

实现

```rust
native fun internal_is_char_boundary(v: &vector<u8>, i: u64): bool;
```

### `internal_sub_string`

```rust
fun internal_sub_string(v: &vector<u8>, i: u64, j: u64): vector<u8>
```

实现

```rust
native fun internal_sub_string(v: &vector<u8>, i: u64, j: u64): vector<u8>;
```

### `internal_index_of`

```rust
fun internal_index_of(v: &vector<u8>, r: &vector<u8>): u64
```

实现

```rust
native fun internal_index_of(v: &vector<u8>, r: &vector<u8>): u64;
```

## 规范

### `internal_check_utf8`

```rust
public fun internal_check_utf8(v: &vector<u8>): bool
```

特性 opaque;

如果 false，则中止 [abstract] false;

确保 [abstract] 结果 == spec_internal_check_utf8(v);

### `internal_is_char_boundary`

```rust
fun internal_is_char_boundary(v: &vector<u8>, i: u64): bool
```

特性 opaque;

如果 false，则中止 [abstract] false;

确保 [abstract] 结果 == spec_internal_is_char_boundary(v, i);

### `internal_sub_string`

```rust
fun internal_sub_string(v: &vector<u8>, i: u64, j: u64): vector<u8>
```

特性 opaque;

如果 false，则中止 [abstract] false;

确保 [abstract] 结果 == spec_internal_sub_string(v, i, j);

### `internal_index_of`

```rust
fun internal_index_of(v: &vector<u8>, r: &vector<u8>): u64
```

特性 opaque;

如果 false，则中止 [abstract] false;

确保 [abstract] 结果 == spec_internal_index_of(v, r);

## 规范函数

```rust
fun spec_utf8(bytes: vector<u8>): String {
   String{bytes}
}
```

```rust
fun spec_internal_check_utf8(v: vector<u8>): bool;

fun spec_internal_is_char_boundary(v: vector<u8>, i: u64): bool;

fun spec_internal_sub_string(v: vector<u8>, i: u64, j: u64): vector<u8>;

fun spec_internal_index_of(v: vector<u8>, r: vector<u8>): u64;
```