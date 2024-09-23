---
title: 内置结构体
---
# 内置结构体

## `KeyEvent`

这个结构体被生成并传递给 `FocusScope` 元素的按键按下和释放回调。

### 字段

- **`text`**（*字符串*）：按下的键的 Unicode 表示。
- **`modifiers`**（*KeyboardModifiers*）：按键事件发生时激活的键盘修饰键。
- **`repeat`**（*布尔值*）：对于重复的按键事件，即键被按住时，此字段设置为 true。对于按键释放事件，它总是 false。

## `KeyboardModifiers`

`KeyboardModifiers` 结构体提供了布尔值来指示键盘上可能的修饰键，如 Shift、Control 等。它作为 `KeyEvent` 的 `modifiers` 字段的一部分提供。

在苹果平台上的键盘快捷键通常使用 Command 键（⌘），例如 Command+C 用于“复制”。在其他平台上，相同的快捷键通常使用 Control+C 来表示。为了便于开发跨平台应用程序，在 macOS 上，Slint 将 Command 键映射到控制修饰键，Control 键映射到 Meta 修饰键。

在 Windows 上，Windows 键被映射到 Meta 修饰键。

### 字段

- **`alt`**（*布尔值*）：指示键盘上的 Alt 键。
- **`control`**（*布尔值*）：指示键盘上的 Control 键，除了在 macOS 上，它是 Command 键（⌘）。
- **`shift`**（*布尔值*）：指示键盘上的 Shift 键。
- **`meta`**（*布尔值*）：在 macOS 上指示 Control 键，在 Windows 上指示 Windows 键。

## `Point`

这个结构体表示具有 x 和 y 坐标的点。

### 字段

- **`x`**（*长度*）
- **`y`**（*长度*）

## `PointerEvent`

代表窗口系统发送的指针事件。这个结构体被传递给 `TouchArea` 元素的 `pointer-event` 回调。

### 字段

- **`button`**（*PointerEventButton*）：被按下或释放的按钮
- **`kind`**（*PointerEventKind*）：事件的类型
- **`modifiers`**（*KeyboardModifiers*）：事件期间按下的键盘修饰键

## `PointerScrollEvent`

代表窗口系统发送的指针滚动（或滚轮）事件。这个结构体被传递给 `TouchArea` 元素的 `scroll-event` 回调。

### 字段

- **`delta_x`**（*长度*）：水平方向上的像素数量
- **`delta_y`**（*长度*）：垂直方向上的像素数量
- **`modifiers`**（*KeyboardModifiers*）：事件期间按下的键盘修饰键

## `StandardListViewItem`

代表 `StandardListView` 和 `StandardTableView` 中的项。

### 字段

- **`text`**（*字符串*）：项的文本内容

## `TableColumn`

用于定义 `TableView` 的列和列标题。

### 字段

- **`title`**（*字符串*）：列标题的标题
- **`min_width`**（*长度*）：列的最小宽度（逻辑长度）
- **`horizontal_stretch`**（*浮点数*）：列的水平拉伸
- **`sort_order`**（*SortOrder*）：对列进行排序
- **`width`**（*长度*）：列的实际宽度（逻辑长度）
