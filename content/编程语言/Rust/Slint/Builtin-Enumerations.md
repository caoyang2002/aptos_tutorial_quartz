---
title: 内置枚举
---
# 内置枚举

## `AccessibleRole`

这个枚举代表了 `accessible-role` 属性的不同值，用于描述元素在辅助技术（如屏幕阅读器）中的角色。

- **`none`**：元素不可访问。
- **`button`**：元素是一个 [`Button`](https://slint.dev/releases/1.7.2/docs/slint/src/language/widgets/button) 或表现得像一个按钮。
- **`checkbox`**：元素是一个 [`CheckBox`](https://slint.dev/releases/1.7.2/docs/slint/src/language/widgets/checkbox) 或表现得像一个复选框。
- **`combobox`**：元素是一个 [`ComboBox`](https://slint.dev/releases/1.7.2/docs/slint/src/language/widgets/combobox) 或表现得像一个组合框。
- **`list`**：元素是一个 [`ListView`](https://slint.dev/releases/1.7.2/docs/slint/src/language/widgets/listview) 或表现得像一个列表。
- **`slider`**：元素是一个 [`Slider`](https://slint.dev/releases/1.7.2/docs/slint/src/language/widgets/slider) 或表现得像一个滑块。
- **`spinbox`**：元素是一个 [`SpinBox`](https://slint.dev/releases/1.7.2/docs/slint/src/language/widgets/spinbox) 或表现得像一个旋转框。
- **`tab`**：元素是一个 [`Tab`](https://slint.dev/releases/1.7.2/docs/slint/src/language/widgets/tabwidget) 或表现得像一个标签。
- **`tab-list`**：元素类似于 [`TabWidget`](https://slint.dev/releases/1.7.2/docs/slint/src/language/widgets/tabwidget) 中的标签栏。
- **`text`**：[`Text`](https://slint.dev/releases/1.7.2/docs/slint/src/language/builtins/elements) 元素的角色。它会自动应用。
- **`table`**：[`TableView`](https://slint.dev/releases/1.7.2/docs/slint/src/language/widgets/standardtableview) 的角色或表现得像一个表格。
- **`tree`**：树视图的角色或表现得像一个树视图。（尚未提供）
- **`progress-indicator`**：元素是一个 [`ProgressIndicator`](https://slint.dev/releases/1.7.2/docs/slint/src/language/widgets/progressindicator) 或表现得像一个进度指示器。
- **`text-input`**：可编辑文本的控件（如 [`LineEdit`](https://slint.dev/releases/1.7.2/docs/slint/src/language/widgets/lineedit) 或 [`TextEdit`](https://slint.dev/releases/1.7.2/docs/slint/src/language/widgets/textedit)）的角色。
- **`switch`**：元素是一个 [`Switch`](https://slint.dev/releases/1.7.2/docs/slint/src/language/widgets/switch) 或表现得像一个开关。

## `ColorScheme`

这个枚举指示小部件样式使用的颜色方案。使用此枚举可以在暗色和亮色方案之间明确切换，或选择 Unknown 以回退到系统默认设置。

- **`unknown`**：方案未知，由系统范围设置配置。这可能意味着小部件以暗色或亮色方案显示，但也可能是自定义颜色方案。
- **`dark`**：样式为背景选择浅色，前景选择深色。
- **`light`**：样式为背景选择深色，前景选择浅色。

## `DialogButtonRole`

这个枚举代表了 `dialog-button-role` 属性的值，可以添加到 [`Dialog`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#dialog) 中的任何元素，以将该项置于按钮行中，其确切位置取决于角色和平台。

- **`none`**：这不是一个打算放入底部行的按钮。
- **`accept`**：这是用于接受对话框的主要按钮的角色，例如 “Ok” 或 “Yes”。
- **`reject`**：这是用于拒绝对话框的主要按钮的角色，例如 “Cancel” 或 “No”。
- **`apply`**：这是 “Apply” 按钮的角色。
- **`reset`**：这是 “Reset” 按钮的角色。
- **`help`**：这是 “Help” 按钮的角色。
- **`action`**：这是执行其他操作的任何其他按钮的角色。

## `EventResult`

这个枚举描述了事件是否被事件处理器拒绝或接受。

- **`reject`**：事件被此事件处理器拒绝，然后可能由父项处理。
- **`accept`**：事件被接受，将不再进一步处理。

## `FillRule`

这个枚举描述了决定路径描述的形状内部应如何的不同方式。

- **`nonzero`**：SVG 中定义的 [“nonzero”填充规则](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/fill-rule#nonzero)。
- **`evenodd`**：SVG 中定义的 [“evenodd”填充规则](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/fill-rule#evenodd)。

## `ImageFit`

这个枚举定义了源图像应如何适应 [`Image`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#image) 元素。

- **`fill`**：缩放并拉伸源图像以适应 [`Image`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#image) 元素的宽度和高度。
- **`contain`**：缩放源图像以适应 [`Image`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#image) 元素的尺寸，同时保持宽高比。
- **`cover`**：缩放源图像以覆盖 [`Image`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#image) 元素的尺寸，同时保持宽高比。如果源图像的宽高比与元素的宽高比不匹配，则图像将被裁剪以适应。
- **`preserve`**：保持源图像在逻辑像素中的大小。源图像仍将根据适用于窗口中所有元素的缩放因子进行缩放。任何额外的空间将留空。

## `ImageHorizontalAlignment`

这个枚举指定源图像的水平对齐方式。

- **`center`**：将源图像对齐到 [`Image`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#image) 元素的中心。
- **`left`**：将源图像对齐到 [`Image`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#image) 元素的左侧。
- **`right`**：将源图像对齐到 [`Image`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#image) 元素的右侧。

## `ImageRendering`

这个枚举指定源图像将如何被缩放。

- **`smooth`**：图像使用线性插值算法进行缩放。
- **`pixelated`**：图像使用最近邻算法进行缩放。

## `ImageTiling`

这个枚举指定源图像将如何平铺。

- **`none`**：源图像将不平铺。
- **`repeat`**：源图像将被重复以填充 [`Image`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#image) 元素。
- **`round`**：源图像将被重复并缩放以填充 [`Image`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#image) 元素，确保重复次数为整数。

## `ImageVerticalAlignment`

这个枚举指定源图像的垂直对齐方式。

- **`center`**：将源图像对齐到 [`Image`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#image) 元素的中心。
- **`top`**：将源图像对齐到 [`Image`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#image) 元素的顶部。
- **`bottom`**：将源图像对齐到 [`Image`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#image) 元素的底部。

## `InputType`

这个枚举用于定义输入字段的类型。

- **`text`**：默认值。这将正常渲染所有字符。
- **`password`**：这将以默认为 “*” 的字符渲染所有字符。
- **`number`**：这只接受并渲染数字字符（0-9）。
- **`decimal`**：如果它是小数的有效部分，这只接受并渲染字符。

## `LayoutAlignment`

枚举代表 [`HorizontalBox`](https://releases.slint.dev/1.7.2/docs/slint/src/language/widgets/horizontalbox), 一个 [`VerticalBox`](https://releases.slint.dev/1.7.2/docs/slint/src/language/widgets/verticalbox), 一个 [`HorizontalLayout`, 或 `VerticalLayout`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#verticallayout-and-horizontallayout) 的 [对齐](https://releases.slint.dev/1.7.2/docs/slint/src/language/concepts/layouting#alignment) 属性。

- **`stretch`**：使用布局中所有元素的最小大小，根据 `*-stretch` 在所有元素之间分配剩余空间。
- **`center`**：对所有元素使用首选大小，将剩余空间均匀分配在第一个元素之前和最后一个元素之后。
- **`start`**：对所有元素使用首选大小，将剩余空间放在最后一个元素之后。
- **`end`**：对所有元素使用首选大小，将剩余空间放在第一个元素之前。
- **`space-between`**：对所有元素使用首选大小，将剩余空间均匀分配在元素之间。
- **`space-around`**：对所有元素使用首选大小，将剩余空间均匀分配在第一个元素之前，最后一个元素之后以及元素之间。

## `MouseCursor`

这个枚举代表不同类型的鼠标光标。它是 CSS 中可用鼠标光标的一个子集。有关详细信息和图示，请参阅 [MDN 文档中的光标](https://developer.mozilla.org/en-US/docs/Web/CSS/cursor#values)。根据后端和使用的操作系统，单向调整大小的光标可能会被双向光标替换。

- **`default`**：系统的默认光标。
- **`none`**：不显示光标。
- **`help`**：指示帮助信息的光标。
- **`pointer`**：指示链接的指向手形光标。
- **`progress`**：程序忙碌但仍然可以交互。
- **`wait`**：程序忙碌。
- **`crosshair`**：十字准线。
- **`text`**：指示可选中文本的光标。
- **`alias`**：正在创建别名或快捷方式。
- **`copy`**：正在创建副本。
- **`move`**：需要移动某物。
- **`no-drop`**：这里不能放下某物。
- **`not-allowed`**：不允许执行操作。
- **`grab`**：可以抓取某物。
- **`grabbing`**：正在抓取某物。
- **`col-resize`**：指示可以水平调整列的大小。
- **`row-resize`**：指示可以垂直调整行的大小。
- **`n-resize`**：向北单向调整大小。
- **`e-resize`**：向东单向调整大小。
- **`s-resize`**：向南单向调整大小。
- **`w-resize`**：向西单向调整大小。
- **`ne-resize`**：向东北单向调整大小。
- **`nw-resize`**：向西北单向调整大小。
- **`se-resize`**：向东南单向调整大小。
- **`sw-resize`**：向西南单向调整大小。
- **`ew-resize`**：双向调整大小（东西方向）。
- **`ns-resize`**：双向调整大小（南北方向）。
- **`nesw-resize`**：双向调整大小（东北-西南）。
- **`nwse-resize`**：双向调整大小（西北-东南）。

## `Orientation`

表示元素或控件（如 [`Slider`](https://releases.slint.dev/1.7.2/docs/slint/src/language/widgets/slider)）的方向。

- **`horizontal`**：元素水平方向排列。
- **`vertical`**：元素垂直方向排列。

## `PathEvent`

`PathEvent` 是一个低级数据结构，描述路径的组成。通常它是在编译时从高级描述（如 SVG 命令）生成的。

- **`begin`**：路径的开始。
- **`line`**：路径上的直线。
- **`quadratic`**：路径上的二次贝塞尔曲线。
- **`cubic`**：路径上的三次贝塞尔曲线。
- **`end-open`**：保持开放的路径的结束。
- **`end-closed`**：闭合路径的结束。

## `PointerEventButton`

这个枚举描述了指针事件（通常在鼠标或铅笔上）的不同类型按钮。

- **`other`**：不是左键、右键或中键的按钮。例如，这用于具有多个按钮的鼠标上的第四个按钮。
- **`left`**：左键。
- **`right`**：右键。
- **`middle`**：中键。

## `PointerEventKind`

枚举报告在事件中 `PointerEventButton` 发生了什么

- **`cancel`**：操作被取消。
- **`down`**：按钮被按下。
- **`up`**：按钮被释放。
- **`move`**：指针移动，

## `SortOrder`

这个枚举代表了 `sort-order` 属性的不同值。它用于按列对 [`StandardTableView`](https://releases.slint.dev/1.7.2/docs/slint/src/language/widgets/standardtableview) 进行排序。

- **`unsorted`**：列未排序。
- **`ascending`**：列按升序排序。
- **`descending`**：列按降序排序。

## `StandardButtonKind`

使用此枚举向 [`Dialog`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#dialog) 添加标准按钮。这些 [`StandardButton`](https://releases.slint.dev/1.7.2/docs/slint/src/language/widgets/standardbutton) 的外观和定位取决于应用程序运行的环境（操作系统，UI 环境等）。

- **`ok`**：一个 “OK” 按钮，接受 [`Dialog`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#dialog) 并在点击时关闭它。
- **`cancel`**：一个 “Cancel” 按钮，拒绝 [`Dialog`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#dialog) 并在点击时关闭它。
- **`apply`**：一个 “Apply” 按钮，应该在接受 [`Dialog`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#dialog) 的值而不关闭它的情况下使用。
- **`close`**：一个 “Close” 按钮，应该在不查看值的情况下关闭 [`Dialog`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#dialog)。
- **`reset`**：一个 “Reset” 按钮，应该将 [`Dialog`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#dialog) 重置为其初始状态。
- **`help`**：一个 “Help” 按钮，点击时应该显示与上下文相关的文档。
- **`yes`**：一个 “Yes” 按钮，用于确认操作。
- **`no`**：一个 “No” 按钮，用于拒绝操作。
- **`abort`**：一个 “Abort” 按钮，用于中止操作。
- **`retry`**：一个 “Retry” 按钮，用于重试失败的操作。
- **`ignore`**：一个 “Ignore” 按钮，用于忽略失败的操作。

## `TextHorizontalAlignment`

这个枚举描述了 [`Text`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#text) 元素沿水平轴的不同对齐类型。

- **`left`**：文本将与包含框的左边缘对齐。
- **`center`**：文本将在包含框内水平居中。
- **`right`**：文本将对齐到包含框的右侧。

## `TextOverflow`

这个枚举描述了如果文本太宽而无法适应 [`Text`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#text) 宽度时的外观。

- **`clip`**：文本将被简单裁剪。
- **`elide`**：文本将用 `…` 省略。

## `TextStrokeStyle`

这个枚举描述了 [`Text`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#text) 中的文本笔画相对于字形边界的位置。

- **`outside`**：笔画的内边缘位于文本的外边缘。
- **`center`**：笔画的中心线位于文本的外边缘，就像在 Adobe Illustrator 中一样。

## `TextVerticalAlignment`

这个枚举描述了 [`Text`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#text) 元素沿垂直轴的不同对齐类型。

- **`top`**：文本将与包含框的顶部对齐。
- **`center`**：文本将在包含框内垂直居中。
- **`bottom`**：文本将与包含框的底部对齐。

## `TextWrap`

这个枚举描述了如果文本太宽而无法适应 [`Text`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/elements#text) 宽度时的换行方式。

- **`no-wrap`**：文本不会换行，而是会溢出。
- **`word-wrap`**：如果可能，文本将在单词边界处换行，或者在任何位置换行，对于非常长的单词。
- **`char-wrap`**：文本将在任何字符处换行。目前仅由 Qt 和软件渲染器支持。


