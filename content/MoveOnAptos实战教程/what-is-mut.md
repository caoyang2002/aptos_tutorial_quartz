---
title: mut 的作用是什么
---
先看一段[示例代码](https://aptos.dev/en/build/smart-contracts/book/structs-and-resources#borrowing-structs-and-fields)

```rust
module 0x2::m {
  struct Foo has drop{ x: u64, y: bool }
  fun example() {
    let foo = Foo { x: 3, y: true };
    let foo_ref: &Foo = &foo;
    let y: bool = foo_ref.y;  // 通过引用读取结构体中的字段
    let x_ref: &u64 = &foo.x;
 
    let x_ref_mut: &mut u64 = &mut foo.x;
    *x_ref_mut = 42;  // 通过可变引用修改字段
  }
}
```



```rust
module 0x2::m {
	struct Foo has drop{ x: u64, y: bool }
	fun example() {  
		
		let foo = Foo { x: 3, y: true };  
		let foo_ref: &Foo = &foo;  
		let y: bool = foo_ref.y;          // reading a field via a reference to the struct  
		let x_ref: &u64 = &foo.x;  
		  
		debug::print(x_ref);   // 可以输出
		  
		let x_ref_mut: &mut u64 = &mut foo.x;  
		*x_ref_mut = 42;            // modifying a field via a mutable reference  
		// debug::print(x_ref);  // 无法在这里输出
		debug::print(x_ref_mut);   // 可以输出
	}
}
```

成功执行。输出：

```bash
3
42
```

但你尝试取消注释下面一行 print 的时候，报错：

```rust
error[E07003]: invalid operation, could create dangling a reference
    ┌─ /Users/caoyang/Desktop/GitHub/pink_mammoth_community/contract/sources/get_token.move:311:9
    │
307 │         let x_ref: &u64 = &foo.x;
    │                           ------ It is still being borrowed by this reference
							    ------ 这个引用仍在被借用
    ·
311 │         *x_ref_mut = 42;            // modifying a field via a mutable reference
    │         ^^^^^^^^^^^^^^^ Invalid mutation of reference.
		      ^^^^^^^^^^^^^^^ 引用的的变更无效.
```

为什么？

```rust
struct Foo has drop{ x: u64, y: bool }  
  
#[test]  
fun example() {  
    let foo = Foo { x: 3, y: true };  
    let foo_ref: &Foo = &foo;  
    let _y: bool = foo_ref.y;          // reading a field via a reference to the struct  
    let x_ref: &u64 = &foo.x;    
    debug::print(x_ref); // success  
    // debug::print(x_ref); // success    
    *x_ref_mut = 42;            // modifying a field via a mutable reference  
    x_ref = freeze(x_ref_mut);  
    debug::print(x_ref); // error  
    debug::print(x_ref_mut); // sucess  
```

作用域：

在 Move V1 编译器中，