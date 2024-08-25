npm、cnpm、yarn 搭建react + js 或者 react + ts（tsx）创建方式

# 1. 安装：node
(已安装忽略，命令行：`node -v` 检查是否成功）

官网 https://nodejs.org/en/ 一直下一步安装结束（境外资源下载稍慢）
或到腾讯管家自带的 【软件管理】 搜索node下载安装（很快，其他软件中心自测）

.

# 2.安装：create-react-app
npm方式： 

```bash
npm install -g create-react-app
```

cnpm方式： 

```bash
cnpm install -g create-react-app
```

yarn方式：

```bash
yarn global add create-react-app
```

yarn安装：npm install -g yarn 查看版本：yarn -v
cnpm安装：npm install -g cnpm -registry=https://registry.npm.taobao.org 查看版本：cnpm -v （备注：不要用npm install cnpm -g安装）
.

# 3.创建（注:项目名称不能有大写）

react + js:

备注：`projectname` 项目名字，**勿大写**

```bash
create-react-app projectname
```

yarn 创建：

```bash
yarn create react-app projectname
```

react+ts（tsx）项目创建：【根据需要创建】

```bash
create-react-app projectname --template typescript
```

或者：
```bash
yarn create react-app projectname --template typescript
```

或者：

```bash
yarn create react-app projectname --template=typescript
```


.

# 4.打开项目

cd projectname 打开项目

.

# 5.运行项目
npm方式 运行项目：npm start

cnpm方式：npm 替换成 cnpm
yarn方式：npm 替换成 yarn

npm install 安装依赖（若需要可执行安装依赖）

到此，react创建已完结。

拓展：各UI组件安装
```bash
antd（ant design）安装：https://ant.design/index-cn
npm： npm install antd --save
cnpm： cnpm install antd --save
yarn： yarn add antd
```


```bash
antd-mobile（ant design mobile）V2 安装：https://antd-mobile-v2.surge.sh/index-cn
npm： npm install antd-mobile --save
cnpm： cnpm install antd-mobile --save
yarn： yarn add antd-mobile
```


其他ui框架引用是另外导入命令，每个官网都有的介绍

npm安装就是：
```bash
npm install XXX --save
```

yarn安装更简单：
```bash
yarn add XXX
```
