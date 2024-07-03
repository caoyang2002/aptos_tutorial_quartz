---
title: 常数
---
# 常数

常量是给`module`或`script`内的共享静态值命名的一种方式。

常量必须在汇编时知道。常量的值存储在编译的模块或脚本中。每次使用该常量时，都会制作该值的新副本。

## 声明[](https://aptos.guide/en/build/smart-contracts/book/constants#declaration)

常量声明以`const`关键字开头，后跟名称、类型和值。它们可以存在于脚本或模块中

```
const <name>: <type> = <expression>;
```

例如

```
script {
  const MY_ERROR_CODE: u64 = 0;
 
  fun main(input: u64) {
    assert!(input > 0, MY_ERROR_CODE);
  }
}
 
module 0x42::example {
  const MY_ADDRESS: address = @0x42;
 
  public fun permissioned(s: &signer) {
    assert!(std::signer::address_of(s) == MY_ADDRESS, 0);
  }
}
```

## 命名[](https://aptos.guide/en/build/smart-contracts/book/constants#naming)

常量必须以大写字母`A`到`Z`开头。在第一个字母之后，常量名称可以包含下划线`_`、字母`a`到`z`、字母`A`到`Z`或数字`0`到9。

```
script {
  const FLAG: bool = false;
  const MY_ERROR_CODE: u64 = 0;
  const ADDRESS_42: address = @0x42;
}
```

即使你可以在常数中使用字母`a`到`z`。[一般风格准则](https://aptos.guide/en/build/smart-contracts/book/coding-conventions)是只使用大写字母`A`到`Z`，每个单词之间有下划线`_`。

这种从`A`到`Z`开头的命名限制已经到位，为未来的语言功能提供了空间。稍后可能会删除，也可能不会删除。

## 可见性[](https://aptos.guide/en/build/smart-contracts/book/constants#visibility)

`public`当前不支持常量。`const`值只能在声明模块中使用。

## 有效表达式[](https://aptos.guide/en/build/smart-contracts/book/constants#valid-expressions)

目前，常量仅限于原始类型`bool`、`u8`、`u16`、`u32`、`u64`、`u128`、`u256`、`address`和`vector<u8>`。未来对其他`vector`（除了“字符串”风格的文字）的支持将在稍后到来。

### 价值取向[](https://aptos.guide/en/build/smart-contracts/book/constants#values)

通常，`const`被分配一个其类型的简单值或文字值。例如

```
script {
  const MY_BOOL: bool = false;
  const MY_ADDRESS: address = @0x70DD;
  const BYTES: vector<u8> = b"hello world";
  const HEX_BYTES: vector<u8> = x"DEADBEEF";
}
```

### 复杂的表达式[](https://aptos.guide/en/build/smart-contracts/book/constants#complex-expressions)

除了文字外，常量还可以包括更复杂的表达式，只要编译器能够在编译时将表达式简化为值。

目前，可以使用相等运算、所有布尔运算、所有位运算和所有算术运算。

```rust
script {
  const RULE: bool = true && false;
  const CAP: u64 = 10 * 100 + 1;
  const SHIFTY: u8 = {
    (1 << 1) * (1 << 2) * (1 << 3) * (1 << 4)
  };
  const HALF_MAX: u128 = 340282366920938463463374607431768211455 / 2;
  const REM: u256 = 57896044618658097711785492504343953926634992332820282019728792003956564819968 % 654321;
  const EQUAL: bool = 1 == 1;
}
```

如果操作导致运行时异常，编译器将给出一个错误，表明它无法生成常量的值

```rust
script {
  const DIV_BY_ZERO: u64 = 1 / 0; // error!
  const SHIFT_BY_A_LOT: u64 = 1 << 100; // error!
  const NEGATIVE_U64: u64 = 0 - 1; // error!
}
```

请注意，常量目前不能引用其他常量。此功能以及对其他表达式的支持，将在未来添加。