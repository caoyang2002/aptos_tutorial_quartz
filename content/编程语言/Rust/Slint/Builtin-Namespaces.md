---
title: 内置命名空间
---
# 内置命名空间

以下命名空间提供了访问常用常量（如特殊键或命名颜色）的途径。

## `Colors`

使用 `Colors` 命名空间通过名称选择颜色。例如，您可以使用 `Colors.aquamarine` 或 `Colors.bisque`。颜色名称的完整列表非常长。您可以在 [CSS 规范](https://www.w3.org/TR/css-color-3/#svg-color) 中找到完整列表。

这些函数既可以在全局作用域中使用，也可以在 `Colors` 命名空间中使用。

- **`rgb(int, int, int) -> color`**, **`rgba(int, int, int, float) -> color`**

返回 CSS 中的颜色。像在 CSS 中一样，这两个函数实际上是可以接收三个或四个参数的别名。

前三个参数可以是 0 到 255 之间的数字，或者带有 `%` 单位的百分比。如果提供了第四个值，则为 0 到 1 之间的 alpha 值。

与 CSS 不同，逗号是强制性的。

- **`hsv(float, float, float) -> color`**, **`hsv(float, float, float, float) -> color`**

从 HSV 颜色空间计算返回颜色。色相在 0 到 360 之间。饱和度、值和可选的 alpha 参数期望在 0 和 1 范围内。

## `Key`

使用 `Key` 命名空间中的常量来处理没有可打印字符的键的按下事件。检查 [`KeyEvent`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/structs#keyevent) 的 `text` 属性与下面的常量。

- **`Backspace`**
- **`Tab`**
- **`Return`**
- **`Escape`**
- **`Backtab`**
- **`Delete`**
- **`Shift`**
- **`Control`**
- **`Alt`**
- **`AltGr`**
- **`CapsLock`**
- **`ShiftR`**
- **`ControlR`**
- **`Meta`**
- **`MetaR`**
- **`Space`**
- **`UpArrow`**
- **`DownArrow`**
- **`LeftArrow`**
- **`RightArrow`**
- **`F1`**
- **`F2`**
- **`F3`**
- **`F4`**
- **`F5`**
- **`F6`**
- **`F7`**
- **`F8`**
- **`F9`**
- **`F10`**
- **`F11`**
- **`F12`**
- **`F13`**
- **`F14`**
- **`F15`**
- **`F16`**
- **`F17`**
- **`F18`**
- **`F19`**
- **`F20`**
- **`F21`**
- **`F22`**
- **`F23`**
- **`F24`**
- **`Insert`**
- **`Home`**
- **`End`**
- **`PageUp`**
- **`PageDown`**
- **`ScrollLock`**
- **`Pause`**
- **`SysReq`**
- **`Stop`**
- **`Menu`**

## `Math`

这些函数既可以在全局作用域中使用，也可以在 `Math` 命名空间中使用。

### `abs(T) -> T`

返回绝对值，其中 T 是数字类型。

### `acos(float) -> angle`, `asin(float) -> angle`, `atan(float) -> angle`, `cos(angle) -> float`, `sin(angle) -> float`, `tan(angle) -> float`

三角函数。注意应该用 `deg` 或 `rad` 单位输入（例如 `cos(90deg)` 或 `sin(slider.value * 1deg)`）。

### `ceil(float) -> int` 和 `floor(float) -> int`

返回上限或下限

### `clamp(T, T, T) -> T`

接受一个 `value`，`minimum` 和 `maximum`，并在 `value > maximum` 时返回 `maximum`，在 `value < minimum` 时返回 `minimum`，在其他所有情况下返回 `value`。

### `log(float, float) -> float`

返回第一个值以第二个值作为底数的对数值

### `max(T, T) -> T` 和 `min(T, T) -> T`

返回具有最小（或最大）值的参数。所有参数必须是相同的数字类型

### `mod(T, T) -> T`

执行模运算，其中 T 是某些数字类型。

### `round(float) -> int`

返回四舍五入到最近整数的值

### `sqrt(float) -> float`

平方根

### `pow(float, float) -> float`

返回第一个值提升到第二个值的结果
