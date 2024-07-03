---
title: 函数
---
# 函数

Move中的函数语法在模块函数和脚本函数之间共享。模块内部的函数是可重用的，而脚本函数仅用于调用事务一次。

## 声明[](https://aptos.guide/en/build/smart-contracts/book/functions#declaration)

函数用`fun`关键字声明，后跟函数名称、类型参数、参数、返回类型、获取注释，最后是函数主体。

```
fun <identifier><[type_parameters: constraint],*>([identifier: type],*): <return_type> <acquires [identifier],*> <function_body>
```

例如

```
fun foo<T1, T2>(x: u64, y: T1, z: T2): (T2, T1, u64) { (z, y, x) }
```

### 可见性[](https://aptos.guide/en/build/smart-contracts/book/functions#visibility)

默认情况下，模块函数只能在同一模块内调用。这些内部（有时称为私有）函数不能从其他模块或脚本中调用。

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

要允许从其他模块或脚本访问，该函数必须声明为`public`或`public(friend)`

#### `public`能见度[](https://aptos.guide/en/build/smart-contracts/book/functions#public-visibility)

`public`函数可以由_任何_模块或脚本中定义_的任何_函数调用。如以下示例所示，可以通过以下方式调用`public`函数：

- 在同一模块中定义的其他功能，
- 在另一个模块中定义的函数，或
- 脚本中定义的函数。

公共函数可以采用的参数类型及其返回类型也没有限制。

```
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

#### `public(friend)`能见度[](https://aptos.guide/en/build/smart-contracts/book/functions#publicfriend-visibility)

`public(friend)`可见性修饰符是`public`修饰符的一种更受限制的形式，可以更好地控制函数的使用位置。`public(friend)`函数可以通过以下方式调用：

- 在同一模块中定义的其他函数，或
- 在**朋友列表中**明确指定的模块中定义的函数（请参阅有关如何指定朋友列表的[朋友](https://aptos.guide/en/build/smart-contracts/book/friends)）。

请注意，由于我们不能将脚本声明为模块的朋友，因此脚本中定义的函数永远不能调用`public(friend)`函数。

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

### `entry`修饰符[](https://aptos.guide/en/build/smart-contracts/book/functions#entry-modifier)

`entry`修饰符旨在允许模块函数像脚本一样安全直接调用。这允许模块编写者指定可以调用哪些函数来开始执行。然后，模块编写者知道，任何非`entry`函数都将从已经在执行的Move程序中调用。

从本质上讲，`entry`函数是模块的“主要”函数，它们指定了移动程序开始执行的位置。

但请注意，其他移动函数_仍然可以_调用`entry`函数。因此，虽然它们_可以_作为移动程序的开始，但它们并不局限于这种情况。

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

甚至内部功能也可以标记为`entry`！这使您可以保证该函数仅在执行开始时调用（假设您不在模块的其他地方调用它）

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

入口函数可以接受原始类型、字符串和向量参数，但不能接受结构（例如选项）。它们也不得有任何返回值。

### 姓名[](https://aptos.guide/en/build/smart-contracts/book/functions#name)

函数名可以以字母`a`到`z`或字母`A`到`Z`开头。在第一个字符之后，函数名可以包含下划线`_`、字母`a`到`z`、字母`A`到`Z`或数字`0`到9。

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

### 类型参数[](https://aptos.guide/en/build/smart-contracts/book/functions#type-parameters)

在名称之后，函数可以有类型参数

```rust
module 0x42::example {
    fun id<T>(x: T): T { x }
 
    fun example<T1: copy, T2>(x: T1, y: T2): (T1, T1, T2) { (copy x, x, y) }
}
```

有关更多详细信息，请参阅[移动通用](https://aptos.guide/en/build/smart-contracts/book/generics)。

### 参数[](https://aptos.guide/en/build/smart-contracts/book/functions#parameters)

函数参数用局部变量名声明，后跟类型注释

```rust
module 0x42::example {
    fun add(x: u64, y: u64): u64 { x + y }
}
```

我们读这个，因为`x`有类型`u64`

函数根本不需要任何参数。

```rust
module 0x42::example {    
	fun useless() {}
}
```

这对于创建新数据或空数据结构的函数来说非常常见

```rust
module 0x42::example {
    struct Counter { count: u64 }
 
    fun new_counter(): Counter {
        Counter { count: 0 }
    }
}
```

### 收购[](https://aptos.guide/en/build/smart-contracts/book/functions#acquires)

当函数使用`move_from`、`borrow_global`或`borrow_global_mut`访问资源时，该函数必须指示它`acquires`该资源。然后，Move的类型系统使用它来确保全局存储中的引用是安全的，特别是没有悬垂的引用进入全局存储中。

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

`acquires`对于模块内的传递性调用，还必须添加注释。从另一个模块对这些函数的调用不需要用这些获取进行注释，因为一个模块无法访问另一个模块中声明的资源——因此不需要注释来确保引用安全。

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

一个功能`acquire`尽可能多的资源

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

### 返回类型[](https://aptos.guide/en/build/smart-contracts/book/functions#return-type)

在参数之后，函数指定其返回类型。

```rust
module 0x42::example {    
	fun zero(): u64 { 0 }
}
```

这里`: u64`表示函数的返回类型是`u64`。

如果从输入引用派生，函数可以返回不可变`&`或可变`&mut`[引用](https://aptos.guide/en/build/smart-contracts/book/references)。请记住，这意味着函数[不能返回对全局存储的引用，](https://aptos.guide/en/build/smart-contracts/book/references#references-cannot-be-stored)除非它是[内联函数](https://aptos.guide/en/build/smart-contracts/book/functions#inline-functions)。

使用元组，函数可以返回多个值：

```rust
module 0x42::example {    
	fun one_two_three(): (u64, u64, u64) { 
		(0, 1, 2) 
	}
}
```

如果没有指定返回类型，则该函数具有单位`()`的隐式返回类型。这些功能是等价的：

```rust
module 0x42::example {    
	fun just_unit1(): () { () }     
	fun just_unit2() { () }     
	fun just_unit3() {}
}
```

`script`函数必须具有单位`()`的返回类型：

```
script {    
	fun do_nothing() {}
}
```

如[元组部分](https://aptos.guide/en/build/smart-contracts/book/tuples)所述，这些元组“值”是虚拟的，在运行时不存在。因此，对于返回单位`()`的函数，它在执行期间根本不会返回任何值。

### 功能体[](https://aptos.guide/en/build/smart-contracts/book/functions#function-body)

函数的主体是一个表达式块。函数的返回值是序列中的最后一个值

```
module 0x42::example {
    fun example(): u64 {
        let x = 0;
        x = x + 1;
        x // returns 'x'
    }
}
```

[有关退货的更多信息，](https://aptos.guide/en/build/smart-contracts/book/functions#returning-values)请参阅[以下部分](https://aptos.guide/en/build/smart-contracts/book/functions#returning-values)

有关表达式块的更多信息，请参阅[移动变量](https://aptos.guide/en/build/smart-contracts/book/variables)。

### 原生函数[](https://aptos.guide/en/build/smart-contracts/book/functions#native-functions)

有些功能没有指定主体，而是由虚拟机提供主体。这些功能被标记为`native`。

如果不修改虚拟机源代码，程序员就无法添加新的本机函数。此外，`native`函数用于标准库代码或给定移动环境所需的功能。

您可能会看到的大多数`native`函数都在标准库代码中，例如`vector`

```
module std::vector {    
	native public fun empty<Element>(): vector<Element>;    
	// ...
}
```

## 呼叫[](https://aptos.guide/en/build/smart-contracts/book/functions#calling)

调用函数时，可以通过别名或完全限定指定名称

```
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

