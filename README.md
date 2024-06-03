**简体中文** | [English](docs/README_en.md) | [更改日志](docs/CHANGELOG.md)

# 一、Aptos 开发教程

[IP 访问](http://chyraw.com) | [域名访问](http://43.138.107.218/)

# 二、文档站使用说明

## 1. 安装

前置条件

Quartz 需要 [Node](https://nodejs.org/) 版本 **v18.14** 和 `npm` 版本 v9.3.1 以上才能正常工作。请确保您的设备上已经安装了再继续。推荐使用 `nvm`

开始安装

```bash
git clone https://github.com/caoyang2002/aptos_tutorial_quartz.git
```

```bash
cd aptos_tutorial_quartz
```

安装 npm包

```bash
num i
```

运行本程序

```bash
./run.sh
```

停止本程序

```bash
./stop.sh
```

## 2. 编辑内容

文档格式：Markdown（`.md` 后缀）

属性设置: （写在文章顶部）

```yaml
---
title: 文章标题
---
```

> title 会作为文档标题显示在文章的顶部
>
> 但是文件的访问仍然是文件名
>
> > 例如：`http://chyraw.com/算法/两数之和`
> >
> > - 两数之和 是文件名
> > - title：找出两个数字的和
> > - 文件路径：`/算法/两数之和`
> > - `index.md` 中嵌入 `[[两数之和]]` （`index.md` 是访问文件夹时，默认被访问的）

WIKI 格式：

```wiki
[[文件名]]
```

> 一定是文件名，不是文件中的 title 字段

```yaml
title: test
description: 说明
aliases: 别称
tags:
  - 标签一
  - 标签二
draft: false
date: 2024-05-01
```

```py title="one.py"
test
```

行高亮

````
```js {1-3,5}
let a = 10; < 高亮
let b = 10; < 高亮
let c = 10; < 高亮
let d = 10;
let e = 10; < 高亮
let f = 10;
let g = 10;
```
````

```js {1-3,5}
let a = 10; < 高亮
let b = 10; < 高亮
let c = 10; < 高亮
let d = 10;
let e = 10; < 高亮
let f = 10;
let g = 10;
```

关键词高亮

````
```js /useState/
const [age, setAge] = useState(50);  useState 高亮
const [name, setName] = useState('Taylor');
```
````

```js /useState/
const [age, setAge] = useState(50);  useState 高亮
const [name, setName] = useState('Taylor');
```

起始位置

````
```rust showLineNumbers{3}
let a = 10; < 起始位置为第三行
let b = 10;
let c = 10;
let d = 10;
let e = 10;
let f = 10;
```
````

```rust showLineNumbers{3}
let a = 10; < 起始位置为第三行
let b = 10;
let c = 10;
let d = 10;
let e = 10;
let f = 10;
```

````
```js /useState/
const [age, setAge] = useState(50);
const [name, setName] = useState('Taylor');
```
````

---

---

> [Quartz v4](https://github.com/jackyzha0/quartz) 指南
>
> English get started: https://quartz.jzhao.xyz/
>
> “[One] who works with the door open gets all kinds of interruptions, but [they] also occasionally gets clues as to what the world is and what might be important.” — Richard Hamming
>
> 中文使用手册：https://quartz.songxingguo.com/
>
> “工作时门开着的人会遭遇各种打扰，但他们偶尔也会得到一些关于世界和可能重要的事情的线索。” — 理查德·哈明

# 参考

[hello-algo](https://www.hello-algo.com/chapter_hashing/hash_map/#612)

# vercel

```bash
vercel --prod
```
