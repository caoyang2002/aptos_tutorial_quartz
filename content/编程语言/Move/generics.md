---
title: 通用
---
# 通用

泛型可用于定义不同输入数据类型的函数和结构。这种语言特征有时被称为_参数多态性_。在Move中，我们通常会将术语泛型与类型参数和类型参数互换使用。

泛型通常用于库代码，例如在矢量中，以声明适用于任何可能实例化（满足指定约束）的代码。在其他框架中，通用代码有时可用于与全局存储交互，以多种不同的方式进行交互，这些方式仍然共享相同的实现。

## 声明类型参数[](https://aptos.guide/en/build/smart-contracts/book/generics#declaring-type-parameters)

函数和结构都可以在其签名中获取类型参数列表，由一对角括号括起来`<...>`。

### 通用函数[](https://aptos.guide/en/build/smart-contracts/book/generics#generic-functions)

函数的类型参数放在函数名称之后和（值）参数列表之前。以下代码定义了一个通用身份函数，该函数接受任何类型的值并返回该值不变。

```rust
module 0x42::example {
  fun id<T>(x: T): T {
    // this type annotation is unnecessary but valid
    (x: T)
  }
}
```

一旦定义，类型参数`T`可用于参数类型、返回类型和函数体内部。

### 通用结构[](https://aptos.guide/en/build/smart-contracts/book/generics#generic-structs)

结构的类型参数放在结构名称之后，可用于命名字段的类型。

```rust
module 0x42::example {
  struct Foo<T> has copy, drop { x: T }
 
  struct Bar<T1, T2> has copy, drop {
    x: T1,
    y: vector<T2>,
  }
}
```

