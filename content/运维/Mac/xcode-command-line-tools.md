---
title: 安装 xcode 命令行工具
aliases:
  - 安装 xcode 命令行工具
---
# 使用安装包安装
https://developer.apple.com/download/all/ 


# 使用命令行安装
https://stackoverflow.com/questions/34617452/how-to-update-xcode-from-command-line


1. 移除旧工具（`$ sudo rm -rf /Library/Developer/CommandLineTools`）
2. 再次安装 xcode 命令行工具（`$ xcode-select --install`）。

https://forums.developer.apple.com/forums/thread/677124
```error
xcode-select: note: Command line tools are already installed. Use "Software Update" in System Settings or the softwareupdate command line interface to install updates
```
在反复收到相同的错误后 - 甚至在更新之后 - 我找到了一种让它工作的方法，假设您正在使用 Ventura 13.0.1 (22A400)：

1. 准备终端命令：`xcode-select --install`
2. 打开“设置”>“常规”>“软件更新”
3. 运行命令，按照提示进行安装，下载时会弹出

![](https://developer.apple.com/forums/content/attachment/09e4dfd8-35f1-4c34-9bdd-69cc6f746c89 "软件更新.png")

1. 同时在软件更新中启动更新
2. 终端命令的提示最终返回以下内容：

![](https://developer.apple.com/forums/content/attachment/330fa45b-34b6-4d07-9c62-9aea4affd12e "已安装.png")

1. 软件更新中仍提供更新，但“立即更新”没有任何效果
2. 返回终端并运行：`xcode-select -p`
3. 我返回的是：`/Applications/Xcode.app/Contents/Developer`——所以我运行了这个：`sudo xcode-select --switch /Library/Developer/CommandLineTools`

瞧，Xcode 命令行工具被识别为已更新。您可以检查 `xcode-select --install`以查看返回 `xcode-select：错误：命令行工具已安装，请使用系统设置中的‘软件更新’安装更新”现在命令行工具可以正常工作。`


查看`/usr/bin/cc --version`是否返回
```bash
目标：arm64-apple-darwin22.XX
线程模型：posix
安装目录：/Library/Developer/CommandLineTools/usr/bin
```


如果接近这个​​值，那么一切都应该没问题。如果不是，执行下命令应该可以解决这个问题：我假设安装目录在更新或突然卸载期间被更改了。

```bash
sudo xcode-select --switch /Library/Developer/CommandLineTools
```




# 如何在 Mac 上安装 Xcode 命令行工具
https://www.freecodecamp.org/news/install-xcode-command-line-tools/

开发人员需要安装 Xcode 命令行工具才能在 Mac 上开发软件。

苹果为程序员提供了一个名为Xcode的完整开发环境。如果你正在为macOS、iOS、tvOS和watchOS开发软件，则必须安装完整的Xcode应用程序。

它不是预装的，但你可以从[Apple 开发者网站](https://developer.apple.com/download/)或 Mac 上的 App Store 安装它。

## 什么是 Xcode 命令行工具？

如果您不是为 Apple 设备开发软件，则不需要完整的 Xcode 应用程序（它需要超过 40GB 的磁盘空间！）。

相反，您将安装 Xcode 命令行工具。它是面向软件开发人员的较小软件包，其中包含在命令行（即在终端应用程序中）上运行的工具。

自计算机诞生以来，程序员就一直在 Unix 操作系统上使用这些工具，它们几乎是所有软件开发的基础。

幸运的是，Xcode 命令行工具包仅占用 1.2GB 的磁盘空间。

您有三种选择可以在 Mac 上安装 Xcode 命令行工具：

- 安装完整的 Xcode 包
- 当命令触发时安装 Xcode 命令行工具
- 安装 Xcode 命令行工具作为 Homebrew 安装的一部分。

除非您正在为 Apple 设备开发软件，否则我不建议安装完整的 Xcode 软件包。下载时间太长，并且会占用不必要的磁盘空间。相反，请尝试两种更快的方法之一。

## 如何从命令提示符安装 Xcode 命令行工具

Apple 使安装 Xcode 命令行工具变得简单，因为某些命令会提示您开始安装。

以下是触发安装 Xcode 命令行工具的提示的命令示例：

- `clang`– 将源代码转换成可执行程序的编译器
- `gcc`– GNU 编译器
- `git`– 随时保存的版本控制系统

在终端中运行任何这些命令都会提示安装 Xcode 命令行工具。我曾在其他地方写过如何[在 MacOS 上打开终端](https://mac.install.guide/terminal/index.html)- 只需单击菜单栏中的 Spotlight 图标并输入“terminal”。

`xcode-select --install`您也可以在终端中输入命令来开始安装过程。您将看到一个面板，要求您安装 Xcode 命令行工具。

![安装-Xcode-CLT](https://mac.install.guide/assets/images/ruby/install-Xcode-CLT.png)

单击“安装”开始下载和安装过程。

![安装-Xcode-CLT-进度](https://mac.install.guide/assets/images/ruby/install-Xcode-CLT-progress.png)

在 2021 款 Mac M1 Mini 上，安装需要 8 分钟，互联网连接速度为 100Mbps。在较慢的互联网连接上，Mac Intel 的安装速度明显较慢。

![安装-Xcode-CLT-完成](https://mac.install.guide/assets/images/ruby/install-Xcode-CLT-done.png)

安装完成后您将看到一条确认消息。

验证您是否已成功安装 Xcode 命令行工具：

```bash
$ xcode-select -p
```

您应该看到以下内容：

```bash
/Library/Developer/CommandLineTools
```

## 如何使用 Homebrew 安装 Xcode 命令行工具

虽然使用命令提示符安装 Xcode 命令行工具非常简单，但我推荐一种更简单的方法：使用 Homebrew。

该选项最近才添加到 Homebrew，因此很多开发人员并不知道。

Homebrew 是流行的 Mac 软件包管理器。大多数开发人员需要的编程语言和实用程序在 macOS 上未安装，也不包含在 Xcode 命令行工具包中。Homebrew 可以为开发人员安装几乎所有开源工具。

由于您可能需要 Homebrew，因此您不妨让 Homebrew 为您安装 Xcode 命令行工具。

首先，检查 Homebrew 是否已安装。

```bash
$ brew
```

如果未安装 Homebrew，您将看到：

```bash
zsh: command not found: brew
```

Homebrew 提供了一个可以使用单个命令运行的安装脚本（检查它在[Homebrew 网站](https://brew.sh/)上是否没有更改）。

```bash
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Homebrew 安装脚本会要求您输入 Mac 用户密码。这是您用于登录 Mac 的密码。

```bash
Password:
```

您在输入时不会看到字符。输入完成后按 Enter。

![homebrew-输入密码](https://mac.install.guide/assets/images/ruby/homebrew-enter-password.png)

如果您尚未安装 Xcode 命令行工具，您将看到一条消息“将安装 Xcode 命令行工具”。 Homebrew 安装脚本提示时按回车键继续。

![安装自制](https://mac.install.guide/assets/images/ruby/install-homebrew.png)

您将看到诊断和进度消息。在 2021 Mac M1 Mini 上，Homebrew 安装需要 2 到 15 分钟，互联网连接速度为 100Mbps。在较慢的互联网连接上，Mac Intel 的速度会明显变慢。

![自制完成](https://mac.install.guide/assets/images/ruby/homebrew-complete.png)

在 Mac Intel 机器上，这就是您需要做的全部事情 - Homebrew 已准备就绪。在 Mac Intel 上，Homebrew 会自行安装到目录中`/usr/local/bin`，该目录已配置为使用 macOS 默认的 shell 进行访问`$PATH`。

在 Apple Silicon 机器上，还有一个步骤。Homebrew 文件安装到`/opt/homebrew`文件夹中。但该文件夹不是默认文件夹的一部分`$PATH`。按照 Homebrew 的建议创建一个`~/.zprofile`包含设置 Homebrew 的命令的文件。Homebrew 在安装过程结束时显示说明：

```bash
- Add Homebrew to your PATH in ~/.zprofile:
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

安装 Homebrew 后，请检查 Homebrew 是否正确安装。

```bash
$ brew doctor
```

你应该看到这个：

```bash
Your system is ready to brew.
```

如果 Homebrew 成功安装，则会在`/usr/local`（对于 macOS Intel）或`/opt/homebrew`（对于 Apple Silicon） 中有 Homebrew 文件。

现在您已安装 Xcode 命令行工具和 Homebrew。如果您想了解有关添加 Homebrew 软件包以设置开发环境的更多信息，请参阅[安装 Homebrew 软件包](https://mac.install.guide/homebrew/6.html)。

## 更多信息

我已经编写了一份深入的指南来[安装 Xcode 命令行工具，](https://mac.install.guide/commandlinetools/index.html)它超越了这些基础知识。

在本指南中，我解释了如何检查[Xcode 命令行工具是否已安装](https://mac.install.guide/commandlinetools/2.html)。我更详细地介绍了如何使用[Homebrew 安装 Xcode 命令行工具](https://mac.install.guide/commandlinetools/3.html)。最后，我解释了如何[卸载 Xcode 命令行工具](https://mac.install.guide/commandlinetools/6.html)、[重新安装 Xcode 命令行工具](https://mac.install.guide/commandlinetools/7.html)，并提供了一份您可以使用的[Xcode 命令行工具列表。](https://mac.install.guide/commandlinetools/8.html)

还有一份完整的[Homebrew for Mac 安装](https://mac.install.guide/homebrew/index.html)指南，讲解了如何[更新 Homebrew](https://mac.install.guide/homebrew/4.html)、[卸载 Homebrew](https://mac.install.guide/homebrew/5.html)以及如何跟上[Homebrew 的其他管理工作](https://mac.install.guide/homebrew/8.html)。

## 您的开发环境

MacOS 是最受欢迎的软件开发平台，因为该操作系统基于 Unix（软件开发的长期标准）。

安装 Xcode 命令行工具后，您将拥有添加几乎任何开源开发工具的坚实基础。

添加 Homebrew，您就拥有了一个包管理器，它可以安装版本管理器、编程语言以及您可能需要的几乎任何其他工具。

结合文本编辑器和终端应用程序，您将可以为在 freeCodeCamp 上找到的任何教程做好准备。

广告

广告

广告

广告

广告

广告

广告

---

![丹尼尔基霍](https://www.freecodecamp.org/news/content/images/size/w60/2021/05/daniel-kehoe-gravatar.jpeg)

[丹尼尔基霍](https://www.freecodecamp.org/news/author/danielkehoe/)

《Learn Ruby on Rails》一书的作者。mac.install.guide 的常驻撰稿人。

---

如果您读到这里，请向作者表示感谢，以表明您关心他们。说谢谢

免费学习编码。freeCodeCamp 的开源课程已经帮助超过 40,000 人找到了开发人员的工作。[开始使用](https://www.freecodecamp.org/learn/)

广告

freeCodeCamp 是一个由捐助者支持的免税 501(c)(3) 慈善组织（美国联邦税务识别号：82-0779546）

我们的使命：帮助人们免费学习编码。我们通过制作数千个视频、文章和交互式编码课程来实现这一目标 - 所有这些都免费向公众开放。

对 freeCodeCamp 的捐款将用于我们的教育计划，并帮助支付服务器、服务和员工的费用。

您可以[在这里进行免税捐赠](https://www.freecodecamp.org/donate/)。

## 热门指南

- [学习 CSS 变换](https://www.freecodecamp.org/news/complete-guide-to-css-transform-functions-and-properties/)
- [建立静态博客](https://www.freecodecamp.org/news/how-to-create-a-static-blog-with-lume/)
- [构建 AI 聊天机器人](https://www.freecodecamp.org/news/how-to-build-an-ai-chatbot-with-redis-python-and-gpt/)
- [什么是编程？](https://www.freecodecamp.org/news/what-is-programming-tutorial-for-beginners/)
- [Python 代码示例](https://www.freecodecamp.org/news/python-code-examples-sample-script-coding-tutorial-for-beginners/)
- [面向开发人员的开源](https://www.freecodecamp.org/news/a-practical-guide-to-start-opensource-contributions/)
- [JS 中的 HTTP 网络](https://www.freecodecamp.org/news/http-full-course/)
- [编写 React 单元测试](https://www.freecodecamp.org/news/how-to-write-unit-tests-in-react-redux/)
- [学习 JS 中的算法](https://www.freecodecamp.org/news/introduction-to-algorithms-with-javascript-examples/)
- [如何编写干净的代码](https://www.freecodecamp.org/news/how-to-write-clean-code/)
- [学习 PHP](https://www.freecodecamp.org/news/the-php-handbook/)
- [学习 Java](https://www.freecodecamp.org/news/the-java-handbook/)
- [学习 Swift](https://www.freecodecamp.org/news/the-swift-handbook/)
- [学习 Golang](https://www.freecodecamp.org/news/learn-golang-handbook/)
- [学习 Node.js](https://www.freecodecamp.org/news/get-started-with-nodejs/)
- [学习 CSS 网格](https://www.freecodecamp.org/news/complete-guide-to-css-grid/)
- [学习 Solidity](https://www.freecodecamp.org/news/learn-solidity-handbook/)
- [学习 Express.js](https://www.freecodecamp.org/news/the-express-handbook/)
- [学习 JS 模块](https://www.freecodecamp.org/news/javascript-es-modules-and-module-bundlers/)
- [学习 Apache Kafka](https://www.freecodecamp.org/news/apache-kafka-handbook/)
- [REST API 最佳实践](https://www.freecodecamp.org/news/rest-api-design-best-practices-build-a-rest-api/)
- [前端 JS 开发](https://www.freecodecamp.org/news/front-end-javascript-development-react-angular-vue-compared/)
- [学习构建 REST API](https://www.freecodecamp.org/news/build-consume-and-document-a-rest-api/)
- [中级 TS 和 React](https://www.freecodecamp.org/news/build-strongly-typed-polymorphic-components-with-react-and-typescript/)
- [初学者的命令行](https://www.freecodecamp.org/news/command-line-for-beginners/)
- [操作系统简介](https://www.freecodecamp.org/news/an-introduction-to-operating-systems/)
- [学习构建 GraphQL API](https://www.freecodecamp.org/news/building-consuming-and-documenting-a-graphql-api/)
- [OSS 安全最佳实践](https://www.freecodecamp.org/news/oss-security-best-practices/)
- [分布式系统模式](https://www.freecodecamp.org/news/design-patterns-for-distributed-systems/)
- [软件架构模式](https://www.freecodecamp.org/news/an-introduction-to-software-architecture-patterns/)

## 移动应用

- [![从 App Store 下载](https://cdn.freecodecamp.org/platform/universal/apple-store-badge.svg)](https://apps.apple.com/us/app/freecodecamp/id6446908151?itsct=apps_box_link&itscg=30200)
- [![从 Google Play 获取](https://cdn.freecodecamp.org/platform/universal/google-play-badge.svg)](https://play.google.com/store/apps/details?id=org.freecodecamp)

[关于](https://www.freecodecamp.org/news/about/)[校友网络](https://www.linkedin.com/school/free-code-camp/people/)[开源](https://github.com/freeCodeCamp/)[店铺](https://www.freecodecamp.org/news/shop/)[支持](https://www.freecodecamp.org/news/support/)[赞助商](https://www.freecodecamp.org/news/sponsors/)[学术诚信](https://www.freecodecamp.org/news/academic-honesty-policy/)[行为守则](https://www.freecodecamp.org/news/code-of-conduct/)[隐私政策](https://www.freecodecamp.org/news/privacy-policy/)[服务条款](https://www.freecodecamp.org/news/terms-of-service/)[版权政策](https://www.freecodecamp.org/news/copyright-policy/)
