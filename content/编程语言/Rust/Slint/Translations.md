---
title: 翻译
---

# 翻译

Slint 的翻译基础设施使您的应用程序能够支持多种语言。

## 概述

安装 `slint-tr-extractor` 工具以从 `.slint` 文件中提取可翻译的字符串：

```
cargo install slint-tr-extractor
```

完成以下步骤以翻译您的应用程序：

1. 确定所有需要翻译的用户可见字符串，并用 `@tr()` 宏进行标注。
2. 运行 `slint-tr-extractor` 工具提取标注的字符串并生成 `.pot` 文件。
3. 使用第三方工具将字符串翻译为目标语言，生成 `.po` 文件。
4. 使用 [gettext 的 `msgfmt`](https://www.gnu.org/software/gettext/manual/gettext.html) 工具将 `.po` 文件转换为可在运行时加载的 `.mo` 文件。
5. 使用 Slint 的 API 根据用户的区域设置选择并加载 `.mo` 文件。

此时，所有标记为翻译的字符串将自动以目标语言呈现。

## 标注可翻译字符串

在 `.slint` 文件中使用 `@tr` 宏标记需要翻译的字符串。此宏负责处理翻译和格式化，替换 `{}` 占位符。

第一个参数必须是普通字符串文字，后面跟随参数：

```typescript
export component Example {
    property <string> name;
    Text {
        text: @tr("Hello, {}", name);
    }
}
```

### 格式化

`@tr` 宏将每个 `{}` 占位符替换为对应的参数。也可以使用 `{0}`、`{1}` 等重新排序参数。翻译者可以使用有序占位符，即使原始字符串没有。

您可以通过在字符串中前置相同字符来包含字面字符 `{` 和 `}`，例如，用 `{{` 转义 `{`，用 `}}` 转义 `}`。

### 复数形式

当涉及可变数量元素的文本翻译时，根据单个元素或多个元素的情况改变文本格式。

给定 `count` 以及表示某种计数的表达式，使用 `|` 和 `%` 符号形成复数：

`@tr("I have {n} item" | "I have {n} items" % count)`。

在格式字符串中使用 `{n}` 访问 `%` 后面的表达式。

```cpp
export component Example inherits Text {
    in property <int> score;
    in property <int> name;
    text: @tr("Hello {0}, you have one point" | "Hello {0}, you have {n} point" % score, name);
}
```

### 上下文

通过在 `@tr(...)` 宏中添加上下文，使用 `"..." =>` 语法来消歧义具有相同源文本但不同上下文含义的字符串。

使用上下文为翻译者提供额外的信息，确保翻译准确且符合上下文。

上下文必须是普通字符串文字，并在 `.pot` 文件中显示为 `msgctx`。如果未指定，默认上下文为周围组件的名称。

```typescript
export component MenuItem {
    property <string> name : @tr("Default Name"); // 默认：`MenuItem` 将是上下文。
    property <string> tooltip : @tr("ToolTip" => "ToolTip for {}", name); // 指定：上下文为 `ToolTip`。
}
```

## 提取可翻译字符串

使用 `slint-tr-extractor` 工具从 `.slint` 文件生成 `.pot` 文件。可以这样运行：

```
find -name \*.slint | xargs slint-tr-extractor -o MY_PROJECT.pot
```

这会创建一个名为 `MY_PROJECT.pot` 的文件。将“MY_PROJECT”替换为您的实际项目名称。要了解项目名称如何影响翻译查找，请阅读以下部分。

`.pot` 文件是 [Gettext](https://www.gnu.org/software/gettext/) 模板文件。

## 翻译字符串

通过从 `.pot` 文件创建 `.po` 文件开始新的翻译。两种文件格式是相同的。您可以手动复制文件或使用像 Gettext 的 `msginit` 这样的工具开始新的 `.po` 文件。

`.po` 文件包含目标语言中的字符串。

`.po` 和 `.pot` 文件是纯文本文件，可以用文本编辑器编辑。我们建议使用专用翻译工具，例如：

- [poedit](https://poedit.net/)
- [OmegaT](https://omegat.org/)
- [Lokalize](https://userbase.kde.org/Lokalize)
- [Transifex](https://www.transifex.com/)（Web 界面）

## 将 `.po` 文件转换为 `.mo` 文件

将可读的 `.po` 文件转换为机器友好的 `.mo` 文件，这是一种更高效的二进制表示。

使用 [Gettext](https://www.gnu.org/software/gettext/) 的 `msgfmt` 命令行工具将 `.po` 文件转换为 `.mo` 文件：

```
msgfmt translation.po -o translation.mo
```

## 在运行时选择和加载 `.mo` 文件

Slint 使用 [Gettext](https://www.gnu.org/software/gettext/) 库在运行时加载翻译。Gettext 期望翻译文件（称为消息目录）在以下目录层次结构中：

```
dir_name/locale/LC_MESSAGES/domain_name.mo
```

- `dir_name`：您可以自由选择的基础目录。

- `locale`：用户的语言环境名称，例如法语为 `fr`，德语为 `de`。

  语言环境通常使用您的操作系统设置的环境变量确定。

- `domain_name`：根据您使用 Slint 的编程语言选择。

有关更多信息，请阅读 [Gettext 文档](https://www.gnu.org/software/gettext/manual/gettext.html#Locating-Catalogs)。

### 使用 Rust 选择和加载翻译

首先，在 `features` 部分启用 `slint` crate 的 `gettext` 特性，以访问翻译 API 并激活运行时翻译支持。

接下来，使用 `slint::init_translations!` 宏指定 `.mo` 文件的基本位置。这是上一节方案中的 `dir_name`。Slint 期望 `.mo` 文件位于相应的子目录中，并且文件名 - `domain_name` - 必须与您的 `Cargo.toml` 中的包名匹配。这通常与 crate 名称相同。

例如：

```
slint::init_translations!(concat!(env!("CARGO_MANIFEST_DIR"), "/lang/"));
```

例如，如果您的 `Cargo.toml` 包含以下行，并且用户的语言环境为 `fr`：

```
[package]
name = "gallery"
```

在这些设置下，Slint 将在 `lang/fr/LC_MESSAGES/gallery.mo` 中查找 `gallery.mo`。

### 使用 C++ 选择和加载翻译

首先，在编译 Slint 时启用 `SLINT_FEATURE_GETTEXT` cmake 选项，以访问翻译 API 并激活运行时翻译支持。

在使用 cmake 的 C++ 应用程序中，`domain_name` 是 CMake 目标名称。

接下来，使用标准 gettext 库将文本域绑定到路径。

为此，在您的 `CMakeLists.txt` 文件中添加以下内容：

```
find_package(Intl)
if(Intl_FOUND)
    target_compile_definitions(my_application PRIVATE HAVE_GETTEXT SRC_DIR="${CMAKE_CURRENT_SOURCE_DIR}")
    target_link_libraries(my_application PRIVATE Intl::Intl)
endif()
```

然后设置语言环境和文本域：

```
#ifdef HAVE_GETTEXT
#    include <locale>
#    include <libintl.h>
#endif

int main()
{
#ifdef HAVE_GETTEXT
    bindtextdomain("my_application", SRC_DIR "/lang/");
    std::locale::global(std::locale(""));
#endif
   //...
}
```

例如，如果您使用上述代码，并且用户的语言环境为 `fr`，Slint 将在 `lang/fr/LC_MESSAGES/` 目录中查找 `my_application.mo`。

## 使用 `slint-viewer` 预览翻译

使用 `slint-viewer` 预览 `.slint` 文件中的翻译：

```
cargo install slint-viewer
```

1. 在编译 `slint-viewer` 时启用 `gettext` 特性。
2. 使用 `--translation-domain` 和 `translation-dir` 命令行选项加载翻译并根据当前语言环境显示它们。