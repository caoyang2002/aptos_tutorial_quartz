---
title: 元祖和单元
---
# 元组和单元

Move并不完全支持元组，因为人们可能期望来自另一种语言，它们是[一流的值](https://en.wikipedia.org/wiki/First-class_citizen)。然而，为了支持多个返回值，Move有类似元组的表达式。这些表达式在运行时不会产生具体值（字节码中没有元组），因此它们非常有限：它们只能出现在表达式中（通常在函数的返回位置）；它们不能绑定到局部变量；它们不能存储在结构中；元组类型不能用于实例化泛型。

同样，[单位`()`](https://en.wikipedia.org/wiki/Unit_type)是由移动源语言为基于表达式而创建的类型。单位值`()`不会产生任何运行时值。我们可以认为unit`()`是一个空元组，任何适用于元组的限制也适用于单元。

鉴于这些限制，语言中的元组可能会感觉很奇怪。但其他语言中元组最常见的用例之一是函数允许函数返回多个值。一些语言通过强制用户编写包含多个返回值的结构来解决这个问题。但是，在Move中，您不能将引用放在[结构中](https://aptos.guide/en/build/smart-contracts/book/structs-and-resources)。这需要移动来支持多个返回值。这些多个返回值都在字节码级别的堆栈上推送。在源级别，这些多个返回值使用元组表示。

## 字面量

元组由括号内的逗号分隔的表达式列表创建。

|语法|类型|描述|
|---|---|---|
|`()`|`(): ()`|单位，空元组，或元组0|
|`(e1, ..., en)`|`(e1, ..., en): (T1, ..., Tn)` where `e_i: Ti`s.t. `0 < i <= n` and `n > 0`|一个`n`元组，一个元数`n`的元组，一个有`n`元素的元组|

请注意，`(e)`没有类型`(e): (t)`换句话说，没有一个元素的元组。如果括号内只有一个元素，则括号仅用于消歧义，不具有任何其他特殊含义。

有时，具有两个元素的元组被称为“对”，具有三个元素的元组被称为“三重”。

### 实例

```rust
module 0x42::example {
  // all 3 of these functions are equivalent
 
  // when no return type is provided, it is assumed to be `()`
  fun returns_unit_1() { }
 
  // there is an implicit () value in empty expression blocks
  fun returns_unit_2(): () { }
 
  // explicit version of `returns_unit_1` and `returns_unit_2`
  fun returns_unit_3(): () { () }
 


  fun returns_3_values(): (u64, bool, address) {
    (0, false, @0x42)
  }
  fun returns_4_values(x: &u64): (&u64, u8, u128, vector<u8>) {
    (x, 0, 1, b"foobar")
  }
}
```

## 运营[](https://aptos.guide/en/build/smart-contracts/book/tuples#operations)

目前唯一可以在元组上完成的操作是解构。

### 破坏[](https://aptos.guide/en/build/smart-contracts/book/tuples#destructuring)

对于任何大小的元组，它们可以在`let`绑定或赋值中解构。

例如：

```rust
module 0x42::example {
  // all 3 of these functions are equivalent
  fun returns_unit() {}
  fun returns_2_values(): (bool, bool) { (true, false) }
  fun returns_4_values(x: &u64): (&u64, u8, u128, vector<u8>) { (x, 0, 1, b"foobar") }
 
  fun examples(cond: bool) {
    let () = ();
    let (x, y): (u8, u64) = (0, 1);
    let (a, b, c, d) = (@0x0, 0, false, b"");
 
    () = ();
    (x, y) = if (cond) (1, 2) else (3, 4);
    (a, b, c, d) = (@0x1, 1, true, b"1");
  }
 
  fun examples_with_function_calls() {
    let () = returns_unit();
    let (x, y): (bool, bool) = returns_2_values();
    let (a, b, c, d) = returns_4_values(&0);
 
    () = returns_unit();
    (x, y) = returns_2_values();
    (a, b, c, d) = returns_4_values(&1);
  }
}
```

有关更多详细信息，请参阅[移动变量](https://aptos.guide/en/build/smart-contracts/book/variables)。

## 子类型[](https://aptos.guide/en/build/smart-contracts/book/tuples#subtyping)

与引用一起，元组是唯一在Move中具有[子类型](https://en.wikipedia.org/wiki/Subtyping)的其他类型。元组只有在它们带有引用的子类型（以协变量方式）的意义上具有子类型。

例如：

```
script {
  fun example() {
    let x: &u64 = &0;
    let y: &mut u64 = &mut 1;
 
    // (&u64, &mut u64) is a subtype of (&u64, &u64)
    // since &mut u64 is a subtype of &u64
    let (a, b): (&u64, &u64) = (x, y);
 
    // (&mut u64, &mut u64) is a subtype of (&u64, &u64)
    // since &mut u64 is a subtype of &u64
    let (c, d): (&u64, &u64) = (y, y);
 
    // error! (&u64, &mut u64) is NOT a subtype of (&mut u64, &mut u64)
    // since &u64 is NOT a subtype of &mut u64
    let (e, f): (&mut u64, &mut u64) = (x, y);
  }
}
```

## 所有权[](https://aptos.guide/en/build/smart-contracts/book/tuples#ownership)

如上所述，元组值在运行时并不真正存在。目前，由于这个原因，它们无法存储到局部变量中（但此功能可能很快就会出现）。因此，元组目前只能移动，因为复制它们需要先将它们放入局部变量中。