调用函数时，必须为每个参数提供参数。

```
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

类型参数可以指定或推断。两个电话是等价的。

```
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

有关更多详细信息，请参阅[移动通用](https://aptos.guide/en/build/smart-contracts/book/generics)。

## 返回值[](https://aptos.guide/en/build/smart-contracts/book/functions#returning-values)

函数的结果，其“返回值”，是其函数体的最终值。例如

```
module 0x42::example {
    fun add(x: u64, y: u64): u64 {
        x + y
    }
}
```

[如上所述](https://aptos.guide/en/build/smart-contracts/book/functions#function-body)，函数的主体是一个[表达式块](https://aptos.guide/en/build/smart-contracts/book/variables)。表达式块可以是各种语句的序列，块中的最终表达式将是该块的值。

```
module 0x42::example {
    fun double_and_add(x: u64, y: u64): u64 {
        let double_x = x * 2;
        let double_y = y * 2;
        double_x + double_y
    }
}
```

这里的返回值是`double_x + double_y`

### `return`表达[](https://aptos.guide/en/build/smart-contracts/book/functions#return-expression)

函数隐式返回其主体求值的值。然而，函数也可以使用explicitreturn表达式：

```
module 0x42::example {
    fun f1(): u64 { return 0 }
 
    fun f2(): u64 { 0 }
}
```

这两个功能是等价的。在这个稍微更复杂的示例中，该函数减去两个`u64`值，但如果第二个值太大，则提前返回`0`：

```
module 0x42::example {
    fun safe_sub(x: u64, y: u64): u64 {
        if (y > x) return 0;
        x - y
    }
}
```

请注意，该函数的主体也可以写成`if (y > x) 0 else x - y`。

然而，`return`真正闪耀的地方在于在其他控制流结构的深处退出。在本例中，该函数通过向量遍转以查找给定值的索引：

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

在没有参数的情况下使用`return`是`return ()`的缩写。也就是说，以下两个函数是等价的：

```
module 0x42::example {
    fun foo1() { return }
 
    fun foo2() { return () }
}
```

## 内联函数[](https://aptos.guide/en/build/smart-contracts/book/functions#inline-functions)

内联函数是编译期间在调用方位置扩展其主体的函数。因此，内联函数不会作为单独的函数出现在Move bytecode中：所有对它们的调用都由编译器扩展。在某些情况下，它们可能会导致更快的执行和节省汽油。然而，用户应该意识到，它们可能会导致更大的字节码大小：过度的内联可能会触发各种大小限制。

可以通过将`inline`关键字添加到函数声明中来定义内联函数，如下所示：

```rust
module 0x42::example {
    inline fun percent(x: u64, y: u64): u64 { x * 100 / y }
}
```

如果我们将此内联函数调用为`percent(2, 200)`编译器将用内联函数的主体替换此调用，就像用户写了`2 * 100 / 200`一样。

### 函数参数和lambda表达式[](https://aptos.guide/en/build/smart-contracts/book/functions#function-parameters-and-lambda-expressions)

内联函数支持_函数参数_，它们接受lambda表达式（即匿名函数）作为参数。此功能允许优雅地编写几种常见的编程模式。与内联函数类似，lambda表达式也在调用站点上展开。

A lambda expression includes a list of parameter names (enclosed within `||`) followed by the body. Some simple examples are: `|x| x + 1`, `|x, y| x + y`, `|| 1`, `|| { 1 }`. A lambda’s body can refer to variables available in the scope where the lambda is defined: this is also known as capturing. Such variables can be read or written (if mutable) by the lambda expression.

函数参数的类型写为`|<list of parameter types>| <return type>`。例如，当函数参数类型为`|u64, u64| bool`时，任何接受两个`u64`参数并返回`bool`值的lambda表达式都可以作为参数提供。

以下是展示许多这些概念的示例（此示例取自thestd`std::vector`模块）：

```
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

省略的公共内联函数`for_each`的类型签名`fun for_each<Element>(v: vector<Element>, f: |Element|)`它的第二个参数`f`是一个函数参数，它接受任何消耗`Element`且不返回任何内容的lambda表达式。在代码示例中，我们使用lambda表达式`|elem| accu = f(accu, elem)`作为此函数参数的参数。请注意，此lambda表达式从外部范围捕获变量`accu`。

### 当前限制[](https://aptos.guide/en/build/smart-contracts/book/functions#current-restrictions)

计划在未来放松其中一些限制，但目前，

- 只有内联函数才能有函数参数。
- 只有显式lambda表达式才能作为参数传递给内联函数的函数参数。
- 内联函数和lambda表达式
    - 不能有`return`表达式；或自由`break`或`continue`表达式（发生在循环之外）
    - 无法返回lambda表达式。
- 不允许仅涉及内联函数的循环递归。
- lambda表达式中的参数不得有类型注释（例如，不允许`|x: u64| x + 1`）：推断其类型。

### 其他考虑因素[](https://aptos.guide/en/build/smart-contracts/book/functions#additional-considerations)

- 避免在公共内联函数中使用模块私有常量/方法。当此类内联函数在该模块之外调用时，调用站点的就地扩展会导致私有常量/方法的无效访问。
- 避免将在不同位置调用的大型函数标记为内联。还要避免内联函数以传递方式调用许多其他内联函数。这些可能会导致过度内联并增加字节码大小。
- 内联函数可用于返回对全局存储的引用，这是非内联函数无法做到的。

### 内联功能和参考[](https://aptos.guide/en/build/smart-contracts/book/functions#inline-functions-and-references)

正如[上面的“提示”中](https://aptos.guide/en/build/smart-contracts/book/functions#return-type)简要提到的`inline`函数可以比普通函数更自由地使用引用。

例如，对非`inline`函数调用的实际参数可能不会被不安全地别名化（多个`&`参数引用同一对象，其中至少有一个`&mut`），但对`inline`函数的调用不一定有这种限制，只要函数内联后没有引用使用冲突。

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

从非内联函数返回的引用类型值必须从传递给该函数的引用参数派生，但对于内联函数来说，只要引用值在内联后在函数范围内，就不必如此。

参考安全和“借款检查”的确切细节很复杂，并在其他地方有记录。高级移动用户通过理解“借用检查”只有在所有`inline`函数调用被扩展后才会发生，从而找到新的表现力。

然而，随着这种力量而来的是新的责任：非平凡的`inline`函数的文档应该解释对呼叫站点的参考参数和结果的任何潜在限制。

## 点（接收器）函数调用样式[](https://aptos.guide/en/build/smart-contracts/book/functions#dot-receiver-function-call-style)

_自语言版本2.0以来_

通过使用众所周知的名称`self`作为函数声明的第一个参数，可以使用`.`语法调用此函数——通常也称为接收器样式语法。示例：

```
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

调用`s.foo(1)`是`foo(&s, 1)`的语法糖。请注意，编译器会自动插入引用运算符。第二，旧符号仍然可用于`foo`，因此可以在不破坏现有代码的情况下增量引入新的调用样式。

`self`参数的类型可以是结构，也可以是对结构的不可变或可变引用。结构必须与函数在同一模块中声明。

请注意，您不需要`use`引入接收器功能的模块。编译器将在`s.foo(1)`等调用中根据`s`的参数类型自动找到这些函数。这与自动插入引用运算符相结合，可以使使用此语法的代码更加简洁。