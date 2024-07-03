---
title: 引用
draft: 
aliases:
  - 引用
date: 2024-07-03
description: 引用
tags:
  - Move
---
# 引用

Move有两种类型的引用：不可变`&`和可变`&mut`。不可更改引用是只读的，不能修改基础值（或其任何字段）。可变引用允许通过该引用的写入进行修改。Move的类型系统强制执行所有权纪律，防止引用错误。

有关参考规则的更多详细信息，请参阅[结构和资源](https://aptos.guide/en/build/smart-contracts/book/structs-and-resources)

## 参考运算符[](https://aptos.guide/en/build/smart-contracts/book/references#reference-operators)

Move提供了用于创建和扩展引用以及将可变引用转换为不可变引用的运算符。在这里和其他地方，我们使用符号`e: T`表示“表达式`e`有`T`型”。

|语法|类型|描述|
|---|---|---|
|`&e`|`&T`其中`e: T`和`T`是非参考类型|创建一个不可变的引用`e`|
|`&mut e`|`&mut T`其中`e: T`和`T`是非参考类型|创建一个对`e`的可变引用。|
|`&e.f`|`&T`地点`e.f: T`|创建对struct `e`字段`f`的不可变引用。|
|`&mut e.f`|`&mut T`地点`e.f: T`|创建对结构`f`字段的可变引用。|
|`freeze(e)`|`&T`地点`e: &mut T`|将可变引用`e`转换为不可变引用。|

`&e.f`和`&mut e.f`运算符既可用于将新引用创建到结构中，也可以扩展现有引用：

```
script {  
	fun example() {    
		let s = S { f: 10 };    
		let f_ref1: &u64 = &s.f; // works    
		let s_ref: &S = &s;    
		let f_ref2: &u64 = &s_ref.f; // also works  
	}
}
```

只要两个结构在同一模块中，具有多个字段的引用表达式就有效：

```
module 0x42::example {  
	struct A { b: B }  
	struct B { c : u64 }   
	fun f(a: &A): &u64 {    
		&a.b.c  
	}
}
```

最后，请注意，不允许引用引用：

```
script {  
	fun example() {    
		let x = 7;    
		let y: &u64 = &x;    
		let z: &&u64 = &y; // will not compile  
	}
}
```

## 通过参考文献阅读和写作[](https://aptos.guide/en/build/smart-contracts/book/references#reading-and-writing-through-references)

可变和不可变引用都可以读取，以生成引用值的副本。

只能写可变引用。写入`*x = v`丢弃之前存储在`x`中的值，并用`v`更新它。

这两个操作都使用类似C的`*`语法。然而，请注意，读取是一种表达式，而写入是一种突变，必须发生在等式的左侧。

|语法|类型|描述|
|---|---|---|
|`*e`|`T`其中`e`是`&T`或`&mut T`|阅读所指向的值`e`|
|`*e1 = e2`|`()`其中`e1: &mut T`和`e2: T`|用`e2`更新`e1`中的值。|

为了读取引用，底层类型必须具有[`copy`能力](https://aptos.guide/en/build/smart-contracts/book/abilities)，因为读取引用会创建值的新副本。此规则可防止复制资源值：

```
module 0x42::coin {  
	struct Coin {} // Note does not have copy   
	fun copy_resource_via_ref_bad(c: Coin) {      
		let c_ref = &c;      
		let counterfeit: Coin = *c_ref; // not allowed!      
		pay(c);      
		pay(counterfeit);  
	}
}
```

双重：为了将引用写入到，底层类型必须具有[`drop`能力](https://aptos.guide/en/build/smart-contracts/book/abilities)，因为写入引用将丢弃（或“删除”）旧值。此规则防止资源价值的破坏：

```
module 0x42::coin {  
	struct Coin {} // Note does not have drop   
	fun destroy_resource_via_ref_bad(ten_coins: Coin, c: Coin) {      
		let ref = &mut ten_coins;      
		*ref = c; // not allowed--would destroy 10 coins!  
	}
}
```

## `freeze`推断[](https://aptos.guide/en/build/smart-contracts/book/references#freeze-inference)

可变引用可以在预期不可变引用的上下文中使用：

```
script {  
	fun example() {    
		let x = 7;    
		let y: &u64 = &mut x;  
	}
}
```

这之所以有效，是因为在引擎盖下，编译器在需要的地方插入`freeze`指令。以下是一些`freeze`推理在行动中的示例：

```
module 0x42::example {  
	fun takes_immut_returns_immut(x: &u64): &u64 { x }   // freeze inference on return value  
	fun takes_mut_returns_immut(x: &mut u64): &u64 { x }   
	fun expression_examples() {    
		let x = 0;    
		let y = 0;    
		takes_immut_returns_immut(&x); // no inference    
		takes_immut_returns_immut(&mut x); // inferred freeze(&mut x)    
		takes_mut_returns_immut(&mut x); // no inference     
		assert!(&x == &mut y, 42); // inferred freeze(&mut y)  
	}   
	fun assignment_examples() {    
		let x = 0;    
		let y = 0;    
		let imm_ref: &u64 = &x;     
		imm_ref = &x; // no inference    
		imm_ref = &mut y; // inferred freeze(&mut y)  
	}
}
```

### 子类型[](https://aptos.guide/en/build/smart-contracts/book/references#subtyping)

通过这种`freeze`推断，移动类型检查器可以将`&mut T`视为`&T`的子类型。如上所述，这意味着对于任何使用`&T`值的表达式，也可以使用`&mut T`值。该术语用于错误消息中，以简明扼要地表示在提供`&T`的地方需要`&mut T`。例如

```
module 0x42::example {  
	fun read_and_assign(store: &mut u64, new_value: &u64) {    
		*store = *new_value  
	}   
	fun subtype_examples() {    
		let x: &u64 = &0;    
		let y: &mut u64 = &mut 1;     
		x = &mut 1; // valid    
		y = &2; // invalid!     
		read_and_assign(y, x); // valid    
		read_and_assign(x, y); // invalid!  
	}
}
```

将产生以下错误消息

```error
error:     
   ┌── example.move:12:9 ───    
   │ 
12 │         y = &2; // invalid!    
   │         ^ Invalid assignment to local 'y'  
   ·  
12 │         y = &2; // invalid!    
   │             -- The type: '&{integer}'  
   ·  
9  │         let y: &mut u64 = &mut 1;    
   │                -------- Is not a subtype of: '&mut u64'    
   │ 
error:     
   ┌── example.move:15:9 ───    
   │ 
15 │         read_and_assign(x, y); // invalid!    
   │         ^^^^^^^^^^^^^^^^^^^^^ Invalid call of '0x42::example::read_and_assign'. Invalid argument for parameter 'store'    
   ·  
8  │         let x: &u64 = &0;    
   │                ---- The type: '&u64'    
   ·  
3  │     fun read_and_assign(store: &mut u64, new_value: &u64) {    
   │                                -------- Is not a subtype of: '&mut u64'    
   │
```

目前唯一具有子类型的其他类型是[元组](https://aptos.guide/en/build/smart-contracts/book/tuples)

## 所有权

_即使有同一引用的现有副本或扩展，_可变和不可变引用也可以始终复制和扩展：

```
script {  
	fun reference_copies(s: &mut S) {    
	let s_copy1 = s; // ok    
	let s_extension = &mut s.f; // also ok    
	let s_copy2 = s; // still ok    
	// ...  
	}
}
```

对于熟悉Rust所有权系统的程序员来说，这可能会感到惊讶，因为系统会拒绝上述代码。Move的类型系统在处理[副本](https://aptos.guide/en/build/smart-contracts/book/variables#move-and-copy)方面更加宽松，但在确保写入前对可变引用的唯一所有权方面同样严格。

### 无法存储引用[](https://aptos.guide/en/build/smart-contracts/book/references#references-cannot-be-stored)

引用和元组_是唯一_不能存储为结构字段值的类型，这也意味着它们不能存在于全局存储中。当Move程序终止时，程序执行期间创建的所有引用都将被销毁；它们完全是短暂的。这种不变量对于没有`store`[能力的](https://aptos.guide/en/build/smart-contracts/book/abilities)类型值也是如此，但请注意，引用和元组更进一步，首先从不允许在结构中。

这是Move和Rust的另一个区别，它允许引用存储在结构中。

目前，Move不支持这一点，因为引用无法[序列化](https://en.wikipedia.org/wiki/Serialization)，但_每个Move值都必须可序列化_。这一要求来自Move的[持久全局存储](https://aptos.guide/en/build/smart-contracts/book/global-storage-structure)，该存储需要序列化值，使其跨程序执行。结构可以写入全局存储，因此它们必须是可序列化的。

人们可以想象一个更高级、更具表现力的类型系统，该系统将允许引用存储在结构中，_并_禁止这些结构存在于全局存储中。我们也许可以允许在没有`store`[能力](https://aptos.guide/en/build/smart-contracts/book/abilities)的结构中引用，但这并不能完全解决问题：Move有一个相当复杂的系统来跟踪静态引用安全，类型系统的这一方面也必须扩展，以支持在结构中存储引用。简而言之，Move的类型系统（特别是参考安全方面）必须扩展以支持存储的引用。但随着语言的发展，我们正在密切关注这一点。