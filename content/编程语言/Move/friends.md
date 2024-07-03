# 好友

`friend`语法用于声明当前模块信任的模块。允许可信模块调用当前模块中定义的具有`public(friend)`可见性的任何函数。有关功能可见性的详细信息，请参阅[功能](https://aptos.guide/en/build/smart-contracts/book/functions)中的*可见性*部分。

## 朋友声明

模块可以通过朋友声明语句将其他模块声明为朋友，格式为

- `friend <address::name>`—使用完全限定的模块名称进行朋友声明，如以下示例，或

    ```rust
    module 0x42::a {
        friend 0x42::b;
    }
    ```

    

- `friend <module-name-alias>`—使用模块名称别名的朋友声明，其中模块别名通过`use`语句引入。

    ```rust
    module 0x42::a {
        use 0x42::b;
        friend b;
    }
    ```

    

一个模块可能有多个朋友声明，所有朋友模块的联合构成了朋友列表。在下面的例子中，`0x42::B`和`0x42::C`都被认为是`0x42::A`的朋友。

```rust
module 0x42::a {
    friend 0x42::b;
    friend 0x42::c;
}
```



与`use`语句不同，`friend`只能在模块作用域中声明，不能在表达式块作用域中声明。`friend`声明可以位于允许顶级结构（例如`use`、`function`、`struct`等）的任何地方。然而，为了可读性，建议将朋友声明放在模块定义的开头附近。

请注意，友谊的概念不适用于移动脚本：

- 移动脚本不能声明`friend`模块，因为这样做被认为是毫无意义的：没有调用脚本中定义的函数的机制。
- Move模块也不能声明`friend`脚本，因为脚本是短暂的代码片段，永远不会发布到全局存储。

### 朋友声明规则

朋友声明受以下规则的约束：

- 模块不能声明自己是朋友。

    ```rust
    module 0x42::m {
      friend Self; // ERROR!
    //       ^^^^ Cannot declare the module itself as a friend
    }
     
    module 0x43::m {
      friend 0x43::M; // ERROR
    //       ^^^^^^^ Cannot declare the module itself as a friend
    }
    ```

    

- 编译器必须知道朋友模块

    ```rust
    module 0x42::m {
      friend 0x42::nonexistent; // ERROR!
      //     ^^^^^^^^^^^^^^^^^ Unbound module '0x42::nonexistent'
    }
    ```

    

- 朋友模块必须在同一帐户地址内。（注：这不是技术要求，而是稍后*可能会*放松的政策决定。）

    ```rust
    module 0x42::m {}
     
    module 0x43::n {
      friend 0x42::m; // ERROR!
    //       ^^^^^^^ Cannot declare modules out of the current address as a friend
    }
    ```

    

- 朋友关系不能创建循环模块依赖关系。

    朋友关系中不允许循环，例如，关系`0x2::a`朋友`0x2::b`朋友`0x2::c`朋友`0x2::a`是不允许的。更一般地说，声明朋友模块将对当前模块的依赖性添加到朋友模块中（因为目的是让朋友调用当前模块中的函数）。如果已经直接或传递使用该朋友模块，则将创建一个依赖周期。

    ```rust
    address 0x2 {
      module a {
        use 0x2::c;
        friend 0x2::b;
     
        public fun a() {
          c::c()
        }
      }
     
      module b {
        friend 0x2::c; // ERROR!
      //       ^^^^^^ This friend relationship creates a dependency cycle: '0x2::b' is a friend of '0x2::a' uses '0x2::c' is a friend of '0x2::b'
      }
     
      module c {
        public fun c() {}
      }
    }
    ```

    

- 模块的朋友列表不能包含重复项。

    ```rust
    address 0x42 {
      module a {}
     
      module m {
        use 0x42::a as aliased_a;
        friend 0x42::A;
        friend aliased_a; // ERROR!
      //       ^^^^^^^^^ Duplicate friend declaration '0x42::a'. Friend declarations in a module must be unique
      }
    }
    ```

    