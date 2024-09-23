---
title: 焦点处理
---
# 焦点处理

某些元素，例如 `TextInput`，可以接收来自鼠标/手指的输入以及来自（虚拟）键盘的按键事件。为了让一个项目能够接收这些事件，它必须处于焦点状态。焦点状态可以通过 `has-focus`（输出）属性来查看。

您可以通过调用 `focus()` 手动激活元素的焦点：

```slint
import { Button } from "std-widgets.slint";

export component App inherits Window {
    VerticalLayout {
        alignment: start;
        Button {
            text: "press me";
            clicked => { input.focus(); }
        }
        input := TextInput {
            text: "I am a text input field";
        }
    }
}
```

同样，您可以通过调用 `clear-focus()` 手动清除当前聚焦元素的焦点：

```slint
import { Button } from "std-widgets.slint";

export component App inherits Window {
    VerticalLayout {
        alignment: start;
        Button {
            text: "press me";
            clicked => { input.clear-focus(); }
        }
        input := TextInput {
            text: "I am a text input field";
        }
    }
}
```

在清除焦点后，键盘输入将被丢弃，直到另一个元素被明确聚焦。例如，可以通过调用 `focus()`，在用户单击元素时使其获取焦点，或在按下 Tab 键时找到第一个可聚焦的元素。

如果您将 `TextInput` 封装在一个组件中，可以使用 `forward-focus` 属性将焦点激活转发到应接收焦点的元素：

```slint
import { Button } from "std-widgets.slint";

component LabeledInput inherits GridLayout {
    forward-focus: input;
    Row {
        Text {
            text: "Input Label:";
        }
        input := TextInput {}
    }
}

export component App inherits Window {
    GridLayout {
        Button {
            text: "press me";
            clicked => { label.focus(); }
        }
        label := LabeledInput {
        }
    }
}
```

如果在 `Window` 上使用 `forward-focus` 属性，则指定的元素将在窗口第一次获得焦点时接收焦点，成为初始焦点元素。