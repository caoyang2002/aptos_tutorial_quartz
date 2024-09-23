# 描述

Slint 运行在许多桌面和嵌入式平台以及微控制器上。

下面提供的平台描述涵盖了已经测试过的部署环境。对于开发环境，我们建议使用最新的桌面操作系统和编译器版本。

如果你需要支持特定或较旧的版本，请与 SixtyFPS GmbH 联系。

## 桌面平台
通常，Slint 运行在 Windows、macOS 和流行的 Linux 发行版上。以下表格覆盖了我们特别测试的版本。总体目标是在 Slint 版本发布时支持其供应商支持的操作系统。

Windows

| 操作系统 | 架构  |
|----------|-------|
| Windows 10 | x86-64 |
| Windows 11 | x86-64 |

macOS

| 操作系统 | 架构      |
|----------|-----------|
| macOS 12 Monterey | x86-64, aarch64 |
| macOS 13 Ventura  | x86-64, aarch64 |
| macOS 14 Sonoma  | x86-64, aarch64 |

Linux
Linux 桌面发行版呈现出多样化的景象，Slint 应该能够在任何使用 Wayland 或 X-Windows、glibc 和 d-bus 的发行版上运行。如果一个 Linux 发行版提供了长期支持（LTS），Slint 应该能够在 Slint 版本发布时运行在最新的 LTS 或更新版本上。

## 嵌入式平台
Slint 运行在多种嵌入式平台上。一般来说，Slint 需要一个带有工作正常的 OpenGL ES 2.0（或更新）或 Vulkan 驱动程序的现代 Linux 用户空间。我们在以下系统上成功运行了 Slint：

基于 Yocto 的发行版。对于 C++ 应用程序，请查看 meta-slint 以获取配方。Rust 应用程序可以与 Yocto 的 Rust 支持直接开箱即用。

基于 BuildRoot 的发行版。

TorizonCore。

## 微控制器
Slint 的平台抽象允许集成到任何基于 Rust 或 C++ 的微控制器开发环境中。开发者需要实现功能以提供输入事件（如触摸或键盘），以及将 Slint 渲染的像素显示到帧或行缓冲区中。

# 语言

## 1 简介

### 1.1 Slint语言

Slint是一种易于学习和使用的语言，用于描述用户界面。Slint语言对于人类和机器都是可读的——如此，我们一方面拥有了出色的工具，同时通过阅读显示用户界面的代码，使得设计师和开发人员能够确切地知道会发生什么。

Slint 语言要么在运行时被解释，要么被编译为本机代码并与提供业务逻辑的编程语言的代码一起内置到您的应用程序中。Slint 编译器可以优化用户界面以及在编译时使用的任何资源，因此用 Slint 编写的用户界面占用的资源很少。

Slint 语言通过使用用户为项目定义的接口，将用户界面与业务逻辑分开。这使得以设计为重点的团队成员和专注于项目编程方面的团队成员之间的合作不再有任何的障碍。

Slint 设计标记语言使用 Slint 框架描述可扩展的图形用户界面：

- 以文本方式在窗口中放置和管理可视的元素树；
- 通过属性配置元素的外观。例如，文本元素具有文本属性，而矩形元素具有背景颜色属性；
- 属性值绑定表达式，以自动计算依赖于其他属性的值；
- 命名状态和条件组合在一起绑定表达式；
- 在属性和状态上声明动画，使用户界面有动感；
- 自定义可重用组件，并在.slint模块文件中共享；
- 定义数据结构和模型，并从编程语言访问它们；
- 使用内置元素和预构建小部件生成高度定制的用户界面。

Slint 语言只描述用户界面，而不是一种编程语言。业务逻辑需要使用 Slint API 用不同的编程语言编写。

### 1.2 入门

