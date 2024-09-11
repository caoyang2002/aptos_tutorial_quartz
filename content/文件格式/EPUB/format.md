---
title: epub 格式
---
# 步骤 1：解压 EPUB 文件

1. **重命名文件扩展名**（可选）：将 EPUB 文件的扩展名从 `.epub` 改为 `.zip`。这使得它可以用任何标准的解压缩工具打开。
   
   例如，将 `example.epub` 重命名为 `example.zip`。

2. **解压文件**：使用压缩文件管理工具（如 7-Zip、WinRAR、macOS 自带的压缩工具等）解压 `.zip` 文件。解压后，你会看到一个文件夹，其中包含了 EPUB 的结构文件，如 `META-INF`、`OEBPS`（或 `content`）等目录。

# 步骤 2：编辑文件

1. **编辑文本内容**：
   - 找到 EPUB 中的 HTML 或 XHTML 文件，这些文件通常位于 `OEBPS` 或 `content` 文件夹内。这些文件包含了电子书的实际内容。
   - 使用文本编辑器（如 Notepad++、VS Code、Sublime Text）打开这些 HTML 文件，并进行所需的编辑。

2. **编辑样式**：
   - CSS 文件通常存放在 `OEBPS/styles` 或 `content/styles` 文件夹内。你可以编辑这些 CSS 文件来更改 EPUB 的样式和布局。

3. **编辑元数据**：
   - `META-INF` 文件夹内的 `container.xml` 文件定义了 EPUB 文件的结构和主要内容文件的位置。
   - `OEBPS` 文件夹内的 `content.opf` 文件包含元数据、内容清单等信息。可以用文本编辑器打开并编辑这个文件。
   - `content.opf` 文件中包含标题、作者、语言等信息，你可以修改这些信息来更新 EPUB 的元数据。

4. **修改封面**：
   - 封面图像通常位于 `OEBPS/images` 或 `content/images` 文件夹中。可以用图片编辑工具（如 Photoshop、GIMP）编辑这些图像，然后用同样的文件名替换原有图像。




### 2.1 编辑文本内容

EPUB 文件的实际内容通常以 HTML 或 XHTML 文件的形式存在。你可以按照以下步骤编辑这些文件：

1. **找到 HTML/XHTML 文件**：
   - 在解压后的 EPUB 文件夹中，HTML 或 XHTML 文件一般位于 `OEBPS` 或 `content` 文件夹内。例如，可能是 `OEBPS/Text` 或 `content/text`。

2. **使用文本编辑器打开文件**：
   - 选择一个合适的文本编辑器，如 Notepad++、Visual Studio Code、Sublime Text 等。这些编辑器提供了语法高亮和格式化功能，使得编辑 HTML 文件更为方便。

3. **编辑内容**：
   - 在 HTML 文件中，你可以修改文本、添加新的内容、改变内容结构等。例如：
     ```html
     <h1>原始标题</h1>
     <p>这是原始内容。</p>
     ```
     可以改成：
     ```html
     <h1>新标题</h1>
     <p>这是更新后的内容。</p>
     ```

4. **保存文件**：
   - 保存修改后的文件，并确保保留原有的文件名和扩展名（例如 `.html` 或 `.xhtml`）。

### 2.2 编辑样式

EPUB 文件中的样式表通常是 CSS 文件，用于定义文本的样式、布局和设计。编辑这些文件可以改变 EPUB 的外观。

1. **找到 CSS 文件**：
   - CSS 文件通常位于 `OEBPS/styles` 或 `content/styles` 文件夹中。文件通常以 `.css` 扩展名结尾。

2. **使用文本编辑器打开文件**：
   - 使用如 Notepad++、Visual Studio Code、Sublime Text 等文本编辑器打开 CSS 文件。

3. **编辑样式**：
   - 修改现有的样式规则，添加新的样式。例如：
     ```css
     p {
         font-size: 14px;
         color: black;
     }
     ```
     可以改成：
     ```css
     p {
         font-size: 16px;
         color: darkblue;
     }
     ```

4. **保存文件**：
   - 保存修改后的 CSS 文件，确保文件名和路径保持不变。

### 2.3 编辑元数据

EPUB 文件的元数据通常存储在 `content.opf` 文件中，这个文件包含了书籍的标题、作者、语言等信息。

1. **找到 `content.opf` 文件**：
   - `content.opf` 文件通常位于 `OEBPS` 文件夹中，例如 `OEBPS/content.opf`。

2. **使用文本编辑器打开文件**：
   - 使用 Notepad++、Visual Studio Code、Sublime Text 等文本编辑器打开 `content.opf` 文件。这个文件是 XML 格式的。

3. **编辑元数据**：
   - 修改或添加元数据。例如：
     ```xml
     <metadata>
         <dc:title>原始标题</dc:title>
         <dc:creator>原始作者</dc:creator>
         <dc:language>en</dc:language>
     </metadata>
     ```
     可以改成：
     ```xml
     <metadata>
         <dc:title>新标题</dc:title>
         <dc:creator>新作者</dc:creator>
         <dc:language>zh</dc:language>
     </metadata>
     ```

4. **保存文件**：
   - 保存修改后的 `content.opf` 文件。

### 2.4 修改封面

封面图像通常存储在 `OEBPS/images` 或 `content/images` 文件夹中。你可以更换图像文件来更新封面。

1. **找到封面图像**：
   - 在 `OEBPS/images` 或 `content/images` 文件夹中找到封面图像文件，通常是 `.jpg` 或 `.png` 格式。

2. **编辑或替换图像**：
   - 使用图像编辑工具（如 Adobe Photoshop、GIMP）打开和编辑图像。修改完毕后，将图像保存为相同的文件格式和文件名。

3. **替换原始图像**：
   - 将修改后的图像文件替换掉原始的封面图像文件。如果更改了文件名，请确保更新 `content.opf` 文件中的引用路径。

4. **保存和更新**：
   - 确保修改后的图像保存在正确的位置，并且文件名与 EPUB 中的引用一致。


# 步骤 3：重新打包 EPUB 文件

1. **重新压缩文件**：将修改后的文件夹重新打包为 ZIP 文件。确保压缩时保留文件夹结构和文件路径。

2. **重命名扩展名**：将 `.zip` 文件扩展名重新改为 `.epub`。确保文件的 MIME 类型正确。

# 注意事项

- **备份**：在编辑 EPUB 文件之前，最好备份原始文件，以防止任何意外的损坏或丢失。

- **EPUB 校验**：编辑完成后，你可以使用 EPUB 校验工具（如 [EpubCheck](https://github.com/epubcheck/epubcheck)）来确保修改后的 EPUB 文件符合 EPUB 标准。

- **工具**：除了手动编辑外，还有一些专门的 EPUB 编辑工具（如 [Sigil](https://sigil-ebook.com/) 和 [Calibre](https://calibre-ebook.com/)）可以帮助你更方便地编辑和管理 EPUB 文件。

# 示例操作

假设你有一个名为 `example.epub` 的文件：

1. 将 `example.epub` 重命名为 `example.zip`。
2. 解压 `example.zip` 到一个文件夹。
3. 编辑 `OEBPS` 文件夹中的 HTML、CSS 或其他文件。
4. 用图像编辑工具修改封面图像。
5. 将修改后的文件夹重新压缩为 `example.zip`。
6. 将 `example.zip` 重命名为 `example.epub`。

通过这些步骤，你可以手动编辑 EPUB 文件的内容和样式。