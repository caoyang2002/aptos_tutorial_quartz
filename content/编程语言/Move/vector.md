---
title: 向量
draft: 
aliases:
  - 向量
date: 2024-07-03
tags:
  - Move
description: 向量
---
# Vector

`vector<T>`是Move提供的唯一原始集合类型。`vector<T>`是`T`的同质集合，可以通过将值从“端”推开/弹出来增长或收缩。

`vector<T>`可以用任何类型`T`实例化。例如，`vector<u64>`、`vector<address>`、`vector<0x42::MyModule::MyResource>`和`vector<vector<u8>>`都是有效的向量类型。

## 文字

### 一般`vector`文字[](https://aptos.guide/en/build/smart-contracts/book/vector#general-vector-literals)

任何类型的矢量都可以用`vector`文字创建。

|语法|类型|描述|
|---|---|---|
|`vector[]`|`vector[]: vector<T>`其中`T`是任何单一的非引用类型|一个空的矢量|
|`vector[e1, ..., en]`|`vector[e1, ..., en]: vector<T>` where `e_i: T` s.t. `0 < i <= n` and `n > 0`|带有`n`元素（长度为`n`）的向量|

在这些情况下，从元素类型或矢量的用法中推断出`vector`的类型。如果无法推断类型，或者只是为了增加清晰度，则可以明确指定类型：

```rust
vector<T>[]: vector<T>
vector<T>[e1, ..., en]: vector<T>
```

#### 矢量文字示例[](https://aptos.guide/en/build/smart-contracts/book/vector#example-vector-literals)

```
script {  
	fun example() {    
		(vector[]: vector<bool>);    
		(vector[0u8, 1u8, 2u8]: vector<u8>);    
		(vector<u128>[]: vector<u128>);    
		(vector<address>[@0x42, @0x100]: vector<address>);  
	}
}
```

### `vector<u8>`文字

移动中向量的一个常见用例是表示“字节数组”，这些数组用向`vector<u8>`表示。这些值通常用于加密目的，例如公钥或散列结果。这些值非常常见，因此提供了特定的语法来使值更易读，而不是必须使用`vector[]`，其中每个单独的`u8`值都以数字形式指定。

目前支持两种类型的`vector<u8>`文字，**字节字符串**和**十六进制字符串**。

#### 字节字符串

字节字符串是引号字符串文字，前缀为a `b`，例如`b"Hello!\n"`

这些是ASCII编码的字符串，允许转义序列。目前，支持的转义序列是：

| 逃生序列   | 描述                  |
| ------ | ------------------- |
| `\n`   | 新线路（或线路馈送）          |
| `\r`   | 马车返回                |
| `\t`   | 选项卡                 |
| `\\`   | 反斜线                 |
| `\0`   | 无效                  |
| `\"`   | 引文                  |
| `\xHH` | 十六制转义，插入十六制字节序列`HH` |

#### 六角弦

十六制字符串是以`x`为前缀的引号字符串文字，例如`x"48656C6C6F210A"`

每个字节对，从`00`到`FF`不等，被解释为十六向编码的`u8`值。因此，每个字节对对应于结果`vector<u8>`中的单个条目。

#### 字符串文字示例[](https://aptos.guide/en/build/smart-contracts/book/vector#example-string-literals)

```
script {  
	fun byte_and_hex_strings() {    
		assert!(b"" == x"", 0);    
		assert!(b"Hello!\n" == x"48656C6C6F210A", 1);    
		assert!(b"\x48\x65\x6C\x6C\x6F\x21\x0A" == x"48656C6C6F210A", 2);    
		assert!(        
			b"\"Hello\tworld!\"\n \r \\Null=\0" == x"2248656C6C6F09776F726C6421220A200D205C4E756C6C3D00",        
			3    
		);  
	}
}
```

## 操作符

