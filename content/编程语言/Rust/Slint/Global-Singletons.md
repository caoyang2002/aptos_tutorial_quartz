---
title: 全局单例
---
# 全局单例

使用 `global Name { /* .. 属性或回调 .. */ }` 声明一个全局单例，以便在整个项目中访问属性和回调。可以通过 `Name.property` 访问它们。

例如，这对于共享的颜色调色板很有用：

```slint
global Palette {
    in-out property<color> primary: blue;
    in-out property<color> secondary: green;
}

export component Example inherits Rectangle {
    background: Palette.primary;
    border-color: Palette.secondary;
    border-width: 2px;
}
```

导出全局变量以使其在其他文件中可访问（请参见 [模块](https://releases.slint.dev/1.7.2/docs/slint/src/language/syntax/modules)）。如果从导出主应用组件的文件中导出全局变量，则可以使其在业务逻辑中的本地代码中可见。

```slint
export global Logic {
    in-out property<int> the-value;
    pure callback magic-operation(int) -> int;
}
// ...
```

在 Rust 中使用

```rust
slint::slint! {
export global Logic {
    in-out property<int> the-value;
    pure callback magic-operation(int) -> int;
}

export component App inherits Window {
    // ...
}
}

fn main() {
    let app = App::new();
    app.global::<Logic>().on_magic_operation(|value| {
        eprintln!("magic operation input: {}", value);
        value * 2
    });
    app.global::<Logic>().set_the_value(42);
    // ...
}
```

可以使用双向绑定语法重新暴露全局中的回调或属性。

```slint
global Logic {
    in-out property<int> the-value;
    pure callback magic-operation(int) -> int;
}

component SomeComponent inherits Text {
    // 在任何组件中使用全局变量
    text: "The magic value is:" + Logic.magic-operation(42);
}

export component MainWindow inherits Window {
    // 重新暴露全局属性，以便本地代码可以访问或修改它们
    in-out property the-value <=> Logic.the-value;
    pure callback magic-operation <=> Logic.magic-operation;

    SomeComponent {}
}
```