要使用Slint，您需要将slint文件嵌入到用受支持的编程语言（如C++、[Rust](https://so.csdn.net/so/search?q=Rust&spm=1001.2101.3001.7020)或JavaScript）编写的项目中。开始使用Slint有三种不同的途径：

1. [SlintPad](https://slint-ui.com/releases/1.7.2/editor/) - 使用它来感受 Slint 设计标记语言。这是一个基于网络浏览器的工具，您可以尝试 Slint。
2. 作为 UI 设计师，在本地使用 Slint 文件，我们建议使用以下软件工具组合：
   - Visual Studio Code
   - Visual Studio Code 安装 Slint 插件
3. 作为软件开发人员，将 Slint 集成到新的或现有的代码库中，选择以下语言之一开始：
   - C++
   - Rust
   - JavaScript

## 2 概念

### 2.1 `.slint` 文件

用户界面用 Slint 语言编写，并保存在扩展名为 `.slint`的文件中。每个 `.slint` 文件定义了一个或多个组件，这些组件构成了一个元素树。组件是 Slint 的基础，每个组件在其声明后可以用作另一个组件中的元素。您可以使用组件来构建自己的可重用 UI 控件集。

以下是组件和元素的示例：

```slint
component MyButton inherits Text {
    color: black;
    // ...
}

export component MyApp inherits Window {
    preferred-width: 200px;
    preferred-height: 100px;
    Rectangle {
        width: 200px;
        height: 100px;
        background: green;
    }
    MyButton {
        x:0;y:0;
        text: "hello";
    }
    MyButton {
        y:0;
        x: 50px;
        text: "world";
    }
}
```

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/298b0cacb62f51ddedd0aeaa062d455b.png#pic_center)

MyButton 和 MyApp 都是组件。Window 和 Rectangle 是 MyApp 使用的内置元素。MyApp 还重新使用 MyButton 组件作为两个单独的元素。

元素具有属性，您可以为这些属性分配值。在这里，我们为第一个 MyButton 的 text 属性分配一个字符串常量 “hello” 。您还可以将属性设置为包含其他属性的表达式，当表达式依赖的任何属性发生变化时，Slint将重新计算表达式，这使得用户界面具有反应性。

您可以使用 `:=` 语法为元素命名，名称必须是有效的标识符。

```slint
component MyButton inherits Text {
    // ...
}

export component MyApp inherits Window {
    preferred-width: 200px;
    preferred-height: 100px;

    hello := MyButton {
        x:0;y:0;
        text: "hello";
    }
    world := MyButton {
        y:0;
        text: "world";
        x: 50px;
    }
}
```

一些元素也可以以预定义的名称访问：

- `root` 指组件的最外层元素
- `self` 指当前元素
- `parent` 指当前元素的父元素

这些名称是保留的，您无法重新定义它们。

### 2.2 元素的定位和布局

所有可视元素都显示在一个窗口中。元素的 `x` 和 `y` 属性表示相对于其父元素的元素坐标，`width` 和 `height` 属性表示可视元素的大小。您可以通过两种方式放置元素来创建整个图形用户界面：

- 显式设置：设置 `x`、`y`、`width` 和 `height` 属性
- 自动布局：使用布局元素（`VerticalLayout` / `HorizontalLayout` / `GridLayout`）

显式设置适合元素很少的静态场景，自动布局适用于复杂的用户界面，并有助于创建可扩展的用户界面。布局元素表达了元素之间的几何关系。

#### 2.2.1 显式设置

以下示例将两个矩形放入一个窗口中，一个是蓝色的，另一个是绿色的，绿色矩形是蓝色的子元素。

```slint
// Explicit positioning
export component Example inherits Window {
    width: 200px;
    height: 200px;
    Rectangle {
        x: 100px;
        y: 70px;
        width: parent.width - self.x;
        height: parent.height - self.y;
        background: blue;
        Rectangle {
            x: 10px;
            y: 5px;
            width: 50px;
            height: 30px;
            background: green;
        }
    }
}
```

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/4fec901fa233258478ca917ee9c77889.png#pic_center)

两个矩形的位置和内部绿色矩形的大小都是固定的。蓝色矩形的大小是由 `width` 和 `height` 属性绑定的表达式自动计算的，每当窗口的 width 和 height 发生变化时，它就会更新，结果是蓝色矩形的左下角总是与窗口的左下角对齐。

当为任何几何属性指定显式值时，Slint 要求您将一个单位附加到数字上。您可以在两个不同的单位之间进行选择：

- 逻辑像素，使用 `px` 单位后缀（推荐）
- 物理像素，使用 `phx` 单位后缀

逻辑像素根据系统配置的设备像素比自动缩放。例如，在现代高 DPI 显示器上，设备像素比可以是 2，因此每个逻辑像素占用 2 个物理像素。在较旧的屏幕上，用户界面在没有任何适应的情况下进行缩放。

此外，`width` 和 `height` 属性也可以指定为百分比单位，这适用于相对于父元素。例如，`width:50%` 表示父 width 的一半。

`x` 和 `y` 属性的默认值使得元素在其父属性中居中，width 和 height 的默认值取决于元素的类型。一些元素根据其内容自动调整大小，如 `Image`、`Text` 和大多数小部件。以下元素没有内容，当它们没有子元素时，默认填充其父元素：

- `Rectangle`
- `TouchArea`
- `FocusScope`
- `Flickable`

	布局元素也默认填充父级，无论其首选大小如何，其他元素默认使用其首选大小。元素的首选大小可以用 `preferred-width` 和 `preferred-height` 属性来指定。若未显式设置，则首选大小取决于子元素，其值为具有较大首选大小的子元素的首选大小，且该子元素的 `x` 和 `y` 属性未设置。

特殊情况是将首选大小设置为 `100%` 父级大小。例如，默认情况下，下面的组件将使用父组件的大小：

```
component MyComponent {
    preferred-width: 100%;
    preferred-height: 100%;
    // ...
}
```

#### 2.2.2 自动布局

Slint 带有不同的布局元素，可以自动计算其子元素的位置和大小：

- `VerticalLayout` / `HorizontalLayout`：子项沿着垂直或水平轴放置。
- `GridLayout`：子项被放置在由列和行组成的网格中。

您还可以嵌套布局来创建复杂的用户界面。

您可以使用不同的约束来调整自动放置，以适应用户界面的设计。每个元素都有最小尺寸、最大尺寸和首选尺寸。使用以下属性显式设置这些：

- `min-width`
- `min-height`
- `max-width`
- `max-height`
- `preferred-width`
- `preferred-height`

任何具有指定 `width` 和 `height` 的元素在布局中都有固定大小。当布局中有额外的空间时，元素可以沿着布局轴延伸。您可以使用以下属性控制元素及其兄弟姐妹之间的拉伸因子：

- `horizontal-stretch`
- `vertical-stretch`

值为 `0` 意味着该元素根本不会拉伸。如果所有元素的拉伸系数都为 `0`，则它们都均匀拉伸。这些约束属性的默认值可能取决于元素的内容。如果未设置元素的 `x` 或 `y`，这些约束也会自动应用于父元素。

**布局元素的常见属性**

所有布局元素都具有以下共同属性：

- `spacing`：这控制了孩子之间的间距。
- `padding`：这指定了布局中的填充，元素和布局边界之间的空间。

对于更细粒度的控制，[padding属性](https://so.csdn.net/so/search?q=padding属性&spm=1001.2101.3001.7020)可以拆分为布局每边的属性：

- `padding-left`
- `padding-right`
- `padding-top`
- `padding-bottom`

**`VerticalLayout` 和 `HorizontalLayout`**

`VerticalLayout` 和 `HorizontalLayout` 元素将其子元素放在一列或一行中。默认情况下，它们会拉伸或缩小以占用整个空间。您可以根据需要调整元素的对齐方式。

以下示例将蓝色和黄色矩形放在一排中，并均匀地拉伸在 `width` 的 `200` 个逻辑像素上：

```slint
// Stretch by default
export component Example inherits Window {
    width: 200px;
    height: 200px;
    HorizontalLayout {
        Rectangle { background: blue; min-width: 20px; }
        Rectangle { background: yellow; min-width: 30px; }
    }
}
```

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/a0d25381dd1808d619804c110e31ece9.png#pic_center)

另一方面，下面的示例规定，矩形应与布局的开头（视觉左侧）对齐。这导致没有拉伸，同时矩形保留了其指定的最小宽度：

```slint
// Unless an alignment is specified
export component Example inherits Window {
    width: 200px;
    height: 200px;
    HorizontalLayout {
        alignment: start;
        Rectangle { background: blue; min-width: 20px; }
        Rectangle { background: yellow; min-width: 30px; }
    }
}
```

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/ef6fe4cc02ace9cf3f972020b9f079aa.png#pic_center)

下面的示例为更复杂的场景嵌套了两个布局：

```slint
export component Example inherits Window {
    width: 200px;
    height: 200px;
    HorizontalLayout {
        // Side panel
        Rectangle { background: green; width: 10px; }

        VerticalLayout {
            padding: 0px;
            //toolbar
            Rectangle { background: blue; height: 7px; }

            Rectangle {
                border-color: red; border-width: 2px;
                HorizontalLayout {
                    Rectangle { border-color: blue; border-width: 2px; }
                    Rectangle { border-color: green; border-width: 2px; }
                }
            }
            Rectangle {
                border-color: orange; border-width: 2px;
                HorizontalLayout {
                    Rectangle { border-color: black; border-width: 2px; }
                    Rectangle { border-color: pink; border-width: 2px; }
                }
            }
        }
    }
}
```

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/a687e764180bc002dcd8de9b8f516c1a.png#pic_center)

**对齐**

如果指定了 `width` 和 `height` 属性，则元素的大小由其 `width` 和 `height` 决定，否则取决于 `min-width` 和 `min-heigh` 属性，或由内部布局的规则决定其大小。

元素根据对齐规则排列。只有当布局的 `alignment` 属性为 `LayoutAlignment.stretch`（默认值）时，元素的大小才大于最小尺寸。

这个例子展示了不同的对齐可能性。

```slint
export component Example inherits Window {
    width: 300px;
    height: 200px;
    VerticalLayout {
        HorizontalLayout {
            alignment: stretch;
            Text { text: "stretch (default)"; }
            Rectangle { background: blue; min-width: 20px; }
            Rectangle { background: yellow; min-width: 30px; }
        }
        HorizontalLayout {
            alignment: start;
            Text { text: "start"; }
            Rectangle { background: blue; min-width: 20px; }
            Rectangle { background: yellow; min-width: 30px; }
        }
        HorizontalLayout {
            alignment: end;
            Text { text: "end"; }
            Rectangle { background: blue; min-width: 20px; }
            Rectangle { background: yellow; min-width: 30px; }
        }
        HorizontalLayout {
            alignment: start;
            Text { text: "start"; }
            Rectangle { background: blue; min-width: 20px; }
            Rectangle { background: yellow; min-width: 30px; }
        }
        HorizontalLayout {
            alignment: center;
            Text { text: "center"; }
            Rectangle { background: blue; min-width: 20px; }
            Rectangle { background: yellow; min-width: 30px; }
        }
        HorizontalLayout {
            alignment: space-between;
            Text { text: "space-between"; }
            Rectangle { background: blue; min-width: 20px; }
            Rectangle { background: yellow; min-width: 30px; }
        }
        HorizontalLayout {
            alignment: space-around;
            Text { text: "space-around"; }
            Rectangle { background: blue; min-width: 20px; }
            Rectangle { background: yellow; min-width: 30px; }
        }
    }
}
```

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/35000efaf9c2368cba5c34318381694d.png#pic_center)

**拉伸算法**

当对齐设置为拉伸（默认值）时，元素的大小为最小尺寸，然后额外的空间在元素之间共享，与它们的拉伸因子集成正比，具有 `horizontal-stretch` 和 `vertical-stretch` 属性。拉伸尺寸不会超过最大尺寸。拉伸因子是一个浮点数。默认内容大小的元素通常默认为 `0`，而默认为父母大小的元素默认为 `1`。拉伸因子为 `0` 的元素将保持其最小尺寸，除非所有其他元素的拉伸因子也为 `0` 或达到其最大尺寸。

示例：

```slint
export component Example inherits Window {
    width: 300px;
    height: 200px;
    VerticalLayout {
        // Same stretch factor (1 by default): the size is divided equally
        HorizontalLayout {
            Rectangle { background: blue; }
            Rectangle { background: yellow;}
            Rectangle { background: green;}
        }
        // Elements with a bigger min-width are given a bigger size before they expand
        HorizontalLayout {
            Rectangle { background: cyan; min-width: 100px;}
            Rectangle { background: magenta; min-width: 50px;}
            Rectangle { background: gold;}
        }
        // Stretch factor twice as big:  grows twice as much
        HorizontalLayout {
            Rectangle { background: navy; horizontal-stretch: 2;}
            Rectangle { background: gray; }
        }
        // All elements not having a maximum width have a stretch factor of 0 so they grow
        HorizontalLayout {
            Rectangle { background: red; max-width: 20px; }
            Rectangle { background: orange; horizontal-stretch: 0; }
            Rectangle { background: pink; horizontal-stretch: 0; }
        }
    }
}
```

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/dac628796bc9d71ac0ada51acbb6f8c2.png#pic_center)

**for**

在 `VerticalLayout` 和 `HorizontalLayout` 中也可以使用 `for` 或 `if` 表达式：

```slint
export component Example inherits Window {
    width: 200px;
    height: 50px;
    HorizontalLayout {
        Rectangle { background: green; }
        for t in [ "Hello", "World", "!" ] : Text {
            text: t;
        }
        Rectangle { background: blue; }
    }
}
```

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/f5dcd295a18ea0ba21d4684991f67bf0.png#pic_center)

**网格布局**

`GridLayout` 将元素放在网格中。每个元素都获得属性`row`、`col`、`rowspan` 和 `colspan`。可以使用 `Row` 子元素，也可以显式设置 `row` 属性——这些属性必须在编译时静态已知，因此不可能使用算术或依赖属性。到目前为止，在网格布局中不允许使用for或if表达式。

这个例子使用 Row 元素。

```slint
export component Foo inherits Window {
    width: 200px;
    height: 200px;
    GridLayout {
        spacing: 5px;
        Row {
            Rectangle { background: red; }
            Rectangle { background: blue; }
        }
        Row {
            Rectangle { background: yellow; }
            Rectangle { background: green; }
        }
    }
}
```

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/fc9953f24889ad285f51947f81b6d9f3.png#pic_center)

此示例使用col和row属性

```slint
export component Foo inherits Window {
    width: 200px;
    height: 150px;
    GridLayout {
        spacing: 0px;
        Rectangle { background: red; }
        Rectangle { background: blue; }
        Rectangle { background: yellow; row: 1; }
        Rectangle { background: green; }
        Rectangle { background: black; col: 2; row: 0; }
    }
}
```

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/6110e97c1d1f0f01c550359c88cea337.png#pic_center)

### 2.3 容器组件

在声明组件时，有时希望在使用该组件时添加的子元素的位置限制在特定区域。例如，想象一个组件在用户放置的任何元素上方绘制标签：

```slint
export component MyApp inherits Window {

    BoxWithLabel {
        Text {
            // ...
        }
    }

    // ...
}
```

您可以使用布局实现这样的 `BoxWithLabel`。默认情况下，像 `Text` 元素这样的子元素成为 `BoxWithLabel` 的直接子元素，但我们需要它们成为我们布局的子元素。为此，您可以通过在组件的元素层次结构中使用`@children` 表达式来更改默认的子位置：

```slint
component BoxWithLabel inherits GridLayout {
    Row {
        Text { text: "label text here"; }
    }
    Row {
        @children
    }
}

export component MyApp inherits Window {
    preferred-height: 100px;
    BoxWithLabel {
        VerticalLayout {
            Rectangle { background: blue; }
            Rectangle { background: yellow; }
        }
    }
}
```

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/52d14c204c1850dfa64e9484f200ee2a.png#pic_center)

### 2.4 焦点处理

某些元素，如TextInput不仅接受来自鼠标/手指的输入，还接受来自（虚拟）键盘的关键事件。为了使一个项目接收这些事件，它必须有焦点。这通过 `has-focus(out)`属性可见。

您可以通过调用focus()手动激活元素的焦点：

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

如果您已将 `TextInput` 包装在组件中，那么您可以使用 `forward-focus` 属性转发此类焦点激活，以引用应接收它的元素：

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

如果在窗口上使用 `forward-focus` 属性，则指定的元素将在窗口第一次接收焦点时获得焦点——它将成为初始焦点元素。

### 2.5 字体处理

`Text` 和 `TextInput` 等元素可以渲染文本，并允许通过不同的属性自定义文本的外观。以 `font-` 为前缀的属性，如 `font-family`、`font-size` 和 `font-weight`，会影响用于渲染到屏幕的字体的选择。如果未指定这些属性中的任何一个，则应用周围 `Window` 元素中的 `default-font-值`，例如 `default-font-family`。

选择用于渲染的字体会自动从系统中拾取。也可以在您的设计中包含自定义字体。自定义字体必须是`TrueType`字体（`.ttf`）或 `TrueType` 字体集合（`.ttc`）。您可以使用 `import`语句选择自定义字体：在 `.slint` 文件中导入 `"./my_custom_font.ttf"`。这指示 Slint 编译器包含字体，并使字体系列在全球范围内可用于 `font-family` 属性。

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

### 2.6 纯度

Slint 的属性赋值是懒惰和“反应性”的，读取属性值时会计算属性绑定，属性之间的依赖关系在属性赋值时自动被发现。属性存储了赋值结果。当属性更改时，所有依赖属性都会收到通知，因此下次读取其值时，会重新计算其绑定。

为了使任何反应系统正常工作，计算属性值不应该改变任何可观察状态，而应该改变属性本身。如果是这种情况，那么表达式是“纯的”，否则就是有副作用。副作用是有问题的，因为并不总是清楚它们何时会发生：懒惰的评估可能会改变它们的顺序或影响它们是否发生。此外，由于副作用，在绑定赋值期间对属性的更改可能会导致意外行为。

因此，Slint 中的绑定必须是纯的。Slint 编译器在纯上下文中强制执行代码，以免受副作用。纯上下文包括绑定表达式、纯函数的主体和纯回调处理程序的主体。在这种情况下，不允许更改属性，或调用非 `purecallback`或 函数。

使用 `pure` 关键字注释回调和公共函数，使其可以从属性绑定和其他纯回调和函数访问它们。

私有函数的纯度是自动推断的。您可以声明私有函数显式“纯”，让编译器强制执行其纯度。

```
export component Example {
    pure callback foo() -> int;
    public pure function bar(x: int) -> int
    { return x + foo(); }
}

```

## 3 参考

### 3.1 注释

支持C风格的注释：

- 行注释：从`//`开始至行末尾的所有内容都是注释
- 块注释： 以 `/*` 开始、以 `*/` 结尾的内容都是注释

### 3.2 标识符

标识符可以由字母（`a-zA-Z`）、数字（`0-9`）或下划线（`_`）或破折号（`-`）组成。它们**不能以数字或破折号开头**（但他们可以从下划线开始）下划线被标准化为破折号。这意味着这两个标识符是相同的：`foo_bar` 和 `foo-bar`。

### 3.3 类型

Slint 中的所有属性都有一个类型。Slint 基本类型如下表所示。

| 类型                 | 描述                                                                                              |
| ------------------ | ----------------------------------------------------------------------------------------------- |
| int                | 整数                                                                                              |
| float              | 32位浮点数。带有%后缀的数字会自动除以100，因此例如30%与0.30相同                                                          |
| bool               | 布尔值可以是true或false                                                                                |
| string             | UTF-8编码字符串                                                                                      |
| color              | 带有 alpha 通道的 RGB 颜色，每个通道的精度为 8 位。支持 CSS 颜色名称以及十六进制颜色编码，例如 `#RRGGBBAA` 或 `#RGB`                  |
| brush              | 画笔是一种特殊类型，可以从颜色或渐变规格中初始化。有关更多信息，请参阅颜色和画笔部分                                                      |
| physical-length    | 物理像素的数量。要从整数转换为长度单位，只需乘以 `1px` 即可。或者从长度转换为浮点数，可以除以 `1phx`                                       |
| length             | 用于x、y、width和height坐标。对应于字面上的like1px1pt1in1mm或1cm。它可以转换为长度，前提是绑定在可以访问设备像素比的上下文中运行                |
| duration           | 动画持续时间。像ms（毫秒）或s（秒）这样的后缀用于表示精度                                                                  |
| angle              | 角度，对应于字面值，如90deg，1.2rad，0.25turn                                                                |
| easing             | 属性动画允许指定宽松曲线。有效值是linear（值是线性插值的），以及CSS中已知的四个常见的cubiz-bezier函数：ease、ease_in、ease_in_out、ease_out |
| percent            | 带有符号的 32 位浮点数，被解释为百分比。分配给此类属性的字面编号必须有 `%` 后缀                                                    |
| image              | 对图像的引用，可以使用 `@image-url("…")`构造初始化                                                              |
| relative-font-size | 相对字体大小因子，与 `Window.default-font-size` 相乘，可以转换为 `length`                                         |

请参阅特定语言的API参考，这些类型如何映射到不同编程语言的API。

#### 3.3.1 字符串

任何被双引号包围的 utf-8 编码字符序列都是一个字符串。字符串允许使用反斜杠转义

转义序列可以嵌入到字符串中，以插入否则难以插入的字符：

| 逃脱             | 结果           |
| -------------- | ------------ |
| `\"`           | "            |
| `\\`           | `\`          |
| `\n`           | 换行           |
| `\u{x}`        | 其中x是一个十六进制数字 |
| `{expression}` | 计算表达式的结果     |

```slint
export component Example inherits Text {
    text: "hello";
}
```

注意：在 Rust 中的 `slint!` 宏内，`{...}` 语法是无效的。
#### 3.3.2 颜色和刷子

颜色文字遵循CSS的语法：

```
export component Example inherits Window {
    background: blue;
    property<color> c1: #ffaaff;
    property<brush> b2: Colors.red;
}
```

除了纯色外，许多元素的属性都是 `brush` 类型，而不是 `color` 。画笔是一种可以是颜色或渐变的类型。然后，画笔用于填充元素或绘制轮廓。

CSS 颜色名称仅在类型 `color` 或 `brush` 的表达式中处于范围之内。否则，您可以从 Colors 命名空间访问颜色。

**方法**

所有颜色和画笔都定义了以下方法：

- **brighter(factor: float) -> Brush**
  返回从该颜色派生的新颜色，但其亮度增加了指定因子。例如，如果因子为0.5（或例如50%），则返回的颜色亮50%。负因素会降低亮度。

- **darker(factor: float) -> Brush**
  返回从该颜色派生的新颜色，但其亮度因指定因子而降低。例如，如果因子为0.5（或例如50%），则返回的颜色更深50%。负面因素增加了亮度。

**线性梯度**

线性梯度描述了光滑、多彩的表面。它们使用角度和一系列色标来指定。颜色将在止损之间线性插值，与以指定角度旋转的虚线对齐。这被称为线性梯度，并使用具有以下签名的@linear-gradient宏指定：

@linear-gradient(angle, color percentage, color percentage, …)

宏的第一个参数是一个角度（请参阅类型）。梯度线的起点将按指定值旋转。

初始角度之后是一个或多个颜色停止，描述为color值和percentage的空间分隔对。颜色指定了沿梯度轴线的指定百分比的线性颜色插值应达到哪个值。

以下示例显示了一个矩形，它充满了线性渐变，该渐变以浅蓝色开始，插入到中心非常浅的阴影，并以橙色色调结束：

```
export component Example inherits Window {
    preferred-width: 100px;
    preferred-height: 100px;

    Rectangle {
        background: @linear-gradient(90deg, #3f87a6 0%, #ebf8e1 50%, #f69d3c 100%);
    }
}
12345678
```

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/ba8e553b7835fbaf2eebe9072c9ee0ef.png#pic_center)

**径向梯度**

线性梯度就像真正的梯度，但颜色是在圆中插值的，而不是沿着一条线插值。要描述一个就读的渐变，请使用具有以下签名的@radial-gradient宏：

@radial-gradient(circle, color percentage, color percentage, …)

宏的第一个参数总是circle，因为只支持圆形辐射。除此之外，语法是基于CSSradial-gradient函数。

示例：

```
export component Example inherits Window {
    preferred-width: 100px;
    preferred-height: 100px;
    Rectangle {
        background: @radial-gradient(circle, #f00 0%, #0f0 50%, #00f 100%);
    }
}

```

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/af6d29828b635da881c56c42b00da20e.png#pic_center)

#### 3.3.3 图片

image类型是对图像的引用。它是使用@image-url(“…”)构造定义的。@image-url函数中的地址必须在编译时知道。

Slint在以下地方寻找图像：

1. 绝对路径或相对于当前.slint文件的路径。
2. 编译器用于查找.slint文件的包含路径。

使用image的width和height属性访问图像的尺寸。

```
export component Example inherits Window {
    preferred-width: 150px;
    preferred-height: 50px;

    in property <image> some_image: @image-url("https://slint-ui.com/logo/slint-logo-full-light.svg");

    Text {
        text: "The image is " + some_image.width + "x" + some_image.height;
    }
}
12345678910
```

#### 3.3.4 结构

使用struct关键字定义命名结构：

```
export struct Player  {
    name: string,
    score: int,
}

export component Example {
    in-out property<Player> player: { name: "Foo", score: 100 };
}
12345678
```

**匿名结构**

使用 { identifier1: type2, identifier1: type2 } 语法声明一个匿名结构，使用 { identifier1: expression1, identifier2: expression2 } 初始化。

```
export component Example {
    in-out property<{name: string, score: int}> player: { name: "Foo", score: 100 };
    in-out property<{a: int, }> foo: { a: 3 };
}
1234
```

#### 3.3.5 数组和模型

数组通过在方括号内写数组元素类型来声明。

数组文字以及保存数组的属性充当模型for表达式。

```
export component Example {
    in-out property<[int]> list-of-int: [1,2,3];
    in-out property<[{a: int, b: string}]> list-of-structs: [{ a: 1, b: "hello" }, {a: 2, b: "world"}];
}
1234
```

数组定义了以下操作：

array.length：可以使用内置的.length属性查询数组和模型的长度。
array[index]：索引运算符检索数组的单个元素。
对数组的越界访问将返回默认构造的值。

```
export component Example {
    in-out property<[int]> list-of-int: [1,2,3];

    out property <int> list-len: list-of-int.length;
    out property <int> first-int: list-of-int[0];
}
123456
```

#### 3.3.6 类型转换

Slint支持不同类型之间的转换。需要显式转换以使UI描述更加健壮，但为了方便起见，允许在某些类型之间进行隐式转换。

以下转换是可能的：

- int可以隐式转换为float，反之亦然
- int和float可以隐式转换为string
- physical-length只有在已知像素比的上下文中，length才能隐式地相互转换。
- 单位类型（length、physical-length、duration、…）不能转换为数字（float或int），但它们可以按自身划分，得出一个数字。同样，一个数字可以乘以这些单位中的一个。这个想法是，人们会乘以1px或除以1px来进行此类转换
- 字面值0可以转换为具有相关单位的任何这些类型。
- 如果结构类型具有相同的属性名称，并且其类型可以转换，则使用其他结构类型进行转换。源结构可以有缺失的属性，也可以有额外的属性。但不是两者兼而有之。
- 数组通常不会相互转换。如果元素类型可转换，则可以转换数组文字。
- 可以使用`to-float`函数将字符串转换为float。如果字符串不是有效数字，则该函数返回0。您可以使用`is-float()`检查字符串是否包含有效数字

```
export component Example {
    // ok: int converts to string
    property<{a: string, b: int}> prop1: {a: 12, b: 12 };
    // ok even if a is missing, it will just have the default value
    property<{a: string, b: int}> prop2: { b: 12 };
    // ok even if c is too many, it will be discarded
    property<{a: string, b: int}> prop3: { a: "x", b: 12, c: 42 };
    // ERROR: b is missing and c is extra, this doesn't compile, because it could be a typo.
    // property<{a: string, b: int}> prop4: { a: "x", c: 42 };

    property<string> xxx: "42.1";
    property<float> xxx1: xxx.to-float(); // 42.1
    property<bool> xxx2: xxx.is-float(); // true
}
1234567891011121314
```

### 3.4 属性

所有元素都有属性。内置元素具有常见的属性，如颜色或尺寸属性。您可以为它们分配值或整个表达式：

```
export component Example inherits Window {
    // Simple expression: ends with a semi colon
    width: 42px;
    // or a code block (no semicolon needed)
    height: { 42px }
}
123456
```

除了现有属性外，通过指定名称、类型和可选的默认值来定义额外的属性：

```
export component Example {
    // declare a property of type int with the name `my-property`
    property<int> my-property;

    // declare a property with a default value
    property<int> my-second-property: 42;
}
1234567
```

使用限定符对属性进行自定义注释，限定符指定如何读取和写入属性：

- private（默认值）：只能从组件内部访问该属性。
- in：该属性是一个输入。它可以由此组件的用户设置和修改，例如通过绑定或回调中的赋值。该组件可以提供默认绑定，但不能通过赋值覆盖它
- out：只能由组件设置的输出属性。它对组件的用户是只读的。
- in-out：该属性可以被每个人读取和修改。

```
export component Button {
    // This is meant to be set by the user of the component.
    in property <string> text;
    // This property is meant to be read by the user of the component.
    out property <bool> pressed;
    // This property is meant to both be changed by the user and the component itself.
    in-out property <bool> checked;

    // This property is internal to this component.
    private property <bool> has-mouse;
}
1234567891011
```

当将组件用作元素时，或通过业务逻辑的语言绑定，在组件的顶层声明的所有非private属性都可以从外部访问。

**绑定**

当表达式中访问的属性发生变化时，绑定表达式会自动重新计算。

在以下示例中，当用户按下按钮时，按钮的文本会自动更改。增量counter属性会自动使绑定到text的表达式无效，并触发重新计算。

```
import { Button } from "std-widgets.slint";
export component Example inherits Window {
    preferred-width: 50px;
    preferred-height: 50px;
    Button {
        property <int> counter: 3;
        clicked => { self.counter += 3 }
        text: self.counter * 2;
    }
}
12345678910
```

当查询属性时，重新计算会懒惰地发生。

在内部，在计算绑定时为访问的任何属性注册依赖项。当属性更改时，会通知依赖项，所有依赖绑定都会被标记为脏。

默认情况下，本机代码中的回调不依赖于任何属性，除非它们查询本机代码中的属性。

**双向绑定**

使用<=>语法在属性之间创建双向绑定。这些属性将被链接在一起，并且始终包含相同的值。

<=>的右侧必须是同一类型属性的引用。属性类型是可选的，带有双向绑定，如果没有指定，将被推断。

```
export component Example  {
    in property<brush> rect-color <=> r.background;
    // It's allowed to omit the type to have it automatically inferred
    in property rect-color2 <=> r.background;
    r:= Rectangle {
        width: parent.width;
        height: parent.height;
        background: blue;
    }
}
12345678910
```

***相对长度***

有时，用相对百分比来表达长度属性的关系很方便。例如，以下内部蓝色矩形的大小是外部绿色窗口的一半：

```
export component Example inherits Window {
    preferred-width: 100px;
    preferred-height: 100px;

    background: green;
    Rectangle {
        background: blue;
        width: parent.width * 50%;
        height: parent.height * 50%;
    }
}
1234567891011
```

这种以同名的父属性的百分比表示width或height的模式很常见。为了方便起见，此场景存在一个简写语法：

属性是width或height
绑定表达式求值为百分比。
如果满足这些条件，则无需指定父属性，相反，您可以简单地使用百分比。前面的例子看起来像这样：

```
export component Example inherits Window {
    preferred-width: 100px;
    preferred-height: 100px;

    background: green;
    Rectangle {
        background: blue;
        width: 50%;
        height: 50%;
    }
}
1234567891011
```

### 3.5 表达式

表达式是在用户界面中声明关系和连接的强大方式。它们通常用于将基本算术与访问其他元素的属性相结合。当这些属性发生变化时，表达式会自动重新计算，并为表达式关联的属性分配一个新值：

```
export component Example {
    // declare a property of type int
    in-out property<int> my-property;

    // This accesses the property
    width: root.my-property * 20px;
}
1234567
```

当my-property发生变化时，宽度也会自动改变。

带有数字的表达式中的算术就像大多数编程语言中的运算符*，+，-，/：

```
export component Example {
    in-out property <int> p: 1 * 2 + 3 * 4; // same as (1 * 2) + (3 * 4)
}
123
```

将字符串与+连接。

运算符 && 和 || 表示两个布尔值的逻辑“与”和“或”，运算符 ==、!=、>、<、=>和<=用于比较类型相同的两个值。

使用元素的名称访问元素的属性，后跟a.和属性名称：

```
export component Example {
    foo := Rectangle {
        x: 42px;
    }
    x: foo.x;
}
123456
```

三元运算符 … ? … : … 也被支持，就像 C 或 JavaScript 那样：

```
export component Example inherits Window {
    preferred-width: 100px;
    preferred-height: 100px;

    Rectangle {
        touch := TouchArea {}
        background: touch.pressed ? #111 : #eee;
        border-width: 5px;
        border-color: !touch.enabled ? #888
            : touch.pressed ? #aaa
            : #555;
    }
}
12345678910111213
```

### 3.6 函数

使用function关键字声明函数。默认情况下，函数是私有的，但可以通过public注释公开。

```
export component Example {
    in property <int> min;
    in property <int> max;
    public function inbound(x: int) -> int {
        return Math.min(root.max, Math.max(root.min, x));
    }
}
1234567
```

### 3.7 回调

组件可以声明回调，将状态变化传达给外部。回调是通过“调用”它们来调用的，就像您调用函数一样。

您可以通过使用`=>`箭头语法声明处理程序来响应回调调用。内置TouchArea元素声明了clicked回调，当用户触摸元素覆盖的矩形区域或用鼠标点击它时，就会调用回调。在下面的示例中，通过声明处理程序并调用我们的自定义回调，将该回调的调用转发到另一个自定义回调（hello）：

```
export component Example inherits Rectangle {
    // declare a callback
    callback hello;

    area := TouchArea {
        // sets a handler with `=>`
        clicked => {
            // emit the callback
            root.hello()
        }
    }
}
123456789101112
```

可以向回调添加参数：

```
export component Example inherits Rectangle {
    // declares a callback
    callback hello(int, string);
    hello(aa, bb) => { /* ... */ }
}
12345
```

回调也可以返回一个值：

```
export component Example inherits Rectangle {
    // declares a callback with a return value
    callback hello(int, int) -> int;
    hello(aa, bb) => { aa + bb }
}
12345
```

**别名**

可以以类似于双向绑定的方式声明回调别名：

```
export component Example inherits Rectangle {
    callback clicked <=> area.clicked;
    area := TouchArea {}
}
1234
```

### 3.8 语句

回调处理程序可能包含复杂的语句：

赋值：

```
clicked => { some-property = 42; }
1
```

使用+=、 -=、 *=和 /=自我赋值：

```
clicked => { some-property += 42; }
1
```

回调：

```
clicked => { root.some-callback(); }
1
```

条件陈述：

```
clicked => {
    if (condition) {
        foo = 42;
    } else if (other-condition) {
        bar = 28;
    } else {
        foo = 4;
    }
}
123456789
```

空表达式：

```
clicked => { }
// or
clicked => { ; }
123
```

### 3.8 重复元素

使用for-in语法多次创建元素。

语法如下所示：for name[index] in model : id := Element { … }

model 可以是以下类型：

- 一个整数，在这种情况下，元素将被重复 model 次
- 本地声明的数组类型或模型，在这种情况下，将为数组或模型中的每个元素实例化元素。

该名称将可用于在元素中查找，并且将类似于设置为模型值的伪属性。索引是可选的，并将设置为模型中此元素的索引。id也是可选的。

示例

```
export component Example inherits Window {
    preferred-width: 300px;
    preferred-height: 100px;
    for my-color[index] in [ #e11, #1a2, #23d ]: Rectangle {
        height: 100px;
        width: 60px;
        x: self.width * index;
        background: my-color;
    }
}
12345678910
```

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/77ddf44d00fe8468516a093cc0423b2c.png#pic_center)

```
export component Example inherits Window {
    preferred-width: 50px;
    preferred-height: 50px;
    in property <[{foo: string, col: color}]> model: [
        {foo: "abc", col: #f00 },
        {foo: "def", col: #00f },
    ];
    VerticalLayout {
        for data in root.model: my-repeated-text := Text {
            color: data.col;
            text: data.foo;
        }
    }
}
1234567891011121314
```

### 3.9 条件元素

只有当给定条件为真时，if构造才会实例化元素。语法是if condition : id := Element { … }

```
export component Example inherits Window {
    preferred-width: 50px;
    preferred-height: 50px;
    if area.pressed : foo := Rectangle { background: blue; }
    if !area.pressed : Rectangle { background: red; }
    area := TouchArea {}
}
1234567
```

### 3.10 动画

使用像这样的animate关键字为属性声明动画：

```
export component Example inherits Window {
    preferred-width: 100px;
    preferred-height: 100px;

    background: area.pressed ? blue : red;
    animate background {
        duration: 250ms;
    }

    area := TouchArea {}
}
1234567891011
```

每当颜色属性发生变化时，会有250毫秒的颜色过渡动画。

使用以下参数微调动画：

- delay：开始动画之前等待的时间
- duration：动画完成所需的时间
- iteration-count：动画应该运行的次数，负值表示无限重播
- easing：可以是 linear（线性）、 ease（缓慢）、ease-in（淡入）、 ease-out（淡出）、 ease-in-out（淡入淡出）、cubic-bezier(a, b, c, d)（三阶贝塞尔平滑） ，就像 CSS

也可以为多个属性指定相同的动画：

```
animate x, y { duration: 100ms; }
1
```

等价于：

```
animate x { duration: 100ms; }
animate y { duration: 100ms; }
12
```

### 3.11 状态

states语句允许一次声明状态并设置多个元素的属性：

```
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

123456789101112131415161718192021222324252627
```

在本例中，active和active-hovered状态取决于active布尔属性的值和TouchAreahas-hover。当用户用鼠标悬停示例时，它将在蓝色和绿色背景之间切换，并相应地调整文本标签。单击切换active属性，从而进入inactive状态。

**过渡**

过渡将动画绑定到状态更改。

这个例子定义了两个过渡。首先，当离开disabled状态时out关键字用于为所有800ms的属性添加动画效果。第二个过渡在过渡到down状态时使用in关键字为背景添加动画。

```
export component Example inherits Window {
    preferred-width: 100px;
    preferred-height: 100px;

    text := Text { text: "hello"; }
    in-out property<bool> pressed;
    in-out property<bool> is-enabled;

    states [
        disabled when !root.is-enabled : {
            background: gray; // same as root.background: gray;
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

123456789101112131415161718192021222324
```

### 3.12 全局单例

使用global关键字声明一个全局单例，使属性和回调函数在整个项目中可用。
例如，这对常见的调色板很有用：

```
global Palette  {
    in-out property<color> primary: blue;
    in-out property<color> secondary: green;
}

export component Example inherits Rectangle {
    background: Palette.primary;
    border-color: Palette.secondary;
    border-width: 2px;
}
12345678910
```

导出全局，使其可以从其他文件访问（请参阅模块）。从文件中导出全局文件，还导出主应用程序组件，使其对业务逻辑中的本机代码可见。

```
export global Logic  {
    in-out property <int> the-value;
    pure callback magic-operation(int) -> int;
}
// ...
12345
```

使用双向绑定语法可以从全局重新暴露回调或属性。

```
global Logic  {
    in-out property <int> the-value;
    pure callback magic-operation(int) -> int;
}

component SomeComponent inherits Text {
    // use the global in any component
    text: "The magic value is:" + Logic.magic-operation(42);
}

export component MainWindow inherits Window {
    // re-expose the global properties such that the native code
    // can access or modify them
    in-out property the-value <=> Logic.the-value;
    pure callback magic-operation <=> Logic.magic-operation;

    SomeComponent {}
}

123456789101112131415161718
```

### 3.13 模块

在.slint文件中声明的组件可以通过导出和导入它们作为其他.slint文件中的元素。

默认情况下，.slint文件中声明的每个类型都是私有的。export关键字改变了这一点。

```
component ButtonHelper inherits Rectangle {
    // ...
}

component Button inherits Rectangle {
    // ...
    ButtonHelper {
        // ...
    }
}

export { Button }
123456789101112
```

在上述示例中，Button可以从其他.slint文件访问，但ButtonHelper不能。

也可以导出时更改名称，而不会影响其内部使用：

```
component Button inherits Rectangle {
    // ...
}

export { Button as ColorButton }
12345
```

在上面的例子中，Button从外部访问，而是在名称ColorButton下可用。

为了方便起见，导出组件的第三种方法是立即声明其导出：

```
export component Button inherits Rectangle {
    // ...
}
123
```

同样，从其他文件导出的组件也可以导入：

```
import { Button } from "./button.slint";

export component App inherits Rectangle {
    // ...
    Button {
        // ...
    }
}
12345678
```

如果两个文件以相同的名称导出类型，那么您可以选择在导入时分配不同的名称：

```
import { Button } from "./button.slint";
import { Button as CoolButton } from "../other_theme/button.slint";

export component App inherits Rectangle {
    // ...
    CoolButton {} // from other_theme/button.slint
    Button {} // from button.slint
}
12345678
```

元素、全局和结构可以导出和导入。

也可以导出从其他文件导入的全局（见全局单例）：

```
import { Logic as MathLogic } from "math.slint";
export { MathLogic } // known as "MathLogic" when using native APIs to access globals
12
```

**模块语法**

导入类型支持以下语法：

```
import { export1 } from "module.slint";
import { export1, export2 } from "module.slint";
import { export1 as alias1 } from "module.slint";
import { export1, export2 as alias2, /* ... */ } from "module.slint";
1234
```

导出类型支持以下语法：

```
// Export declarations
export component MyButton inherits Rectangle { /* ... */ }

// Export lists
component MySwitch inherits Rectangle { /* ... */ }
export { MySwitch };
export { MySwitch as Alias1, MyButton as Alias2 };

// Re-export all types from other module
export * from "other_module.slint";
12345678910
```

## 4 内置

### 4.1 内置回调

**init()**

每个元素都隐式声明init回调。您可以为其分配一个代码块，该代码块将在元素实例化时调用，并在所有属性以其最终绑定的值初始化后调用。调用顺序是从内部到外部的。以下示例将打印“第一”，然后是“第二”，然后是“第三”：

```
component MyButton inherits Rectangle {
    in-out property <string> text: "Initial";
    init => {
        // If `text` is queried here, it will have the value "Hello".
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

1234567891011121314151617181920
```

不要使用此回调来初始化属性，因为这违反了声明原则。避免使用此回调，除非您需要它，例如，为了通知一些本机代码：

```
global SystemService  {
    // This callback can be implemented in native code using the Slint API
    callback ensure_service_running();
}

export component MySystemButton inherits Rectangle {
    init => {
        SystemService.ensure_service_running();
    }
    // ...
}
1234567891011
```

### 4.2 内置元素

**通用属性**

- 位置和大小：对所有可见项目有效
  - width和height（长度）：元素的大小。设置时，这会覆盖默认大小
  - x和y：元素相对于其父元素的位置
  - z：元素在同一级元素中的堆叠次序，默认值为0
- 布局：对所有可见项目有效（当用于布局时指定约束）
  - col，row， colspan，rowspan：网格布局有效，请参阅GridLayout。
  - horizontal-stretch和vertical-stretch：拉伸因子
  - max-width和max-height：元素的最大大小
  - min-width和min-height：元素的最小尺寸
  - preferred-width和preferred-height：元素的首选尺寸
- 杂项
  - cache-rendering-hint：加速渲染，默认false
  - dialog-button-role：指定这是Dialog的按钮
  - opacity：透明度，默认值为1（0是完全透明的，1是完全不透明的）
  - visible：可见性，默认true
- 可访问性
  - accessible-role：元素角色（大多数元素默认为none，但文本元素为text）
  - accessible-checkable：是否可以选中元素
  - accessible-checked：是否选中了元素——对应复选框、单选按钮和其他小部件的“已选中”状态
  - accessible-description：当前元素的描述
  - accessible-has-focus：当当前元素当前具有焦点时，设置为true。
  - accessible-label：交互式元素的标签（大多数元素默认为空，或文本元素的text属性值）
  - accessible-value-maximum：最大值
  - accessible-value-minimum：最小值
  - accessible-value-step：当前值可以改变的最小增量
  - accessible-value：当前值。
- 阴影：在元素框架下方显示阴影效果
  - drop-shadow-blur：阴影半径，也描述了应用于阴影的模糊程度，默认值为0
  - drop-shadow-color：阴影颜色（该颜色是阴影由浓变淡的起始颜色）
  - drop-shadow-offset-x和drop-shadow-offset-y：阴影与元素框架的水平和垂直距离，若为负值，阴影位于元素的左边和上方

以下示例演示了元素和子项的opacity属性。红色矩形上应用不透明度。由于绿色矩形是红色矩形的子项，因此您可以看到绿色矩形下面的渐变，但您无法通过绿色矩形看到红色矩形。

```
export component Example inherits Window {
    width: 200px;
    height: 200px;
    background: @radial-gradient(circle, black, white, black, white);
    Rectangle {
        opacity: 0.5;
        background: red;
        border-color: #822;
        border-width: 10px;
        width: 100px; height: 100px;
        x: 20px; y: 20px;
        Rectangle {
            background: green;
            border-color: #050;
            border-width: 10px;
            width: 100px; height: 100px;
            x: 50px; y: 50px;
        }
    }
}

1234567891011121314151617181920
```

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/a476547376f464fed6d08e2632d7b01c.png#pic_center)

#### 4.2.1 Dialog

对话框就像一个窗口，但它有约定俗成的按钮。

对话框应该有一个主要元素作为子元素，而不是按钮。对话框可以具有任意数量的StandardButton小部件或其他具有dialog-button-role属性的按钮。这些按钮将按运行时取决于目标平台的顺序放置。

StandardButton的kind属性和dialog-button-role属性需要设置为常量值，它不能是任意变量表达式。不可能有多个同类StandardButton。

为每个没有显式回调处理程序的StandardButton自动添加回调_clicked，因此可以从本机代码进行处理：例如，如果有一个cancel按钮，将添加cancel_clicked回调。

**属性**

- icon（在图像中）：标题栏或支持它的窗口管理器上的任务栏中显示的窗口图标。
- title（字符串）：标题栏中显示的窗口标题。

```
import { StandardButton, Button } from "std-widgets.slint";
export component Example inherits Dialog {
    Text {
      text: "This is a dialog box";
    }
    StandardButton { kind: ok; }
    StandardButton { kind: cancel; }
    Button {
      text: "More Info";
      dialog-button-role: action;
    }
}
123456789101112
```

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/3744d7b503c01a11c579711b7e47a3dc.png#pic_center)

#### 4.2.2 Flickable

Flickable是一个低级元素，是可滚动小部件的基础，例如ScrollView。当viewport-width或viewport-height大于父的width或height时，该元素将变得可滚动。请注意，Flickable创建滚动条。取消设置时，viewport-width和viewport-height将根据Flickable的子项自动计算。当使用for循环填充元素时，情况并非如此。这是问题[#407]（（https://github.com/slint-ui/slint/issues/407）中跟踪的错误。Flickable的最大和首选大小基于视口。

当不是布局的一部分时，当未指定时，其宽度或高度默认为父元素的100%。

**属性**

- interactive：允许通过单击视口并用光标拖动它来滚动视口，默认true
- viewport-height，viewport-width：可滚动元素的总大小
- viewport-x，viewport-y：可滚动元素相对于Flickable的位置，这通常是一个负值

```
export component Example inherits Window {
    width: 270px;
    height: 100px;

    Flickable {
        viewport-height: 300px;
        Text {
            x:0;
            y: 150px;
            text: "This is some text that you have to scroll to see";
        }
    }
}
12345678910111213
```

#### 4.2.3 FocusScope

FocusScope暴露了回调以拦截关键事件。请注意，FocusScope只会在has-focus时调用它们。

KeyEvent有一个文本属性，这是输入的密钥的字符。当按下不可打印的键时，该字符要么是控制字符，要么被映射到私有Unicode字符。这些不可打印的特殊字符的映射在Key命名空间中可用

**属性**

- has-focus：当元素具有键盘焦点时为true。
- enabled：当为真时，FocusScope将在单击时使自己成为聚焦元素。如果您不想要点击对焦行为，请将此设置为false。同样，禁用的FocusScope不接受通过选项卡焦点遍历的焦点。父FocusScope仍将从childFocusScopes接收被拒绝的关键事件，即使enabled设置为false。（默认值：true）

**功能**

- focus()调用此函数将键盘焦点传输到此FocusScope，以接收未来KeyEvent。

**回调**

- key-pressed(KeyEvent) -> EventResult：按下键时调用，参数是aKeyEvent结构。
- key-released(KeyEvent) -> EventResult：在释放密钥时调用，参数是aKeyEvent结构。
  示例

```
export component Example inherits Window {
    width: 100px;
    height: 100px;
    forward-focus: my-key-handler;
    my-key-handler := FocusScope {
        key-pressed(event) => {
            debug(event.text);
            if (event.modifiers.control) {
                debug("control was pressed during this event");
            }
            if (event.text == Key.Escape) {
                debug("Esc key was pressed")
            }
            accept
        }
    }
}

1234567891011121314151617
```

#### 4.2.4 GridLayout

GridLayout将其子项放在网格中。GridLayout为每个子项添加属性：col、row、colspan、rowspan。你可以用col和row来控制子项的位置。如果未指定col或row，则会自动计算它们，使项目在同一行中位于前一个项目旁边。或者，可以将项目放在行元素中。

**属性**

- spacing：布局中元素之间的距离。
- padding：布局中的填充物。
- padding-left，padding-right，padding-top和padding-bottom：设置这些属性以覆盖特定侧面的填充。

**示例**

此示例使用Row元素：

```
export component Foo inherits Window {
    width: 200px;
    height: 200px;
    GridLayout {
        spacing: 5px;
        Row {
            Rectangle { background: red; }
            Rectangle { background: blue; }
        }
        Row {
            Rectangle { background: yellow; }
            Rectangle { background: green; }
        }
    }
}
123456789101112131415
```

此示例使用col和row属性

```
export component Foo inherits Window {
    width: 200px;
    height: 150px;
    GridLayout {
        Rectangle { background: red; }
        Rectangle { background: blue; }
        Rectangle { background: yellow; row: 1; }
        Rectangle { background: green; }
        Rectangle { background: black; col: 2; row: 0; }
    }
}
1234567891011
```

#### 4.2.5 Image

Image可用于表示从文件加载的图像。

**属性**

- colorize（在画笔中）：设置时，图像用作alpha掩码，并以给定的颜色（或渐变）绘制。
- image-fit（在枚举ImageFit）：指定源图像应如何融入图像元素。（默认值：当Image元素是布局的一部分时contain，否则fill）
- image-rendering（在枚举ImageRendering）：指定源图像的缩放方式。（默认值：smooth）
- rotation-angle（角度）、rotation-origin-x（长度）、rotation-origin-y（长度）：围绕指定原点以给定角度旋转图像。默认原点是元素的中心。设置这些属性后，Image不能有子项。
- source（在图像中）：要加载的图像。使用@image-url(“…”)宏指定图像的位置。
- source-clip-x，source-clip-y，source-clip-width，source-clip-height（in int）：源图像坐标中的属性，定义渲染的源图像区域。默认情况下，整个源图像是可见的：
- width，height（长度）：屏幕上显示的图像的宽度和高度。默认值是source图像提供的大小。如果Image不在布局中，并且只指定了两种尺寸中的一种，那么其他尺寸默认为根据source图像的宽高比缩放的指定值。

**示例**

```
export component Example inherits Window {
    width: 100px;
    height: 100px;
    VerticalLayout {
        Image {
            source: @image-url("https://slint-ui.com/logo/slint-logo-full-light.svg");
            // image-fit default is `contain` when in layout, preserving aspect ratio
        }
        Image {
            source: @image-url("https://slint-ui.com/logo/slint-logo-full-light.svg");
            colorize: red;
        }
    }
}
1234567891011121314
```

在保持宽高比的同时缩放：

```
export component Example inherits Window {
    width: 100px;
    height: 150px;
    VerticalLayout {
        Image {
            source: @image-url("https://slint-ui.com/logo/slint-logo-full-light.svg");
            width: 100px;
            // implicit default, preserving aspect ratio:
            // height: self.width * natural_height / natural_width;
        }
    }
}
123456789101112
```

#### 4.2.6 Path

Path元素允许渲染由不同几何命令组成的通用形状。可以填充和勾勒出路径形状。

当不是布局的一部分时，当未指定时，其宽度或高度默认为父元素的100%。

路径可以用两种不同的方式定义：

- 使用SVG路径命令作为字符串
- 在.slint标记中使用路径命令元素。

几何命令中使用的坐标在路径的虚坐标系内。在屏幕上渲染时，形状是相对于x和y属性绘制的。如果width和height属性非零，则通过相应缩放，整个形状适合这些边界。

**通用路径属性**

- fill（在画笔中）：填充路径形状的颜色。
- fill-rule（在枚举FillRule）：用于路径的填充规则。（默认值：nonzero）
- stroke（画笔）：绘制路径轮廓的颜色。
- stroke-width（长度）：轮廓的宽度。
- width（长度）：如果非零，路径将被缩放以适应指定的宽度。
- height（长度）：如果非零，路径将缩放以适应指定高度。
- viewbox-x/viewbox-y/viewbox-width/viewbox-height（以浮点数为单位）这四个属性允许在路径坐标中定义路径视口的位置和大小。
  如果viewbox-width或viewbox-height小于或等于零，则忽略viewbox属性，而是使用所有路径元素的边界矩形来定义视图端口。
- clip（在bool中）：默认情况下，当路径定义了视图框，并且元素在它之外渲染时，它们仍然被渲染。当此属性设置为true时，渲染将在视图框的边界处被裁剪。此属性必须是字面值为true或false（默认值：false）

**使用SVG命令的路径**

SVG是一种用于定义可扩展图形的流行文件格式，这些图形通常由路径组成。在SVG中，路径是使用命令组成的，而命令又用字符串编写。在.slint中，路径命令被提供给commands属性。以下示例呈现的形状由弧形和矩形组成，矩形由line-to、move-to和arc命令组成：

```
export component Example inherits Path {
    width: 100px;
    height: 100px;
    commands: "M 0 0 L 0 100 A 1 1 0 0 0 100 100 L 100 0 Z";
    stroke: red;
    stroke-width: 1px;
}
1234567
```

命令在属性中提供：

- commands（字符串中）：根据SVG路径规范提供命令的字符串。

**使用SVG路径元素的路径**

路径的形状也可以使用类似于SVG路径命令的元素来描述，但使用.slint标记语法。前面使用SVG命令的例子也可以这样写：

```
export component Example inherits Path {
    width: 100px;
    height: 100px;
    stroke: blue;
    stroke-width: 1px;

    MoveTo {
        x: 0;
        y: 0;
    }
    LineTo {
        x: 0;
        y: 100;
    }
    ArcTo {
        radius-x: 1;
        radius-y: 1;
        x: 100;
        y: 100;
    }
    LineTo {
        x: 100;
        y: 0;
    }
    Close {
    }
}

123456789101112131415161718192021222324252627
```

注意路径元素的坐标如何使用单位-它们在可扩展路径的虚坐标系内运行。

- MoveToPath的子元素

MoveTo子元素关闭当前子路径（如果存在），并将当前点移动到x和y属性指定的位置。LineTo等后续元素将使用此新位置作为起点，因此这将启动一个新的子路径。

属性
x（浮点数）：新当前点的x位置。
y（以浮点数为单位）：新当前点的y位置。

- LineToPath的子元素

LineTo子元素描述了从路径的当前位置到x和y属性指定位置的一条线。

属性
x（浮点）：线的目标x位置。
y（浮点）：线的目标y位置。

- ArcToPath的子元素

ArcTo子元素描述椭圆的部分。弧从路径的当前位置绘制到x和y属性指定的位置。其余属性按照SVG规范建模，并允许调整视觉特征，如方向或角度。

属性
large-arc（在布尔中）：在封闭椭圆的两个弧中，此标志选择要渲染较大的弧。如果属性为false，则会呈现较短的弧度。
radius-x（浮点）：椭圆的x半径。
radius-y（浮点）：椭圆的y半径。
sweep（in bool）：如果属性为true，弧将绘制为顺时针旋转弧；否则为逆时针。
x-rotation（浮点数）：椭圆的x轴将按此属性的值旋转，指定为0到360度角。
x（浮点）：线的目标x位置。
y（浮点）：线的目标y位置。

- CubicToPath的子元素

CubicTo子元素描述了从路径当前位置到x和y属性指定的位置的光滑贝塞尔，使用其各自属性指定的两个控制点。

属性
control-1-x（以浮点数为单位）：曲线第一个控制点的x坐标。
control-1-y（浮点数）：曲线第一个控制点的y坐标。
control-2-x（浮点数）：曲线第二个控制点的x坐标。
control-2-y（浮点数）：曲线第二个控制点的y坐标。
x（浮点数）：曲线的目标x位置。
y（浮点数）：曲线的目标y位置。

- QuadraticToPath的子元素

QuadraticTo子元素使用control-x和control-y属性指定的控制点，描述了从路径当前位置到x和y属性指定位置的光滑贝塞尔。

属性
control-x（浮点数）：曲线控制点的x坐标。
control-y（以浮点数为单位）：曲线控制点的y坐标。
x（浮点数）：曲线的目标x位置。
y（浮点数）：曲线的目标y位置。

- ClosePath的子元素

Close元素关闭当前子路径，并从当前位置到路径的开头画一条直线。

#### 4.2.7 PopupWindow

使用此元素显示弹出窗口，如工具提示或弹出菜单。

注意：不允许从PopupWindow外部访问弹出窗口中元素的属性。

**函数**

show()在屏幕上显示弹出窗口。

**示例**

```
export component Example inherits Window {
    width: 100px;
    height: 100px;

    popup := PopupWindow {
        Rectangle { height:100%; width: 100%; background: yellow; }
        x: 20px; y: 20px; height: 50px; width: 50px;
    }

    TouchArea {
        height:100%; width: 100%;
        clicked => { popup.show(); }
    }
}
1234567891011121314
```

#### 4.2.8 Rectangle

默认情况下，Rectangle只是一个不显示任何内容的空项。通过设置颜色或配置边框，可以在屏幕上绘制矩形。

当不是布局的一部分时，其宽度和高度默认为父元素的100%。

**属性**

- background（画笔）：这个Rectangle的背景画笔，通常是一种颜色。（默认值：transparent）
- border-color（在画笔中）：边框的颜色。（默认值：transparent）
- border-radius（长度）：半径的大小。（默认值：0）
- border-width（长度）：边框的宽度。（默认值：0）
- clip（在bool中）：默认情况下，当一个元素更大或处于另一个元素之外时，它仍然显示。当此属性设置为true，此Rectangle的子项将被剪切到矩形的边框。（默认值：false）

**示例**

```
export component Example inherits Window {
    width: 270px;
    height: 100px;

    Rectangle {
        x: 10px;
        y: 10px;
        width: 50px;
        height: 50px;
        background: blue;
    }

    // Rectangle with a border
    Rectangle {
        x: 70px;
        y: 10px;
        width: 50px;
        height: 50px;
        background: green;
        border-width: 2px;
        border-color: red;
    }

    // Transparent Rectangle with a border and a radius
    Rectangle {
        x: 140px;
        y: 10px;
        width: 50px;
        height: 50px;
        border-width: 4px;
        border-color: black;
        border-radius: 10px;
    }

    // A radius of width/2 makes it a circle
    Rectangle {
        x: 210px;
        y: 10px;
        width: 50px;
        height: 50px;
        background: yellow;
        border-width: 2px;
        border-color: blue;
        border-radius: self.width/2;
    }
}

12345678910111213141516171819202122232425262728293031323334353637383940414243444546
```

#### 4.2.9 TextInput

TextInput是一个较低级别的项目，显示文本并允许输入文本。

当不是布局的一部分时，当未指定时，其宽度或高度默认为父元素的100%。

**属性**

- color（画笔中）：文本的颜色（默认值：取决于样式）
- font-family（字符串）：选择用于渲染文本的字体家族的名称。
- font-size（长度）：文本的字体大小。
- font-weight（in int）：字体的重量。值范围从100（最轻）到900（最厚）。400是正常重量。
- has-focus（out bool）：TextInput聚焦时将其设置为true。只有这样，它才会收到KeyEvent。
- horizontal-alignment（在枚举TextHorizontalAlignment）：文本的水平对齐。
- input-type（在枚举InputType）：使用此配置TextInput以编辑特殊输入，例如密码字段。（默认值：text）
- letter-spacing（长度）：字母间距允许更改字形之间的间距。正值增加间距，负值减少距离。（默认值：0）
- read-only（在bool中）：设置为true时，通过键盘和鼠标进行文本编辑将被禁用，但选择文本以及以编程方式编辑文本仍然被启用。（默认值：false）
- selection-background-color（颜色）：选择的背景颜色。
- selection-foreground-color（颜色）：选择的前景颜色。
- single-line（在bool中）：当设置为true时，文本始终呈现为一行，无论文本中是否有新的行分隔符。（默认值：true）
- text-cursor-width（长度）：文本光标的宽度。（默认值：在运行时由所选小部件样式提供）
- text（输入字符串）：用户渲染和可编辑的文本。
- vertical-alignment（在枚举TextVerticalAlignment）：文本的垂直对齐。
- wrap（在枚举TextWrap）：文本输入的包装方式。只有当single-line假时才有意义。（默认值：no-wrap）

**函数**

- focus()调用此函数来聚焦文本输入，并使其接收未来的键盘事件。

**回调**

- accepted()：按下回车键时调用。
- cursor-position-changed(Point)：光标被移动到新的（x，y）位置。
- edited()：当文本因用户修改而更改时调用。

**示例**

```
export component Example inherits Window {
    width: 270px;
    height: 100px;

    TextInput {
        text: "Replace me with a name";
    }
}
12345678
```

#### 4.2.10 Text

Text元素负责渲染文本。除了指定要渲染的文本的text属性外，它还允许通过font-family、font-size、font-weight和颜色属性配置不同的视觉方面。

Text元素可以将长文本分解为多行文本。text属性字符串中的换行字符（\n）将触发手动换行符。对于自动换行，您需要将thewrap属性设置为no-wrap以外的值，并且为Text元素指定width和height很重要，以便知道在哪里中断。建议将Text元素放置在布局中，并让它根据可用的屏幕空间和文本本身设置width和height。

**属性**

- color（在画笔中）：文本的颜色。（默认值：取决于样式）
- font-family（字符串）：选择用于渲染文本的字体家族的名称。
- font-size（长度）：文本的字体大小。
- font-weight（in int）：字体的重量。值范围从100（最轻）到900（最厚）。400是正常重量。
- horizontal-alignment（在枚举TextHorizontalAlignment）：文本的水平对齐。
- letter-spacing（长度）：字母间距允许更改字形之间的间距。正值增加间距，负值减少距离。（默认值：0）
- overflow（在枚举TextOverflow）：当文本溢出时会发生什么（默认值：剪辑）。
- text（字符串）：呈现的文本。
- vertical-alignment（在枚举TextVerticalAlignment）：文本的垂直对齐。
- wrap（在枚举中TextWrap）：文本包装方式（默认值：no-wrap）。

**示例**

此示例使用默认字体以红色显示文本“Hello World”：

```
export component Example inherits Window {
    width: 270px;
    height: 100px;

    Text {
        x:0;y:0;
        text: "Hello World";
        color: red;
    }
}
12345678910
```

此示例通过设置wrap策略并分配有限的width和足够的height来将较长的文本段落分解为多行：

```
export component Example inherits Window {
    width: 270px;
    height: 300px;

    Text {
        x:0;
        text: "This paragraph breaks into multiple lines of text";
        wrap: word-wrap;
        width: 150px;
        height: 100%;
    }
}
123456789101112
```

#### 4.2.11 TouchArea

使用TouchArea来控制当它覆盖的区域被触摸或使用鼠标交互时会发生什么。

当不是布局的一部分时，其宽度或高度默认为父元素的100%。

**属性**

- has-hover（out bool）：当鼠标在它上面时，TouchArea将其设置为true。
- mouse-cursor（在枚举MouseCursor）：鼠标悬停TouchArea时鼠标光标类型。
- mouse-x，mouse-y（外长）：由TouchArea设置为鼠标在其中的位置。
- pressed-x，pressed-y（长度）：由TouchArea设置为鼠标上次按下时的位置。
- pressed（out bool）：当鼠标按在TouchArea上时，将其设置为true。

**回调**

- clicked()：单击时调用：按下鼠标，然后释放此元素。
- moved()：鼠标已被移动。只有在按下鼠标时才会调用。
- pointer-event(PointerEvent)：按下或松开按钮时调用。

**示例**

```
export component Example inherits Window {
    width: 200px;
    height: 100px;
    area := TouchArea {
        width: parent.width;
        height: parent.height;
        clicked => {
            rect2.background = #ff0;
        }
    }
    Rectangle {
        x:0;
        width: parent.width / 2;
        height: parent.height;
        background: area.pressed ? blue: red;
    }
    rect2 := Rectangle {
        x: parent.width / 2;
        width: parent.width / 2;
        height: parent.height;
    }
}

12345678910111213141516171819202122
```

#### 4.2.12 VerticalLayout和HorizontalLayout

这些布局将他们的孩子垂直或水平地放在一起。元素的大小可以用width或height属性固定，或者如果没有设置，则将由尊重最小和最大尺寸以及拉伸系数的布局来计算。

**属性**

- spacing（长度）：布局中元素之间的距离。
- padding（长度）：布局中的填充物。
- padding-left，padding-right，padding-top和padding-bottom（长度）：设置这些属性以覆盖特定侧面的填充。
- alignment（在枚举LayoutAlignment）：设置对齐。匹配CSS flex框。

**示例**

```
export component Foo inherits Window {
    width: 200px;
    height: 100px;
    HorizontalLayout {
        spacing: 5px;
        Rectangle { background: red; width: 10px; }
        Rectangle { background: blue; min-width: 10px; }
        Rectangle { background: yellow; horizontal-stretch: 1; }
        Rectangle { background: green; horizontal-stretch: 2; }
    }
}
1234567891011
```

#### 4.2.13 Window

Window是屏幕上可见的元素树的根。

Window几何形状将受到其布局约束的限制：设置width将导致固定宽度，窗口管理器将尊重min-width和max-width因此窗口无法调整大小或大小。初始宽度可以使用preferred-width属性进行控制。这同样适用于Windows的高度。

**属性**

- always-on-top（in bool）：窗口是否应该放在支持它的窗口管理器上的所有其他窗口之上。
- background（在画笔中）：Window的背景画笔。（默认值：取决于样式）
- default-font-family（字符串）：在此窗口内的文本元素中用作默认的字体系列，没有设置其font-family属性。
- default-font-size（内长）：在此窗口内的文本元素中用作默认的字体大小，没有设置其font-size属性。此属性的值也构成了相对字体大小的基础。
- default-font-weight（在int中）：在此窗口内的文本元素中用作默认的字体权重，这些元素没有其font-weight属性集。值范围从100（最轻）到900（最厚）。400是正常重量。
- icon（在图像中）：标题栏或支持它的窗口管理器上的任务栏中显示的窗口图标。
- no-frame（in bool）：窗口是否应该是无边框/无框的。
- title（字符串）：标题栏中显示的窗口标题。

### 4.3 内置枚举

可以使用枚举的名称和以点分隔的值的名称来引用枚举值（例如：TextHorizontalAlignment.left）。在该枚举类型的绑定中，或者如果回调的返回值是该枚举，则可以省略枚举的名称。每个枚举类型的默认值始终是第一个值。

#### 4.3.1 AccessibleRole

此枚举表示可accessible-role属性的不同值，用于描述元素在屏幕阅读器等辅助技术中的作用。

- none：该元素无法访问。
- button：元素是一个Button或表现得像一个按钮。
- checkbox：元素是CheckBox或表现得像复选框。
- combobox：该元素是ComboBox或行为像一个。
- slider：元素是Slider或行为像滑块。
- spinbox：该元素是SpinBox或行为像一个。
- tab：元素是Tab或行为像制表符。
- text：Text元素的作用。它会自动应用。

#### 4.3.2 DialogButtonRole

此枚举表示dialog-button-role属性的值，该属性可以添加到Dialog的任何元素中，以将该项目放在按钮行中，其确切位置取决于角色和平台。

- none：这不是一个用于进入最下行的按钮
- accept：这是点击接受对话框的主按钮的作用。例如“好的”或“是的”
- reject：这是主按钮单击以拒绝对话框的作用。例如“取消”或“否”
- apply：这是“应用”按钮的作用
- reset：这是“重置”按钮的作用
- help：这是“帮助”按钮的作用
- action：这是执行其他操作的任何其他按钮的角色。

#### 4.3.3 EventResult

此枚举描述了事件是否被事件处理程序拒绝或接受。

- reject：事件被此事件处理程序拒绝，然后可能由父项处理
- accept：该活动已被接受，将不再进一步处理

#### 4.3.4 FillRule

这个枚举描述了决定路径所描述的形状内部的不同方式。

- nonzero：SVG中定义的“非零”填充规则。
- evenodd：SVG中定义的“偶数”填充规则

#### 4.3.5ImageFit

该枚举定义了源图像如何融入Image元素。

- fill：缩放和拉伸源图像，以适应Image元素的宽度和高度。
- contain：源图像被缩放以适应Image元素的尺寸，同时保留宽高比。
- cover：源图像被缩放以覆盖到Image元素的尺寸，同时保留宽高比。如果源图像的宽高比与元素的宽高比不匹配，那么图像将被裁剪以适合。

#### 4.3.6 ImageRendering

此枚举指定了源图像的缩放方式。

- smooth：使用线性插值算法对图像进行缩放。
- pixelated：使用最近邻算法缩放图像。

#### 4.3.7 InputType

此枚举用于定义输入字段的类型。目前，这只能区分文本和密码输入，但将来可以扩展它，以定义应该显示哪种类型的虚拟键盘，例如。

- text：默认值。这将正常呈现所有字符
- password：这将呈现所有字符，其字符默认为“*”

#### 4.3.8 LayoutAlignment

表示HorizontalBox、VerticalBox、HorizontalLayout或VerticalLayout的对齐属性的枚举。

- stretch：使用布局中所有元素的最小大小，根据*-stretch在所有元素之间分配剩余空间。
- center：使用所有元素的首选大小，在第一个元素之前和最后一个元素之后均匀分布剩余空间。
- start：使用所有元素的首选大小，将剩余空间放在最后一个元素之后。
- end：对所有元素使用首选大小，将剩余空间放在第一个元素之前。
- space-between：对所有元素使用首选大小，在元素之间均匀地分配剩余空间。
- space-around：使用所有元素的首选大小，在第一个元素之前、最后一个元素之后和元素之间均匀分布剩余空间。

#### 4.3.9 MouseCursor

这个枚举表示不同类型的鼠标光标。它是CSS中可用的鼠标光标的子集。有关详细信息和象形图，请参阅光标的MDN文档。根据后端和使用的操作系统，单向调整大小光标可能会被双向光标取代。

- default：系统默认光标。
- none：没有显示光标。
- help：指示帮助信息的光标。
- pointer：指向链接的指针。
- progress：该程序很忙，但仍然可以与之互动。
- wait：程序很忙。
- crosshair：十字准线。
- text：指示可选择文本的光标。
- alias：正在创建别名或快捷方式。
- copy：正在创建副本。
- move：有些东西需要移动。
- no-drop：有些东西不能在这里掉落。
- not-allowed：不允许采取行动
- grab：有些东西是可抓的。
- grabbing：有东西被抓住了。
- col-resize：表示一列可以水平调整大小。
- row-resize：表示一行可以垂直调整大小。
- n-resize：单向向向北调整。
- e-resize：单向向东调整大小。
- s-resize：单向向调整南尺寸。
- w-resize：单向西调整大小。
- ne-resize：单向调整东北方向的大小。
- nw-resize：单向调整西北大小。
- se-resize：东南方向调整大小。
- sw-resize：单向调整西南大小。
- ew-resize：东西方向双向调整大小。
- ns-resize：双向调整大小。
- nesw-resize：双向调整东北-西南的大小。
- nwse-resize：双向调整西北-东南方向的大小。

#### 4.3.10PathEvent

PathEvent是一个描述路径组合的低级数据结构。通常，它是在编译时从更高级别的描述中生成的，例如SVG命令。

- begin：道路的起点。
- line：路径上的一条直线。
- quadratic：路径上的二次贝塞尔曲线。
- cubic：路径上的立方贝塞尔曲线。
- end-open：仍然开放的道路的尽头。
- end-closed：一条封闭的小路的尽头。

#### 4.3.11 PointerEventButton

此枚举描述了指针事件的不同类型的按钮，通常在鼠标或铅笔上。

- other：一个没有左、右或中间的按钮。例如，这用于鼠标上带有多个按钮的第四个按钮。
- left：左键。
- right：右边的按钮。
- middle：中央按钮。

#### 4.3.12 PointerEventKind

枚举报告了事件中PointerEventButton发生了什么

- cancel：行动被取消了。
- down：按下了按钮。
- up：按钮被释放了。

#### 4.3.13 SortOrder

此枚举表示sort-order属性的不同值。它用于按列对StandardTableView进行排序。

- unsorted：该列是未排序的。
- ascending：该列按升序排序。
- descending：该列按降序排序。

#### 4.3.14 StandardButtonKind

使用此枚举将标准按钮添加到Dialog。这些StandardButton的外观和定位取决于应用程序运行的环境（OS、UI环境等）。

- ok：一个“确定”按钮，接受Dialog，单击时将其关闭。
- cancel：拒绝Dialog的“取消”按钮，单击时将其关闭。
- apply：一个“应用”按钮，应该接受来自Dialog的值，而无需关闭它。
- close：一个“关闭”按钮，它应该在不查看值的情况下关闭Dialog。
- reset：一个“重置”按钮，该按钮应将Dialog重置为初始状态。
- help：一个“帮助”按钮，点击时应该会调出上下文相关文档。
- yes：“是”按钮，用于确认操作。
- no：“否”按钮，用于拒绝操作。
- abort：“中止”按钮，用于中止操作。
- retry：一个“重试”按钮，用于重试失败的操作。
- ignore：一个“忽略”按钮，用于忽略失败的操作。

#### 4.3.15 TextHorizontalAlignment

此枚举描述了文本沿Text元素水平轴对齐的不同类型的内容。

- left：文本将与包含框的左边缘对齐。
- center：文本将在包含框中水平居中。
- right：文本将排列在包含框的右侧。

#### 4.3.16TextOverflow

此枚举描述了如果文本太宽而无法适应Text宽度，文本的显示方式。

- clip：文本将被简单地剪切。
- elide：文本将被省略为…

#### 4.3.17 TextVerticalAlignment

此枚举描述了文本沿Text元素垂直轴对齐的不同类型的内容。

- top：文本将与包含框的顶部对齐。
- center：文本将垂直居中于包含框中。
- bottom：文本将与包含框的底部对齐。

#### 4.3.18 TextWrap

此枚举描述了文本太宽而无法适应Text宽度时如何包装。

- no-wrap：文本不会包装，而是会溢出。
- word-wrap：文本将以单词边界包装。

### 4.4 内置函数

- animation-tick() -> duration
  这个函数返回一个单调递增的时间，可以用于动画。从绑定中调用此函数将不断地重新计算绑定。它可以这样使用：`x: 1000px + sin(animation-tick() / 1s * 360°)* 100px;`或者`y: 20px * mod(animation-tick()， 2s) / 2s`

```
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

123456789101112131415161718
```

- debug(string) -> string
  调试函数将字符串作为参数并打印出来

### 4.5 内置全局单例

TextInputInterface
TextInputInterface.text-input-focused属性可用于确定TextInput元素是否具有焦点。如果您正在实现自己的虚拟键盘，此属性是虚拟键盘是否应该显示或隐藏的指示器。

**属性**

- text-input-focused（bool）：如果TextInput元素有焦点，则为真；否则为假。

**示例**

```
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
123456789101112131415
```

### 4.6 内置命名空间

### 4.7 内置结构体

#### 4.7.1 KeyboardModifiers

此结构作为KeyEvent的一部分生成，以指示在生成密钥事件期间按下了哪些修饰键。包含字段:

- control（bool）：如果按下控制键，则true。在macOS上，这与命令键相对应。
- alt（bool）：如果按下alt键，则true。
- shift（bool）：如果按下Shift键，则true。
- meta（bool）：如果在Windows上按下Windows键，或在macOS上按下控制键，则true。

#### 4.7.2 KeyEvent

此结构被生成并传递给FocusScope元素的按键按下和释放回调。包含字段：

- text（字符串）：键的字符串表示
- modifiers（键盘修饰符）：事件期间按下的键盘修饰符

#### 4.7.3 Point

这个结构表示一个带有x和y坐标的点。包含字段：

- x（长度）
- y（长度）

#### 4.7.4 PointerEvent

此结构被生成并传递给TouchArea元素的pointer-event回调。包含字段：

- kind（enum PointerEventKind）：事件的类型：以下之一
- down：按下了按钮。
- up：按钮被释放了。
- cancel：另一个元素或窗户抓住了抓斗。这适用于所有按下的按钮，该button与此无关。
- button（enum PointerEventButton）：按下或松开的按钮。left、right、middlenone。

#### 4.7.5 StandardListViewItem

StandardListViewItem用于在StandardListView和StandardTableView中显示项目。包含字段：

- text（字符串）：描述项目的文本。

#### 4.7.6 TableColumn

TableColumn用于定义TableView的列和列标题。包含字段：

- title（字符串）：描述列标题。
- min-width（长度）：用列定义最小值。
- width（长度）：列的当前宽度。
- horizontal-stretch（浮动）：定义柱子的水平拉伸。
- sort-order（SortOrder）：描述列的排序顺序。

### 4.8 部件

Slint提供了一系列内置小部件，可以从"std-widgets.slint"导入。

小部件的外观取决于所选的样式。以下样式可用：

- fluent：流畅的风格实现了流畅的设计系统。
- material：材料风格实现了材料设计。
- native：原生风格类似于它们所使用平台的原生控件的外观。这特别包括对macOS和Windows上控件的外观和感觉的支持。仅当您的系统上安装了Qt时，此样式才可用。

有关如何选择样式的详细信息，请参阅选择小部件样式。如果没有选择样式，则默认为native样式。如果native不可用，则默认是fluent。

所有小部件都支持内置元素共有的所有属性。

#### 4.8.1 AboutSlint

此元素显示“Made with Slint”徽章。

```
import { AboutSlint } from "std-widgets.slint";
export component Example inherits Window {
    width: 128px;
    height: 128px;
    AboutSlint {
    }
}
1234567
```

#### 4.8.2 Button

一个简单的按钮。常见的按钮类型也可以使用StandardButton创建。

**属性**

- checkable（在bool中）：显示按钮是否可以检查。这使得checked的属性可能变得true。
- checked（inout bool）：显示按钮是否已选中。需要checkable才能true工作。
- enabled：（在bool中）：默认为true。当错误时，按钮无法按下
- has-focus：（out bool）：当按钮有键盘焦点时设置为true。
- icon（在图像中）：按钮中要显示的图像。请注意，并非所有样式都支持绘图图标。
- pressed：（out bool）：按下按钮时设置为true。
- text（字符串）：写在按钮中的文本。

**回调**

- clicked()

**示例**

```
import { Button, VerticalBox } from "std-widgets.slint";
export component Example inherits Window {
    VerticalBox {
        Button {
            text: "Click Me";
            clicked => { self.text = "Clicked"; }
        }
    }
}
123456789
```

#### 4.8.3 CheckBox

**属性**

- checked：（inout bool）：是否选中复选框。
- enabled：（在bool中）：默认为true。当为假时，无法按下复选框
- has-focus：（out bool）：当复选框具有键盘焦点时设置为true。
- text（字符串）：写在复选框旁边的文本。

**回调**

- toggled()：复选框值已更改

**示例**

```
import { CheckBox } from "std-widgets.slint";
export component Example inherits Window {
    width: 200px;
    height: 25px;
    CheckBox {
        width: parent.width;
        height: parent.height;
        text: "Hello World";
    }
}
12345678910
```

#### 4.8.4 ComboBox

一个按钮，单击时会打开一个弹出窗口来选择一个值。

**属性**

- current-index：（in-out int）：所选值的索引（如果没有选择值，则为-1）
- current-value：（输入字符串）：当前选定的文本
- enabled：（在bool中）：默认为true。当错误时，组合框无法与之交互
- has-focus：（out bool）：当组合框具有键盘焦点时，设置为true。
- model（在[字符串]中）：可能的值列表

**回调**

- selected(string)：从组合框中选择一个值。参数是当前选择的值。

**示例**

```
import { ComboBox } from "std-widgets.slint";
export component Example inherits Window {
    width: 200px;
    height: 130px;
    ComboBox {
        y: 0px;
        width: self.preferred-width;
        height: self.preferred-height;
        model: ["first", "second", "third"];
        current-value: "first";
    }
}
123456789101112
```

#### 4.8.5 GridBox

GridBox是一个GridLayout，其中间距和填充值取决于样式，而不是默认为0。

**属性**

- enabled：（在bool中）：默认为true。当错误时，组框无法与之交互
- title（字符串）：写成组框标题的文本。

**示例**

```
import { GroupBox } from "std-widgets.slint";
export component Example inherits Window {
    width: 200px;
    height: 100px;
    GroupBox {
        title: "A Nice Title";
        Text {
            text: "Hello World";
            color: blue;
        }
    }
}
123456789101112
```

#### 4.8.6 HorizontalBox

HorizontalBox是一个HorizontalLayout，其中间距和填充值取决于样式，而不是默认为0。

#### 4.8.7 LineEdit

用于输入单行文本的小部件。请参阅TextEdit，了解能够处理几行文本的小部件。

**属性**

- enabled：（在bool中）：默认为true。当为假时，无法输入任何内容，选择文本仍然启用，以及以编程方式编辑文本（默认值：false）
- font-size（长度）：输入文本字体的大小
- has-focus：（out bool）：当行编辑当前具有焦点时设置为true
- horizontal-alignment（在枚举TextHorizontalAlignment）：文本的水平对齐。
- input-type（在枚举InputType中）：允许特殊输入查看属性的方式，如密码字段（默认值：text）。
- placeholder-text：（字符串）：当编辑字段中没有文本时显示的占位符文本
- read-only（in bool）：当设置为true，通过键盘和鼠标进行文本编辑将被禁用，但
- text（输入输出字符串）：正在编辑的文本

**回调**

- accepted(string)：按了回车键
- edited(string)：当文本因用户修改而更改时发出

**示例**

```
import { LineEdit } from "std-widgets.slint";
export component Example inherits Window {
    width: 200px;
    height: 25px;
    LineEdit {
        font-size: 14px;
        width: parent.width;
        height: parent.height;
        placeholder-text: "Enter text here";
    }
}
1234567891011
```

#### 4.8.8 ListView

ListView就像Scrollview，但它应该有一个for元素，并且内容会自动在列表中布局。元素只有在可见时才会实例化

**属性**

和ScrollView相同。

**示例**

```
import { ListView } from "std-widgets.slint";
export component Example inherits Window {
    width: 150px;
    height: 150px;
    ListView {
        width: 150px;
        height: 150px;
        for data in [
            { text: "Blue", color: #0000ff, bg: #eeeeee},
            { text: "Red", color: #ff0000, bg: #eeeeee},
            { text: "Green", color: #00ff00, bg: #eeeeee},
            { text: "Yellow", color: #ffff00, bg: #222222 },
            { text: "Black", color: #000000, bg: #eeeeee },
            { text: "White", color: #ffffff, bg: #222222 },
            { text: "Magenta", color: #ff00ff, bg: #eeeeee },
            { text: "Cyan", color: #00ffff, bg: #222222 },
        ] : Rectangle {
            height: 30px;
            background: data.bg;
            width: parent.width;
            Text {
                x: 0;
                text: data.text;
                color: data.color;
            }
        }
    }
}

12345678910111213141516171819202122232425262728
```

#### 4.8.9 ScrollView

滚动视图包含一个比视图更大的视口，可以滚动。它有滚动条可以与之交互。视口宽度和视口高度会自动计算，以创建可视视图，除非使用for循环填充元素。在这种情况下，视口宽度和视口高度不是自动计算的，必须手动设置才能滚动。未来可能会添加使用循环时自动计算视口宽度和视口高度的能力，并在第407期中进行跟踪。

**属性**

- enabled（在bool中）：用于将框架呈现为禁用或启用，但不会更改小部件的行为。
- has-focus（in-out bool）：用于将帧呈现为聚焦或未聚焦，但不会改变小部件的行为。
- viewport-width和viewport-height（入外长度）：视口的width和length属性
- viewport-x和viewport-y（入外长度）：视口的x和y属性。通常这些是负面的
- visible-width和visible-height（外长）：ScrollView可见区域的大小（不包括滚动条）

**示例**

```
import { ScrollView } from "std-widgets.slint";
export component Example inherits Window {
    width: 200px;
    height: 200px;
    ScrollView {
        width: 200px;
        height: 200px;
        viewport-width: 300px;
        viewport-height: 300px;
        Rectangle { width: 30px; height: 30px; x: 275px; y: 50px; background: blue; }
        Rectangle { width: 30px; height: 30px; x: 175px; y: 130px; background: red; }
        Rectangle { width: 30px; height: 30px; x: 25px; y: 210px; background: yellow; }
        Rectangle { width: 30px; height: 30px; x: 98px; y: 55px; background: orange; }
    }
}
123456789101112131415
```

#### 4.8.10 Slider

**属性**

- enabled：（在bool中）：默认为true。如果启用为false，则无法与滑块交互。
- has-focus：（out bool）：当滑块当前具有焦点时设置为true
- value（进出浮点数）：值。
- minimum（以浮点数为单位）：最小值（默认值：0）
- maximum（以浮点数计）：最大值（默认值：100）

**回调**

- changed(float)：值已更改

**示例**

```
import { Slider } from "std-widgets.slint";
export component Example inherits Window {
    width: 200px;
    height: 25px;
    Slider {
        width: parent.width;
        height: parent.height;
        value: 42;
    }
}
12345678910
```

#### 4.8.11 SpinBox

**属性**

- enabled：（在bool中）：默认为true。如果启用为假，则无法与旋转盒交互。
- has-focus：（out bool）：当旋转盒当前具有焦点时，设置为true
- value（in-out int）：值。
- minimum（in int）：最小值（默认值：0）。
- maximum（in int）：最大值（默认值：100）。

**示例**

```
import { SpinBox } from "std-widgets.slint";
export component Example inherits Window {
    width: 200px;
    height: 25px;
    SpinBox {
        width: parent.width;
        height: parent.height;
        value: 42;
    }
}
12345678910
```

#### 4.8.12 StandardButton

StandardButton看起来像一个按钮，但它可以使用预定义的kind之一，而不是使用text和icon进行自定义，文本和图标将取决于样式。

**属性**

- enabled：（在bool中）：默认为true。当错误时，按钮无法按下
- has-focus：（out bool）：当按钮当前具有焦点时设置为true
- kind（在枚举StandardButtonKind中）：按钮类型，okcancel，apply，close，reset，help，yes，no,abort，retry或ignore
- pressed：（out bool）：按下按钮时设置为true。

**回调**

- clicked()

**示例**

```
import { StandardButton, VerticalBox } from "std-widgets.slint";
export component Example inherits Window {
  VerticalBox {
    StandardButton { kind: ok; }
    StandardButton { kind: apply; }
    StandardButton { kind: cancel; }
  }
}
12345678
```

#### 4.8.13 StandardListView

与ListView类似，但具有默认委托和model属性，该属性是StandardListViewItem类型的模型。

**属性**

与ListView相同，此外：

- current-item（in-out int）：当前活动项目的索引。-1表示没有被选中，这是默认的
- model（在StandardListViewItem中）：模型

**功能**

set-current-item(*index: int*)：设置当前项目并将其带入视图

**示例**

```
import { StandardListView } from "std-widgets.slint";
export component Example inherits Window {
    width: 150px;
    height: 150px;
    StandardListView {
        width: 150px;
        height: 150px;
        model: [ { text: "Blue"}, { text: "Red" }, { text: "Green" },
            { text: "Yellow" }, { text: "Black"}, { text: "White"},
            { text: "Magenta" }, { text: "Cyan" },
        ];
    }
}
12345678910111213
```

#### 4.8.14 StandardTableView

StandardTableView表示带有列和行的数据表。单元格组织在一个模型中，其中每行都是[StandardListViewItem]的模型。

**属性**
与ListView相同，此外：

- current-sort-column（out int）：表示已排序的列。-1表示没有排序列。
- columns（in-out [TableColumn]）：定义表列的模型。
- rows（[[StandardListViewItem]]）：定义表行的模型。

**回调**

- sort-ascending(int)：如果模型应按给定列按升序排序，则发出。
- sort-descending(int)：如果模型应按给定列降序排序，则发出。

**示例**

```
import { StandardTableView } from "std-widgets.slint";
export component Example inherits Window {
    width: 230px;
    height: 200px;
    StandardTableView {
        width: 230px;
        height: 200px;
        columns: [
            { title: "Header 1" },
            { title: "Header 2" },
        ];
        rows: [
            [
                { text: "Item 1" }, { text: "Item 2" },
            ],
            [
                { text: "Item 1" }, { text: "Item 2" },
            ],
            [
                { text: "Item 1" }, { text: "Item 2" },
            ]
        ];
    }
}

123456789101112131415161718192021222324
```

#### 4.8.15 TabWidget

TabWidget是一组选项卡的容器。它只能将Tab元素作为子元素，并且一次只能看到一个选项卡。

**属性**

- content-min-width和content-min-height（外长）：内容的最小宽度和高度
- content-width和content-height（外长）：内容的宽度和高度
- content-x和content-y（外长）：内容的x和y位置
- current-focused（在int中）：具有焦点的选项卡的索引。此选项卡可能可见，也可能不可见。
- current-index（in int）：当前可见选项卡的索引
- tabbar-preferred-width和tabbar-preferred-height（长度）：制表栏的首选宽度和高度
- tabbar-width和tabbar-height（外长）：标签栏的宽度和高度
- tabbar-x和tabbar-y（外长）：标签栏的x和y位置
- Tab元素的属性
- current-focused（out int）：此选项卡的索引此时有焦点，如果没有焦点，则为-1
- enabled：（在bool中）：默认为true。当错误时，该选项卡无法激活
- icon（在图像中）：选项卡上的图像
- num-tabs（out int）：当前选项卡的数量TabBar
- tab-index（out int）：此选项卡的索引
- title（字符串）：写在选项卡上的文本

**示例**

```
import { TabWidget } from "std-widgets.slint";
export component Example inherits Window {
    width: 200px;
    height: 200px;
    TabWidget {
        Tab {
            title: "First";
            Rectangle { background: orange; }
        }
        Tab {
            title: "Second";
            Rectangle { background: pink; }
        }
    }
}
123456789101112131415
```

#### 4.8.16 TextEdit

类似于LineEdit`，但可用于输入几行文本

注意：当前的实现只实现了很少的基本快捷方式。未来版本将实现更多快捷方式：https://github.com/slint-ui/slint/issues/474

**属性**

- font-size（长度）：输入文本字体的大小
- text（输入输出字符串）：正在编辑的文本
- has-focus：（in_out bool）：当小部件当前具有焦点时，设置为true
- enabled：（在bool中）：默认为true。当错误时，什么都不能进入
- read-only（在bool中）：设置为true时，通过键盘和鼠标进行文本编辑将被禁用，但选择文本以及以编程方式编辑文本仍然被启用（默认值：false）
- wrap（在枚举TextWrap中）：文本包装的方式（默认：word-wrap）。
- horizontal-alignment（在枚举TextHorizontalAlignment）：文本的水平对齐。

**回调**

- edited(string)：当文本因用户修改而更改时发出

**示例**

```
import { TextEdit } from "std-widgets.slint";
export component Example inherits Window {
    width: 200px;
    height: 200px;
    TextEdit {
        font-size: 14px;
        width: parent.width;
        height: parent.height;
        text: "Lorem ipsum dolor sit amet,\n consectetur adipisici elit";
    }
}
1234567891011
```

#### 4.8.17 VerticalBox

VerticalBox是一个VerticalLayout，其中间距和填充值取决于样式，而不是默认为0。

选择小部件样式
小部件样式是在项目编译时选择的。细节取决于您使用Slint的编程语言。

使用Slint with Rust时选择小部件样式：
将Slint与C++一起使用时选择小部件样式：
使用slint-viewer预览设计时选择小部件样式
通过设置SLINT_STYLE环境变量或传递带有–style参数的样式名称来选择样式：

slint-viewer --style material /path/to/design.slint
使用Slint Visual Studio代码扩展在预览设计时选择小部件样式
通过首先打开Visual Studio Code设置编辑器来选择样式：

在Windows/Linux上-文件>首选项>设置
在macOS上-代码>首选项>设置
然后在扩展>Slint>预览：样式下输入样式名称

使用通用LSP流程预览设计时选择小部件样式
在启动进程之前，通过设置SLINT_STYLE环境变量来选择样式。或者，如果您的IDE集成允许传递命令行参数，您可以通过–style指定样式。

## 5 示例

### 5.1 开始

**可点击的按钮**

```
import { VerticalBox, Button } from "std-widgets.slint";
export component Recipe inherits Window {
    in-out property <int> counter: 0;
    VerticalBox {
        button := Button {
            text: "Button, pressed " + root.counter + " times";
            clicked => {
                root.counter += 1;
            }
        }
    }
}
123456789101112
```

在第一个示例中，您看到了Slint语言的基础知识：

- 我们使用import语句从标准库中导入VerticalBox布局和Button小部件。此语句可以导入小部件或您在不同文件中声明的您自己的组件。您无需导入内置元素，如Window或Rectangle。
- 我们使用component关键字声明Recipe组件。Recipe继承自Window，并具有元素：带有一个按钮的布局（VerticalBox）。
- 您可以使用元素的名称实例化元素，然后使用一对大括号（带有可选内容）。您可以使用:=为特定元素分配名称
- 元素具有属性。使用:设置属性值。在这里，我们分配一个绑定，通过连接一些字符串文字来计算字符串，并将counter属性分配给Buttontext属性。
- 您可以用property <…>为任何元素声明自定义属性。属性需要有类型，并且可以有默认值和访问说明符。private、in、out或in-out等访问说明符定义了外部元素如何与属性交互。Private是默认值，它阻止任何外部元素访问该属性。在本例中，counter属性是自定义的。
- 元素也可以有回调。在这种情况下，我们用=>{…}。
- 如果绑定的任何属性依赖于更改，则会自动重新评估属性绑定。每当counter发生变化时，按钮的text绑定都会自动重新计算。

**对本机代码中的按钮点击做出反应**

此示例使用本机代码增加计数器：

```
import { VerticalBox, Button } from "std-widgets.slint";
export component Recipe inherits Window {
    in-out property <int> counter: 0;
    callback button-pressed <=> button.clicked;
    VerticalBox {
        button := Button {
            text: "Button, pressed " + root.counter + " times";
        }
    }
}
12345678910
```

<=>语法将两个回调绑定在一起。在这里，新的button-pressed回调绑定到button.clicked。

主组件的根元素将所有非private属性和回调公开到本机代码。

在Slint中，-和_在所有标识符中都是等价和可互换的。这在本机代码中有所不同：大多数编程语言禁止-在标识符中，所以-被替换为_。

- Rust代码

出于技术原因，本例使用了import {Recipe}。宏。在实际代码中，您可以将整个Slint代码放在Slint中!宏，或者使用外部.slint文件和构建脚本。

```rust
slint::slint!(import { Recipe } from "docs/language/src/recipes/button_native.slint";);

fn main() {
    let recipe = Recipe::new().unwrap();
    let recipe_weak = recipe.as_weak();
    recipe.on_button_pressed(move || {
        let recipe = recipe_weak.upgrade().unwrap();
        let mut value = recipe.get_counter();
        value = value + 1;
        recipe.set_counter(value);
    });
    recipe.run().unwrap();
}
12345678910111213
```

Slint编译器会为Recipe组件的根元素的每个可访问属性生成一个带有getter (get_counter)和setter (set_counter)的结构体Recipe。它还为每个可访问的回调生成一个函数，如本例中的on_button_pressed。

Recipe结构实现了[slint::ComponentHandle]特征。组件管理强和弱参考计数，类似于Rc。我们调用as_weak函数来获得组件的弱句柄，我们可以将其移动到回调中。

我们不能在这里使用强句柄，因为这将形成一个循环：组件句柄拥有回调的所有权，回调本身拥有闭包捕获的变量的所有权。

- C++代码

在C++中，你可以写

```c++
#include "button_native.h"

int main(int argc, char **argv)
{
    auto recipe = Recipe::create();
    recipe->on_button_pressed([&]() {
        auto value = recipe->get_counter();
        value += 1;
        recipe->set_counter(value);
    });
    recipe->run();
}
123456789101112
```

CMake集成根据需要处理Slint编译器调用，这将解析.slint文件并生成button_native.h头。

此头文件包含一个Recipe类，其中包含每个可访问属性的getter和setter，以及为Recipe中每个可访问的回调设置回调的函数。在这种情况下，我们将使用get_counter，set_counter来访问counter属性，on_button_pressed来设置回调。

**使用属性绑定同步控件**

```
import { VerticalBox, Slider } from "std-widgets.slint";
export component Recipe inherits Window {
    VerticalBox {
        slider := Slider {
            maximum: 100;
        }
        Text {
            text: "Value: \{round(slider.value)}";
        }
    }
}
1234567891011
```

此示例介绍了Slider小部件。

它还引入了字符串文字中的插值：使用{…}将大括号之间的代码结果渲染为字符串。

### 5.2 动画

**动画元素的位置**

```
import { CheckBox } from "std-widgets.slint";
export component Recipe inherits Window {
    width: 200px;
    height: 100px;

    rect := Rectangle {
        x:0;
        y: 5px;
        width: 40px;
        height: 40px;
        background: blue;
        animate x {
            duration: 500ms;
            easing: ease-in-out;
        }
    }


    CheckBox {
        y: 25px;
        text: "Align rect to the right";
        toggled => {
            if (self.checked) {
                 rect.x = parent.width - rect.width;
            } else {
                 rect.x = 0px;
            }
        }
    }
}

123456789101112131415161718192021222324252627282930
```

布局自动定位元素。在本例中，我们使用x、y、width、height属性来手动定位元素。

注意指定动画的`animate x`块。每当属性发生变化时，它都会运行：要么是因为回调设置了属性，要么是因为其绑定值发生变化。

**动画序列**

```
import { CheckBox } from "std-widgets.slint";
export component Recipe inherits Window {
    width: 200px;
    height: 100px;

    rect := Rectangle {
        x:0;
        y: 5px;
        width: 40px;
        height: 40px;
        background: blue;
        animate x {
            duration: 500ms;
            easing: ease-in-out;
        }
        animate y {
            duration: 250ms;
            delay: 500ms;
            easing: ease-in;
        }
    }


    CheckBox {
        y: 25px;
        text: "Align rect bottom right";
        toggled => {
            if (self.checked) {
                 rect.x = parent.width - rect.width;
                 rect.y = parent.height - rect.height;
            } else {
                 rect.x = 0px;
                 rect.y = 0px;
            }
        }
    }
}

12345678910111213141516171819202122232425262728293031323334353637
```

此示例使用delay属性使一个动画一个动画运行一个动画。

### 5.3 声明

**将属性与状态相关联**

```
import { HorizontalBox, VerticalBox, Button } from "std-widgets.slint";

component Circle inherits Rectangle {
    width: 30px;
    height: 30px;
    border-radius: root.width / 2;
    animate x { duration: 250ms; easing: ease-in; }
    animate y { duration: 250ms; easing: ease-in-out; }
    animate background { duration: 250ms; }
}

export component Recipe inherits Window {
    states [
        left-aligned when b1.pressed: {
            circle1.x: 0px; circle1.y: 40px; circle1.background: green;
            circle2.x: 0px; circle2.y: 0px; circle2.background: blue;
        }
        right-aligned when b2.pressed: {
            circle1.x: 170px; circle1.y: 70px; circle1.background: green;
            circle2.x: 170px; circle2.y: 00px; circle2.background: blue;
        }
    ]

    VerticalBox {
        HorizontalBox {
            max-height: self.min-height;
            b1 := Button {
                text: "State 1";
            }
            b2 := Button {
                text: "State 2";
            }
        }
        Rectangle {
            background: root.background.darker(20%);
            width: 200px;
            height: 100px;

            circle1 := Circle { y:0; background: green; x: 85px; }
            circle2 := Circle { background: green; x: 85px; y: 40px; }
        }
    }
}

12345678910111213141516171819202122232425262728293031323334353637383940414243
```

**过渡**

```
import { HorizontalBox, VerticalBox, Button } from "std-widgets.slint";

component Circle inherits Rectangle {
    width: 30px;
    height: 30px;
    border-radius: root.width / 2;
}

export component Recipe inherits Window {
    states [
        left-aligned when b1.pressed: {
            circle1.x: 0px; circle1.y: 40px;
            circle2.x: 0px; circle2.y: 0px;
            in {
                animate circle1.x, circle2.x { duration: 250ms; }
            }
            out {
                animate circle1.x, circle2.x { duration: 500ms; }
            }
        }
        right-aligned when !b1.pressed: {
            circle1.x: 170px; circle1.y: 70px;
            circle2.x: 170px; circle2.y: 00px;
        }
    ]

    VerticalBox {
        HorizontalBox {
            max-height: self.min-height;
            b1 := Button {
                text: "Press and hold to change state";
            }
        }
        Rectangle {
            background: root.background.darker(20%);
            width: 250px;
            height: 100px;

            circle1 := Circle { y:0; background: green; x: 85px; }
            circle2 := Circle { background: blue; x: 85px; y: 40px; }
        }
    }
}

12345678910111213141516171819202122232425262728293031323334353637383940414243
```

### 5.4 布局

**垂直**

```
import { VerticalBox, Button } from "std-widgets.slint";
export component Recipe inherits Window {
    VerticalBox {
        Button { text: "First"; }
        Button { text: "Second"; }
        Button { text: "Third"; }
    }
}
12345678
```

**水平**

```
import { HorizontalBox, Button } from "std-widgets.slint";
export component Recipe inherits Window {
    HorizontalBox {
        Button { text: "First"; }
        Button { text: "Second"; }
        Button { text: "Third"; }
    }
}
12345678
```

**网格**

```
import { GridBox, Button, Slider } from "std-widgets.slint";
export component Recipe inherits Window {
    GridBox {
        Row {
            Button { text: "First"; }
            Button { text: "Second"; }
        }
        Row {
            Button { text: "Third"; }
            Button { text: "Fourth"; }
        }
        Row {
            Slider {
                colspan: 2;
            }
        }
    }
}

123456789101112131415161718
```

### 5.5 全局回调

**从Slint调用全局注册的本地回调**

此示例使用全局单例在本机代码中实现通用逻辑。此单例还可以存储本机代码可访问的属性。

注意：预览仅可视化Slint代码。它没有连接到本机代码。

```
import { HorizontalBox, VerticalBox, LineEdit } from "std-widgets.slint";

export global Logic  {
    pure callback to-upper-case(string) -> string;
    // You can collect other global properties here
}

export component Recipe inherits Window {
    VerticalBox {
        input := LineEdit {
            text: "Text to be transformed";
        }
        HorizontalBox {
            Text { text: "Transformed:"; }
            // Callback invoked in binding expression
            Text {
                text: {
                    Logic.to-upper-case(input.text);
                }
            }
        }
    }
}

1234567891011121314151617181920212223
```

- Rust代码

在Rust中，您可以像这样设置回调：

```
slint::slint!{
import { HorizontalBox, VerticalBox, LineEdit } from "std-widgets.slint";

export global Logic {
    pure callback to-upper-case(string) -> string;
    // You can collect other global properties here
}

export Recipe := Window {
    VerticalBox {
        input := LineEdit {
            text: "Text to be transformed";
        }
        HorizontalBox {
            Text { text: "Transformed:"; }
            // Callback invoked in binding expression
            Text {
                text: {
                    Logic.to-upper-case(input.text);
                }
            }
        }
    }
}
}

fn main() {
    let recipe = Recipe::new().unwrap();
    recipe.global::<Logic>().on_to_upper_case(|string| {
        string.as_str().to_uppercase().into()
    });
    // ...
}

123456789101112131415161718192021222324252627282930313233
```

- C++代码

翻译
Slint目前不提供内置的翻译支持。我们正在问题跟踪器中跟踪此功能。

同时，您可以使用全局回调、一些本机代码和gettext或fluent等翻译库使您的设计可翻译。

使用gettext的示例：

```
import { HorizontalBox, Button } from "std-widgets.slint";

export global Tr  {
    // Do the translation of the first argument, with an array of string as supstitution
    pure callback gettext(string, [string]) -> string;

    // A default implementation that returns the original string for preview purposes.
    gettext(text, _) => { return text; }
}

export component Example inherits Window {
    in-out property <int> count;
    HorizontalBox {
        Button {
            text: Tr.gettext("Button pressed {0} times", [root.count]);
        }
    }
}

123456789101112131415161718
```

xgettext可以提取可翻译的文本，然后可以使用gettext工具进行翻译：

xgettext -o example.pot example.slint
在您的本机代码中设置此回调，并在幕后调用gettext。使用类似的方法forngettext、dgettext和其他gettext函数。

- Rust代码

```rust
slint::slint!{
import { HorizontalBox , Button } from "std-widgets.slint";

export global Tr {
    // Do the translation of the first argument, with an array of string as supstitution
    pure callback gettext(string, [string]) -> string;
}

Example := Window {
    property <int> count;
    HorizontalBox {
        Button {
            text: Tr.gettext("Button pressed {0} times", [count]);
        }
    }
}
}

fn main() {
    let app = Example::new().unwrap();
    app.global::<Tr>().on_gettext(|string, model| {
        use crate::slint::Model;
#       let mut str = String::from(string.as_str()); /* (we don't depend on gettext-rs just for that)
        let mut str = gettextrs::gettext(string.as_str());
#       */
        for (idx, to) in model.iter().enumerate() {
            str = str.replace(&format!("%{}", idx + 1), to.as_str());
        }
        str.into()
    });
    //...
#   return;
    app.run().unwrap();
}

12345678910111213141516171819202122232425262728293031323334
```

### 5.6 自定义小部件

**自定义按钮**

```
component Button inherits Rectangle {
    in-out property text <=> txt.text;
    callback clicked <=> touch.clicked;
    border-radius: root.height / 2;
    border-width: 1px;
    border-color: root.background.darker(25%);
    background: touch.pressed ? #6b8282 : touch.has-hover ? #6c616c :  #456;
    height: txt.preferred-height * 1.33;
    min-width: txt.preferred-width + 20px;
    txt := Text {
        x: (parent.width - self.width)/2 + (touch.pressed ? 2px : 0);
        y: (parent.height - self.height)/2 + (touch.pressed ? 1px : 0);
        color: touch.pressed ? #fff : #eee;
    }
    touch := TouchArea { }
}

export component Recipe inherits Window {
    VerticalLayout {
        alignment: start;
        Button { text: "Button"; }
    }
}

1234567891011121314151617181920212223
```

**ToggleSwitch**

```
export component ToggleSwitch inherits Rectangle {
    callback toggled;
    in-out property <string> text;
    in-out property <bool> checked;
    in-out property<bool> enabled <=> touch-area.enabled;
    height: 20px;
    horizontal-stretch: 0;
    vertical-stretch: 0;

    HorizontalLayout {
        spacing: 8px;
        indicator := Rectangle {
            width: 40px;
            border-width: 1px;
            border-radius: root.height / 2;
            border-color: self.background.darker(25%);
            background: root.enabled ? (root.checked ? blue: white)  : white;
            animate background { duration: 100ms; }

            bubble := Rectangle {
                width: root.height - 8px;
                height: bubble.width;
                border-radius: bubble.height / 2;
                y: 4px;
                x: 4px + self.a * (indicator.width - bubble.width - 8px);
                property <float> a: root.checked ? 1 : 0;
                background: root.checked ? white : (root.enabled ? blue : gray);
                animate a, background { duration: 200ms; easing: ease;}
            }
        }

        Text {
            min-width: max(100px, self.preferred-width);
            text: root.text;
            vertical-alignment: center;
            color: root.enabled ? black : gray;
        }

    }

    touch-area := TouchArea {
        width: root.width;
        height: root.height;
        clicked => {
            if (root.enabled) {
                root.checked = !root.checked;
                root.toggled();
            }
        }
    }
}

export component Recipe inherits Window {
    VerticalLayout {
        alignment: start;
        ToggleSwitch { text: "Toggle me"; }
        ToggleSwitch { text: "Disabled"; enabled: false; }
    }
}

1234567891011121314151617181920212223242526272829303132333435363738394041424344454647484950515253545556575859
```

**自定义幻灯片**

TouchArea覆盖了整个小部件，因此您可以从自身的任何点拖动此滑块。

```
import { VerticalBox } from "std-widgets.slint";

export component MySlider inherits Rectangle {
    in-out property<float> maximum: 100;
    in-out property<float> minimum: 0;
    in-out property<float> value;

    min-height: 24px;
    min-width: 100px;
    horizontal-stretch: 1;
    vertical-stretch: 0;

    border-radius: root.height/2;
    background: touch.pressed ? #eee: #ddd;
    border-width: 1px;
    border-color: root.background.darker(25%);

    handle := Rectangle {
        width: self.height;
        height: parent.height;
        border-width: 3px;
        border-radius: self.height / 2;
        background: touch.pressed ? #f8f: touch.has-hover ? #66f : #0000ff;
        border-color: self.background.darker(15%);
        x: (root.width - handle.width) * (root.value - root.minimum)/(root.maximum - root.minimum);
    }
    touch := TouchArea {
        property <float> pressed-value;
        pointer-event(event) => {
            if (event.button == PointerEventButton.left && event.kind == PointerEventKind.down) {
                self.pressed-value = root.value;
            }
        }
        moved => {
            if (self.enabled && self.pressed) {
                root.value = max(root.minimum, min(root.maximum,
                    self.pressed-value + (touch.mouse-x - touch.pressed-x) * (root.maximum - root.minimum) / (root.width - handle.width)));

            }
        }
    }
}

export component Recipe inherits Window {
    VerticalBox {
        alignment: start;
        slider := MySlider {
            maximum: 100;
        }
        Text {
            text: "Value: \{round(slider.value)}";
        }
    }
}

123456789101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354
```

此示例显示了另一个具有可拖动句柄的实现：只有当我们单击该句柄时，句柄才会移动。TouchArea位于手柄内，并与手柄一起移动。

```
import { VerticalBox } from "std-widgets.slint";

export component MySlider inherits Rectangle {
    in-out property<float> maximum: 100;
    in-out property<float> minimum: 0;
    in-out property<float> value;

    min-height: 24px;
    min-width: 100px;
    horizontal-stretch: 1;
    vertical-stretch: 0;

    border-radius: root.height/2;
    background: touch.pressed ? #eee: #ddd;
    border-width: 1px;
    border-color: root.background.darker(25%);

    handle := Rectangle {
        width: self.height;
        height: parent.height;
        border-width: 3px;
        border-radius: self.height / 2;
        background: touch.pressed ? #f8f: touch.has-hover ? #66f : #0000ff;
        border-color: self.background.darker(15%);
        x: (root.width - handle.width) * (root.value - root.minimum)/(root.maximum - root.minimum);

        touch := TouchArea {
            moved => {
                if (self.enabled && self.pressed) {
                    root.value = max(root.minimum, min(root.maximum,
                        root.value + (self.mouse-x - self.pressed-x) * (root.maximum - root.minimum) / root.width));
                }
            }
        }
    }
}

export component Recipe inherits Window {
    VerticalBox {
        alignment: start;
        slider := MySlider {
            maximum: 100;
        }
        Text {
            text: "Value: \{round(slider.value)}";
        }
    }
}

123456789101112131415161718192021222324252627282930313233343536373839404142434445464748
```

**自定义选项卡**
当您想创建自己的自定义选项卡小部件时，请使用此食谱作为基础。

```
import { Button } from "std-widgets.slint";

export component Recipe inherits Window {
    preferred-height: 200px;
    in-out property <int> active-tab;
    VerticalLayout {
        tab_bar := HorizontalLayout {
            spacing: 3px;
            Button {
                text: "Red";
                clicked => { root.active-tab = 0; }
            }
            Button {
                text: "Blue";
                clicked => { root.active-tab = 1; }
            }
            Button {
                text: "Green";
                clicked => { root.active-tab = 2; }
            }
        }
        Rectangle {
            clip: true;
            Rectangle {
                background: red;
                x: root.active-tab == 0 ? 0 : root.active-tab < 0 ? - self.width - 1px : parent.width + 1px;
                animate x { duration: 125ms; easing: ease; }
            }
            Rectangle {
                background: blue;
                x: root.active-tab == 1 ? 0 : root.active-tab < 1 ? - self.width - 1px : parent.width + 1px;
                animate x { duration: 125ms; easing: ease; }
            }
            Rectangle {
                background: green;
                x: root.active-tab == 2 ? 0 : root.active-tab < 2 ? - self.width - 1px : parent.width + 1px;
                animate x { duration: 125ms; easing: ease; }
            }
        }
    }
}

1234567891011121314151617181920212223242526272829303132333435363738394041
```

**自定义表视图**

Slint提供了一个表格小部件，但您也可以根据ListView进行自定义操作。

```
import { VerticalBox, ListView } from "std-widgets.slint";

component TableView inherits Rectangle {
    in property <[string]> columns;
    in property <[[string]]> values;

    private property <length> e: self.width / root.columns.length;
    private property <[length]> column_sizes: [
        root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e,
        root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e,
        root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e, root.e,
    ];

    VerticalBox {
        padding: 5px;
        HorizontalLayout {
            padding: 5px; spacing: 5px;
            vertical-stretch: 0;
            for title[idx] in root.columns : HorizontalLayout {
                width: root.column_sizes[idx];
                Text { overflow: elide; text: title; }
                Rectangle {
                    width: 1px;
                    background: gray;
                    TouchArea {
                        width: 10px;
                        x: (parent.width - self.width) / 2;
                        property <length> cached;
                        pointer-event(event) => {
                            if (event.button == PointerEventButton.left && event.kind == PointerEventKind.down) {
                                self.cached = root.column_sizes[idx];
                            }
                        }
                        moved => {
                            if (self.pressed) {
                                root.column_sizes[idx] += (self.mouse-x - self.pressed-x);
                                if (root.column_sizes[idx] < 0) {
                                    root.column_sizes[idx] = 0;
                                }
                            }
                        }
                        mouse-cursor: ew-resize;
                    }
                }
            }
        }
        ListView {
            for r in root.values : HorizontalLayout {
                padding: 5px;
                spacing: 5px;
                for t[idx] in r : HorizontalLayout {
                    width: root.column_sizes[idx];
                    Text { overflow: elide; text: t; }
                }
            }
        }
    }
}

export component Example inherits Window {
   TableView {
       columns: ["Device", "Mount Point", "Total", "Free"];
       values: [
            ["/dev/sda1", "/", "255GB", "82.2GB"] ,
            ["/dev/sda2", "/tmp", "60.5GB", "44.5GB"] ,
            ["/dev/sdb1", "/home", "255GB", "32.2GB"] ,
       ];
   }
}

123456789101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869
```

**响应式用户界面的断点

使用配方实现了响应式边栏，当父宽度小于给定的断点时，该边栏会折叠。单击按钮时，边栏会再次展开。

```
import { Button, StyleMetrics } from "std-widgets.slint";

export component SideBar inherits Rectangle {
    private property <bool> collapsed: root.reference-width < root.break-point;

    /// Defines the reference width to check `break-point`.
    in-out property <length> reference-width;

    /// If `reference-width` is less `break-point` the `SideBar` collapses.
    in-out property <length> break-point: 600px;

    /// Set the text of the expand button.
    in-out property <string> expand-button-text;

    width: 160px;

    container := Rectangle {
        private property <bool> expaned;

        width: parent.width;
        background: StyleMetrics.window-background.darker(0.2);

        VerticalLayout {
            padding: 2px;
            alignment: start;

            HorizontalLayout {
                alignment: start;

                if (root.collapsed) : Button {
                    checked: container.expaned;
                    text: root.expand-button-text;

                    clicked => {
                        container.expaned = !container.expaned;
                    }
                }
            }

            @children
        }

        states [
            expaned when container.expaned && root.collapsed : {
                width: 160px;

                in {
                    animate width { duration: 200ms; }
                }

                out {
                    animate width { duration: 200ms; }
                }
            in {
                    animate width { duration: 200ms; }
                }
            out {
                    animate width { duration: 200ms; }
                }
            }
        ]
    }

    states [
        collapsed when root.collapsed : {
            width: 62px;
        }
    ]
}

export component SideBarTest inherits Window {
    preferred-width: 700px;
    min-height: 400px;

    GridLayout {
        Rectangle {
            height: 100%;
            col: 1;
            background: white;

            HorizontalLayout {
                padding: 8px;

                Text {
                    color: black;
                    text: "Content";
                }
            }
        }
        SideBar {
            col: 0;
            reference-width: parent.width;
            expand-button-text: "E";
        }
    }
}
```