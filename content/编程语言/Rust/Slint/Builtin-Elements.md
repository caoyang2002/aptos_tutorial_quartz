---
title: 内置元素
---
# 内置元素

## 通用属性

### 几何属性

以下属性适用于所有可见项目：

- **`width`** 和 **`height`**（*长度*）：元素的大小。设置后，将覆盖默认大小。
- **`x`** 和 **`y`**（*长度*）：元素相对于其父元素的位置。
- **`z`**（*浮点数*）：允许指定不同的顺序来堆叠项目及其同级元素。（默认值：0）
- **`absolute-position`**（*点*）：元素在包含窗口内的位置。

### 布局

以下属性适用于所有可见项目，并且可以在布局中使用来指定约束：

- **`col`**, **`row`**, **`colspan`**, **`rowspan`**（*整数*）：参见[`GridLayout`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#gridlayout)。
- **`horizontal-stretch`** 和 **`vertical-stretch`**（*输入-输出* *浮点数*）：指定这些元素在布局中拉伸的相对空间量。当为 0 时，这意味着除非所有元素都为 0，否则元素不会被拉伸。内置小部件的值为 0 或 1。
- **`max-width`** 和 **`max-height`**（*长度*）：元素的最大尺寸
- **`min-width`** 和 **`min-height`**（*长度*）：元素的最小尺寸
- **`preferred-width`** 和 **`preferred-height`**（*长度*）：元素的首选尺寸

### 杂项

- **`cache-rendering-hint`**（*布尔值*）：当设置为 `true` 时，这为渲染器提供了一个提示，将元素及其所有子元素的内容缓存到一个中间缓存层中。对于很少更改的复杂子树，这可能会加速渲染，但代价是增加内存消耗。并非所有渲染后端都支持此功能，因此这只是一个提示。（默认值：`false`）
- **`dialog-button-role`**（*枚举 [`DialogButtonRole`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/enums#dialogbuttonrole)*）：指定这是一个 `Dialog` 中的按钮。
- **`opacity`**（*浮点数*）：用于绘制元素及其子元素的透明度的值，范围在 0 到 1（或百分比）之间。0 表示完全透明（不可见），1 表示完全不透明。透明度应用于子元素树，就好像它们首先被绘制到一个中间层中，然后整个层以这种透明度渲染。（默认值：1）
- **`visible`**（*布尔值*）：当设置为 `false` 时，元素及其所有子元素将不会被绘制，也不会响应鼠标输入（默认值：`true`）

以下示例演示了带有子元素的 `opacity` 属性。红色矩形应用了透明度。由于绿色矩形是红色矩形的子元素，你可以看到它下面的渐变，但你不能通过绿色矩形看到红色矩形。

```slint
export component Example inherits Window {
    width: 100px;
    height: 100px;
    background: @radial-gradient(circle, black, white, black, white);
    Rectangle {
        opacity: 0.5;
        background: red;
        border-color: #822;
        border-width: 5px;
        width: 50px; height: 50px;
        x: 10px; y: 10px;
        Rectangle {
            background: green;
            border-color: #050;
            border-width: 5px;
            width: 50px; height: 50px;
            x: 25px; y: 25px;
        }
    }
}
```

### 可访问性

使用以下 `accessible-` 属性使您的项目能够与屏幕阅读器、盲文终端机和其他软件良好交互，从而使您的应用程序可访问。必须设置 `accessible-role` 才能设置任何其他可访问属性或回调。

- **`accessible-role`**（*枚举 [`AccessibleRole`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/enums#accessiblerole)*）：元素的角色。此属性是能够使用任何其他可访问属性的必要条件。它应该设置为一个常量值。（大多数元素的默认值：`none`，但对于 Text 元素是 `text`）
- **`accessible-checkable`**（*布尔值*）：元素是否可以被选中。
- **`accessible-checked`**（*布尔值*）：元素是否被选中。这对应于复选框、单选按钮和其他小部件的“选中”状态。
- **`accessible-description`**（*字符串*）：当前元素的描述。
- **`accessible-label`**（*字符串*）：交互元素的标签。（大多数元素的默认值：空，或 Text 元素的 `text` 属性的值）
- **`accessible-value-maximum`**（*浮点数*）：项目的最大值。例如，由旋转框使用。
- **`accessible-value-minimum`**（*浮点数*）：项目的最小值。
- **`accessible-value-step`**（*浮点数*）当前值可以改变的最小增量或减量。这对应于滑块上的手柄可以拖动的步长。
- **`accessible-value`**（*字符串*）：项目当前的值。
- **`accessible-placeholder-text`**（*字符串*）：当项目值为空时使用的占位符文本。适用于文本元素。

您还可以使用以下回调，这些回调将由可访问性框架调用：

- **`accessible-action-default()`**：当请求此小部件的默认操作时调用（例如：按下按钮）。
- **`accessible-action-set-value(string)`**：当用户想要更改可访问值时调用。
- **`accessible-action-increment()`**：当用户请求增加值时调用。
- **`accessible-action-decrement()`**：当用户请求减少值时调用。

### 阴影效果

为了实现视觉上提升的形状显示元素框架下方的阴影效果，可以设置以下 `drop-shadow` 属性：

- **`drop-shadow-blur`**（*长度*）：阴影的半径，也描述了应用于阴影的模糊程度。负值被忽略，零表示无模糊。（默认值：0）
- **`drop-shadow-color`**（*颜色*）：要使用的基础阴影颜色。通常该颜色是渐变的起始颜色，渐变到透明。
- **`drop-shadow-offset-x`** 和 **`drop-shadow-offset-y`**（*长度*）：阴影与元素框架的水平和垂直距离。负值将阴影放置在元素的左侧/上方。

`drop-shadow` 效果支持 `Rectangle` 元素。

## `Dialog`

对话框就像一个窗口，但它有自动布局的按钮。

一个对话框应该有一个主要的子元素，而不是一个按钮。对话框可以有任意数量的 `StandardButton` 小部件或其他具有 `dialog-button-role` 属性的按钮。按钮将根据运行时的目标平台以特定的顺序放置。

`StandardButton` 的 `kind` 属性和 `dialog-button-role` 属性需要设置为一个常量值，不能是任意的变量表达式。不能有多个相同种类的 `StandardButton`。

对于每个没有显式回调处理器的 `StandardButton`，会自动添加一个 `<kind>_clicked` 回调，以便它可以从本地代码处理：例如，如果有一个 `cancel` 类型的按钮，将添加一个 `cancel_clicked` 回调。这些自动生成的回调是关联的 `StandardButton` 的 `clicked` 回调的别名。

### 属性

- **`icon`**（*图像*）：在支持它的窗口管理器的标题栏或任务栏中显示的窗口图标。
- **`title`**（*字符串*）：在标题栏中显示的窗口标题。

### 示例

```slint
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
```

## `Flickable`

`Flickable` 是一个低级元素，是可滚动小部件（如 [`ScrollView`](https://releases.slint.dev/1.7.2/docs/slint/src/language/widgets/scrollview)）的基础。当 `viewport-width` 或 `viewport-height` 大于父元素的 `width` 或 `height` 时，元素变得可滚动。注意 `Flickable` 不创建滚动条。未设置时，`viewport-width` 和 `viewport-height` 根据 `Flickable` 的子元素自动计算。当使用 `for` 循环填充元素时，情况并非如此。这是一个在问题 [#407](https://github.com/slint-ui/slint/issues/407) 中跟踪的错误。`Flickable` 的最大和首选大小基于视口。

当不是布局的一部分时，如果没有指定，其宽度或高度默认为父元素的 100%。

### 指针事件交互

如果 `Flickable` 的区域包含使用 `TouchArea` 来响应点击的元素，例如 `Button` 小部件，则使用以下算法来区分用户的滚动意图或与 `TouchArea` 元素交互：

1. 如果 `Flickable` 的 `interactive` 属性为 `false`，则所有事件都转发到下面的元素。
2. 如果接收到与 `TouchArea` 交互的按下事件，将存储该事件，并按如下方式处理任何后续移动和释放事件：
   1. 如果没有任何事件发生 100 毫秒，则将存储的按下事件传递给 `TouchArea`。
   2. 如果在 100 毫秒内接收到释放事件，则将存储的按下事件和释放事件立即传递给 `TouchArea`，然后算法重置。
   3. 如果收到任何移动事件，如果满足以下所有条件，将在 `Flickable` 上启动滑动操作：
      1. 事件是在接收到按下事件后的 500 毫秒内接收的。
      2. 距离按下事件的距离超过了允许移动的方向上的 8 个逻辑像素。如果 `Flickable` 决定滑动，任何先前发送到 `TouchArea` 的按下事件，都会跟随一个退出事件。在接收移动事件的阶段，可滑动元素会跟随坐标。
3. 如果按下、移动和释放事件的交互开始于不与 `TouchArea` 相交的坐标，则当指针移动事件的欧几里得距离超过按下事件坐标的 8 个逻辑像素时，`Flickable` 将立即滑动。

### 属性

- **`interactive`**（*布尔值*）：当为 true 时，可以通过点击并用光标拖动来滚动视口。（默认值：true）
- **`viewport-height`**, **`viewport-width`**（*长度*）：可滚动元素的总大小。
- **`viewport-x`**, **`viewport-y`**（*长度*）：可滚动元素相对于 `Flickable` 的位置。这通常是负值。

### 回调

- **`flicked()`**：当 `viewport-x` 或 `viewport-y` 被用户操作（拖动、滚动）改变时调用。

### 示例

```slint
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
```

## `FocusScope`

`FocusScope` 公开回调以拦截按键事件。注意 `FocusScope` 只有在它 `has-focus` 时才会调用它们。

[`KeyEvent`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/structs#keyevent) 有一个文本属性，它是按下的键的 Unicode 表示。当按下一个不可打印的键时，字符将是控制字符，或者它将被映射到一个私有的 Unicode 字符。这些不可打印的特殊字符的映射可在 [`Key`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/namespaces#key) 命名空间中找到。

### 属性

- **`has-focus`**（*输出* *布尔值*）：当元素拥有键盘焦点时为 `true`。
- **`enabled`**（*输入* *布尔值*）：当为 true 时，`FocusScope` 将在点击时使自己成为焦点元素。如果你想取消点击聚焦行为，请将其设置为 false。同样，禁用的 `FocusScope` 不接受通过 tab 焦点遍历的焦点。即使 `enabled` 设置为 false，父 `FocusScope` 仍将从被拒绝的子 `FocusScope` 接收按键事件。（默认值：true）

### 函数

- **`focus()`** 调用此函数将键盘焦点转移到此 `FocusScope`，以接收未来的 [`KeyEvent`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/structs#keyevent)。
- **`clear-focus()`** 调用此函数，如果此 `FocusScope` 当前拥有焦点，则移除键盘焦点。另见 [焦点处理](https://releases.slint.dev/1.7.2/docs/slint/src/language/concepts/focus)。

### 回调

- **`key-pressed(KeyEvent) -> EventResult`**：当按键按下时调用，参数是 [`KeyEvent`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/structs#keyevent) 结构体。返回的 [`EventResult`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/enums#eventresult) 表示是接受还是忽略事件。忽略的事件将转发给父元素。
- **`key-released(KeyEvent) -> EventResult`**：当按键释放时调用，参数是 [`KeyEvent`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/structs#keyevent) 结构体。返回的 [`EventResult`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/enums#eventresult) 表示是接受还是忽略事件。忽略的事件将转发给父元素。
- **`focus-changed-event()`**：当 `FocusScope` 上的焦点改变时调用。

### 示例

```slint
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
```

## `GridLayout`

`GridLayout` 将子元素放置在网格中。`GridLayout` 为每个子元素添加属性：`col`, `row`, `colspan`, `rowspan`。您可以使用 `col` 和 `row` 控制子元素的位置。如果没有指定 `col` 或 `row`，它们将自动计算，以便项目位于同一行的前一个项目旁边。或者，可以将项目放在 `Row` 元素中。

### 属性

- **`spacing`**（*长度*）：布局中元素之间的距离。
- **`spacing-horizontal`**, **`spacing-vertical`**（*长度*）：设置这些属性以覆盖特定方向上的间距。
- **`padding`**（*长度*）：布局内的填充。
- **`padding-left`**, **`padding-right`**, **`padding-top`** 和 **`padding-bottom`**（*长度*）：设置这些属性以覆盖特定边的填充。

### 示例

这个示例使用了 `Row` 元素：

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

[编辑 📝](https://releases.slint.dev/1.7.2/editor/?snippet=export component Foo inherits Window { width: 200px; height: 200px; GridLayout { spacing: 5px; Row { Rectangle { background: red; } Rectangle { background: blue; } } Row { Rectangle { background: yellow; } Rectangle { background: green; } } } } )

这个示例使用了 `col` 和 `row` 属性

```slint
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
```

[编辑 📝](https://releases.slint.dev/1.7.2/editor/?snippet=export component Foo inherits Window { width: 200px; height: 150px; GridLayout { Rectangle { background: red; } Rectangle { background: blue; } Rectangle { background: yellow; row: 1; } Rectangle { background: green; } Rectangle { background: black; col: 2; row: 0; } } } )

## `Image`

`Image` 可以用来表示从文件加载的图像。

### 属性

- **`colorize`**（*画笔*）：当设置时，图像用作 alpha 遮罩，并以给定的颜色（或渐变）绘制。

- **`horizontal-alignment`**（*枚举 [`ImageHorizontalAlignment`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/enums#imagehorizontalalignment)*）：元素内图像的水平对齐方式。

- **`horizontal-tiling`**（*枚举 [`ImageTiling`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/enums#imagetiling)*）：图像是否应在水平轴上平铺。

- **`image-fit`**（*枚举 [`ImageFit`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/enums#imagefit)*）：指定源图像应如何适应图像元素。当与 9 分割缩放或平铺图像一起使用时，没有任何效果。（默认值：当 `Image` 元素是布局的一部分时为 `contain`，否则为 `fill`）

- **`image-rendering`**（*枚举 [`ImageRendering`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/enums#imagerendering)*）：指定源图像将如何被缩放。（默认值：`smooth`）

- **`rotation-angle`**（*角度*），**`rotation-origin-x`**（*长度*），**`rotation-origin-y`**（*长度*）：围绕指定的原点旋转图像，给定的角度。默认原点是元素的中心。当设置这些属性时，`Image` 不能有子元素。

- **`source`**（*图像*）：要加载的图像。使用 [`@image-url("...")` 宏](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#../syntax/types#images) 指定图像的位置。

- **`source-clip-x`**, **`source-clip-y`**, **`source-clip-width`**, **`source-clip-height`**（*整数*）：在源图像坐标中定义要渲染的源图像区域的属性。默认情况下，整个源图像是可见的：




  | 属性             | 默认绑定                 |
  | ---------------- | ---------------------- |
  | `source-clip-x`  | `0`                    |
  | `source-clip-y`  | `0`                    |
  | `source-clip-width`  | `source.width - source-clip-x`  |
  | `source-clip-height` | `source.height - source-clip-y` |
  
  

- **`vertical-alignment`**（*枚举 [`ImageVerticalAlignment`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/enums#imageverticalalignment)*）：元素内图像的垂直对齐方式。

- **`vertical-tiling`**（*枚举 [`ImageTiling`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/enums#imagetiling)*）：图像是否应在垂直轴上平铺。

- **`width`**, **`height`**（*长度*）：图像在屏幕上的宽度和高度。默认值由 **`source`** 图像提供。如果 `Image` **不是** 布局的一部分，并且只指定了两个大小中的**一个**，那么另一个默认为指定值，根据 **`source`** 图像的宽高比缩放。

### 示例

```slint
export component Example inherits Window {
    width: 100px;
    height: 100px;
    VerticalLayout {
        Image {
            source: @image-url("https://slint.dev/logo/slint-logo-full-light.svg");
            // image-fit 默认在布局中为 `contain`，保持宽高比
        }
        Image {
            source: @image-url("https://slint.dev/logo/slint-logo-full-light.svg");
            colorize: red;
        }
    }
}
```

在保持宽高比的同时缩放：

```slint
export component Example inherits Window {
    width: 100px;
    height: 150px;
    VerticalLayout {
        Image {
            source: @image-url("https://slint.dev/logo/slint-logo-full-light.svg");
            width: 100px;
            // 隐式默认值，保持宽高比：
            // height: self.width * natural_height / natural_width;
        }
    }
}
```

使用九宫格示例：

```slint
export component Example inherits Window {
    width: 100px;
    height: 150px;
    VerticalLayout {
        Image {
            source: @image-url("https://interactive-examples.mdn.mozilla.net/media/examples/border-diamonds.png", nine-slice(30));
        }
    }
}
```

## `Path`

`Path` 元素允许渲染由不同几何命令组成的通用形状。路径形状可以填充和轮廓。

当不是布局的一部分时，如果没有指定，其宽度或高度默认为父元素的 100%。

路径可以用两种不同的方式定义：

- 使用 SVG 路径命令作为字符串
- 使用 `.slint` 标记中的路径命令元素。

几何命令中使用的坐标在路径的想象坐标系内。在屏幕上渲染时，形状相对于 `x` 和 `y` 属性绘制。如果 `width` 和 `height` 属性非零，则整个形状将适应这些边界 - 相应地进行缩放。

### 通用路径属性

- **`fill`**（*画笔*）：填充路径形状的颜色。

- **`fill-rule`**（*枚举 [`FillRule`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/enums#fillrule)*）：用于路径的填充规则。（默认值：`nonzero`）

- **`stroke`**（*画笔*）：绘制路径轮廓的颜色。

- **`stroke-width`**（*长度*）：轮廓的宽度。

- **`width`**（*长度*）：如果非零，则路径将缩放以适应指定的宽度。

- **`height`**（*长度*）：如果非零，则路径将缩放以适应指定的高度。

- **`viewbox-x`**/ **`viewbox-y`**/ **`viewbox-width`**/ **`viewbox-height`**（*浮点数*）这四个属性允许定义路径视口的位置和大小，以路径坐标表示。

  如果 `viewbox-width` 或 `viewbox-height` 小于或等于零，则忽略视口属性，而使用所有路径元素的边界矩形来定义视口。

- **`clip`**（*布尔值*）：默认情况下，当路径定义了视口并且元素在视口外渲染时，它们仍然被渲染。当此属性设置为 `true` 时，则渲染将在视口边界处被剪辑。此属性必须是字面 `true` 或 `false`（默认值：`false`）

#### 使用 SVG 命令的路径

SVG 是定义可缩放图形的流行文件格式，通常由路径组成。在 SVG 中，路径由命令组成，这些命令反过来以字符串的形式书写。在 `.slint` 中，路径命令提供给 `commands` 属性。以下示例渲染了一个由弧线和矩形组成的形状，由 `line-to`、`move-to` 和 `arc` 命令组成：

```slint
export component Example inherits Path {
    width: 100px;
    height: 100px;
    commands: "M 0 0 L 0 100 A 1 1 0 0 0 100 100 L 100 0 Z";
    stroke: red;
    stroke-width: 1px;
}
```

命令是在属性中提供的：

- **`commands`**（*字符串*）：根据 SVG 路径规范提供命令的字符串。

#### 使用 SVG 路径元素的路径

路径的形状也可以使用类似于 SVG 路径命令但使用 `.slint` 标记语法的元素来描述。前面使用 SVG 命令的示例也可以这样写：

```slint
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
```

注意路径元素的坐标不使用单位 - 它们在可缩放路径的想象坐标系中操作。

##### `MoveTo` 子元素 for `Path`

`MoveTo` 子元素关闭当前子路径（如果存在），并将当前点移动到由 `x` 和 `y` 属性指定的位置。后续元素（如 `LineTo`）将使用这个新位置作为它们的起点，因此这开始了一个新的子路径。

###### 属性

- **`x`**（*浮点数*）：新当前点的 x 位置。
- **`y`**（*浮点数*）：新当前点的 y 位置。

##### `LineTo` 子元素 for `Path`

`LineTo` 子元素描述了从路径当前位置到由 `x` 和 `y` 属性指定的位置的直线。

###### 属性

- **`x`**（*浮点数*）：线的 target x 位置。
- **`y`**（*浮点数*）：线的 target y 位置。

##### `ArcTo` 子元素 for `Path`

`ArcTo` 子元素描述了椭圆的部分。弧线从路径的当前位置绘制到由 `x` 和 `y` 属性指定的位置。其余属性是根据 SVG 规范建模的，允许调整视觉特征，如方向或角度。

###### 属性

- **`large-arc`**（*布尔值*）：在闭合椭圆的两条弧线中，此标志选择要渲染的较大弧线。如果属性为 `false`，则渲染较短的弧线。
- **`radius-x`**（*浮点数*）：椭圆的 x 半径。
- **`radius-y`**（*浮点数*）：椭圆的 y 半径。
- **`sweep`**（*布尔值*）：如果属性为 `true`，则弧线将作为顺时针旋转的弧线绘制；否则为逆时针。
- **`x-rotation`**（*浮点数*）：椭圆的 x 轴将按此属性的值旋转，以度为单位，从 0 到 360 度。
- **`x`**（*浮点数*）：线的 target x 位置。
- **`y`**（*浮点数*）：线的 target y 位置。

##### `CubicTo` 子元素 for `Path`

`CubicTo` 子元素描述了从路径当前位置到由 `x` 和 `y` 属性指定的位置的平滑贝塞尔曲线，使用它们各自的属性指定的两个控制点。

###### 属性

- **`control-1-x`**（*浮点数*）：曲线的第一个控制点的 x 坐标。
- **`control-1-y`**（*浮点数*）：曲线的第一个控制点的 y 坐标。
- **`control-2-x`**（*浮点数*）：曲线的第二个控制点的 x 坐标。
- **`control-2-y`**（*浮点数*）：曲线的第二个控制点的 y 坐标。
- **`x`**（*浮点数*）：曲线的 target x 位置。
- **`y`**（*浮点数*）：曲线的 target y 位置。

##### `QuadraticTo` 子元素 for `Path`

`QuadraticTo` 子元素描述了从路径当前位置到由 `x` 和 `y` 属性指定的位置的平滑贝塞尔曲线，使用 `control-x` 和 `control-y` 属性指定的控制点。

###### 属性

- **`control-x`**（*浮点数*）：曲线的控制点的 x 坐标。
- **`control-y`**（*浮点数*）：曲线的控制点的 y 坐标。
- **`x`**（*浮点数*）：曲线的 target x 位置。
- **`y`**（*浮点数*）：曲线的 target y 位置。

##### `Close` 子元素 for `Path`

`Close` 元素关闭当前子路径并在当前位置与路径起点之间绘制一条直线。

## `PopupWindow`

使用此元素显示弹出窗口，如工具提示或弹出菜单。

注意：不允许从 `PopupWindow` 外部访问其中的元素属性。

### 属性

- **`close-on-click`**（*布尔值*）：默认情况下，当用户点击时，PopupWindow 会关闭。将此设置为 false 以防止该行为，并使用 `close()` 函数手动关闭。（默认值：true）

### 函数

- **`show()`** 在屏幕上显示弹出窗口。
- **`close()`** 关闭弹出窗口。如果您将 `close-on-click` 属性设置为 false，请使用此方法。

### 示例

```slint
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
```

## `Rectangle`

默认情况下，`Rectangle` 只是一个空的项目，什么都不显示。通过设置颜色或配置边框，然后可以在屏幕上绘制矩形。

当不是布局的一部分时，如果没有指定，其宽度和高度默认为父元素的 100%。

### 属性

- **`background`**（*画笔*）：这个 `Rectangle` 的背景画笔，通常是一种颜色。（默认值：`transparent`）
- **`border-color`**（*画笔*）：边框的颜色。（默认值：`transparent`）
- **`border-radius`**（*长度*）：圆角的大小。（默认值：0）
- **`border-top-left-radius`**, **`border-top-right-radius`**, **`border-bottom-left-radius`** 和 **`border-bottom-right-radius`**（*长度*）：设置这些属性以覆盖特定角的圆角。
- **`border-width`**（*长度*）：边框的宽度。（默认值：0）
- **`clip`**（*布尔值*）：默认情况下，当元素大于或超出另一个元素时，它仍然会被显示。当此属性设置为 `true` 时，这个 `Rectangle` 的子元素将被剪辑到矩形的边框。（默认值：`false`）

### 示例

```slint
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

    // 带边框的矩形
    Rectangle {
        x: 70px;
        y: 10px;
        width: 50px;
        height: 50px;
        background: green;
        border-width: 2px;
        border-color: red;
    }

    // 带边框和圆角的透明矩形
    Rectangle {
        x: 140px;
        y: 10px;
        width: 50px;
        height: 50px;
        border-width: 4px;
        border-color: black;
        border-radius: 10px;
    }

    // 圆角为宽度的一半使其成为圆形
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
```

## `TextInput`

`TextInput` 是一个低级项目，显示文本并允许输入文本。

当不是布局的一部分时，如果没有指定，其宽度或高度默认为父元素的 100%。

### 属性

- **`color`**（*画笔*）：文本的颜色（默认值：取决于样式）
- **`font-family`**（*字符串*）：选择用于渲染文本的字体系列的名称。
- **`font-size`**（*长度*）：文本的字体大小。
- **`font-weight`**（*整数*）：字体的权重。值范围从 100（最轻）到 900（最厚）。400 是正常权重。
- **`font-italic`**（*布尔值*）：字体是否应该倾斜绘制。（默认值：false）
- **`has-focus`**（*输出* *布尔值*）：`TextInput` 将其设置为 `true` 当它被聚焦时。只有在那时它才会接收 [`KeyEvent`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/structs#keyevent)。
- **`horizontal-alignment`**（*枚举 [`TextHorizontalAlignment`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/enums#texthorizontalalignment)*）：文本的水平对齐方式。
- **`input-type`**（*枚举 [`InputType`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/enums#inputtype)*）：使用此属性配置 `TextInput` 以编辑特殊输入，例如密码字段。（默认值：`text`）
- **`letter-spacing`**（*长度*）：字距允许更改字形之间的间距。正值增加间距，负值减小距离。（默认值：0）
- **`read-only`**（*布尔值*）：当设置为 `true` 时，通过键盘和鼠标编辑文本被禁用，但仍然可以选中文本以及以编程方式编辑文本。（默认值：`false`）
- **`selection-background-color`**（*颜色*）：选择的背景颜色。
- **`selection-foreground-color`**（*颜色*）：选择的前景颜色。
- **`single-line`**（*布尔值*）：当设置为 `true` 时，文本始终作为单行渲染，无视文本中的新行分隔符。（默认值：`true`）
- **`text-cursor-width`**（*长度*）：文本光标的宽度。（运行时由选定的小部件样式提供，默认值）
- **`text`**（*输入-输出* *字符串*）：由用户渲染和可编辑的文本。
- **`vertical-alignment`**（*枚举 [`TextVerticalAlignment`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/enums#textverticalalignment)*）：文本的垂直对齐方式。
- **`wrap`**（*枚举 [`TextWrap`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/enums#textwrap)*）：文本输入的换行方式。只有当 `single-line` 为 false 时才有意义。（默认值：no-wrap）

### 函数

- **`focus()`** 调用此函数将键盘焦点转移到此 `TextInput`，以接收未来的键盘事件。
- **`clear-focus()`** 调用此函数，如果此 `TextInput` 当前拥有焦点，则移除键盘焦点。另见 [焦点处理](https://releases.slint.dev/1.7.2/docs/slint/src/language/concepts/focus)。
- **`set-selection-offsets(int, int)`** 选择两个 UTF-8 偏移之间的文本。
- **`select-all()`** 选择所有文本。
- **`clear-selection()`** 清除选择。
- **`copy()`** 将选定的文本复制到剪贴板。
- **`cut()`** 将选定的文本复制到剪贴板并从可编辑区域移除。
- **`paste()`** 将剪贴板的文本内容粘贴到光标位置。

### 回调

- **`accepted()`**：当按下回车键时调用。
- **`cursor-position-changed(Point)`**：光标移动到由 [*`Point`*](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/structs#point) 参数描述的新 (x, y) 位置。
- **`edited()`**：当文本因为用户修改而改变时调用。

### 示例

```slint
export component Example inherits Window {
    width: 270px;
    height: 100px;

    TextInput {
        text: "Replace me with a name";
    }
}
```



## `Text`

`Text` 元素负责渲染文本。除了指定要渲染的文本的 `text` 属性外，它还允许通过 `font-family`、`font-size`、`font-weight`、`color` 和 `stroke` 属性配置不同的视觉方面。

`Text` 元素可以将长文本拆分为多行文本。在 `text` 属性的字符串中，换行字符（`\n`）将触发手动换行。要进行自动换行，您需要将 `wrap` 属性设置为除 `no-wrap` 之外的值，并且重要的是为 `Text` 元素指定 `width` 和 `height`，以便知道在哪里换行。建议将 `Text` 元素放置在布局中，并让它根据可用的屏幕空间和文本本身设置 `width` 和 `height`。

### 属性

- **`color`**（*画笔*）：文本的颜色。（默认值：取决于样式）
- **`font-family`**（*字符串*）：选择用于渲染文本的字体系列的名称。
- **`font-size`**（*长度*）：文本的字体大小。
- **`font-weight`**（*整数*）：字体的权重。值范围从 100（最轻）到 900（最厚）。400 是正常权重。
- **`font-italic`**（*布尔值*）：字体是否应该倾斜绘制。（默认值：false）
- **`horizontal-alignment`**（*枚举 [`TextHorizontalAlignment`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/enums#texthorizontalalignment)*）：文本的水平对齐方式。
- **`letter-spacing`**（*长度*）：字距允许更改字形之间的间距。正值增加间距，负值减小距离。（默认值：0）
- **`overflow`**（*枚举 [`TextOverflow`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/enums#textoverflow)*）：当文本溢出时会发生什么。（默认值：clip）
- **`text`**（*字符串*）：渲染的文本。
- **`vertical-alignment`**（*枚举 [`TextVerticalAlignment`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/enums#textverticalalignment)*）：文本的垂直对齐方式。
- **`wrap`**（*枚举 [`TextWrap`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/enums#textwrap)*）：文本换行的方式。（默认值：`no-wrap`）
- **`stroke`**（*画笔*）：用于文本轮廓的画笔。（默认值：`transparent`）
- **`stroke-width`**（*长度*）：文本轮廓的宽度。如果宽度为零，则将渲染一条细线轮廓（1 个物理像素）。
- **`stroke-style`**（*枚举 [`TextStrokeStyle`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/enums#textstrokestyle)*）：文本轮廓的样式/对齐方式。（默认值：`outside`）
- **`rotation-angle`**（*角度*），**`rotation-origin-x`**（*长度*），**`rotation-origin-y`**（*长度*）：围绕指定的原点旋转文本，给定的角度。默认原点是元素的中心。当设置这些属性时，`Text` 不能有子元素。

### 示例

这个示例显示了使用默认字体的红色文本 “Hello World”：

```slint
export component Example inherits Window {
    width: 270px;
    height: 100px;

    Text {
        x:0;y:0;
        text: "Hello World";
        color: red;
    }
}
```



这个示例通过设置 `wrap` 策略并分配有限的 `width` 和足够的 `height`，将更长的段落文本拆分为多行：

```slint
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
```



## `TouchArea`

使用 `TouchArea` 控制当它覆盖的区域被触摸或使用鼠标交互时会发生什么。

当不是布局的一部分时，如果没有指定，其宽度或高度默认为父元素的 100%。

### 属性

- **`has-hover`**（*输出* *布尔值*）：当鼠标悬停在其上时，`TouchArea` 将其设置为 `true`。
- **`mouse-cursor`**（*输入* *枚举 [`MouseCursor`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/enums#mousecursor)*）：鼠标悬停在 `TouchArea` 上时的鼠标光标类型。
- **`mouse-x`**, **`mouse-y`**（*输出* *长度*）：由 `TouchArea` 设置为其内部鼠标的位置。
- **`pressed-x`**, **`pressed-y`**（*输出* *长度*）：由 `TouchArea` 设置为鼠标上次按下时的位置。
- **`pressed`**（*输出* *布尔值*）：当鼠标在其上按下时，`TouchArea` 将其设置为 `true`。

### 回调

- **`clicked()`**：当点击时调用：手指或鼠标左键在此元素上按下，然后释放。
- **`double-clicked()`**：当双击时调用。鼠标左键在此元素上短时间内按下并释放两次，或者使用手指做同样的事情。`clicked()` 回调将在 `double-clicked()` 回调之前触发。
- **`moved()`**：鼠标或手指已移动。这只有在鼠标也按下或手指继续触摸显示屏时才会被调用。另见 **pointer-event(PointerEvent)**。
- **`pointer-event(PointerEvent)`**：当按钮被按下或释放，手指触摸或指针移动时调用。[*`PointerEvent`*](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/structs#pointerevent) 参数包含有关哪个按钮被按下以及任何活动的键盘修饰符的信息。在 [*`PointerEventKind::Move`*](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/structs#pointereventkind) 情况下，`buttons` 字段将始终设置为 `PointerEventButton::Other`，无论是否有任何按钮被按下。
- **`scroll-event(PointerScrollEvent) -> EventResult`**：当鼠标滚轮旋转或进行其他滚动手势时调用。[*`PointerScrollEvent`*](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/structs#pointerscrollevent) 参数包含有关滚动多少以及滚动方向的信息。返回的 [`EventResult`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/enums#eventresult) 表示是接受还是忽略事件。忽略的事件将转发给父元素。

### 示例

```slint
export component Example inherits  Window {
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
```



## `VerticalLayout` 和 `HorizontalLayout`

这些布局将它们的子元素垂直或水平放置在一起。元素的大小可以通过 `width` 或 `height` 属性固定，或者如果没有设置，它们将由布局计算，同时尊重最小和最大尺寸以及拉伸因子。

### 属性

- **`spacing`**（*长度*）：布局中元素之间的距离。
- **`padding`**（*长度*）：布局内的填充。
- **`padding-left`**, **`padding-right`**, **`padding-top`** 和 **`padding-bottom`**（*长度*）：设置这些属性以覆盖特定边的填充。
- **`alignment`**（*枚举 [`LayoutAlignment`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/enums#layoutalignment)*）：设置对齐方式。匹配 CSS 弹性盒。

### 示例

```slint
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
```



## `Window`

`Window` 是屏幕上可见元素树的根。

`Window` 的几何形状将受到其布局约束的限制：设置 `width` 将导致固定宽度，窗口管理器将尊重 `min-width` 和 `max-width`，以便窗口不能被调整得更大或更小。可以使用 `preferred-width` 属性控制初始宽度。同样适用于 `Window` 的高度。

### 属性

- **`always-on-top`**（*布尔值*）：窗口是否应该放在支持它的窗口管理器的所有其他窗口之上。
- **`background`**（*画笔*）：`Window` 的背景画笔。（默认值：取决于样式）
- **`default-font-family`**（*字符串*）：在没有设置 `font-family` 属性的文本元素中使用此字体系列。
- **`default-font-size`**（*输入-输出* *长度*）：在没有设置 `font-size` 属性的文本元素中使用的字体大小。此属性的值还构成了相对字体大小的基础。
- **`default-font-weight`**（*整数*）：在没有设置 `font-weight` 属性的文本元素中使用的字体权重。值范围从 100（最轻）到 900（最厚）。400 是正常权重。
- **`icon`**（*图像*）：在支持它的窗口管理器的标题栏或任务栏中显示的窗口图标。
- **`no-frame`**（*布尔值*）：窗口是否应该是无边框/无框架的。
- **`resize-border-width`**（*长度*）：无边框/无框架窗口中的调整边框大小。（目前仅适用于 winit）
- **`title`**（*字符串*）：在标题栏中显示的窗口标题。




