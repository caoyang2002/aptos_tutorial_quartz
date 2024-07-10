---
title: Aptos-Math64
---
[toc]

# 0x1::math64

```rust
use 0x1::error;
use 0x1::fixed_point32;
```



## 常数

AI注：不能对值0取以2为底的对数。

```rust
const EINVALID_ARG_FLOOR_LOG2: u64 = 1;
```



## 函数

### `max`

返回两个数中较大的一个。

```rust
public fun max(a: u64, b: u64): u64
```

实现

```rust
public fun max(a: u64, b: u64): u64 {
    if (a >= b) a else b
}
```

### `min`

返回两个数中较小的一个。

```rust
public fun min(a: u64, b: u64): u64
```

实现

```rust
public fun min(a: u64, b: u64): u64 {
    if (a < b) a else b
}
```

### `average`

返回两个数的平均值。

```rust
public fun average(a: u64, b: u64): u64
```

实现

```rust
public fun average(a: u64, b: u64): u64 {
    if (a < b) {
        a + (b - a) / 2
    } else {
        b + (a - b) / 2
    }
}
```

### `gcd`

通过欧几里得算法返回`a`和`b`的最大公约数。

```rust
public fun gcd(a: u64, b: u64): u64
```

实现

```rust
public inline fun gcd(a: u64, b: u64): u64 {
    let (large, small) = if (a > b) (a, b) else (b, a);
    while (small != 0) {
        let tmp = small;
        small = large % small;
        large = tmp;
    };
    large
}
```

### `mul_div`

通过`u128`计算`a * b / c`以防止中间溢出。

```rust
public fun mul_div(a: u64, b: u64, c: u64): u64
```

实现

```rust
public inline fun mul_div(a: u64, b: u64, c: u64): u64 {
    assert!(c != 0, std::error::invalid_argument(4));
    (((a as u128) * (b as u128) / (c as u128)) as u64)
}
```

### `clamp`

将`x`限制在区间`[lower, upper]`内。

```rust
public fun clamp(x: u64, lower: u64, upper: u64): u64
```

实现

```rust
public fun clamp(x: u64, lower: u64, upper: u64): u64 {
    min(upper, max(lower, x))
}
```

### `pow`

返回`n`的`e`次幂。

```rust
public fun pow(n: u64, e: u64): u64
```

实现

```rust
public fun pow(n: u64, e: u64): u64 {
    if (e == 0) {
        1
    } else {
        let p = 1;
        while (e > 1) {
            if (e % 2 == 1) {
                p = p * n;
            };
            e = e / 2;
            n = n * n;
        };
        p * n
    }
}
```

### `floor_log2`

返回`x`的以2为底的对数的向下取整值。

```rust
public fun floor_log2(x: u64): u8
```

实现

```rust
public fun floor_log2(x: u64): u8 {
    let res = 0;
    assert!(x != 0, std::error::invalid_argument(EINVALID_ARG_FLOOR_LOG2));
    let n = 32;
    while (n > 0) {
        if (x >= (1 << n)) {
            x = x >> n;
            res = res + n;
        };
        n = n >> 1;
    };
    res
}
```

### `log2`

计算以2为底的对数。

```rust
public fun log2(x: u64): fixed_point32::FixedPoint32
```

实现

```rust
public fun log2(x: u64): FixedPoint32 {
    let integer_part = floor_log2(x);
    // 将x规范化到[1, 2)区间内，以进行定点32位计算。
    let y = (if (x >= 1 << 32) {
        x >> (integer_part - 32)
    } else {
        x << (32 - integer_part)
    } as u128);
    let frac = 0;
    let delta = 1 << 31;
    while (delta != 0) {
        // log x = 1/2 log x^2
        // x在[1, 2)区间内
        y = (y * y) >> 32;
        // 现在x在[1, 4)区间内
        // 如果x在[2, 4)区间内，那么log x = 1 + log (x / 2)
        if (y >= (2 << 32)) { frac = frac + delta; y = y >> 1; };
        delta = delta >> 1;
    };
    fixed_point32::create_from_raw_value (((integer_part as u64) << 32) + frac)
}
```

### `sqrt`

返回`x`的平方根，精确到`floor(sqrt(x))`。

```rust
public fun sqrt(x: u64): u64
```

实现

```rust
public fun sqrt(x: u64): u64 {
    if (x == 0) return 0;
    let res = 1 << ((floor_log2(x) + 1) >> 1);
    // 使用标准牛顿-拉弗森迭代法改进初始近似值。
    // 误差项演进为delta_i+1 = delta_i^2 / 2（二次收敛）。
    // 经过4次迭代后，delta小于2^-32，因此低于阈值。
    res = (res + x / res) >> 1;
    res = (res + x / res) >> 1;
    res = (res + x / res) >> 1;
    res = (res + x / res) >> 1;
    min(res, x / res)
}
```

### `ceil_div`

返回`x`除以`y`后向上取整的结果。

```rust
public fun ceil_div(x: u64, y: u64): u64
```

实现

```rust
public inline fun ceil_div(x: u64, y: u64): u64 {
    // ceil_div(x, y) = floor((x + y - 1) / y) = floor((x - 1) / y) + 1
    // (x + y - 1) 可能会导致错误溢出，因此我们使用后一种版本
    if (x == 0) {
        assert!(y != 0, std::error::invalid_argument(4));
        0
    }
    else (x - 1) / y + 1
}
```



## 规格说明

### `max`

```rust
public fun max(a: u64, b: u64): u64
```

如果`false`，则中止。

确保如果`a >= b`，则结果为`a`；如果`a < b`，则结果为`b`。

### `min`

```rust
public fun min(a: u64, b: u64): u64
```

如果`false`，则中止。

确保如果`a < b`，则结果为`a`；如果`a >= b`，则结果为`b`。

### `average`

```rust
public fun average(a: u64, b: u64): u64
```

特性 opaque；如果`false`，则中止。

确保结果为`(a + b) / 2`。

### `clamp`

```rust
public fun clamp(x: u64, lower: u64, upper: u64): u64
```

需要`(lower <= upper)`；如果`false`，则中止。

确保如果`(lower <= x && x <= upper)`，则结果为`x`；如果`x < lower`，则结果为`lower`；如果`upper < x`，则结果为`upper`。

### `pow`

```rust
public fun pow(n: u64, e: u64): u64
```

特性 opaque；如果`[abstract] spec_pow(n, e) > MAX_U64`，则中止。

确保`[abstract] result == spec_pow(n, e)`。

### `floor_log2`

```rust
public fun floor_log2(x: u64): u8
```

特性 opaque；如果`[abstract] x == 0`，则中止。

确保`[abstract] spec_pow(2, result) <= x`；确保`[abstract] x < spec_pow(2, result+1)`。

### `sqrt`

```rust
public fun sqrt(x: u64): u64
```

特性 opaque；如果`[abstract] false`，则中止。

确保如果`x > 0`，则`result * result <= x`；确保如果`x > 0`，则`x < (result+1) * (result+1)`。

### `spec_pow`

```rust
fun spec_pow(n: u64, e: u64): u64 {
   if (e == 0) {
       1
   }
   else {
       n * spec_pow(n, e-1)
   }
}
```