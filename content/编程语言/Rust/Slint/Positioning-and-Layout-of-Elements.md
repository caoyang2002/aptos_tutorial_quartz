---
title: 元素的定位与布局
---
# 元素的定位与布局

所有视觉元素都显示在窗口中。`x` 和 `y` 属性存储元素相对于其父元素的坐标。Slint 通过将父元素的位置与元素的位置相加来确定元素的绝对位置。如果父元素本身有父元素，则也会进行相加，直到到达顶层元素。

`width` 和 `height` 属性存储视觉元素的大小。

您可以通过两种方式放置元素以创建整个图形用户界面：

- 显式地 - 通过设置 `x`、`y`、`width` 和 `height` 属性。
- 自动地 - 通过使用布局元素。

显式放置适合于静态场景，元素较少的情况。布局适合复杂用户界面，并有助于创建可扩展的用户界面。布局元素表达元素之间的几何关系。

## 显式放置

以下示例在窗口中放置两个矩形，一个蓝色和一个绿色。绿色矩形是蓝色的子元素：

```slint
// 显式定位
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

两个矩形的位置和内层绿色矩形的大小都是固定的。外层蓝色矩形的大小使用绑定表达式自动计算。该计算使得左下角与窗口的角对齐，并在窗口的 `width` 和 `height` 变化时更新。

在指定任何几何属性的显式值时，Slint 要求您为数字附加一个单位。您可以选择两种单位：

- 逻辑像素，使用 `px` 单位后缀。这是推荐的单位。
- 物理像素，使用 `phx` 单位后缀。

逻辑像素会根据您的系统配置的设备像素比自动缩放。例如，在现代高 DPI 显示器上，设备像素比可能为 2，因此每个逻辑像素占用 2 个物理像素。在较旧的屏幕上，用户界面在不适应的情况下进行缩放。

您还可以将 `width` 和 `height` 属性指定为 `%` 百分比单位，这相对于父元素应用。例如，`width: 50%` 意味着父元素 `width` 的一半。

`x` 和 `y` 属性的默认值将元素居中于其父元素。

`width` 和 `height` 的默认值取决于元素的类型。一些元素根据其内容自动调整大小，例如 `Image`、`Text` 和大多数小部件。以下元素没有内容，默认填充其父元素，当没有子元素时：

- `Rectangle`
- `TouchArea`
- `FocusScope`
- `Flickable`

布局元素也默认为填充父元素，无论其自身的首选大小如何。

其他元素（包括没有基类的自定义元素）默认使用其首选大小。

### 首选大小

您可以使用 `preferred-width` 和 `preferred-height` 属性指定元素的首选大小。

当未显式设置时，首选大小取决于子元素，并且是首选大小较大的子元素的大小，其 `x` 和 `y` 属性未设置。首选大小因此是从子元素到父元素计算的，就像其他约束（最大和最小大小）一样，除非显式覆盖。

一个特殊情况是将首选大小设置为父元素的大小，使用 `100%` 作为值。例如，此组件默认使用父元素的大小：

```slint
export component MyComponent {
    preferred-width: 100%;
    preferred-height: 100%;
    // ...
}
```

## 使用布局的自动放置

Slint 提供不同的布局元素，可以自动计算其子元素的位置和大小：

- `VerticalLayout` / `HorizontalLayout`：子元素沿垂直或水平方向放置。
- `GridLayout`：子元素以列和行的网格放置。

您还可以嵌套布局以创建复杂的用户界面。

您可以使用不同的约束调整自动放置，以适应用户界面的设计。每个元素都有最小、最大大小和首选大小。使用以下属性显式设置这些：

- `min-width`
- `min-height`
- `max-width`
- `max-height`
- `preferred-width`
- `preferred-height`

在布局中，任何指定 `width` 和 `height` 的元素具有固定大小。

当布局中有额外空间时，元素可以沿布局轴拉伸。您可以使用以下属性控制元素与其兄弟元素之间的拉伸因子：

- `horizontal-stretch`
- `vertical-stretch`

值为 `0` 表示元素不会拉伸。如果所有元素的拉伸因子为 `0`，则所有元素均等拉伸。

这些约束属性的默认值可能取决于元素的内容。如果元素的 `x` 或 `y` 未设置，则这些约束也会自动应用于父元素。

## 布局元素的常见属性

所有布局元素都有以下共同属性：

- `spacing`：控制子元素之间的间距。
- `padding`：指定布局内部的填充，即元素与布局边框之间的空间。

要进行更细致的控制，可以将 `padding` 属性分为每个侧面的属性：

- `padding-left`
- `padding-right`
- `padding-top`
- `padding-bottom`

## `VerticalLayout` 和 `HorizontalLayout`

`VerticalLayout` 和 `HorizontalLayout` 元素将其子元素放置在一列或一行。默认情况下，它们拉伸或缩小以占据整个空间。您可以根据需要调整元素的对齐方式。

以下示例将蓝色和黄色矩形放置在一行中，并在 200 个逻辑像素的 `width` 上均匀拉伸：

```slint
// 默认拉伸
export component Example inherits Window {
    width: 200px;
    height: 200px;
    HorizontalLayout {
        Rectangle { background: blue; min-width: 20px; }
        Rectangle { background: yellow; min-width: 30px; }
    }
}
```

以下示例则指定矩形对齐到布局的开始（视觉左侧）。这导致没有拉伸，而是矩形保留其指定的最小宽度：

```slint
// 除非指定对齐方式
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

