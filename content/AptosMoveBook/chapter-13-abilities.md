---
title: 第十三章 能力
aliases:
  - Abilities
draft: false
description: Aptos 上 Move 的别名
tags:
  - abilities
  - Move
date: 2024-07-04
---
[[../DailyMove/What-does-key- copy-drop-store-mean|结构体中能力的作用]]

能力是 Move 语言中的一个类型特性，它控制给定类型的值允许执行的操作。这个系统对值的“线性”类型行为以及值是否以及如何被用于全局存储提供了细粒度的控制。这是通过限制对某些字节码指令的访问来实现的，以便要使用某个值与字节码指令，它必须具有所需的能力（如果需要的话——并非每个指令都受到能力的约束）。

# 1. 四种能力

四种能力包括：

- `copy`：允许具有此能力的类型的值被复制。
- `drop`：允许具有此能力的类型的值被弹出/丢弃。
- `store`：允许具有此能力的类型的值存在于全局存储中的结构体内。
- `key`：允许类型作为全局存储操作的键。

## 1.1 `copy`

`copy`能力允许具有该能力的类型的值被复制。它通过[`copy`运算符](https://aptos.dev/en/build/smart-contracts/book/variables#move-and-copy)和[解引用 `*e`](https://aptos.dev/en/build/smart-contracts/book/references#reading-and-writing-through-references)来限制从局部变量复制值的能力。

如果一个值具有`copy`能力，那么该值内包含的所有值都具有`copy`能力。

## 1.2 `drop`

`drop`能力允许具有该能力的类型的值被丢弃。所谓丢弃，是指该值不会被转移，并且在执行Move程序时被有效销毁。因此，这种能力限制了在多种位置忽略值的能力，包括：

- 不在局部变量或参数中使用值
- 不在序列中通过[`;`](https://aptos.dev/en/build/smart-contracts/book/variables#expression-blocks)使用值
- 在[赋值](https://aptos.dev/en/build/smart-contracts/book/variables#assignments)中覆盖变量中的值
- 在[写入](https://aptos.dev/en/build/smart-contracts/book/references#reading-and-writing-through-references) `*e1 = e2` 时通过引用覆盖值

如果一个值具有`drop`能力，那么该值内包含的所有值都具有`drop`能力。

### 1.3 `store`

`store`能力允许具有此能力的类型的值存在于全局存储中的结构体（资源）内，但不一定是作为全局存储中的顶级资源。这是唯一不直接限制操作的能力。相反，当与`key`一起使用时，它限制了在全局存储中的存在。

如果一个值具有`store`能力，那么该值内包含的所有值都具有`store`能力。

## 1.4 `key`

`key`能力允许类型作为[全局存储操作](https://aptos.dev/en/build/smart-contracts/book/global-storage-operators)的键。它限制了所有全局存储操作，因此为了使用类型与`move_to`、`borrow_global`、`move_from`等一起，该类型必须具有`key`能力。注意，这些操作仍然必须在定义`key`类型的模块中使用（从某种意义上说，操作是定义模块的私有的）。

如果一个值具有`key`能力，那么该值内包含的所有值都具有`store`能力。这是这种不对称性所具备的唯一能力。

# 2. 内置类型

大多数内置原始类型具有`copy`、`drop`和`store`能力，除了`signer`，它只有`drop`能力。

- `bool`、`u8`、`u16`、`u32`、`u64`、`u128`、`u256`和`address`都具有`copy`、`drop`和`store`能力。
- `signer`
  - 只有`drop`能力。
  - 不能被复制，不能放入全局存储。
- `vector<T>`
  - 可能具有`copy`、`drop`和`store`能力，这取决于`T`的能力。
  - 有关更多详细信息，请参见[有条件能力和通用类型](https://aptos.dev/en/build/smart-contracts/book/abilities#conditional-abilities-and-generic-types)。

不可变引用`&`和可变引用`&mut`都具有`copy`和`drop`能力。

- 这指的是复制和丢弃引用本身，而不是它们所引用的内容。
- 引用不能出现在全局存储中，因此它们没有`store`能力。

所有原始类型都没有`key`能力，意味着它们都不能直接用于[全局存储操作](https://aptos.dev/en/build/smart-contracts/book/global-storage-operators)。

# 3. 标记结构体

要声明一个`struct`具有某种能力，在结构体名称之后但在字段之前使用`has <ability>`进行标记。例如：

```rust
module 0x42::example {
  struct Ignorable has drop { f: u64 }
 
  struct Pair has copy, drop, store { x: u64, y: u64 }
}
```

在这种情况下：`Ignorable`具有`drop`能力。`Pair`具有`copy`、`drop`和`store`能力。

所有这些能力对这些受限操作都有强有力的保证。只有在值具有该能力时，才能对该值执行操作；即使该值被嵌套在其他集合内！

因此：在声明结构体的能力时，对字段有特定的要求。所有字段必须满足这些约束。这些规则是必要的，以便结构体满足上述能力可达性规则。如果结构体声明具有能力…

- `copy`，所有字段必须具有`copy`能力。
- `drop`，所有字段必须具有`drop`能力。
- `store`，所有字段必须具有`store`能力。
- `key`，所有字段必须具有`store`能力。
  - `key`是目前唯一不需要自身的能力。

例如：

```rust
module 0x42::example {
    // 一个没有任何能力的struct
    struct NoAbilities {}

    struct WantsCopy has copy {
        f: NoAbilities, // ERROR 'NoAbilities' 没有 'copy' 能力
    }
}
```

以及类似地：

```rust
module 0x42::example {
    // 一个没有任何能力的struct
    struct NoAbilities {}

    struct MyResource has key {
        f: NoAbilities, // Error 'NoAbilities' 没有 'store' 能力
    }
}
```

# 4. 有条件的能力和通用类型

当能力在泛型上注释时，并不是该类型的所有实例都保证具有该能力。考虑这个结构体声明：

```rust
module 0x42::example {
    struct Cup<T> has copy, drop, store, key {
        item: T
    }
}
```

如果`Cup`能够容纳任何类型，无论其具有何种能力，这可能非常有用。类型系统可以“看到”类型参数，所以当它“看到”一个类型参数会违反该能力的保证时，它应该能够从`Cup`中移除能力。

这种行为一开始可能听起来有点令人困惑，但如果我们考虑集合类型，可能会更容易理解。我们可以认为内置类型`vector`具有以下类型声明：

```rust
vector<T> has copy, drop, store;
```

我们希望`vector`与任何类型一起工作。我们不希望为不同的能力创建不同的`vector`类型。那么，我们希望的规则是什么？正是与上述字段规则相同的规则。因此，只有当内部元素可以被复制时，才安全地复制一个`vector`值。只有当内部元素可以被忽略/丢弃时，才安全地忽略一个`vector`值。并且，只有当内部元素可以存储在全局存储中时，才安全地将一个`vector`放入全局存储。

为了拥有这种额外的表现力，一个类型可能不一定具有它声明的所有能力，这取决于该类型的实例化；相反，一个类型将具有的能力取决于它的声明**和 **它的类型参数。对于任何类型，类型参数被悲观地假定在结构体内部使用，所以只有当类型参数满足上述字段要求时，才会授予能力。以上面的`Cup`为例：

- `Cup`具有`copy`能力，仅当`T`具有`copy`能力。
- 它具有`drop`能力，仅当`T`具有`drop`能力。
- 它具有`store`能力，仅当`T`具有`store`能力。
- 它具有`key`能力，仅当`T`具有`store`能力。

以下是每种能力的有条件系统的示例：

## 4.1 示例：条件 `copy`

```rust
module 0x42::example {
    struct NoAbilities {}
    struct S has copy, drop {
        f: bool
    }
    struct Cup<T> has copy, drop, store {
        item: T
    }
    fun example(c_x: Cup<u64>, c_s: Cup<S>) {
        // 有效，'Cup<u64>' 具有 'copy' 能力，因为 'u64' 具有 'copy' 能力
        let c_x2 = copy c_x;
        // 有效，'Cup<S>' 具有 'copy' 能力，因为 'S' 具有 'copy' 能力
        let c_s2 = copy c_s;
    }fun invalid(c_account: Cup<signer>, c_n: Cup<NoAbilities>) {
        // 无效，'Cup<signer>' 没有 'copy' 能力。
        // 尽管 'Cup' 声明了 copy，实例没有 'copy' 能力，因为 'signer' 没有 'copy' 能力
        let c_account2 = copy c_account;
        // 无效，'Cup<NoAbilities>' 没有 'copy' 能力，因为 'NoAbilities' 没有 'copy' 能力
        let c_n2 = copy c_n;
    }
}
```

## 4.2 示例：条件 `drop`

```rust
module 0x42::example {
    struct NoAbilities {}
    struct S has copy, drop {
        f: bool
    }
    struct Cup<T> has copy, drop, store {
        item: T
    }
    fun unused() {
        Cup<bool> { item: true }; // 有效，'Cup<bool>' 具有 'drop' 能力
        Cup<S> { item: S { f: false } }; // 有效，'Cup<S>' 具有 'drop' 能力
    }
    fun left_in_local(c_account: Cup<signer>): u64 {
        let c_b = Cup<bool> { item: true };
        let c_s = Cup<S> { item: S { f: false } };
        // 有效返回：'c_account'、'c_b' 和 'c_s' 有值
        // 但 'Cup<signer>'、'Cup<bool>' 和 'Cup<S>' 具有 'drop' 能力
        0
    }
    fun invalid_unused() {
        // 无效，不能忽略 'Cup<NoAbilities>' 因为它没有 'drop' 能力。
        // 尽管 'Cup' 声明了 'drop'，实例没有 'drop' 能力
        // 因为 'NoAbilities' 没有 'drop' 能力
        Cup<NoAbilities> { item: NoAbilities {} };
    }
    fun invalid_left_in_local(): u64 {
        let c_n = Cup<NoAbilities> { item: NoAbilities {} };
        // 无效返回：'c_n' 有一个值
        // 'Cup<NoAbilities>' 没有 'drop' 能力
        0
    }
}
```

## 4.3 示例：条件 `store`

```rust
module 0x42::example {
    struct Cup<T> has copy, drop, store {
        item: T
    }
    // 'MyInnerResource' 声明了 'store'，所以所有字段都需要 'store' 能力
    struct MyInnerResource has store {
        yes: Cup<u64>, // 有效，'Cup<u64>' 具有 'store' 能力
        // no: Cup<signer>, 无效，'Cup<signer>' 没有 'store' 能力
    }
    // 'MyResource' 声明了 'key'，所以所有字段都需要 'store' 能力
    struct MyResource has key {
        yes: Cup<u64>, // 有效，'Cup<u64>' 具有 'store' 能力
        inner: Cup<MyInnerResource>, // 有效，'Cup<MyInnerResource>' 具有 'store' 能力
        // no: Cup<signer>, 无效，'Cup<signer>' 没有 'store' 能力
    }
}
```

## 4.4 示例：条件 `key`

```rust
module 0x42::example {
    struct NoAbilities {}
    struct MyResource<T> has key {
        f: T
    }
    fun valid(account: &signer) acquires MyResource {
        let addr = signer::address_of(account);
        // 有效，'MyResource<u64>' 具有 'key' 能力
        let has_resource = exists<MyResource<u64>>(addr);
        if (!has_resource) {
            // 有效，'MyResource<u64>' 具有 'key' 能力
            move_to(account, MyResource<u64> { f: 0 })
        };
        // 有效，'MyResource<u64>' 具有 'key' 能力
        let r = borrow_global_mut<MyResource<u64>>(addr)
        r.f = r.f + 1;
    }
    fun invalid(account: &signer) {
        // 无效，'MyResource<NoAbilities>' 没有 'key' 能力
        let has_it = exists<MyResource<NoAbilities>>(addr);
        // 无效，'MyResource<NoAbilities>' 没有 'key' 能力
        let NoAbilities {} = move_from<NoAbilities>(addr);
        // 无效，'MyResource<NoAbilities>' 没有 'key' 能力
        move_to(account, NoAbilities {});
        // 无效，'MyResource<NoAbilities>' 没有 'key' 能力
        borrow_global<NoAbilities>(addr);
    }
}
```
