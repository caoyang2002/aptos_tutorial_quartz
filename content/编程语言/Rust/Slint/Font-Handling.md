---
title: 字体处理
---
# 字体处理

元素如 `Text` 和 `TextInput` 可以渲染文本，并通过不同的属性自定义文本的外观。以 `font-` 为前缀的属性，如 `font-family`、`font-size` 和 `font-weight`，会影响用于屏幕渲染的字体选择。如果未指定这些属性，则会应用周围 `Window` 元素中的 `default-font-` 值，例如 `default-font-family`。

所选的渲染字体会自动从运行应用程序的系统中获取。您也可以在设计中包含自定义字体。自定义字体必须是 TrueType 字体（`.ttf`）、TrueType 字体集合（`.ttc`）或 OpenType 字体（`.otf`）。您可以在 .slint 文件中使用 `import` 语句选择自定义字体，例如：`import "./my_custom_font.ttf"`。这指示 Slint 编译器包含该字体，并使字体家族在全局范围内可用于 `font-family` 属性。

例如：

```slint
import "./NotoSans-Regular.ttf";

export component Example inherits Window {
    default-font-family: "Noto Sans";

    Text {
        text: "Hello World";
    }
}
```