以下示例嵌套两个布局以创建更复杂的场景：

```slint
export component Example inherits Window {
    width: 200px;
    height: 200px;
    HorizontalLayout {
        // 侧面面板
        Rectangle { background: green; width: 10px; }

        VerticalLayout {
            padding: 0px;
            // 工具栏
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

### 对齐方式

每个元素的大小根据其 `width` 或 `height` 进行设置，如果未指定，则设置为最小大小，这由最小宽度或最小高度属性确定，或内部布局的最小大小，以较大者为准。

元素的位置根据对齐方式进行设置。只有当布局的 `alignment` 属性为 `LayoutAlignment.stretch`（默认值）时，元素的大小才会大于最小大小。

以下示例展示不同的对齐方式：

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

### 拉伸算法

当 `alignment` 设置为拉伸（默认值）时，元素首先根据其最小尺寸进行调整，然后将多余的空间按各自的拉伸因子（由 `horizontal-stretch` 和 `vertical-stretch` 属性设置）进行分配。拉伸后的尺寸不会超过最大尺寸。拉伸因子为浮点数，默认内容大小的元素通常为 0，而默认为其父级大小的元素则为 1。如果某个元素的拉伸因子为 0，则保持其最小尺寸，除非所有其他元素的拉伸因子也为 0 或已达到最大尺寸。

示例：

```slint
export component Example inherits Window {
    width: 300px;
    height: 200px;
    VerticalLayout {
        // 相同的拉伸因子（默认1）：大小均分
        HorizontalLayout {
            Rectangle { background: blue; }
            Rectangle { background: yellow; }
            Rectangle { background: green; }
        }
        // 最小宽度较大的元素在扩展前获得更大的尺寸
        HorizontalLayout {
            Rectangle { background: cyan; min-width: 100px; }
            Rectangle { background: magenta; min-width: 50px; }
            Rectangle { background: gold; }
        }
        // 拉伸因子为2：扩展两倍
        HorizontalLayout {
            Rectangle { background: navy; horizontal-stretch: 2; }
            Rectangle { background: gray; }
        }
        // 所有没有最大宽度的元素都有拉伸因子0，因此它们会扩展
        HorizontalLayout {
            Rectangle { background: red; max-width: 20px; }
            Rectangle { background: orange; horizontal-stretch: 0; }
            Rectangle { background: pink; horizontal-stretch: 0; }
        }
    }
}
```

### `for`

VerticalLayout 和 HorizontalLayout 还可以包含 `for` 或 `if` 表达式：

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

## GridLayout

GridLayout 将元素布局成网格。每个元素都获得 `row`、`col`、`rowspan` 和 `colspan` 属性。您可以使用 `Row` 子元素，或明确设置 `row` 属性。这些属性必须在编译时静态已知，因此无法使用算术或依赖于属性。目前，在网格布局中不允许使用 `for` 或 `if`。

这个示例使用 `Row` 元素：

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

这个示例使用 `col` 和 `row` 属性：

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
