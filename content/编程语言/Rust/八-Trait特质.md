# Trait 特质

在 Rust 中，特质（Trait）是一种定义方法签名的机制

特质允许你定义一组方法的签名，但可以不提供具体的实现（也可以提供）。这些方法签名可以包括参数和返回类型，但不可以包括方法的实现代码

任何类型都可以实现特质，只要他们提供了特质中定义的所有方法，这使得你可以为不同类型提供相同的行为



## 特点

1. 内置常量：特质可以内置常量（const），特质中定义的常量在程序的整个生命周期内都是有效的
2. 默认实现：特质可以提供默认的方法实现，如果类型没有为特质中的某个方法提供自定义实现，将会默认实现。
3. 多重实现：类型可以实现多个特质，这允许你将不同的行为组合到一起。
4. 特质边界：在泛型代码中，你可以使用特质作为类型约束，这被称为特质边界，它限制了泛型类型必须实现的特质
5. Trait Alias：Rust 还支持 trait alias，这允许你为复杂的 trait 组合创建简介的别名，以便在代码中更轻松地引用



```rust
trait Greeter{
    fn greet(&self);
    fn hello();
}
struct Person{
    name:String,
}
impl Greeter for Person{
    fn greet(&self) {
       println!("name is {}",self.name)
    }
    fn hello(){
        println!("hello")
    }
}
fn main(){
    let person = Person{name:"cccy".to_string()};
    person.greet();
    // name is cccy
    Person::hello();
    // hello
}
```





```rust
trait Greeter{
    fn greet(&self);
    fn hello(){ // 默认方法的实现
        println!("hello")
    }
}
struct Person{
    name:String,
}
impl Greeter for Person{
    fn greet(&self) {
       println!("name is {}",self.name)
    }

}
fn main(){
    let person = Person{name:"cccy".to_string()};
    person.greet();
    // name is cccy
    Person::hello();
    // hello
}
```



# 二、Trait Object 与 Box

## Trait Object

1. 在运行时动态分配的对象

    “运行时的泛型”

    比泛型要灵活的多

2. 可以在集合中混入不同的类型对象

    更容易处理相似的数据

3. 有一些小小的性能损耗



## dyn 关键字

dyn 是 Rust 中的关键字，用于声明特质对象（Trait object）的类型。特质对象是实现了特定特质（trait）的类型的实例，但其具体类型在编译时是未知的。因此，为了让编译器知道我们正在处理的是特质对象，我们需要在特质名称前面加上 dyn 关键字

dyn 关键字的作用是指示编译器处理特质对象





## Rust 中数据传输的三种形式

不可变引用（Immutable References）：`&dyn Trait`

可变引用（Mutable References）：`&mut dyn Trait`

Move 语义所有权转移：特质需要用 `Box<dyn Trait>` 实现 Move，如果你需要在函数调用之间传递特质的所有权，并且希望薄面在栈上分配大量的内存，可以使用 `Box<dyn Trait>`



## 特质与Box

创建 trait Object 的三种方式

第一种：

```rust
let o = Object{};
let o_obj : &dyn Object = &o;
```

第二种：

```rust
let o_obj:&dyn Object = &Object{};
```

第三种：

```rust
let o_obj:Box<dyn Object> = Box::new(Object{});
```

第一种和第二种都是创建不可变引用

第三种最常见也最灵活，一般来说会使用 Box 和特质来组成集合元素

