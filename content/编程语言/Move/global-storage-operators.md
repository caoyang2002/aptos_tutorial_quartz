---
title: 全局存储-操作符
---
# 全球存储-运营商

移动程序可以使用以下五条说明创建、删除和更新全局存储中的[资源](https://aptos.guide/en/build/smart-contracts/book/structs-and-resources)：

|操作|描述|流产？|
|---|---|---|
|`move_to<T>(&signer,T)`|发布`T`在`signer.address`|如果`signer.address`已经持有`T`|
|`move_from<T>(address): T`|从`address`中删除`T`并返回|如果`address`不持有`T`|
|`borrow_global_mut<T>(address): &mut T`|返回对下存储的`T`的可变引用`address`|如果`address`不持有`T`|
|`borrow_global<T>(address): &T`|返回对存储在...下的`T`的不可变引用`address`|如果`address`不持有`T`|
|`exists<T>(address): bool`|如果`T`存储在`address`|从来没有|

这些指令中的每一个都由具有[`key`能力的](https://aptos.guide/en/build/smart-contracts/book/abilities)`T`型参数化。然而，每个类型`T`_必须在当前模块中声明_。这确保了资源只能通过其定义模块公开的API进行操作。指令还采用一个[`address`](https://aptos.guide/en/build/smart-contracts/book/address)或[`&signer`](https://aptos.guide/en/build/smart-contracts/book/signer)，代表存储`T`类型资源的帐户地址。

## 资源参考[](https://aptos.guide/en/build/smart-contracts/book/global-storage-operators#references-to-resources)

`borrow_global`或`borrow_global_mut`返回的对全局资源的引用大多类似于对本地存储的引用：它们可以使用普通[引用运算符](https://aptos.guide/en/build/smart-contracts/book/references)进行扩展、读取和写入，并作为参数传递给其他函数。然而，本地引用和全局引用之间有一个重要区别：**函数不能返回指向全局存储的引用**。例如，这两个函数都无法编译：

```rust
module 0x42::example {
  struct R has key { f: u64 }
  // will not compile
  fun ret_direct_resource_ref_bad(a: address): &R {
    borrow_global<R>(a) // error!
  }
  // also will not compile
  fun ret_resource_field_ref_bad(a: address): &u64 {
    &borrow_global<R>(a).f // error!
  }
}
```

Move必须强制执行此限制，以保证没有对全局存储的悬垂引用。[本节](https://aptos.guide/en/build/smart-contracts/book/global-storage-operators#reference-safety-for-global-resources)为感兴趣的读者提供了更多细节。

## 具有通用的全球存储运营商[](https://aptos.guide/en/build/smart-contracts/book/global-storage-operators#global-storage-operators-with-generics)

全局存储操作可以应用于具有实例化和非实例化通用类型参数的通用资源：

```rust
module 0x42::example {
  struct Container<T> has key { t: T }
 
  // Publish a Container storing a type T of the caller's choosing
  fun publish_generic_container<T>(account: &signer, t: T) {
    move_to<Container<T>>(account, Container { t })
  }
 
  /// Publish a container storing a u64
  fun publish_instantiated_generic_container(account: &signer, t: u64) {
    move_to<Container<u64>>(account, Container { t })
  }
}
```

通过运行时选择的类型参数索引到全局存储的能力是一个强大的移动功能，称为_存储多态性_。有关此功能启用的设计模式的更多信息，请参阅[移动泛型](https://aptos.guide/en/build/smart-contracts/book/generics)。

## 示例：`Counter`[](https://aptos.guide/en/build/smart-contracts/book/global-storage-operators#example-counter)

下面的简单`Counter`模块练习了五个全球存储运营商中的每一个。此模块暴露的API允许：

- 任何人在其帐户下发布计数器资源
- 任何人可以检查任何地址下是否存在`Counter`
- 任何人在任何地址下读取或增加计数器资源的值
- 存储计数器资源以将其重置为零的帐户
- 存储计数器资源以删除和删除它的帐户

```rust
module 0x42::counter {
  use std::signer;
 
  /// Resource that wraps an integer counter
  struct Counter has key { i: u64 }
 
  /// Publish a `Counter` resource with value `i` under the given `account`
  public fun publish(account: &signer, i: u64) {
    // "Pack" (create) a Counter resource. This is a privileged operation that
    // can only be done inside the module that declares the `Counter` resource
    move_to(account, Counter { i })
  }
 
  /// Read the value in the `Counter` resource stored at `addr`
  public fun get_count(addr: address): u64 acquires Counter {
    borrow_global<Counter>(addr).i
  }
 
  /// Increment the value of `addr`'s `Counter` resource
  public fun increment(addr: address) acquires Counter {
    let c_ref = &mut borrow_global_mut<Counter>(addr).i;
    *c_ref = *c_ref + 1
  }
 
  /// Reset the value of `account`'s `Counter` to 0
  public fun reset(account: &signer) acquires Counter {
    let c_ref = &mut borrow_global_mut<Counter>(signer::address_of(account)).i;
    *c_ref = 0
  }
 
  /// Delete the `Counter` resource under `account` and return its value
  public fun delete(account: &signer): u64 acquires Counter {
    // remove the Counter resource
    let c = move_from<Counter>(signer::address_of(account));
    // "Unpack" the `Counter` resource into its fields. This is a
    // privileged operation that can only be done inside the module
    // that declares the `Counter` resource
    let Counter { i } = c;
    i
  }
 
  /// Return `true` if `addr` contains a `Counter` resource
  public fun exists_at(addr: address): bool {
    exists<Counter>(addr)
  }
}
```

## 注释功能与`acquires`[](https://aptos.guide/en/build/smart-contracts/book/global-storage-operators#annotating-functions-with-acquires)

在`counter`示例中，您可能已经注意到`get_count`、`increment`、`reset`和`delete`函数都用`acquires Counter`进行注释。移动函数`m::f`必须用`acquires T`注释，当且仅当：

- `m::f`的主体包含`move_from<T>`，`borrow_global_mut<T>`，或`borrow_global<T>`指令，或
- `m::f`的主体调用在同一模块中声明的函数`m::g`，该模块用注释`acquires`

例如，`Counter`内部的以下函数需要`acquires`注释：

```rust
module 0x42::example {
  // Needs `acquires` because `increment` is annotated with `acquires`
  fun call_increment(addr: address): u64 acquires Counter {
    counter::increment(addr)
  }
}
```

然而，`Counter`_之外_的相同功能不需要注释：

```rust
module 0x43::m {
  use 0x42::counter;
 
  // Ok. Only need annotation when resource acquired by callee is declared
  // in the same module
  fun call_increment(addr: address): u64 {
    counter::increment(addr)
  }
}
```

如果一个函数涉及多个资源，它需要多个`acquires`：

```rust
module 0x42::two_resources {
  struct R1 has key { f: u64 }
  struct R2 has key { g: u64 }
 
  fun double_acquires(a: address): u64 acquires R1, R2 {
    borrow_global<R1>(a).f + borrow_global<R2>(a).g
  }
}
```

`acquires`注释不考虑通用类型参数：

```rust
module 0x42::m {
  struct R<T> has key { t: T }
 
  // `acquires R`, not `acquires R<T>`
  fun acquire_generic_resource<T: store>(a: addr) acquires R {
    let _ = borrow_global<R<T>>(a);
  }
 
  // `acquires R`, not `acquires R<u64>
  fun acquire_instantiated_generic_resource(a: addr) acquires R {
    let _ = borrow_global<R<u64>>(a);
  }
}
```

最后：不允许冗余`acquires`。在`Counter`中添加此功能将导致编译错误：

```rust
module 0x42::m {
  // This code will not compile because the body of the function does not use a global
  // storage instruction or invoke a function with `acquires`
  fun redundant_acquires_bad() acquires Counter {}
}
```

有关`acquires`的更多信息，请参阅[移动函数](https://aptos.guide/en/build/smart-contracts/book/functions)。

## 全球资源的参考安全[](https://aptos.guide/en/build/smart-contracts/book/global-storage-operators#reference-safety-for-global-resources)

移动禁止返回全局引用，并要求`acquires`注释以防止悬垂的引用。这允许Move兑现其对所有[引用](https://aptos.guide/en/build/smart-contracts/book/references)类型的静态引用安全（即没有悬垂的引用，没有`null`或`nil`取消引用）的承诺。

此示例说明了移动类型系统如何使用`acquires`来防止悬垂的引用：

```rust
module 0x42::dangling {
  struct T has key { f: u64 }
 
  fun borrow_then_remove_bad(a: address) acquires T {
    let t_ref: &mut T = borrow_global_mut<T>(a);
    let t = remove_t(a); // type system complains here
    // t_ref now dangling!
    let uh_oh = *&t_ref.f;
  }
 
  fun remove_t(a: address): T acquires T {
    move_from<T>(a)
  }
}
```

在此代码中，第6行获取对存储在全局存储中地址`a`的`T`的引用。然后，被调用者`remove_t`删除该值，这使得`t_ref`成为悬垂的引用。

幸运的是，这不可能发生，因为类型系统会拒绝这个程序。`acquires`注释onremove`remove_t`让类型系统知道第7行是危险的，而不必单独重新检查或内省`remove_t`的主体！

对返回全局引用的限制防止了类似但更阴险的问题：

```rust
address 0x42 {
  module m1 {
    struct T has key {}
 
    public fun ret_t_ref(a: address): &T acquires T {
      borrow_global<T>(a) // error! type system complains here
    }
 
    public fun remove_t(a: address) acquires T {
      let T {} = move_from<T>(a);
    }
  }
 
  module m2 {
    fun borrow_then_remove_bad(a: address) {
      let t_ref = m1::ret_t_ref(a);
      let t = m1::remove_t(a); // t_ref now dangling!
    }
  }
}
```

第16行获取对全局资源`m1::T`的引用，然后第17行删除相同的资源，这使`t_ref`悬垂。在这种情况下，`acquires`注释对我们没有帮助，因为 `borrow_then_remove_bad`函数在声明`T`的`m1`模块之外（`acquires`注释的召回只能用于当前模块中声明的资源）。相反，类型系统通过防止在第6行返回全局引用来避免这个问题。

允许在不牺牲引用安全性的情况下返回全局引用的更类型系统是可能的，我们可能会在未来的移动迭代中考虑它们。我们选择当前的设计是因为它在表达、注释负担和类型系统复杂性之间取得了很好的平衡。