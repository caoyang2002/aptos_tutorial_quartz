---
title: 第四章 局部变量和作用域
---
# 局部变量和作用域

Move 中的局部变量词法上（静态）定域。新变量通过关键字 `let` 引入，它将遮蔽任何具有相同名称的先前局部变量。局部变量是可变的，并且可以直接和通过可变引用进行更新。

# 声明局部变量
## `let` 绑定
Move 程序使用 `let` 将变量名称关联到值：

```rust
script {
  fun example() {
    let x = 1;
    let y = x + x;
  }
}
```


`let` 也可以在不将值绑定到局部变量的情况下使用。

```rust
script {
  fun example() {
    let x;
  }
}
```

然后可以在稍后为该局部变量赋值。

```rust
script {
  fun example() {
    let x;
    if (cond) {
      x = 1
    } else {
      x = 0
    }
  }
}
```

当尝试从循环中提取值且无法提供默认值时，这可能非常有用。
```rust
script {
  fun example() {
    let x;
    let cond = true;
    let i = 0;
    loop {
      (x, cond) = foo(i);
      if (!cond) break;
      i = i + 1;
    }
  }
}
```

## 变量必须在使用前赋值

Move 的类型系统阻止在为局部变量赋值之前使用它。

```rust
script {
  fun example() {
    let x;
    x + x; // 错误，`x` 没有值
  }
}
```

```rust
script {
  fun example() {
    let x;
    if (cond) x = 0;
    x + x; // ERROR!
  }
}
```

```rust
script {
  fun example() {
    let x;
    while (cond) x = 0;
    x + x; // ERROR!
  }
}
```
## 有效的变量名称
变量名称可以包含下划线 _、字母 a 到 z、字母 A 到 Z 和数字 0 到 9。变量名称必须以下划线 _ 或字母 a 到 z 开头。它们不能以大写字母开头。

```rust
script {
  fun example() {
    // all valid
    let x = e;
    let _x = e;
    let _A = e;
    let x0 = e;
    let xA = e;
    let foobar_123 = e;
 
    // all invalid
    let X = e; // ERROR!
    let Foo = e; // ERROR!
  }
}
```

## 类型注解
局部变量的类型几乎总是可以由 Move 的类型系统推导、推断得出。然而，Move 允许显式的类型注解，这对于可读性、清晰性或调试性可能很有用。添加类型注解的语法是：

```rust
script {
  fun example() {
    let x: T = e; // "Variable x of type T is initialized to expression e"
  }
}
```

一些显式类型注解的示例：

```rust
module 0x42::example {
 
  struct S { f: u64, g: u64 }
 
  fun annotated() {
    let u: u8 = 0;
    let b: vector<u8> = b"hello";
    let a: address = @0x0;
    let (x, y): (&u64, &mut u64) = (&0, &mut 1);
    let S { f, g: f2 }: S = S { f: 0, g: 1 };
  }
}
```

请注意，类型注解必须始终在模式的右侧：

```rust
script {
  fun example() {
    let (x: &u64, y: &mut u64) = (&0, &mut 1); // ERROR! should be let (x, y): ... =
  }
}
```

## 当注解是必要的
在某些情况下，如果类型系统无法推断类型，则需要本地类型注解。这通常发生在泛型类型的类型参数无法推断时。例如：

```rust
script {
  fun example() {
    let _v1 = vector::empty(); // ERROR!
    //        ^^^^^^^^^^^^^^^ Could not infer this type. Try adding an annotation
    let v2: vector<u64> = vector::empty(); // no error
  }
}
```

在更罕见的情况下，类型系统可能无法为发散代码（其中所有后续代码都不可达）推断类型。`return` 和 `abort` 都是表达式，可以具有任何类型。如果一个循环有 `break`，则其类型为 `()`，但如果没有从循环中跳出，则它可能具有任何类型。如果这些类型无法推断，则需要类型注解。例如，此代码：

```rust
script {
  fun example() {
    let a: u8 = return ();
    let b: bool = abort 0;
    let c: signer = loop ();
 
    let x = return (); // ERROR!
    //  ^ Could not infer this type. Try adding an annotation
    let y = abort 0; // ERROR!
    //  ^ Could not infer this type. Try adding an annotation
    let z = loop (); // ERROR!
    //  ^ Could not infer this type. Try adding an annotation
  }
}
```