```rust
use std::os::unix::raw::time_t;

// trait 不可变引用 / 所所有权转移 Move
trait Overview{
    fn overview(&self) -> String{
        String::from("overview")
    }
}
struct Obj{
}

impl Overview for Obj{
    fn overview(&self) -> String {
       String::from("Obj")
    }
}

// 不可变引用
fn call_obj(item:&impl Overview){
    println!("Overview {}",item.overview());
}

// 所有权转移 move
fn call_obj_box(item:Box<dyn Overview>){
    println!("Overview {}",item.overview());
}

// -------------------

trait Sale {
    fn amount(&self) -> f64;
}
struct Common(f64);
impl Sale for Common {
    fn amount(&self) -> f64 {
       self.0
    }
}

struct TenDiscount(f64);
impl Sale for TenDiscount{
    fn amount(&self) -> f64 {
       self.0 - 10.0
    }
}

struct TenPercentDiscount(f64);

impl Sale for TenPercentDiscount {
    fn amount(&self) -> f64 {
       self.0 * 0.9
    }
}

fn calculate(sales: &Vec<Box<dyn Sale>>) -> f64 {
    sales.iter().map(|sale|sale.amount()).sum()
}

fn main(){
    let a = Obj{};
    call_obj(&a);
    // Overview Obj
    println!("{}",a.overview());
    // Obj
    let b_a = Box::new(Obj{});
    call_obj_box(b_a);
    // println!("{}",b_a.overview()); // value borrowed here after move // 所有权转移
    // -------------
    let c = Box::new(Common(100.0));
    let t1 = Box::new(TenDiscount(100.0));
    let t2 = Box::new(TenPercentDiscount(100.0));

    // 可以在下面声明类型， 也可以在上面声明类型 例如： let c: Box<dyn Sale> = .......
    let sales: Vec<Box<dyn Sale>> = vec![c,t1,t2];
    println!("pay {}",calculate(&sales));
    // pay 280
}
```



# Trait Object 与 泛型

## 泛型与 impl 不同的写法

可以是不同类型

- ```rust
    fn call(item1: &impl Trait, item2: &impl Trait);
    ```

可以是相同类型

- ```rust
    fn call_generic<T:Trait>(item1: &T, item2:&T);
    ```



## Multiple Trait Bounds

```rust
fn call(item: &(impl Trait+ AnotherTrait));
fn call_generic<T: Trait+ AnotherTrait>(item1: &T);
```

```rust
trait Overview{
    fn overview(&self) -> String {
        String::from("Course")
    }
}

trait Another {
    fn hell(&self) {
        println!("welcome to hell");
    }
}

// impl 和泛型写法的两种区别
struct Course {
    headline: String,
    author:String,
}

impl Overview for Course {}

struct AnotherCourse{
    headline: String,
    author: String,
}

// impl 的写法
impl Overview for AnotherCourse {}
impl Another for Course{}

// 单个绑定 推荐写法
fn call_overview(item:&impl Overview){
    println!("Overview {}",item.overview());
}

// 写法
fn call_overview_generic<T:Overview>(item:&T){
    println!("Overview {}",item.overview());
}

fn call_overview_T(item1:&impl Overview,item2:&impl Overview){
    println!("Overview {}",item1.overview());
    println!("Overview {}",item2.overview());
}

// 泛型
fn call_overview_TT<T:Overview>(item1:&T,item2:&T){
    println!("Overview {}",item1.overview());
    println!("Overview {}",item2.overview());
}

// ----------
// 多绑定  不推荐这样写， 推荐用泛型
fn call_mul_bind(item:&(impl Overview + Another)){
    println!("Overview {}",item.overview());
    item.hell();
}

// 泛型
fn call_mul_bind_T<T:Overview+Another>(item:&T){
    println!("Overview {}",item.overview());
    item.hell();
}

// where 语句 (多个绑定推荐)
fn call_mul_bind_T_where<T>(item:&T) where T:Overview + Another{
    println!("Overview {}",item.overview());
    item.hell();
}

fn main(){
    let c0 = Course{headline:"headline".to_owned(),author:"author".to_owned(),};
    let c1 = Course{headline:"headline".to_owned(),author:"author".to_owned(),};
    let c2 = AnotherCourse{headline:"headline_2".to_owned(),author:"author_2".to_owned(),};
    call_overview(&c1);
    // Overview Course
    call_overview_generic(&c1);
    // Overview Course

    call_overview(&c1);
    // Overview Course
    call_overview_generic(&c2); // the trait `Overview` is not implemented for `AnotherCourse`
    // Overview Course
    call_overview_T(&c1,&c2);
    // Overview Course
    // Overview Course

    //
    println!("----------------------");
    // call_overview_TT(&c1,&c2); // &c2: the trait `Overview` is not implemented for `AnotherCourse`
    call_overview_TT(&c1,&c0);
    call_overview_T(&c1,&c0);
    // Overview Course
    // Overview Course

    println!("----------------------");
    call_mul_bind(&c1);
    // Overview Course
    // welcome to hell
    call_mul_bind_T(&c1);
    // Overview Course
    // welcome to hell

    call_mul_bind_T_where(&c1);
    // Overview Course
    // welcome to hell
}
```



