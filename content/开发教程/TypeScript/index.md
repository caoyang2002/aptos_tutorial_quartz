---
title: TypeScript 教程
---
```yaml
original: https://ts.xcatliu.com/
other: https://github.com/mqyqingfeng/learn-typescript
ruanyifeng: https://wangdoc.com/typescript/basic
cnblogs: https://www.cnblogs.com/bleaka/p/16118452.html
coding-time: https://www.coding-time.cn/ts/preamble.html
```


# [TypeScript学习文档-高级篇（已完结）](https://www.cnblogs.com/bleaka/p/16118452.html "发布于 2022-04-08 17:20")

目录

- [TypeScript学习高级篇第一章：变量声明](https://www.cnblogs.com/bleaka/p/16118452.html#typescript%E5%AD%A6%E4%B9%A0%E9%AB%98%E7%BA%A7%E7%AF%87%E7%AC%AC%E4%B8%80%E7%AB%A0%E5%8F%98%E9%87%8F%E5%A3%B0%E6%98%8E)
    - [1.1 var变量声明](https://www.cnblogs.com/bleaka/p/16118452.html#11-var%E5%8F%98%E9%87%8F%E5%A3%B0%E6%98%8E)
    - [1.2 作用域法则](https://www.cnblogs.com/bleaka/p/16118452.html#12-%E4%BD%9C%E7%94%A8%E5%9F%9F%E6%B3%95%E5%88%99)
    - [1.3 变量捕获的怪癖](https://www.cnblogs.com/bleaka/p/16118452.html#13-%E5%8F%98%E9%87%8F%E6%8D%95%E8%8E%B7%E7%9A%84%E6%80%AA%E7%99%96)
    - [1.4 let变量声明](https://www.cnblogs.com/bleaka/p/16118452.html#14-let%E5%8F%98%E9%87%8F%E5%A3%B0%E6%98%8E)
    - [1.5 块级作用域](https://www.cnblogs.com/bleaka/p/16118452.html#15-%E5%9D%97%E7%BA%A7%E4%BD%9C%E7%94%A8%E5%9F%9F)
    - [1.6 重复声明和投影](https://www.cnblogs.com/bleaka/p/16118452.html#16-%E9%87%8D%E5%A4%8D%E5%A3%B0%E6%98%8E%E5%92%8C%E6%8A%95%E5%BD%B1)
    - [1.7 块级作用域变量捕获](https://www.cnblogs.com/bleaka/p/16118452.html#17-%E5%9D%97%E7%BA%A7%E4%BD%9C%E7%94%A8%E5%9F%9F%E5%8F%98%E9%87%8F%E6%8D%95%E8%8E%B7)
    - [1.8 `const`声明](https://www.cnblogs.com/bleaka/p/16118452.html#18-const%E5%A3%B0%E6%98%8E)
    - [1.9 `let`与`const`比较](https://www.cnblogs.com/bleaka/p/16118452.html#19-let%E4%B8%8Econst%E6%AF%94%E8%BE%83)
    - [1.10 解构](https://www.cnblogs.com/bleaka/p/16118452.html#110-%E8%A7%A3%E6%9E%84)
    - [1.11 数组析构](https://www.cnblogs.com/bleaka/p/16118452.html#111-%E6%95%B0%E7%BB%84%E6%9E%90%E6%9E%84)
    - [1.12 元组解构](https://www.cnblogs.com/bleaka/p/16118452.html#112-%E5%85%83%E7%BB%84%E8%A7%A3%E6%9E%84)
    - [1.13 对象解构](https://www.cnblogs.com/bleaka/p/16118452.html#113-%E5%AF%B9%E8%B1%A1%E8%A7%A3%E6%9E%84)
    - [1.14 Function声明](https://www.cnblogs.com/bleaka/p/16118452.html#114-function%E5%A3%B0%E6%98%8E)
    - [1.15 展开](https://www.cnblogs.com/bleaka/p/16118452.html#115-%E5%B1%95%E5%BC%80)
- [TypeScript学习高级篇第二章：类型推断](https://www.cnblogs.com/bleaka/p/16118452.html#typescript%E5%AD%A6%E4%B9%A0%E9%AB%98%E7%BA%A7%E7%AF%87%E7%AC%AC%E4%BA%8C%E7%AB%A0%E7%B1%BB%E5%9E%8B%E6%8E%A8%E6%96%AD)
    - [2.1 最佳公共类型](https://www.cnblogs.com/bleaka/p/16118452.html#21-%E6%9C%80%E4%BD%B3%E5%85%AC%E5%85%B1%E7%B1%BB%E5%9E%8B)
    - [2.2 上下文类型](https://www.cnblogs.com/bleaka/p/16118452.html#22-%E4%B8%8A%E4%B8%8B%E6%96%87%E7%B1%BB%E5%9E%8B)
- [TypeScript学习高级篇第三章：枚举](https://www.cnblogs.com/bleaka/p/16118452.html#typescript%E5%AD%A6%E4%B9%A0%E9%AB%98%E7%BA%A7%E7%AF%87%E7%AC%AC%E4%B8%89%E7%AB%A0%E6%9E%9A%E4%B8%BE)
    - [3.1 数值型枚举](https://www.cnblogs.com/bleaka/p/16118452.html#31-%E6%95%B0%E5%80%BC%E5%9E%8B%E6%9E%9A%E4%B8%BE)
    - [3.2 字符串枚举](https://www.cnblogs.com/bleaka/p/16118452.html#32-%E5%AD%97%E7%AC%A6%E4%B8%B2%E6%9E%9A%E4%B8%BE)
    - [3.3 异构枚举](https://www.cnblogs.com/bleaka/p/16118452.html#33-%E5%BC%82%E6%9E%84%E6%9E%9A%E4%B8%BE)
    - [3.4 计算型和常量型成员](https://www.cnblogs.com/bleaka/p/16118452.html#34-%E8%AE%A1%E7%AE%97%E5%9E%8B%E5%92%8C%E5%B8%B8%E9%87%8F%E5%9E%8B%E6%88%90%E5%91%98)
    - [3.5 联合枚举和枚举成员类型](https://www.cnblogs.com/bleaka/p/16118452.html#35-%E8%81%94%E5%90%88%E6%9E%9A%E4%B8%BE%E5%92%8C%E6%9E%9A%E4%B8%BE%E6%88%90%E5%91%98%E7%B1%BB%E5%9E%8B)
    - [3.6 运行时的枚举](https://www.cnblogs.com/bleaka/p/16118452.html#36-%E8%BF%90%E8%A1%8C%E6%97%B6%E7%9A%84%E6%9E%9A%E4%B8%BE)
    - [3.7 编译时的枚举](https://www.cnblogs.com/bleaka/p/16118452.html#37-%E7%BC%96%E8%AF%91%E6%97%B6%E7%9A%84%E6%9E%9A%E4%B8%BE)
    - [3.8 环境枚举](https://www.cnblogs.com/bleaka/p/16118452.html#38-%E7%8E%AF%E5%A2%83%E6%9E%9A%E4%B8%BE)
    - [3.9 对象与枚举](https://www.cnblogs.com/bleaka/p/16118452.html#39-%E5%AF%B9%E8%B1%A1%E4%B8%8E%E6%9E%9A%E4%B8%BE)
- [TypeScript学习高级篇第四章：公共类型](https://www.cnblogs.com/bleaka/p/16118452.html#typescript%E5%AD%A6%E4%B9%A0%E9%AB%98%E7%BA%A7%E7%AF%87%E7%AC%AC%E5%9B%9B%E7%AB%A0%E5%85%AC%E5%85%B1%E7%B1%BB%E5%9E%8B)
    - [4.1 `Partial<Type>`](https://www.cnblogs.com/bleaka/p/16118452.html#41-partialtype)
    - [4.2 `Required<Type>`](https://www.cnblogs.com/bleaka/p/16118452.html#42-requiredtype)
    - [4.3 `Readonly<Type>`](https://www.cnblogs.com/bleaka/p/16118452.html#43-readonlytype)
    - [4.4 `Record<Keys,Type>`](https://www.cnblogs.com/bleaka/p/16118452.html#44-recordkeystype)
    - [4.5 `Pick<Type, Keys>`](https://www.cnblogs.com/bleaka/p/16118452.html#45-picktype-keys)
    - [4.6 `Omit<Type, Keys>`](https://www.cnblogs.com/bleaka/p/16118452.html#46-omittype-keys)
    - [4.7 `Exclude<Type, ExcludedUnion>`](https://www.cnblogs.com/bleaka/p/16118452.html#47-excludetype-excludedunion)
    - [4.8 `Extract<Type, Union>`](https://www.cnblogs.com/bleaka/p/16118452.html#48-extracttype-union)
    - [4.9 `NonNullable`](https://www.cnblogs.com/bleaka/p/16118452.html#49-nonnullable)
    - [4.10 `Parameters<Function Type>`](https://www.cnblogs.com/bleaka/p/16118452.html#410-parametersfunction-type)
    - [4.11 `ConstructorParameters`](https://www.cnblogs.com/bleaka/p/16118452.html#411-constructorparameters)
    - [4.12 `ReturnType`](https://www.cnblogs.com/bleaka/p/16118452.html#412--returntype)
    - [4.13 InstanceType](https://www.cnblogs.com/bleaka/p/16118452.html#413-instancetype)
    - [4.14 ThisParameterType](https://www.cnblogs.com/bleaka/p/16118452.html#414-thisparametertype)
    - [4.15 OmitThisParameter](https://www.cnblogs.com/bleaka/p/16118452.html#415-omitthisparameter)
    - [4.16 ThisType](https://www.cnblogs.com/bleaka/p/16118452.html#416-thistype)
    - [4.17 字符串操作类型](https://www.cnblogs.com/bleaka/p/16118452.html#417-%E5%AD%97%E7%AC%A6%E4%B8%B2%E6%93%8D%E4%BD%9C%E7%B1%BB%E5%9E%8B)
- [TypeScript学习高级篇第五章：Symbols](https://www.cnblogs.com/bleaka/p/16118452.html#typescript%E5%AD%A6%E4%B9%A0%E9%AB%98%E7%BA%A7%E7%AF%87%E7%AC%AC%E4%BA%94%E7%AB%A0symbols)
    - [5.1 `unique symbol`](https://www.cnblogs.com/bleaka/p/16118452.html#51-unique-symbol)
    - [5.2 知名的 Symbols](https://www.cnblogs.com/bleaka/p/16118452.html#52-%E7%9F%A5%E5%90%8D%E7%9A%84-symbols)
        - [5.2.1 Symbol.hasInstance](https://www.cnblogs.com/bleaka/p/16118452.html#521-symbolhasinstance)
        - [5.2.2 Symbol.isConcatSpreadable](https://www.cnblogs.com/bleaka/p/16118452.html#522-symbolisconcatspreadable)
        - [5.2.3 Symbol.iterator](https://www.cnblogs.com/bleaka/p/16118452.html#523-symboliterator)
        - [5.2.4 Symbol.match](https://www.cnblogs.com/bleaka/p/16118452.html#524-symbolmatch)
        - [5.2.5 Symbol.replace](https://www.cnblogs.com/bleaka/p/16118452.html#525-symbolreplace)
        - [5.2.6 Symbol.search](https://www.cnblogs.com/bleaka/p/16118452.html#526-symbolsearch)
        - [5.2.7 Symbol.species](https://www.cnblogs.com/bleaka/p/16118452.html#527-symbolspecies)
        - [5.2.8 Symbol.split](https://www.cnblogs.com/bleaka/p/16118452.html#528-symbolsplit)
        - [5.2.9 Symbol.toPrimitive](https://www.cnblogs.com/bleaka/p/16118452.html#529-symboltoprimitive)
        - [5.2.10 Symbol.toStringTag](https://www.cnblogs.com/bleaka/p/16118452.html#5210-symboltostringtag)
        - [5.2.11 Symbol.unscopables](https://www.cnblogs.com/bleaka/p/16118452.html#5211-symbolunscopables)
- [TypeScript学习高级篇第六章：类型兼容性](https://www.cnblogs.com/bleaka/p/16118452.html#typescript%E5%AD%A6%E4%B9%A0%E9%AB%98%E7%BA%A7%E7%AF%87%E7%AC%AC%E5%85%AD%E7%AB%A0%E7%B1%BB%E5%9E%8B%E5%85%BC%E5%AE%B9%E6%80%A7)
    - [6.1 关于健全性的说明](https://www.cnblogs.com/bleaka/p/16118452.html#61-%E5%85%B3%E4%BA%8E%E5%81%A5%E5%85%A8%E6%80%A7%E7%9A%84%E8%AF%B4%E6%98%8E)
    - [6.2 起步](https://www.cnblogs.com/bleaka/p/16118452.html#62-%E8%B5%B7%E6%AD%A5)
    - [6.3 对比两个函数](https://www.cnblogs.com/bleaka/p/16118452.html#63-%E5%AF%B9%E6%AF%94%E4%B8%A4%E4%B8%AA%E5%87%BD%E6%95%B0)
    - [6.4 函数参数的双差性](https://www.cnblogs.com/bleaka/p/16118452.html#64-%E5%87%BD%E6%95%B0%E5%8F%82%E6%95%B0%E7%9A%84%E5%8F%8C%E5%B7%AE%E6%80%A7)
    - [6.5 可选参数和其他参数](https://www.cnblogs.com/bleaka/p/16118452.html#65-%E5%8F%AF%E9%80%89%E5%8F%82%E6%95%B0%E5%92%8C%E5%85%B6%E4%BB%96%E5%8F%82%E6%95%B0)
    - [6.6 带有重载的函数](https://www.cnblogs.com/bleaka/p/16118452.html#66-%E5%B8%A6%E6%9C%89%E9%87%8D%E8%BD%BD%E7%9A%84%E5%87%BD%E6%95%B0)
    - [6.7 枚举](https://www.cnblogs.com/bleaka/p/16118452.html#67-%E6%9E%9A%E4%B8%BE)
    - [6.8 类](https://www.cnblogs.com/bleaka/p/16118452.html#68-%E7%B1%BB)
    - [6.9 类中的私有和受保护成员](https://www.cnblogs.com/bleaka/p/16118452.html#69-%E7%B1%BB%E4%B8%AD%E7%9A%84%E7%A7%81%E6%9C%89%E5%92%8C%E5%8F%97%E4%BF%9D%E6%8A%A4%E6%88%90%E5%91%98)
    - [6.10 泛型](https://www.cnblogs.com/bleaka/p/16118452.html#610-%E6%B3%9B%E5%9E%8B)
    - [6.11 子类型与赋值](https://www.cnblogs.com/bleaka/p/16118452.html#611-%E5%AD%90%E7%B1%BB%E5%9E%8B%E4%B8%8E%E8%B5%8B%E5%80%BC)
    - [6.12 `any` ,`unknown` ,`object` ,`void` ,`undefined` ,`null` , 和 `never`可分配性](https://www.cnblogs.com/bleaka/p/16118452.html#612-any-unknown-object-void-undefined-null--%E5%92%8C-never%E5%8F%AF%E5%88%86%E9%85%8D%E6%80%A7)
- [TypeScript学习高级篇第七章：迭代器和生成](https://www.cnblogs.com/bleaka/p/16118452.html#typescript%E5%AD%A6%E4%B9%A0%E9%AB%98%E7%BA%A7%E7%AF%87%E7%AC%AC%E4%B8%83%E7%AB%A0%E8%BF%AD%E4%BB%A3%E5%99%A8%E5%92%8C%E7%94%9F%E6%88%90)
    - [7.1 遍历](https://www.cnblogs.com/bleaka/p/16118452.html#71-%E9%81%8D%E5%8E%86)
        - [7.1.1 `Iterable`接口](https://www.cnblogs.com/bleaka/p/16118452.html#711-iterable%E6%8E%A5%E5%8F%A3)
        - [7.1.2 `for ... of`声明](https://www.cnblogs.com/bleaka/p/16118452.html#712-for--of%E5%A3%B0%E6%98%8E)
        - [7.1.3 `for ... of`与`for ... in` 声明](https://www.cnblogs.com/bleaka/p/16118452.html#713-for--of%E4%B8%8Efor--in-%E5%A3%B0%E6%98%8E)
    - [7.2 代码生成](https://www.cnblogs.com/bleaka/p/16118452.html#72-%E4%BB%A3%E7%A0%81%E7%94%9F%E6%88%90)
        - [7.2.1 生成目标 ES5 和 ES3](https://www.cnblogs.com/bleaka/p/16118452.html#721-%E7%94%9F%E6%88%90%E7%9B%AE%E6%A0%87-es5-%E5%92%8C-es3)
        - [7.2.2 ECMAScript 2015(ES6) 和 更高版本](https://www.cnblogs.com/bleaka/p/16118452.html#722-ecmascript-2015es6-%E5%92%8C-%E6%9B%B4%E9%AB%98%E7%89%88%E6%9C%AC)
- [TypeScript学习高级篇第八章：装饰器(Decorators)](https://www.cnblogs.com/bleaka/p/16118452.html#typescript%E5%AD%A6%E4%B9%A0%E9%AB%98%E7%BA%A7%E7%AF%87%E7%AC%AC%E5%85%AB%E7%AB%A0%E8%A3%85%E9%A5%B0%E5%99%A8decorators)
    - [8.1 简介](https://www.cnblogs.com/bleaka/p/16118452.html#81-%E7%AE%80%E4%BB%8B)
    - [8.2 装饰器](https://www.cnblogs.com/bleaka/p/16118452.html#82-%E8%A3%85%E9%A5%B0%E5%99%A8)
    - [8.3 装饰器工厂](https://www.cnblogs.com/bleaka/p/16118452.html#83-%E8%A3%85%E9%A5%B0%E5%99%A8%E5%B7%A5%E5%8E%82)
    - [8.4 装饰器构成](https://www.cnblogs.com/bleaka/p/16118452.html#84-%E8%A3%85%E9%A5%B0%E5%99%A8%E6%9E%84%E6%88%90)
    - [8.5 装饰器评估](https://www.cnblogs.com/bleaka/p/16118452.html#85-%E8%A3%85%E9%A5%B0%E5%99%A8%E8%AF%84%E4%BC%B0)
    - [8.6 类装饰器](https://www.cnblogs.com/bleaka/p/16118452.html#86-%E7%B1%BB%E8%A3%85%E9%A5%B0%E5%99%A8)
    - [8.7 方法装饰器](https://www.cnblogs.com/bleaka/p/16118452.html#87-%E6%96%B9%E6%B3%95%E8%A3%85%E9%A5%B0%E5%99%A8)
    - [8.8 访问器装饰器](https://www.cnblogs.com/bleaka/p/16118452.html#88-%E8%AE%BF%E9%97%AE%E5%99%A8%E8%A3%85%E9%A5%B0%E5%99%A8)
    - [8.9 属性装饰器](https://www.cnblogs.com/bleaka/p/16118452.html#89-%E5%B1%9E%E6%80%A7%E8%A3%85%E9%A5%B0%E5%99%A8)
    - [8.10 参数装饰器](https://www.cnblogs.com/bleaka/p/16118452.html#810-%E5%8F%82%E6%95%B0%E8%A3%85%E9%A5%B0%E5%99%A8)
- [TypeScript学习高级篇第九章：JSX](https://www.cnblogs.com/bleaka/p/16118452.html#typescript%E5%AD%A6%E4%B9%A0%E9%AB%98%E7%BA%A7%E7%AF%87%E7%AC%AC%E4%B9%9D%E7%AB%A0jsx)
    - [9.1 基本用法](https://www.cnblogs.com/bleaka/p/16118452.html#91-%E5%9F%BA%E6%9C%AC%E7%94%A8%E6%B3%95)
    - [9.2 `as`操作符](https://www.cnblogs.com/bleaka/p/16118452.html#92-as%E6%93%8D%E4%BD%9C%E7%AC%A6)
    - [9.3 类型检查](https://www.cnblogs.com/bleaka/p/16118452.html#93-%E7%B1%BB%E5%9E%8B%E6%A3%80%E6%9F%A5)
    - [9.4 内在元素](https://www.cnblogs.com/bleaka/p/16118452.html#94-%E5%86%85%E5%9C%A8%E5%85%83%E7%B4%A0)
    - [9.5 基于值的元素](https://www.cnblogs.com/bleaka/p/16118452.html#95-%E5%9F%BA%E4%BA%8E%E5%80%BC%E7%9A%84%E5%85%83%E7%B4%A0)
        - [9.5.1 函数组件](https://www.cnblogs.com/bleaka/p/16118452.html#951-%E5%87%BD%E6%95%B0%E7%BB%84%E4%BB%B6)
        - [9.5.2 类组件](https://www.cnblogs.com/bleaka/p/16118452.html#952-%E7%B1%BB%E7%BB%84%E4%BB%B6)
    - [9.7 子类型检查](https://www.cnblogs.com/bleaka/p/16118452.html#97-%E5%AD%90%E7%B1%BB%E5%9E%8B%E6%A3%80%E6%9F%A5)
    - [9.8 JSX的结果类型](https://www.cnblogs.com/bleaka/p/16118452.html#98-jsx%E7%9A%84%E7%BB%93%E6%9E%9C%E7%B1%BB%E5%9E%8B)
    - [9.9 嵌入表达式](https://www.cnblogs.com/bleaka/p/16118452.html#99-%E5%B5%8C%E5%85%A5%E8%A1%A8%E8%BE%BE%E5%BC%8F)
    - [9.10 React 集成](https://www.cnblogs.com/bleaka/p/16118452.html#910-react-%E9%9B%86%E6%88%90)
        - [9.10.1 配置JSX](https://www.cnblogs.com/bleaka/p/16118452.html#9101-%E9%85%8D%E7%BD%AEjsx)
- [TypeScript学习高级篇第十章：混入](https://www.cnblogs.com/bleaka/p/16118452.html#typescript%E5%AD%A6%E4%B9%A0%E9%AB%98%E7%BA%A7%E7%AF%87%E7%AC%AC%E5%8D%81%E7%AB%A0%E6%B7%B7%E5%85%A5)
    - [10.1 混入是如何工作的？](https://www.cnblogs.com/bleaka/p/16118452.html#101-%E6%B7%B7%E5%85%A5%E6%98%AF%E5%A6%82%E4%BD%95%E5%B7%A5%E4%BD%9C%E7%9A%84)
    - [10.2 受约束的混入](https://www.cnblogs.com/bleaka/p/16118452.html#102-%E5%8F%97%E7%BA%A6%E6%9D%9F%E7%9A%84%E6%B7%B7%E5%85%A5)
    - [10.3 替代模式](https://www.cnblogs.com/bleaka/p/16118452.html#103-%E6%9B%BF%E4%BB%A3%E6%A8%A1%E5%BC%8F)
    - [10.4 限制条件](https://www.cnblogs.com/bleaka/p/16118452.html#104-%E9%99%90%E5%88%B6%E6%9D%A1%E4%BB%B6)
        - [10.4.1 装饰器和混入](https://www.cnblogs.com/bleaka/p/16118452.html#1041-%E8%A3%85%E9%A5%B0%E5%99%A8%E5%92%8C%E6%B7%B7%E5%85%A5)
    - [10.4.2 静态属性混入](https://www.cnblogs.com/bleaka/p/16118452.html#1042-%E9%9D%99%E6%80%81%E5%B1%9E%E6%80%A7%E6%B7%B7%E5%85%A5)
- [TypeScript学习高级篇第十一章：三斜线指令](https://www.cnblogs.com/bleaka/p/16118452.html#typescript%E5%AD%A6%E4%B9%A0%E9%AB%98%E7%BA%A7%E7%AF%87%E7%AC%AC%E5%8D%81%E4%B8%80%E7%AB%A0%E4%B8%89%E6%96%9C%E7%BA%BF%E6%8C%87%E4%BB%A4)
    - [11.1 `/// <reference path='...' />`](https://www.cnblogs.com/bleaka/p/16118452.html#111--reference-path-)
    - [11.2 `/// <reference types='...' />`](https://www.cnblogs.com/bleaka/p/16118452.html#112--reference-types-)
    - [11.3 `/// <reference lib='...'>`](https://www.cnblogs.com/bleaka/p/16118452.html#113--reference-lib)
    - [11.4 `/// <reference no-default-lib='true'>`](https://www.cnblogs.com/bleaka/p/16118452.html#114--reference-no-default-libtrue)
    - [11.5 `/// <amd-module>`](https://www.cnblogs.com/bleaka/p/16118452.html#115--amd-module)
- [TypeScript学习高级篇第十二章：模块](https://www.cnblogs.com/bleaka/p/16118452.html#typescript%E5%AD%A6%E4%B9%A0%E9%AB%98%E7%BA%A7%E7%AF%87%E7%AC%AC%E5%8D%81%E4%BA%8C%E7%AB%A0%E6%A8%A1%E5%9D%97)
    - [12.1 导出声明](https://www.cnblogs.com/bleaka/p/16118452.html#121-%E5%AF%BC%E5%87%BA%E5%A3%B0%E6%98%8E)
    - [12.2 导出别名](https://www.cnblogs.com/bleaka/p/16118452.html#122-%E5%AF%BC%E5%87%BA%E5%88%AB%E5%90%8D)
    - [12.3 二次导出](https://www.cnblogs.com/bleaka/p/16118452.html#123-%E4%BA%8C%E6%AC%A1%E5%AF%BC%E5%87%BA)
    - [12.4 导入](https://www.cnblogs.com/bleaka/p/16118452.html#124-%E5%AF%BC%E5%85%A5)
        - [12.4.1 从一个模块中导入一个单一的导出](https://www.cnblogs.com/bleaka/p/16118452.html#1241-%E4%BB%8E%E4%B8%80%E4%B8%AA%E6%A8%A1%E5%9D%97%E4%B8%AD%E5%AF%BC%E5%85%A5%E4%B8%80%E4%B8%AA%E5%8D%95%E4%B8%80%E7%9A%84%E5%AF%BC%E5%87%BA)
        - [12.4.2 将整个模块导入到一个变量中，并使用它来访问模块的出口](https://www.cnblogs.com/bleaka/p/16118452.html#1242-%E5%B0%86%E6%95%B4%E4%B8%AA%E6%A8%A1%E5%9D%97%E5%AF%BC%E5%85%A5%E5%88%B0%E4%B8%80%E4%B8%AA%E5%8F%98%E9%87%8F%E4%B8%AD%E5%B9%B6%E4%BD%BF%E7%94%A8%E5%AE%83%E6%9D%A5%E8%AE%BF%E9%97%AE%E6%A8%A1%E5%9D%97%E7%9A%84%E5%87%BA%E5%8F%A3)
        - [12.4.3 导入一个只有副作用的模块](https://www.cnblogs.com/bleaka/p/16118452.html#1243-%E5%AF%BC%E5%85%A5%E4%B8%80%E4%B8%AA%E5%8F%AA%E6%9C%89%E5%89%AF%E4%BD%9C%E7%94%A8%E7%9A%84%E6%A8%A1%E5%9D%97)
    - [12.5 默认输出](https://www.cnblogs.com/bleaka/p/16118452.html#125-%E9%BB%98%E8%AE%A4%E8%BE%93%E5%87%BA)
    - [12.6 `as x`导出全部](https://www.cnblogs.com/bleaka/p/16118452.html#126-as-x%E5%AF%BC%E5%87%BA%E5%85%A8%E9%83%A8)
    - [12.7 `export =`与`import = require()`](https://www.cnblogs.com/bleaka/p/16118452.html#127-export-%E4%B8%8Eimport--require)
    - [12.8 模块的代码生成](https://www.cnblogs.com/bleaka/p/16118452.html#128--%E6%A8%A1%E5%9D%97%E7%9A%84%E4%BB%A3%E7%A0%81%E7%94%9F%E6%88%90)
    - [12.9 案例](https://www.cnblogs.com/bleaka/p/16118452.html#129-%E6%A1%88%E4%BE%8B)
    - [12.10 可选模块加载和其他高级加载场景](https://www.cnblogs.com/bleaka/p/16118452.html#1210-%E5%8F%AF%E9%80%89%E6%A8%A1%E5%9D%97%E5%8A%A0%E8%BD%BD%E5%92%8C%E5%85%B6%E4%BB%96%E9%AB%98%E7%BA%A7%E5%8A%A0%E8%BD%BD%E5%9C%BA%E6%99%AF)
    - [12.11 与其他JavaScript库一起工作](https://www.cnblogs.com/bleaka/p/16118452.html#1211-%E4%B8%8E%E5%85%B6%E4%BB%96javascript%E5%BA%93%E4%B8%80%E8%B5%B7%E5%B7%A5%E4%BD%9C)
        - [12.11.1 环境模块](https://www.cnblogs.com/bleaka/p/16118452.html#12111-%E7%8E%AF%E5%A2%83%E6%A8%A1%E5%9D%97)
        - [12.11.2 速记的环境模块](https://www.cnblogs.com/bleaka/p/16118452.html#12112-%E9%80%9F%E8%AE%B0%E7%9A%84%E7%8E%AF%E5%A2%83%E6%A8%A1%E5%9D%97)
        - [12.11.3 通配符模块的声明](https://www.cnblogs.com/bleaka/p/16118452.html#12113-%E9%80%9A%E9%85%8D%E7%AC%A6%E6%A8%A1%E5%9D%97%E7%9A%84%E5%A3%B0%E6%98%8E)
        - [12.11.4 UMD 模块](https://www.cnblogs.com/bleaka/p/16118452.html#12114-umd-%E6%A8%A1%E5%9D%97)
    - [12.12 构建模块的指导意见](https://www.cnblogs.com/bleaka/p/16118452.html#1212-%E6%9E%84%E5%BB%BA%E6%A8%A1%E5%9D%97%E7%9A%84%E6%8C%87%E5%AF%BC%E6%84%8F%E8%A7%81)
        - [12.12.1 尽可能接近顶层导出(export)](https://www.cnblogs.com/bleaka/p/16118452.html#12121-%E5%B0%BD%E5%8F%AF%E8%83%BD%E6%8E%A5%E8%BF%91%E9%A1%B6%E5%B1%82%E5%AF%BC%E5%87%BAexport)
        - [12.12.2 扩展的重新导出](https://www.cnblogs.com/bleaka/p/16118452.html#12122-%E6%89%A9%E5%B1%95%E7%9A%84%E9%87%8D%E6%96%B0%E5%AF%BC%E5%87%BA)
        - [12.12.3 不要在模块中使用命名空间](https://www.cnblogs.com/bleaka/p/16118452.html#12123-%E4%B8%8D%E8%A6%81%E5%9C%A8%E6%A8%A1%E5%9D%97%E4%B8%AD%E4%BD%BF%E7%94%A8%E5%91%BD%E5%90%8D%E7%A9%BA%E9%97%B4)
        - [12.12.4 红线](https://www.cnblogs.com/bleaka/p/16118452.html#12124-%E7%BA%A2%E7%BA%BF)
- [TypeScript学习高级篇第十三章：模块解析](https://www.cnblogs.com/bleaka/p/16118452.html#typescript%E5%AD%A6%E4%B9%A0%E9%AB%98%E7%BA%A7%E7%AF%87%E7%AC%AC%E5%8D%81%E4%B8%89%E7%AB%A0%E6%A8%A1%E5%9D%97%E8%A7%A3%E6%9E%90)
    - [13.1 相对与非相对的模块导入](https://www.cnblogs.com/bleaka/p/16118452.html#131-%E7%9B%B8%E5%AF%B9%E4%B8%8E%E9%9D%9E%E7%9B%B8%E5%AF%B9%E7%9A%84%E6%A8%A1%E5%9D%97%E5%AF%BC%E5%85%A5)
    - [13.2 模块解析策略](https://www.cnblogs.com/bleaka/p/16118452.html#132--%E6%A8%A1%E5%9D%97%E8%A7%A3%E6%9E%90%E7%AD%96%E7%95%A5)
        - [13.2.1 Classic](https://www.cnblogs.com/bleaka/p/16118452.html#1321-classic)
        - [13.2.2 Node](https://www.cnblogs.com/bleaka/p/16118452.html#1322-node)
    - [13.3 额外的模块解析标志](https://www.cnblogs.com/bleaka/p/16118452.html#133-%E9%A2%9D%E5%A4%96%E7%9A%84%E6%A8%A1%E5%9D%97%E8%A7%A3%E6%9E%90%E6%A0%87%E5%BF%97)
        - [13.3.1 Base URL](https://www.cnblogs.com/bleaka/p/16118452.html#1331-base-url)
        - [13.3.2 路径映射](https://www.cnblogs.com/bleaka/p/16118452.html#1332-%E8%B7%AF%E5%BE%84%E6%98%A0%E5%B0%84)
        - [13.3.3 带有`rootDirs`的虚拟目录](https://www.cnblogs.com/bleaka/p/16118452.html#1333-%E5%B8%A6%E6%9C%89rootdirs%E7%9A%84%E8%99%9A%E6%8B%9F%E7%9B%AE%E5%BD%95)
    - [13.4 追踪模块的解析](https://www.cnblogs.com/bleaka/p/16118452.html#134-%E8%BF%BD%E8%B8%AA%E6%A8%A1%E5%9D%97%E7%9A%84%E8%A7%A3%E6%9E%90)
    - [13.5 应用 `--noResolve`](https://www.cnblogs.com/bleaka/p/16118452.html#135-%E5%BA%94%E7%94%A8---noresolve)
    - [13.6 常见的问题](https://www.cnblogs.com/bleaka/p/16118452.html#136-%E5%B8%B8%E8%A7%81%E7%9A%84%E9%97%AE%E9%A2%98)
- [TypeScript学习高级篇第十四章：命名空间](https://www.cnblogs.com/bleaka/p/16118452.html#typescript%E5%AD%A6%E4%B9%A0%E9%AB%98%E7%BA%A7%E7%AF%87%E7%AC%AC%E5%8D%81%E5%9B%9B%E7%AB%A0%E5%91%BD%E5%90%8D%E7%A9%BA%E9%97%B4)
    - [14.1 第一步](https://www.cnblogs.com/bleaka/p/16118452.html#141-%E7%AC%AC%E4%B8%80%E6%AD%A5)
        - [14.1.1 单一文件中的验证器](https://www.cnblogs.com/bleaka/p/16118452.html#1411-%E5%8D%95%E4%B8%80%E6%96%87%E4%BB%B6%E4%B8%AD%E7%9A%84%E9%AA%8C%E8%AF%81%E5%99%A8)
    - [14.2 命名方式](https://www.cnblogs.com/bleaka/p/16118452.html#142-%E5%91%BD%E5%90%8D%E6%96%B9%E5%BC%8F)
    - [14.3 命名的验证器](https://www.cnblogs.com/bleaka/p/16118452.html#143-%E5%91%BD%E5%90%8D%E7%9A%84%E9%AA%8C%E8%AF%81%E5%99%A8)
    - [14.4 跨文件分割](https://www.cnblogs.com/bleaka/p/16118452.html#144-%E8%B7%A8%E6%96%87%E4%BB%B6%E5%88%86%E5%89%B2)
    - [14.5 多文件命名空间](https://www.cnblogs.com/bleaka/p/16118452.html#145-%E5%A4%9A%E6%96%87%E4%BB%B6%E5%91%BD%E5%90%8D%E7%A9%BA%E9%97%B4)
    - [14.6 别名](https://www.cnblogs.com/bleaka/p/16118452.html#146-%E5%88%AB%E5%90%8D)
    - [14.7 与其他JavaScript库一起工作](https://www.cnblogs.com/bleaka/p/16118452.html#147-%E4%B8%8E%E5%85%B6%E4%BB%96javascript%E5%BA%93%E4%B8%80%E8%B5%B7%E5%B7%A5%E4%BD%9C)
- [TypeScript学习高级篇第十五章：命名空间与模块](https://www.cnblogs.com/bleaka/p/16118452.html#typescript%E5%AD%A6%E4%B9%A0%E9%AB%98%E7%BA%A7%E7%AF%87%E7%AC%AC%E5%8D%81%E4%BA%94%E7%AB%A0%E5%91%BD%E5%90%8D%E7%A9%BA%E9%97%B4%E4%B8%8E%E6%A8%A1%E5%9D%97)
    - [15.1 使用模块](https://www.cnblogs.com/bleaka/p/16118452.html#151-%E4%BD%BF%E7%94%A8%E6%A8%A1%E5%9D%97)
    - [15.2 使用命名空间](https://www.cnblogs.com/bleaka/p/16118452.html#152-%E4%BD%BF%E7%94%A8%E5%91%BD%E5%90%8D%E7%A9%BA%E9%97%B4)
    - [15.3 命名空间和模块的陷阱](https://www.cnblogs.com/bleaka/p/16118452.html#153-%E5%91%BD%E5%90%8D%E7%A9%BA%E9%97%B4%E5%92%8C%E6%A8%A1%E5%9D%97%E7%9A%84%E9%99%B7%E9%98%B1)
        - [15.3.1 `/// <reference>`为模块命名](https://www.cnblogs.com/bleaka/p/16118452.html#1531--reference%E4%B8%BA%E6%A8%A1%E5%9D%97%E5%91%BD%E5%90%8D)
        - [15.3.2 不必要的命名方式](https://www.cnblogs.com/bleaka/p/16118452.html#1532-%E4%B8%8D%E5%BF%85%E8%A6%81%E7%9A%84%E5%91%BD%E5%90%8D%E6%96%B9%E5%BC%8F)
        - [15.3.3 模块的权衡](https://www.cnblogs.com/bleaka/p/16118452.html#1533-%E6%A8%A1%E5%9D%97%E7%9A%84%E6%9D%83%E8%A1%A1)
- [TypeScript学习高级篇第十六章： 声明合并](https://www.cnblogs.com/bleaka/p/16118452.html#typescript%E5%AD%A6%E4%B9%A0%E9%AB%98%E7%BA%A7%E7%AF%87%E7%AC%AC%E5%8D%81%E5%85%AD%E7%AB%A0-%E5%A3%B0%E6%98%8E%E5%90%88%E5%B9%B6)
    - [16.1 简介](https://www.cnblogs.com/bleaka/p/16118452.html#161-%E7%AE%80%E4%BB%8B)
    - [16.2 基本概念](https://www.cnblogs.com/bleaka/p/16118452.html#162-%E5%9F%BA%E6%9C%AC%E6%A6%82%E5%BF%B5)
    - [16.3 合并接口](https://www.cnblogs.com/bleaka/p/16118452.html#163-%E5%90%88%E5%B9%B6%E6%8E%A5%E5%8F%A3)
    - [16.4 合并命名空间](https://www.cnblogs.com/bleaka/p/16118452.html#164-%E5%90%88%E5%B9%B6%E5%91%BD%E5%90%8D%E7%A9%BA%E9%97%B4)
        - [16.4.1 将命名空间与类、函数和枚举合并起来](https://www.cnblogs.com/bleaka/p/16118452.html#1641-%E5%B0%86%E5%91%BD%E5%90%8D%E7%A9%BA%E9%97%B4%E4%B8%8E%E7%B1%BB%E5%87%BD%E6%95%B0%E5%92%8C%E6%9E%9A%E4%B8%BE%E5%90%88%E5%B9%B6%E8%B5%B7%E6%9D%A5)
        - [16.4.2 将命名空间与类合并](https://www.cnblogs.com/bleaka/p/16118452.html#1642-%E5%B0%86%E5%91%BD%E5%90%8D%E7%A9%BA%E9%97%B4%E4%B8%8E%E7%B1%BB%E5%90%88%E5%B9%B6)
        - [16.4.3 不被允许的合并](https://www.cnblogs.com/bleaka/p/16118452.html#1643-%E4%B8%8D%E8%A2%AB%E5%85%81%E8%AE%B8%E7%9A%84%E5%90%88%E5%B9%B6)
    - [16.5 模块增强](https://www.cnblogs.com/bleaka/p/16118452.html#165-%E6%A8%A1%E5%9D%97%E5%A2%9E%E5%BC%BA)
    - [16.6 全局增强](https://www.cnblogs.com/bleaka/p/16118452.html#166-%E5%85%A8%E5%B1%80%E5%A2%9E%E5%BC%BA)

# TypeScript学习高级篇第一章：变量声明

`let`和`const`是JavaScript中变量声明的两个相对较新的概念。正如我们前面提到的， `let` 在某些方面与 `var` 相似，但允许用户避免在JavaScript中遇到的一些常见的 "麻烦"。

`const`是`let`的一个扩展，它可以防止重新赋值给一个变量。

由于TypeScript是JavaScript的扩展，该语言自然支持 `let` 和 `const` 。在这里，我们将进一步阐述这些新的声明，以及为什么它们比 `var` 更适合。

如果你已经不经意地使用了JavaScript，那么下一节可能是刷新你记忆的一个好方法。如果你对JavaScript中 `var` 声明的所有怪癖非常熟悉，你可能会发现跳过前面会更容易。

## 1.1 var变量声明

在JS中声明一个变量，传统上都是用`var`关键字来完成。

```tsx
var a = 10
```

正如你可能已经发现的，我们刚刚声明了一个名为`a`的变量，其值为`10` 。

我们也可以在一个函数中声明一个变量：

```tsx
function f() {	var message = "Hello, world!";	return message;}
```

而我们也可以在其他函数中访问这些相同的变量：

```tsx
function f() {    var a = 10;    return function g() {        var b = a + 1;        return b;    };}var g = f();g(); // returns '11'
```

在上面这个例子中， g 捕获了 f 中声明的变量 a 。在 g 被调用的任何时候， a 的值都将与 f 中 a 的值相联系。

```tsx
function f() {    var a = 1;    a = 2;    var b = g();    a = 3;    return b;    function g() {        return a;    }}f(); // returns '2'
```

## 1.2 作用域法则

对于那些习惯于其他语言的人来说， `var` 声明有一些奇怪的作用域范围规则。以下面的例子为例：

```tsx
function f(shouldInitialize: boolean) {    if (shouldInitialize) {        var x = 10;    }    return x;}f(true); // 返回 '10'f(false); // 返回 'undefined'
```

有些读者可能会对这个例子产生怀疑。变量 x 是在 `if` 块中声明的，但我们却能从该块之外访问它。这是因为 `var` 声明可以在其**包含的函数、模块、命名空间或全局范围内的任何地方**访问（所有这些我们将在后面讨论），而不考虑包含的块。有些人把这称为 **`var` 作用域**或**函数作用域**。参数也是函数作用域。

这些作用域规则会导致几种类型的错误。它们加剧的一个问题是，多次声明同一个变量并不是一个错误。

```tsx
function sumMatrix(matrix: number[][]) {    var sum = 0;    for (var i = 0; i < matrix.length; i++) {        var currentRow = matrix[i];        for (var i = 0; i < currentRow.length; i++) {            sum += currentRow[i];        }    }    return sum;}
```

也许对于一些有经验的JavaScript开发者来说，这很容易被发现，但是内部 `for-loop` 会意外地覆盖变量 `i` ，因为 `i` 指的是同一个函数范围的变量。正如有经验的开发者现在所知道的，类似的各种bug会在代码审查中溜走，并会成为无尽的挫折来源。

## 1.3 变量捕获的怪癖

花点时间猜一猜下面这段话的输出是什么：

```tsx
for (var i = 0; i < 10; i++) {    setTimeout(function () {        console.log(i);    }, 100 * i);}
```

对于那些不熟悉的人来说， `setTimeout` 将尝试在一定数量的毫秒后执行一个函数（尽管要等待其他东西停止运行）。最后的结果是十行10。

许多JavaScript开发人员对这种行为非常熟悉，但如果你感到惊讶，你肯定不是一个人。大多数人都希望输出的结果是：1 2 3 4 5 6 7 8 9 10。

还记得我们前面提到的关于变量捕获的问题吗？我们传递给 `setTimeout` 的每个函数表达式实际上都是指同一范围内的同一个 `i` 。

让我们花点时间考虑一下这意味着什么。`setTimeout` 将在若干毫秒之后运行一个函数，但只有在 for循环停止执行之后；当 for 循环停止执行时， i 的值是 10 。因此，每次给定的函数被调用时，它将打 印出 10 !

一个常见的解决方法是使用`IIFE`--一个立即调用的函数表达式--来捕获每次迭代的 i 。

```tsx
for (var i = 0; i < 10; i++) {    // 通过调用一个带有其当前值的函数    // 捕捉'i'的当前状态    (function (i) {        setTimeout(function () {            console.log(i);        }, 100 * i);    })(i);}
```

这种看起来很奇怪的模式其实是很常见的。参数列表中的 i 实际上是对 for 循环中声明的 i 的影子，但由于我们对它们的命名相同，所以我们不必对循环体进行过多的修改。

## 1.4 let变量声明

现在你已经发现 `var` 有一些问题，这正是 `let` 语句被引入的原因。除了使用的关键字外， let 语句的写法与 var 语句相同。

```tsx
let hello = 'hello'
```

关键的区别不在语法上，而在语义上，我们现在要深入研究

## 1.5 块级作用域

当一个变量使用 `let` 声明时，它使用了一些人所说的词法范围或块法范围。与用 `var` 声明的变量不同, `block-scope`块级作用域变量的作用域会泄露给其包含的函数, 而在其最近的包含块或 `for-loop`之外是不可见的。

```tsx
function f(input: boolean) {    let a = 100;    if (input) {        // 引用'a'仍然可以        let b = a + 1;        return b;    }    // 错误：这里不存在'b'。    return b;}
```

在这里，我们有两个局部变量 a 和 b 。a 的作用域仅限于 f 的主体，而 b 的作用域仅限于包含 if 语句的块。

在 `catch` 子句中声明的变量也有类似的作用域规则

```tsx
try {    throw "oh no!";} catch (e) {    console.log("Oh well.");}// Error: 这里不存在'e'。console.log(e);
```

块级作用域变量的另一个属性是，**在它们被实际声明之前，它们不能被读或写到**。虽然这些变量在它们的整个作用域中都是 "存在 "的，但是直到它们被声明之前的所有点都是它们的时间死角的一部分。这只是一种复杂的说法，你不能在 `let` 语句之前访问它们，幸运的是TypeScript会让你知道这一点。

```tsx
a++; // 在声明之前使用'a'是非法的。let a;
```

需要注意的是，你仍然可以在声明之前捕获一个块范围的变量。唯一的问题是，在声明之前调用该函数是非法的。如果以ES2015为目标，现代运行时将抛出一个错误；然而，现在TypeScript是允许的，不会将此作为一个错误报告。

```tsx
function foo() {    // 可以捕捉到 "a"。    return a;}// 在声明'a'之前非法调用'foo'。// runtimes应该在这里抛出一个错误foo();let a;
```

## 1.6 重复声明和投影

对于`var`声明，我们提到，你声明了多少次变量并不重要，你只是得到了一个。

```tsx
function f(x) {    var x; var x;    if (true) {        var x;    }}
```

在上面的例子中，所有关于 x 的声明实际上指的是同一个 x ，这是完全有效的。这往往会成为错误的根源。值得庆幸的是， `let` 的声明并不那么宽容。

```tsx
let x = 10;let x = 20; // 错误：不能在同一范围内重新声明'x'。
```

变量不一定要都是块范围的，TypeScript才会告诉我们有一个问题。

```tsx
function f(x) {    let x = 100; // 错误：干扰了参数声明}function g() {    let x = 100;    var x = 100; // 错误：不能同时有'x'的声明}
```

这并不是说一个块作用域变量永远不能和一个函数作用域变量一起声明。区块作用域变量只是需要在一个明显不同的区块中声明。

```tsx
function f(condition, x) {    if (condition) {        let x = 100;        return x;    }    return x;}f(false, 0); // 返回 0f(true, 0); // 返回 100
```

在一个更加嵌套的作用域中引入一个新名字的行为被称为投影。这是一把双刃剑，因为它可以在意外影射的情况下自行引入某些错误，同时也可以防止某些错误。例如，想象一下我们之前用 let 变量编写的`sumMatrix`函数：

```tsx
function sumMatrix(matrix: number[][]) {    let sum = 0;    for (let i = 0; i < matrix.length; i++) {        var currentRow = matrix[i];        for (let i = 0; i < currentRow.length; i++) {            sum += currentRow[i];        }    }    return sum;}
```

这个版本的循环实际上会正确地执行求和，因为内循环的 i 会对外循环的 i 产生阴影。

为了写出更清晰的代码，通常应避免使用投影。虽然在某些情况下，利用它可能是合适的，但你应该使用你的最佳判断。

## 1.7 块级作用域变量捕获

当我们第一次触及用 `var` 声明捕获变量的想法时，我们简要地讨论了变量一旦被捕获是如何行动的。为了给大家一个更好的直观印象，每次运行一个作用域时，它都会创建一个变量的 "环境"。这个环境和它捕获的变量甚至在它的作用域内的所有东西都执行完毕后仍然存在。

```tsx
function theCityThatAlwaysSleeps() {    let getCity;    if (true) {        let city = "Seattle";        getCity = function () {            return city;        };    }    return getCity();}
```

因为我们已经从它的环境中捕获了 `city` ，所以尽管 `if` 块已经执行完毕，我们仍然能够访问它。

回想一下，在我们之前的 `setTimeout` 例子中，我们最终需要使用`IIFE`来捕获 for 循环的每个迭代中的变量状态。实际上，**我们所做的是为我们捕获的变量创建一个新的变量环境**。这有点麻烦，但幸运的是，在TypeScript中你再也不用这么做了。

当声明为循环的一部分时， let 声明的行为有很大的不同。这些声明并不只是给循环本身引入一个新的环境，而是在每个迭代中创建一个新的范围。因为这就是我们在IIFE中所做的事情，我们可以改变我们以前的 `setTimeout` 的例子，只使用 `let` 声明。

```tsx
for (let i = 0; i < 10; i++) {    setTimeout(function () {        console.log(i);    }, 100 * i);}
```

和预期一样会打印：0 1 2 3 4 5 6 7 8 9

## 1.8 `const`声明

`const`声明是声明变量的另一种方式

```tsx
const numLivesForCat = 9;
```

它们就像 let 声明一样，但正如它们的名字所暗示的，一旦它们被绑定，它们的值就不能被改变。换句话说，它们有和 let 一样的范围规则，但你不能重新赋值给它们。

这不应该与它们所指的值是不可改变的想法相混淆。

```tsx
const numLivesForCat = 9;const kitty = {    name: "Aurora",    numLives: numLivesForCat,}; // 错误kitty = {    name: "Danielle",    numLives: numLivesForCat,}; // 以下都正确kitty.name = "Rory";kitty.name = "Kitty";kitty.name = "Cat";kitty.numLives--;
```

除非你采取特定的措施来避免它，否则常量变量的内部状态仍然是可以修改的。幸运的是，TypeScript允许你指定一个对象的成员是 `readonly` 的。

## 1.9 `let`与`const`比较

鉴于我们有两种具有类似范围语义的声明，我们很自然地会问自己应该使用哪一种。像大多数广泛的问题一样，答案是：这取决于。

**根据最小特权原则，除了那些你打算修改的声明外，所有的声明都应该使用 const。其理由是，如果一个变量不需要被写入，那么在同一个代码库中工作的其他人就不应该自动能够写入该对象，他们需要考虑是否真的需要重新赋值给该变量。在推理数据流时，使用 const 也会使代码更可预测。**

使用你的最佳判断，如果适用的话，请与你的团队其他成员协商此事。

下面文档大部分内容都使用 `let` 声明。

## 1.10 解构

**解构赋值**语法是一种 Javascript表达式。通过**解构赋值,** 可以将属性/值从对象/数组中取出,赋值给其他变量。

## 1.11 数组析构

最简单的解构形式是数组解构赋值。

```tsx
let input = [1, 2];let [first, second] = input;console.log(first); // 输出 1console.log(second); // 输出 2
```

这将创建两个新的变量，命名为 first 和 second 。这等同于使用索引，但要方便得多。

```tsx
first = input[0];second = input[1];
```

解构也适用于已经声明的变量。

```tsx
// 交换变量[first, second] = [second, first];
```

而且是带参数的函数：

```tsx
function f([first, second]: [number, number]) {    console.log(first);    console.log(second);}f([1, 2]);
```

你可以使用语法 `...` 为列表中的剩余项目创建一个变量

```tsx
let [first, ...rest] = [1, 2, 3, 4];console.log(first); // 输出 1console.log(rest); // 输出 [ 2, 3, 4 ]
```

当然，由于这是JavaScript，你可以直接忽略你不关心的拖尾元素：

```tsx
let [first] = [1, 2, 3, 4];console.log(first); // outputs 1
```

## 1.12 元组解构

元组可以像数组一样被去结构化；去结构化的变量得到相应元组元素的类型：

```tsx
let tuple: [number, string, boolean] = [7, "hello", true];let [a, b, c] = tuple; // a: number, b: string, c: boolean
```

对一个元组进行解构，超出其元素的范围是一个错误：

```tsx
let [a, b, c, d] = tuple; // 错误，索引3处没有元素
```

和数组一样，你可以用 `...` 对元组的其余部分进行解构，以得到一个更短的元组:

```tsx
let [a, ...bc] = tuple; // bc: [string, boolean]let [a, b, c, ...d] = tuple; // d: [], 空 tuple
```

或者忽略尾部元素，或者忽略其他元素：

```tsx
let [a] = tuple; // a: numberlet [, b] = tuple; // b: string
```

## 1.13 对象解构

你也可以做对象的解构：

```tsx
let o = { a: "foo", b: 12, c: "bar",};let { a, b } = o;
```

这就从 `o.a` 和 `o.b` 中创建了新的变量 `a` 和 `b` 。注意，如果你不需要 `c` ，你可以跳过它。 就像数组去结构化一样，你可以不用声明就进行赋值：

```tsx
({ a, b } = { a: "baz", b: 101 });
```

请注意，我们必须用圆括号包围这个语句。JavaScript通常将{作为块的开始来解析。

你可以使用语法 `...` 为对象中的剩余项目创建一个变量：

```tsx
let { a, ...passthrough } = o;let total = passthrough.b + passthrough.c.length;
```

1. 属性重命名

你也可以给属性起不同的名字：

```tsx
let { a: newName1, b: newName2 } = o;
```

这里的语法开始变得混乱了。你可以把 `a: newName1` 读作 `"a as newName1"` 。方向是从左到右，就像你写的一样:

```tsx
let newName1 = o.a;let newName2 = o.b;
```

令人困惑的是，这里的冒号并不表示类型。如果你指定了类型，仍然需要写在整个结构解构之后。

```tsx
let { a, b }: { a: string; b: number } = o;
```

2. 默认值

默认值让你指定一个默认值，以防一个属性未被定义:

```tsx
function keepWholeObject(wholeObject: { a: string; b?: number }) {	let { a, b = 1001 } = wholeObject;}
```

在这个例子中， `b?` 表示 `b` 是可选的，所以它可能是未定义的。 `keepWholeObject` 现在有一个 `wholeObject` 的变量，以及属性 `a` 和 `b` ，即使 `b` 是未定义的。

## 1.14 Function声明

去结构化在函数声明中也起作用。对于简单的情况，这是很直接的。

```tsx
type C = { a: string; b?: number };function f({ a, b }: C): void {	// ...}
```

但是对于参数来说，指定默认值是比较常见的，而用解构的方式来获得默认值是很棘手的。首先，你需要记住把模式放在默认值之前。

```tsx
function f({ a = "", b = 0 } = {}): void {    // ...}f();
```

然后，你需要记住在 `destructured`属性上给可选属性一个默认值，而不是主初始化器。记住， C的定义是b可选的。

```tsx
function f({ a, b = 0 } = { a: "" }): void {    // ...}f({ a: "yes" }); // 正确，b = 0f(); // 正确, 默认 { a: "" }, 然后默认为 b = 0f({}); // 错误，如果你提供一个参数，'a'是必须的
```

小心使用解构。正如前面的例子所展示的，除了最简单的析构表达式之外，任何东西都会令人困惑。这在深度嵌套的结构化中尤其如此，即使不堆积重命名、默认值和类型注释，也会变得非常难以理解。尽量保持结构化表达式的小而简单。你总是可以自己写出解构会产生的赋值。

## 1.15 展开

展开操作符与解构相反。它允许你将一个数组分散到另一个数组中，或者将一个对象分散到另一个对象中。比如说：

```tsx
let first = [1, 2];let second = [3, 4];let bothPlus = [0, ...first, ...second, 5];
```

这使 `bothPlus` 的值为 `[0, 1, 2, 3, 4, 5]` 。展开创建`first`和`second`的浅层拷贝。它们不会因 为展开而改变。

你也可以展开对象。

```tsx
let defaults = {    food: "spicy",    price: "$$",    ambiance: "noisy"};let search = {    ...defaults,    food: "rich"};
```

现在的 search 是 `{ food: "rich", price: "$$", ambiance: "noisy" }` 。对象展开比数组展开更复杂。像数组展开一样，它从左到右进行，但结果仍然是一个对象。这意味着展开**对象中较晚出现的属性会覆盖较早出现的属性**。因此，如果我们修改前面的例子，在最后展开：

```tsx
let defaults = {    food: "spicy",    price: "$$",    ambiance: "noisy"};let search = {    food: "rich",    ...defaults};
```

然后， defaults 中的食物属性覆盖了 `food: "rich"` ，这不是我们在这种情况下想要的。

对象传播也有其他一些令人惊讶的限制。首先，它只包括一个对象自己的、可列举的属性。基本上，这意味着当你传播一个对象的实例时，你会**失去方法**。

```tsx
class C {    p = 12;    m() {}}let c = new C();let clone = {    ...c};clone.p; // 正确clone.m(); // 错误!
```

TypeScript编译器不允许从通用函数中展开类型参数。该功能预计将在未来的语言版本中出现。

# TypeScript学习高级篇第二章：类型推断

在TS中，有几个地方在没有显式类型注释的情况下，使用类型推理来提供类型信息。例如，在这段代码中：

```tsx
//let x: numberlet x = 3 
```

`x` 变量的类型被推断为 `number` 。这种推断发生在**初始化变量和成员**、**设置参数默认值**和**确定函数返回类型**时。

在大多数情况下，类型推断是**直截了当**的。在下面的章节中，我们将探讨类型推断的一些细微差别。

## 2.1 最佳公共类型

当从几个表达式中进行类型推断时，这些表达式的类型被用来计算一个 "最佳公共类型"。比如说：

```tsx
// let x: (number | null)[]let x = [0, 1, null];
```

为了推断上面例子中 `x` 的类型，我们必须考虑每个数组元素的类型。这里我们得到了两个数组类型的选择： `number` 和 `null` 。最佳公共类型算法考虑了每个候选类型，并**选择了与所有其他候选类型兼容的类型**。

因为最佳公共类型必须从所提供的候选类型中选择，所以在某些情况下，类型有共同的结构，但没有一个类型是所有候选类型的超级类型。比如说：

```tsx
// let zoo: (Rhino | Elephant | Snake)[]let zoo = [new Rhino(), new Elephant(), new Snake()];
```

理想情况下，我们可能希望 `zoo` 被推断为 `Animal[]` ，但是因为数组中没有严格意义上的 `Animal` 类型的对象，所以我们没有对数组元素类型进行推断。为了纠正这一点，当没有一个类型是所有其他候选类型的超级类型时，就明确地提供类型。

```tsx
// let zoo: Animal[]tlet zoo: Animal[] = [new Rhino(), new Elephant(), new Snake()];
```

当没有找到最好的共同类型时，产生的推论是联合数组类型， `(Rhino | Elephant | Snake)[]` 。

## 2.2 上下文类型

在TS的某些情况下，类型推理也在"另一个方向"发挥作用。这被称为”上下文类型化“。当表达式的类型被他的位置所暗示时，上下文类型就发生了。例如：

```tsx
window.onmousedown = function (mouseEvent) {    console.log(mouseEvent.button);    console.log(mouseEvent.kangaroo); // Ⓧ 在'MouseEvent'类型上不存在'kangaroo'属性。};
```

在这里，TypeScript 类型检查器使用 `window.onmousedown` 函数的类型来推断赋值右侧的函数表达式的类型。当它这样做时，它能够推断出 `mouseEvent` 参数的类型，它确实包含一个**按钮**button属性，但不包含**袋鼠**kangaroo属性。

这样做的原因是 `window` 已经在其类型中声明了 `onmousedown` 。

```tsx
// 声明有一个名为'window'的全局变量declare var window: Window & typeof globalThis; // 这被声明为（简化版）。interface Window extends GlobalEventHandlers {    // ...} // 其中定义了很多已知的处理程序事件interface GlobalEventHandlers {    onmousedown: ((this: GlobalEventHandlers, ev: MouseEvent) => any) | null;    // ...}	
```

TypeScript足够聪明，在其他情况下也能推断出类型：

```tsx
window.onscroll = function (uiEvent) {    // Ⓧ 属性 "button" 不存在于 "Event"类型上。    console.log(uiEvent.button);};
```

基于上述函数被分配给 `Window.onscroll` 的事实，TypeScript知道 `uiEvent` 是一个 `UIEvent` ，而不是像前面的例子那样是 `MouseEvent` 。 `UIEvent` 对象不包含按钮属性，所以TypeScript会抛出一个错误。

如果这个函数不在上下文类型的位置，这个函数的参数将隐含有类型 `any` ，并且不会发出错误（除非你使用 `noImplicitAny`选项）。

```tsx
const handler = function (uiEvent) {	console.log(uiEvent.button); // <- 正确};
```

我们也可以明确地给函数的参数提供类型信息，以覆盖任何上下文的类型。

```tsx
window.onscroll = function (uiEvent: any) {	console.log(uiEvent.button); // <- 现在也没有错误};
```

然而，这段代码将记录 `undefined` 的内容，因为 uiEvent 没有名为按钮的属性。

上下文类型化在很多情况下都适用。常见的情况包括**函数调用的参数**、**赋值的右侧**、**类型断言**、**对象**和**数组字面量**的成员，以及**返回语句**。上下文类型也作为最佳普通类型的候选类型。比如说:

```tsx
function createZoo(): Animal[] {	return [new Rhino(), new Elephant(), new Snake()];}
```

在这个例子中，最佳普通类型有一组四个候选者。 `Animal` , `Rhino` , `Elephant` 和 `Snake` 。其中，`Animal` 可以被最佳共同类型算法所选择。

# TypeScript学习高级篇第三章：枚举

`Enums` 是TypeScript的少数功能之一，它不是JavaScript的类型级扩展。

**枚举允许开发者定义一组命名的常量**。使用枚举可以使其更容易记录意图，或创建一组不同的情况。TypeScript提供了基于**数字**和**字符串**的枚举。

## 3.1 数值型枚举

我们首先从数字枚举开始，如果你来自自其他语言，可能会更熟悉它。一个枚举可以用 **enum**关键字来定义。

```tsx
enum Direction {    Up = 1,    Down,    Left,    Right,}
```

上面，我们有一个数字枚举，其中 `Up` 被初始化为 1 ，所有下面的成员从这一点开始自动递增。换句话说， `Direction.Up`的值是 1 ， `Down` 是 2 ， `Left` 是 3 ， `Right` 是 4 。

如果我们愿意，我们可以完全不使用初始化器：

```tsx
enum Direction {    Up,    Down,    Left,    Right,}
```

这里，Up的值是0，Down是1，依次类推。这种**自动递增**的行为对于我们可能**不关心成员值本身**，但**关心每个值与同一枚举中的其他值不同的情况**很有用。

使用枚举很简单：只需将任何成员作为枚举本身的一个属性来访问，并使用枚举的名称来声明类型:

```tsx
enum UserResponse {    No = 0,    Yes = 1,}function respond(recipient: string, message: UserResponse): void {    // ...}respond("Princess Caroline", UserResponse.Yes);
```

数字枚举可以混合在计算和常量成员中（见下文）。简而言之，**没有初始化器的枚举要么需要放在第一位**，**要么必须放在用数字常量或其他常量枚举成员初始化的数字枚举之后**。换句话说，下面的情况是不允许的:

```tsx
enum E {    A = getSomeValue(),    B,    // Ⓧ Enum成员必须有初始化器。}
```

## 3.2 字符串枚举

字符串枚举是一个类似的概念，但有一些细微的运行时差异，如下文所述。在一个字符串枚举中，**每个成员都必须用一个字符串字头或另一个字符串枚举成员进行常量初始化**。

```tsx
enum Direction {    Up = "UP",    Down = "DOWN",    Left = "LEFT",    Right = "RIGHT",}
```

虽然字符串枚举没有自动递增的行为，但字符串枚举有一个好处，那就是它们可以很好地 **"序列化"**。换句话说，如果你在调试时不得不读取一个数字枚举的运行时值，这个值往往是**不透明**的--它本身并不传达任何有用的意义（反向映射往往可以），字符串枚举允许你在代码运行时给出一个有意义的、可读的值，与枚举成员本身的名称无关。

## 3.3 异构枚举

从技术上讲，枚举可以与字符串和数字成员混合，但不清楚为什么你会想这样做：

```tsx
enum BooleanLikeHeterogeneousEnum {    No = 0,    Yes = "YES",}
```

除非你真的想以一种巧妙的方式利用JavaScript的运行时行为，否则建议你不要这样做。

## 3.4 计算型和常量型成员

每个枚举成员都有一个与之相关的值，可以是常量，也可以是计算值。一个枚举成员被认为是常数，如果：

- 它是枚举中的第一个成员，它没有初始化器，在这种情况下，它被赋值为 `0` ：

```tsx
// E.X is constant:enum E { X,}
```

- 它没有一个初始化器，而且前面的枚举成员是一个**数字常数**。在这种情况下，当前枚举成员的值将是**前一个枚举成员的值加 1** ：

```tsx
// 'E1'和'E2'中的所有枚举成员都是常数。enum E1 { X, Y, Z,}enum E2 { A = 1, B, C,}
```

枚举成员用一个常量枚举表达式进行初始化。常量枚举表达式是TypeScript表达式的一个子集，可以在编译时进行完全评估。一个表达式是一个常量枚举表达式，如果它是:

1. 枚举表达式的字面意思（基本上是一个字符串字面量或一个数字字面量）；
2. 对先前定义的常量枚举成员的引用（可以来自不同的枚举）；
3. 一个括号内的常量枚举表达式；
4. 应用于常量枚举表达式的 `+` , `-` , `~` 单项运算符之一 ；
5. `+`, `-` , `*` , `/` , `%` , `<<` , `>>` , `&` , `|` , `^` 以常量枚举表达式为操作数的二元运算符。

如果常量枚举表达式被评估为 `NaN` 或 `Infinity` ，这是一个编译时错误。

在所有其他情况下，枚举成员被认为是计算出来的。

```tsx
enum FileAccess {    // 常量成员    None,    Read = 1 << 1,    Write = 1 << 2,    ReadWrite = Read | Write,    // 计算成员    G = "123".length,}
```

## 3.5 联合枚举和枚举成员类型

有一个特殊的常量枚举成员的子集没有被计算：**字面枚举成员**。字面枚举成员是一个没有初始化值的常量枚举成员，或者其值被初始化为：

- 任何字符串（例如： `"foo"` , `"bar"` , `"baz"` ）
- 任何数字字头（例如： 1 ， 100）
- 应用于任何数字字面的单数减号（例如： -1 ， -100 ）

当一个枚举中的所有成员都有**枚举的字面价值**时，一些特殊的语义就会发挥作用。

首先，枚举成员也成为了类型。例如，我们可以说某些成员只能有一个枚举成员的值：

```tsx
enum ShapeKind {    Circle,    Square,}interface Circle {    kind: ShapeKind.Circle;    radius: number;}interface Square {    kind: ShapeKind.Square;    sideLength: number;}let c: Circle = {    kind: ShapeKind.Square,    // Ⓧ 类型 'ShapeKind.Square' 不能被分配给类型 'ShapeKind.Circle'    radius: 100,}
```

另一个变化是枚举类型本身有效地成为每个枚举成员的联盟。通过联合枚举，类型系统能够利用这一事实，即**它知道存在于枚举本身的精确的值集**。正因为如此，TypeScript可以捕捉到我们可能错误地比较数值的错误。比如说：

```tsx
enum E {    Foo,    Bar,}function f(x: E) {    if (x !== E.Foo || x !== E.Bar) {        // Ⓧ 这个条件将总是返回'true'，因为'E.Foo'和'E.Bar'的类型没有重合。        //...    }}
```

在这个例子中，我们首先检查了 `x` 是否不是 `E.Foo` 。如果这个检查成功了，那么我们的 `||` 就会短 路， `if` 语句的主体就会运行。然而，如果检查没有成功，那么 x 就只能是 `E.Foo` ，所以看它是否等于 `E.Bar` 就没有意义了。

## 3.6 运行时的枚举

枚举是在运行时存在的**真实对象**。例如，下面这个枚举

```tsx
enum E {    X,    Y,    Z,}
```

实际上可以被传递给函数:

```tsx
enum E {    X,    Y,    Z,}function f(obj: { X: number }) {    return obj.X;} // 可以正常工作，因为'E'有一个名为'X'的属性，是一个数字。f(E);
```

## 3.7 编译时的枚举

尽管`Enum`是在运行时存在的真实对象， `keyof` 关键字的工作方式与你对对象的预期不同。相反，使用`keyof` `typeof`来获得一个将所有`Enum`键表示为**字符串**的类型。

```tsx
enum LogLevel {    ERROR,    WARN,    INFO,    DEBUG,}/*** 这相当于:* type LogLevelStrings = 'ERROR' | 'WARN' | 'INFO' | 'DEBUG';*/type LogLevelStrings = keyof typeof LogLevel;function printImportant(key: LogLevelStrings, message: string) {    const num = LogLevel[key];    if (num <= LogLevel.WARN) {        console.log("Log level key is:", key);        console.log("Log level value is:", num);        console.log("Log level message is:", message);    }}printImportant("ERROR", "This is a message");
```

- 反向映射

除了**为成员创建一个带有属性名称的对象**外，数字枚举的成员还可以**得到从枚举值到枚举名称的反向映射**。例如，在这个例子中：

```tsx
enum Enum {    A,}let a = Enum.A;let nameOfA = Enum[a]; // "A" 
```

TypeScript将其编译为以下的JavaScript：

```tsx
"use strict";var Enum;(function (Enum) {    Enum[Enum["A"] = 0] = "A";})(Enum || (Enum = {}));let a = Enum.A;let nameOfA = Enum[a]; // "A"
```

在这段生成的代码中，一个枚举被编译成一个对象，它同时存储了正向 `( name -> value )`和反向 `( value -> name )` 的映射关系。对其他枚举成员的引用总是以属性访问的方式发出，而且从不内联。

请记住，字符串枚举成员根本不会被生成反向映射。

- `const`枚举

在大多数情况下，枚举是一个完全有效的解决方案。然而有时要求比较严格。为了**避免在访问枚举值时支付额外的生成代码和额外的间接性的代价**，可以使用 `const` 枚举。常量枚举是使用我们枚举上的 `const` 修饰符来定义的。

```tsx
const enum Enum {    A = 1,    B = A * 2,}
```

常量枚举只能使用常量枚举表达式，与普通枚举不同，它们在编译过程中被完全删除。常量枚举成员在使用地点被内联。这是可能的，因为常量枚举不能有计算的成员。

```tsx
const enum Direction {Up,Down,Left,Right,}let directions = [Direction.Up,Direction.Down,Direction.Left,Direction.Right,];
```

在生成的代码中，将变成：

```js
"use strict";let directions = [    0 /* Up */ ,    1 /* Down */ ,    2 /* Left */ ,    3 /* Right */ ,];
```

## 3.8 环境枚举

环境枚举是用来描述已经存在的枚举类型的形状。

```tsx
declare enum Enum {A = 1,B,C = 2,}
```

环境枚举和非环境枚举之间的一个重要区别是，在常规枚举中，如果其前面的枚举成员被认为是常量，那么没有初始化器的成员将被认为是常量。相反，一个**没有初始化器的环境**（和**非常量**）枚举成员总是被认为是计算的。

## 3.9 对象与枚举

在现代TypeScript中，你可能不需要一个枚举，因为一个对象的常量就足够了：

```tsx
const enum EDirection {    Up,    Down,    Left,    Right,}const ODirection = {    Up: 0,    Down: 1,    Left: 2,    Right: 3,} as const; // (enum member) EDirection.Up = 0EDirection.Up; // (property) Up: 0ODirection.Up; // 将枚举作为一个参数function walk(dir: EDirection) {} // 它需要一个额外的行来拉出数值type Direction = typeof ODirection[keyof typeof ODirection];function run(dir: Direction) {} walk(EDirection.Left);run(ODirection.Right);
```

与TypeScript的枚举相比，支持这种格式的最大理由是，它使你的代码库与JavaScript的状态保持一致， `when/if` 枚举被添加到JavaScript中，那么你可以转移到额外的语法。

# TypeScript学习高级篇第四章：公共类型

TypeScript 提供了几个实用类型，以促进常见的类型转换。这些实用程序在全局范围内可用。“

## 4.1 `Partial<Type>`

构建一个类型，将 `Type` 的所有属性设置为可选。这个工具将返回一个表示给定类型的所有子集的类型。

**例子：**

```tsx
interface Todo {    title: string;    description: string;} function updateTodo(todo: Todo, fieldsToUpdate: Partial<Todo>) {    return { ...todo, ...fieldsToUpdate };} const todo1:Todo = {    title: "organize desk",    description: "clear clutter",}; //因为可以将所有属性设置为可选，可选如果不设置即为undefined，所以拿此来测试const todo2:Partial<Todo> = updateTodo(todo1, {    description: undefined,})
```

## 4.2 `Required<Type>`

构建一个由 `Type` 的所有属性组成的类型，设置为必填。与 `Partial` 相反：

```tsx
interface Props {    a?: number;    b?: string;}const obj: Props = { a: 5 };// error,类型 "{ a: number; }" 中缺少属性 "b"，但类型 "Required<Props>" 中需要该属性const obj2: Required<Props> = { a: 5 };
```

## 4.3 `Readonly<Type>`

构建一个类型， `Type` 的所有属性设置为 `readonly` ，这意味着构建的类型的属性不能被重新设置值。

```tsx
interface Todo {title: string;}const todo: Readonly<Todo> = {title: "Delete inactive users",}; // errortodo.title = "Hello";
```

这个工具对于表示将在运行时失败的赋值表达式很有用（即当试图重新分配一个[冻结对象](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Object/freeze)的属性时）。

```tsx
function freeze<Type>(obj: Type): Readonly<Type>;
```

## 4.4 `Record<Keys,Type>`

构建一个对象类型，其属性键是 Keys ，其属性值是 Type 。这个工具可以用来将一个类型的属性映射到另一个类型:

```tsx
interface CatInfo {    age: number;    breed: string;}type CatName = "miffy" | "boris" | "mordred";const cats: Record<CatName, CatInfo> = {    miffy: { age: 10, breed: "Persian" },    boris: { age: 5, breed: "Maine Coon" },    mordred: { age: 16, breed: "British Shorthair" },}; // const cats: Record<CatName, CatInfo>console.log(cats.boris) // { age: 5, breed: 'Maine Coon' }
```

## 4.5 `Pick<Type, Keys>`

通过从 Type 中选取属性集合 Keys （属性名或属性名的联合）来构造一个类型:

```tsx
interface Todo {    title: string;    description: string;    completed: boolean;} type TodoPreview = Pick<Todo, "title" | "completed">;const todo: TodoPreview = {    title: "Clean room",    completed: false,}; // const todo: TodoPreviewtodo;
```

## 4.6 `Omit<Type, Keys>`

通过从 `Type` 中选取所有属性，然后删除`Keys`（属性名或属性名的联合）来构造一个类型。

```tsx
interface Todo {    title: string;    description: string;    completed: boolean;    createdAt: number;}type TodoPreview = Omit<Todo, "description">;const todo: TodoPreview = {    title: "Clean room",    completed: false,    createdAt: 1615544252770,};// const todo: TodoPreviewtodo; type TodoInfo = Omit<Todo, "completed" | "createdAt">;const todoInfo: TodoInfo = {    title: "Pick up kids",    description: "Kindergarten closes at 5pm",};// const todoInfo: TodoInfotodoInfo;
```

## 4.7 `Exclude<Type, ExcludedUnion>`

通过从 `Type` 中排除所有可分配给 `ExcludedUnion` 的联盟成员来构造一个类型。

```tsx
// type T0 = "b" | "c"type T0 = Exclude<"a" | "b" | "c", "a">; // type T1 = "c"type T1 = Exclude<"a" | "b" | "c", "a" | "b">; // type T2 = string | numbertype T2 = Exclude<string | number | (() => void), Function>;
```

## 4.8 `Extract<Type, Union>`

通过从 `Type` 中提取可分配给 `Union` 的所有 `union` 成员，构造一个类型。

```tsx
// type T0 = "a"type T0 = Extract<"a" | "b" | "c", "a" | "f"> // type T1 = () => voidtype T1 = Extract<string | number | (() => void), Function>
```

## 4.9 `NonNullable`

通过从 Type 中排除 null 和 undefined 来构造一个类型。

```tsx
// type T0 = string | numbertype T0 = NonNullable<string | number | undefined>; // type T1 = string[]type T1 = NonNullable<string[] | null | undefined>;
```

## 4.10 `Parameters<Function Type>`

从一个函数类型 `Type` 的**参数**中使用的类型构建一个元组类型。

```tsx
declare function f1(arg: { a: number; b: string }): void;// type T0 = []type T0 = Parameters<() => string>;// type T1 = [s: string]type T1 = Parameters<(s: string) => void>;// type T2 = [arg: unknown]type T2 = Parameters<<T>(arg: T) => T>;/*type T3 = [arg: {a: number;b: string;}]*/type T3 = Parameters<typeof f1>;// type T4 = unknown[]type T4 = Parameters<any>;// type T5 = nevertype T5 = Parameters<never>;// type T6 = nevertype T6 = Parameters<string>;// type T7 = nevertype T7 = Parameters<Function>;
```

## 4.11 `ConstructorParameters`

从**构造函数**的类型中构造一个**元组**或**数组**类型。它产生一个具有所有参数类型的元组类型（如果 `Type` 不是一个函数，则为 `never` 类型)。

```tsx
// type T0 = [message?: string]type T0 = ConstructorParameters<ErrorConstructor>; // type T1 = string[]type T1 = ConstructorParameters<FunctionConstructor>; // type T2 = [pattern: string | RegExp, flags?: string]type T2 = ConstructorParameters<RegExpConstructor>; // type T3 = unknown[]type T3 = ConstructorParameters<any>; // type T4 = nevertype T4 = ConstructorParameters<Function>;
```

## 4.12 `ReturnType`

构建一个由函数 `Type` 的返回类型组成的类型。如果是泛型则是`unknown`。

```tsx
declare function f1(): { a: number; b: string };// type T0 = stringtype T0 = ReturnType<() => string>;// type T1 = voidtype T1 = ReturnType<(s: string) => void>;// type T2 = unknowntype T2 = ReturnType<<T>() => T>;// type T3 = number[]type T3 = ReturnType<<T extends U, U extends number[]>() => T>; /*type T4 = {    a: number;    b: string;}*/type T4 = ReturnType<typeof f1>;// type T5 = anytype T5 = ReturnType<any>;// type T6 = nevertype T6 = ReturnType<never>;// type T7 = any 报错type T7 = ReturnType<string>;// type T8 = any 报错type T8 = ReturnType<Function>
```

## 4.13 InstanceType

构建一个由 `Type` 中**构造函数的实例**类型组成的类型。

```tsx
class C {	x = 0;	y = 0;}// type T0 = Ctype T0 = InstanceType<typeof C>;// type T1 = anytype T1 = InstanceType<any>;// type T2 = nevertype T2 = InstanceType<never>;// type T3 = anytype T3 = InstanceType<string>;// type T4 = anytype T4 = InstanceType<Function>;
```

## 4.14 ThisParameterType

提取一个函数类型的 `this` 参数的类型，如果该函数类型没有 `this` 参数，则为 `unknown` 。

```tsx
function toHex(this: Number) {	return this.toString(16);}// n: numberfunction numberToString(n: ThisParameterType<typeof toHex>) {	return toHex.apply(n);}
```

## 4.15 OmitThisParameter

移除 `Type` 的 `this` 参数。如果 `Type` 没有明确声明的 `this` 参数，结果只是 `Type` 。否则，一个没有 `this` 参数的新函数类型将从 `Type` 创建。泛型被擦除，只有最后的重载签名被传播到新的函数类型。

```tsx
function toHex(this: Number) {	return this.toString(16);} const fiveToHex: OmitThisParameter<typeof toHex> = toHex.bind(5);console.log(fiveToHex());
```

## 4.16 ThisType

这个工具并不返回一个转换后的类型。相反，**它作为一个上下文的 `this` 类型的标记**。注意，**必须启用**`noImplicitThis` 标志才能使用这个工具。

ts类型中的&表示交叉类型, 主要用于**组合现有的对象类型**。

```tsx
type ObjectDescriptor<D, M> = {    data?: D;    methods?: M & ThisType<D & M>; // 方法中的 'this' 类型是 D & M}; function makeObject<D, M>(desc: ObjectDescriptor<D, M>): D & M {    let data: object = desc.data || {};    let methods: object = desc.methods || {};    return { ...data, ...methods } as D & M;}let obj = makeObject({    data: { x: 0, y: 0 },    methods: {        moveBy(dx: number, dy: number) {            this.x += dx;            this.y += dy;        },    },});obj.x = 10;obj.y = 20;obj.moveBy(5, 5);
```

在上面的例子中，`makeObject`的参数中的 `methods` 对象有一个包括 `ThisType` 的上下文类型，因此方法对象中 `this` 的类型是 `{ x: number, y: number } & { moveBy(dx: number, dy: number): number }` 。注意 methods 属性的类型如何同时是推理目标和方法中 this 类型的来源。 ThisType 标记接口只是在 lib.d.ts 中声明的一个空接口。除了在对象字面的上下文类型中被识别之外，该接口的行为与任何空接口一样。

## 4.17 字符串操作类型

```tsx
Uppercase<StringType>Lowercase<StringType>Capitalize<StringType>Uncapitalize<StringType>            
```

TypeScript包括一组类型，可以在类型系统中用于字符串操作。你可以在 [Template Literal Types](https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html#uppercasestringtype) 文档 中找到这些工具的用法。

# TypeScript学习高级篇第五章：Symbols

从`ECMAScript 2015（ES6）`开始， `symbol` 是一种原始的数据类型，就像 `number` 和 `string` 一样。

`symbol`值是通过调用`Symbol`构造函数创建的。

```tsx
let sym1 = Symbol();let sym2 = Symbol("key"); // 可选的字符串 key
```

Symbols 是不可改变的，而且是独一无二的。

```tsx
let sym2 = Symbol("key");let sym3 = Symbol("key");sym2 === sym3; // false, symbols 是唯一的
```

就像字符串一样，`Symbols`可以被用作对象属性的键。

```tsx
const sym = Symbol();let obj = {    [sym]: "value",};console.log(obj[sym]); // "value"
```

`Symbols`也可以与计算属性声明结合起来，以声明**对象属性**和**类成员**。

```tsx
const getClassNameSymbol = Symbol();class C {    [getClassNameSymbol]() {        return "C";    }}let c = new C();let className = c[getClassNameSymbol](); // "C"
```

## 5.1 `unique symbol`

为了能够将 `symbols` 作为唯一的字面符号，提供了一个特殊的类型 `unique symbol` 。 `unique symbol` 是 `symbol` 的一个子类型，只在调用 `Symbol()` 或 `Symbol.for()` 或**明确的类型注释**时产生。这种类型只允许在**常量声明**和**只读静态属性**中使用，为了引用一个特定的唯一符号，你必须使用`typeof`操作符。每个对唯一符号的引用都意味着一个完全独特的身份，它与一个给定的声明相联系。

```tsx
declare const sym1: unique symbol;// sym2只能是一个常数参考。let sym2: unique symbol = Symbol();// Ⓧ 类型为 "唯一符号 "的变量必须是 "const"类型。 // 运行正确--指的是一个独特的 symbol，但其身份与'sym1'相联系。let sym3: typeof sym1 = sym1; // 也是正确的class C {    static readonly StaticSymbol: unique symbol = Symbol();}
```

因为每个 `unique symbol` 都有一个完全独立的身份，没有两个 `unique symbol` 类型是可以**相互分配**或**比较**的。

```tsx
const sym2 = Symbol();const sym3 = Symbol(); // 这个条件将总是返回'false'，因为'typeof sym2'和'typeof sym3'的类型没有重合。if (sym2 === sym3) {	// ...}
```

## 5.2 知名的 Symbols

除了用户定义的 `symbols` 外，还有著名的内置 `symbols`。内置符号被用来表示内部语言行为。

下面是一个著名的 `symbols` 列表：

### 5.2.1 Symbol.hasInstance

一个**确定构造函数对象**，是否识别一个对象为构造函数的实例之一的方法。由`instanceof`操作符的语义调用。

### 5.2.2 Symbol.isConcatSpreadable

一个布尔值，表示一个对象应该被`Array.prototype.concat`平铺到其数组元素。

### 5.2.3 Symbol.iterator

返回一个对象的默认迭代器的方法。被 `for-of` 语句的语义所调用。

### 5.2.4 Symbol.match

一个正则表达式方法，与字符串的正则表达式相匹配。由 `String.prototype.match` 方法调用。

### 5.2.5 Symbol.replace

一个正则表达式方法，用于替换一个字符串中匹配的子串。由 `String.prototype.replace` 方法调用。

### 5.2.6 Symbol.search

一个正则表达式方法，返回字符串中符合正则表达式的索引。由 `String.prototype.search` 方法调用。

### 5.2.7 Symbol.species

一个函数值的属性，是用于创建派生对象的构造函数。

### 5.2.8 Symbol.split

一个正则表达式方法，在符合正则表达式的索引处分割一个字符串。由 `String.prototype.split` 方法调用。

### 5.2.9 Symbol.toPrimitive

将一个对象转换为一个相应的基元值的方法。由`ToPrimitive`抽象操作调用。

### 5.2.10 Symbol.toStringTag

一个字符串值，用于创建一个对象的默认字符串描述。由内置方法 `Object.prototype.toString` 调用。

### 5.2.11 Symbol.unscopables

一个对象，其自身的属性名是被排除在相关对象的 'with' 环境绑定之外的属性名。

# TypeScript学习高级篇第六章：类型兼容性

TypeScript中的类型兼容性是基于**结构子类型**的。结构分型是一种完全基于其成员的类型关系的方式。

这与名义类型不同。考虑一下下面的代码：

```tsx
interface Pet {    name: string;} class Dog {    name: string;} let pet: Pet;// 正确，因为结构化类型pet = new Dog();
```

在像 `C#` 或 `Java` 这样的名义类型语言中，相应的代码将是一个错误，**因为 `Dog` 类没有明确地描述自己是 `Pet` 接口的实现者**。

TypeScript的**结构类型系统**是根据JavaScript代码的典型写法设计的。因为JavaScript**广泛使用匿名对象**，如**函数表达式**和**对象字面量**，用**结构类型系统**而不是命名类型系统来表示JavaScript库中的各种关系要自然得多。

## 6.1 关于健全性的说明

TypeScript 的类型系统允许某些在编译时无法知道的操作是安全的。当一个类型系统具有这种属性时， 它被称为不 "健全"。我们仔细考虑了 TypeScript 允许不健全行为的地方，在这篇文档中，我们将解释这 些发生的地方以及它们背后的动机情景。

## 6.2 起步

TypeScript的结构类型系统的基本规则是，如果 `y` 至少有与 `x` 相同的成员，那么 `x` 与 `y` 是兼容的。wwww

```tsx
interface Pet {    name: string;}let pet: Pet;// dog's 推断类型是 { name: string; owner: string; }let dog = { name: "Lassie", owner: "Rudd Weatherwax" };pet = dog
```

为了检查 `dog` 是否可以被分配给 `pet` ，编译器检查 `pet` 的每个属性，以找到 `dog` 中相应的兼容属 性。在这种情况下， `dog` 必须有一个名为 `name` 的成员，它是一个字符串。它有，所以赋值是允许的。

在检查函数调用参数时，也使用了同样的赋值规则。

```tsx
interface Pet {    name: string;}let dog = { name: "Lassie", owner: "Rudd Weatherwax" };function greet(pet: Pet) {    console.log("Hello, " + pet.name);}greet(dog); // 正确
```

请注意， `dog` 有一个额外的 `owner` 属性，但这并不产生错误。在检查兼容性时，只考虑目标类型（本例中为 `Pet`）的成员。

这个比较过程是**递归**进行的，探索每个成员和子成员的类型。

## 6.3 对比两个函数

虽然比较原始类型和对象类型是相对直接的，但什么样的函数应该被认为是兼容的，这个问题就有点复杂了。让我们从两个函数的基本例子开始，这两个函数只在参数列表上有所不同：

```tsx
let x = (a: number) => 0;let y = (b: number, s: string) => 0;y = x; // 正确x = y; // 错误
```

为了检查 `x` 是否可以分配给 `y` ，我们首先看一下参数列表。 `x` 中的每个参数在 `y` 中都必须有一个类型兼容的对应参数。注意，参数的名称不被考虑，只考虑它们的类型。在这种情况下， `x` 中的每个参数在`y`中都有一个对应的兼容参数，所以这个赋值是允许的。

第二个赋值是一个错误，因为 `y` 有一个 `x` 没有的必要的第二个参数，所以这个赋值是不允许的。

你可能想知道为什么我们允许像例子中的 `y = x` 那样 "丢弃 "参数。这个赋值被允许的原因是，忽略额外的函数参数在JavaScript中其实很常见。例如， `Array#forEach` 为回调函数提供了三个参数：数组元素、其索引和包含数组。尽管如此，提供一个只使用第一个参数的回调是非常有用的：

```tsx
let items = [1, 2, 3];// 不要强迫这些额外参数items.forEach((item, index, array) => console.log(item));// 应该没有问题!items.forEach((item) => console.log(item));
```

现在让我们看看如何处理返回类型，使用两个只因返回类型不同的函数：

```tsx
let x = () => ({ name: "Alice" });let y = () => ({ name: "Alice", location: "Seattle" });x = y; // 正确y = x; // 错误，因为x()缺少一个location属性
```

类型系统强制要求**源函数的返回类型**是**目标类型的返回类型**的一个**子类型**。

## 6.4 函数参数的双差性

```tsx
enum EventType {    Mouse,    Keyboard,}interface Event {    timestamp: number;}interface MyMouseEvent extends Event {    x: number;    y: number;}interface MyKeyEvent extends Event {    keyCode: number;}function listenEvent(eventType: EventType, handler: (n: Event) => void) {    /* ... */}// 不健全，但有用且常见listenEvent(EventType.Mouse, (e: MyMouseEvent) => console.log(e.x + "," + e.y));// 在健全性存在的情况下，不可取的选择listenEvent(EventType.Mouse, (e: Event) =>            console.log((e as MyMouseEvent).x + "," + (e as MyMouseEvent).y)           );listenEvent(EventType.Mouse, ((e: MyMouseEvent) =>                              console.log(e.x + "," + e.y)) as (e: Event) => void);// 仍然不允许（明确的错误）。对于完全不兼容的类型强制执行类型安全listenEvent(EventType.Mouse, (e: number) => console.log(e));
```

当这种情况发生时，你可以让TypeScript通过编译器标志 `strictFunctionTypes` 引发错误。

## 6.5 可选参数和其他参数

在比较函数的兼容性时，**可选参数**和**必需参数**是可以互换的。源类型的额外可选参数不是错误，而目标类型的可选参数在源类型中没有对应的参数也不是错误。

当一个函数有一个**剩余参数**时，它被当作是**一个无限的可选参数系列**。

从类型系统的角度来看，这是不健全的，但从运行时的角度来看，可选参数的概念一般不会得到很好的加强，因为在这个位置传递 `undefined` 的参数对大多数函数来说是等价的。

激励性的例子是一个函数的常见模式，它接受一个回调，并用一些可预测的（对程序员）但未知的（对类型系统）参数数量来调用它。

```tsx
function invokeLater(args: any[], callback: (...args: any[]) => void) {    /* ... 用'args'调用回调 ... */}// 不健全 - invokeLater "可能 "提供任何数量的参数invokeLater([1, 2], (x, y) => console.log(x + ", " + y));// 令人困惑的是（x和y实际上是需要的），而且是无法发现的invokeLater([1, 2], (x?, y?) => console.log(x + ", " + y));
```

## 6.6 带有重载的函数

当一个函数有重载时，源类型中的每个重载必须由目标类型上的兼容签名来匹配。这保证了目标函数可以在所有与源函数相同的情况下被调用。

## 6.7 枚举

**枚举与数字兼容，而数字与枚举兼容**。来自不同枚举类型的枚举值被认为是不兼容的。比如说:

```tsx
enum Status {    Ready,    Waiting,} enum Color {    Red,    Blue,    Green,} let status = Status.Ready;status = Color.Green; // 错误
```

## 6.8 类

类的工作方式与对象字面类型和接口类似，但有一个例外：它们同时具有静态和实例类型。当比较一个类类型的两个对象时，只有实例的成员被比较。**静态成员和构造函数不影响兼容性**。

```tsx
class Animal {    feet: number;    constructor(name: string, numFeet: number) {}}class Size {    feet: number;    constructor(numFeet: number) {}}let a: Animal;let s: Size;a = s; // 正确s = a; // 正确
```

## 6.9 类中的私有和受保护成员

一个类中的私有成员和保护成员会影响其兼容性。当一个类的实例被检查兼容性时，如果目标类型包含一个私有成员，那么源类型也必须包含一个源自同一类的私有成员。同样地，这也适用于有保护成员的实例。这**允许一个类与它的超类进行赋值兼容**，但不允许与来自不同继承层次的类进行赋值兼容，否则就会有相同的形状。

## 6.10 泛型

因为TypeScript是一个结构化的类型系统，类型参数只在作为成员类型的一部分被消耗时影响到结果类型。比如说：

```tsx
interface Empty<T> {}let x: Empty<number>;let y: Empty<string>;x = y; // 正确，因为y符合x的结构
```

在上面， `x` 和 `y` 是兼容的，因为它们的结构没有以区分的方式使用类型参数。通过给 `Empty` 增加一个成员来改变这个例子，显示了这是如何工作的。

```tsx
interface NotEmpty<T> {data: T;}let x: NotEmpty<number>;let y: NotEmpty<string>;x = y; // 错误，因为x和y不兼容
```

这样一来，一个指定了类型参数的泛型类型就像一个非泛型类型一样。

对于**没有指定类型参数的泛型**，兼容性的检查是通过**指定any来代替所有未指定的类型参数**。然后**产生的类型被检查是否兼容**，就像在非泛型的情况下一样。

比如说:

```tsx
let identity = function <T>(x: T): T {    // ...};let reverse = function <U>(y: U): U {    // ...};identity = reverse; // 正确, 因为 (x: any) => any 匹配 (y: any) => any
```

## 6.11 子类型与赋值

到目前为止，我们已经使用了 "兼容"，这并不是语言规范中定义的一个术语。在TypeScript中，有两种兼容性：**子类型**和**赋值**。这些不同之处只在于，赋值扩展了子类型的兼容性，允许赋值到 `any` ，以及赋值到具有相应数值的 `enum` 。

语言中不同的地方使用这两种兼容性机制中的一种，取决于情况。在实际应用中，类型兼容性是由**赋值兼容性**决定的，即使是在 `implements` 和 `extends` 子句中。

## 6.12 `any` ,`unknown` ,`object` ,`void` ,`undefined` ,`null` , 和 `never`可分配性

下表总结了一些抽象类型之间的可分配性。行表示每个类型可被分配到什么，列表示什么可被分配到它们。"✓"表示只有在关闭 `strictNullChecks` 时才是兼容的组合

||any|unknown|object|void|undefined|null|never|
|---|---|---|---|---|---|---|---|
|any||✓|✓|✓|✓|✓|✕|
|unknown|✓||✕|✕|✕|✕|✕|
|object|✓|✓||✕|✕|✕|✕|
|void|✓|✓|✕||✕|✕|✕|
|undefined|✓|✓|✓|✓||✓|✕|
|null|✓|✓|✓|✓|✓||✕|
|never|✓|✓|✓|✓|✓|✓||

- 所有的东西都是可以分配给自己的。
- `any` 和 `unknown` 在可分配的内容方面是相同的，不同的是 `unknown` 不能分配给任何东西，除了 `any`。
- `unknown` 和 `never` 就像是彼此的反义词。一切都可以分配给 `unknown` , `never` 就可以分配给一切。没有任何东西可以分配给 `never` ， `unknown` 不能分配给任何东西（除了 `any` ）。
- `void` 不能赋值给任何东西，以下是例外情况： `any` 、 `unknown` 、 `never` 、 `undefined` 和 `null`（如果 `strictNullChecks` 是关闭的，详见表）。
- 当 `strictNullChecks` 关闭时， `null` 和 `undefined` 与 `never` 类似：可赋值给大多数类型，大多数类型不可赋值给它们。它们可以互相赋值。
- 当 `strictNullChecks` 打开时， `null` 和 `undefined` 的行为更像 `void` ：除了 `any` 、 `unknown` 、 `never` 和 `void` 之外，不能赋值给任何东西（ `undefined` 总是可以赋值给 `void` ）。

# TypeScript学习高级篇第七章：迭代器和生成

## 7.1 遍历

如果一个对象有 `Symbol.iterator` 属性的实现，它就被认为是可迭代的。一些内置类型，如 `Array` 、 `Map` 、 `Set` 、 `String` 、 `Int32Array` 、 `Uint32Array` 等，已经实现了它们的 `Symbol.iterator` 属性。对象上的 `Symbol.iterato`r 函数负责返回要迭代的值的列表。

### 7.1.1 `Iterable`接口

`Iterable`是一个我们可以使用的类型，如果我们想接收上面列出的可迭代的类型。下面是一个例子：

```tsx
// 传入的参数必须是可迭代的类型function toArray<X>(xs: Iterable<X>): X[] {	return [...xs]}
```

### 7.1.2 `for ... of`声明

`for... of` 在一个可迭代对象上循环，调用对象上的 `Symbol.iterator` 属性。下面是一个关于数组的简单 `for... of` 循环。

```tsx
let someArray = [1, "string", false];for (let entry of someArray) {	console.log(entry); // 1, "string", false}
```

### 7.1.3 `for ... of`与`for ... in` 声明

`for...of` 和 `for...in` 语句都是在列表上进行迭代；但迭代的值是不同的， `for...in` 返回被迭代对象的**键值列表**，而 `for...of` 返回被迭代对象的**数字属性值列表**。 这里有一个例子可以证明这种区别:

```tsx
let list = [4, 5, 6];for (let i in list) {    console.log(i); // "0", "1", "2",}for (let i of list) {    console.log(i); // 4, 5, 6}
```

另一个区别是 `for...in` 对任何对象进行操作；它作为一种检查该对象上的属性的方法。另一方面，`for...of` 主要对可迭代对象的值感兴趣。像 `Map` 和 `Set` 这样的内置对象实现了 `Symbol.iterator` 属性，允许访问存储的值。

```tsx
// Set中的Iterablelet pets = new Set(["Cat", "Dog", "Hamster"]);for (let pet in pets) {    console.log(pet); // 什么也不输出}for (let pet of pets) {    console.log(pet); // "Cat", "Dog", "Hamster"}// Map中的Iterablelet nums = new Map([    [1, 'one'],    [2, 'two'],    [3, 'three'],])for (let num in nums) {    console.log(num) // 什么也不输出} for (let num of nums) {    console.log(num) //[ 1, 'one' ]  [ 2, 'two' ]  [ 3, 'three' ]}
```

## 7.2 代码生成

### 7.2.1 生成目标 ES5 和 ES3

当针对ES5或ES3兼容的引擎时，迭代器只允许在 `Array` 类型的值上使用。

在非数组值上使用 `for...of` 循环是一个错误，即使这些非数组值实现了 `Symbol.iterator` 属性。

例如，编译器将为 `for...` 的循环生成一个简单的 `for` 循环。

```tsx
let numbers = [1, 2, 3];for (let num of numbers) {console.log(num);}
```

将被生成为：

```tsx
var numbers = [1, 2, 3];for (var _i = 0; _i < numbers.length; _i++) {    var num = numbers[_i];    console.log(num);}
```

### 7.2.2 ECMAScript 2015(ES6) 和 更高版本

当针对ECMAScipt 2015兼容的引擎时，编译器将生成 `for...of` 循环，以针对引擎中的内置迭代器实 现。

# TypeScript学习高级篇第八章：装饰器(Decorators)

## 8.1 简介

随着TypeScript和ES6中类的引入，现在存在某些场景需要额外的功能，来支持**注释或修改类和类成员**。 装饰器提供了一种**为类声明和成员添加注释和元编程语法**的方法。装饰器是JavaScript的第二阶段建议，并作为TypeScript的一个实验性功能提供。

> 注意：装饰器是一个实验性的功能，在未来的版本中可能会改变。

要启用对装饰器的实验性支持，你必须在命令行或在 `tsconfig.json` 中启用`experimentalDecorators` 编译器选项。

- 命令行开启

```css
tsc --target ES5 --experimentalDecorators
```

- tsconfig.json

```json
{    "compilerOptions": {        "target": "ES5",        "experimentalDecorators": true    }}
```

## 8.2 装饰器

装饰器是一种特殊的声明，可以附加到类**声明**、**方法**、**访问器**、**属性或参数**上。装饰器使用 `@expression` 的形式，其中 `expression` 必须评估为一个函数，**该函数将在运行时被调用，并带有关于被装饰的声明的信息**。

例如，对于装饰器 `@sealed` ，我们可以将 `sealed` 的函数写成如下:

```tsx
function sealed(target) {	// 对 "target"做一些事情 ...}
```

## 8.3 装饰器工厂

如果我们想自定义装饰器如何应用于声明，我们可以写一个装饰器工厂。装饰器工厂是一个简单的函数，它返回将在运行时被装饰器调用的表达式。

我们可以用以下方式写一个装饰器工厂：

```tsx
function color(value: string) {    // 这是装饰器工厂，它设置了    // 返回的装饰器函数    return function (target) {        // 这就是装饰器        // 用 "target" 和 "value"做一些事情...    };}
```

## 8.4 装饰器构成

多个装饰器可以应用于一个声明，例如在一行中：

```tsx
@f @g x
```

多行的语法：

```tsx
@f@gx
```

当多个装饰器适用于一个声明时，它们的评估类似于数学中的[函数组合](https://wikipedia.org/wiki/Function_composition)。在这种模式下，当组合函数f和g时，所产生的组合 `(f(g))(x)` 等同于 `f(g(x))` 。

因此，在TypeScript中对一个声明的多个装饰器进行评估时，会执行以下步骤：

1. 每个装饰器的表达式都是自上而下地进行评估的。
2. 然后将结果作为函数从下往上调用。

如果我们使用装饰器工厂，可以通过下面的例子观察这个评估顺序：

```tsx
function first() {    console.log("first(): factory evaluated");    return function (target: any, propertyKey: string, descriptor: PropertyDescriptor) {        console.log("first(): called");    };} function second() {    console.log("second(): factory evaluated");    return function (target: any, propertyKey: string, descriptor: PropertyDescriptor) {        console.log("second(): called");    };} class ExampleClass {    @first()    @second()    method() {}}
```

这将把这个输出打印到控制台：

```tsx
first(): factory evaluatedsecond(): factory evaluatedsecond(): calledfirst(): called
```

## 8.5 装饰器评估

对于应用于类内各种声明的装饰器，有一个明确的顺序：

1. 对于每个实例成员，首先是参数装饰器，然后是方法、访问器或属性装饰器。
2. 对于每个静态成员，先是参数装饰器，然后是方法、存取器或属性装饰器。
3. 参数装饰器被应用于构造函数。
4. 类装饰器适用于类。

## 8.6 类装饰器

类装饰器就在类声明之前被声明。类装饰器被应用于类的构造函数，可以用来观察、修改或替换类定义。类装饰器不能在声明文件中使用，也不能在任何其他环境下使用（比如在 `declare` 类上）。

类装饰器的表达式在运行时将作为一个函数被调用，被装饰的类的构造器是它唯一的参数。

如果类装饰器返回一个值，它将用提供的构造函数替换类声明。

> 注意：如果你选择返回一个新的构造函数，必须注意维护原始原型。在运行时应用装饰器的逻辑不 会为你这样做。

下面是一个应用于 `BugReport` 类的类装饰器（ `@sealed` ）的例子。

```tsx
@sealedclass BugReport {    type = "report";    title: string;    constructor(t: string) {        this.title = t;}}
```

我们可以用下面的函数声明来定义`@sealed`装饰器

```tsx
// Object.seal()方法封闭一个对象，阻止添加新属性并将所有现有属性标记为不可配置。当前属性的值只要原来是可写的就可以改变。function sealed(constructor: Function) {    Object.seal(constructor);    Object.seal(constructor.prototype);}
```

当 `@sealed` 被执行时，它将同时封闭构造函数和它的原型，因此将阻止在运行时通过访问 `BugReport.prototype` 或通过定义 `BugReport` 本身的属性来向该类添加或删除任何进一步的功能（注意ES2015类实际上只是基于原型的构造函数的语法糖）。这个装饰器并不能阻止类对 `BugReport` 进行子类化。

接下来我们有一个如何覆盖构造函数以设置新的默认值的例子:

```tsx
function reportableClassDecorator<T extends { new (...args: any[]): {} }>(constructor: T){    return class extends constructor {        reportingURL = "http://www...";    };} @reportableClassDecoratorclass BugReport {    type = "report";    title: string;    constructor(t: string) {        this.title = t;    }} const bug = new BugReport("Needs dark mode");console.log(bug.title); // 打印 "Needs dark mode"console.log(bug.type); // 打印 "report"/*     BugReport {        type: 'report',        title: 'Needs dark mode',        reportingURL: 'http://www...'    } */console.log(bug)// 注意，装饰器不会改变TypeScript的类型// 因此，类型系统对新的属性`reportingURL`是不可知的。console.log(bug.reportingURL);  // Error,类型"BugReport"上不存在"reportingURL"
```

## 8.7 方法装饰器

方法装饰器就在方法声明之前被声明。该装饰器被应用于方法的属性描述符，可以用来观察、修改或替换方法定义。方法装饰器不能在声明文件中使用，不能在重载上使用，也不能在任何其他环境下使用（比如在 `declare` 类中）。

方法装饰器的表达式将在运行时作为一个函数被调用，有以下三个参数：

1. 静态成员的类的构造函数，或者实例成员的类的原型。
2. 成员的名称。
3. 该成员的属性描述符。

> 注意：如果你的脚本目标小于ES5，属性描述符将无法定义。

如果方法装饰器返回一个值，它将被用作方法的属性描述符

> 注意：如果你的脚本目标小于ES5，返回值会被忽略。

下面是一个方法装饰器（ `@enumerable` ）应用于 Greeter 类的一个方法的例子：

```tsx
class Greeter {    greeting: string;    constructor(message: string) {        this.greeting = message;    }    @enumerable(false)    greet() {        return "Hello, " + this.greeting;    }}
```

我们可以用下面的函数声明来定义 `@enumerable` 装饰器:

```tsx
function enumerable(value: boolean) {    return function (target: any, propertyKey: string, descriptor:PropertyDescriptor) {        descriptor.enumerable = value;    };}
```

这里的 `@enumerable(false)` 装饰器是一个 装饰器工厂。当 `@enumerable(false)` 装饰器被调用时，它修改了属性描述符的 `enumerable` 属性。

## 8.8 访问器装饰器

一个访问器装饰器就在访问器声明之前被声明。访问器装饰器被应用于访问器的属性描述符，可以用来观察、修改或替换访问器的定义。一个访问器装饰器不能在声明文件中使用，也不能在任何其他环境中使用（比如在 `declare` 类中）。

> 注意：TypeScript不允许装饰单个成员的 get 和 set 访问器。相反，该成员的所有装饰器必须应 用于文件顺序中指定的第一个访问器。这是因为装饰器适用于一个属性描述符，它结合了获取和设 置访问器，而不是每个声明单独。

访问器装饰器的表达式将在运行时作为一个函数被调用，有以下三个参数：

1. 静态成员的类的构造函数，或者实例成员的类的原型
2. 成员的名称。
3. 该成员的属性描述符。

> 注意：如果你的脚本目标小于ES5，属性描述符将无法定义

如果访问器装饰器返回一个值，它将被用作该成员的属性描述符。

> 注意：如果你的脚本目标小于ES5，返回值会被忽略。

下面是一个访问器装饰器（ `@configurable` ）的例子，它应用于 `Point` 类的一个成员。

```tsx
class Point {    private _x: number;    private _y: number;    constructor(x: number, y: number) {        this._x = x;        this._y = y;    }    @configurable(false)    get x() {        return this._x;    }    @configurable(false)    get y() {        return this._y;    }}
```

我们可以用下面的函数声明来定义 `@configurable` 装饰器:

```tsx
function configurable(value: boolean) {    return function (target: any, propertyKey: string, descriptor:PropertyDescriptor) {        descriptor.configurable = value;    };}
```

## 8.9 属性装饰器

一个属性装饰器就在一个属性声明之前被声明。一个属性装饰器不能在声明文件中使用，也不能在任何 其他环境下使用（比如在 declare 类中）。

属性装饰器的表达式将在运行时作为一个函数被调用，有以下两个参数：

1. 静态成员的类的构造函数，或者实例成员的类的原型。
2. 成员的名称。

> 注意：由于属性装饰器在TypeScript中的初始化方式，属性描述符不会作为参数提供给属性装饰器。这是因为目前没有机制在定义原型成员时描述一个实例属性，也没有办法观察或修改一个属性的初始化器。返回值也被忽略了。因此，一个属性装饰器只能用来观察一个类的特定名称的属性已经被声明。

我们可以使用这些信息来记录关于该属性的元数据，如下面的例子:

```tsx
class Greeter {    @format("Hello, %s")    greeting: string;    constructor(message: string) {        this.greeting = message;    }    greet() {        let formatString = getFormat(this, "greeting");        return formatString.replace("%s", this.greeting);    }}
```

然后我们可以使用以下函数声明来定义 `@format` 装饰器和 `getFormat` 函数。

```tsx
import "reflect-metadata";const formatMetadataKey = Symbol("format");function format(formatString: string) {    return Reflect.metadata(formatMetadataKey, formatString);}function getFormat(target: any, propertyKey: string) {    return Reflect.getMetadata(formatMetadataKey, target, propertyKey);}
```

这里的 `@format("Hello, %s")` 装饰器是一个装饰器工厂。当 `@format("Hello, %s")` 被调用时，它使用 `reflect-metadata` 库中的 `Reflect.metadata` 函数为该属性添加一个元数据条目。当 `getFormat` 被调用时，它读取该格式的元数据值。

> 注意：这个例子需要 reflect-metadata 库。关于 `reflect-metadata` 库的更多信息，请参见[Metadata](https://www.typescriptlang.org/docs/handbook/decorators.html#metadata)。

## 8.10 参数装饰器

参数装饰器就在参数声明之前被声明。参数装饰器被应用于类构造器或方法声明的函数。一个参数装饰器不能在声明文件、重载或任何其他环境中使用（比如在 `declare` 类中）。

参数装饰器的表达式将在运行时作为一个函数被调用，有以下三个参数：

1. 对于静态成员，可以是该类的构造函数，对于实例成员，可以是该类的原型。
2. 该成员的名称。
3. 参数在函数的参数列表中的序数索引。

> 注意：一个参数装饰器只能用来观察一个方法上已经声明了一个参数。

参数装饰器的返回值被忽略了。

下面是一个参数装饰器（ `@required` ）应用于 BugReport 类的一个成员的参数的例子：

```tsx
class BugReport {    type = "report";    title: string;    constructor(t: string) {        this.title = t;    }    @validate    print(@required verbose: boolean) {        if (verbose) {            return `type: ${this.type}\ntitle: ${this.title}`;        } else {            return this.title;        }    }}
```

然后我们可以使用以下函数声明来定义 `@required` 和 `@validate` 装饰器。

```tsx
import "reflect-metadata";const requiredMetadataKey = Symbol("required"); function required(target: Object, propertyKey: string | symbol, parameterIndex:number) {    let existingRequiredParameters: number[] = Reflect.getOwnMetadata(requiredMetadataKey, target, propertyKey) || [];    existingRequiredParameters.push(parameterIndex);    Reflect.defineMetadata( requiredMetadataKey, existingRequiredParameters,                           target, propertyKey);} function validate(target: any, propertyName: string, descriptor:                   TypedPropertyDescriptor<Function>) {    let method = descriptor.value!;        descriptor.value = function () {        let requiredParameters: number[] = Reflect.getOwnMetadata(requiredMetadataKey, target, propertyName);        if (requiredParameters) {            for (let parameterIndex of requiredParameters) {                if (parameterIndex >= arguments.length || arguments[parameterIndex] ===                    undefined) {                    throw new Error("Missing required argument.");                }            }        }        return method.apply(this, arguments);    };}
```

`@required` 装饰器添加了一个元数据条目，将参数标记为必填。然后， `@validate` 装饰器将现有的 `greet` 方法包装在一个函数中，在调用原始方法之前验证参数。

> 注意：这个例子需要 reflect-metadata 库。关于 `reflect-metadata` 库的更多信息，请参见[Metadata](https://www.typescriptlang.org/docs/handbook/decorators.html#metadata)。

# TypeScript学习高级篇第九章：JSX

JSX是一种可嵌入的类似XML的语法。它旨在被转换为有效的JavaScript，尽管这种转换的语义是具体实 施的。JSX随着React 框架的流行而兴起，但后来也有了其他的实现。TypeScript支持嵌入、类型检查， 以及直接将JSX编译为JavaScript。

## 9.1 基本用法

为了使用JSX，你必须做两件事。

1. 用`.tsx`扩展名来命名你的文件
2. 启用`jsx`选项

TypeScript有三种JSX模式： `preserve` , `react` 和 `react-native` 。这些模式只影响生成阶段 - 类型检查不受影响。

`preserve` 模式将保留 JSX 作为输出的一部分，以便被另一个转换步骤（例如 Babel）进一步消耗。此外，输出将有一个 `.jsx` 文件扩展名。

react 模式将发出 `React.createElement` ，在使用前不需要经过JSX转换，而且输出将有一个 `.js` 文件扩展名。

react-native 模式相当于保留模式，它保留了所有的JSX，但输出将有一个 `.js` 文件扩展名

|模式|输入|输出|输出文件扩展名|
|---|---|---|---|
|`preserve`|`<div/>`|`<div/>`|`.jsx`|
|`react`|`<div/>`|`React.createElement('div')`|`.js`|
|`react-native`|`<div/>`|`<div/>`|`.js`|
|`react-jsx`|`<div/>`|`_jsx('div', {}, void 0);`|`.js`|
|`react-jsxdev`|`<div/>`|`_jsxDEV('div', {}, void 0, false, {...}, this)`;|`.js`|

你可以使用 jsx 命令行标志或你的 `tsconfig.json` 文件中的相应选项 jsx 指定这种模式。

> *注意：你可以用 `jsxFactory` 选项指定针对 react JSX 生成 JS 时使用的JSX工厂函数（默认为 `React.createElement` ）。

## 9.2 `as`操作符

回忆一下如何编写类型断言。

```tsx
const foo = <foo>bar;
```

这断言变量 `bar` 具有 `foo` 类型。由于TypeScript也使用角括号进行类型断言，将其与JSX的语法相结合会带来某些解析困难。因此，TypeScript不允许在 `.tsx` 文件中使用角括号类型断言

由于上述语法不能在 `.tsx` 文件中使用，应该使用一个替代的类型断言操作符： `as` 。这个例子可以很容易地用 `as` 操作符重写。

```tsx
const foo = bar as foo;
```

`as` 操作符在 `.ts` 和 `.tsx` 文件中都可用，并且在行为上与角括号式断言风格相同。

## 9.3 类型检查

为了理解JSX的类型检查，你必须首先理解内在元素和基于值的元素之间的区别。给定一个JSX表达式 `<expr />`, `expr`既可以指环境中固有的东西（例如DOM环境中的 `div` 或 `span` ），也可以指你创建的自定义组件。这很重要，有两个原因。

- 对于React来说，内在元素是以字符串的形式发出的（ `React.createElement("div")` ），而你创建的组件则是这样的（ `React.createElement(MyComponent)` ）。
- 在JSX元素中传递的属性类型应该被不同地查找。元素的内在属性应该是已知的，而组件可能想要 指定他们自己的属性集。

TypeScript使用与React相同的约定来区分这些。一个**内在的元素**总是以**小写字母开始**，而**一个组件**总是以**大写字母**开始。

## 9.4 内在元素

内在元素在特殊接口 `JSX.IntrinsicElements` 上被查询到。默认情况下，如果没有指定这个接口，那 么什么都可以，内在元素将不会被类型检查。然而，如果这个接口存在，那么内在元素的名称将作为 `JSX.IntrinsicElements` 接口上的一个属性被查询。比如说:

```tsx
declare namespace JSX {    interface IntrinsicElements {        foo: any;    }} <foo />; // 正确<bar />; // 错误
```

在上面的例子中，`<foo />`可以正常工作，但`<bar />`会导致一个错误，因为它没有被指定在`JSX.IntrinsicElements` 上。

注意：你也可以在`JWX.IntrinsicElements`上指定一个全面的字符串索引器，如下所示：

```tsx
declare namespace JSX {    interface IntrinsicElements {        [elemName: string]: any;    }} let ele1 = <foo /> // 正确let ele2 = <bar /> // 错误
```

## 9.5 基于值的元素

基于值的元素只是通过范围内的标识符进行查询。

```tsx
import MyComponent from "./myComponent";<MyComponent />; // 正确<SomeOtherComponent />; // 错误
```

有两种方法来定义基于值的元素:

1. 函数组件（FC）
2. 类组件

因为这两类基于值的元素在JSX表达式中是无法区分的，首先TS尝试使用重载解析将表达式解析为一个函数组件。如果这个过程成功了，那么TS就完成了将表达式解析为它的声明。如果该值不能被解析为一个函数组件，那么TS将尝试将其解析为一个类组件。如果失败了，TS将报告一个错误。

### 9.5.1 函数组件

顾名思义，该组件被定义为一个JavaScript函数，其第一个参数是一个 `props` 对象。TS强制要求它的返回类型必须是可分配给 `JSX.Element` 的。

```tsx
interface FooProp {    name: string;    X: number;    Y: number;}declare function AnotherComponent(prop: { name: string });function ComponentFoo(prop: FooProp) {    return <AnotherComponent name={prop.name} />;}const Button = (prop: { value: string }, context: { color: string }) => (    <button />);
```

因为函数组件只是一个JavaScript函数，这里也可以使用函数重载。

```tsx
interface ClickableProps {    children: JSX.Element[] | JSX.Element;}interface HomeProps extends ClickableProps {    home: JSX.Element;}interface SideProps extends ClickableProps {    side: JSX.Element | string;}function MainButton(prop: HomeProps): JSX.Element;function MainButton(prop: SideProps): JSX.Element;function MainButton(prop: ClickableProps): JSX.Element {    // ...}
```

> 注意：函数组件以前被称为无状态函数组件（SFC）。由于Function Components在最近的react 版本中不再被认为是无状态的， `SFC` 类型和它的别名 `StatelessComponent` 被废弃了。

### 9.5.2 类组件

定义一个类组件的类型是可能的。然而，要做到这一点，最好理解两个新术语：元素类类型和元素实例类型。

给定`<Expr />` ，元素类的类型就是`Expr`的类型。所以在上面的例子中，如果 `MyComponent` 是一个ES6 类，那么类的类型就是该类的构造函数和状态。如果 MyComponent 是一个工厂函数，类的类型将是该函数。

```tsx
declare namespace JSX {    interface ElementClass {        render: any;	// 限制JSX的类型以符合相应的接口。    }} class MyComponent {    render() {}} // 使用构造签名const myComponent = new MyComponent();// 元素类类型 => MyComponent// 元素实例类型 => { render: () => void }  function MyFactoryFunction() {    return {        render: () => {},    };} <MyComponent />; // 正确<MyFactoryFunction />; // 正确 class NotAValidComponent {}function NotAValidFactoryFunction() {    return {};}<NotAValidComponent />; // 错误<NotAValidFactoryFunction />; // 错误
```

9.6 属性类型检查

类型检查属性的第一步是确定元素属性类型。这在内在元素和基于值的元素之间略有不同。

对于内在元素，它是 `JSX.IntrinsicElements` 上的属性类型。

```tsx
declare namespace JSX {    interface IntrinsicElements {        foo: { bar?: boolean };    }}// 'foo'的元素属性类型是'{bar?: boolean}'<foo bar />;
```

元素属性类型是用来对JSX中的属性进行类型检查的。支持可选和必需的属性。

```tsx
declare namespace JSX {    interface IntrinsicElements {        foo: { requiredProp: string; optionalProp?: number };    }}<foo requiredProp="bar" />; // 正确<foo requiredProp="bar" optionalProp={0} />; // 正确<foo />; // 错误, requiredProp 缺失<foo requiredProp={0} />; // 错误, requiredProp 应该为 string 类型<foo requiredProp="bar" unknownProp />; // 错误, unknownProp 属性不存在<foo requiredProp="bar" some-unknown-prop />; // 正确, 因为 'some-unknown-prop' 不是一个有效的属性标识
```

> 注意：如果一个属性名称不是一个有效的JS标识符（如`data-*`属性），如果在元素属性类型中找不到它，则不被认为是一个错误。

此外， `JSX.IntrinsicAttributes` 接口可以用来指定JSX框架使用的额外属性，这些属性一般不会被组件的道具或参数使用--例如React中的key。进一步专门化，通用的 `JSX.IntrinsicClassAttributes<T>` 类型也可以用来为类组件（而不是函数组件）指定同种额外属性。在这种类型中，通用参数与类的实例类型相对应。在React中，这被用来允许 `Ref<T>` 类型的 `ref` 属性。一般来说，这些接口上的所有属性都应该是可选的，除非你打算让你的JSX框架的用户需要在每个标 签上提供一些属性。

展开运算符也能正常工作：

```tsx
const props = { requiredProp: "bar" };<foo {...props} />; // 正确const badProps = {};<foo {...badProps} />; // 错误
```

## 9.7 子类型检查

在TypeScript 2.3中，TS引入了`children`的类型检查。`children`是元素属性类型中的一个特殊属性，子的 `JSXExpressions`被采取插入属性中。类似于TS使用 `JSX.ElementAttributesProperty` 来确定 `props` 的名称，TS使用 `JSX.ElementChildrenAttribute` 来确定这些 `props` 中的 `children` 的名称。 `JSX.ElementChildrenAttribute` 应该用一个单一的属性来声明。

```tsx
declare namespace JSX {    interface ElementChildrenAttribute {        children: {}; // 指定要使用的 children 名称    }}
```

你可以像其他属性一样指定 children 的类型。这将覆盖默认的类型，例如，如果你使用React类型的话：

```tsx
interface PropsType {    children: JSX.Element    name: string}class Component extends React.Component<PropsType, {}> {    render() {        return (            <h2>                {this.props.children}            </h2>        )    }}// 正确<Component name="foo">    <h1>Hello World</h1></Component>// 错误: children是JSX.Element的类型，而不是JSX.Element的数组<Component name="bar">    <h1>Hello World</h1>    <h2>Hello World</h2></Component>// 错误: children是JSX.Element的类型，而不是JSX.Element的数组或字符串。<Component name="baz">    <h1>Hello</h1>    World</Component>
```

## 9.8 JSX的结果类型

默认情况下，JSX表达式的结果被打造成 `any` 类型。你可以通过指定 `JSX.Element` 接口来定制类型。 然而，不可能从这个接口中检索到关于JSX的元素、属性或孩子的类型信息。它是一个黑盒子。

## 9.9 嵌入表达式

JSX允许你通过用大括号（ `{ }` ）包围表达式，在标签之间嵌入表达式。

```tsx
const a = (    <div>        {["foo", "bar"].map((i) => (            <span>{i / 2}</span>        ))}    </div>);
```

上面的代码将导致一个错误，因为你不能用一个字符串除以一个数字。当使用 `preserve` 选项时，输出结果看起来像：

```tsx
const a = (    <div>        {["foo", "bar"].map(function (i) {            return <span>{i / 2}</span>;        })}    </div>)
```

## 9.10 React 集成

要在React中使用JSX，你应该使用 `React` 类型。这些类型化定义了 `JSX` 的命名空间，以便与React一起使用。

```tsx
/// <reference path="react.d.ts" />interface Props {    foo: string;}class MyComponent extends React.Component<Props, {}> {    render() {        return <span>{this.props.foo}</span>;    }}<MyComponent foo="bar" />; // 正确<MyComponent foo={0} />; // 错误
```

### 9.10.1 配置JSX

有多个编译器标志可以用来定制你的JSX，它们既可以作为编译器标志，也可以通过内联的每个文件实用程序发挥作用。要了解更多信息，请看他们的tsconfig参考页：

- [jsxFactory](https://www.typescriptlang.org/tsconfig#jsxFactory)
- [jsxFragmentFactory](https://www.typescriptlang.org/tsconfig#jsxFragmentFactory)
- [jsxImportSource](https://www.typescriptlang.org/tsconfig#jsxImportSource)

# TypeScript学习高级篇第十章：混入

除了传统的OO层次结构外，另一种流行的从可重用组件中建立类的方式是，通过组合更简单的部分类来 建立它们。你可能对 Scala 等语言的 mixins 或 traits 的想法很熟悉，这种模式在JavaScript社区也达 到了一定的普及。

## 10.1 混入是如何工作的？

该模式依赖于使用**泛型**与**类继承**来扩展基类。TypeScript最好的`mixin`支持是通过类表达模式完成的。你可以在 [这里](https://justinfagnani.com/2015/12/21/real-mixins-with-javascript-classes/)阅读更多关于这种模式在JavaScript中的工作方式。

为了开始工作，我们需要一个类，在这个类上应用混入：

```tsx
class Sprite {    name = "";    x = 0;    y = 0;        constructor(name: string) {        this.name = name;    }}
```

然后你需要一个类型和一个工厂函数，它返回一个扩展基类的表达式。

```tsx
// 为了开始工作，我们需要一个类型，我们将用它来扩展其他类。// 主要的责任是声明传入的类型是一个类。// ...args: any[] 代表接收一个任意类型的数组利用...展开为构造函数的参数type Constructor = new (...args: any[]) => {};  // 这个混集器增加了一个 scale 属性，并带有getters和setters// 用来改变它的封装的私有属性。function Scale<TBase extends Constructor>(Base: TBase) {    return class Scaling extends Base {        // 混入不能声明私有/受保护的属性        // 但是，你可以使用ES2020的私有字段        _scale = 1;        setScale(scale: number) {            this._scale = scale;        }        get scale(): number {            return this._scale;        }    };}
```

有了这些设置，你就可以创建一个代表基类的类，并应用混合元素。

```tsx
// 从Sprite类构成一个新的类。// 用Mixin Scale应用程序:const EightBitSprite = Scale(Sprite); const flappySprite = new EightBitSprite("Bird");flappySprite.setScale(0.8);console.log(flappySprite.scale); // 0.8
```

## 10.2 受约束的混入

在上述形式中，混入**没有关于类的底层知识**，这可能使它很难创建你想要的设计。

为了模拟这一点，我们修改了原来的构造函数类型以接受一个通用参数。

```tsx
// 这就是我们之前的构造函数type Constructor = new (...args: any[]) => {}; // 现在我们使用一个通用的版本，它可以在以下方面应用一个约束// 该混入所适用的类type GConstructor<T = {}> = new (...args: any[]) => T;
```

这允许创建只与受限基类一起工作的类。

```tsx
type Positionable = GConstructor<{ setPos: (x: number, y: number) => void }>;type Spritable = GConstructor<Sprite>;type Loggable = GConstructor<{ print: () => void }>;
```

然后，你可以创建混入函数，只有当你有一个特定的基础时，它才能发挥作用。

```tsx
function Jumpable<TBase extends Positionable>(Base: TBase) {    return class Jumpable extends Base {        jump() {            // 这个混合器只有在传递给基类的情况下才会起作用。            // 类中定义了setPos，因为有了可定位的约束。            this.setPos(0, 20);        }    };} class Person {    name: string;    x = 0    y = 0    setPos(x: number, y: number): void {        this.x = x        this.y = y        console.log(`${this.name}的位置变为x:${x}, y:${y}`)     }    constructor(name: string) {        this.name = name    }} const PersonJump = Jumpable(Person) const personBleak = new PersonJump('Bleak')// Bleak跳之前的位置为x:0,y:0console.log(`${personBleak.name}跳之前的位置为x:${personBleak.x},y:${personBleak.y}`)// Bleak的位置变为x:0, y:20personBleak.jump()
```

## 10.3 替代模式

TS学习文档的前几个版本推荐了一种编写混入函数的方法，即分别创建运行时和类型层次，然后在最后将他们合并：

```tsx
// 每个mixin都是一个传统的ES类class Jumpable {    jump() {        console.log("我跳了一下")    }} class Duckable {    duck() {}} // 基类class Sprite {    x = 0;    y = 0;} // 然后，你创建一个接口// 将预期的混合函数与你的基础函数同名，// 合并在一起。interface Sprite extends Jumpable, Duckable {} // 它可以存在于你代码库的任何地方function applyMixins(derivedCtor: any, constructors: any[]) {    constructors.forEach((baseCtor) => {        Object.getOwnPropertyNames(baseCtor.prototype).forEach((name) => {            Object.defineProperty(                derivedCtor.prototype,                name,                Object.getOwnPropertyDescriptor(baseCtor.prototype, name) ||                Object.create(null)            );        });    });} // 在运行时，通过JS将混入应用到基类中applyMixins(Sprite, [Jumpable, Duckable]);let player = new Sprite();player.jump(); // 我跳了一下console.log(player.x, player.y); // 0 0
```

这种模式较少依赖于编译器，而更多地依赖于你的代码库，以确保运行时和类型系统都能正确地保持同步。

## 10.4 限制条件

mixin模式在TypeScript编译器中通过代码流分析得到了本地支持。在一些情况下，你会遇到本地支持的边界。

### 10.4.1 装饰器和混入

你不能使用装饰器来通过代码流分析提供混入：

```tsx
// 一个复制mixin模式的装饰器函数。const Pausable = (target: typeof Player) => {    return class Pausable extends target {        shouldFreeze = false;    };};  @Pausableclass Player {    x = 0;    y = 0;} // 播放器类没有合并装饰器的类型const player = new Player();player.shouldFreeze;// Ⓧ 属性'shouldFreeze'在类型'Player'上不存在 // 运行时方面可以通过类型组合或接口合并来手动复制。type FreezablePlayer = Player & { shouldFreeze: boolean }; const playerTwo = (new Player() as unknown) as FreezablePlayer;playerTwo.shouldFreeze;
```

## 10.4.2 静态属性混入

与其说是约束，不如说是一个难题。类表达式模式创建了单子，所以它们不能在类型系统中被映射以支持不同的变量类型。

你可以通过使用函数返回你的类来解决这个问题，这些类基于泛型而不同:

```tsx
function base<T>() {    class Base {        static prop: T;    }    return Base;}function derived<T>() {    class Derived extends base<T>() {        static anotherProp: T;    }    return Derived;}class Spec extends derived<string>() {}Spec.prop = 'Bleak' // stringSpec.anotherProp = 'Chris' // string
```

# TypeScript学习高级篇第十一章：三斜线指令

三斜线指令是**包含单个XML标签的单行注释**。**注释的内容被作为编译器指令使用**。

三斜线指令**只在其包含文件的顶部有效**。**三斜线指令的前面只能有单行或多行注释，包括其他三斜线指令**。如果它们出现在语句或声明之后，则被视为普通的单行注释，没有任何特殊意义。

## 11.1 `/// <reference path='...' />`

- **预处理输入文件**

编译器对输入文件进行预处理，以解决所有三斜线参考指令。在这个过程中，额外的文件被添加到编译中。

这个过程从一组 **根文件** 开始；这些文件是在**命令行**或在 **tsconfig.json** 文件的 **文件列表** 中指定的文件名。这些根文件按照它们被指定的顺序进行预处理。在一个文件被添加到列表中之前，其中所有的三斜线引用都会被处理，并包括它们的目标。三斜线引用是以深度优先的方式解决的，按照它们在文件中出现的顺序。 如果使用的是相对路径，那么三斜线引用的路径是相对于包含的文件进行解析的。

- **错误**

引用一个不存在的文件是一个错误。一个文件对自己有三重斜线引用是一个错误。

- 使用`--noResolve`

如果指定了编译器标志noResolve，三斜线引用将被忽略；它们既不会导致添加新的文件，也不会改变所提供文件的顺序。

## 11.2 `/// <reference types='...' />`

与作为依赖关系声明的`/// <reference path='...' />`指令类似，`/// <reference types='...' />`指令声明对包的依赖关系。

解析这些包名的过程与解析 `import` 语句中的模块名的过程类似。一个简单的方法是将三重斜线引用类型指令看作是声明包的 `import` 。

例如，在一个声明文件中包括`/// <reference types='node' />`声明这个文件使用 `@types/node/index.d.ts` 中声明的名字；因此，这个包需要和声明文件一起包含在编译中。

只有在你手工编写 `d.ts` 文件的时候才使用这些指令。

对于在编译过程中生成的声明文件，编译器会自动为你添加`/// <reference types='...' />`； 在生成的声明文件中，当且仅当生成的文件使用了被引用包的任何声明时，会添加`/// <reference types='...' />` 。

对于在 `.ts` 文件中声明对 `@types` 包的依赖，在命令行或你的 `tsconfig.json` 中使用 `types` 来代 替。参见[在 tsconfig.json 文件里应用 @types , typeRoots 和 types](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html#types-typeroots-and-types) 以了解更多细节

## 11.3 `/// <reference lib='...'>`

这个指令允许一个文件明确地包含一个现有的内置 _lib_ 文件。

内置 _lib_ 文件的引用方式与 t`sconfig.json` 中的 [lib](https://www.typescriptlang.org/tsconfig#lib) 编译器选项相同（例如，使用 `lib="es2015"` 而不是 `lib="lib.es2015.d.ts"` ，等等）。

对于依赖内置类型的声明文件作者，例如DOM APIs或内置的JS运行时构造器，如 `Symbol` 或 `Iterable` ，建议使用三重斜线引用的lib指令。以前这些 `.d.ts` 文件不得不添加此类类型的前向/重复声明。

例如，在编译中的一个文件中添加`/// <reference lib='es2017.string'`，相当于用 `--lib es2017.string` 进行编译。

```tsx
/// <reference lib="es2017.string" />"foo".padStart(4);
```

## 11.4 `/// <reference no-default-lib='true'>`

这个指令将一个文件标记为 默认库。你会在 `lib.d.ts` 和它的不同变体的顶部看到这个注释。

这个指令指示编译器在编译时不包括默认库（即 `lib.d.ts` ）。这里的影响类似于在命令行中传递[noLib](https://www.typescriptlang.org/tsconfig#noLib)

还要注意的是，当传递递 [skipDefaultLibCheck](https://www.typescriptlang.org/tsconfig#skipDefaultLibCheck) 时，编译器将只跳过检查带有`/// <reference no-default-lib='true'>`的文件。

## 11.5 `/// <amd-module>`

默认情况下，AMD模块是以匿名方式生成的。当其他工具被用来处理生成的模块时，这可能会导致问题，例如捆绑器（如 `r.js` ）。

`amd-module` 指令允许向编译器传递一个可选的模块名称。

- **amdModule.ts**

```tsx
/// <amd-module name="NamedModule"/>export class C {}
```

将导致在调用AMD `define`的过程中，将 `NamedModule` 这个名字分配给模块。

- **amdModule.js**

```tsx
define("NamedModule", ["require", "exports"], function (require, exports) {    var C = (function () {        function C() {}        return C;    })();    exports.C = C;});
```

# TypeScript学习高级篇第十二章：模块

从ECMAScript 2015（ES6）开始，JavaScript有一个模块的概念。TypeScript也有这个概念。

**模块在自己的范围内执行**，而不是在全局范围内；这意味着在模块中声明的变量、函数、类等在模块外是不可见的，除非它们被明确地使用其中一种[导出形式](https://www.typescriptlang.org/docs/handbook/modules.html#export)导出。相反，要使用从不同模块导出的变量、函数、类、接口等，必须使用[导入形式](https://www.typescriptlang.org/docs/handbook/modules.html#import)将其导入。

模块是声明性的；模块之间的关系是在**文件级别上**以**导入**和**导出**的方式指定的。

模块使用模块加载器相互导入。在运行时，模块加载器负责在执行一个模块之前定位和执行该模块的所 有依赖关系。在JavaScript中使用的著名的模块加载器是Node.js的[CommonJS](https://wikipedia.org/wiki/CommonJS) 模块的加载器和Web应用程序中[AMD](https://github.com/amdjs/amdjs-api/blob/master/AMD.md)模块的 [RequireJS](http://requirejs.org/) 加载器。

在TypeScript中，就像在ECMAScript 2015中一样，任何包含顶级 `import` 或 `export` 的文件都被认为是一个模块。相反，一个没有任何顶级 `import` 或 `export` 声明的文件被视为一个脚本，其内容可在全局范围内使用（因此也可用于模块）。

## 12.1 导出声明

任何声明（如变量、函数、类、类型别名或接口）都可以通过添加 `export` 关键字而被导出

**StringValidator.ts**

```tsx
export interface StringValidator {    isAcceptable(s: string): boolean;}
```

**ZipCodeValidator.ts**

```tsx
import { StringValidator } from "./StringValidator";export const numberRegexp = /^[0-9]+$/;export class ZipCodeValidator implements StringValidator {    isAcceptable(s: string) {        return s.length === 5 && numberRegexp.test(s);    }}
```

## 12.2 导出别名

当导出需要为调用者重新命名时，导出语句很方便，所以上面的例子可以写成：

```tsx
class ZipCodeValidator implements StringValidator {    isAcceptable(s: string) {        return s.length === 5 && numberRegexp.test(s);    }}export { ZipCodeValidator };export { ZipCodeValidator as mainValidator };
```

## 12.3 二次导出

通常情况下，模块会扩展其他模块，并部分地暴露出它们的一些特性。一个二次导出**并不在本地导入**，也不引**入本地变量**。

**ParseIntBasedZipCodeValidator.ts**

```tsx
export class ParseIntBasedZipCodeValidator {    isAcceptable(s: string) {        return s.length === 5 && parseInt(s).toString() === s;    }} // 导出原始验证器但重新命名export { ZipCodeValidator as RegExpBasedZipCodeValidator } from "./ZipCodeValidator";
```

另外，一个模块可以包裹一个或多个模块，并使用 `export * from "module"` 语法组合它们的所有导出。

**AllValidators.ts**

```tsx
export * from "./StringValidator"; // 导出 'StringValidator' 接口export * from "./ZipCodeValidator"; // 导出 'ZipCodeValidator' 类和 'numberRegexp' 常量值export * from "./ParseIntBasedZipCodeValidator"; // 导出'ParseIntBasedZipCodeValidator'类，从'ZipCodeValidator.ts'模块重新导出 'RegExpBasedZipCodeValidator' 作为'ZipCodeValidator'类的别名。
```

## 12.4 导入

导入和从模块中导出一样简单。导入一个导出的声明是通过使用下面的一个导入表格完成的。

### 12.4.1 从一个模块中导入一个单一的导出

```tsx
import { ZipCodeValidator } from "./ZipCodeValidator";let myValidator = new ZipCodeValidator();
```

导入也可以被重新命名：

```tsx
import { ZipCodeValidator as ZCV } from "./ZipCodeValidator";let myValidator = new ZCV();
```

### 12.4.2 将整个模块导入到一个变量中，并使用它来访问模块的出口

```tsx
import * as validator from "./ZipCodeValidator";let myValidator = new validator.ZipCodeValidator();
```

### 12.4.3 导入一个只有副作用的模块

虽然不是推荐的做法，但有些模块设置了一些全局状态，可以被其他模块使用。这些模块可能没有任何出口，或者消费者对它们的任何出口不感兴趣。要导入这些模块，请使用:

```tsx
import "./my-module.js";
```

在TypeScript 3.8之前，你可以使用 `import` 导入一个类型。在TypeScript 3.8中，你可以使用 `import` 语句导入一个类型，或者使用 `import type` 。

```tsx
// 重复使用相同的 importimport { APIResponseType } from "./api";// 明确使用导入类型import type { APIResponseType } from "./api";
```

`import type` 总是被保证从你的JavaScript中删除，而且像Babel这样的工具可以通过 [isolatedModules](https://www.typescriptlang.org/tsconfig#isolatedModules) 编译器标志对你的代码做出更好的假设。你可以在[3.8 release notes](https://devblogs.microsoft.com/typescript/announcing-typescript-3-8-beta/#type-only-imports-exports) 的发行说明中阅读更多内容。

## 12.5 默认输出

每个模块都可以选择输出一个 `default` 输出。默认输出用关键字 `default` 标记；每个模块只能有一个`default` 输出。 `default` 输出使用不同的导入形式导入。

`default` 导出真的很方便。例如，像`jQuery`这样的库可能有一个默认导出的`jQuery`或 `$` ，我们可能也 会以 `$` 或`jQuery`的名字导入。

[JQuery.d.ts](https://github.com/DefinitelyTyped/DefinitelyTyped/blob/master/types/jquery/JQuery.d.ts)

```tsx
declare let $: JQuery;export default $;
```

**App.ts**

```tsx
import $ from "jquery";$("button.continue").html("Next Step...");
```

类和函数声明可以直接作为默认导出而编写。默认导出的类和函数声明名称是可选的。

**ZipCodeValidator.ts**

```tsx
export default class ZipCodeValidator {    static numberRegexp = /^[0-9]+$/;    isAcceptable(s: string) {        return s.length === 5 && ZipCodeValidator.numberRegexp.test(s);    }}
```

**Test.ts**

```tsx
import validator from "./ZipCodeValidator";let myValidator = new validator();
```

或者：

**StaticZipCodeValidator.ts**

```tsx
const numberRegexp = /^[0-9]+$/;export default function (s: string) {    return s.length === 5 && numberRegexp.test(s);}
```

**Test.ts**

```tsx
import validate from "./StaticZipCodeValidator";let strings = ["Hello", "98052", "101"];// 使用函数验证strings.forEach((s) => {    console.log(`"${s}" ${validate(s) ? "matches" : "does not match"}`);});
```

`default`出口也可以只是数值。

**OneTwoThree.ts**

```tsx
export default "123";
```

**Log.ts**

```tsx
import num from "./OneTwoThree";console.log(num); // "123"
```

## 12.6 `as x`导出全部

在TypeScript 3.8中，你可以使用 `export * as ns` 作为一种速记方法来重新导出另一个有名字的模块。

```tsx
export * as utilities from "./utilities";
```

这从一个模块中获取所有的依赖性，并使其成为一个导出的字段，你可以像这样导入它：

```tsx
import { utilities } from "./index";
```

## 12.7 `export =`与`import = require()`

CommonJS和AMD通常都有一个 `exports` 对象的概念，它包含了一个模块的所有出口。

它们也支持用一个自定义的单一对象来替换 `exports` 对象。默认的 `exports` 是为了作为这种行为的替代；然而，两者是不兼容的。TypeScript 支持 `export =` 来模拟传统的 CommonJS 和 AMD 工作流程。

`export =` 语法指定了一个从模块导出的单一对象。这可以是一个类，接口，命名空间，函数，或枚举。

当使用 `export =` 导出一个模块时，必须使用TypeScript特定的 `import module = require("module")` 来导入模块。

**ZipCodeValidator.ts**

```tsx
let numberRegexp = /^[0-9]+$/;class ZipCodeValidator {    isAcceptable(s: string) {        return s.length === 5 && numberRegexp.test(s);    }}export = ZipCodeValidator
```

**Test.ts**

```tsx
import zip = require("./ZipCodeValidator");// 一些可以尝试的样本let strings = ["Hello", "98052", "101"];// 要使用的验证器let validator = new zip();// 显示每个字符串是否通过每个验证器strings.forEach((s) => {    console.log(        `"${s}" - ${validator.isAcceptable(s) ? "matches" : "does not match"}`    );});
```

## 12.8 模块的代码生成

根据编译时指定的模块目标，编译器将为Node.js（[CommonJS](http://wiki.commonjs.org/wiki/CommonJS)）、require.js（[AMD](https://github.com/amdjs/amdjs-api/wiki/AMD)）、 [UMD](https://github.com/umdjs/umd)、 [SystemJS](https://github.com/systemjs/systemjs)或[ECMAScript 2015本地模块](http://www.ecma-international.org/ecma-262/6.0/#sec-modules)（ES6）模块加载系统生成相应的代码。关于生成的代码中的 `define` 、 `require` 和 `register` 调用的更多信息，请查阅每个模块加载器的文档。

这个简单的例子显示了，导入和导出过程中使用的名称，是如何被翻译成模块加载代码的

**SimpleModule.ts**

```tsx
import m = require("mod");export let t = m.something + 1;
```

**AMD / RequireJS SimpleModule.js**

```tsx
define(["require", "exports", "./mod"], function (require, exports, mod_1) {    exports.t = mod_1.something + 1;});
```

**CommonJS / Node SimpleModule.js**

```tsx
var mod_1 = require("./mod");exports.t = mod_1.something + 1;
```

**UMD SimpleModule.js**

```tsx
(function (factory) {    if (typeof module === "object" && typeof module.exports === "object") {        var v = factory(require, exports);        if (v !== undefined) module.exports = v;    } else if (typeof define === "function" && define.amd) {        define(["require", "exports", "./mod"], factory);    }})(function (require, exports) {    var mod_1 = require("./mod");    exports.t = mod_1.something + 1;});
```

**System SimpleModule.js**

```tsx
System.register(["./mod"], function (exports_1) {    var mod_1;    var t;    return {        setters: [            function (mod_1_1) {                mod_1 = mod_1_1;            },        ],        execute: function () {            exports_1("t", (t = mod_1.something + 1));        },    };});
```

**Native ECMAScript 2015 modules SimpleModule.j**

```tsx
import { something } from "./mod";export var t = something + 1;
```

## 12.9 案例

下面，我们整合了之前例子中使用的Validator实现，只从每个模块导出一个命名的导出。

要进行编译，我们必须在命令行中指定一个模块目标。对于`Node.js`，使用 `--module commonjs` ；对于 `require.js`，使用 `--module amd` 。比如说：

```cpp
tsc --module commonjs Test.ts
```

编译时，每个模块将成为一个单独的 `.js` 文件。与参考标签一样，编译器将遵循 `import` 语句来编译依赖的文件。

**Validation.ts**

```tsx
export interface StringValidator {    isAcceptable(s: string): boolean;}
```

**LettersOnlyValidator.ts**

```tsx
import { StringValidator } from "./Validation";const lettersRegexp = /^[A-Za-z]+$/;export class LettersOnlyValidator implements StringValidator {    isAcceptable(s: string) {        return lettersRegexp.test(s);    }}
```

**ZipCodeValidator.ts**

```tsx
import { StringValidator } from "./Validation";const numberRegexp = /^[0-9]+$/;export class ZipCodeValidator implements StringValidator {    isAcceptable(s: string) {        return s.length === 5 && numberRegexp.test(s);    }}
```

**Test.ts**

```tsx
import { StringValidator } from "./Validation";import { ZipCodeValidator } from "./ZipCodeValidator";import { LettersOnlyValidator } from "./LettersOnlyValidator";// 一些可以尝试的样本let strings = ["Hello", "98052", "101"];// 要使用的验证器let validators: { [s: string]: StringValidator } = {};validators["ZIP code"] = new ZipCodeValidator();validators["Letters only"] = new LettersOnlyValidator();// 显示每个字符串是否通过每个验证器strings.forEach((s) => {    for (let name in validators) {        console.log(            `"${s}" - ${            validators[name].isAcceptable(s) ? "matches" : "does not match"            } ${name}`        );    }});
```

## 12.10 可选模块加载和其他高级加载场景

在某些情况下，你可能只想在某些条件下加载一个模块。在TypeScript中，我们可以使用下面所示的模式来实现这个和其他高级的加载场景，直接调用模块加载器而不失去类型安全。

编译器会检测每个模块是否在编译好的JavaScript中被使用。如果一个模块的标识符只被用作类型注释的一部分，而从未被用作表达式，那么就不会为该模块编译 `require` 调用。这种对未使用的引用的消除是一种很好的性能优化，同时也允许对这些模块进行选择性加载。

该模式的核心思想是， `import id = require("...")` 语句使我们能够访问模块所暴露的类型。模块加载器（通过 `require` ）被动态地调用，如下面的 `if` 块所示。这样就利用了引用隔离的优化，使模块只在需要时才被加载。为了使这种模式发挥作用，重要的是通过 `import` 定义的符号只在类型位置使用（也就是说，决不在会被编译到JavaScript的位置）。

为了维护类型安全，我们可以使用 `typeof` 关键字。 `typeof` 关键字在类型位置上使用时，会产生一个值的类型，在这里是模块的类型。

- **Node.js中的动态模块加载**

```tsx
declare function require(moduleName: string): any;import { ZipCodeValidator as Zip } from "./ZipCodeValidator";if (needZipValidation) {    let ZipCodeValidator: typeof Zip = require("./ZipCodeValidator");    let validator = new ZipCodeValidator();    if (validator.isAcceptable("...")) {        /* ... */    }}
```

- **require.js中动态加载模块**

```tsx
declare function require( moduleNames: string[], onLoad: (...args: any[]) => void ): void;import * as Zip from "./ZipCodeValidator";if (needZipValidation) {    require(["./ZipCodeValidator"], (ZipCodeValidator: typeof Zip) => {        let validator = new ZipCodeValidator.ZipCodeValidator();        if (validator.isAcceptable("...")) {            /* ... */        }    });}
```

- System.js中的动态模块加载

```tsx
declare const System: any;import { ZipCodeValidator as Zip } from "./ZipCodeValidator";if (needZipValidation) {    System.import("./ZipCodeValidator").then((ZipCodeValidator: typeof Zip) => {        var x = new ZipCodeValidator();        if (x.isAcceptable("...")) {            /* ... */        }    });}
```

## 12.11 与其他JavaScript库一起工作

为了描述不是用TypeScript编写的库的形状，我们需要声明该库所暴露的API。

我们把不定义实现的声明称为 "环境"。通常情况下，这些都是在 `.d.ts` 文件中定义的。

如果你熟悉 C/C++，你可以把它们看作是 `.h` 文件。让我们来看看几个例子。

### 12.11.1 环境模块

在Node.js中，大多数任务是通过加载一个或多个模块完成的。我们可以在自己的 `.d.ts` 文件中定义每个模块，并进行顶层导出声明，但把它们写成一个更大的 `.d.ts` 文件会更方便。要做到这一点，我们使用一个类似于环境命名空间的结构，但我们使用 `module` 关键字和引号的模块名称，这将在以后的导入中可用。比如说：

**node.d.ts(简要摘录)**

```tsx
declare module "url" {    export interface Url {        protocol?: string;        hostname?: string;        pathname?: string;    }    export function parse(     urlStr: string,     parseQueryString?,     slashesDenoteHost?    ): Url;}declare module "path" {    export function normalize(p: string): string;    export function join(...paths: any[]): string;    export var sep: string;}
```

现在我们可以 `/// <reference> node.d.ts` ，然后使用 `import url = require("url");`或 i`mport * as URL from "url"` 加载模块。

```tsx
/// <reference path="node.d.ts"/>import * as URL from "url";let myUrl = URL.parse("https://www.typescriptlang.org");
```

### 12.11.2 速记的环境模块

如果你不想在使用一个新模块之前花时间写出声明，你可以使用速记声明来快速入门。

**declarations.d.ts**

```tsx
declare module "hot-new-module";
```

所有来自速记模块的导入都将具有任意类型。

```tsx
import x, { y } from "hot-new-module";x(y);
```

### 12.11.3 通配符模块的声明

一些模块加载器，如 SystemJS 和 AMD 允许导入非JavaScript内容。这些模块通常使用一个前缀或后缀来表示特殊的加载语义。通配符模块声明可以用来涵盖这些情况。

```tsx
declare module "*!text" {    const content: string;    export default content;}// 有些人则反其道而行之。declare module "json!*" {    const value: any;    export default value;}
```

现在你可以导入符合 `"*!text "` 或 `"json!*"` 的东西。

```tsx
import fileContent from "./xyz.txt!text";import data from "json!http://example.com/data.json";console.log(data, fileContent);
```

### 12.11.4 UMD 模块

有些库被设计成可以在许多模块加载器中使用，或者没有模块加载（全局变量）也可以。这些被称为UMD模块。这些库可以通过导入或全局变量访问。比如说：

**math-lib.d.ts**

```tsx
export function isPrime(x: number): boolean;export as namespace mathLib;
```

然后，该库可以作为模块内的导入使用：

```tsx
import { isPrime } from "math-lib";isPrime(2);mathLib.isPrime(2); // 错误：不能从模块内部使用全局定义
```

它也可以作为一个全局变量使用，但只能在一个脚本中使用。(脚本是一个没有导入或导出的文件）。

```tsx
mathLib.isPrime(2);
```

## 12.12 构建模块的指导意见

### 12.12.1 尽可能接近顶层导出(export)

你的模块的消费者在使用你导出的东西时，应该有尽可能少的困扰。增加过多的嵌套层次往往是很麻烦的，所以要仔细考虑你想如何组织代码。

从你的模块中导出一个命名空间，就是一个增加过多嵌套层次的例子。虽然命名空间有时有其用途，但在使用模块时，它们增加了额外的间接性。这很快就会成为用户的一个痛点，而且通常是不必要的。

输出类上的静态方法也有类似的问题——类本身增加了一层嵌套。除非它以一种明显有用的方式增加了表达能力或意图，否则考虑简单地导出一个辅助函数。

1. **如果你只导出了一个`class`或`function`则使用`export default`**

正如 "在顶层导出 "可以减少模块消费者的困扰，引入一个默认导出也是如此。如果一个模块的主要目的是容纳一个特定的出口，那么你应该考虑把它作为一个默认出口。这使得导入和实际使用导入都更容易一些。比如说：

**MyClass.ts**

```tsx
export default class SomeType {    constructor() { ... }}
```

**MyFunc.ts**

```tsx
export default function getThing() {    return "thing";}
```

**Consumer.ts**

```tsx
import t from "./MyClass";import f from "./MyFunc";let x = new t();console.log(f());
```

这对消费者来说是最好的。他们可以随心所欲地命名你的类型（本例中为 t ），并且不必做任何过度的 点缀来寻找你的对象。

2. **如果你要导出多个对象，把它们都放在顶层**

**MyThings.ts**

```tsx
export class SomeType {    /* ... */}export function someFunc() {    /* ... */}
```

反之，在导入时，也是如此。

3. **明确列出进口名称**

**Consumer.ts**

```tsx
import { SomeType, someFunc } from "./MyThings";let x = new SomeType();let y = someFunc();
```

如果你要导入大量的东西，请使用命名空间导入模式:

**MyLargeModule.ts**

```tsx
export class Dog { ... }export class Cat { ... }export class Tree { ... }export class Flower { ... }
```

**Consumer.ts**

```tsx
import * as myLargeModule from "./MyLargeModule.ts";let x = new myLargeModule.Dog();
```

### 12.12.2 扩展的重新导出

通常情况下，你需要在一个模块上扩展功能。一个常见的JS模式是用扩展来增强原始对象，类似于 JQuery扩展的工作方式。正如我们之前提到的，模块不会像全局命名空间对象那样进行合并。推荐的解决方案是不改变原始对象，而是导出一个提供新功能的新实体。

考虑一个简单的计算器实现，定义在模块`Calculator.ts`中。该模块还导出了一个辅助函数，通过传递 一个输入字符串列表并在最后写入结果，来测试计算器的功能。

**Calculator.ts**

```tsx
export class Calculator {    private current = 0;    private memory = 0;    private operator: string;    protected processDigit(digit: string, currentValue: number) {        if (digit >= "0" && digit <= "9") {            return currentValue * 10 + (digit.charCodeAt(0) - "0".charCodeAt(0));        }    }    protected processOperator(operator: string) {        if (["+", "-", "*", "/"].indexOf(operator) >= 0) {            return operator;        }    }    protected evaluateOperator(    operator: string,     left: number,     right: number    ): number {        switch (this.operator) {            case "+":                return left + right;            case "-":                return left - right;            case "*":                return left * right;            case "/":                return left / right;        }    }    private evaluate() {        if (this.operator) {            this.memory = this.evaluateOperator(                this.operator,                this.memory,                this.current            );        } else {            this.memory = this.current;        }        this.current = 0;    }    public handleChar(char: string) {        if (char === "=") {            this.evaluate();            return;        } else {            let value = this.processDigit(char, this.current);            if (value !== undefined) {                this.current = value;                return;            } else {                let value = this.processOperator(char);                if (value !== undefined) {                    this.evaluate();                    this.operator = value;                    return;                }            }        }        throw new Error(`Unsupported input: '${char}'`);    }    public getResult() {        return this.memory;    }} export function test(c: Calculator, input: string) {    for (let i = 0; i < input.length; i++) {        c.handleChar(input[i]);    }    console.log(`result of '${input}' is '${c.getResult()}'`);}
```

下面是一个使用暴露测试功能的计算器的简单测试。

**TestCalculator.ts**

```tsx
import { Calculator, test } from "./Calculator";let c = new Calculator();test(c, "1+2*33/11="); // 输出 9
```

现在，为了扩展这个功能，以增加对10以外的数字输入的支持，我们来创建 `ProgrammerCalculator.ts`

**ProgrammerCalculator.ts**

```tsx
import { Calculator } from "./Calculator";class ProgrammerCalculator extends Calculator {    static digits = [        "0",        "1",        "2",        "3",        "4",        "5",        "6",        "7",        "8",        "9",        "A",        "B",        "C",        "D",        "E",        "F",    ];    constructor(public base: number) {        super();        const maxBase = ProgrammerCalculator.digits.length;        if (base <= 0 || base > maxBase) {            throw new Error(`base has to be within 0 to ${maxBase} inclusive.`);        }    }    protected processDigit(digit: string, currentValue: number) {        if (ProgrammerCalculator.digits.indexOf(digit) >= 0) {            return (                currentValue * this.base + ProgrammerCalculator.digits.indexOf(digit)            );        }    }} // 将新的扩展计算器导出为 Calculatorexport { ProgrammerCalculator as Calculator };// 同时，导出辅助函数export { test } from "./Calculator";
```

新模块 `ProgrammerCalculator` 输出的API形状与原来的 `Calculator` 模块相似，但并没有增强原来模块中的任何对象。下面是对我们的 `ProgrammerCalculator` 类的测试。

**TestProgrammerCalculator.ts**

```tsx
import { Calculator, test } from "./ProgrammerCalculator";let c = new Calculator(2);test(c, "001+010="); // 输出 3
```

### 12.12.3 不要在模块中使用命名空间

当第一次转移到基于模块的代码设计时，一个常见的趋势是，将 export 包裹在一个额外的命名空间层中。模块有自己的范围，只有导出的声明在模块外可见。考虑到这一点，如果有命名空间的话，它在使用模块时提供的价值非常小。

在组织方面，命名空间对于在全局范围内，将逻辑上相关的对象和类型组合在一起很方便。例如，在C#中，你会在 `System.Collections` 中找到所有的集合类型。通过将我们的类型组织到分层的命名空间中，我们为这些类型的用户提供了良好的 "发现 "体验。另一方面，模块已经存在于文件系统中，是必然的。我们必须通过路径和文件名来解决它们，所以有一个逻辑的组织方案供我们使用。我们可以有一 个 `/collections/generic/` 文件夹，里面有一个列表模块。

命名空间对于避免全局范围内的命名冲突很重要。例如，你可能有 `My.Application.Customer.AddForm` 和 `My.Application.Order.AddForm` 两个名字相同的类型，但名字空间不同。然而，对于模块来说，这不是一个问题。在一个模块中，没有合理的理由让两个对象具有相同的名字。从消费方面来看，任何给定模块的消费者都可以选择他们将用来引用模块的名称，所以意外的命名冲突是不可能的。

### 12.12.4 红线

以下所有情况都是模块结构化的红线。如果你的文件有这些情况，请仔细检查你是否试图，对你的外部模块进行命名空间定义。

- 一个文件的唯一顶层声明是 `export namespace Foo { ... }` (移除 `Foo` ，并将所有内容 "上移 "一个级别）
- 多个文件在顶层有相同的 `export namespace Foo {` (不要以为这些文件会合并成一个 `Foo !`)

# TypeScript学习高级篇第十三章：模块解析

模块解析是编译器用来分析一个导入什么的过程。考虑一个导入语句，如 `import { a } from "moduleA"`； 为了检查对`a`的任何使用，编译器需要知道**它到底代表什么**，并需要检查它的定义`moduleA` 。

在这一点上，编译器会问 " `moduleA` 的形状是什么？" 虽然这听起来很简单，但 `moduleA` 可能被定义在你自己的一个 `.ts / .tsx` 文件中，或者在你的代码所依赖的一个 `.d.ts` 中。

首先，编译器将试图找到一个代表导入模块的文件。为了做到这一点，编译器遵循两种不同的策略之一。 [Classic](https://www.typescriptlang.org/docs/handbook/module-resolution.html#classic) or [Node](https://www.typescriptlang.org/docs/handbook/module-resolution.html#node)。这些策略告诉编译器去哪里寻找模块A。

如果这没有用，并且如果模块名称是非相对的（在 "`moduleA`" 的情况下，它是相对的），那么编译器将尝试定位一个环境模块的声明。我们接下来会讨论**非相对导入**。

最后，如果编译器不能解决该模块，它将记录一个错误。在这种情况下，错误会是这样的： `error TS2307: Cannot find module 'moduleA'`。

## 13.1 相对与非相对的模块导入

模块导入是**根据模块引用是相对的还是非相对的**来解析的。

相对导入是以 `/` 、 `./` 或 `../` 开头的导入。一些例子包括：

- `import Entry from "./components/Entry";`
- `import { DefaultHeaders } from "../constants/http";`
- `import "/mod";`

任何其他的导入都被认为是**不相关**的。一些例子包括：

- `import * as $ from 'jquery'`
- `import { Component } from "@angular/core";`

相对导入是相对于导入文件进行解析的，不能解析为环境模块的声明。你应该为你自己的模块使用相对导入，以保证在运行时保持其相对位置。

非相对导入可以相对于 `baseUrl` 来解析，也可以通过路径映射来解析，我们将在下面介绍。它们也可以解析为[环境模块声明](https://www.typescriptlang.org/docs/handbook/modules.html#ambient-modules)。当导入你的任何外部依赖时，使用**非相对路径**。

## 13.2 模块解析策略

有两种可能的模块解析策略。 **Node** 和 **Classic**。你可以使用 [moduleResolution](https://www.typescriptlang.org/tsconfig#moduleResolution) 选项来指定模块解析策略。如果没有指定，对于 `--module commonjs` ，默认为 **Node** ，否则为 **Classic**（包括 `module` 设置 为 **amd** 、 **system** 、 **umd** 、 **es2015** 、 **esnext** 等时）。

> 注意： node 模块解析是TypeScript社区中最常用的，并被推荐用于大多数项目。如果你在 TypeScript的导入和导出中遇到解析问题，可以尝试设置 `moduleResolution："node"` ，看看是 否能解决这个问题。

### 13.2.1 Classic

这曾经是TypeScript的默认解析策略。现在，这个策略主要是为了**向后兼容**而存在。

一个相对导入将被解析为相对于导入文件。所以在源文件`/root/src/folder/A.ts`中从"./moduleB "导入{ b }会导致以下查找。

所以在源文件 `/root/src/folder/A.ts` 中的 `import { b } from "./moduleB"` 查找路径如下：

1. `/root/src/folder/moduleB.ts`
2. `/root/src/folder/moduleB.d.ts`

然而，对于非相对的模块导入，编译器从包含导入文件的目录开始沿着目录树向上走，试图找到一个匹配的定义文件。

例如：

在源文件 `/root/src/folder/A.ts` 中，对于 `import { b } from "moduleB"` ，会导致尝试在以下位置找到 `"moduleB"` :

1. `/root/src/folder/moduleB.ts`
2. `/root/src/folder/moduleB.d.ts`
3. `/root/src/moduleB.ts`
4. `/root/src/moduleB.d.ts`
5. `/root/moduleB.ts`
6. `/root/moduleB.d.ts`
7. `/moduleB.ts`
8. `/moduleB.d.ts`

### 13.2.2 Node

这种解析策略试图在运行时模仿 [Node.js](https://nodejs.org/) 的模块解析机制。完整的Node.js解析算法在[Node.js模块文档](https://nodejs.org/api/modules.html#modules_all_together)中概述。

- **Node.js如何解析模块**

为了理解TS编译器将遵循哪些步骤，有必要对Node.js模块进行一些说明。传统上，Node.js的导入是通过调用一个名为 `require`的函数来完成的。Node.js采取的行为会有所不同，这取决于require是给出**相对路径**还是**非相对路径**。

相对路径是相当直接的。举个例子，让我们考虑一个位于 `/root/src/moduleA.js` 的文件，其中包含 `import var x = require("./moduleB");` 的模块导入，Node.js 按照以下顺序解析：

1. 询问名为 `/root/src/moduleB.js` 的是否存在;
2. 询问文件夹 `/root/src/moduleB` 是否包含一个名为 `package.json` 的文件，其中指定了一个 `"main"` 模块。在我们的例子中，如果Node.js发现文件 `/root/src/moduleB/package.json` 包 含 `{ "main": "lib/mainModule.js" }` ，那么Node.js将引用`/root/src/moduleB/lib/mainModule.js`;
3. 询问文件夹 `/root/src/moduleB` 是否包含一个名为 `index.js` 的文件。该文件被隐含地视为该文件夹的 "主"模块。

你可以在Node.js文档中阅读更多关于 [file模块](https://nodejs.org/api/modules.html#modules_file_modules) 模块 [folder模块](https://nodejs.org/api/modules.html#modules_folders_as_modules)的内容。

然而，非相关模块名称的解析是以不同方式进行的。Node将在名为 `node_modules` 的特殊文件夹中寻找你的模块。一个 `node_modules`文件夹可以和当前文件在同一级别，也**可以在目录链中更高的位置**。 Node将沿着目录链向上走，寻找每个 `node_modules` ，直到找到你试图加载的模块。

继续我们上面的例子，考虑一下如果 `/root/src/moduleA.js` 使用了一个非相对路径，并且有导入 `var x = require("moduleB");` 。然后，Node会尝试将 `moduleB` 解析到每一个位置，直到有一个成功：

1. `/root/src/node_modules/moduleB.js`
2. `/root/src/node_modules/moduleB/package.json` (如果 "main" 属性存在)
3. `/root/src/node_modules/moduleB/index.js`
4. `/root/node_modules/moduleB.js`
5. `/root/node_modules/moduleB/package.json` (如果 "main" 属性存在)
6. `/root/node_modules/moduleB/index.js`
7. `/node_modules/moduleB.js`
8. `/node_modules/moduleB/package.json` (如果 "main" 属性存在)
9. `/node_modules/moduleB/index.js`

注意，Node.js在步骤（4）和（7）中跳出了本目录。

你可以在Node.js文档中阅读更多关于[从 node_modules 加载模块的过程](https://nodejs.org/api/modules.html#modules_loading_from_node_modules_folders)。

- **TypeScript如何解决模块**

TypeScript将模仿Node.js的运行时解析策略，以便在编译时找到模块的定义文件。为了实现这一点，TypeScript在Node的解析逻辑上叠加了TypeScript源文件扩展名（ `.ts` 、 `.tsx` 和 `.d.ts` ）。

TypeScript还将使用 `package.json` 中一个名为 `types` 的字段来达到 `"main"` 的目的——编译器将使用它来找到 `"main` "定义文件来查阅。

例如，在 `/root/src/moduleA.ts` 中的 `import { b } from "./moduleB"` ，这样的导入语句会导致尝试在以下位置定位 `"./moduleB"` 。

1. `/root/src/moduleB.ts`
2. `/root/src/moduleB.tsx`
3. `/root/src/moduleB.d.ts`
4. `/root/src/moduleB/package.json` (如果 types 属性存在)
5. `/root/src/moduleB/index.ts`
6. `/root/src/moduleB/index.tsx`
7. `/root/src/moduleB/index.d.ts`

回顾一下，Node.js寻找一个名为 `moduleB.js` 的文件，然后寻找一个适用的 `package.json` ，然后寻找一个 `index.js` 。

同样地，一个非相对的导入将遵循Node.js的解析逻辑，首先查找一个文件，然后查找一个适用的文件 夹。因此，在源文件 `/root/src/moduleA.ts` 中的 `import { b } from "moduleB"` 导致以下查找

1. `/root/src/node_modules/moduleB.ts`
2. `/root/src/node_modules/moduleB.tsx`
3. `/root/src/node_modules/moduleB.d.ts`
4. `/root/src/node_modules/moduleB/package.json` (如果 types 属性存在)
5. `/root/src/node_modules/@types/moduleB.d.ts`
6. `/root/src/node_modules/moduleB/index.ts`
7. `/root/src/node_modules/moduleB/index.tsx`
8. `/root/src/node_modules/moduleB/index.d.ts`
9. `/root/node_modules/moduleB.ts`
10. `/root/node_modules/moduleB.tsx`
11. `/root/node_modules/moduleB.d.ts`
12. `/root/node_modules/moduleB/package.json` (如果 types 属性存在)
13. `/root/node_modules/@types/moduleB.d.ts`
14. `/root/node_modules/moduleB/index.ts`
15. `/root/node_modules/moduleB/index.tsx`
16. `/root/node_modules/moduleB/index.d.ts`
17. `/node_modules/moduleB.ts`
18. `/node_modules/moduleB.tsx`
19. `/node_modules/moduleB.d.ts`
20. `/node_modules/moduleB/package.json` (如果 types 属性存在)
21. `/node_modules/@types/moduleB.d.ts`
22. `/node_modules/moduleB/index.ts`
23. `/node_modules/moduleB/index.tsx`
24. `/node_modules/moduleB/index.d.ts`

不要被这里的步骤数量所吓倒——TypeScript仍然只是在步骤(9)和(17)上跳了两次目录。这其实并不比 Node.js本身所做的更复杂

## 13.3 额外的模块解析标志

一个项目的源代码内容有时与输出的内容不一致。通常情况下，一组构建步骤会产生最终的输出。这些步骤包括将 `.ts` 文件编译成 `.js` ，并将不同的源文件位置的依赖关系复制到一个单一的输出位置。最终的结果是，模块在运行时的名称可能与包含其定义的源文件不同。或者最终输出中的模块路径可能与编译时对应的源文件路径不一致。

TS编译器有一组额外的标志，以告知编译器预计将发生在源文件上的转换，以生成最终的输出。

值得注意的是，编译器不会执行任何这些转换；它只是使用这些信息来指导解析模块，导入到其定义文件的过程。

### 13.3.1 Base URL

在使用AMD模块加载器的应用程序中，使用 `baseUrl` 是一种常见的做法，模块在运行时被 "部署"到一个文件夹。这些模块的来源可以在不同的目录中，但构建脚本会把它们放在一起。

设置 `baseUrl` 会通知编译器在哪里找到模块。所有非相对名称的模块导入都被认为是相对于 `baseUrl` 的。

`baseUrl` 的值由以下两种情况决定:

- baseUrl 命令行参数的值（如果给定的路径是相对的，它是基于当前目录计算的）
- `tsconfig.json`中的_baseUrl_ 属性值（如果给定的路径是相对的，则根据 'tsconfig.json' 的 位置计算）

请注意，相对模块的导入不受设置 `baseUrl` 的影响，因为它们总是相对于其导入文件进行解析。

你可以在 **RequireJS** 和 **SystemJS** 文档中找到更多关于 baseUrl 的文档

### 13.3.2 路径映射

有时模块并不直接位于baseUrl下。例如，对模块 `"jquery "` 的导入会在运行时被翻译成 `"node_modules/jquery/dist/jquery.slim.min.js"` 。装载器使用映射配置在运行时将模块名称映 射到文件，见 **RequireJs** 文档和 **SystemJS** 文档。

TypeScript编译器支持使用 `tsconfig.json` 文件中的 `paths` 属性来声明这种映射关系。下面是一个例子，说明如何为`jquery`指定 `paths` 属性:

```json
{    "compilerOptions": {        "baseUrl": ".", // 如果设置 "paths"，这个必须指定。        "paths": {            "jquery": ["node_modules/jquery/dist/jquery"] // 这种映射是相对于 "baseUrl"而            指定的。        }    }}
```

请注意， `paths` 是相对于 `baseUrl` 解析的。当设置 `baseUrl` 为 `"."` 以外的其他值时，即`tsconfig.json` 的目录，映射必须相应改变。比如，你把 `"baseUrl "` 设置为 `"./src"` ，那么jquery应该被映射到 `"../node_modules/jquery/dist/jquery"`

使用 `paths` 还可以实现更复杂的映射，包括多个回退位置。考虑一个项目的配置，其中只有一些模块在一个地方可用，而其他的在另一个地方。一个构建步骤会把它们放在一个地方。项目布局可能看起来像:

```bash
projectRoot├── folder1│ ├── file1.ts (imports 'folder1/file2' and 'folder2/file3')│ └── file2.ts├── generated│ ├── folder1│ └── folder2│ └── file3.ts└── tsconfig.json
```

相应的 `tsconfig.json` 将看起来像：

```json
{    "compilerOptions": {        "baseUrl": ".",        "paths": {            "*": ["*", "generated/*"]        }    }}
```

这告诉编译器对于任何符合 `"*"` 模式的模块导入（即所有值），要在两个地方寻找：

1. `"*"` : 意思是相同的名字不变，所以映射`<moduleName>` => `<baseUrl>/<moduleName>`.
2. `"generated/*"` ：意思是模块名称有一个附加的前缀 `"generated"`，所以`<moduleName>` => `<baseUrl>/generated/<moduleName>`.

按照这个逻辑，编译器将试图将这两个导入解析为这样：

`import 'folder1/file2':`

1. 模式 `'*'`被匹配，通配符捕获了整个模块的名称。
2. 尝试列表中的第一个替换： `'*' -> folder1/file2` 。
3. 替换的结果是非相对名称——与 baseUrl 结合 -> `projectRoot/folder1/file2.ts` 。
4. 文件存在。完成了。

`import 'folder2/file3':`

1. 模式 `'*'`被匹配，通配符捕获了整个模块的名称。
2. 尝试列表中的第一个替换： `'*' -> folder2/file3`。
3. 替换的结果是非相对名称——与 baseUrl 结合 -> `projectRoot/folder2/file3.ts`。
4. 文件不存在，移到第二个替换项。
5. 第二个替换 `'generated/*'` -> `generated/folder2/file3`
6. 替换的结果是非相对名称——与baseUrl结合 -> projectRoot/generated/folder2/file3.ts
7. 文件存在。完成了。

### 13.3.3 带有`rootDirs`的虚拟目录

有时，在编译时来自多个目录的项目源都会被合并，以生成一个单一的输出目录。这可以被看作是一组源目录创建了一个 "虚拟 "目录。

使用 `rootDirs` ，你可以告知编译器构成这个 "虚拟 "目录的根；因此，编译器可以在这些 "虚拟 "目录中 解决相对模块的导入，就像它们被合并在一个目录中一样。

例如，考虑这个项目结构：

```vbnet
src└── views	└── view1.ts (imports './template1')	└── view2.ts	generated└── templates		└── views			└── template1.ts (imports './view2')
```

`src/views` 中的文件是一些UI控件的用户代码。 `generated/templates` 中的文件是由模板生成器作为构建的一部分，自动生成的UI模板绑定代码。构建步骤会将 `/src/views` 和 `/generated/templates/views` 中的文件复制到输出的同一个目录中。在运行时，一个视图可以期望它的模板存在于它的旁边，因此应该使用 `"./template "` 这样的相对名称来导入它。

为了向编译器指定这种关系，可以使用 `rootDirs` 。 `rootDirs` 指定了一个根的列表，这些根的内容在 运行时被期望合并。所以按照我们的例子， `tsconfig.json`文件应该看起来像:

```json
{    "compilerOptions": {        "rootDirs": ["src/views", "generated/templates/views"]    }}
```

每当编译器在其中一个 `rootDirs` 的子文件夹中看到一个相对的模块导入，它就会尝试在 `rootDirs` 的每个条目中寻找这个导入。

`rootDirs` 的灵活性并不局限于，指定一个在逻辑上合并的物理源代码目录的列表。提供的数组可以包括任何数量的特别的、任意的目录名称，不管它们是否存在。这允许编译器以类型安全的方式捕获复杂的捆绑和运行时特征，如条件性包含和项目特定的加载器插件。

考虑一个国际化的场景，构建工具通过插值一个特殊的路径标记，例如 `#{locale}` ，作为相对模块路径的一部分，如 `./#{locale}/messages` ，自动生成特定地域的捆绑。在这个假设的设置中，工具列举了支持的语言，将抽象的路径映射为 `./zh/messages` ， `./de/messages` ，等等。

假设这些模块中的每一个都导出一个字符串数组。例如， `./zh/messages` 可能包含：

```tsx
export default ["您好吗", "很高兴认识你"];
```

通过利用 rootDirs ，我们可以告知编译器这种映射，从而允许它安全地解析 `./# {locale}/messages` ，即使该目录永远不存在。例如，在下面的 `tsconfig.json` 中：

```tsx
{    "compilerOptions": {        "rootDirs": ["src/zh", "src/de", "src/#{locale}"]    }}
```

编译器现在会将 i`mport messages from './#{locale}/messages'` 解析为 `import messages from './zh/messages'` ，以便于在不影响设计时间支持的情况下，以与地区无关的方式开发。

## 13.4 追踪模块的解析

如前所述，编译器在解析一个模块时可以访问当前文件夹以外的文件。这在诊断为什么一个模块没有被 解析，或者被解析为一个不正确的定义时可能会很困难。使用 [traceResolution](https://www.typescriptlang.org/tsconfig#traceResolution) 启用编译器模块解析 跟踪，可以深入了解模块解析过程中发生了什么。

假设我们有一个使用 `typescript` 模块的示例应用程序。 `app.ts` 有一个类似 `import * as ts from "typescript "` 的导入。

```css
│ tsconfig.json├───node_modules│ 	└───typescript│ 	  	└───lib│ 				typescript.d.ts└───src		app.ts
```

用 traceResolution 调用编译器

```css
tsc --traceResolution
```

输出结果如下：

```delphi
======== Resolving module 'typescript' from 'src/app.ts'. ========Module resolution kind is not specified, using 'NodeJs'.Loading module 'typescript' from 'node_modules' folder.File 'src/node_modules/typescript.ts' does not exist.File 'src/node_modules/typescript.tsx' does not exist.File 'src/node_modules/typescript.d.ts' does not exist.File 'src/node_modules/typescript/package.json' does not existFile 'node_modules/typescript.ts' does not exist.File 'node_modules/typescript.tsx' does not exist.File 'node_modules/typescript.d.ts' does not exist.Found 'package.json' at 'node_modules/typescript/package.json'.'package.json' has 'types' field './lib/typescript.d.ts' that references'node_modules/typescript/lib/typescript.d.ts'.File 'node_modules/typescript/lib/typescript.d.ts' exist - use it as a moduleresolution result.======== Module name 'typescript' was successfully resolved to'node_modules/typescript/lib/typescript.d.ts'. ========
```

需要注意的事项:

- 导入的名称和位置

```bash
======== 从'src/app.ts'中解析模块'typescript'。 ========
```

- 编译器所遵循的策略是

```bash
未指定模块解析种类，使用'NodeJs'。
```

- 从npm包中加载类型

```bash
package.json'有'typescript'字段'./lib/typescript.d.ts'，引用'node_modules/typescript/lib/typescript.d.ts'。
```

- 最终结果

```bash
======== 模块名称'typescript'已成功解析为'node_modules/typescript/lib/typescript.d.ts'。========
```

## 13.5 应用 `--noResolve`

通常情况下，编译器在开始编译过程之前会尝试解析所有模块的导入。每当它成功地解析了一个文件的 导入，该文件就被添加到编译器以后要处理的文件集合中。

`noResolve` 编译器选项指示编译器不要 "添加 "任何未在命令行中传递的文件到编译中。它仍然会尝试 将模块解析为文件，但如果没有指定文件，它将不会被包括在内。

举个例子：

**app.ts**

```tsx
import * as A from "moduleA"; // 正确，'moduleA'在命令行上通过了import * as B from "moduleB"; // 错误 TS2307: 无法找到模块'moduleB'
```

```css
tsc app.ts moduleA.ts --noResolve
```

使用 `noResolve` 编译 `app.ts` 将导致：

- 正确地找到模块A，因为它是在命令行上传递的。
- 没有找到模块B，因为它没有被传递，所以出现错误。

## 13.6 常见的问题

**为什么排除列表中的模块仍然会被编译器选中？**

`tsconfig.json` 将一个文件夹变成一个 "项目"。如果不指定任何 `"exclude "` 或 `"files "` 条目，包含 `tsconfig.json` 的文件夹及其所有子目录中的所有文件都会包括在你的编译中。如果你想排除某些文件，使用 `"exclude"` ，如果你想指定所有的文件，而不是让编译器去查找它们，使用 `"files"` 。

那是 `tsconfig.json` 的自动包含。这并没有嵌入上面讨论的模块解析。如果编译器将一个文件识别为模块导入的目标，它将被包含在编译中，不管它是否在前面的步骤中被排除。

所以要从编译中排除一个文件，你需要排除它和所有有 `import` 或 `/// <reference path="..." />` 指令的文件。

# TypeScript学习高级篇第十四章：命名空间

> **关于术语的说明**：需要注意的是，在TypeScript 1.5中，术语已经改变。"**内部模块** " 现在是 "**命名空间**"。"**外部模块** "现在只是 "**模块**"，以便与 ECMAScript 2015的术语保持一致，（即 `module X {` 等同于现在的 namespace X { ）。

这篇文章概述了在TypeScript中使用命名空间（以前的 "内部模块"），用各种方法来组织你的代码。正如我们在术语说明中所暗示的，"内部模块 "现在被称为 "命名空间"。此外，在声明内部模块时，凡是使用 `module` 关键字的地方，都可以而且应该使用 `namespace` 关键字来代替。这就避免了新用户因使用类似的术语而感到困惑。

## 14.1 第一步

让我们从本页中我们将使用的程序开始。作为例子，我们写了一小套简单的字符串验证器，用来检查用户在网页中的表单中的输入，或者检查外部提供的数据文件的格式。

### 14.1.1 单一文件中的验证器

```tsx
interface StringValidator {    isAcceptable(s: string): boolean;} let lettersRegexp = /^[A-Za-z]+$/;let numberRegexp = /^[0-9]+$/; class LettersOnlyValidator implements StringValidator {    isAcceptable(s: string) {        return lettersRegexp.test(s);    }} class ZipCodeValidator implements StringValidator {    isAcceptable(s: string) {        return s.length === 5 && numberRegexp.test(s);    }} // 一些测试案例let strings = ["Hello", "98052", "101"];// 要使用的验证器let validators: { [s: string]: StringValidator } = {};validators["ZIP code"] = new ZipCodeValidator();validators["Letters only"] = new LettersOnlyValidator();// 显示每一个字符串是否通过了每个验证器for (let s of strings) {    for (let name in validators) {        let isMatch = validators[name].isAcceptable(s);        console.log(`'${s}' ${isMatch ? "matches" : "does not match"} '${name}'.`);    }} 
```

## 14.2 命名方式

当我们添加更多的验证器时，我们会希望有某种组织方案，这样我们就可以跟踪我们的类型，而不用担心与其他对象的名称冲突。与其把很多不同的名字放到全局命名空间中，不如把我们的对象包装成一个**命名空间**。

在这个例子中，我们将把所有与验证器相关的实体移到一个叫做 `Validation` 的命名空间中。因为我们希望这里的接口和类在命名空间之外是可见的，所以我们在它们前面加上 `export` 。相反，变量 `lettersRegexp` 和 `numberRegexp` 是实现细节，所以它们没有被导出，也不会被命名空间以外的代码 看到。在文件底部的测试代码中，我们现在需要限定在名字空间之外使用的类型的名称，例如 `Validation.LettersOnlyValidator` 。

## 14.3 命名的验证器

```tsx
namespace Validation {    export interface StringValidator {        isAcceptable(s: string): boolean;    }    const lettersRegexp = /^[A-Za-z]+$/;    const numberRegexp = /^[0-9]+$/;    export class LettersOnlyValidator implements StringValidator {        isAcceptable(s: string) {            return lettersRegexp.test(s);        }    }    export class ZipCodeValidator implements StringValidator {        isAcceptable(s: string) {            return s.length === 5 && numberRegexp.test(s);        }    }} // 一些测试案例let strings = ["Hello", "98052", "101"];// 要使用的验证器let validators: { [s: string]: Validation.StringValidator } = {};validators["ZIP code"] = new Validation.ZipCodeValidator();validators["Letters only"] = new Validation.LettersOnlyValidator(); // 显示每一个字符串是否通过了每个验证器for (let s of strings) {    for (let name in validators) {        console.log(            `"${s}" - ${            validators[name].isAcceptable(s) ? "matches" : "does not match"            } ${name}`        );    }}
```

## 14.4 跨文件分割

随着我们的应用程序的增长，我们将希望把代码分成多个文件，以使它更容易维护。

## 14.5 多文件命名空间

在这里，我们将把我们的 `Validation` 命名空间分成许多文件。尽管这些文件是分开的，但它们都可以为同一个命名空间做出贡献，并且可以像在一个地方定义一样被使用。由于文件之间存在依赖关系，我们将添加引用标签来告诉编译器这些文件之间的关系。我们的测试代码在其他方面没有变化。

**Validation.ts**

```tsx
namespace Validation {    export interface StringValidator {        isAcceptable(s: string): boolean;    }}
```

**LettersOnlyValidator.ts**

```tsx
/// <reference path="Validation.ts" />namespace Validation {    const lettersRegexp = /^[A-Za-z]+$/;    export class LettersOnlyValidator implements StringValidator {        isAcceptable(s: string) {            return lettersRegexp.test(s);        }    }}
```

**ZipCodeValidator.ts**

```tsx
/// <reference path="Validation.ts" />namespace Validation {    const numberRegexp = /^[0-9]+$/;    export class ZipCodeValidator implements StringValidator {        isAcceptable(s: string) {            return s.length === 5 && numberRegexp.test(s);        }    }}
```

**Test.ts**

```tsx
/// <reference path="Validation.ts" />/// <reference path="LettersOnlyValidator.ts" />/// <reference path="ZipCodeValidator.ts" />// 一些测试案例let strings = ["Hello", "98052", "101"];// 要使用的验证器let validators: { [s: string]: Validation.StringValidator } = {};validators["ZIP code"] = new Validation.ZipCodeValidator();validators["Letters only"] = new Validation.LettersOnlyValidator();// 显示每一个字符串是否通过了每个验证器for (let s of strings) {    for (let name in validators) {        console.log(            `"${s}" - ${            validators[name].isAcceptable(s) ? "matches" : "does not match"            } ${name}`        );    }}
```

一旦涉及到多个文件，我们就需要确保所有的编译后的代码都能被加载。有两种方法可以做到这一点。

首先，我们可以使用 **outFile** 选项进行串联输出，将所有的输入文件编译成一个单一的JavaScript输出文件。

```x86asm
tsc --outFile sample.js Test.ts
```

编译器将根据文件中存在的参考标签自动排列输出文件。你也可以单独指定每个文件:

```x86asm
tsc --outFile sample.js Validation.ts LettersOnlyValidator.tsZipCodeValidator.ts Test.ts
```

另外，我们也可以使用按文件编译（默认），为每个输入文件生成一个JavaScript文件。如果产生了多个JS文件，我们就需要在网页上使用`<script>`标签，以适当的顺序加载每个发射的文件，例如：

**MyTestPage.html (部分代码)**

```html
<script src="Validation.js" type="text/javascript" /><script src="LettersOnlyValidator.js" type="text/javascript" /><script src="ZipCodeValidator.js" type="text/javascript" /><script src="Test.js" type="text/javascript" />
```

## 14.6 别名

另一个可以简化命名空间工作的方法是使用 `import q = x.y.z` 来为常用对象创建更短的名称。不要与用于加载模块的 `import x = require("name")` 语法相混淆，这种语法只是为指定的符号创建一个别名。你可以为任何类型的标识符使用这类导入（通常被称为别名），包括从模块导入创建的对象。

```tsx
namespace Shapes {    export namespace Polygons {        export class Triangle {}        export class Square {}    }} import polygons = Shapes.Polygons;let sq = new polygons.Square(); // 与'new Shapes.Polygons.Square()'等价
```

注意，我们没有使用 `require` 关键字；相反，我们直接从我们要导入的符号的限定名称中分配。这类似于使用 `var` ，但也适用于导入符号的类型和命名空间的含义。重要的是，对于数值来说，导入是一个不同于原始符号的引用，所以对别名 `var` 的改变不会反映在原始变量上。

## 14.7 与其他JavaScript库一起工作

为了描述不是用TypeScript编写的库的形状，我们需要声明库所暴露的API。因为大多数JavaScript库只暴露了几个顶级对象，命名空间是表示它们的一个好方法。

我们把不定义实现的声明称为 "环境"。通常，这些都是在 `.d.ts` 文件中定义的。如果你熟悉C/C++，你可以把它们看作是 `.h` 文件。让我们来看看几个例子：

**D3.d.ts (简要摘录)**

```tsx
declare namespace D3 {    export interface Selectors {        select: {            (selector: string): Selection;            (element: EventTarget): Selection;        };    }    export interface Event {        x: number;        y: number;    }    export interface Base extends Selectors {        event: Event;    }}declare var d3: D3.Ba
```

# TypeScript学习高级篇第十五章：命名空间与模块

这篇文章概述了在TypeScript中使用模块和命名空间来组织你的代码的各种方法。我们还将讨论一些关于如何使用命名空间和模块的高级话题，并解决在TypeScript中使用它们时的一些常见陷阱。

关于ES模块的更多信息，请参见 [Modules](https://www.typescriptlang.org/docs/handbook/modules.html) 文档。更多关于TypeScript命名空间的信息，请参见[Namespaces](https://www.typescriptlang.org/docs/handbook/namespaces.html) 文档。

> 注意：在非常老的TypeScript版本中，命名空间被称为 "内部模块"，这比JavaScript模块系统要早。

## 15.1 使用模块

模块可以包含代码和声明。

模块也依赖于模块加载器（如`CommonJs/Require.js`）或支持ES模块的运行时间。模块提供了更好的代码重用，更强的隔离性和更好的捆绑工具支持。

同样值得注意的是，对于`Node.js`应用程序，模块是默认的，我们在现代代码中推荐模块而不是命名空间。

从ECMAScript 2015开始，模块是语言的原生部分，所有兼容的引擎实现都应该支持。因此，对于新项目，模块将是推荐的代码组织机制。

## 15.2 使用命名空间

命名空间是一种TypeScript特有的组织代码的方式。

命名空间是全局命名空间中简单命名的JavaScript对象。这使得命名空间的使用非常简单。与模块不同，它们可以跨越多个文件，并且可以使用 `outFile` 串联。命名空间可以成为Web应用程序中结构化代码的一个好方法，所有的依赖关系都包含在HTML页面的`<script>`标签中。

就像所有的全局命名空间污染一样，可能很难识别组件的依赖关系，特别是在一个大型应用程序中。

## 15.3 命名空间和模块的陷阱

在本节中，我们将介绍使用命名空间和模块的各种常见陷阱，以及如何避免这些陷阱。

### 15.3.1 `/// <reference>`为模块命名

一个常见的错误是试图使用 `/// <reference ... />`语法来引用一个模块文件，而不是使用 `import` 语句。为了理解这种区别，我们首先需要理解编译器是如何根据 `import` 的路径（例如，在 `import x from "...";` 中的 `...` , `import x = require("...");` 等等）路径来定位模块的类型信息。

编译器将尝试找到一个 `.ts` ， `.tsx` ，然后是一个具有适当路径的 `.d.ts` 。如果找不到一个特定的文件，那么编译器将寻找一个环境模块声明。回顾一下，这些需要在 `.d.ts` 文件中声明。

- **myModules.d.ts**

```tsx
// 在一个.d.ts文件或不是模块的.ts文件中declare module "SomeModule" {    export function fn(): string;}
```

- **myOtherModule.ts**

```tsx
/// <reference path="myModules.d.ts" />import * as m from "SomeModule";
```

这里的引用标签允许我们找到包含环境模块声明的声明文件。几个TypeScript样本使用的 `node.d.ts` 文件就是这样被消耗的。

### 15.3.2 不必要的命名方式

如果你要把一个程序从命名空间转换为模块，很容易就会出现一个看起来像这样的文件：

- `shapes.ts`

```tsx
export namespace Shapes {    export class Triangle {        /* ... */    }    export class Square {        /* ... */    }}
```

这里的顶层命名空间 `Shapes` 毫无理由地将 `Triangle` 和 `Square` 包裹起来。这让你的模块的使用者感到困惑和厌烦。

- `shapeConsumer.ts`

```tsx
import * as shapes from "./shapes";let t = new shapes.Shapes.Triangle(); // shapes.Shapes?
```

TypeScript中模块的一个关键特征是，两个不同的模块永远不会将名字贡献给同一个范围。因为模块的消费者决定给它分配什么名字，所以不需要主动将导出的符号包裹在一个命名空间中。

重申一下为什么你不应该尝试对模块内容进行命名空间，命名空间的一般想法是**提供结构体的逻辑分组**，并**防止名称碰撞**。因为模块文件本身已经是一个逻辑分组，它的顶层名称由导入它的代码定义，所以没有必要为导出的对象使用一个额外的模块层。

下面是一个修改后的例子:

- `shapes.ts`

```tsx
export class Triangle {    /* ... */}export class Square {    /* ... */}
```

- `shapeConsumer.ts`

```tsx
import * as shapes from "./shapes";let t = new shapes.Triangle();
```

### 15.3.3 模块的权衡

就像JS文件和模块之间有一对一的对应关系一样，TypeScript在模块源文件和其发射的JS文件之间有一对一的对应关系。

**这样做的一个影响是，根据你的目标模块系统，不可能串联多个模块源文件。**例如，你不能在针对 `commonjs` 或 `umd` 时使用 **outFile** 选项，但在 TypeScript 1.8 及更高版本中，在针对`amd` 或 `system` 时可以使用 **outFile** 。

# TypeScript学习高级篇第十六章： 声明合并

## 16.1 简介

TypeScript中的一些独特概念在类型层面上描述了JavaScript对象的形状。一个对TypeScript来说特别独特的例子是 **"声明合并 "**的概念。理解这个概念会让你在处理现有的JavaScript时有一个优势。它还打开了通往**更高级抽象概念**的大门。

就本文而言，"声明合并 "意味着**编译器将两个以相同名称声明的独立声明合并为一个定义**。**这个合并的定义具有两个原始声明的特征**。**任何数量的声明都可以被合并**；**它并不局限于两个声明**。

## 16.2 基本概念

在TypeScript中，声明至少在三组中的一组创建实体：**命名空间**、**类型**或**值**。创建命名空间的声明创建了一个命名空间，其中包含使用**点阵符号**访问的名称。创建类型的声明就是这样做的：它们创建了一个类型，这个类型在声明的形状下是可见的，并与给定的名称绑定。最后，创建值的声明会创建在输出的 JavaScript中可见的值。

|声明类型|NameSpace|Type|Value|
|---|---|---|---|
|NcameSpace|×||×|
|Class||×|×|
|Enum||×|×|
|Interface||×||
|Type Alias||×||
|Function|||×|
|Variable|||×|

了解每个声明所创建的内容将有助于你理解当你执行声明合并时被合并的内容

## 16.3 合并接口

最简单的，也许也是最常见的声明合并类型是接口合并。在最基本的层面上，合并是将两个声明中的成员机械地连接到一个具有相同名称的单一接口中。

```tsx
interface Box {    height: number;    width: number;}interface Box {    scale: number;}let box: Box = { height: 5, width: 6, scale: 10 };
```

接口的非功能成员应该是唯一的。如果它们不是唯一的，它们必须是同一类型的。如果接口都声明了同名的非功能成员，但类型不同，编译器会发出错误。

对于函数成员，**每个同名的函数成员都被视为描述同一个函数的重载**。同样值得注意的是，在接口 A 与后来的接口 A 合并的情况下，第二个接口将比第一个接口有更高的优先权。

就是说，在这个例子中:

```tsx
interface Cloner {    clone(animal: Animal): Animal;}interface Cloner {    clone(animal: Sheep): Sheep;}interface Cloner {    clone(animal: Dog): Dog;    clone(animal: Cat): Cat;}
```

这三个接口将合并成一个单一的声明，如下：

```tsx
interface Cloner {    clone(animal: Dog): Dog;    clone(animal: Cat): Cat;    clone(animal: Sheep): Sheep;    clone(animal: Animal): Animal;}
```

请注意，每个组的元素保持相同的顺序，但组本身是合并的，后来的重载组先排序。

这一规则的一个例外是专门的签名。如果一个签名有一个参数的类型是单一的字符串字面类型（例如，不是字符串字面的联合），那么它将被冒泡在其合并的重载列表的顶部。

例如，以下接口将合并在一起:

```tsx
interface Document {    createElement(tagName: any): Element;}interface Document {    createElement(tagName: "div"): HTMLDivElement;    createElement(tagName: "span"): HTMLSpanElement;}interface Document {    createElement(tagName: string): HTMLElement;    createElement(tagName: "canvas"): HTMLCanvasElement;}
```

合并后的 document 声明将如下：

```tsx
interface Document {    createElement(tagName: "canvas"): HTMLCanvasElement;    createElement(tagName: "div"): HTMLDivElement;    createElement(tagName: "span"): HTMLSpanElement;    createElement(tagName: string): HTMLElement;    createElement(tagName: any): Element;}
```

## 16.4 合并命名空间

与接口类似，同名的命名空间也会合并其成员。由于命名空间同时创建了一个命名空间和一个值，我们需要了解两者是如何合并的。

为了合并命名空间，每个命名空间中声明的导出接口的类型定义本身也被合并，形成一个单一的命名空间，里面有合并的接口定义。

为了合并名字空间的值，在每个声明地点，如果已经存在一个给定名字的名字空间，那么它将被进一步扩展，方法是利用现有的名字空间，将第二个名字空间的导出成员添加到第一个名字空间中。

在这个例子中， `Animals` 的声明合并：

```tsx
namespace Animals {    export class Zebra {}} namespace Animals {    export interface Legged {        numberOfLegs: number;    }    export class Dog {}}
```

相当于：

```tsx
namespace Animals {    export interface Legged {        numberOfLegs: number;    }    export class Zebra {}    export class Dog {}}
```

这种命名空间合并的模式是一个有用的起点，但是我们还需要了解非导出成员的情况。**非导出的成员只在原始（未合并的）命名空间中可见**。这意味着在合并后，**来自其他声明的合并成员不能看到非导出成员**。

我们可以在这个例子中更清楚地看到这一点：

```tsx
namespace Animal {    let haveMuscles = true;    export function animalsHaveMuscles() {        return haveMuscles;    }}namespace Animal {    export function doAnimalsHaveMuscles() {        return haveMuscles; // 错误，因为这里无法访问haveMuscles。    }}
```

因为 `haveMuscles` 没有被导出，所以只有共享同一未合并命名空间的 `animalsHaveMuscles` 函数可以看到这个符号。 `doAnimalsHaveMuscles` 函数，即使它是合并后的 `Animal` 命名空间的一部分，也 不能看到这个未输出的成员。

### 16.4.1 将命名空间与类、函数和枚举合并起来

命名空间足够灵活，也可以与其他类型的声明合并。要做到这一点，**命名空间声明必须跟在它要合并的声明后面。**由此产生的声明具有两种声明类型的属性。TypeScript使用这种能力来模拟JavaScript以及其他编程语言中的一些模式。

### 16.4.2 将命名空间与类合并

这给了用户一种描述内部类的方法。

```tsx
class Album {    label: Album.AlbumLabel;}namespace Album {    export class AlbumLabel {}}
```

合并成员的可见性规则与合并命名空间一节中描述的相同，所以我们必须导出 `AlbumLabel` 类，以便合并后的类能看到它。最终的结果是一个类在另一个类里面管理。你也可以使用命名空间来为现有的类添加更多的静态成员。

除了内部类的模式外，你可能也熟悉JavaScript的做法，即创建一个函数，然后通过在函数上添加属性来进一步扩展该函数。TypeScript使用声明合并，以类型安全的方式建立这样的定义。

```tsx
function buildLabel(name: string): string {    return buildLabel.prefix + name + buildLabel.suffix;} namespace buildLabel {    export let suffix = "";    export let prefix = "Hello, ";}console.log(buildLabel("Sam Smith"));
```

同样地，命名空间可以用来扩展具有静态成员的枚举。

```tsx
enum Color {    red = 1,    green = 2,    blue = 4,}namespace Color {    export function mixColor(colorName: string) {        if (colorName == "yellow") {            return Color.red + Color.green;        } else if (colorName == "white") {            return Color.red + Color.green + Color.blue;        } else if (colorName == "magenta") {            return Color.red + Color.blue;        } else if (colorName == "cyan") {            return Color.green + Color.blue;        }    }}
```

### 16.4.3 不被允许的合并

不是所有的合并在TypeScript中都是允许的。目前，类不能与其他类或变量合并。关于模仿类合并的信息，请参阅 [Mixins in TypeScript](https://www.cnblogs.com/bleaka/p/16118452.html) 部分。

## 16.5 模块增强

虽然JavaScript模块不支持合并，但你可以通过导入然后更新现有对象来打补丁。让我们来看看一个玩具 `Observable` 的例子

```tsx
// observable.tsexport class Observable<T> {    // ...}  // map.tsimport { Observable } from "./observable";Observable.prototype.map = function (f) {    // ...};
```

这在TypeScript中也能正常工作，但编译器不知道 `Observable.prototype.map` 。你可以使用模块增强来告诉编译器它的存在。

```tsx
// observable.tsexport class Observable<T> {    // ... implementation left as an exercise for the reader ...} // map.tsimport { Observable } from "./observable";declare module "./observable" {    interface Observable<T> {        map<U>(f: (x: T) => U): Observable<U>;    }} Observable.prototype.map = function (f) {    // ... another exercise for the reader}; // consumer.tsimport { Observable } from "./observable";import "./map";let o: Observable<number>;o.map((x) => x.toFixed());
```

模块名称的解析方式与 `import / export` 中的模块指定器相同。更多信息请参见 [Modules](https://www.typescriptlang.org/docs/handbook/modules.html) 。然后，增量中的声明被合并，就像它们与原始文件在同一个文件中声明一样。

然而，有两个限制需要记住：

1. **你不能在扩增中声明新的顶层声明--只是对现有声明的补丁**。
2. **默认出口也不能被增强**，只能是命名的出口（因为你需要用出口的名字来增强出口，而`default`是一个保留词--详见 [#14080](https://github.com/Microsoft/TypeScript/issues/14080) )

## 16.6 全局增强

你也可以从一个模块内部向全局范围添加声明。

```tsx
// observable.tsexport class Observable<T> {    // ... still no implementation ...} declare global {    interface Array<T> {        toObservable(): Observable<T>;    }} Array.prototype.toObservable = function () {    // ...};
```

全局增强的行为和限制与模块增强相同。

分类: [TypeScript](https://www.cnblogs.com/bleaka/category/2126678.html)

好文要顶 关注我 收藏该文 微信分享

[![](https://pic.cnblogs.com/face/2550942/20210917165954.png)](https://home.cnblogs.com/u/bleaka/)

[bleaka](https://home.cnblogs.com/u/bleaka/)  
[粉丝 - 7](https://home.cnblogs.com/u/bleaka/followers/) [关注 - 2](https://home.cnblogs.com/u/bleaka/followees/)  

+加关注

0

0

[升级成为会员](https://cnblogs.vip/)

[«](https://www.cnblogs.com/bleaka/p/16095547.html) 上一篇： [TypeScript学习文档-基础篇（完结）](https://www.cnblogs.com/bleaka/p/16095547.html "发布于 2022-04-03 12:06")  
[»](https://www.cnblogs.com/bleaka/p/16123393.html) 下一篇： [TypeScript装饰器Decorators学习](https://www.cnblogs.com/bleaka/p/16123393.html "发布于 2022-04-11 18:01")

posted @ 2022-04-08 17:20  [bleaka](https://www.cnblogs.com/bleaka)  阅读(867)  评论(0)  [编辑](https://i.cnblogs.com/EditPosts.aspx?postid=16118452)  收藏  举报

[会员力量，点亮园子希望](https://cnblogs.vip/)

[刷新页面](https://www.cnblogs.com/bleaka/p/16118452.html#)[返回顶部](https://www.cnblogs.com/bleaka/p/16118452.html#top)

登录后才能查看或发表评论，立即 登录 或者 [逛逛](https://www.cnblogs.com/) 博客园首页

[【推荐】这场阿里云开发者社区有奖征文活动，期待您出文相助](https://www.cnblogs.com/cmt/p/18226431)  
[【推荐】三生石上：ASP.NET Core中运行WebForms业务代码](https://www.cnblogs.com/sanshi/p/18186007)  
[【推荐】通义灵码：灵动指间，快码加编，你的智能编码助手](https://tongyi.cnblogs.com/)  
[【推荐】凡泰极客：跨越技术“鸿”沟，小程序一键生成鸿蒙App](https://www.finclip.com/?channel=cnblog2024)  
[【推荐】阿里云创新加速季，5亿补贴享不停，上云礼包抢先领](https://click.aliyun.com/m/1000394160/)  

[![](https://img2024.cnblogs.com/blog/35695/202405/35695-20240529225347158-1507288531.jpg)](https://www.cnblogs.com/cmt/p/18219378)

**编辑推荐：**  
· [网关限流功能性能优化](https://www.cnblogs.com/wsss/p/18231400)  
· [零基础写框架(2)：故障排查和日志基础](https://www.cnblogs.com/whuanle/p/18232144)  
· [初探富文本之基于虚拟滚动的大型文档性能优化方案](https://www.cnblogs.com/WindrunnerMax/p/18227998)  
· [RabbitMQ 进阶使用之延迟队列：订单在30分钟之内未支付则自动取消](https://www.cnblogs.com/youzhibing/p/18226063)  
· [生产事故 - 误删文件开发运维险被同时开除](https://www.cnblogs.com/mylibs/p/18227455/production-accident-0004)  

**阅读排行：**  
· [C#.Net筑基-String字符串超全总结 [深度好文]](https://www.cnblogs.com/anding/p/18221262)  
· [C# .NET 6 使用WorkFlow Core 创建工作审批流](https://www.cnblogs.com/BFMC/p/18233359)  
· [C#/.NET/.NET Core优秀项目和框架2024年5月简报](https://www.cnblogs.com/Can-daydayup/p/18236262)  
· [阿里400+天，我为什么离开阿里](https://www.cnblogs.com/cuzzz/p/18237070)  
· [互联网大厂的缓存策略：抵抗超高并发的秘密武器，已开源！](https://www.cnblogs.com/binghe001/p/18236464)  

### 公告

昵称： [bleaka](https://home.cnblogs.com/u/bleaka/)  
园龄： [2年8个月](https://home.cnblogs.com/u/bleaka/ "入园时间：2021-09-17")  
粉丝： [7](https://home.cnblogs.com/u/bleaka/followers/)  
关注： [2](https://home.cnblogs.com/u/bleaka/followees/)

+加关注

|   |   |   |   |   |   |   |
|---|---|---|---|---|---|---|
|\|   \|   \|   \|<br>\|---\|---\|---\|<br>\|<\|2024年6月\|>\||   |   |   |   |   |   |
|日|一|二|三|四|五|六|
|26|27|28|29|30|31|1|
|2|3|4|5|6|7|8|
|9|10|11|12|13|14|15|
|16|17|18|19|20|21|22|
|23|24|25|26|27|28|29|
|30|1|2|3|4|5|6|

### 搜索

 

### [我的标签](https://www.cnblogs.com/bleaka/tag/)

- [Javascript(1)](https://www.cnblogs.com/bleaka/tag/Javascript/)
- [DOM(1)](https://www.cnblogs.com/bleaka/tag/DOM/)

### [随笔分类](https://www.cnblogs.com/bleaka/post-categories)

- [ANTD(2)](https://www.cnblogs.com/bleaka/category/2061969.html)
- [Canvas(1)](https://www.cnblogs.com/bleaka/category/2144091.html)
- [Electron(1)](https://www.cnblogs.com/bleaka/category/2149768.html)
- [Element UI(1)](https://www.cnblogs.com/bleaka/category/2100086.html)
- [Hooks(5)](https://www.cnblogs.com/bleaka/category/2116276.html)
- [NodeJs(1)](https://www.cnblogs.com/bleaka/category/2149769.html)
- [REACT(7)](https://www.cnblogs.com/bleaka/category/2061968.html)
- [ReactRouter(1)](https://www.cnblogs.com/bleaka/category/2119399.html)
- [Table(1)](https://www.cnblogs.com/bleaka/category/2061970.html)
- [TypeScript(7)](https://www.cnblogs.com/bleaka/category/2126678.html)
- [Vue(2)](https://www.cnblogs.com/bleaka/category/2100084.html)
- [Webpack(1)](https://www.cnblogs.com/bleaka/category/2112137.html)
- [WIN10操作小技巧(1)](https://www.cnblogs.com/bleaka/category/2134293.html)

### 随笔档案

- [2022年4月(5)](https://www.cnblogs.com/bleaka/p/archive/2022/04)
- [2022年3月(7)](https://www.cnblogs.com/bleaka/p/archive/2022/03)
- [2022年2月(2)](https://www.cnblogs.com/bleaka/p/archive/2022/02)
- [2022年1月(3)](https://www.cnblogs.com/bleaka/p/archive/2022/01)
- [2021年12月(1)](https://www.cnblogs.com/bleaka/p/archive/2021/12)
- [2021年11月(1)](https://www.cnblogs.com/bleaka/p/archive/2021/11)
- [2021年9月(5)](https://www.cnblogs.com/bleaka/p/archive/2021/09)

### [文章分类](https://www.cnblogs.com/bleaka/article-categories)

- [DOM(2)](https://www.cnblogs.com/bleaka/category/2032745.html)
- [TypeScript(6)](https://www.cnblogs.com/bleaka/category/2122649.html)
- [VUE(1)](https://www.cnblogs.com/bleaka/category/2063066.html)

### [阅读排行榜](https://www.cnblogs.com/bleaka/most-viewed)

- [1. WIN10便签开机自启动(5389)](https://www.cnblogs.com/bleaka/p/16071109.html)
- [2. 函数式组件中实现Antd打开Modal后其Input框自动聚焦(focus)到文字的最后 (4459)](https://www.cnblogs.com/bleaka/p/15994761.html)
- [3. TypeScript学习文档-基础篇（完结）(3147)](https://www.cnblogs.com/bleaka/p/16095547.html)
- [4. Electron结合React和TypeScript进行开发(2745)](https://www.cnblogs.com/bleaka/p/16184636.html)
- [5. REACT 使用antd Table 中rowSelection遇到的问题(2521)](https://www.cnblogs.com/bleaka/p/15552708.html)

### [评论排行榜](https://www.cnblogs.com/bleaka/most-commented)

- [1. React 函数式组件使用props传参作为state的注意项(2)](https://www.cnblogs.com/bleaka/p/15990503.html)
- [2. React函数类组件及其Hooks学习(2)](https://www.cnblogs.com/bleaka/p/15947784.html)

### [推荐排行榜](https://www.cnblogs.com/bleaka/most-liked)

- [1. Electron结合React和TypeScript进行开发(3)](https://www.cnblogs.com/bleaka/p/16184636.html)
- [2. canvas基础简单易懂教程（完结，多图）(1)](https://www.cnblogs.com/bleaka/p/16143470.html)
- [3. WIN10便签开机自启动(1)](https://www.cnblogs.com/bleaka/p/16071109.html)
- [4. 函数式组件中实现Antd打开Modal后其Input框自动聚焦(focus)到文字的最后 (1)](https://www.cnblogs.com/bleaka/p/15994761.html)
- [5. React 函数组件中对window添加事件监听resize导致回调不能获得Hooks最新状态的问题解决思路(1)](https://www.cnblogs.com/bleaka/p/15954518.html)

### [最新评论](https://www.cnblogs.com/bleaka/comments)

- [1. Re:React 函数式组件使用props传参作为state的注意项](https://www.cnblogs.com/bleaka/p/15990503.html)
- @xclidongbo 当然可以，全局状态也比较合适。...
- --bleaka
- [2. Re:React 函数式组件使用props传参作为state的注意项](https://www.cnblogs.com/bleaka/p/15990503.html)
- 不用redux呢？
    
- --xclidongbo
- [3. Re:React函数类组件及其Hooks学习](https://www.cnblogs.com/bleaka/p/15947784.html)
- @热心市民~菜先生 谢谢夸奖，好久之前写的，嘿嘿。...
- --bleaka
- [4. Re:React函数类组件及其Hooks学习](https://www.cnblogs.com/bleaka/p/15947784.html)
- 写的很好
    
- --热心市民~菜先生

Copyright © 2024 bleaka  
Powered by .NET 8.0 on Kubernetes