请注意，[不必使用类型参数](https://aptos.guide/en/build/smart-contracts/book/generics#unused-type-parameters)

## 类型参数[](https://aptos.guide/en/build/smart-contracts/book/generics#type-arguments)

### 调用通用函数[](https://aptos.guide/en/build/smart-contracts/book/generics#calling-generic-functions)

调用泛型函数时，可以在由一对角括号包围的列表中指定函数类型参数的类型参数。

```rust
module 0x42::example {
  fun foo() {
    let x = id<bool>(true);
  }
}
```

如果您没有指定类型参数，Move的[类型推断](https://aptos.guide/en/build/smart-contracts/book/generics#type-inference)将为您提供它们。

### 使用通用结构[](https://aptos.guide/en/build/smart-contracts/book/generics#using-generic-structs)

同样，在构造或破坏泛型类型的值时，可以附加结构类型参数的类型参数列表。

```
module 0x42::example {
  fun foo() {
    let foo = Foo<bool> { x: true };
    let Foo<bool> { x } = foo;
  }
}
```

如果您没有指定类型参数，Move的[类型推断](https://aptos.guide/en/build/smart-contracts/book/generics#type-inference)将为您提供它们。

### 类型参数不匹配[](https://aptos.guide/en/build/smart-contracts/book/generics#type-argument-mismatch)

如果您指定类型参数，并且它们与提供的实际值冲突，则会给出一个错误：

```
module 0x42::example {
  fun foo() {
    let x = id<u64>(true); // error! true is not a u64
  }
}
```

同样：

```
module 0x42::example {
  fun foo() {
    let foo = Foo<bool> { x: 0 }; // error! 0 is not a bool
    let Foo<address> { x } = foo; // error! bool is incompatible with address
  }
}
```

## 类型推断[](https://aptos.guide/en/build/smart-contracts/book/generics#type-inference)

在大多数情况下，Move编译器将能够推断类型参数，因此您不必明确地写下它们。如果我们省略类型参数，以下是上述示例的样子：

```
module 0x42::example {
  fun foo() {
    let x = id(true);
    //        ^ <bool> is inferred
 
    let foo = Foo { x: true };
    //           ^ <bool> is inferred
 
    let Foo { x } = foo;
    //     ^ <bool> is inferred
  }
}
```

注意：当编译器无法推断类型时，您需要手动注释它们。一个常见的场景是调用一个类型参数仅出现在返回位置的函数。

```rust
module 0x2::m {
  use std::vector;
 
  fun foo() {
    // let v = vector::new();
    //                    ^ The compiler cannot figure out the element type.
 
    let v = vector::new<u64>();
    //                 ^~~~~ Must annotate manually.
  }
}
```

但是，如果该返回值在该函数后面使用，编译器将能够推断类型：

```
module 0x2::m {
  use std::vector;
 
  fun foo() {
    let v = vector::new();
    //                 ^ <u64> is inferred
    vector::push_back(&mut v, 42);
  }
}
```

## 未使用的类型参数[](https://aptos.guide/en/build/smart-contracts/book/generics#unused-type-parameters)

对于结构定义，未使用的类型参数是不会出现在结构中定义的任何字段中，但在编译时进行静态检查。移动允许未使用的类型参数，因此以下结构定义是有效的：

```
module 0x2::m {
  struct Foo<T> {
    foo: u64
  }
}
```

在建模某些概念时，这可能很方便。这里有一个例子：

```
module 0x2::m {
  // Currency Specifiers
  struct Currency1 {}
  struct Currency2 {}
 
  // A generic coin type that can be instantiated using a currency
  // specifier type.
  //   e.g. Coin<Currency1>, Coin<Currency2> etc.
  struct Coin<Currency> has store {
    value: u64
  }
 
  // Write code generically about all currencies
  public fun mint_generic<Currency>(value: u64): Coin<Currency> {
    Coin { value }
  }
 
  // Write code concretely about one currency
  public fun mint_concrete(value: u64): Coin<Currency1> {
    Coin { value }
  }
}
```

在本例中，`struct Coin<Currency>`在`Currency`类型参数上是通用的，该参数指定硬币的货币，并允许在任何货币上通用地编写代码，也可以具体地在特定货币上编写代码。即使`Currency`类型参数没有出现在`Coin`中定义的任何字段中，这种通用性也适用。

### 幻影类型参数[](https://aptos.guide/en/build/smart-contracts/book/generics#phantom-type-parameters)

在上面的示例中，尽管`struct Coin`要求`store`能力，但`Coin<Currency1>`和`Coin<Currency2>`都不具有`store`能力。这是因为[条件能力和通用类型的](https://aptos.guide/en/build/smart-contracts/book/abilities#conditional-abilities-and-generic-types)规则，以及`Currency1`和`Currency2`没有`store`能力，尽管它们甚至没有在`struct Coin`的主体中使用。这可能会造成一些不愉快的后果。例如，我们无法将`Coin<Currency1>`放入全球存储的钱包中。

一个可能的解决方案是向`Currency1`和`Currency2`添加虚假能力注释（即`struct Currency1 has store {}`）。但是，这可能会导致错误或安全漏洞，因为它削弱了具有不必要能力声明的类型。例如，我们永远不会期望全局存储中的资源具有`Currency1`类型的字段，但通过虚假`store`能力，这是可能的。此外，虚假注释具有传染性，需要许多在未使用的类型参数上通用的功能也包括必要的约束。

幻影类型参数解决了这个问题。未使用的类型参数可以标记为_幻影_类型参数，这些参数不参与结构的能力推导。这样，在推导通用类型的能力时，不考虑幻影类型参数的参数，从而避免了对虚假能力注释的需求。为了使这个宽松的规则是合理的，Move的类型系统保证了声明为asphantom的参数要么在结构定义中根本不使用，要么仅用作同样声明为`phantom`的类型参数的参数。

#### 声明[](https://aptos.guide/en/build/smart-contracts/book/generics#declaration)

在结构定义中，可以通过在声明前添加`phantom`关键字来声明类型参数为幻影。如果类型参数被声明为幻影，我们说它是一个幻影类型参数。在定义结构时，Move的类型检查器确保每个幻影类型参数要么不在结构定义中使用，要么仅用作幻影类型参数的参数。

更正式地说，如果一个类型被用作幻影类型参数的参数，我们说该类型出现在_幻影位置_。有了这个定义，正确使用幻影参数的规则可以指定如下：**幻影类型参数只能出现在幻影位置**。

以下两个示例显示了幻影参数的有效用法。在第一个中，在结构定义中根本没有使用参数`T1`。在第二个中，参数`T1`仅用作幻影类型参数的参数。

```rust
module 0x2::m {
  struct S1<phantom T1, T2> { f: u64 }
  //                ^^
  //                Ok: T1 does not appear inside the struct definition
 
 
  struct S2<phantom T1, T2> { f: S1<T1, T2> }
  //                                ^^
  //                                Ok: T1 appears in phantom position
}
```

以下代码显示了违反该规则的示例：

```rust
module 0x2::m {
  struct S1<phantom T> { f: T }
  //                        ^
  //                        Error: Not a phantom position
 
  struct S2<T> { f: T }
 
  struct S3<phantom T> { f: S2<T> }
  //                           ^
  //                           Error: Not a phantom position
}
```

#### 实例化[](https://aptos.guide/en/build/smart-contracts/book/generics#instantiation)

实例化结构时，在推导结构能力时，排除幻影参数的参数。例如，考虑以下代码：

```
module 0x2::m {
  struct S<T1, phantom T2> has copy { f: T1 }
  struct NoCopy {}
  struct HasCopy has copy {}
}
```

现在考虑类型`S<HasCopy, NoCopy>`。由于`S`是用`copy`定义的，并且所有非幻影参数都有`copy`，那么`S<HasCopy, NoCopy>`也有`copy`。

#### 具有能力约束的幻影类型参数[](https://aptos.guide/en/build/smart-contracts/book/generics#phantom-type-parameters-with-ability-constraints)

能力约束和幻影类型参数是正交特征，即幻影参数可以用能力约束声明。当使用能力约束实例化幻影类型参数时，类型参数必须满足该约束，即使参数是幻影。例如，以下定义是完全有效的：

```
module 0x2::m {  
	struct S<phantom T: copy> {}
}
```

通常的限制适用，`T`只能用具有`copy`的参数进行实例化。

## 约束[](https://aptos.guide/en/build/smart-contracts/book/generics#constraints)

在上面的示例中，我们演示了如何使用类型参数来定义“未知”类型，这些类型可以由呼叫者稍后插入。然而，这意味着类型系统几乎没有关于类型的信息，必须以非常保守的方式进行检查。从某种意义上说，类型系统必须假设无约束的泛型最坏情况。简而言之，默认情况下，通用类型参数没有[能力](https://aptos.guide/en/build/smart-contracts/book/abilities)。

这就是约束发挥作用的地方：它们提供了一种方法来指定这些未知类型具有哪些属性，以便类型系统可以允许否则不安全的操作。

### 声明约束[](https://aptos.guide/en/build/smart-contracts/book/generics#declaring-constraints)

可以使用以下语法对类型参数施加约束。

```
// T is the name of the type parameter
T: <ability> (+ <ability>)*
```

`<ability>`可以是四种[能力](https://aptos.guide/en/build/smart-contracts/book/abilities)中的任何一种，类型参数可以同时受制为多种能力。因此，以下所有内容都是有效的类型参数声明：

```
T: copy
T: copy + drop
T: copy + drop + store + key
```

### 验证约束[](https://aptos.guide/en/build/smart-contracts/book/generics#verifying-constraints)

在调用站点检查约束，因此以下代码不会编译。

```
module 0x2::m {
  struct Foo<T: key> { x: T }
 
  struct Bar { x: Foo<u8> }
  //                  ^ error! u8 does not have 'key'
 
  struct Baz<T> { x: Foo<T> }
  //                     ^ error! T does not have 'key'
}
```

```
module 0x2::m {
  struct R {}
 
  fun unsafe_consume<T>(x: T) {
    // error! x does not have 'drop'
  }
 
  fun consume<T: drop>(x: T) {
    // valid!
    // x will be dropped automatically
  }
 
  fun foo() {
    let r = R {};
    consume<R>(r);
    //      ^ error! R does not have 'drop'
  }
}
```

```
module 0x2::m {
  struct R {}
 
  fun unsafe_double<T>(x: T) {
    (copy x, x)
    // error! x does not have 'copy'
  }
 
  fun double<T: copy>(x: T) {
    (copy x, x) // valid!
  }
 
  fun foo(): (R, R) {
    let r = R {};
    double<R>(r)
    //     ^ error! R does not have 'copy'
  }
}
```

有关更多信息，请参阅关于[条件能力和通用类型的](https://aptos.guide/en/build/smart-contracts/book/abilities#conditional-abilities-and-generic-types)能力部分。

## 递归的限制[](https://aptos.guide/en/build/smart-contracts/book/generics#limitations-on-recursions)

### 递归结构[](https://aptos.guide/en/build/smart-contracts/book/generics#recursive-structs)

通用结构不能包含相同类型的字段，无论是直接还是间接的，即使使用不同的类型参数。以下所有结构定义都是无效的：

```
module 0x2::m {
  struct Foo<T> {
    x: Foo<u64> // error! 'Foo' containing 'Foo'
  }
 
  struct Bar<T> {
    x: Bar<T> // error! 'Bar' containing 'Bar'
  }
 
  // error! 'A' and 'B' forming a cycle, which is not allowed either.
  struct A<T> {
    x: B<T, u64>
  }
 
  struct B<T1, T2> {
    x: A<T1>,
    y: A<T2>
  }
}
```

### 高级主题：类型级递归[](https://aptos.guide/en/build/smart-contracts/book/generics#advanced-topic-type-level-recursions)

移动允许递归调用泛型函数。然而，当与通用结构结合使用时，在某些情况下，这可能会创建无限数量的类型，允许这意味着为编译器、vm和其他语言组件添加不必要的复杂性。因此，禁止这种递归。

允许：

```
module 0x2::m {
  struct A<T> {}
 
  // Finitely many types -- allowed.
  // foo1<T> -> foo1<T> -> foo1<T> -> ... is valid
  fun foo1<T>() {
    foo1<T>();
  }
 
  // Finitely many types -- allowed.
  // foo2<T> -> foo2<A<u64>> -> foo2<A<u64>> -> ... is valid
  fun foo2<T>() {
    foo2<A<u64>>();
  }
}
```

不允许：

```
module 0x2::m {
  struct A<T> {}
 
  // Infinitely many types -- NOT allowed.
  // error!
  // foo<T> -> foo<A<T>> -> foo<A<A<T>>> -> ...
  fun foo<T>() {
    foo<A<T>>();
  }
}
```

```rust
module 0x2::n {
  struct A<T> {}
 
  // Infinitely many types -- NOT allowed.
  // error!
  // foo<T1, T2> -> bar<T2, T1> -> foo<T2, A<T1>>
  //   -> bar<A<T1>, T2> -> foo<A<T1>, A<T2>>
  //   -> bar<A<T2>, A<T1>> -> foo<A<T2>, A<A<T1>>>
  //   -> ...
  fun foo<T1, T2>() {
    bar<T2, T1>();
  }
 
  fun bar<T1, T2>() {
    foo<T1, A<T2>>();
  }
}
```

请注意，类型级递归的检查是基于对调用站点的保守分析，不考虑控制流或运行时值。

```
module 0x2::m {
  struct A<T> {}
 
  fun foo<T>(n: u64) {
    if (n > 0) {
      foo<A<T>>(n - 1);
    };
  }
}
```

上述示例中的函数将在技术上终止任何给定的输入，因此只创建有限多个类型，但它仍然被Move的类型系统视为无效。