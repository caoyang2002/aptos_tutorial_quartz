---
title: 第一章：类型
---
1. **值类型(Value Type)**：包括布尔型，整数型等等，这类变量赋值时候直接传递数值。
    
2. **引用类型(Reference Type)**：包括数组和结构体，这类变量占空间大，赋值时候直接传递地址（类似指针）。
    
3. **映射类型(Mapping Type)**: Solidity 中存储键值对的数据结构，可以理解为哈希表

我们将仅介绍常用类型，不常用的类型不会涉及，本篇将介绍值类型。

# 值类型

## 1. 布尔型

布尔型是二值变量，取值为 `true` 或 `false`。

```
constract myBool{
	bool public b = true; // true  - false
}
```


## 整型

### `uint`
```
constract myUint{
	uint public u = true; // 无符号整数
}
```
`uint` ：正数，默认 256 位
- `uint8` $0$ ~ $2^{8}-1$
- `uint16` $0$ ~ $2^{16}-1$
- `uint24` $0$ ~ $2^{24}-1$
- `uint32` $0$ ~ $2^{32}-1$
- `+8` 递增
- `uint256` $0$ ~ $2^{256}-1$

### `int`

```solidity
constract myUint{
	int public u = -1; // 有符号整数
}
```

`int`：含负数，默认256 位
- `int8` $-2^{8}$ ~ $2^{8}-1$
- `int16` $-2^{16}$ ~ $2^{16}-1$
- `int24` $-2^{24}$ ~ $2^{24}-1$
- `int32` $-2^{32}$ ~ $2^{32}-1$
- `+8` 递增
- `int256` $-2^{255}$ ~ $2^{255}-1$

查看最小值

```solidity
constract myInt{
	int public minInt = type(int).min;
	int public maxInt = type(int).max;
}
```


## 地址

```
contract myAddress{
	address public addr = 0x;5B38Da6a701c568545dCfcB03FcB875f56beddC4; // 十六进制数
}
```

### byte

```solidity
contract myByte{
	byte32 public b32 = 0xdc53e55bf330421c07022e6bbc4707abe3748ec1d89c4b95d80ee8247c087ff9;
}
```





---


















布尔值的运算符包括：

- `!` （逻辑非）
- `&&` （逻辑与，"and"）
- `||` （逻辑或，"or"）
- `==` （等于）
- `!=` （不等于）

```
// 布尔运算bool 
public _bool1 = !_bool; // 取非bool 
public _bool2 = _bool && _bool1; // 与bool 
public _bool3 = _bool || _bool1; // 或bool 
public _bool4 = _bool == _bool1; // 相等bool 
public _bool5 = _bool != _bool1; // 不相等
```




在上述代码中：变量 `_bool` 的取值是 `true`；`_bool1` 是 `_bool` 的非，为 `false`；`_bool && _bool1` 为 `false`；`_bool || _bool1` 为 `true`；`_bool == _bool1` 为 `false`；`_bool != _bool1` 为 `true`。

**值得注意的是：**`&&` 和 `||` 运算符遵循短路规则，这意味着，假如存在 `f(x) || g(y)` 的表达式，如果 `f(x)` 是 `true`，`g(y)` 不会被计算，即使它和 `f(x)` 的结果是相反的。假如存在`f(x) && g(y)` 的表达式，如果 `f(x)` 是 `false`，`g(y)` 不会被计算。 所谓“短路规则”，一般出现在逻辑与（&&）和逻辑或（||）中。 当逻辑与（&&）的第一个条件为false时，就不会再去判断第二个条件； 当逻辑或（||）的第一个条件为true时，就不会再去判断第二个条件，这就是短路规则。

### 2. 整型[​](https://www.wtf.academy/docs/solidity-101/ValueTypes/#2-%E6%95%B4%E5%9E%8B "2. 整型的直接链接")

整型是 Solidity 中的整数，最常用的包括：

```
// 整型int 
public _int = -1; // 整数，包括负数uint 
public _uint = 1; // 正整数uint256 
public _number = 20220330; // 256位正整数
uint public u = 123;

```

Copy

常用的整型运算符包括：

- 比较运算符（返回布尔值）： `<=`， `<`，`==`， `!=`， `>=`， `>`
- 算数运算符： `+`， `-`， `*`， `/`， `%`（取余），`**`（幂）

