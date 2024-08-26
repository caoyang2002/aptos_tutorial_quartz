---
title: 第九章 函数
aliases:
  - 第九章 函数
draft: 
description: Aptos 上 Move 的函数
tags:
  - MoveOnAptos
date: 2024-07-03
---
# 函数

Move 语言中模块函数和脚本函数的语法是共享的。模块内的函数可以重复使用，而脚本函数仅用于一次交易的调用。

## 声明

函数使用`fun`关键字声明，后跟函数名、类型参数、参数、返回类型、获取注释，最后是函数体。

```rust
fun <identifier><[type_parameters: constraint],*>([identifier: type],*): <return_type> <acquires [identifier],*> <function_body>
```

例如：

```rust
fun foo<T1, T2>(x: u64, y: T1, z: T2): (T2, T1, u64) { (z, y, x) }
```

### 可见性

默认情况下，模块函数只能在同一个模块内被调用。这些内部（有时称为私有）函数不能从其他模块或脚本中调用。

```rust
address 0x42 {
module m {
    fun foo(): u64 { 0 }
 
    fun calls_foo(): u64 { foo() } // valid
}
 
module other {
    fun calls_m_foo(): u64 {
        0x42::m::foo() // ERROR!
    //      ^^^^^^^^^^^^ 'foo' is internal to '0x42::m'
    }
}
}
 
script {
    fun calls_m_foo(): u64 {
        0x42::m::foo() // ERROR!
    //      ^^^^^^^^^^^^ 'foo' is internal to '0x42::m'
    }
}
```

要允许从其他模块或脚本访问，函数必须被声明为`public`或`public(friend)`。

#### `public`可见性

`public`函数可以被任何模块或脚本中定义的*任何*函数调用。如下例所示，`public`函数可以被以下调用：

- 同一模块中定义的其他函数，
- 另一个模块中定义的函数，或
- 脚本中定义的函数。

公共函数的参数类型和返回类型也没有限制。

```rust
address 0x42 {
module m {
    public fun foo(): u64 { 0 }
 
    fun calls_foo(): u64 { foo() } // valid
}
 
module other {
    fun calls_m_foo(): u64 {
        0x42::m::foo() // valid
    }
}
}
 
script {
    fun calls_m_foo(): u64 {
        0x42::m::foo() // valid
    }
}
```

#### `public(friend)`可见性

`public(friend)`可见性修饰符是`public`修饰符的更受限形式，以便更精确地控制函数的使用位置。`public(friend)`函数可以被以下调用：

