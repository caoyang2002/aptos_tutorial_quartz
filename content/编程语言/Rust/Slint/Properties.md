---
title: 属性
---
# 属性

所有元素都有属性。内置元素带有常见属性，例如颜色或尺寸属性。您可以为它们分配值或整个[表达式](https://releases.slint.dev/1.7.2/docs/slint/src/language/syntax/expressions)：

```slint
export component Example inherits Window {
    // 简单表达式：以分号结束
    width: 42px;
    // 或代码块（不需要分号）
    height: { 42px }
}
```

属性的默认值是该类型的默认值。例如，布尔属性的默认值为`false`，整型属性的默认值为零，等等。

除了现有属性外，还可以通过指定类型、名称以及可选的默认值来定义额外的属性：

```slint
export component Example {
    // 声明一个名为 `my-property` 的整型属性
    property<int> my-property;

    // 声明一个具有默认值的属性
    property<int> my-second-property: 42;
}
```

用修饰符注释额外属性，指明该属性的读写方式：

- **`private`**（默认值）：该属性只能在组件内部访问。
- **`in`**：该属性是输入属性，可以由该组件的用户设置和修改，例如通过绑定或在回调中赋值。组件可以提供默认绑定，但不能通过赋值覆盖它。
- **`out`**：输出属性，仅能由组件设置。对于组件的用户来说是只读的。
- **`in-out`**：该属性可以被所有人读取和修改。

```slint
export component Button {
    // 该属性由组件的用户设置。
    in property <string> text;
    // 该属性供组件的用户读取。
    out property <bool> pressed;
    // 该属性既可由用户更改，也可由组件自身更改。
    in-out property <bool> checked;

    // 该属性对该组件是内部的。
    private property <bool> has-mouse;
}
```

所有在组件顶层声明的非`private`属性在将组件用作元素时可以从外部访问，或者通过语言绑定从业务逻辑访问。

## 绑定

当绑定表达式中访问的属性发生变化时，该表达式会自动重新评估。

在以下示例中，当用户按下按钮时，按钮的文本会自动改变。递增`counter`属性会自动使绑定到`text`的表达式失效并触发重新评估。

```slint
import { Button } from "std-widgets.slint";
export component Example inherits Window {
    preferred-width: 50px;
    preferred-height: 50px;
    Button {
        property <int> counter: 3;
        clicked => { self.counter += 3 }
        text: self.counter * 2;
    }
}
```

重新评估是懒加载的，仅在查询属性时进行。

内部会为在评估绑定时访问的任何属性注册依赖关系。当属性发生变化时，依赖项会被通知，所有依赖的绑定会被标记为脏。

默认情况下，原生代码中的回调不依赖于任何属性，除非它们在原生代码中查询属性。

## 双向绑定

使用`<=>`语法在属性之间创建双向绑定。这些属性将相互连接，并始终包含相同的值。

`<=>`右侧必须是同一类型属性的引用。双向绑定的属性类型是可选的，如果未指定，将进行推断。

```slint
export component Example {
    in property<brush> rect-color <=> r.background;
    // 允许省略类型以进行自动推断
    in property rect-color2 <=> r.background;
    r:= Rectangle {
        width: parent.width;
        height: parent.height;
        background: blue;
    }
}
```

## 相对长度

有时，使用相对百分比表示长度属性之间的关系是方便的。例如，下面的内层蓝色矩形大小为外层绿色窗口的一半：

```slint
export component Example inherits Window {
    preferred-width: 100px;
    preferred-height: 100px;

    background: green;
    Rectangle {
        background: blue;
        width: parent.width * 50%;
        height: parent.height * 50%;
    }
}
```

这种以父级相同名称的属性百分比表示`width`或`height`的模式是常见的。为方便起见，对于这种情况存在一种简写语法：

- 属性为`width`或`height`
- 绑定表达式评估为百分比。

如果满足这些条件，则不需要指定父属性，可以直接使用百分比。先前的示例可以改写为：

```slint
export component Example inherits Window {
    preferred-width: 100px;
    preferred-height: 100px;

    background: green;
    Rectangle {
        background: blue;
        width: 50%;
        height: 50%;
    }
}
```