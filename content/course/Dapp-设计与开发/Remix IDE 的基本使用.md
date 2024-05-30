---
title: Remix IDE 的基本使用
---
建议使用网页版[Remix](https://remix.ethereum.org)，因为会实时更新，并且可以快速链接 metamask


# 本地开发

1. 安装 Remixd

```bash
npm install -g @remix-project/remixd
```

2. 共享项目给 Remix 
```bash
remixd -s <absolute-path-to-the-shared-folder> --remix-ide https://remix.ethereum.org
```

3. 在 Remix 中将 `workspace` 切换到 `localhost`

>[!NOTE]
> 网页上的修改会直接覆盖本地的内容，但是本地的修改不会直接覆盖，而是会提示你是替换还是保留。


# 克隆别人的代码到自己的仓库

例如：

USDT： https://etherscan.io/token/0xdac17f958d2ee523a2206206994597c13d831ec7

1. 创建一个文件
2. 复制 USDT 的代码到文件里
![image-20240530111011335](https://mielgo-markdown.oss-cn-chengdu.aliyuncs.com/image-20240530111011335.png)

3. 连接到 MetaMask

4. 选择合约类型

5. 输入合约地址

![image-20240530111109236](https://mielgo-markdown.oss-cn-chengdu.aliyuncs.com/image-20240530111109236.png)

等待账户地址上的加载图标结束后，就可以直接开始与 USDT 交互了。