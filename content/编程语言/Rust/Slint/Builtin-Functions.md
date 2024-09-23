---
title: 内置函数
---
# 内置函数

## `animation-tick() -> duration`

这个函数返回一个单调递增的时间值，可用于动画。在绑定中调用此函数将不断重新评估绑定。可以这样使用：`x: 1000px + sin(animation-tick() / 1s * 360deg) * 100px;` 或 `y: 20px * mod(animation-tick(), 2s) / 2s`

```slint
export component Example inherits Window {
    preferred-width: 100px;
    preferred-height: 100px;

    Rectangle {
        y:0;
        background: red;
        height: 50px;
        width: parent.width * mod(animation-tick(), 2s) / 2s;
    }

    Rectangle {
        background: blue;
        height: 50px;
        y: 50px;
        width: parent.width * abs(sin(360deg * animation-tick() / 3s));
    }
}
```

## `debug(...)`

debug 函数可以接受一个或多个值作为参数，打印它们，并返回无值。
