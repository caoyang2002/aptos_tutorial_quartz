---
title: 容器组件
---
# 容器组件

在创建组件时，有时需要影响子元素在使用时的位置。例如，一个在内部元素上方绘制标签的组件：

```slint
export component MyApp inherits Window {

    BoxWithLabel {
        Text {
            // ...
        }
    }

    // ...
}
```

您可以通过布局实现这样的 `BoxWithLabel`。默认情况下，像 `Text` 元素这样的子元素成为 `BoxWithLabel` 的直接子元素，但在这个示例中，它们需要成为布局的子元素。为此，可以使用 `@children` 表达式改变默认的子元素放置方式：

```typescript
component BoxWithLabel inherits GridLayout {
    Row {
        Text { text: "label text here"; }
    }
    Row {
        @children
    }
}

export component MyApp inherits Window {
    preferred-height: 100px;
    BoxWithLabel {
        Rectangle { background: blue; }
        Rectangle { background: yellow; }
    }
}
```