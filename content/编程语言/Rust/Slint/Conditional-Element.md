---
title: 条件元素
---
# 条件元素

`if` 结构仅在给定条件为真时实例化一个元素。语法为 `if condition : id := Element { ... }`

```slint
export component Example inherits Window {
    preferred-width: 50px;
    preferred-height: 50px;
    if area.pressed : foo := Rectangle { background: blue; }
    if !area.pressed : Rectangle { background: red; }
    area := TouchArea {}
}
```