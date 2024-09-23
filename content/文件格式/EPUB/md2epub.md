---
title: markdiwn 转 epub
---
# Python 实现将 Markdown 文档转换为 EPUB 电子书文件

## Markdown

Markdown 是一种轻量级的标记语言，用于以简单且易于阅读的方式格式化文本。它由 John Gruber 在 2004 年创建，旨在允许人们使用易于阅读和编写的纯文本格式编写内容。

Markdown 使用一种纯文本格式化语法，可以轻松转换为 HTML。这使得它成为编写网页内容的流行选择，因为它允许作者快速创建格式化的文本，而无需复杂的 HTML 或 CSS 编码。

一些常见的 Markdown 语法包括：

- 标题：以一个或多个 `#` 符号开头的行来指示标题级别（例如 `#` 表示 `H1`，`##` 表示 `H2`，`###` 表示 H3 等）。
- 强调：使用星号或下划线来表示斜体或粗体文本（例如 `_斜体_`、`**粗体**` 或 `**_粗斜体_**`）。
- 列表：通过以数字或破折号开头的行来创建有序或无序列表。
- 链接：通过将链接文本括在方括号中，然后在括号中跟上 URL 来创建超链接（例如 `[Google](https://www.google.com)`）。
- 图片：通过将 alt 文本括在方括号中，然后在括号中跟上图像 URL 来插入图像（例如 `![Alt text](image.jpg)`）。

Markdown 可以在各种应用程序和平台中使用，包括基于 Web 的工具如 GitHub、Stack Overflow 和 Reddit，以及桌面应用程序如 Typora 和 Atom。

## EPUB

EPUB 是一种开放标准的电子书格式，可以在不同的设备上阅读，包括电脑、平板电脑、智能手机以及专门的电子阅读器等。是目前应用最广泛的电子书格式是 EPUB（Electronic Publication）。

EPUB 格式具有可伸缩性，可以根据不同的屏幕尺寸和设备进行自适应调整，使得阅读体验更加舒适。此外，EPUB 格式还支持图像、表格、脚注等多种元素，可以更好地呈现书籍内容。

EPUB 格式的优势在于其开放性和可移植性，可以在不同的操作系统和软件中使用。同时，EPUB 格式支持数字版权管理（DRM）技术，保护版权和防止盗版的问题。因此，EPUB 格式已成为电子书市场的主流格式。

## 已有转换工具

要将 Markdown 文档转换为 EPUB 文件，可以使用一些工具和软件。以下是一些常见的方法：

