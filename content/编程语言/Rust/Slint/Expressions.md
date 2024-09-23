---
title: 表达式
---
# 表达式

表达式是声明用户界面中关系和连接的强大方式。它们通常用于将基本算术与对其他元素属性的访问结合起来。当这些属性发生变化时，表达式会自动重新计算，并将新值分配给与该表达式相关联的属性：

```slint
export component Example {
    // 声明一个 int 类型的属性
    in-out property<int> my-property;

    // 访问该属性
    width: root.my-property * 20px;

}
```

当 `my-property` 变化时，宽度也会自动变化。

表达式中的数字算术与大多数编程语言相似，使用运算符 `*`、`+`、`-`、`/`：

```slint
export component Example {
    in-out property <int> p: 1 * 2 + 3 * 4; // 同 (1 * 2) + (3 * 4)
}
```

用 `+` 连接字符串。

运算符 `&&` 和 `||` 表示布尔值之间的逻辑 *与* 和 *或*。运算符 `==`、`!=`、`>`、`<`、`>=` 和 `<=` 比较同类型的值。

通过使用元素名称，后跟 `.` 和属性名称来访问元素的属性：

```slint
export component Example {
    foo := Rectangle {
        x: 42px;
    }
    x: foo.x;
}
```

也支持三元运算符 `... ? ... : ...`，类似于 C 或 JavaScript：

```slint
export component Example inherits Window {
    preferred-width: 100px;
    preferred-height: 100px;

    Rectangle {
        touch := TouchArea {}
        background: touch.pressed ? #111 : #eee;
        border-width: 5px;
        border-color: !touch.enabled ? #888
            : touch.pressed ? #aaa
            : #555;
    }
}
```