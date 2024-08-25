# [React报错之Invalid hook call](https://www.cnblogs.com/chuckQu/p/16622367.html "发布于 2022-08-24 21:33")

正文从这开始~

## 总览

导致"Invalid hook call. Hooks can only be called inside the body of a function component"错误的有多种原因：

1. `react`和`react-dom`的版本不匹配。
2. 在一个项目中有多个`react`包版本。
3. 试图将一个组件作为一个函数来调用，例如，`App()`而不是`<App />`。
4. 在类里面使用钩子，或者在不是组件或自定义钩子的函数中使用钩子。

![invalid-hook-call-hooks-can-only-be-called.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/6600863158bf40aaba0b79ef007bce43~tplv-k3u1fbpfcp-watermark.image?)

## 版本匹配

在项目的根目录下打开终端，更新`react`和`react-dom`包的版本，确保版本是相匹配的，并且没有使用过时的版本。

```sh
# 👇️ with NPM
npm install react@latest react-dom@latest

# 👇️ ONLY If you use TypeScript
npm install --save-dev @types/react@latest @types/react-dom@latest

# ----------------------------------------------

# 👇️ with YARN
yarn add react@latest react-dom@latest

# 👇️ ONLY If you use TypeScript
yarn add @types/react@latest @types/react-dom@latest --dev
```

如果错误仍存在，尝试删除`node_modules`以及`package-lock.json`（不是`package.json`）文件，重新运行`npm install` 并重启你的IDE。

这个错误通常是由于在同一个项目中拥有多个版本的`react`造成的。

```sh
# 👇️ delete node_modules and package-lock.json
rm -rf node_modules
rm -f package-lock.json

# 👇️ clean npm cache
npm cache clean --force

npm install
```

> 如果错误仍然存在，请确保重启了IDE和开发服务。VSCode经常出现故障，需要重启。

## 调用组件

这里有另一个示例，用来展示错误是如何发生的。

```jsx
// App.js
import {useState} from 'react';

// 👇️ Don't call components as functions 👇️
App();

export default function App() {
  /**
   * ⛔️ Warning: Invalid hook call. Hooks can only be
   * called inside of the body of a function component.
   *  This could happen for one of the following reasons:
1. You might have mismatching versions of React and the renderer (such as React DOM)
2. You might be breaking the Rules of Hooks
3. You might have more than one copy of React in the same app
   */
  const [count, setCount] = useState(0);

  return (
    <div>
      <h1>Hello world</h1>
    </div>
  );
}
```

> 问题在于，我们将`App`组件作为函数进行调用。

你应该只使用具有JSX语法的组件。比如：`<App country="Austria" age="30" />`，而不是`App({country: 'Austria', age: 30})`。

> 确保你没有在一个类组件，或一个既不是组件也不是自定义钩子的函数里面调用钩子。

如果你有一个类，请将其转换为能够使用钩子的函数。

下面是一个例子，说明在一个既不是组件也不是自定义钩子的函数中是如何引起错误的。

```jsx
// App.js
import {useState, useEffect} from 'react';

// 👇️ not a component nor custom hook
// so it can't use hooks
function counter() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    console.log('hello world');
  }, []);
}
```

`counter`函数以小写的`c`开头，所以它不被React认为是一个组件。因为所有的组件名称必须以大写字母开头。它同样也不是自定义钩子，因为其名称没有以`use`开头，比如说`useCounter`。

我们只能在函数组件或自定义钩子里面使用钩子，所以能够使用钩子的一个方法是将`counter`重命名为`useCounter`。

```jsx
import {useState, useEffect} from 'react';

function useCounter() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    console.log('hello world');
  }, []);
}
```

现在React认为`useCounter`是一个自定义钩子，并允许我们在里面使用钩子。

就像文档中所说的那样：

- 只从React函数组件或自定义钩子中调用Hook
- 只在最顶层使用 Hook
- 不要在循环，条件或嵌套函数中调用 Hook
- 确保总是在你的 React 函数的最顶层以及任何 return 之前使用 Hook
