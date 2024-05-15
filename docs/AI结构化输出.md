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

````
`````