向此代码添加类型注解将暴露有关死代码或未使用的局部变量的其他错误，但该示例对于理解此问题仍然有帮助。

## 使用元组的多个声明
`let` 可以使用元组一次引入多个局部变量。括号内声明的局部变量被初始化为元组中的相应值。

```rust
script {
  fun example() {
    let () = ();
    let (x0, x1) = (0, 1);
    let (y0, y1, y2) = (0, 1, 2);
    let (z0, z1, z2, z3) = (0, 1, 2, 3);
  }
}
```

表达式的类型必须与元组模式的基数完全匹配。

```rust
script {
  fun example() {
    let (x, y) = (0, 1, 2); // ERROR!
    let (x, y, z, q) = (0, 1, 2); // ERROR!
  }
}
```

在单个 `let` 中，不能用相同的名称声明多个局部变量。

```rust
script {
  fun example() {
    let (x, y) = (0, 1, 2); // ERROR!
    let (x, y, z, q) = (0, 1, 2); // ERROR!
  }
}
```

## 使用结构体的多个声明
当解构（或匹配）结构体时，`let` 也可以一次引入多个局部变量。在这种形式中，`let` 创建一组局部变量，这些变量被初始化为结构体字段的值。语法如下：
```rust
script {
  fun example() {
    struct T { f1: u64, f2: u64 }
  }
}
```

```rust
script {
  fun example() {
    let T { f1: local1, f2: local2 } = T { f1: 1, f2: 2 };
    // local1: u64
    // local2: u64
  }
}
```

这里是一个更复杂的例子：

```rust
module 0x42::example {
  struct X { f: u64 }
  struct Y { x1: X, x2: X }
 
  fun new_x(): X {
    X { f: 1 }
  }
 
  fun example() {
    let Y { x1: X { f }, x2 } = Y { x1: new_x(), x2: new_x() };
    assert!(f + x2.f == 2, 42);
 
    let Y { x1: X { f: f1 }, x2: X { f: f2 } } = Y { x1: new_x(), x2: new_x() };
    assert!(f1 + f2 == 2, 42);
  }
}
```

结构体的字段可以兼作双重用途，既标识要绑定的字段，又标识变量的名称。这有时被称为一词多义。

```rust
script {
  fun example() {
    let X { f } = e;
  }
}
```

相当于： 

```rust
script {
  fun example() {
    let X { f: f } = e;
  }
}
```

如元组所示，在单个 `let` 中，不能用相同的名称声明多个局部变量。

```rust
script {
  fun example() {
    let Y { x1: x, x2: x } = e; // ERROR!
  }
}
```

### 解构引用

在上述关于结构体的例子中，在`let`绑定中的绑定值被移动了，销毁了结构体值并绑定了它的字段。

```rust
script {
  fun example() {
    struct T { f1: u64, f2: u64 }
  }
}
```

```rust
script {
  fun example() {
    let T { f1: local1, f2: local2 } = T { f1: 1, f2: 2 };
    // local1: u64
    // local2: u64
  }
}
```

在这种情况下，结构体值`T { f1: 1, f2: 2 }`在`let`之后不再存在。

如果你想不移动并销毁结构体值，你可以借用它的每个字段。例如：

```rust
script {
  fun example() {
    let t = T { f1: 1, f2: 2 };
    let T { f1: local1, f2: local2 } = &t;
    // local1: &u64
    // local2: &u64
  }
}
```

以及可变引用的类似用法：

```rust
script {
  fun example() {
    let t = T { f1: 1, f2: 2 };
    let T { f1: local1, f2: local2 } = &mut t;
    // local1: &mut u64
    // local2: &mut u64
  }
}
```

这种行为也可以用于嵌套结构体。

```rust
module 0x42::example {
  struct X { f: u64 }
  struct Y { x1: X, x2: X }
 
  fun new_x(): X {
    X { f: 1 }
  }
 
  fun example() {
    let y = Y { x1: new_x(), x2: new_x() };
 
    let Y { x1: X { f }, x2 } = &y;
    assert!(*f + x2.f == 2, 42);
 
    let Y { x1: X { f: f1 }, x2: X { f: f2 } } = &mut y;
    *f1 = *f1 + 1;
    *f2 = *f2 + 1;
    assert!(*f1 + *f2 == 4, 42);
  }
}
```

### 忽略值

在`let`绑定中，经常有助于忽略一些值。以`_`开头的局部变量将被忽略，不会引入一个新的变量。

