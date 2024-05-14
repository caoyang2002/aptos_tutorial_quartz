**简体中文** | [English](docs/README_en.md) | [更改日志](docs/CHANGELOG.md)

# 一、Aptos 开发教程

[IP 访问](http://chyraw.com)  | [域名访问](http://43.138.107.218/)

















# 二、文档站使用说明

## 1. 安装

前置条件

Quartz 需要 [Node](https://nodejs.org/) 版本 **v18.14** 和 `npm` 版本 v9.3.1 以上才能正常工作。请确保您的设备上已经安装了再继续。推荐使用 `nvm`

开始安装

```bash
git clone https://github.com/caoyang2002/aptos_tutorial_quartz.git
```

```bash
cd /home/ubuntu/aptos_tutorial_quartz
```

```bash
num i
```

```bash
npx quartz build --serve  # 运行
```



## 2. 编辑内容

文档格式：Markdown（`.md`  后缀）

属性设置:  （写在文章顶部）

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
> > - `index.md` 中嵌入 `[[两数之和]]`  （`index.md` 是访问文件夹时，默认被访问的）



WIKI 格式：

```wiki
[[文件名]]
```

> 一定是文件名，不是文件中的 title 字段











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