```
// 整数运算uint256 public _number1 = _number + 1; // +，-，*，/uint256 public _number2 = 2**2; // 指数uint256 public _number3 = 7 % 2; // 取余数bool public _numberbool = _number2 > _number3; // 比大小
```

Copy

大家可以运行一下代码，看看这 4 个变量分别是多少。

### 3. 地址类型[​](https://www.wtf.academy/docs/solidity-101/ValueTypes/#3-%E5%9C%B0%E5%9D%80%E7%B1%BB%E5%9E%8B "3. 地址类型的直接链接")

地址类型(address)有两类：

- 普通地址（address）: 存储一个 20 字节的值（以太坊地址的大小）。
- payable address: 比普通地址多了 `transfer` 和 `send` 两个成员方法，用于接收转账。

我们会在之后的章节更加详细地介绍 payable address。

```
// 地址address public _address = 0x7A58c0Be72BE218B41C608b7Fe7C5bB630736C71;address payable public _address1 = payable(_address); // payable address，可以转账、查余额// 地址类型的成员uint256 public balance = _address1.balance; // balance of address
```

Copy

### 4. 定长字节数组[​](https://www.wtf.academy/docs/solidity-101/ValueTypes/#4-%E5%AE%9A%E9%95%BF%E5%AD%97%E8%8A%82%E6%95%B0%E7%BB%84 "4. 定长字节数组的直接链接")

字节数组分为定长和不定长两种：

- 定长字节数组: 属于值类型，数组长度在声明之后不能改变。根据字节数组的长度分为 `bytes1`, `bytes8`, `bytes32` 等类型。定长字节数组最多存储 32 bytes 数据，即`bytes32`。
- 不定长字节数组: 属于引用类型（之后的章节介绍），数组长度在声明之后可以改变，包括 `bytes` 等。

```
// 固定长度的字节数组bytes32 public _byte32 = "MiniSolidity"; bytes1 public _byte = _byte32[0]; 
```

Copy

在上述代码中，`MiniSolidity` 变量以字节的方式存储进变量 `_byte32`。如果把它转换成 `16 进制`，就是：`0x4d696e69536f6c69646974790000000000000000000000000000000000000000`

`_byte` 变量的值为 `_byte32` 的第一个字节，即 `0x4d`。

### 5. 枚举 enum[​](https://www.wtf.academy/docs/solidity-101/ValueTypes/#5-%E6%9E%9A%E4%B8%BE-enum "5. 枚举 enum的直接链接")

枚举（`enum`）是 Solidity 中用户定义的数据类型。它主要用于为 `uint` 分配名称，使程序易于阅读和维护。它与 `C 语言` 中的 `enum` 类似，使用名称来代替从 `0` 开始的 `uint`：

```
// 用enum将uint 0， 1， 2表示为Buy, Hold, Sellenum ActionSet { Buy, Hold, Sell }// 创建enum变量 actionActionSet action = ActionSet.Buy;
```

Copy

枚举可以显式地和 `uint` 相互转换，并会检查转换的正整数是否在枚举的长度内，否则会报错：

```
// enum可以和uint显式的转换function enumToUint() external view returns(uint){    return uint(action);}
```

Copy

`enum` 是一个比较冷门的变量，几乎没什么人用。

## 在 Remix 上运行[​](https://www.wtf.academy/docs/solidity-101/ValueTypes/#%E5%9C%A8-remix-%E4%B8%8A%E8%BF%90%E8%A1%8C "在 Remix 上运行的直接链接")

- 部署合约后可以查看每个类型的变量的数值：

![2-1.png](https://www.wtf.academy/assets/images/2-1-90414d7e21f49e75101a07a8a55e602c.png)

- `enum` 和 `uint` 转换的示例：

![2-2.png](https://www.wtf.academy/assets/images/2-2-6c364618b30e6c498127e2d129f9e7e8.png)

![2-3.png](https://www.wtf.academy/assets/images/2-3-d2742673ffbd4df5c230d48a02a2921c.png)

## 总结[​](https://www.wtf.academy/docs/solidity-101/ValueTypes/#%E6%80%BB%E7%BB%93 "总结的直接链接")

在这一讲，我们介绍了 Solidity 中值类型，包括布尔型、整型、地址、定长字节数组和枚举。在后续章节，我们将继续介绍 Solidity 的其他变量类型，包括引用类型和映射类型。