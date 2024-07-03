---
title: 能力类型
---
# 能力

能力是移动中的一个打字功能，它控制给定类型的值允许哪些操作。该系统对值的“线性”类型行为以及值是否以及如何在全局存储中使用提供细粒度控制。这是通过门控访问某些字节码指令来实现的，因此要将值与字节码指令一起使用，它必须具有所需的能力（如果需要的话——并非每个指令都由能力门控）。

## 四种能力[](https://aptos.guide/en/build/smart-contracts/book/abilities#the-four-abilities)

这四种能力是：

- [`copy`](https://aptos.guide/en/build/smart-contracts/book/abilities#copy)
    - 允许复制具有此功能的类型值。
- [`drop`](https://aptos.guide/en/build/smart-contracts/book/abilities#drop)
    - 允许弹出/删除具有此功能的类型值。
- [`store`](https://aptos.guide/en/build/smart-contracts/book/abilities#store)
    - 允许具有此能力的类型值存在于全局存储中的结构中。
- [`key`](https://aptos.guide/en/build/smart-contracts/book/abilities#key)
    - 允许该类型作为全局存储操作的密钥。

### `copy`[](https://aptos.guide/en/build/smart-contracts/book/abilities#copy)

`copy`能力允许复制具有该能力的类型值。它能够使用[`copy`](https://aptos.guide/en/build/smart-contracts/book/variables#move-and-copy)运算符从局部变量中复制值，并通过[取消引用`*e`](https://aptos.guide/en/build/smart-contracts/book/references#reading-and-writing-through-references)通过引用复制值。

如果一个值有`copy`，则该值中包含的所有值都有`copy`。

### `drop`[](https://aptos.guide/en/build/smart-contracts/book/abilities#drop)

`drop`能力允许放弃具有该能力的类型值。删除意味着该值不会被转移，并且在移动程序执行时被有效销毁。因此，这种能力具有忽略多个位置的值的能力，包括：

- 不使用局部变量或参数中的值
- 不使用[序列](https://aptos.guide/en/build/smart-contracts/book/variables#expression-blocks)中的值[通过`;`](https://aptos.guide/en/build/smart-contracts/book/variables#expression-blocks)
- 覆盖[赋](https://aptos.guide/en/build/smart-contracts/book/variables#assignments)值中变量中的值
- [写`*e1 = e2`](https://aptos.guide/en/build/smart-contracts/book/references#reading-and-writing-through-references)时通过引用覆盖值。

如果一个值已`drop`，则该值中包含的所有值都已`drop`。

### `store`[](https://aptos.guide/en/build/smart-contracts/book/abilities#store)

`store`能力允许具有这种能力的类型值存在于全局存储的结构（资源）中，_但_不一定作为全局存储中的顶级资源。这是唯一不直接关闭操作的能力。相反，当与`key`一起使用时，它会将存在门在全局存储中。

如果一个值有`store`，则该值中包含的所有值都有`store`

### `key`[](https://aptos.guide/en/build/smart-contracts/book/abilities#key)

`key`能力允许该类型作为[全局存储操作](https://aptos.guide/en/build/smart-contracts/book/global-storage-operators)的密钥。它门禁了所有全局存储操作，因此为了使类型与`move_to`、`borrow_global`、`move_from`等一起使用，该类型必须具有`key`能力。请注意，操作仍然必须在定义`key`类型的模块中使用（从某种意义上说，操作对定义模块是私有的）。

如果一个值有`key`，则该值中包含的所有值都有`store`。这是具有这种不对称的唯一能力。

## 内置类型[](https://aptos.guide/en/build/smart-contracts/book/abilities#builtin-types)

大多数原始的内置类型都有`copy`、`drop`和`store`，除了`signer`，它只是有`drop`

- `bool`、`u8`、`u16`、`u32`、`u64`、`u128`、`u256`和`address`都有`copy`、`drop`和`store`。
- `signer`有`drop`
    - 无法复制，也无法放入全局存储
- `vector<T>`根据`T`的能力，可能会有`copy`、`drop`和`store`。
    - 有关更多详细信息，请参阅[条件能力和通用类型](https://aptos.guide/en/build/smart-contracts/book/abilities#conditional-abilities-and-generic-types)。
- 不可变引用`&`和可变引用`&mut`都有`copy`和`drop`。
    - 这指的是复制和删除引用本身，而不是他们所指的。
    - 引用不能出现在全局存储中，因此它们没有`store`。

没有一个原始类型有`key`，这意味着它们都不能直接与[全局存储操作](https://aptos.guide/en/build/smart-contracts/book/global-storage-operators)一起使用。

## 注释结构[](https://aptos.guide/en/build/smart-contracts/book/abilities#annotating-structs)

要声明`struct`具有能力，请在结构名称后但字段前声明`has <ability>`。例如：

```
module 0x42::example {
  struct Ignorable has drop { f: u64 }
 
  struct Pair has copy, drop, store { x: u64, y: u64 }
}
```

在这种情况下：`Ignorable`有`drop`能力。`Pair`有`copy`、`drop`和`store`。

所有这些能力都对这些封闭式操作有强有力的保证。只有当该值具有该能力时，才能对该值执行该操作；即使该值深深嵌套在其他集合中！

因此：在声明结构的能力时，对字段提出了某些要求。所有字段都必须满足这些约束。这些规则是必要的，以便结构满足上述能力的可达性规则。如果一个结构被声明为有能力...

- `copy`，所有字段都必须有`copy`。
- `drop`，所有字段都必须有`drop`。
- `store`，所有字段都必须有`store`。
- `key`，所有字段都必须有`store`。
    - `key`是目前唯一不需要自己的能力。

例如：

```
module 0x42::example {
  // A struct without any abilities
  struct NoAbilities {}
 
  struct WantsCopy has copy {
    f: NoAbilities, // ERROR 'NoAbilities' does not have 'copy'
  }
}
```

同样：

```
module 0x42::example {
  // A struct without any abilities
  struct NoAbilities {}
 
  struct MyResource has key {
    f: NoAbilities, // Error 'NoAbilities' does not have 'store'
  }
}
```

## 条件能力和通用类型[](https://aptos.guide/en/build/smart-contracts/book/abilities#conditional-abilities-and-generic-types)

当能力在通用类型上进行注释时，并非该类型的所有实例都能保证具有该能力。考虑这个结构声明：

```
module 0x42::example {
  struct Cup<T> has copy, drop, store, key { item: T }
}
```

如果`Cup`可以容纳任何类型，无论其能力如何，这可能会非常有帮助。类型系统_可以看到_类型参数，因此，如果它_看到_违反该能力保证的类型参数，它应该能够从`Cup`中删除能力。

起初，这种行为听起来可能有点令人困惑，但如果我们考虑集合类型，它可能更容易理解。我们可以考虑内置类型`vector`具有以下类型声明：

```
vector<T> has copy, drop, store;
```

我们希望`vector`适用于任何类型。我们不希望为不同的能力提供单独的`vector`类型。那么，我们想要的规则是什么？与我们想要的上述字段规则完全相同。因此，只有当内部元素可以复制时，复制`vector`才是安全的。只有当内部元素可以被忽略/删除时，忽略`vector`才是安全的。而且，只有当内部元素可以在全球存储中时，将`vector`放在全局存储中才是安全的。

为了获得这种额外的表现力，一个类型可能不具有声明的所有能力，这取决于该类型的实例化；相反，一个类型将拥有的能力取决于其声明**和**类型参数。对于任何类型，类型参数都悲观地假设在结构内使用，因此只有当类型参数满足上述字段要求时，才能授予能力。以上面的`Cup`为例：

- `Cup`只有在`T`有`copy`的情况下，才有`copy`的能力。
- 只有当`T`有`drop`它才会`drop`。
- 只有当`T`有`store`，它才有`store`。
- 只有当`T`有`store`，它才有`key`。

以下是每种能力的条件系统示例：

### 示例：条件`copy`[](https://aptos.guide/en/build/smart-contracts/book/abilities#example-conditional-copy)

```
module 0x42::example {
  struct NoAbilities {}
 
  struct S has copy, drop { f: bool }
 
  struct Cup<T> has copy, drop, store { item: T }
 
  fun example(c_x: Cup<u64>, c_s: Cup<S>) {
    // Valid, 'Cup<u64>' has 'copy' because 'u64' has 'copy'
    let c_x2 = copy c_x;
    // Valid, 'Cup<S>' has 'copy' because 'S' has 'copy'
    let c_s2 = copy c_s;
  }
 
  fun invalid(c_account: Cup<signer>, c_n: Cup<NoAbilities>) {
    // Invalid, 'Cup<signer>' does not have 'copy'.
    // Even though 'Cup' was declared with copy, the instance does not have 'copy'
    // because 'signer' does not have 'copy'
    let c_account2 = copy c_account;
    // Invalid, 'Cup<NoAbilities>' does not have 'copy'
    // because 'NoAbilities' does not have 'copy'
    let c_n2 = copy c_n;
  }
}
```

### 示例：条件`drop`[](https://aptos.guide/en/build/smart-contracts/book/abilities#example-conditional-drop)

```
module 0x42::example {
  struct NoAbilities {}
 
  struct S has copy, drop { f: bool }
 
  struct Cup<T> has copy, drop, store { item: T }
 
  fun unused() {
    Cup<bool> { item: true }; // Valid, 'Cup<bool>' has 'drop'
    Cup<S> { item: S { f: false } }; // Valid, 'Cup<S>' has 'drop'
  }
 
  fun left_in_local(c_account: Cup<signer>): u64 {
    let c_b = Cup<bool> { item: true };
    let c_s = Cup<S> { item: S { f: false } };
    // Valid return: 'c_account', 'c_b', and 'c_s' have values
    // but 'Cup<signer>', 'Cup<bool>', and 'Cup<S>' have 'drop'
    0
  }
 
  fun invalid_unused() {
    // Invalid, Cannot ignore 'Cup<NoAbilities>' because it does not have 'drop'.
    // Even though 'Cup' was declared with 'drop', the instance does not have 'drop'
    // because 'NoAbilities' does not have 'drop'
    Cup<NoAbilities> { item: NoAbilities {} };
  }
 
  fun invalid_left_in_local(): u64 {
    let c_n = Cup<NoAbilities> { item: NoAbilities {} };
    // Invalid return: 'c_n' has a value
    // and 'Cup<NoAbilities>' does not have 'drop'
    0
  }
}
```

### 示例：条件`store`[](https://aptos.guide/en/build/smart-contracts/book/abilities#example-conditional-store)

```
module 0x42::example {
  struct Cup<T> has copy, drop, store { item: T }
 
  // 'MyInnerResource' is declared with 'store' so all fields need 'store'
  struct MyInnerResource has store {
    yes: Cup<u64>,
    // Valid, 'Cup<u64>' has 'store'
    // no: Cup<signer>, Invalid, 'Cup<signer>' does not have 'store'
  }
 
  // 'MyResource' is declared with 'key' so all fields need 'store'
  struct MyResource has key {
    yes: Cup<u64>,
    // Valid, 'Cup<u64>' has 'store'
    inner: Cup<MyInnerResource>,
    // Valid, 'Cup<MyInnerResource>' has 'store'
    // no: Cup<signer>, Invalid, 'Cup<signer>' does not have 'store'
  }
}
```

### 示例：条件`key`[](https://aptos.guide/en/build/smart-contracts/book/abilities#example-conditional-key)

```rust
module 0x42::example {
  struct NoAbilities {}
 
  struct MyResource<T> has key { f: T }
 
  fun valid(account: &signer) acquires MyResource {
    let addr = signer::address_of(account);
    // Valid, 'MyResource<u64>' has 'key'
    let has_resource = exists<MyResource<u64>>(addr);
    if (!has_resource) {
      // Valid, 'MyResource<u64>' has 'key'
      move_to(account, MyResource<u64> { f: 0 })
    };
    // Valid, 'MyResource<u64>' has 'key'
    let r = borrow_global_mut<MyResource<u64>>(addr)
    r.f = r.f + 1;
  }
 
  fun invalid(account: &signer) {
    // Invalid, 'MyResource<NoAbilities>' does not have 'key'
    let has_it = exists<MyResource<NoAbilities>>(addr);
    // Invalid, 'MyResource<NoAbilities>' does not have 'key'
    let NoAbilities {} = move_from<NoAbilities>(addr);
    // Invalid, 'MyResource<NoAbilities>' does not have 'key'
    move_to(account, NoAbilities {});
    // Invalid, 'MyResource<NoAbilities>' does not have 'key'
    borrow_global<NoAbilities>(addr);
  }
}
```