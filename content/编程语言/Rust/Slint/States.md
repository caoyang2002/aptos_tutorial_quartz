---
title: 状态
---
# 状态

`states` 语句允许一次声明多个状态并设置多个元素的属性：

```slint
export component Example inherits Window {
    preferred-width: 100px;
    preferred-height: 100px;
    default-font-size: 24px;

    label := Text { }
    ta := TouchArea {
        clicked => {
            active = !active;
        }
    }
    property <bool> active: true;
    states [
        active when active && !ta.has-hover: {
            label.text: "Active";
            root.background: blue;
        }
        active-hover when active && ta.has-hover: {
            label.text: "Active\nHover";
            root.background: green;
        }
        inactive when !active: {
            label.text: "Inactive";
            root.background: gray;
        }
    ]
}
```

在此示例中，`active` 和 `active-hover` 状态根据布尔属性 `active` 的值以及 `TouchArea` 的 `has-hover` 定义。当用户将鼠标悬停在示例上时，背景将在蓝色和绿色之间切换，并相应调整文本标签。单击会切换 `active` 属性，从而进入 `inactive` 状态。

## 过渡

过渡将动画绑定到状态变化。

此示例定义了两个过渡。首先，使用 `out` 关键字在离开 `disabled` 状态时动画化所有属性，持续 800 毫秒。第二个过渡使用 `in` 关键字在过渡到 `down` 状态时动画化背景。

```slint
export component Example inherits Window {
    preferred-width: 100px;
    preferred-height: 100px;

    text := Text { text: "hello"; }
    in-out property<bool> pressed;
    in-out property<bool> is-enabled;

    states [
        disabled when !root.is-enabled : {
            background: gray; // 与 root.background: gray; 相同
            text.color: white;
            out {
                animate * { duration: 800ms; }
            }
        }
        down when pressed : {
            background: blue;
            in {
                animate background { duration: 300ms; }
            }
        }
    ]
}
```