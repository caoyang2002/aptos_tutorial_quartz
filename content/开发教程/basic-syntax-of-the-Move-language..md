---
title: Move 语言基础语法
draft: 
aliases:
  - Move 基础语法
---

> 注： 在测试的时候，请删除注释中的中文
>
> 参考：
>
> - [Move Dao](https://github.com/move-dao)
>     - [Move Book 中文版](https://move-dao.github.io/move-book-zh/friends.html)
>     - [Move 案例教程](https://move-dao.github.io/move_tutorial/)
> - [Aptos 开发者教程](https://aptos.dev/move/move-on-aptos)
> - [Aptos 学习网](https://learn.aptoslabs.com/tutorials)



module 的格式

```rust
module <address>::<identifier> {
    (<use> | <friend> | <type> | <function> | <constant>)*
}
```

例如

```rust
module 0x42::module_name{
  use aptos_std::debug::print;
  friend 0x42::other_module;
  public entry fun hello() {
        let hello_str = string::utf8(b"hello_world");
        print(&hello_str);
    }
}
```



# 一、基本类型



## 整型（u8、u64、u128）

先定义一个变量 a 为 u64 类型，然后设置值为 10

```rust
let a:u8; 
a = 10; 
```

定义变量 a ，同时指定类型为 u64，并赋值为 10

```rust
let a:u64 = 10;
```

定义变量 a 为10 （Move 的会进行类型推断）

```rust
let a = 10;
```

定义变量 a 为 u128 类型的10

```rust
let a = 10u128;
```

在 if 表达式中使用整数作为常量值

```rust
 if (a < 10) {};
```

在 if 表达式中使用 u128 类型的整数作为常量值

```rust
 if (a < 10u128) {};
```



完整代码

> ```rust
> script {
>     fun main() {
>         // 定义一个空变量，稍后赋值
>         // define empty variable, set value later
>         let a: u8;
>         a = 10;
> 
>         // 定义变量并指定类型
>         // define variable, set type
>         let a: u64 = 10;
> 
>         // 最后进行简单赋值
>         // finally simple assignment
>         let a = 10;
> 
>         // 带有指定值类型的简单赋值
>         // simple assignment with defined value type
>         let a = 10u128;
> 
>         // 在函数调用或表达式中，您可以使用整数作为常量值
>         // in function calls or expressions you can use ints as constant values
>         if (a < 10) {};
> 
>         // 或者像这样，带有类型
>         // or like this, with type
>         if (a < 10u8) {}; // 通常情况下不需要指定类型 // usually you don't need to specify type
>     }
> }
> ```



## 运算符 as

当需要比较值的大小或函数需要输入不同大小的整型参数时，可以使用 `as` 运算符将一种类型转换为另一种类型

```rust
script {
    fun main() {
        let a: u8 = 10;
        let b: u64 = 100;

				// 我们只能比较相同大小的整数
        // we can only compare same size integers
        if (a == (b as u8)) abort 11;
        if ((a as u64) == b) abort 11;
    }
}
```



## 布尔型（boolean）



## 地址（address）

地址是区块链中交易发送者的标识符，转账和导入模块这些基本操作都离不开地址。

```rust
script {
    fun main() {
        let addr: address; // type identifier //类型标识符

        // in this book I'll use {{sender}} notation;
        // 在本书中，我将使用 {{sender}} 表示法;
        // always replace `{{sender}}` in examples with VM specific address!!!
        // 始终将示例中的“{{sender}}”替换为 VM 特定地址!!
        addr = {{sender}};

        // in Diem's Move VM and Starcoin - 16-byte address in HEX
        // 在 Diem 的 Move VM 和 Starcoin 中 - 十六进制的 16 字节地址
        addr = 0x...;

        // in dfinance's DVM - bech32 encoded address with `wallet1` prefix\
        // 在 dfinance 的 DVM 中 - 带有“wallet1”前缀的 bech32 编码地址
        addr = wallet1....;
    }
}

```

# 二、注释

> 注释中也不可以使用中文

`// 行注释`：可以注释一行

```rust
script {
    // let's add a note to everything!
    fun main() {
        let a = 10;
        // let b = 10 this line is commented and won't be executed
        let b = 5; // here comment is placed after code
        a + b // result is 15, not 10!
    }
}

```



`/* 块注释 */`：可以注释连续多行

```rust
script {
    fun /* you can comment everywhere */ main() {
        /* here
           there
           everywhere */ let a = 10;
        let b = /* even here */ 10; /* and again */
        a + b
    }
    /* you can use it to remove certain expressions or definitions
    fun empty_commented_out() {

    }
    */
}
```

# 三、表达式和作用域

> 在编程语言中，表达式是具有返回值的代码单元。有返回值的函数调用是一个表达式，它有返回值；整型常数也是一个表达式，它返回整数；其它表达式依此类推。
>
> 表达式必须用分号";"隔开

## 空表达式

类似于 Rust，Move 中的空表达式用空括号表示：

```rust
script {
    fun empty() {
        () // this is an empty expression
    }
}
```

## 文字（Literal）表达式

下面的代码，每行包含一个以分号结尾的表达式。最后一行包含三个表达式，由分号隔开。

```rust
script {
    fun main() {
        10;
        10 + 5;
        true;
        true != false;
        0x1;
        1; 2; 3
    }
}
```

> 创建和初始化变量后，就可以使用变量名来*修改*或*访问*它所代表的值了。在上面的示例中，变量 a 在函数末尾被初始化，并被*分配*了一个值 c。
>
> 等号"="是赋值运算符。它将右侧表达式赋值给左侧变量。示例：a = 10 表示将整数10赋值给变量a。

# 四、变量和 let 关键字

关键字 let 用来将表达式的值存储在变量中，以便于将其传递到其它地方。我们曾经在基本类型章节中使用过 let，它用来创建一个新变量，该变量要么为空（未定义），要么为某表达式的值。

> 关键字 let 会在*当前作用域* 内创建新变量，并可以选择*初始化* 此变量。该表达式的语法是：`let : ;`或`let = `。

```rust
script {
    fun main() {
        let a;
        let b = true;
        let c = 10;
        let d = 0x1;
        a = c;
    }
}
```



# 五、整型运算符

Move具有多种用于修改整数值的运算符：

| 运算符 | 操作   | 类型 |                  |
| ------ | ------ | ---- | ---------------- |
| +      | sum    | uint | LHS加上RHS       |
| -      | sub    | uint | 从LHS减去RHS     |
| /      | div    | uint | 用LHS除以RHS     |
| *      | mul    | uint | LHS乘以RHS       |
| %      | mod    | uint | LHS除以RHS的余数 |
| <<     | lshift | uint | LHS左移RHS位     |
| >>     | rshift | uint | LHS右移RHS位     |
| &      | and    | uint | 按位与           |
| ^      | xor    | uint | 按位异或         |
| \      | or     | uint | 按位或           |

> LHS - 左侧表达式
>
> RHS - 右侧表达式
>
>  uint: u8, u64, u128

# 六、下划线 "_" 表示未被使用

Move 中每个变量都必须被使用，否则代码编译不会通过, 因此我们不能初始化一个变量却不去使用它。但是你可以用下划线来告诉编译器，这个变量是故意不被使用的。

例如，下面的脚本在编译时会报错：

```rust
script {
    fun main() {
        let a = 1;
    }
}
```

报错：

```rust
    ┌── /scripts/script.move:3:13 ───
    │
 33 │         let a = 1;
    │             ^ Unused assignment or binding for local 'a'. Consider removing or replacing it with '_'
    │
```

编译器给出明确提示：用下划线来代替变量名。

```rust
script {
    fun main() {
        let _ = 1;
    }
}
```



# 七、屏蔽

Move 允许两次定义同一个的变量，第一个变量将会被屏蔽。但有一个要求：我们仍然需要"使用"被屏蔽的变量。

```rust
script {
    fun main() {
        let a = 1; // 定义 第一次
        let a = 2; // 定义 第二次
        let _ = a; // 使用第二个 a // 但是未使用第一个 a 【编译错误】
    }
}
```

在上面的示例中，我们仅使用了第二个 a 。第一个 a 实际上未使用，因为a在下一行被重新定义了。所以，我们可以通过下面的修改使得这段代码正常运行。

```rust
script {
    fun main() {
        let a = 1; // 定义 第一次
        let a = a + 2; // 定义 第二次，并使用第一个 a
        let _ = a; // 使用第二个 a
    }
}
```

# 八、块表达式

块表达式用花括号"{}"表示。块可以包含其它表达式（和其它代码块）。函数体在某种意义上也是一个代码块。

```rust
script {
    fun block() {
        { };
        { { }; };
        true;
        {
            true;

            { 10; };
        };
        { { { 10; }; }; };
    }
}
```



# 九、作用域

如 [Wikipedia](https://en.wikipedia.org/wiki/Scope_(computer_science)) 中所述，作用域是绑定生效的代码区域。换句话说，变量存在于作用域中。Move 作用域是由花括号扩起来的代码块，它本质上是一个块。

> 定义一个代码块，实际上是定义一个作用域。

```rust
script {
    fun scope_sample() {
        // this is a function scope
        // 这是一个函数的作用域
        {
            // this is a block scope inside function scope
            // 这是一个函数作用域内的块作用域
            {
                // and this is a scope inside scope
                // 这是一个作用域内的作用域
                // inside functions scope... etc
            };
        };

        {
            // this is another block inside function scope
            // 这是函数作用域内的另一个块
        };
    }
}
```

从该示例可以看出，作用域是由代码块（或函数）定义的。它们可以嵌套，并且可以定义多个作用域，数量没有限制。



# 十、变量的生命周期和可见性

我们前面已经介绍过关键字 let 的作用，它可以用来定义变量。有一点需要强调的是，该变量仅存在于变量所处的作用域内。也就是说，它在作用域之外不可访问，并在作用域结束后立即消亡。

```rust
fun let_scope_sample() {
    let a = 1; // 我们在函数作用域内定义了变量 A

    {
        let b = 2; // 变量 B 在块作用域内

        {
            // 变量 A 和 B 在嵌套作用域内都是可访问的
            val c = a + b;

        }; // 在这里 C 被销毁

        // 我们不能写这一行
        // let d = c + b;
        // 因为变量 C 随着它的作用域而消失了

        // 但是我们可以定义另一个 C
        let c = b - 1;

    }; // 变量 C 被销毁，所以 C 也随之消失

    // 这是不可能的
    // let d = b + c;

    // 我们可以定义任何我们想要的变量
    // 没有发生名称保留
    let b = a + 1;
    let c = b + 1;

} // 函数作用域结束 - a、b 和 c 被丢弃，不再可访问
```

> 变量仅存在于其作用域（或代码块）内，当作用域结束时变量随之消亡。



# 十一、块返回值

上面我们了解到代码块是一个表达式，但是我们没有介绍为什么它是一个表达式以及代码块的返回值是什么。

> 代码块可以返回一个值，如果它后面没有分号，则返回值为代码块内最后一个表达式的值。

听起来不好理解，我们来看下面的例子：

```rust
script {
    fun block_ret_sample() {

        // since block is an expression, we can
        // assign it's value to variable with let
        // 由于块是一个表达式，我们可以使用 let 将其值分配给变量
        let a = {

            let c = 10;

            c * 1000  // no semicolon! // 没有分号！
        }; // scope ended, variable a got value 10000  // 作用域结束，变量 a 获得值 10000

        let b = {
            a * 1000  // no semi!  // 没有分号！
        };

        // variable b got value 10000000
        // 变量 b 获得值 10000000

        {
            10; // see semi! // 见分号！
        }; // this block does not return a value  // 这个块不返回值

        let _ = a + b; // both a and b get their values from blocks  // a 和 b 都从块中获取它们的值
    }
}

```

> 代码块中的最后一个表达式（不带分号）是该块的返回值。



# 小结

我们来总结一下本章要点：

1. 每个表达式都必须以分号结尾，除非它是 block 的返回值。
2. 关键字 let 使用值或表达式创建新变量，该变量的生命周期与其作用域相同。
3. 代码块是一个可能具有也可能没有返回值的表达式。

下一章我们将介绍控制流和分支语句。