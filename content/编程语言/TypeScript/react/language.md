---
title: 多语言
---
## 如何理解多语言国际化？

![44444444444.png](https://segmentfault.com/img/remote/1460000040477250 "44444444444.png")

图片中下拉部分已经清楚的说明了多语言国际化是什么了。

个人理解：它就是我们在网站上可以通过切换语言类型来实现同一功能的不同语言展示效果。

## react-i18next介绍

react-i18next 是一个强大的React / React Native国际化框架，它基于i18next的React插件。

## 安装依赖

```bash
npm install react-i18next i18next --save
```
 
 
 既然是要学习使用react-i18next，为什么还需要安装i18next包？
 
 i18next才是提供所有翻译功能的核心,
 
 react-i18next是为了与 react一起使用提供了一些额外的功能。

## 项目文件结构

![11111111.png](https://segmentfault.com/img/remote/1460000040477251 "11111111.png")

## 项目配置

### 1.本地json数据初始化(新建简体、繁体、英文三个json文件)

 大家看下zh-cn.json文件的数据结构，繁体和英文结构是一样的，只是内容不同。  
```bash
{
  "home":{
    "title":"首页",
    "content":"我是首页",
  },
  "about":{
    "title":"关于我们",
    "content":"我是关于我们"
  }
}
```

### 2.创建配置react-i18next的react-i18next-config.js文件

```tsx
import i18n from "i18next";
import { initReactI18next } from "react-i18next";
//i18next-browser-languagedetector插件 
//这是一个 i18next 语言检测插件，用于检测浏览器中的用户语言，
//详情请访问：https://github.com/i18next/i18next-browser-languageDetector
import LanguageDetector from 'i18next-browser-languagedetector';
//引入需要实现国际化的简体、繁体、英文三种数据的json文件
import cn from './locales/zh-cn.json'
import hk from './locales/zh-HK.json'
import en from './locales/en-us.json'
const resources = {
  cn: {
    translation: cn
  },
  hk: {
    translation: hk
  },
  en: {
    translation: en
  },
};
i18n.use(LanguageDetector) //嗅探当前浏览器语言 zh-CN
.use(initReactI18next) // 将 i18n 向下传递给 react-i18next
  .init({ //初始化
    resources, //本地多语言数据
    fallbackLng: "cn", //默认当前环境的语言
    detection: {
      caches: ['localStorage', 'sessionStorage', 'cookie'],
    }
  })

export default i18n
```


### 3.然后将react-i18next-config.js 引入到App.js组件

```bash
import i18n from './react-i18next-config'
```


这样的话react-i18next和i18next 就可以作用到App组件以及它的所有子组件上了。

### 4.默认语言和默认数据

 项目初始化后，用户浏览器的默认语言为zh-CN
 根据react-i18next-config.js文件中关于resources的配置：
```json
"zh-CN": {
    translation: './locales/zh-cn.json'
  },
  "zh-HK": {
    translation: './locales/zh-HK.json'
  },
  "en-US": {
    translation: './locales/en-us.json'
  },
```


 根据上述配置我们可以判断出默认请求的数据为`./locales/zh-cn.json`
 
### 5.开发选择切换语言组件

<div>
     <label>语言切换</label>
     <select value={language} onChange={(e)=>changeLanguage(e)}>
        <option value="zh-CN">简</option>
        <option value="zh-HK">繁</option>
        <option value="en-US">英</option>
     </select>
 </div>  

当我们进行语言切换时，将调用组件中的changeLanguage方法。

这个方法的调用会做下面几件事：

1、对当前选择的语言类型进行更新操作 

  const [language,setLanguage] = useState('zh-CN')
  
  setLanguage(当前选中的语言类型)，更新页面中选中的语言类型对应的文字
  
2.执行由react-i18next-config.js导出的i18n上面的changeLanguage
  (当前选中的语言类型)方法。
  
  执行了i18n.changeLanguage后：
  
  a.更新数据源
  
```json
"zh-CN": {
        translation: './locales/zh-cn.json'
      },
"zh-HK": {
        translation: './locales/zh-HK.json'
      },
"en-US": {
        translation: './locales/en-us.json'
      },
```
    
根据选中的语言类型去获取对应的json数据
    
  b.更新语言类型
```bash
localStorage 中 i18nextLng 的值
```


### 6. i18next-browser-languagedetector插件引入

   安装i18next-browser-languagedetector插件后，可以探测出当前浏览器的用户语言为zh-CN。
   
   此时会在localStorage中设置i18nextLng为zh-CN。

   那么这里为什么会在localStorage中存储呢？键值为什么是i18nextLng呢?

![22222222.png](https://segmentfault.com/img/remote/1460000040477252 "22222222.png")

上述代码就是i18next-browser-languagedetector插件的源码，我们可以清楚的看到是插件默认将浏览器的用户语言（zh-CN）存储到localStorage中去的，并设置键名为 i18nextLng`

#### 自定义配置

如果我们需要自定义的话 可以通过官方文档中的Detector Options进行配置,例如：

初始化项目后，我们不仅希望localStorage中存储了i18nextLng，

同时希望在sessionStorage、cookie中也存储i18nextLng。

可以进行如下配置：
```json
detection: {
    caches: ['localStorage', 'sessionStorage', 'cookie'],
}
```


将上述配置放到i18n初始化init的配置对象中去就可以了。

#### localStorage存储i18nextLng的作用

众所周知，localStorage是不会随着页面刷新、标签关闭造成数据丢失的，

也就是说当我们刷新页面时，我们仍然可以拿到上一次用户选择的语言类型，

并且按照这个语言类型去加载对应的json文件数据。

更多配置，请访问 i18next-browser-languageDetector官方文档：  

[https://github.com/i18next/i1...](https://link.segmentfault.com/?enc=iyKUJLDYfTgF2uGqS4Cmag%3D%3D.v%2FwIAFJ6OOZs%2Bl7NkIJ70nDBOF6DxwS4Tk6FpPC00TvrUq7LYpKIbmK78zbTKQYCwVYy00nr02im4toAf5iQuA%3D%3D)

## 如何使用react-i18next进行渲染，进而实现页面多语言切换呢？

1. `useTranslation (hook)`

**注意：useTranslation()必须是函数组件中使用否则会报，hooks错误。**
```tsx
 const { t } = useTranslation()
 <NavLink to="/home">{t('home.title')}</NavLink>

```

2. Translation (render prop)

```tsx
import {Translation} from 'react-i18next'

<Translation>
  {(t) => <h3>{t("about.content")}</h3>}
</Translation>
```


3. withTranslation (HOC) 高阶组件方式

react-i18next 内部封装了一个高阶组件withTranslation,  
我们需要利用这个高阶组件把我们自己的组件包装一次
```tsx
import { withTranslation } from 'react-i18next'; 
//类组件
class Home extends Component {
  render() {
    const {t} = this.props

    return (
      <div>
          <h3>{t("home.content")}</h3>
      </div>
    )
  }
}
//函数组件
const Home = ({t})=>{
  return (
    <div>
        <h3>{t("home.content")}</h3>
    </div>
  )
}
//组件导出：
export default withTranslation()(Home)
```


## 项目实现

![11111111.png](https://segmentfault.com/img/remote/1460000040477253 "11111111.png")

![22222222.png](https://segmentfault.com/img/remote/1460000040477254 "22222222.png")

https://github.com/dabaoRain/react-inter.git

## 参考文档

[https://react.i18next.com/](https://link.segmentfault.com/?enc=3nWzmWxxEtyvMhQC2OdPpA%3D%3D.s92vmxYDJHy6qLLjvNt1cG15m2jWt1jhUHp0csJHkwI%3D)

[https://www.i18next.com/](https://link.segmentfault.com/?enc=ol5yavCytdDJAgcTvA9FIg%3D%3D.RoAVldZRryuKxPZdmGfk7J5MBHr7MqPhhzwZA34JP60%3D)

[https://github.com/i18next/re...](https://link.segmentfault.com/?enc=55kUM4zAcmBzJqKcPTjqiA%3D%3D.h8I7flo0bhoGZ%2BFqNJjajuli0bFUEmcxCt4XLi7mH5Z0XSGOB%2BjmOhTUZqIv3UR0)

[https://github.com/i18next/i1...](https://link.segmentfault.com/?enc=4jsh6Khqz8jqi5R%2FgZBEGQ%3D%3D.8eIpqEdlmIs5LsTlhcQ6A8BtrZTzkVMO6Qi9%2FK4HmfhT%2FGpRdknfidWQY40aBe%2BL)

**作者对于react-i18next的理解属于基础入门级别，对于文章中的理解或者使用错误，望各位大神不吝指出，关于react-i18next有那些需要补充的也可以进行评论，作者不胜感激。排版码字不易，觉得对您有所帮助，就帮忙点个赞吧！**









# 方法二
 1.安装
 ```bash
npm install react-i18next i18next
 # or
yarn add react-i18next i18next
```

2.新建目录
在src下新建lang文件夹，以存放语言包和i18n的配置文件；

3.创建i18n配置文件
在lang文件下新建jsx、js或tsx文件（例如：命名为`config.js`）
```tsx
import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
//中文语言包
import zh from './zh.json';
//英文语言包
import en from './en.json';
 
const resources = {
  en: {
    translation: en
  },
  zh: {
    translation: zh
  }
};
 
i18n.use(initReactI18next).init({
  resources,
  lng: 'zh',//设置默认语言（可用三元表达式进行动态切换）
  interpolation: {
    escapeValue: false
  }
});
 
export default i18n;
```

4.语言包格式

`zh.json`
```tsx
{
  "login": {
    "register": "注册",
    "signin": "登录",
    "home": "首页"
  },
  "footer": {
    "text": "版权所有 @ React"
  },
  "home": {
    "title": "首页"
  },
}
```



 
5.开始使用

首先在index.jsx中引入国际化配置文件
```tsx
import './i18n/config';
```

页面中使用
```tsx
import React from 'react';
import { useTranslation } from 'react-i18next';
function Home() {
  const { t, i18n } = useTranslation();
  return (
    <div>
      <p>{t('login.home')}</p>
    </div>
  );
}
export default Home;
```

 
切换语言

//一般是在点击事件、change事件函数中进行改变。根据自己的语言包进行切换、切换之后可以本地存储保存
```tsx
i18n.changeLanguage('en')//切换英文
i18n.changeLanguage('zh')//切换中文
```



————————————————

                            版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。
                        
原文链接：https://blog.csdn.net/wsdshdhdhd/article/details/130656553




# 【前端出海】多语言篇（一）：React项目中支持多语言

[远方的戈多](https://juejin.cn/user/2576910985723965/posts)

2024-02-121,475阅读4分钟

![书籍、桌子、咖啡.jpg](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c2bc0a454726423f95a98d535288299a~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp#?w=1280&h=853&s=298904&e=jpg&b=95806b)

> 众所周知，国内互联网行业已经进入存量市场，竞争激烈、利润微薄。一些公司为了摆脱困境，将目标转向了海外，海外市场相比国内，竞争小、利润高，潜力大。未来数年，出海会成为越来越多公司的重要战略。

如果你所在的公司要走出国门，相应面向客户的web和H5产品都要国际化。国际化最重要的就是多语言的支持。我将以React框架为例，介绍在前端项目中如何搭建多语言。

# 基础项目搭建

首先创建一个React模板项目

node

代码解读

复制代码

`npx create-react-app oversea-react-app --template typescript`

然后下载i18n相应的依赖包

node

代码解读

复制代码

`npm i i18next react-i18next`

`i18next` 和 `react-i18next` 不用过多介绍，就是i18n提供翻译能力的基础依赖包。

然后在项目src目录下，新建i18n目录，新建如下几个文件

- src
    - i18n
        - index.ts
        - zh-cn.json
        - en-us.json

其中index.tsx文件代码如下：

ts

代码解读

复制代码

`import i18n from 'i18next'; import { initReactI18next } from 'react-i18next'; import enUs from './en-us.json'; import zhCn from './zh-cn.json'; export const SUPPORTED_LANG = [     'zh-cn',     'en-us', ]; // 配置参数的文档: https://www.i18next.com/overview/configuration-options const option = {     fallbackLng: 'zh', // 默认语言     debug: process.env.NODE_ENV !== 'production',     resources: { // 支持的语言         en: {             translation: enUs,         },         zh: {             translation: zhCn,         },     },     interpolation: {         escapeValue: false, // not needed for react!!     }, }; // 注入react-i18next实例并初始化 i18n.use(initReactI18next)     .init(option); export default i18n;`

上面第三行和第四行代码引入了两个json文件，分别是英文和中文的翻译资源

json

代码解读

复制代码

`{     "multiLanguage": "多语言" }`

json

代码解读

复制代码

`{     "multiLanguage": "multi-language" }`

不要忘记在项目主文件 src/index.ts 中导入i18n

ts

代码解读

复制代码

`import './i18n/index'`

最后在项目业务组件中使用i18n翻译功能

ts

代码解读

复制代码

`import React from 'react'; import { useTranslation } from 'react-i18next'; const Language: React.FC = () => {     // useTranslation 返回的对象包含一个 t 方法，这个方法可以翻译文本     const { t } = useTranslation();     return <>         <div>{t('multiLanguage')}</div>     </> } export default Language;`

在浏览器中可以看到，文本已经被成功翻译了

![显示效果1.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/fbc1c9d162e8487ea8c13adb1af15048~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp#?w=266&h=170&s=1870&e=png&b=ffffff)

# 检测浏览器默认语言

项目中已经成功引入了多语言，但在实际应用场景中，是需要根据浏览器默认语言作为页面的展示语言的，这就要使用到能检测浏览器语言的插件`i18next-browser-languagedetector`

下载依赖并在 i8n/index.ts文件中引入

ts

代码解读

复制代码

`import LanguageDetector from 'i18next-browser-languagedetector'; ... // 注入react-i18next实例并初始化 i18n.use(LanguageDetector) // 检测用户当前使用的语言     .use(initReactI18next)     .init(option);`

重启项目，查看浏览器的Application控制面板，可以看到浏览器默认语言在Local Storage中做了缓存

![local storage.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/87ad7325fab8418d9b988b6ffcca9d71~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp#?w=1054&h=559&s=47148&e=png&b=fefefe) 再将浏览器默认语言设置为英语

![default language.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/386ee1f7fc4a4104b4879b8c9b974d84~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp#?w=1920&h=953&s=100867&e=png&b=222326) 清空Local Storage的缓存并刷新浏览器，页面展示了英语，并且Local Storage中缓存也设置为英语

![显示效果2.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/aa4fa70ea6d840098b76c281e70e1a9b~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp#?w=1920&h=953&s=92925&e=png&b=ffffff)

# 语言切换

前端实现国际化的过程中，还要提供能切换页面展示语言的功能

我们将业务组件做如下改动，核心改动点就是在切换语言时修改缓存数据`i18nextLng`

ts

代码解读

复制代码

`import React, {useState} from 'react'; import { useTranslation } from 'react-i18next'; const Language: React.FC = () => {     const { t } = useTranslation();     const lang = window.localStorage.getItem('i18nextLng') || 'zh';     const [language, setLanguage] = useState(lang);     const languageChange = (e: React.ChangeEvent<HTMLSelectElement>) => {         setLanguage(e.target.value);         // 切换语言时修改缓存数据         window.localStorage.setItem('i18nextLng', e.target.value);         // 重新加载页面         window.location.reload();     }     return <>         <select value={language} onChange={languageChange}>             <option value="zh">简体中文</option>             <option value="en">English</option>         </select>         <br />         <div>{t('multiLanguage')}</div>     </> } export default Language;`

当然i8n官方更推荐使用changeLanguage方法，调用`i18n.changeLanguage`,会自动修改缓存数据`i18nextLng`

ts

代码解读

复制代码

`import React, {useState} from 'react'; import { useTranslation } from 'react-i18next'; const Language: React.FC = () => {     const { t, i18n } = useTranslation();     ...     const languageChange = (e: React.ChangeEvent<HTMLSelectElement>) => {         ...         // 切换展示语言，会自动修改缓存数据i18nextLng         i18n.changeLanguage(e.target.value);         ...     }     ... }`

看看代码展示效果，当语言切换成简体中文，页面展示了中文，同时缓存数据也修改为`zh`

![展示效果3.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3be66442b50640e288f5eefdcdd896a6~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp#?w=1920&h=1048&s=122098&e=png&b=fefdfd)

# 插值表达式

在实际应用场景中，可能会遇到一段话中夹杂了变量，这时候i18n的插值表达式就派上用场了。

插值表达式的语法是使用两个大花括号包裹变量

json

代码解读

复制代码

`{     "desc": "作者是{{author}}，当前时间是{{currentTime}}" }`

json

代码解读

复制代码

`{     "desc": "The author is {{author}}, current time is {{currentTime}}" }`

在视图层，t函数支持传入第二个参数，是一个对象，对象的属性名对应插值表达式中花括号包裹的变量，属性值作为插值最终被t方法替换到翻译文本中。

js

代码解读

复制代码

`<div>     {t('desc', {         author: '远方的戈多',         language,         currentTime: new Date().toLocaleString()     })} </div>`

最终显示效果

![显示效果4.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4fdc44f2ef7045a5ae27282374898797~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp#?w=866&h=401&s=19760&e=png&b=ffffff)

# 结语

本文介绍了React项目中支持多语言的基础搭建，同时介绍了项目默认语言设置为浏览器的首选语言，切换语言以及插值表达式这些常用功能。