```rust
module 0x42::example {
  fun three(): (u64, u64, u64) {
    (0, 1, 2)
  }
 
  fun example() {
    let (x1, _, z1) = three();
    let (x2, _y, z2) = three();
    assert!(x1 + z1 == x2 + z2, 42);
  }
}
```

有时这是必要的，因为编译器会对未使用的局部变量报错。

```rust
module 0x42::example {
  fun example() {
    let (x1, y, z1) = three(); // ERROR!
    //       ^ unused local 'y'
  }
}
```

### 通用`let`语法

`let`中的所有不同结构可以组合在一起！有了这个，我们得到了`let`语句的通用语法：

> *let-binding* → **let** *pattern-or-list* *type-annotation*opt* *initializer*opt*

> *pattern-or-list* → *pattern* | **(** *pattern-list* **)**

> *pattern-list* → *pattern* **,***opt* | *pattern* **,** *pattern-list*

> *type-annotation* → **:** *type*

> *initializer* → **=** *expression*

引入绑定的一般项称为*pattern*（模式）。模式用于解构数据（可能是递归的）并引入绑定。模式语法如下：

> *pattern* → *local-variable* | *struct-type* **{** *field-binding-list* **}**

> *field-binding-list* → *field-binding* **,***opt* | *field-binding* **,** *field-binding-list*

> *field-binding* → *field* | *field* **:** *pattern*

一些应用这个语法的具体例子：

```rust
script {
  fun example() {
    let (x, y): (u64, u64) = (0, 1);
    //       ^                           local-variable
    //       ^                           pattern
    //          ^                        local-variable
    //          ^                        pattern
    //          ^                        pattern-list
    //       ^^^^                        pattern-list
    //      ^^^^^^                       pattern-or-list
    //            ^^^^^^^^^^^^           type-annotation
    //                         ^^^^^^^^  initializer
    //  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ let-binding
 
    let Foo { f, g: x } = Foo { f: 0, g: 1 };
    //      ^^^                                    struct-type
    //            ^                                field
    //            ^                                field-binding
    //               ^                             field
    //                  ^                          local-variable
    //                  ^                          pattern
    //               ^^^^                          field-binding
    //            ^^^^^^^                          field-binding-list
    //      ^^^^^^^^^^^^^^^                        pattern
    //      ^^^^^^^^^^^^^^^                        pattern-or-list
    //                      ^^^^^^^^^^^^^^^^^^^^   initializer
    //  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ let-binding
  }
}
```

# 更改

### 赋值

通过`let`引入（或者作为函数参数）局部变量后，可以通过赋值来修改它：

```rust
script {
  fun example(e: u8) {
    let x = 0;
    x = e
  }
}
```

与`let`绑定不同，赋值是表达式。在一些语言中，赋值返回被赋的值，但在Move中，任何赋值的类型总是`()`。

```rust
script {
  fun example(e: u8) {
    let x = 0;
    (x = e) == ()
  }
}
```

实际上，赋值作为表达式意味着它们可以在不添加新的表达式块（`{`…`}`）的情况下使用。

```rust
script {
  fun example(e: u8) {
    let x = 0;
    if (cond) x = 1 else x = 2;
  }
}
```

赋值使用与`let`绑定相同的模式语法方案：

```rust
module 0x42::example {
    struct X { f: u64 }
 
    fun new_x(): X {
        X { f: 1 }
    }
 
    // This example will complain about unused variables and assignments.
    fun example() {
       let (x, _, z) = (0, 1, 3);
       let (x, y, f, g);
 
       (X { f }, X { f: x }) = (new_x(), new_x());
       assert!(f + x == 2, 42);
 
       (x, y, z, f, _, g) = (0, 0, 0, 0, 0, 0);
    }
}
```

注意，局部变量只能有一种类型，所以在赋值之间局部变量的类型不能改变。

```rust
script {
  fun example() {
    let x;
    x = 0;
    x = false; // ERROR!
  }
}
```

### 通过引用变异

除了直接通过赋值修改局部变量外，也可以通过可变引用`&mut`来修改局部变量。

```rust
script {
  fun example() {
    let x = 0;
    let r = &mut x;
    *r = 1;
    assert!(x == 1, 42);
  }
}
```

这在以下情况下特别有用：

1. 你想要根据不同的条件修改不同的变量。

