---
undefined: ""
File: 在前端项目中开始使用 TailwindCSS
---
# 方法一

https://tailwindcss.com/docs/installation/using-postcss

```bash
# yarn
yran add -D tailwindcss postcss autoprefixer
yran tailwindcss init

# npm 
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init
```


`postcss.config.js`
```js
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  }
}
```

`tailwind.config.js`
```js
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{html,js}"],
  theme: {
    extend: {},
  },
  plugins: [],
}
```

`main.css`
```css
@tailwind base;
@tailwind components;
@tailwind utilities;
```

# 方法二

原文：
https://www.levenx.com/guide/how-to-using-tailwindcss/content/how-to-start-using-tailwindcss-in-front-end-projects

## 背景

TailwindCSS 近年来在前端圈非常流行，它摆脱了原有的CSS限制，以灵活实用为卖点，用户通过各种class组合即可构建出漂亮的用户界面。对于初学者而言，可能需要一些上手成本，一旦掌握实用技巧后，TailwindCSS会是我们开发工作中的出鞘利刃。

笔者参与开发的项目几乎全部支持TailwindCSS来完成需求开发，期间碰到过 TailwindCSS 相关的各种问题。于是想着把 TailwindCSS 的使用技巧和踩坑经验记录下来，分享给有需要的同学。

本文详细介绍常见前端构建工具脚手架&技术栈开启使用 TailwindCSS的 步骤。

## 目标

- 初学者快速入门 TailwindCSS；
- TailwindCSS 使用技巧和提效工具；
- 高效的问题定位和排查；
- TailwindCSS 工作原理；

## 使用步骤

> 💡 对于现代化前端开发，webpack、vite、rollup 这些前端构建工具是必须的；使用PostCSS插件是构建工具和 TailwindCSS 结合的最佳选择。

### 1. 安装 TailwindCSS & PostCSS

```bash
npm install -D tailwindcss tailwindcss postcss autoprefixer
```


### 2. 初始化 TailwindCSS 配置文件

javascript

`npx tailwindcss init`

### 3. 配置 TailwindCSS 扫描范围

> 📌 由于 TailwindCSS 的工作原理是扫描指定范围内所有的文件，获取到文件中 CSS class 类，基于TailwindCSS 内置预设的规则以及用户自定义的规则，最终生成一份 CSS 文件。
> 
> **那么重点来了!!!** 对于不同前端技术栈的项目，比如 React、Vue、Svelte、Angular等等，我们只需要**配置对应的文件扫描范围**即可。其他的配置步骤都是相同的。

- React：`"./src/**/*.{js,jsx,ts,tsx}"`
- Vue: `"./src/**/*.{vue,js,ts,jsx,tsx}”`
- Svelte: `"./src/**/*.{svelte,js,ts,jsx,tsx}"`

javascript

`/** @type {import('tailwindcss').Config} */ module.exports = { 	// 加载对应**构建工具**和**技术栈**的文件即可   **content: ["./src/**/*.{html,js}"],**   theme: {     extend: {},   },   plugins: [], }`

如果你在html模板中也使用了 TailwindCSS 的样式类，那么 `content` 配置数组也需要添加 `html` 文件路径。

### 4. 配置 PostCSS

如果项目中之前已经使用了 PostCSS 插件，我们只需要在 `postcss.config.js`中添加 tailwindcss相关的配置；如果项目之前没有使用 PostCSS 插件，那我们需要在项目根路径创建文件 `postcss.config.js`，并添加如下配置；

javascript

`// postcss.config.js module.exports = {   plugins: {     tailwindcss: {},     autoprefixer: {},   } }`

### 5. 构建工具集成 PostCSS插件（让PostCSS插件开始工作）

> 📌 Vite、Create react app 内部集成了postcss插件，可以忽略这一步

- Rspack

javascript

`/**  * @type {import('@rspack/cli').Configuration}  */ module.exports = {   module: {     rules: [       {         test: /\.css$/i,         use: [           {             loader: "postcss-loader",           },         ],         type: "css",       },     ],   } };`

- webpack

javascript

`module.exports = {   module: {     rules: [       {         test: /\.css$/i,         use: [           "style-loader",           "css-loader",           {             loader: "postcss-loader"           },         ],       },     ],   }, };`

### 6. 项目全局CSS文件中添加 TailwinCSS 依赖内容

javascript

`// index.css @tailwind base; @tailwind components; @tailwind utilities;`

至此，我们完成了使用 TailwindCSS 的所有配置，接下来是如何使用 TailwindCSS 美化页面。

在此之前我们需要**启动**或者**重启**本地开发服务器

javascript

`npm run dev`

## 使用效果

> 使用TailwindCSS 画一个正方形

javascript

`<div className='border border-lime-600 w-32 h-32'></div>`

![](https://cdn.portal.levenx.com/levenx-world/1ba1e0d189cb4a7ebcc2b3862b2d3f01.png)

## 总结

TailwindCSS 的开始步骤看着比较多，但是真正按照步骤动手启动可能只需要几分钟，更多的内容是我想跟大家分享具体的作用，也方便大家能够对 TailwindCSS 有个较为清晰的理解。

更多的 TailwindCSS 相关的内容分享，前往 [TailwindCSS 使用指南](https://www.levenx.com/guide/how-to-using-tailwindcss?enter_from=article_recommend)
