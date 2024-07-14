https://b23.tv/Epl9OSG

# GC 语言的变量语义
> GC 语言：有垃圾回收器的语言例如 java go kotlin


## 基本类型    
> `a` 和 `b` 相互独立
```java
int a = 123; // a 发生了变化，b不会变化
int b = a;
a += 1;
```

## 对象类型   
> `a` 和 `b` 指向同一个对象

```java
List a = [1,2,3]; // a 发生了变化 b 会变化
List b = a;
```

# Rust 的变量语义
- 和 GC 语言中的变量不再一样
- 所有权机制


# 栈 Stack
- 栈帧（函数的参数、局部变量以及返回地址）
- 管理函数调用的过程
- 栈帧大小是确定的
- 性能极高

# 堆 heap
- 动态分配
- 一种内存资源
- 内存分配器
- 需要归还

# Rust 语言设计目标
- 系统编程语言
- 安全性
- 可靠性
- 性能
- 现代化

# 矛盾的选择

系统编程语言  --> 不能使用 GC  -->  堆内存由程序管理

安全性  -->  堆内存必须自动管理


## 如何设计：无 GC 的自动内存回收方案
### 规则一：确定回收时机
- GC 判断对象不再使用后，择机回收
- rule1:变量离开作用域（变量不再使用）回收  -->  变量不能共享对象
- 问题：如果变量之间共享对象？

### 规则二：每一个变量仅和一个对象绑定
- 为了解决上一步的问题，我们禁止变量之间共享对象


### 规则三：值在任何时候只能与一个变量形成绑定

- 赋值行为，为了遵循规则二，原始值变量 p 不再有效（所有权转移）

```rust
let p:Point = Poitn {x:1,y:2};
let p2:Point = p;
```

![[../../Images/所有权——移动语义.png]]

复制变量 --> 新内存地址上重建 --> 销毁原始的变量

p 在这里依然有效，只是不能被访问而已，编译器是在控制这个内存地址的值不再有效了。

### 动态内存的复杂数据结构如何处理？

![[../../Images/动态内存-数组.png]]

>[!NOTE] 实现
> 到此我们得到一个编程能力受限的无 GC 的自动内存回收方案 —— “所有权”



# 所有权（ownership）
所有权规则可以概括为三个核心规则：
- Rust 中的每一个值都与一个变量明确关联，这个变量是该值的唯一拥有者
- 在任一时刻，每个值都只与一个变量有这种关联。（禁止共享）
- 当这个变量离开作用域，与之关联的值将会被自动回收（释放资源是安全的）


# 引用类型
## 如果没有引用类型

所有权模型规定了变量的所有权唯一性，这在实际编程中回遇到一些挑战，例如下面的函数：

```rust
fn inspect(list:Vec<i32>){
	println!{"The data is :{:?}",list}
}
```

使用函数的场景如下
```rust
let data = vec![1,2,3];
inspact(data)
// 现在我们无法再访问 ‘data’，因为所有权已经被移动到函数内部
```

## 受限制的指针

- 限制一：引用类型和类型一一对应（&i32、&bool）
- 限制二：不可随意修改
- 限制三：必须有效初始化
```rust
let a: &i32;
// a 未初始化，不能被使用，
```

相比之下，正确的做法是在上名的同一行对引用进行初始化

```rust
let value = 42;
let a: &i32 = &value;
```

## 引用类型的内存布局

- 一般是 u64 类型
- slice、Trait object 类型的引用类型是双 Word


## 引入引用类型后

```rust
fn inspact(list:&Vec<i32>){
	println("The data is: {:?}", list);
}
fn main(){
	let data = vec![1,2,3];
	inspact(&data); // 使用引用传递 data 的引用
	// inspact 函数执行后，data 仍然有效，且所有权没有改变
	println!("data can still be accessed: {:?}",data); 
}
```

# 不可变借用和可变借用

- 不可变借用（read lock，可以并发）

```rust
let value: i32 = 10;
let ref_to_value: &i32 = &value; //创建 value 得不可变引用
println!("通过不可变借用获取的值是:{}",ref_to_value);
```

- 可变借用（write lock）
```rust
let mut value:&i32 = 10;
let ref_to_mut_value:&mut i32 = &mut value; // 创建 value 的可变借用
*ref_to_mut_value += 5;
println!("通过可变借用修改后的值是:{}",value);
```

>[!TIP] 提示
>引用类型后原始类型是两个完全独立的类型

# 悬垂引用（Dangling References）
```bash
fn main(){
	let my_ref = dangling_ref();
	// 注意：这段代码无法编译通过，因为 my_ref 是一个悬垂引用
}

fn dangling_ref() -> &string{
	let temp_string = String::from("一个临时字符串")
	&temp_string // 我们尝试返回一个指向 temp_string 的引用
}
```


# 借用规则
- 多个不可变借用（读取权）可以共存，但不可变借用和可变借用（写入权）不能同时存在
- 可变引用在任意时刻只能有一个
- 引用的生命周期必须在所有者离开作用域之前结束，防止创建悬垂引用（lifetime）
- 这些借用规则有 Rust【借用检查器】执行检查，不符合规则的代码将导致编译错误

# 生命周期标注
```rust
fn main(){
	let r;
	{
		let x = 5;
		r = &x;
	}
	println!("r: {}",r)
}
```

## 编译器如何发现错误

通过 `r = &x`  语句，编译器得知 `r` 和 `x` 之间存在引用关系

编译器仅能通过 `&` 借用操作，来确定引用和变量之间的对应关系 

无法编译通过的代码：

```rust
fn longest(x:&str,y: &str) -> &str {
	let x.len() > y.len(){
		x
	}else{
		y
	}
}
```

可以编译通过的代码：
```rust
fn longest<'a>(x:&'a str, y:&'a str) -> &'a str{
	if x.len() > y.len(){
		x
	}else{
		y
	}
}
```

>[!TIP] 提示
>`'a` 是一个生命周期注释，表示 x 和 y 的引用必须至少和返回值的引用一样长

## 如何简单解读 `'a`  的语义

`'a` 指出返回的引用与输入参数 x、y 之间有关系

`'a` 只是这个关联关系的代号

```rust
// 返回结果只与参数有关
fn some_fun<'a>(x:&'a str,y: &str) -> &'a str

// 返回元组，第一个和 x 有关，第二个和 y 有关
fn some_fun2<'a,'b>(x:&'a str,y: &'b str) -> (&'a str, &'b str)
```



```rust
fn main(){
	let string1 = String::from("long string is long");
	let result;
	{
		let string2 = String::from("xyz");
		result = longest(string.as_str,string2.as_str());
	}
	println("The longest is {}",result);
}
```

编译器可以分析出以下几点：
- result 变量是引用类型
- 根据 longest 函数的签名，result 可能与参数x、y 其中之一关联
- string1 和 x 关联、string2 和 y 关联
- result 可能指向 string1 或 string2
- 比较 result 的生命周期与 string1 和 string2 中较短者的生命周期
- 发现当 result 和 string2 相关时，在代码第 8 行，result 指向了失效的变量 string2，出现了悬垂引用的风险
因此通过生命周期标注，编译器能发现并预防悬垂引用的危险情况