- 同一模块中定义的其他函数，或
- 在**友元列表**中明确指定的模块中定义的函数（见[友元](https://aptos.dev/en/build/smart-contracts/book/friends)了解如何指定友元列表）。

注意，由于我们不能将脚本声明为模块的好友，因此在脚本中定义的函数永远不能调用`public(friend)`函数。

```rust
address 0x42 {
module m {
    friend 0x42::n;  // friend declaration
    public(friend) fun foo(): u64 { 0 }
 
    fun calls_foo(): u64 { foo() } // valid
}
 
module n {
    fun calls_m_foo(): u64 {
        0x42::m::foo() // valid
    }
}
 
module other {
    fun calls_m_foo(): u64 {
        0x42::m::foo() // ERROR!
        //      ^^^^^^^^^^^^ 'foo' can only be called from a 'friend' of module '0x42::m'
    }
}
}
 
script {
    fun calls_m_foo(): u64 {
        0x42::m::foo() // ERROR!
        //      ^^^^^^^^^^^^ 'foo' can only be called from a 'friend' of module '0x42::m'
    }
}
```

### `entry`修饰符

`entry`修饰符旨在允许模块函数像脚本一样被安全且直接地调用。这允许模块编写者指定哪些函数可以被调用以开始执行。模块编写者随后知道任何非`entry`函数将从已在执行中的Move程序中调用。

本质上，`entry`函数是模块的“主”函数，它们指定了Move程序开始执行的位置。

但请注意，`entry`函数*仍然可以*被其他Move函数调用。所以虽然它们*可以*作为Move程序的起点，但它们并不局限于这种情况。

例如：

```rust
address 0x42 {
	module m {
	    public entry fun foo() {}
	 
	    fun calls_foo(): u64 { foo() } // valid!
	}
	 
	module n {
	    fun calls_m_foo(): u64 {
	        0x42::m::foo() // valid!
	    }
	}
	 
	module other {
	    public entry fun calls_m_foo() {
	        0x42::m::foo(); // valid!
	    }
	}
}
 
script {
    fun calls_m_foo(): u64 {
        0x42::m::foo() // valid!
    }
}
```

即使是内部函数也可以被标记为`entry`！这可以确保函数仅在执行开始时被调用（假设你没有在模块的其他地方调用它）。

```rust
address 0x42 {
module m {
    entry fun foo() { 0 } // valid! entry functions do not have to be public
}
 
module n {
    fun calls_m_foo(): u64 {
        0x42::m::foo() // ERROR!
        //      ^^^^^^^^^^^^ 'foo' is internal to '0x42::m'
    }
}
 
module other {
    public entry fun calls_m_foo() {
        0x42::m::foo() // ERROR!
        //      ^^^^^^^^^^^^ 'foo' is internal to '0x42::m'
    }
}
}
 
script {
    fun calls_m_foo(): u64 {
        0x42::m::foo() // ERROR!
        //      ^^^^^^^^^^^^ 'foo' is internal to '0x42::m'
    }
}
```

入口函数可以接收原始类型、String和vector参数，但不能接收结构体（例如Option）。它们也必须没有任何返回值。

### 名称

函数名可以以字母`a`到`z`或字母`A`到`Z`开始。在第一个字符之后，函数名可以包含下划线`_`、字母`a`到`z`、字母`A`到`Z`或数字`0`到`9`。

```rust
module 0x42::example {
    // all valid
    fun FOO() {}
 
    fun bar_42() {}
 
    fun bAZ19() {}
 
    // invalid
    fun _bAZ19() {} // Function names cannot start with '_'
}
```

### 类型参数

在名称之后，函数可以有类型参数

```rust
module 0x42::example {
    fun id<T>(x: T): T { x }
 
    fun example<T1: copy, T2>(x: T1, y: T2): (T1, T1, T2) { (copy x, x, y) }
}
```

有关更多详细信息，请参见[Move泛型](https://aptos.dev/en/build/smart-contracts/book/generics)。

### 参数

函数参数通过在局部变量名后添加类型注释来声明

```rust
module 0x42::example {
    fun add(x: u64, y: u64): u64 { x + y }
}
```

我们将其读作`x`的类型为`u64`。

一个函数不必有任何参数。

```rust
module 0x42::example {
    fun useless() {}
}
```

这对于创建新的或空的数据结构的函数来说非常常见。

```rust
module 0x42::example {
    struct Counter { count: u64 }
 
    fun new_counter(): Counter {
        Counter { count: 0 }
    }
}
```

### 获取

当一个函数使用`move_from`、`borrow_global`或`borrow_global_mut`访问一个资源时，该函数必须表明它获取了该资源。然后Move的类型系统使用这个来确保对全局存储的引用是安全的，特别是没有悬空的全局存储引用。

```rust
module 0x42::example {
 
    struct Balance has key { value: u64 }
 
    public fun add_balance(s: &signer, value: u64) {
        move_to(s, Balance { value })
    }
 
    public fun extract_balance(addr: address): u64 acquires Balance {
        let Balance { value } = move_from<Balance>(addr); // acquires needed
        value
    }
}
```

获取注释还必须为模块内的递归调用添加。从另一个模块调用这些函数不需要添加这些获取注释，因为一个模块不能访问在另一个模块中声明的资源，所以不需要注释来确保引用安全。

```rust
module 0x42::example {
 
    struct Balance has key { value: u64 }
 
    public fun add_balance(s: &signer, value: u64) {
        move_to(s, Balance { value })
    }
 
    public fun extract_balance(addr: address): u64 acquires Balance {
        let Balance { value } = move_from<Balance>(addr); // acquires needed
        value
    }
 
    public fun extract_and_add(sender: address, receiver: &signer) acquires Balance {
        let value = extract_balance(sender); // acquires needed here
        add_balance(receiver, value)
    }
}
 
module 0x42::other {
    fun extract_balance(addr: address): u64 {
        0x42::example::extract_balance(addr) // no acquires needed
    }
}
```

一个函数可以获取它需要的任意多的资源

```rust
module 0x42::example {
    use std::vector;
 
    struct Balance has key { value: u64 }
 
    struct Box<T> has key { items: vector<T> }
 
    public fun store_two<Item1: store, Item2: store>(
        addr: address,
        item1: Item1,
        item2: Item2,
    ) acquires Balance, Box {
        let balance = borrow_global_mut<Balance>(addr); // acquires needed
        balance.value = balance.value - 2;
        let box1 = borrow_global_mut<Box<Item1>>(addr); // acquires needed
        vector::push_back(&mut box1.items, item1);
        let box2 = borrow_global_mut<Box<Item2>>(addr); // acquires needed
        vector::push_back(&mut box2.items, item2);
    }
}
```

### 返回类型

在参数之后，函数指定其返回类型。

```rust
module 0x42::example {
    fun zero(): u64 { 0 }
}
```

这里的`: u64`表示函数的返回类型是`u64`。

>[!NOTE] 重要
>一个函数可以返回一个不可变的`&`或可变的`&mut`[引用](https://aptos.dev/en/build/smart-contracts/book/references)，如果它是从输入引用派生的。请注意，这意味着一个函数[不能返回对全局存储的引用](https://aptos.dev/en/build/smart-contracts/book/references#references-cannot-be-stored)，除非它是一个[内联函数](https://aptos.dev/en/build/smart-contracts/book/functions#inline-functions)。

使用元组，函数可以返回多个值：

```rust
module 0x42::example {
    fun one_two_three(): (u64, u64, u64) { (0, 1, 2) }
}
```

如果没有指定返回类型，函数的隐式返回类型为单元`()`。这些函数是等价的：

```rust
module 0x42::example {
    fun just_unit1(): () { () }
 
    fun just_unit2() { () }
 
    fun just_unit3() {}
}
```

脚本函数必须有单元`()`的返回类型：

```rust
script {
    fun do_nothing() {}
}
```

如[元组部分](https://aptos.dev/en/build/smart-contracts/book/tuples)所述，这些元组“值”是虚拟的，并且在运行时不存在。所以对于返回单元`()`的函数来说，在执行期间它根本不会返回任何值。

### 函数体

函数体是一个表达式块。函数的返回值是序列中的最后一个值。

```rust
module 0x42::example {
    fun example(): u64 {
        let x = 0;
        x = x + 1;
        x // returns 'x'
    }
}
```

有关返回的更多信息，请参见[下面的部分](https://aptos.dev/en/build/smart-contracts/book/functions#returning-values)。

有关表达式块的更多信息，请参见[Move变量](https://aptos.dev/en/build/smart-contracts/book/variables)。

### 本地函数

有些函数没有指定主体，而是由VM提供主体。这些函数被标记为`native`。

不修改VM源代码，程序员不能添加新的本地函数。此外，`native`函数的意图是用于标准库代码或给定Move环境所需的功能。

你可能会看到的大多数`native`函数都在标准库代码中，例如`vector`。

```rust
module std::vector {
    native public fun empty<Element>(): vector<Element>;
    // ...
}
```

## 调用

调用函数时，可以通过别名或完全限定名指定名称。

```rust
module 0x42::example {
    public fun zero(): u64 { 0 }
}
 
script {
    use 0x42::example::{Self, zero};
 
    fun call_zero() {
        // With the `use` above all of these calls are equivalent
        0x42::example::zero();
        example::zero();
        zero();
    }
}
```

调用函数时，必须为每个参数提供一个参数。

```rust
module 0x42::example {
    public fun takes_none(): u64 { 0 }
 
    public fun takes_one(x: u64): u64 { x }
 
    public fun takes_two(x: u64, y: u64): u64 { x + y }
 
    public fun takes_three(x: u64, y: u64, z: u64): u64 { x + y + z }
}
 
script {
    use 0x42::example;
 
    fun call_all() {
        example::takes_none();
        example::takes_one(0);
        example::takes_two(0, 1);
        example::takes_three(0, 1, 2);
    }
}
```

类型参数可以指定或推断。两种调用都是等价的。

```rust
module 0x42::example {
    public fun id<T>(x: T): T { x }
}
 
script {
    use 0x42::example;
 
    fun call_all() {
        example::id(0);
        example::id<u64>(0);
    }
}
```

有关更多详细信息，请参见[Move泛型](https://aptos.dev/en/build/smart-contracts/book/generics)。

## 返回值

函数的结果，即其“返回值”，是其函数体的最终值。例如

```rust
module 0x42::example {
    fun add(x: u64, y: u64): u64 {
        x + y
    }
}
```

[如上所述](https://aptos.dev/en/build/smart-contracts/book/functions#function-body)，函数体是[表达式块](https://aptos.dev/en/build/smart-contracts/book/variables)。表达式块可以是各种语句的序列，块中的最后一个表达式将是该块的值。

```rust
module 0x42::example {
    fun double_and_add(x: u64, y: u64): u64 {
        let double_x = x * 2;
        let double_y = y * 2;
        double_x + double_y
    }
}
```

这里的返回值是`double_x + double_y`。

### `return`表达式

函数隐式返回其体求值的值。然而，函数也可以使用显式的`return`表达式：

```rust
module 0x42::example {
    fun f1(): u64 { return 0 }
 
    fun f2(): u64 { 0 }
}
```

这两个函数是等价的。在这个稍微复杂一点的例子中，函数减去两个`u64`值，但如果第二个值太大，则提前返回`0`：

```rust
module 0x42::example {
    fun safe_sub(x: u64, y: u64): u64 {
        if (y > x) return 0;
        x - y
    }
}
```

注意，这个函数的体也可以写成`if (y > x) 0 else x - y`。

然而，`return`在深入其他控制流结构时真正发挥作用。在这个例子中，函数迭代一个向量以找到给定值的索引：

```rust
module 0x42::example {
    use std::vector;
    use std::option::{Self, Option};
 
    fun index_of<T>(v: &vector<T>, target: &T): Option<u64> {
        let i = 0;
        let n = vector::length(v);
        while (i < n) {
            if (vector::borrow(v, i) == target) return option::some(i);
            i = i + 1
        };
 
        option::none()
    }
}
```

不带参数使用`return`是`return ()`的简写。也就是说，以下两个函数是等价的：

```rust
module 0x42::example {
    fun foo1() { return }
 
    fun foo2() { return () }
}
```

## 内联函数

内联函数是在编译时在调用者位置展开的函数体的函数。因此，内联函数不会以独立函数的形式出现在Move字节码中：对它们的所有调用都被编译器展开。在某些情况下，它们可能导致更快的执行并节省燃气。然而，用户应该意识到它们可能导致更大的字节码大小：过度内联可能触发各种大小限制。

可以通过在函数声明中添加`inline`关键字来定义内联函数，如下所示：

```rust
module 0x42::example {
    inline fun percent(x: u64, y: u64): u64 { x * 100 / y }
}
```

如果我们将这个内联函数调用为`percent(2, 200)`，编译器将用内联函数的体替换这个调用，就好像用户写了`2 * 100 / 200`。

### 函数参数和lambda表达式

内联函数支持*函数参数*，它接受lambda表达式（即匿名函数）作为参数。这个特性允许以优雅的方式编写几种常见的编程模式。与内联函数类似，lambda表达式也在调用点展开。

lambda表达式包括一组参数名（用`||`包围）后跟体。一些简单的例子是：`|x| x + 1`，`|x, y| x + y`，`|| 1`，`|| { 1 }`。lambda的体可以引用在定义lambda的范围内可用的变量：这也称为捕获。这些变量可以被lambda表达式读取或写入（如果是可变的）。

函数参数的类型被写为`|<list of parameter types>| <return type>`。例如，当函数参数类型是`|u64, u64| bool`时，任何接受两个`u64`参数并返回`bool`值的lambda表达式都可以作为参数提供。

下面是一个展示这些概念的示例（这个示例取自`std::vector`模块）：

```rust
module 0x42::example {
    /// Fold the function over the elements.
    /// E.g, `fold(vector[1,2,3], 0, f)` is the same as `f(f(f(0, 1), 2), 3)`.
    public inline fun fold<Accumulator, Element>(
        v: vector<Element>,
        init: Accumulator,
        f: |Accumulator, Element|Accumulator
    ): Accumulator {
        let accu = init;
        // Note: `for_each` is an inline function, but is not shown here.
        for_each(v, |elem| accu = f(accu, elem));
        accu
    }
}
```

`for_each`函数的类型签名是`fun for_each<Element>(v: vector<Element>, f: |Element|)`。它的第二个参数`f`是一个函数参数，接受任何消费一个`Element`并返回无值的lambda表达式。在代码示例中，我们使用lambda表达式`|elem| accu = f(accu, elem)`作为这个函数参数的参数。注意，这个lambda表达式捕获了外部作用域中的变量`accu`。

### 当前限制

计划在未来放宽这些限制，但目前，

- 只有内联函数可以有函数参数。
- 只有显式的lambda表达式可以作为参数传递给内联函数的函数参数。
- 内联函数和lambda表达式
    - 不能有`return`表达式；或者自由的`break`或`continue`表达式（出现在循环之外）
    - 不能返回lambda表达式。
- 只涉及内联函数的循环递归是不允许的。
- lambda表达式中的参数不能被类型注释（例如，`|x: u64| x + 1`是不允许的）：它们的类型是推断出来的。

### 额外考虑

- 避免在公共内联函数中使用模块私有常量/方法。当这些内联函数在该模块之外被调用时，调用点的原地展开会导致对私有常量/方法的无效访问。
- 避免将大型函数标记为内联，这些函数在不同位置被调用。也避免内联函数递归调用许多其他内联函数。这些可能导致过度内联并增加字节码大小。
- 内联函数可以用于返回全局存储的引用，这是非内联函数无法做到的。

### 内联函数和引用

如上文[“技巧”部分](https://aptos.dev/en/build/smart-contracts/book/functions#return-type)简要提到的，`inline`函数可以比普通函数更自由地使用引用。

例如，对非`inline`函数的调用的实际参数可能不会不安全地别名（多个`&`参数引用同一个对象，至少其中一个是`&mut`），但是对`inline`函数的调用不一定有这个限制，只要函数内联后没有引用使用冲突。

```rust
inline fun add(dest: &mut u64, a: &u64, b: &u64) {
    *dest = *a + *b;
}
 
fun user(...) {
    ...
    x = 3;
    add(&mut x, &x, &x);  // legal only because of inlining
    ...
}
```

从非内联函数返回的引用类型值必须从传递给函数的引用参数派生，但对于内联函数，只要引用值在内联后在函数作用域内，就不必如此。

引用安全性和“借用检查”的确切细节是复杂的，并在其他地方有文档记录。高级Move用户通过理解“借用检查”仅在所有`inline`函数调用展开后才会发生，从而找到新的表达方式。

然而，随着这种力量而来的是新的责任：非平凡的`inline`函数的文档应该解释在调用点对引用参数和结果的任何潜在限制。

## 点（接收器）函数调用风格

**从[[附录：Move 编译器 v2 介绍|Move 2.0]]开始**

通过使用众所周知的名称`self`作为函数声明的第一个参数，可以启用使用`.`语法调用此函数——通常也称为接收器风格语法。示例：

```rust
module 0x42::example {
    struct S {}
 
    fun foo(self: &S, x: u64) { /* ... */ }
 
    //...
 
    fun example() {
        let s = S {};
        s.foo(1);
    }
}
```

调用`s.foo(1)`是`foo(&s, 1)`的语法糖。注意编译器自动插入了引用运算符。对于`foo`，第二种旧的标记仍然可用，因此可以逐步引入新的调用风格，而不会破坏现有代码。

`self`参数的类型可以是结构体或对结构体的不可变或可变引用。结构体必须在与函数相同的模块中声明。

注意，你不需要`use`引入接收器函数的模块。编译器将根据调用中`s`的参数类型`s.foo(1)`自动找到这些函数。这与引用运算符的自动插入相结合，可以使使用此语法的代码更加简洁。