# 四、重载操作符 (Operator)

## Rust 重载操作符

只需实现响应的特质

为结构体实现一个加号的例子

```rust
use std::any::TypeId;
use std::fmt::Debug;
use std::ops::Add;
use std::process::Output;

// 编译时确定的
#[derive(Debug)]
struct Point<T> {
    x: T,
    y: T,
}

// T 的类型可以执行相加的操作
impl<T> Add for Point<T> where T:Add<Output = T>{
    type Output = Self;
    fn add(self, rhs: Self) -> Self::Output {
        Point{
            x:self.x + rhs.x,
            y:self.y + rhs.y,
        }
    }
}

fn main(){
    let i1 = Point{x:1,y:2};
    let i2 = Point{x:3,y:4};
    let sum = i1 + i2;
    println!("{:?}",sum);
    // Point { x: 4, y: 6 }
    let f1 = Point{x:0.1,y:0.2};
    let f2 = Point{x:0.3,y:0.4};
    let sum = f1 + f2;
    println!("{:?}",sum);
    // Point { x: 0.4, y: 0.6000000000000001 }
}
```



# Trait 与多态和“继承”

## Rust 并不支持面向对象

Rust 并不支持传统的继承概念，但是你可以在特质中通过层级化来完成你的需求

Rust 选择了一种函数时的编程范式，即“组合委托”而非“继承”

编程语言的大势也是组合由于继承



## 多态

多态是面向对象编程中的一个重要概念，指的是同一个方法调用可以根据对象的不同类型表现出不同的行为。

简单来说，多态允许一个接口或方法在不同的上下文中表现出不同的行为。这样的做法的好处是可以提高代码的灵活性和可扩展性，使得代码更易于维护和理解

Rust 中的多态无处不在

```rust
// 多态
trait Driver{
    fn drive(&self);
}
struct Car;
impl Driver for Car {
    fn drive(&self) {
       println!("Car is driving");
    }
}
struct SUV;
impl Driver for SUV{
    fn drive(&self) {
       println!("SUV is driving");
    }
}

//
fn road(vehicle:& dyn Driver){
    vehicle.drive();
}

fn main(){
    road(&Car);
    // Car is driving
    road(&SUV);
    // SUV is driving
}
```



```rust
use std::collections::VecDeque;
// 多态
trait Driver{
    fn drive(&self);
}
struct Car;
impl Driver for Car {
    fn drive(&self) {
       println!("Car is driving");
    }
}
struct SUV;
impl Driver for SUV{
    fn drive(&self) {
       println!("SUV is driving");
    }
}

//
fn road(vehicle:& dyn Driver){
    vehicle.drive();
}


// 继承思想
// 单向特质
trait Queue{
    fn len(&self) -> usize;
    fn push_back(&mut self,n:i32);
    fn pop_front(&mut self) -> Option<i32>;
}

// 双向特质
trait Deque: Queue{
    fn push_front(&mut self,n:i32);
    fn pop_back(&mut self) -> Option<i32>;
}
#[derive(Debug)]
struct List{
    data:VecDeque<i32>,
}

impl List {
    fn new() -> Self{
        let data = VecDeque::<i32>::new();
        Self{data}
    }
}

impl Deque for List {
    fn pop_back(&mut self) -> Option<i32> {
        self.data.pop_back()
    }
    fn push_front(&mut self, n: i32) {
        self.data.push_front(n)
    }
}

impl Queue for List{
    fn len(&self) -> usize {
        self.data.len()
    }
    fn pop_front(&mut self) -> Option<i32> {
        self.data.pop_front()
    }
    fn push_back(&mut self, n: i32) {
        self.data.push_back(n)
    }
}

fn main(){
    road(&Car);
    // Car is driving
    road(&SUV);
    // SUV is driving
    // ----------
    let mut l = List::new();
    l.push_back(1);
    l.push_front(0);
    println!("{:?}",l);
    // List { data: [0, 1] }
    l.push_front(2);
    println!("{:?}",l);
    // List { data: [2, 0, 1] }
    l.push_back(3);
    println!("{:?}",l);
    // List { data: [2, 0, 1, 3] }
    println!("{}",l.pop_back().unwrap());
    // 3
    println!("{:?}",l);
    // List { data: [2, 0, 1] }
}
```





