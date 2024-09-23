---
title: 内置全局单例
---
# 内置全局单例

## `Palette`

使用 `Palette` 创建与所选风格（例如流畅、cupertino、material 或 qt）的颜色相匹配的自定义小部件。

### 属性

- **`background`**（*输出* *画笔*）：定义默认的背景画笔。如果没有更专门的背景画笔适用，可以使用此画笔。
- **`foreground`**（*输出* *画笔*）：定义用于在 `background` 画笔上显示的内容的前景画笔。
- **`alternate-background`**（*输出* *画笔*）：定义备用背景画笔，例如用于文本输入控件或像侧边栏这样的面板。
- **`alternate-foreground`**（*输出* *画笔*）：定义用于在 `alternate-background` 画笔上显示的内容的前景画笔。
- **`control-background`**（*输出* *画笔*）：定义控件的默认背景画笔，如按钮、组合框等。
- **`control-foreground`**（*输出* *画笔*）：定义用于在 `control-background` 画笔上显示的内容的前景画笔。
- **`accent-background`**（*输出* *画笔*）：定义用于突出显示控件（如主按钮）的背景画笔。
- **`accent-foreground`**（*输出* *画笔*）：定义用于在 `accent-background` 画笔上显示的内容的前景画笔。
- **`selection-background`**（*输出* *画笔*）：定义用于突出显示选择（如文本选择）的背景画笔。
- **`selection-foreground`**（*输出* *画笔*）：定义用于在 `selection-background` 画笔上显示的内容的前景画笔。
- **`border`**（*输出* *画笔*）：定义用于边框（如分隔符和控件边框）的画笔。
- **`color-scheme`**（*输入* *输出* *枚举 [`ColorScheme`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/enums#colorscheme)*）：  读取此属性以确定调色板使用的颜色方案。设置此属性以强制使用暗色或亮色颜色方案。除了 Qt 风格外，所有风格都支持设置暗色或亮色颜色方案。

### 示例

```slint
import { Palette, HorizontalBox } from "std-widgets.slint";

export component MyCustomWidget {
    in property <string> text <=> label.text;

    Rectangle {
        background: Palette.control-background;

        HorizontalBox {
            label := Text {
                color: Palette.control-foreground;
            }
        }
    }
}
```

## `TextInputInterface`

`TextInputInterface.text-input-focused` 属性可以用来判断 `TextInput` 元素是否拥有焦点。如果您正在实现自己的虚拟键盘，这个属性是一个指示器，用于判断是否应该显示或隐藏虚拟键盘。

### 属性

- **`text-input-focused`**（*布尔值*）：如果 `TextInput` 元素拥有焦点，则为 true；否则为 false。

### 示例

```slint
import { LineEdit } from "std-widgets.slint";

component VKB {
    Rectangle { background: yellow; }
}

export component Example inherits Window {
    width: 200px;
    height: 100px;
    VerticalLayout {
        LineEdit {}
        FocusScope {}
        if TextInputInterface.text-input-focused: VKB {}
    }
}
```