---
title: 局部变量和作用域
---
# 局部变量和作用域

Move中的局部变量在词法上（静态上）作用域化。使用关键字`let`引入新变量，该变量将跟踪任何具有相同名称的先前本地。本地是可变的，可以直接或通过可变引用进行更新。

## 声明局部变量
### `let`绑定[](https://aptos.guide/en/build/smart-contracts/book/variables#let-bindings)

移动程序使用`let`将变量名绑定到值：

```
script {  
	fun example() {    
		let x = 1;    
		let y = x + x;  
	}
}
```

`let`也可以在不绑定值到本地的情况下使用。

```
script {  
	fun example() {    
		let x;  
	}
}
```

然后可以稍后为本地分配一个值。

```
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

当无法提供默认值时，当试图从循环中提取值时，这可能会非常有帮助。

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

### 使用前必须分配变量[](https://aptos.guide/en/build/smart-contracts/book/variables#variables-must-be-assigned-before-use)

Move的类型系统阻止在分配本地变量之前使用。

```rust
script {  
	fun example() {    
		let x;    
		x + x; // ERROR!  
	}
}
```

```
script {  
	fun example() {    
		let x;    
		if (cond) x = 0;    
		x + x; // ERROR!  
	}
}
```

```
script {  
	fun example() {    
		let x;    
		while (cond) x = 0;    
		x + x; // ERROR!  
	}
}
```

### 有效的变量名

变量名称可以包含下划线`_`、字母`a`到`z`、字母`A`到`Z`和数字`0`到9。变量名称必须以下划线`_`或字母`a`到`z`开头。它们_不能_以大写字母开头。

```rust
script {  
	fun example() {    // all valid    
		let x = e;    
		let _x = e;    
		let _A = e;    
		let x0 = e;    
		let xA = e;    
		let foobar_123 = e;     // all invalid    
		let X = e; // ERROR!    
		let Foo = e; // ERROR!  
	}
}
```

### 类型注释[](https://aptos.guide/en/build/smart-contracts/book/variables#type-annotations)

局部变量的类型几乎总是可以通过Move的类型系统推断出来。然而，Move允许显式类型注释，这些注释对可读性、清晰度或可调试性很有用。添加类型注释的语法是：

```
script {  
	fun example() {    
	let x: T = e; // "Variable x of type T is initialized to expression e"  }}
```

显式类型注释的一些示例：

```rust
module 0x42::example {   
	struct S { 
		f: u64, 
		g: u64 
	}   
	fun annotated() {    
		let u: u8 = 0;    
		let b: vector<u8> = b"hello";    
		let a: address = @0x0;    
		let (x, y): (&u64, &mut u64) = (&0, &mut 1);    
		let S { f, g: f2 }: S = S { f: 0, g: 1 };  }}
```

请注意，类型注释必须始终在模式的右侧：

```
script {  
	fun example() {    
		let (x: &u64, y: &mut u64) = (&0, &mut 1); // ERROR! should be let (x, y): ... =  
	}
}
```

### 当需要注释时[](https://aptos.guide/en/build/smart-contracts/book/variables#when-annotations-are-necessary)

在某些情况下，如果类型系统无法推断类型，则需要本地类型注释。当无法推断泛型类型的类型参数时，通常会发生这种情况。例如：

```
script {  
	fun example() {    
		let _v1 = vector::empty(); // ERROR!    
		//        ^^^^^^^^^^^^^^^ Could not infer this type. Try adding an annotation    
		let v2: vector<u64> = vector::empty(); // no error  
	}
}
```

在极少数情况下，类型系统可能无法推断出发散代码的类型（以下所有代码都无法到达）。`return`和[`abort`](https://aptos.guide/en/build/smart-contracts/book/abort-and-assert)都是表达式，可以具有任何类型。如果[`loop`](https://aptos.guide/en/build/smart-contracts/book/loops)有`break`，则具有类型`()`，但如果没有中断`loop`，则可以具有任何类型。如果无法推断这些类型，则需要类型注释。例如，这个代码：

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

在此代码中添加类型注释将暴露有关死代码或未使用的局部变量的其他错误，但该示例仍然有助于理解此问题。

### 带有元组的多个声明[](https://aptos.guide/en/build/smart-contracts/book/variables#multiple-declarations-with-tuples)

`let`使用元组可以一次引入多个本地。括号内声明的局部值从元组初始化为相应值。

```
script {  
	fun example() {    
		let () = ();    
		let (x0, x1) = (0, 1);    
		let (y0, y1, y2) = (0, 1, 2);    
		let (z0, z1, z2, z3) = (0, 1, 2, 3);  
	}
}
```

表达式的类型必须与元组模式的元数完全匹配。

```
script {  
	fun example() {    
		let (x, y) = (0, 1, 2); // ERROR!    
		let (x, y, z, q) = (0, 1, 2); // ERROR!  
	}
}
```

您不能在单个`let`声明多个具有相同名称的本地。

```
script {  
	fun example() {    
		let (x, x) = 0; // ERROR!  
	}
}
```

### 带有结构的多个声明[](https://aptos.guide/en/build/smart-contracts/book/variables#multiple-declarations-with-structs)

`let`在解构（或与结构匹配）时，也可以一次引入多个本地。在此形式中，`let`创建一组局部变量，这些变量从结构初始化为字段的值。语法如下所示：

```
script {  
	fun example() {    
		struct T { 
			f1: u64, f2: u64 
		}  
	}
}
```

```
script {  
	fun example() {    
		let T { f1: local1, f2: local2 } = T { f1: 1, f2: 2 };    
		// local1: u64    
		// local2: u64  
	}
}
```

这里有一个更复杂的例子：

```
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

结构字段可以履行双重职责，识别要绑定的字段_和_变量的名称。这有时被称为双关语。

```
script {  
	fun example() {    
		let X { f } = e;  
	}
}
```

相当于：

```
script {  
	fun example() {    
		let X { f: f } = e;  
	}
}
```

如元组所示，您不能在单个`let`中声明多个具有相同名称的本地。

```
script {  
	fun example() {    
		let Y { x1: x, x2: x } = e; // ERROR!  
	}
}
```

### 对照参考资料进行破坏[](https://aptos.guide/en/build/smart-contracts/book/variables#destructuring-against-references)

在上述结构示例中，let中的绑定值被移动，破坏结构值并绑定其字段。

```
script {  
	fun example() {    
		struct T { f1: u64, f2: u64 }  
	}
}
```

```
script {  
	fun example() {    
		let T { f1: local1, f2: local2 } = T { f1: 1, f2: 2 };    
		// local1: u64    
		// local2: u64  
	}
}
```

在这种情况下，结构值`T { f1: 1, f2: 2 }`在`let`之后不再存在。

如果您不希望移动和破坏结构值，您可以借用其每个字段。例如：

```
script {  
	fun example() {    
	let t = T { f1: 1, f2: 2 };    
	let T { f1: local1, f2: local2 } = &t;    
	// local1: &u64    
	// local2: &u64  
	}
}
```

同样，与可变引用：

```
script {  
	fun example() {    
		let t = T { f1: 1, f2: 2 };    
		let T { f1: local1, f2: local2 } = &mut t;    
		// local1: &mut u64    
		// local2: &mut u64  
	}
}
```

此行为也可以与嵌套结构一起工作。

```
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

### 忽视价值观[](https://aptos.guide/en/build/smart-contracts/book/variables#ignoring-values)

在`let`绑定中，忽略一些值通常是有帮助的。以`_`开头的局部变量将被忽略，并且不会引入新变量

```
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

这有时是必要的，因为编译器会在未使用的局部变量上出错

```
module 0x42::example {  
	fun example() {    
	let (x1, y, z1) = three(); // ERROR!    
	//       ^ unused local 'y'  
	}
}
```

### 一般`let`语法[](https://aptos.guide/en/build/smart-contracts/book/variables#general-let-grammar)

`let`中的所有不同结构都可以组合！有了这一点，我们得出了`let`语句的一般语法：

> _let-binding_ → **let** _pattern-or-list_ _type-annotationopt_ _initializeropt_

> _模式或列表_→_模式_|**（**_模式列表_**）**

> _模式列表_ → _模式_**，**_选择_ | _模式_**，**_模式列表_

> _类型注释_ → **：**_类型_

> _初始化器_ → **=** _表达式_

引入绑定的项目的通用术语是一种_模式_。该模式既用于解构数据（可能是递归的），也用于引入绑定。模式语法如下：

> _pattern_ → _local-variable_ | _struct-type_ **{** _field-binding-list_ **}**

> _field-binding-list_ → _field-binding_ **,**_opt_ | _field-binding_ **,** _field-binding-list_

> _字段绑定_ → _字段_ | _字段_**：**_模式_

应用这种语法的几个具体例子：

```
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

## 突变[](https://aptos.guide/en/build/smart-contracts/book/variables#mutations)

### 作业[](https://aptos.guide/en/build/smart-contracts/book/variables#assignments)

引入局部后（通过`let`或作为函数参数），可以通过赋值来修改局部：

```
script {  
	fun example(e: u8) {    
		let x = 0;    
		x = e  
	}
}
```

与`let`绑定不同，赋值是表达式。在某些语言中，赋值返回分配的值，但在Move中，任何赋值的类型总是`()`

```
 script {  
	 fun example(e: u8) {    
		 let x = 0;   
		(x = e) == ()  
	}
}
```

实际上，作为表达式的赋值意味着它们可以在不添加带大括号（`{``}`）的新表达式块的情况下使用。

```
script {  
	fun example(e: u8) {    
		let x = 0;    
		if (cond) x = 1 else x = 2;  
	}
}
```

赋值使用与`let`绑定相同的模式语法方案：

```
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

请注意，局部变量只能有一个类型，因此局部变量的类型不能在赋值之间更改。

```
script {  
	fun example() {    
		let x;    
		x = 0;    
		x = false; // ERROR!  
	}
}
```

### 通过引用进行突变[](https://aptos.guide/en/build/smart-contracts/book/variables#mutating-through-a-reference)

除了直接通过赋值修改本地外，还可以通过可变引用`&mut`修改本地。

```
script {  
	fun example() {    
		let x = 0;    
		let r = &mut x;    
		*r = 1;    
		assert!(x == 1, 42);  
	}
}
```

在以下任一的情况下，这特别有用：

（1）您想根据某些条件修改不同的变量。

```
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

（2）您希望另一个函数来修改您的本地值。

```
script {  
	fun example() {    
		let x = 0;    
		modify_ref(&mut x);  
	}
}
```

这种修改就是你修改结构和向量的方式！

```
script {  
	use 0x1::vector;   
	fun example() {    
		let v = vector::empty();    
		vector::push_back(&mut v, 100);    
		assert!(*vector::borrow(&v, 0) == 100, 42);  
	}
}
```

有关更多详细信息，请参阅[移动引用](https://aptos.guide/en/build/smart-contracts/book/references)。

## 范围[](https://aptos.guide/en/build/smart-contracts/book/variables#scopes)

任何用`let`声明的本地都可用于_该范围内_的任何后续表达式。范围用表达式块声明，`{``}`。

本地不能在声明的范围之外使用。

```
script {  
	fun example() {    
		let x = 0;    
		{      
			let y = 1;    
		};    
		x + y // ERROR!    
		//  ^ unbound local 'y'  }}
```

但是，来自外部范围的本地人_可以在_嵌套范围内使用。

```
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

本地人可以在可访问的任何范围内进行突变。无论进行突变的范围如何，该突变都会与局部一起存活。

```
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

### 表达式块[](https://aptos.guide/en/build/smart-contracts/book/variables#expression-blocks)

表达式块是由分号（`;`）分隔的一系列语句。表达式块的结果值是块中最后一个表达式的值。

```
script {  
	fun example() {    
		{ 
			let x = 1; 
			let y = 1; 
			x + y 
		} 
	}
}
```

在本例中，块的结果是`x + y`。

语句可以是`let`声明，也可以是表达式。请记住，赋值（`x = e`）是类型`()`的表达式。

```
script {  
	fun example() {    
		{ 
			let x; 
			let y = 1; 
			x = 1; 
			x + y 
		}  
	}
}
```

函数调用是类型`()`的另一个常见表达式。修改数据的函数调用通常用作语句。

```
script {  
	fun example() {    
		{ 
			let v = vector::empty(); 
			vector::push_back(&mut v, 1); 
			v
		}  
	}
}
```

这不仅限于`()`类型——任何表达式都可以用作序列中的语句！

```
script {
  fun example() {
    {
      let x = 0;
      x + 1; // value is discarded
      x + 2; // value is discarded
      b"hello"; // value is discarded
    }
  }
}
```

但是！如果表达式包含资源（没有`drop`[能力的](https://aptos.guide/en/build/smart-contracts/book/abilities)值），您将收到错误。这是因为Move的类型系统保证任何被丢弃的值都具有`drop`[能力](https://aptos.guide/en/build/smart-contracts/book/abilities)。（所有权必须转让，或者必须在其声明模块内明确销毁该值。）

```
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

如果最终表达式不存在于块中——也就是说，如果有尾随分号`;`，则有一个隐式[单位`()`值](https://en.wikipedia.org/wiki/Unit_type)。同样，如果表达式块为空，则有一个隐式单位`()`值。

```
script {
  fun example() {
    // Both are equivalent
    { x = x + 1; 1 / x; };
    { x = x + 1; 1 / x; () };
  }
}
```

```
script {
  fun example() {
    // Both are equivalent
    {}
    { () }
  }
}
```

表达式块本身就是表达式，可以在使用表达式的任何地方使用。（注：函数的主体也是表达式块，但函数主体不能被另一个表达式替换。）

```
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

（本例中不需要类型注释，只是为了清晰起见添加。）

### 阴影[](https://aptos.guide/en/build/smart-contracts/book/variables#shadowing)

如果`let`引入一个名称已经在作用域中的局部变量，则该先前的变量在此作用域的其余部分无法再访问。这被称为_阴影_。

```
script {
  fun example() {
    let x = 0;
    assert!(x == 0, 42);
 
    let x = 1; // x is shadowed
    assert!(x == 1, 42);
  }
}
```

当本地被阴影时，它不需要保留与以前相同的类型。

```
script {
  fun example() {
    let x = 0;
    assert!(x == 0, 42);
 
    let x = b"hello"; // x is shadowed
    assert!(x == b"hello", 42);
  }
}
```

本地被阴影后，存储在本地中的值仍然存在，但将无法再访问。重要的是要记住没有[`drop`能力的](https://aptos.guide/en/build/smart-contracts/book/abilities)类型值，因为值的所有权必须在功能结束前转移。

```
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

当本地在范围内被阴影时，阴影只保留在该范围内。一旦范围结束，阴影就会消失。

```
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

请记住，当地人在被阴影时可以改变类型。

```
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

## 移动和复制[](https://aptos.guide/en/build/smart-contracts/book/variables#move-and-copy)

移动中的所有局部变量都可以通过`move`或`copy`两种方式使用。如果未指定其中一个，移动编译器能够推断是否应该使用`copy`或`move`。这意味着在上述所有示例中，编译器将插入`move`或`copy`。如果不使用`move`或`copy`，就无法使用局部变量。

`copy`可能会觉得最熟悉的来自其他编程语言，因为它在变量内创建了一个值的新副本，用于该表达式。使用`copy`，局部变量可以多次使用。

```rust
script {
  fun example() {
    let x = 0;
    let y = copy x + 1;
    let z = copy x + 2;
  }
}
```

任何具有`copy`[能力的](https://aptos.guide/en/build/smart-contracts/book/abilities)值都可以以这种方式复制。

`move`_在不_复制数据的情况下从局部变量中取出值。`move`发生后，局部变量不可用。

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

### 安全[](https://aptos.guide/en/build/smart-contracts/book/variables#safety)

移动的类型系统将阻止一个值在移动后被使用。这是与[`let`声明](https://aptos.guide/en/build/smart-contracts/book/variables#let-bindings)中描述的相同的安全检查，该检查防止在分配值之前使用局部变量。

### 推断[](https://aptos.guide/en/build/smart-contracts/book/variables#inference)

如上所述，如果没有指示，移动编译器将推断出`copy`或`move`。这样做的算法非常简单：

- 任何具有`copy`[能力的](https://aptos.guide/en/build/smart-contracts/book/abilities)值都会被赋予`copy`。
- 任何引用（可变`&mut`和不可变`&`）都会得到一份`copy`。
    - 除非在特殊情况下，它因可预测的借款检查错误而`move`。
- 任何其他值都会被`move`。
- 如果编译器可以证明在分配后没有使用具有复制能力的源值，那么可以使用移动而不是副本来表示性能，但这对程序员来说是不可见的（除非可能减少时间或气体成本）。

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