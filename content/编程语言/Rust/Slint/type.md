---
title: 类型
---
# 类型

Slint中的所有属性都有一个类型。Slint知道这些基本类型：

| 类型                 | 描述                                                         | 默认值        |
| -------------------- | ------------------------------------------------------------ | ------------- |
| `angle`              | 角度测量，对应于类似`90deg`、`1.2rad`、`0.25turn`的字面量 | 0deg          |
| `bool`               | 布尔值，可以是`true`或`false`。                             | false         |
| `brush`              | 一种特殊类型，可以从颜色或渐变规格初始化。有关更多信息，请参见[颜色和画刷部分](https://releases.slint.dev/1.7.2/docs/slint/src/language/syntax/types#colors-and-brushes)。 | transparent   |
| `color`              | 带有alpha通道的RGB颜色，每个通道8位精度。支持CSS颜色名称和十六进制颜色编码，如`#RRGGBBAA`或`#RGB`。 | transparent   |
| `duration`           | 动画持续时间的类型。使用后缀如`ms`（毫秒）或`s`（秒）表示精度。 | 0ms           |
| `easing`             | 属性动画允许指定缓动曲线。有关值的列表，请参见[动画](https://releases.slint.dev/1.7.2/docs/slint/src/language/animations/index.html)。 | linear        |
| `float`              | 有符号32位浮点数。带有`%`后缀的数字会自动除以100，例如`30%`与`0.30`相同。 | 0             |
| `image`              | 图像的引用，可以使用`@image-url("...")`构造进行初始化。 | 空图像       |
| `int`                | 有符号整数。                                               | 0             |
| `length`             | 用于`x`、`y`、`width`和`height`坐标的类型。对应于类似`1px`、`1pt`、`1in`、`1mm`或`1cm`的字面量。可以在可以访问设备像素比的上下文中进行长度之间的转换。 | 0px           |
| `percent`            | 有符号32位浮点数，解释为百分比。分配给此类型属性的字面数字必须带有`%`后缀。 | 0%            |
| `physical-length`    | 这是一个物理像素的量。可以通过将整数乘以`1px`从整数转换为长度单位。或者通过除以`1phx`将长度转换为浮点数。 | 0phx          |
| `relative-font-size` | 相对字体大小因子，与`Window.default-font-size`相乘并可以转换为`length`。 | 0rem          |
| `string`             | UTF-8编码、引用计数的字符串。                            | `""`          |

有关这些类型如何映射到不同编程语言的API，请参见语言特定的API参考。

## 字符串

用引号括起来的任何UTF-8编码字符序列都是`string`：`"foo"`。

可以在字符串中嵌入转义序列，以插入难以直接插入的字符：

| 转义              | 结果                              |
| --------------- | ------------------------------- |
| `\"`            | `"`                             |
| `\\`            | `\`                             |
| `\n`            | 新行                              |
| `\u{x}`         | 其中`x`是十六进制数字，扩展为该数字表示的unicode码点 |
| `\{expression}` | 表达式的评估结果                        |

其他任何跟在未转义的`\`后面的是一个错误。

```slint
export component Example inherits Text {
    text: "hello";
}
```

注意：`slint!`宏中不允许使用`\{...}`语法。

## 颜色和画刷

颜色字面量遵循CSS语法：

```slint
export component Example inherits Window {
    background: blue;
    property<color> c1: #ffaaff;
    property<brush> b2: Colors.red;
}
```

除了普通颜色，许多元素具有类型为`brush`的属性，而不是`color`。画刷是一种可以是颜色或渐变的类型。画刷用于填充元素或绘制轮廓。

CSS颜色名称仅在类型为`color`或`brush`的表达式中有效。否则，可以从`Colors`命名空间访问颜色。

### 属性

以下属性被暴露：

- **`red`**
- **`green`**
- **`blue`**
- **`alpha`**

这些属性的范围是0-255。

### 方法

所有颜色和画刷定义以下方法：

- **`brighter(factor: float) -> brush`**  
  返回一个新颜色，亮度由指定因子增加。通过将颜色转换为HSV颜色空间并将亮度（值）乘以（1 + 因子）来实现。

- **`darker(factor: float) -> brush`**  
  返回一个新颜色，亮度由指定因子降低。通过将颜色转换为HSV颜色空间并将亮度（值）除以（1 + 因子）来实现。

- **`mix(other: brush, factor: float) -> brush`**  
  返回此颜色和`other`的混合新颜色。指定因子被限制在`0.0`和`1.0`之间，然后应用于此颜色，而`1.0 - factor`则应用于`other`。

- **`transparentize(factor: float) -> brush`**  
  返回一个新颜色，透明度由`factor`降低。透明度通过将alpha通道乘以`(1 - factor)`获得。

- **`with-alpha(alpha: float) -> brush`**  
  返回一个新颜色，alpha值设置为`alpha`（介于0和1之间）。

- **`to-hsv()->{hue: float, saturation: float, value: float, alpha: float}`**  
  将此颜色转换为HSV颜色空间，并返回包含`hue`、`saturation`、`value`和`alpha`字段的结构。

### 线性渐变

线性渐变描述平滑的彩色表面。它们使用一个角度和一系列颜色停止来指定。颜色将在停止之间线性插值，沿着旋转指定角度的想象线。这称为线性渐变，并使用`@linear-gradient`宏指定，具有以下签名：

**`@linear-gradient(angle, color percentage, color percentage, ...)`**

宏的第一个参数是一个角度。渐变线的起点将根据指定值旋转。

紧随其后的是一个或多个颜色停止，以空格分隔的`color`值和`percentage`描述。颜色指定沿渐变轴达到指定百分比时线性颜色插值应达到的值。

以下示例显示一个矩形，使用从浅蓝色开始、中心插值到非常浅的色调、最后以橙色结束的线性渐变填充：

```bash
export component Example inherits Window {
    preferred-width: 100px;
    preferred-height: 100px;

    Rectangle {
        background: @linear-gradient(90deg, #3f87a6 0%, #ebf8e1 50%, #f69d3c 100%);
    }
}
```

### 径向渐变

径向渐变类似于线性渐变，但颜色沿圆形插值。要描述径向渐变，请使用`@radial-gradient`宏，具有以下签名：

**`@radial-gradient(circle, color percentage, color percentage, ...)`**

宏的第一个参数始终为`circle`，因为仅支持圆形渐变。语法其他部分基于CSS `radial-gradient`函数。

示例：

```bash
export component Example inherits Window {
    preferred-width: 100px;
    preferred-height: 100px;
    Rectangle {
        background: @radial-gradient(circle, #f00 0%, #0f0 50%, #00f 100%);
    }
}
```

## 图像

`image`类型是对图像的引用。它使用`@image-url("...")`构造定义。`@image-url`函数内的地址必须在编译时已知。

Slint在以下位置查找图像：

1. 当前`.slint`文件的绝对路径或相对路径。
2. 编译器用于查找`.slint`文件的包含路径。

使用图像的`width`和`height`属性访问图像的尺寸。

```typescript
export component Example inherits Window {
    preferred-width: 150px;
    preferred-height: 50px;

    in property <image> some_image: @image-url("https://slint.dev/logo/slint-logo-full-light.svg");

    Text {
        text: "图像大小为 " + some_image.width + "x" + some_image.height;
    }
}
```

还可以通过添加`nine-slice(...)`参数加载支持[9切片缩放](https://en.wikipedia.org/wiki/9-slice_scaling)的图像（也称为九个补丁或边框图像）。该参数可以有一个、两个或四个数字，指定边缘的大小。这些数字可以是`top right bottom left`，也可以是`vertical horizontal`，或者一个数字表示所有边。

## 结构体

使用`struct`关键字定义命名结构：

```slint
export struct Player {
    name: string,
    score: int,
}

export component Example {
    in-out property<Player> player: { name: "Foo", score: 100 };
}
```

结构体的默认值初始化时，所有字段都设置为其默认值。

### 匿名结构体

使用`{ identifier1: type1, identifier2: type2 }`语法声明匿名结构体，并使用`{ identifier1: expression1, identifier2: expression2 }`进行初始化。

最后一个表达式或类型后面可以有一个逗号。

```slint
export component Example {
    in-out property<{name: string, score: int}> player: { name: "Foo", score: 100 };
    in-out property<{a: int, }> foo: { a: 3 };
}
```

## 枚举

使用`enum`关键字定义枚举：

```slint
export enum CardSuit { clubs, diamonds, hearts, spade }

export component Example {
    in-out property<CardSuit> card: spade;
    out property<bool> is-clubs: card == CardSuit.clubs;
}
```

枚举值可以通过使用枚举名称和值名称（用点分隔）引用（例如：`CardSuit.spade`）。

在该枚举类型的绑定中，枚举名称可以省略，或者如果回调的返回值是该枚举类型。

每个枚举类型的默认值始终是第一个值。

## 数组和模型

数组通过在元素类型周围用`[`和`]`方括号包装来声明。

数组字面量以及持有数组的属性在`for`表达式中作为模型使用。

```slint
export component Example {
    in-out property<[int]> list-of-int: [1,2,3];
    in-out property<[{a: int, b: string}]> list-of-structs: [{ a: 1, b: "hello" }, {a: 2, b: "world"}];
}
```

数组定义以下操作：

- **`array.length`**：可以通过内置的`.length`属性查询数组的长度和模型。
- **`array[index]`**：索引操作符检索数组的单个元素。

越界访问数组将返回默认构造值。

```slint
export component Example {
    in-out property<[int]> list-of-int: [1,2,3];

    out property <int> list-len: list-of-int.length;
    out property <int> first-int: list-of-int[0];
}
```

## 转换

Slint支持不同类型之间的转换。显式转换对于使UI描述更健壮是必需的，但在某些类型之间允许隐式转换。

以下转换是可能的：

- `int`可以隐式转换为`float`，反之亦然。从`float`转换为`int`时，值会被截断。
- `int`和`float`可以隐式转换为`string`。
- `physical-length`、`relative-font-size`和`length`仅在已知像素比的上下文中可以隐式相互转换。
- 单位类型（`length`、`physical-length`、`duration`等）不能转换为数字（`float`或`int`），但它们可以通过自身相除得到数字。同样，数字可以与这些单位相乘。换句话说，可以通过乘以`1px`或除以`1px`来进行这样的转换。
- 文本`0`可以转换为任何具有相关单位的类型。
- 结构体类型如果具有相同的属性名称并且其类型可以转换，则可以与另一个结构体类型转换。源结构体可以缺少属性或有额外属性，但不能同时存在。
- 数组通常不相互转换。如果数组字面量的元素类型可以转换，则可以进行转换。
- 字符串可以通过使用`to-float`函数转换为浮点数。如果字符串不是有效数字，该函数返回0。可以使用`is-float()`检查字符串是否包含有效数字。

```slint
export component Example {
    // OK: int 转换为 string
    property<{a: string, b: int}> prop1: {a: 12, b: 12 };
    // OK: 即使 a 缺失，默认值将为("")
    property<{a: string, b: int}> prop2: { b: 12 };
    // OK: 即使 c 多余，将被丢弃
    property<{a: string, b: int}> prop3: { a: "x", b: 12, c: 42 };
    // ERROR: b 缺失，c 多余，这不编译，因为可能是拼写错误。
    // property<{a: string, b: int}> prop4: { a: "x", c: 42 };

    property<string> xxx: "42.1";
    property<float> xxx1: xxx.to-float(); // 42.1
    property<bool> xxx2: xxx.is-float(); // true
    property<int> xxx3: 45.8; // 45
}
```