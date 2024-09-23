---
title: 内置回调
---
# 内置回调

## `init()`

每个元素隐式声明一个 `init` 回调。你可以为其分配一个代码块，该代码块将在元素实例化时被调用，并在所有属性使用其最终绑定值初始化后执行。调用顺序是从内到外。以下示例将依次打印“first”、“second”和“third”：

```slint
component MyButton inherits Rectangle {
    in-out property <string> text: "Initial";
    init => {
        // 如果在这里查询 `text`，它的值将是 "Hello"。
        debug("first");
    }
}

component MyCheckBox inherits Rectangle {
    init => { debug("second"); }
}

export component MyWindow inherits Window {
    MyButton {
        text: "Hello";
        init => { debug("third"); }
    }
    MyCheckBox {
    }
}
```

请不要使用此回调来初始化属性，因为这违反了声明式原则。

尽管所有组件都有 `init` 回调，但不能从应用代码中设置它，即生成的代码中没有 `on_init` 函数。这是因为回调在组件创建期间调用，此时你还不能调用 `on_init` 来实际设置它。

虽然 `init` 回调可以调用其他回调，例如在 `global` 部分定义的回调，并且你可以在后端绑定这些，但对于静态创建的组件（包括窗口本身）这并不适用，因为你需要一个实例来设置全局绑定。但对于动态创建的组件（例如在 `if` 后面的组件）则可以这样使用：

```slint
export global SystemService {
    // 这个回调可以在本地代码中使用 Slint API 实现
    callback ensure_service_running();
}

component MySystemButton inherits Rectangle {
    init => {
        SystemService.ensure_service_running();
    }
    // ...
}

export component AppWindow inherits Window {
    in property <bool> show-button: false;

    // MySystemButton 最初未初始化，只有在 show-button 设置为 true 时才会初始化。
    // 此时，它的 init 回调将调用 ensure_service_running()
    if show-button : MySystemButton {}
}
```