1. 使用在线转换工具：有一些在线转换工具可以将 Markdown 文件转换为 EPUB 格式，如 [Pandoc Online](https://pandoc.org/try/)。只需要将 Markdown 文件上传到该网站，然后选择 EPUB 格式，最后点击转换即可。转换完成后，可以下载 EPUB 文件到本地。

2. 使用 Pandoc 命令行工具：Pandoc 是一款免费的开源文本转换工具，可以将 Markdown 文件转换为多种格式，包括 EPUB。首先，需要在计算机上安装 Pandoc 软件。然后，在终端或命令行中输入以下命令：

   ```bash
   pandoc input.md -o output.epub
   ```

   其中，input.md 是要转换的 Markdown 文件名，`output.epub` 是输出的 EPUB 文件名。转换完成后，可以在当前目录下找到 EPUB 文件。

3. 使用 Calibre 桌面应用：[Calibre](https://calibre-ebook.com/) 是一款免费的电子书管理软件，也可以用于将 Markdown 文件转换为 EPUB 格式。首先，需要在计算机上安装 Calibre 软件。然后，打开 Calibre，点击“添加书籍”按钮，选择 Markdown 文件。在添加完成后，选中该文件，然后点击“转换书籍”按钮。在转换对话框中，选择 EPUB 格式，然后点击“确定”按钮即可。转换完成后，可以在 Calibre 中找到 EPUB 文件，并将其导出到本地。

## Python 实现将 Markdown 文档转换为 EPUB 电子书文件

以下是将 Markdown 转换为 EPUB 的步骤：

1. [安装 Pandoc](https://pandoc.org/installing.html)：Pandoc 是一个文档转换器，可以将 Markdown 转换为多种格式，包括 EPUB。

   在 macOS 终端的安装命令：

   ```bash
    brew install pandoc
   ```

2. 安装 pypandoc：pypandoc 是 Python 中的一个库，它允许使用 Python 代码调用 Pandoc。可以使用以下命令安装 pypandoc：

   ```bash
   pip install pypandoc
   ```

3. 编写 Python 代码：以下是将 Markdown 文件转换为 EPUB 文件的 Python 代码示例：

   ```python
   import os
   import pypandoc
   from ebooklib import epub
    
   md_folder = "./markdowns/"
   md_file = "My EPUB Book.md"
    
   epub_folder = './epubs/'
   epub_file = "My EPUB Book.epub"
    
   if not os.path.exists(epub_folder):
      os.makedirs(epub_folder)
    
   # 将 Markdown文件转换为 EPUB文件
   pypandoc.convert_file(
      os.path.join(md_folder, md_file), 'epub',
      outputfile=os.path.join(epub_folder, epub_file))
    
   ### 修改转换后的 EPUB 元数据 ###
    
   # 读取 epub 文件
   book = epub.read_epub(os.path.join(epub_folder, epub_file))
   # 修改元数据
   book.set_title('My EPUB Book')
   book.add_author('飞仔FeiZai')
   book.set_language('zh')
    
   epub_new_file = "My EPUB Book.epub"
   # 保存更改
   epub.write_epub(os.path.join(epub_folder, epub_new_file), book)
   ```

   在上面的代码中，`input.md`是要转换的 Markdown 文件的路径，`output.epub`是 EPUB 输出文件的路径。`pypandoc.convert_file`函数将 Markdown 文件转换为 EPUB 文件，并将其写入输出文件。

4. 运行代码：在终端中运行 Python 代码：

   ```bash
   python convert.py
   ```

   在上面的命令中，`convert.py`是包含上述 Python 代码的文件的名称。

以上是将 Markdown 文档转换为 EPUB 文件的 Python 代码示例。可以根据自己的需求进行修改和调整。

## Python 实现将多个 Markdown 文档转换为一个 EPUB 电子书文件

要将多个 Markdown 文档转换为一个 EPUB 电子书文件，可以使用 Python 中的第三方库 `ebooklib`。首先需要安装这个库，可以使用以下命令在终端中安装：

```bash
pip install ebooklib
```

接下来，可以编写 Python 代码来将 Markdown 文件转换为 EPUB 文件。以下是一个示例代码：

```python
import os
from ebooklib import epub
import subprocess
 
# 定义 Markdown 文件夹路径和 EPUB 文件名
md_folder = "./markdowns/My EPUB Book/"
 
epub_folder = './epubs/'
epub_file = "My EPUB Book.epub"
 
# 创建 EPUB 文件对象
book = epub.EpubBook()
 
# 设置 EPUB 书籍的元数据
book.set_identifier("123456789")
book.set_title("My EPUB Book")
book.set_language("zh")
book.add_author('FeiZai')
 
# 添加章节
for md_file in os.listdir(md_folder):
    if md_file.endswith(".md"):
        # 将 Markdown 文件转换为 HTML 文件
        html_file = md_file.replace(".md", ".html")
        subprocess.call(["pandoc", "-s", os.path.join(md_folder, md_file),
                        "-o", os.path.join(md_folder, html_file)])
 
        # 创建章节对象
        chapter = epub.EpubHtml(title=md_file.replace(
            ".md", ""), file_name=html_file, lang='zh')
        chapter.content = open(os.path.join(md_folder, html_file), 'r',
                               encoding='utf-8').read()
 
        # 将章节添加到书籍中
        book.add_item(chapter)
        book.toc.append(chapter)
 
# add default NCX and Nav file
book.add_item(epub.EpubNcx())
# book.add_item(epub.EpubNav())
 
# 设置封面
# book.set_cover("cover.jpg", open(
#     os.path.join(md_folder, "cover.jpg"), "rb").read())
 
if not os.path.exists(epub_folder):
    os.makedirs(epub_folder)
# 生成 EPUB 文件
epub.write_epub(os.path.join(epub_folder, epub_file), book, {})
```

在以上代码中，首先定义了 Markdown 文件夹路径和 EPUB 文件名。然后，使用 `ebooklib` 创建了一个 EPUB 书籍对象，并设置了元数据。接着，遍历 Markdown 文件夹中的所有 Markdown 文件，将其转换为 HTML 文件，并创建章节对象，将章节添加到书籍中。最后，设置封面并生成 EPUB 文件。

需要注意的是，以上代码中调用了 `subprocess` 模块中的 `call` 函数来执行 `pandoc` 命令来将 Markdown 文件转换为 HTML 文件。因此，在使用此代码之前，需要确保已经安装了 `pandoc`。

