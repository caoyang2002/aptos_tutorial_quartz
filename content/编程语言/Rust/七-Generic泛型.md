# Generic Structures

## Generic

泛型是编程语言的特性，它允许在代码中使用参数化类型，以便在不同地方使用相同的代码逻辑处理多种数据类型，而无需为每种类型编写单独的代码

作用：

1. 提高代码的重用性、
2. 提高代码的可读性
3. 提高代码的抽象度



## 泛型的应用类型

1. 泛型定义结构体 / 枚举
2. 泛型定义函数
3. 泛型与特质

```rust
#[derive(Debug)]
// 相同的类型
struct Point <T> {
    x:T,
    y:T,
}

// 不同的类型
#[derive(Debug)]
struct PointTwo <T,E> {
    x:T,
    y:E,
}
fn main() {
    let c1 = Point{ x:1.0, y:2.0, };
    let c2 = Point{ x:'x', y:'y', };
    println!("c1 is {:?}, \nc2 is {:?}",c1,c2);
    // c1 is Point { x: 1.0, y: 2.0 },
    // c2 is Point { x: 'x', y: 'y' }
    //
    let c3 = PointTwo{ x:1.0, y:'y', };
    println!("c3 is {:?}",c3);
    // c3 is PointTwo { x: 1.0, y: 'y' }
}
```





# Generic Function

## 泛型与函数

在 Rust 中，泛型也可以用于函数，使得函数能够处理多种类型的参数，提高代码的重用性和灵活性

1. 泛型与函数
2. 泛型与结构体中的方法

```rust
// 交换
fn swap<T>(a:T, b:T) -> (T,T){
    (b,a)
}

struct Point<T>{
    x:T,
    y:T,
}

impl<T> Point<T> {
    fn new(x:T,y:T) -> Self { // 可以不用再次声明 T
        Point{x,y}
    }
    fn get_coordinates(&self) -> (&T,&T){
        (&self.x,&self.y)
    }
}

fn main(){
    let number = swap(0,1);
    println!("swap {:?}",number);
    // swap (1, 0)

    let f_number = swap::<f64>(0.1,2.0);
    println!("swap f_number is {:?}",f_number);
    // swap f_number is (2.0, 0.1)

    let ff_number:(f64,f64) = swap(0.1,2.0);
    println!("swap f_number is {:?}",ff_number);
    // swap f_number is (2.0, 0.1)

    //-------------
    let str = swap("front","end");
    println!("str is {:?}",str);
    // str is ("end", "front")
    let str = swap(str.0,str.1);
    println!("str 0 is {} \nstr 1 is {}",str.0,str.1);
    //str 0 is front
    // str 1 is end

    let i32_point = Point::new(2,3);
    let f64_point = Point::new(2.0,3.0);
    let (x1,y1) = i32_point.get_coordinates();
    let (x2,y2) = f64_point.get_coordinates();
    println!("i32 point is x = {}, y = {}",x1,y1);
    // i32 point is x = 2, y = 3
    println!("f46 point is x = {}, y = {}",x2,y2);
    // f46 point is x = 2, y = 3

    // 给结构体的用 String 不要用 &str 字面量
    let string_point = Point::new("x_str".to_string(),"y_str".to_string());
    println!("string point x = {}, y = {}",string_point.x,string_point.y);
    // string point x = x_str, y = y_str
}
```



