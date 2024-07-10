---
title: aptos 钱包选择器
---
# Aptos 钱包适配器选择器 Ant Design

用于使用[Ant Design](https://ant.design/)的钱包选择器模态窗口的包。当点击时包括一个“钱包连接”按钮，会打开一个“钱包选择模态窗口”。

如果钱包已经连接，该按钮将显示截断式的已连接账户地址（例如 `0x123...abc`），在这种情况下，点击该按钮将断开钱包连接。

### 用法

确保您已安装[@aptos-labs/wallet-adapter-react](https://github.com/aptos-labs/aptos-wallet-adapter/blob/main/packages/wallet-adapter-react/README.md)

```bash
npm install @aptos-labs/wallet-adapter-ant-design
```

在 `index.tsx` / `_app.tsx` 中导入 `ant-design` 包的 `.css` 文件，如下所示：

```tsx
// 如果您在应用程序中使用本地的 css 文件，请在导入包的文件之前导入，因为顺序很重要
import "./my-style-file.css";

import "@aptos-labs/wallet-adapter-ant-design/dist/index.css";
```

在您想要包含“钱包连接”按钮的页面上，导入 `WalletSelector` 模块。

```tsx
import { WalletSelector } from "@aptos-labs/wallet-adapter-ant-design";
...
return (
  <WalletSelector />
)
```

这将添加一个“连接钱包”按钮，点击时会打开一个“钱包选择器”模态窗口。

#### 覆盖样式

您可以覆盖这些类

```
.wallet-selector-modal
.wallet-selector-icon
.wallet-selector-text
.wallet-menu-wrapper
.wallet-name-wrapper
.wallet-connect-button
.wallet-connect-install
.wallet-button
.wallet-modal-title
.aptos-connect-button
.aptos-connect-privacy-policy-wrapper
.aptos-connect-privacy-policy-text
.aptos-connect-privacy-policy-link
.aptos-connect-powered-by
```

例如，要覆盖“连接钱包”按钮的背景颜色，您可以在本地 `.css` 文件中使用 `.wallet-button` 类

```
.wallet-button{
  background-color: red;
}
```

[![walletSelector](https://github.com/aptos-labs/aptos-wallet-adapter/raw/main/walletselector.png)
