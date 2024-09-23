---
title: .slint 文件
---
## .slint 文件

您使用 Slint 语言编写用户界面，并将其保存在扩展名为 .slint 的文件中。

每个 .slint 文件定义一个或多个组件。这些组件声明一个元素树。组件是 Slint 组合的基础。利用它们构建您自己的可重用 UI 控件集。您可以在其他组件中以其名称作为元素使用每个声明的组件。

以下是组件和元素的示例：

```slint
component MyButton inherits Text {
    color: black;
    // ...
}

export component MyApp inherits Window {
    preferred-width: 200px;
    preferred-height: 100px;
    Rectangle {
        width: 200px;
        height: 100px;
        background: green;
    }
    MyButton {
        x: 0; y: 0;
        text: "hello";
    }
    MyButton {
        y: 0;
        x: 50px;
        text: "world";
    }
}
```

`MyButton` 和 `MyApp` 都是组件。`Window` 和 `Rectangle` 是 MyApp 使用的内置元素。MyApp 还将 MyButton 组件重用为两个独立的元素。

元素具有属性，您可以为其分配值。上面的示例将字符串常量“hello”分配给第一个 MyButton 的文本属性。您还可以分配整个表达式。当依赖的任何属性发生变化时，Slint 会重新评估表达式，使用户界面具有反应性。

您可以使用 `:=` 语法为元素命名：

```slint
component MyButton inherits Text {
    // ...
}

export component MyApp inherits Window {
    preferred-width: 200px;
    preferred-height: 100px;

    hello := MyButton {
        x: 0; y: 0;
        text: "hello";
    }
    world := MyButton {
        y: 0;
        text: "world";
        x: 50px;
    }
}
```

### 注意

名称必须是有效的标识符。

某些元素也可以通过预定义名称访问：

- `root` 指的是组件的最外层元素。
- `self` 指的是当前元素。
- `parent` 指的是当前元素的父元素。

这些名称是保留的，您不能重新定义它们。