`vector`通过Move标准库中的`std::vector`模块提供几个操作，如下所示。随着时间的推移，可能会添加更多操作。`vector`上的最新文档可以[在这里](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/move-stdlib/doc/vector.mdx#0x1_vector)找到。

|功能|描述|流产？|
|---|---|---|
|`vector::empty<T>(): vector<T>`|创建一个可以存储类型值的空向量`T`|从来没有|
|`vector::is_empty<T>(): bool`|如果向量`v`没有元素，则返回`true`，否则返回`false`。|从来没有|
|`vector::singleton<T>(t: T): vector<T>`|创建一个尺寸为1的矢量，包含`t`|从来没有|
|`vector::length<T>(v: &vector<T>): u64`|返回矢量的长度`v`|从来没有|
|`vector::push_back<T>(v: &mut vector<T>, t: T)`|在末尾添加`t``v`|从来没有|
|`vector::pop_back<T>(v: &mut vector<T>): T`|删除并返回最后一个元素`v`|如果`v`是空的|
|`vector::borrow<T>(v: &vector<T>, i: u64): &T`|返回索引处`T`的不可变引用`i`|如果我不在界内|
|`vector::borrow_mut<T>(v: &mut vector<T>, i: u64): &mut T`|返回索引处`T`的可变引用`i`|如果我不在界内|
|`vector::destroy_empty<T>(v: vector<T>)`|删除`v`|如果`v`不是空的|
|`vector::append<T>(v1: &mut vector<T>, v2: vector<T>)`|将`v2`中的元素添加到末尾`v1`|从来没有|
|`vector::reverse_append<T>(lhs: &mut vector<T>, other: vector<T>)`|将`other`向量的所有元素推入`lhs`向量，其顺序与它们发生相反`other`|从来没有|
|`vector::contains<T>(v: &vector<T>, e: &T): bool`|如果`e`在向量`v`中，则返回true。否则，返回false|从来没有|
|`vector::swap<T>(v: &mut vector<T>, i: u64, j: u64)`|交换矢量中ith和`j`索引的元素`v`|如果`i`或`j`不在界外|
|`vector::reverse<T>(v: &mut vector<T>)`|反转向量`v`中元素的顺序|从来没有|
|`vector::reverse_slice<T>(v: &mut vector<T>, l: u64, r: u64)`|反转向量`v`中元素`[l, r)`的顺序|从来没有|
|`vector::index_of<T>(v: &vector<T>, e: &T): (bool, u64)`|如果`e`在索引`i`的向量`v`中，则返回`(true, i)`否则，返回`(false, 0)`|从来没有|
|`vector::insert<T>(v: &mut vector<T>, i: u64, e: T)`|在位置`0 <= i <= length`插入一个新元素`e`，使用`O(length - i)`时间|`i`出界了|
|`vector::remove<T>(v: &mut vector<T>, i: u64): T`|删除向量`v`的ith元素，移动所有后续元素。这是O（n），并保留了向量中元素的排序|`i`出界了|
|`vector::swap_remove<T>(v: &mut vector<T>, i: u64): T`|将向量`v`的ith元素与最后一个元素交换，然后弹出该元素，这是O（1），但不保留向量中元素的顺序|`i`出界了|
|`vector::trim<T>(v: &mut vector<T>, new_len: u64): u64`|将矢量`v`修剪到较小的尺寸`new_len`，并按顺序返回被驱逐的元素|`new_len`大于...的长度`v`|
|`vector::trim_reverse<T>(v: &mut vector<T>, new_len: u64): u64`|将向量`v`修剪成较小的`new_len`，并按相反的顺序返回被驱逐的元素|`new_len`大于...的长度`v`|
|`vector::rotate<T>(v: &mut vector<T>, rot: u64): u64`|`rotate(&mut [1, 2, 3, 4, 5], 2) -> [3, 4, 5, 1, 2]`就位，返回拆分点，即本例中的3|从来没有|
|`vector::rotate_slice<T>(v: &mut vector<T>, left: u64, rot: u64, right: u64): u64`|旋转切片`[left, right)`与`left <= rot <= right`到位，返回分裂点|从来没有|

## 示例：[](https://aptos.guide/en/build/smart-contracts/book/vector#example)

```
script {  
	use std::vector;   
	fun example() {    
		let v = vector::empty<u64>();    
		vector::push_back(&mut v, 5);    
		vector::push_back(&mut v, 6);     
		assert!(*vector::borrow(&v, 0) == 5, 42);    
		assert!(*vector::borrow(&v, 1) == 6, 42);    
		assert!(vector::pop_back(&mut v) == 6, 42);    
		assert!(vector::pop_back(&mut v) == 5, 42);  
	}
}
```

## 销毁和复制向量

`vector<T>`的一些行为取决于元素类型`T`的能力。例如，包含没有`drop`的元素的矢量不能像上述示例中的`v`那样隐式丢弃——它们必须用`vector::destroy_empty`显式销毁。

请注意，除非`vec`包含零元素，否则`vector::destroy_empty`将在运行时中止：

```
script {  
	fun destroy_any_vector<T>(vec: vector<T>) {    
		vector::destroy_empty(vec) // deleting this line will cause a compiler error  
	}
}
```

但是，删除包含带有`drop`元素的向量不会出错：

```
script {  
	fun destroy_droppable_vector<T: drop>(vec: vector<T>) {    
		// valid!    
		// nothing needs to be done explicitly to destroy the vector  
	}
}
```

同样，除非元素类型有`copy`无法复制向量。换句话说，`vector<T>`有`copy`，当且仅当`T`有`copy`。

有关更多详细信息，请参阅[类型能力和](https://aptos.guide/en/build/smart-contracts/book/abilities)[泛型](https://aptos.guide/en/build/smart-contracts/book/generics)部分。

## 所有权

[如上所述](https://aptos.guide/en/build/smart-contracts/book/vector#destroying-and-copying-vectors)，只有当元素可以复制时，才能复制`vector`。