# 六、常见的 Trait

## Debug

```rust
// Clone Copy Debug PartialEq     Add
// 层级
// 统计用户的种族
#[derive(Debug)]
enum Race{
    white,
    Yellow,
    Black,
}
#[derive(Debug)]
struct User{
    id: u32,
    name: String,
    race:Race,
}

fn main(){
    let user = User{
        id: 3,
        name: "cccy".to_string(),
        race: Race::Yellow,
    };
    println!("{:#?}",user);
    // User {
    //     id: 3,
    //     name: "cccy",
    //     race: Yellow,
    // }
}
```



## Clone

```rust
// Clone Copy Debug PartialEq     Add
// 层级
// 统计用户的种族
#[derive(Debug,Clone)]
enum Race{
    white,
    Yellow,
    Black,
}
#[derive(Debug,Clone)]
struct User{
    id: u32,
    name: String,
    race:Race,
}

fn main(){
    let user = User{
        id: 3,
        name: "cccy".to_string(),
        race: Race::Yellow,
    };
    // 需要实现 Debug
    println!("{:#?}",user);
    // User {
    //     id: 3,
    //     name: "cccy",
    //     race: Yellow,
    // }

    // 需要实现 Clone
    let user2 = user.clone();
    println!("{:#?}",user2);
    // User {
    //     id: 3,
    //     name: "cccy",
    //     race: Yellow,
    // }


}
```





## Copy

```rust
// Clone Copy Debug PartialEq     Add
// 层级
// 统计用户的种族
#[derive(Debug,Clone,Copy)]
enum Race{
    white,
    Yellow,
    Black,
}
#[derive(Debug,Clone,Copy)]
struct User{
    id: u32,
    // name: String, //String 没有 Copy 需要先注释掉
    race:Race,
}

fn main(){
    let user = User{
        id: 3,
        // name: "cccy".to_string(),
        race: Race::Yellow,
    };
    // 需要实现 Debug
    println!("{:#?}",user);
    // User {
    //     id: 3,
    //     name: "cccy",
    //     race: Yellow,
    // }

    // 需要实现 Clone
    let user2 = user.clone();
    println!("{:#?}",user2);
    // User {
    //     id: 3,
    //     name: "cccy",
    //     race: Yellow,
    // }
    println!("{:#?}",user);

    // 需要实现 Copy 这将不会转移所有权
    println!("{:#?}",user2);
}
```



```rust
use std::io::Take;

// Clone Copy Debug PartialEq     Add
// 层级
// 统计用户的种族
#[derive(Debug,Clone)]
enum Race{
    White,
    Yellow,
    Black,
}
impl PartialEq for Race{
    fn eq(&self, other: &Self) -> bool {
        match (self,other) {
            (Race::White, Race::White) => true,
            (Race::Yellow, Race::Yellow) => true,
            (Race::Black, Race::Black) => true,
            _ => false,
        }
    }
}
#[derive(Debug,Clone)]
struct User{
    id: u32,
    name: String, //在实现 Copy 时 String 没有 Copy 需要先注释掉
    race:Race,
}

// 判断是否相等
impl PartialEq for User{
    fn eq(&self, other: &Self) -> bool {
       self.id == other.id && self.name == other.name && self.race == other.race
    }
}

fn main(){
    let user = User{
        id: 3,
        name: "cccy".to_string(),
        race: Race::Yellow,
    };
    // 需要实现 Debug
    println!("{:#?}",user);
    // User {
    //     id: 3,
    //     name: "cccy",
    //     race: Yellow,
    // }

    // 需要实现 Clone
    let user2 = user.clone();
    println!("{:#?}",user2);
    // User {
    //     id: 3,
    //     name: "cccy",
    //     race: Yellow,
    // }
    // println!("{:#?}",user);

    // 需要实现 Copy 这将不会转移所有权
    println!("{:#?}",user2);
    println!("{:#?}",user);

    // 判断是否相等
    println!("{:#?}",user == user2);
    // true
}
```

