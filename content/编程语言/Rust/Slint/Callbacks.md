---
title: 回调
---
# 回调

组件可以声明回调，用于向外部传达状态变化。通过“调用”回调，就像调用函数一样来触发它们。

您可以使用 `=>` 箭头语法声明一个处理器，以响应回调的调用。内置的 `TouchArea` 元素声明了一个 `clicked` 回调，当用户触摸元素覆盖的矩形区域或用鼠标点击时会被调用。在下面的示例中，该回调的调用通过声明处理器并调用我们自定义的回调 (`hello`) 被转发：

```slint
export component Example inherits Rectangle {
    // 声明一个回调
    callback hello;

    area := TouchArea {
        // 使用 `=>` 设置处理器
        clicked => {
            // 触发回调
            root.hello()
        }
    }
}
```

回调也可以添加参数：

```slint
export component Example inherits Rectangle {
    // 声明一个回调
    callback hello(int, string);
    hello(aa, bb) => { /* ... */ }
}
```

回调还可以返回一个值：

```slint
export component Example inherits Rectangle {
    // 声明一个有返回值的回调
    callback hello(int, int) -> int;
    hello(aa, bb) => { aa + bb }
}
```

## 别名

可以以类似于双向绑定的方式声明回调别名：

```slint
export component Example inherits Rectangle {
    callback clicked <=> area.clicked;
    area := TouchArea {}
}
```