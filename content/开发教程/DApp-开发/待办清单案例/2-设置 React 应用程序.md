---
title: 2-设置 React 应用程序
---
# 设置 React 应用程序

这是关于在 Aptos 上构建端到端 dapp 的教程的第二章，你已经创建了一个智能合约，现在正在设置一个 React 应用程序。

## 设置应用程序

我们将使用 `react` 库通过 `Create React App` 构建客户端。

对于用户界面，我们将使用 `Ant Design`。这只是个人决定；你完全可以使用任何其他你希望的 UI 库/框架。

在 `my-first-dapp` 项目的根文件夹中，运行：

```bash
npx create-react-app client --template typescript
```

这将在当前路径中创建一个新的 `client` 文件夹：

你的文件结构应该看起来像这样：

```bash
.
├── client
└── move
```

运行：

```rust
cd client
npm start
```

此时你应该能够在 http://localhost:3000 上运行你的应用程序，它显示了默认的 React 布局。

在 `client/src` 目录中，找到所有的 `React` 应用程序文件。让我们稍微清理一下。

打开 `App.tsx` 文件并更新其内容为：

```ts
function App() {
  return <div>我的应用在这里</div>;
}

export default App;
```

一旦你保存了更改，你应该会看到应用程序的内容在浏览器中已经更改，并显示“我的应用在这里”。

打开` App.tsx` 文件并删除 `import './App.css';` 和 `import logo from './logo.svg';` 这两行。由于我们移除了这个文件的默认导入，我们可以删除项目中的一些文件。删除 `App.css` 和 `logo.svg` 文件。

打开 `index.tsx` 文件并在文件顶部删除 `import './index.css';` 这一行。现在你也可以删除 `src/index.css` 文件。

## 我们的 dapp 用户界面

首先，我们将构建 dapp 用户界面布局。应用程序有两个用户界面状态：

- 当一个账户还没有创建列表时（在左边）。
- 当一个账户已经创建了列表，现在可以向其中添加任务时（在右边）。

![image](https://aptos.dev/assets/images/build-e2e-dapp-img-3-4c39d270f2b788de062ca26db99610f7.png)

我们将为用户界面使用 `Ant Design` 库：

如果正在运行，请停止本地服务器。

转到 client 目录并安装我们的 UI 库包：

```bash
npm i antd@5.1.4
```

更新 `App.tsx`，使用初始状态 UI：

```tsx
return (
  <>
    <Layout>
      <Row align="middle">
        <Col span={10} offset={2}>
          <h1>Our todolist</h1>
        </Col>
        <Col span={12} style={{ textAlign: "right", paddingRight: "200px" }}>
          <h1>Connect Wallet</h1>
        </Col>
      </Row>
    </Layout>
  </>
);
```

不要忘记导入我们刚刚添加的组件：

```ts
import { Layout, Row, Col } from "antd";
```

运行本地服务器：

```bash
npm start 
```

你应该能看到与我们的 UI 模型匹配的标题。

现在是时候在第三章中[添加钱包支持](3-添加钱包支持.md)了。