```rust
script {
  fun example() {
    let x = 0;
    let y = 1;
    let r = if (cond) {
      &mut x
    } else {
      &mut y
    };
    *r = *r + 1;
  }
}
```

2. 你希望另一个函数修改你的局部值。

```rust
script {
  fun example() {
    let x = 0;
    modify_ref(&mut x);
  }
}
```

这种修改方式就是如何修改结构体和向量的方式！

```rust
script {
  use 0x1::vector;
 
  fun example() {
    let v = vector::empty();
    vector::push_back(&mut v, 100);
    assert!(*vector::borrow(&v, 0) == 100, 42);
  }
}
```

有关更多详细信息，请参见[Move引用](https://aptos.dev/en/build/smart-contracts/book/references)。

# 作用域

使用`let`声明的任何局部变量都可以在该作用域内用于任何后续表达式。作用域是通过表达式块`{`…`}`声明的。

局部变量不能在声明的作用域之外使用。

```rust
script {
  fun example() {
    let x = 0;
    {
      let y = 1;
    };
    x + y // ERROR!
    //  ^ unbound local 'y'
  }
}
```

但是，外部作用域的局部变量*可以*在嵌套作用域中使用。

```rust
script {
  fun example() {
    {
      let x = 0;
      {
        let y = x + 1; // valid
      }
    }
  }
}
```

局部变量可以在它们可访问的任何作用域中被修改。这种修改与局部变量一起保留，无论执行修改的作用域如何。

```rust
script {
  fun example() {
    let x = 0;
    x = x + 1;
    assert!(x == 1, 42);
    {
      x = x + 1;
      assert!(x == 2, 42);
    };
    assert!(x == 2, 42);
  }
}
```

### 表达式块

表达式块是由分号(`;`)分隔的一系列语句。表达式块的结果值是块中最后一个表达式的值。

```rust
script {
  fun example() {
    { let x = 1; let y = 1; x + y }
  }
}
```

在这个例子中，块的结果就是`x + y`。

一个语句可以是一个`let`声明或一个表达式。记住赋值(`x = e`)是类型为`()`的表达式。

```rust
script {
  fun example() {
    { let x; let y = 1; x = 1; x + y }
  }
}
```

函数调用是另一种常见的类型为`()`的表达式。修改数据的函数调用通常用作语句。

```rust
script {
  fun example() {
    { let v = vector::empty(); vector::push_back(&mut v, 1); v }
  }
}
```

这不仅仅局限于`()`类型——任何表达式都可以在序列中作为语句使用！

```rust
script {
  fun example() {
    {
      let x = 0;
      x + 1; // value is discarded
      x + 2; // value is discarded
      b"hello"; // value is discarded
    }
  }
```

但是！如果表达式包含一个资源（一个没有`drop`[能力的值](https://aptos.dev/en/build/smart-contracts/book/abilities)），你会得到一个错误。这是因为Move的类型系统保证任何被丢弃的值都有`drop`[能力](https://aptos.dev/en/build/smart-contracts/book/abilities)。（所有权必须被转移，或者值必须在其声明的模块内被显式销毁。）

```rust
script {
  fun example() {
    {
      let x = 0;
      Coin { value: x }; // ERROR!
      //  ^^^^^^^^^^^^^^^^^ unused value without the `drop` ability
      x
    }
  }
}
```

如果块中没有最终表达式——也就是说，如果有尾随分号`;`，就有一个隐式的[unit `()`值](https://en.wikipedia.org/wiki/Unit_type)。同样，如果表达式块为空，就有一个隐式的单位`()`值。

```rust
script {
  fun example() {
    // Both are equivalent
    { x = x + 1; 1 / x; };
    { x = x + 1; 1 / x; () };
  }
}
```

```rust
script {
  fun example() {
    // Both are equivalent
    {}
    { () }
  }
}
```

表达式块本身是一个表达式，可以在任何需要表达式的地方使用。（注意：函数体也是一个表达式块，但函数体不能被另一个表达式替换。）

```rust
script {
  fun example() {
    let my_vector: vector<vector<u8>> = {
      let v = vector::empty();
      vector::push_back(&mut v, b"hello");
      vector::push_back(&mut v, b"goodbye");
      v
    };
  }
}
```

（此示例中不需要类型注释，仅添加以提高清晰度。）

### 遮蔽

如果`let`引入了一个已经在作用域内的局部变量名称，那么之前的变量在这个角色剩余的部分将无法访问。这称为*遮蔽*。

```rust
script {
  fun example() {
    let x = 0;
    assert!(x == 0, 42);
 
    let x = 1; // x is shadowed
    assert!(x == 1, 42);
  }
}
```

当局部变量被遮蔽时，它不需要保持与之前相同的类型。

```rust
script {
  fun example() {
    let x = 0;
    assert!(x == 0, 42);
 
    let x = b"hello"; // x is shadowed
    assert!(x == b"hello", 42);
  }
}
```

局部变量被遮蔽后，存储在局部变量中的值仍然存在，但将不再可访问。这对于没有[`drop`能力](https://aptos.dev/en/build/smart-contracts/book/abilities)的值类型很重要，因为值的所有权必须在函数结束时转移。

```rust
module 0x42::example {
  struct Coin has store { value: u64 }
 
  fun unused_resource(): Coin {
    let x = Coin { value: 0 }; // ERROR!
    //  ^ This local still contains a value without the `drop` ability
    x.value = 1;
    let x = Coin { value: 10 };
    x
    // ^ Invalid return
  }
}
```

当局部变量在作用域内被遮蔽时，遮蔽只对该作用域有效。一旦该作用域结束，遮蔽就消失了。

```rust
script {
  fun example() {
    let x = 0;
    {
      let x = 1;
      assert!(x == 1, 42);
    };
    assert!(x == 0, 42);
  }
}
 
```

记住，当它们被遮蔽时，局部变量可以改变类型。

```rust
script {
  fun example() {
    let x = 0;
    {
      let x = b"hello";
      assert!(x = b"hello", 42);
    };
    assert!(x == 0, 42);
  }
}
```

## 移动和复制

Move中的所有局部变量都可以通过两种方式使用，要么通过`move`要么通过`copy`。如果没有指定其中一个，Move编译器能够推断应该使用`copy`还是`move`。这意味着在上面的所有示例中，编译器会插入`move`或`copy`。没有使用`move`或`copy`，局部变量不能被使用。

`copy`可能对于来自其他编程语言的用户来说最为熟悉，因为它在变量内部创建了值的新副本以用于该表达式。使用`copy`，局部变量可以使用多次。

```rust
script {
  fun example() {
    let x = 0;
    let y = copy x + 1;
    let z = copy x + 2;
  }
}
```

任何具有`copy`[能力](https://aptos.dev/en/build/smart-contracts/book/abilities)的值都可以以这种方式复制。

`move`从局部变量中取出值，*不*复制数据。`move`发生后，局部变量将不可用。

```rust
script {
  fun example() {
    let x = 1;
    let y = move x + 1;
    //      ------ Local was moved here
    let z = move x + 2; // Error!
    //      ^^^^^^ Invalid usage of local 'x'
    y + z;
  }
}
```

### 安全性

Move的类型系统将防止在移动后使用值。这与在[`let`声明](https://aptos.dev/en/build/smart-contracts/book/variables#let-bindings)中描述的安全性检查相同，它防止在分配值之前使用局部变量。

### 推断

如上所述，如果没有指明，Move编译器会推断`copy`或`move`。算法相当简单：

- 任何具有`copy`[能力](https://aptos.dev/en/build/smart-contracts/book/abilities)的值都使用`copy`。
- 任何引用（可变和不可变）都使用`copy`。
  - 除非在特殊情况下，为了避免可预测的借用检查器错误，它被指定为`move`。
- 任何其他值都使用`move`。
- 如果编译器能够证明具有复制能力的源值在赋值后没有被使用，那么为了性能，可能会使用`move`代替复制，但这对程序员来说是不可见的（除了可能减少的时间或燃气成本）。

例如：

```rust
module 0x42::example {
  struct Foo {
    f: u64
  }
 
  struct Coin has copy {
    value: u64
  }
 
  fun example() {
    let s = b"hello";
    let foo = Foo { f: 0 };
    let coin = Coin { value: 0 };
 
    let s2 = s; // copy
    let foo2 = foo; // move
    let coin2 = coin; // copy
 
    let x = 0;
    let b = false;
    let addr = @0x42;
    let x_ref = &x;
    let coin_ref = &mut coin2;
 
    let x2 = x; // copy
    let b2 = b; // copy
    let addr2 = @0x42; // copy
    let x_ref2 = x_ref; // copy
    let coin_ref2 = coin_ref; // copy
  }
}
```
