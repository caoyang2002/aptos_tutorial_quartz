---
title: keyless 实现
---
# 1. 介绍

无密钥账户在 Aptos 生态系统中代表着一项关键的进步，彻底改变了用户加入并与去中心化应用程序（dApps）交互的方式。Aptos 无密钥允许用户从其现有的 OpenID Connect（OIDC）账户（例如，使用 Google 登录；使用 Apple 登录）获得 Aptos 区块链账户的所有权，而不是从传统的密钥或助记词。简而言之，在使用 Aptos 无密钥时，用户的区块链账户即为他们的 OIDC 账户。随着时间的推移，无密钥将发展为支持许多支持 OIDC 标准的身份提供商（IdP），但我们将从支持[此处](https://aptos.dev/en/build/guides/aptos-keyless/oidc-support)列出的提供商开始。

无密钥账户模式的核心是对传统区块链系统中普遍存在的用户体验和安全挑战有深刻的理解。管理私钥，作为用户身份和资产所有权的基石，对于用户来说往往是繁琐且容易出错的，特别是那些缺乏技术专业知识的用户。无密钥账户通过使用户能够通过常见的社交登录选项（如 Google、Apple 等）进行身份验证，提供了一个优雅的解决方案，从而无需用户应对私钥管理的复杂性。随着这个新系统的出现，在您的应用程序中实现无密钥之前，您需要代表您的用户了解一些重要的权衡。以下页面将详细介绍无密钥账户的好处、如何集成、系统架构和常见问题。有关无密钥账户的更详细和技术性的深入探讨，请参阅[AIP-61-无密钥账户](https://github.com/aptos-foundation/AIPs/blob/main/aips/aip-61.md)。

在 Aptos 生态系统中，与无密钥账户进行交互有两种方式。开发人员能够要么 1）将 Aptos 无密钥 SDK 直接集成到他们的 dApp 中，要么 2）集成一个支持无密钥账户创建的钱包，如 Aptos Connect。本文档将重点关注第一种情况，关于第二种情况的更多详细信息可以在此处找到。请注意，直接集成无密钥 SDK 将导致用户账户特定于您的 dApp，而使用钱包集成将允许您的用户将其账户带到任何支持该钱包的应用程序中。

注意：Aptos 无密钥 SDK 和 Aptos Connect 是上述产品体验的代表性示例，但我们生态系统中的开发人员正在构建替代方案，如无密钥 Unity SDK 和具有无密钥集成的替代钱包产品。

## 1.1 Aptos 无密钥的好处

无密钥账户对用户来说具有革命性意义，原因如下：

1. **简化的登录用户体验**：通过熟悉的 Web2 登录（如使用 Google 登录）实现“一键式”账户创建。
2. **增强的 dApp 用户体验**：能够在 Aptos 区块链上进行交易，而无需离开应用程序体验去下载钱包。
3. **安全的密钥管理**：用户无需手动管理密钥。用户使用 OIDC 提供商颁发的 JSON Web Token（JWT）令牌签署交易。因此，区块链账户访问与访问用户的 OIDC 账户是同义词。
4. **改进的账户恢复**：如果用户失去对其 OIDC 账户的访问权限，可以使用类似 Web2 的恢复流程重新获得对其区块链账户的访问权限。
5. **无缝的跨设备体验**：用户无论在什么设备上都可以使用其 OIDC 账户登录 - 无需在每个设备上下载钱包软件、导入密钥并用密码加密，并且必须维护密码。

伴随着这些好处，开发人员需要注意无密钥账户的一些重要结构组件。您可以在我们的常见问题解答中了解更多相关内容。




# 2. 配置您的 OIDC 提供商

Aptos 无密钥在我们的网络中支持以下身份提供商（IdP）。未来将会支持更多的 IdP。如果您有特定用例的覆盖需求，请联系我们。

| 身份提供商 | 开发网    | 测试网 | 主网 |
| ------------- | --------- | ------- | ------- |
| Google        | 已上线      | 已上线    | 已上线    |
| Apple         | 已上线      | 已上线    | -       |
| Microsoft     | 审核中      | -       | -       |
| Github        | 审核中      | -       | -       |
| Facebook      | 审核中      | -       | -       |

要将 Aptos 无密钥集成到您的 dApp 中，您必须通过其 OIDC 注册流程在至少一个可用的身份提供商那里注册您的 dApp。每个相应的注册流程都会为您的应用程序分配一个客户端 ID，这将在无密钥架构中作为您应用程序的标识符。

## 2.1 在 Google 上注册您的 dApp

### 步骤 1：登录到 Google 开发者控制台

1. 导航到[Google Cloud Console](https://console.cloud.google.com/)。
2. 使用您的 Google 帐户凭据登录。

### 步骤 2：创建一个新项目

1. 如果您没有现有项目，请点击页面顶部的“选择项目”下拉菜单，然后选择“新项目”。
2. 为您的项目输入名称，然后点击“创建”。详细说明可在[这里](https://cloud.google.com/resource-manager/docs/creating-managing-projects#creating_a_project)找到。

### 步骤 3：配置同意屏幕

1. 在左侧边栏中，导航到“APIs & Services”>“OAuth 同意屏幕”。
2. 选择“外部”用户类型，然后点击“创建”。
3. 输入所需的详细信息，如应用程序名称、用户支持电子邮件和开发人员联系信息。
4. 可选地，添加其他详细信息，如应用程序徽标和隐私政策 URL。
5. 点击“保存并继续”。详细步骤可在[这里](https://developers.google.com/workspace/guides/create-credentials#configure_the_oauth_consent_screen)找到。

### 步骤 4：注册您的应用程序

1. 在左侧边栏中，导航到“APIs & Services”>“Credentials”。![[../Images/Google Credentials 导航截图.png]]
2. 点击“创建凭据”，然后选择“OAuth 客户端 ID”。![[../Images/Google 创建凭据截图.png]]
4. 输入必要的详细信息，如您的应用程序名称和授权重定向 URI。对于 OIDC，重定向 URI 应遵循格式 `https://your-app-domain.com/auth/google/callback。`
5. 点击“创建”。

### 步骤 5：获取客户端 ID 和客户端密钥

1. 创建 OAuth 客户端 ID 后，Google 将为您提供客户端 ID 和客户端密钥。这些凭据对于验证您的应用程序至关重要。
2. 安全地记录下客户端 ID 和客户端密钥。不要公开暴露它们。

### 步骤 6：在您的应用程序中配置 OIDC 集成

1. 使用合适的 OIDC 库或框架（例如，Node.js 的 Passport.js、Java 的 Spring Security 或各种平台的 Auth0）将 OIDC 身份验证集成到您的应用程序中。
2. 使用从 Google 获得的客户端 ID 和客户端密钥在您的应用程序设置中配置 OIDC 身份验证。
3. 设置适当的回调 URL（https://your-app-domain.com/auth/google/callback）以处理来自 Google 的身份验证响应。

## 2.2 在 Apple 上注册您的 dApp

### 步骤 1：登录到 Apple 开发者帐户

1. 转到[Apple 开发者网站](https://developer.apple.com/)。
2. 使用您的 Apple ID 登录。
3. 如果尚未注册，请注册 Apple 开发者计划。![Apple 开发者计划注册截图](https://aptos.dev/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fapple-dev-program.cbfac707.png&w=2048&q=75)

### 步骤 2：创建一个新的 App ID

1. 导航到“证书、标识符和配置文件”部分。
2. 在侧边栏中点击“标识符”。
3. 点击“+”按钮创建一个新的 App ID。
4. 填写您的应用程序的详细信息，包括名称和捆绑 ID。
5. 在“功能”部分启用“使用 Apple 登录”。
6. 点击“继续”，然后“注册”以创建 App ID。

### 步骤 3：生成私钥

1. 在“证书、标识符和配置文件”页面的“密钥”部分，点击“+”按钮创建一个新密钥。
2. 输入密钥的名称，启用“使用 Apple 登录”功能，然后点击“继续”。
3. 下载生成的私钥并安全存储。此密钥将用于通过 Apple 的 OIDC 服务对您的应用程序进行身份验证。

### 步骤 4：配置重定向 URI

1. 在“App ID”部分，找到您新创建的 App ID 并点击它。
2. 向下滚动到“使用 Apple 登录”部分，然后点击“编辑”。
3. 添加您的应用程序在身份验证后将用于回调的重定向 URI。格式应为 `https://your-app-domain.com/auth/apple/callback`
4. 点击“保存”以更新设置。

### 步骤 5：设置您的 OIDC 集成

1. 使用与 Apple 的 OIDC 服务兼容的 OIDC 库或框架（例如，Node.js 的 Passport.js、Java 的 Spring Security）。
2. 在注册过程中配置您的应用程序使用从 Apple 获得的客户端 ID 和私钥。
3. 设置适当的回调 URL（`https://your-app-domain.com/auth/apple/callback`）以处理来自 Apple 的身份验证响应。


# 3. Aptos 无密钥集成指南

>[!NOTE] 无密钥账户范围
>
>使用 Aptos 无密钥集成指南将允许直接将无密钥账户集成到您的应用程序中。这意味着区块链账户的范围被限定在您的应用程序的域内（在 dApp A 中使用您的 Google 账户登录，在 dApp B 中使用您的 Google 账户登录将创建单独的账户）。请继续关注 Aptos 有关允许无密钥账户在应用程序之间便携使用的更多计划。
>
>要提供反馈、获得支持或成为我们增强 Aptos 无密钥的设计合作伙伴，请在此加入我们：https://t.me/+h5CN-W35yUFiYzkx

在高层次上，要集成无密钥账户，需要遵循三个步骤。

1. 配置您与身份提供商（IdP）的 OpenID 集成。在此步骤中，dApp 将在所选的 IdP（例如 Google）上注册并接收一个 client_id
2. 安装 Aptos TypeScript SDK。
3. 在您的应用程序客户端中集成无密钥账户支持
4. 为您的用户设置“使用 [IdP] 登录”流程。
5. 实例化用户的无密钥账户
6. 通过无密钥账户签署并提交交易

## 示例实现
您可以在 [aptos-keyless-example](https://github.com/aptos-labs/aptos-keyless-example/) 存储库中找到一个示例应用程序，展示了与 Google 的基本无密钥集成。按照 README 中的说明开始使用该示例。有关无密钥的更详细说明，请阅读本集成指南的其余部分。

## 步骤 1. 配置您与 IdP 的 OpenID 集成

第一步是与您的 IdP 设置配置。

[按照此处的说明](https://aptos.dev/en/build/guides/aptos-keyless/oidc-support)

## 步骤 2. 安装 Aptos TypeScript SDK

```bash
# 无密钥在 1.18.1 及以上版本中受支持
pnpm install @aptos-labs/ts-sdk
```

## 步骤 3. 客户端集成步骤

以下是客户端集成无密钥账户的默认步骤

1. 在用户界面上为用户提供“使用 [IdP] 登录”按钮

    1. 在后台，我们创建一个临时密钥对。将其存储在本地存储中。
    
        ```ts
        import {EphemeralKeyPair} from '@aptos-labs/ts-sdk';
        const ephemeralKeyPair = EphemeralKeyPair.generate();
        ```
    
    2. 将临时密钥对存储在本地存储中，以其随机数作为键。
    
        ```ts
        // 这将临时密钥对存储在本地存储中，以其随机数作为键。
        storeEphemeralKeyPair(ephemeralKeyPair);
        ```
    
        storeEphemeralKeyPair 的示例实现
    
        >[!TIP] 提示
        >
        > 这种实现是一个示例，展示了如何使用nonce（随机数）作为密钥将EphemeralKeyPair存储在本地存储中。根据不同应用程序的需求，可以使用不同的实现方式。
    
        ```ts
        /**
         * Stored ephemeral key pairs in localStorage (nonce -> ephemeralKeyPair)
         */
        export type StoredEphemeralKeyPairs = { [nonce: string]: EphemeralKeyPair };
         
        /**
         * Retrieve all ephemeral key pairs from localStorage and decode them. The new ephemeral key pair
         * is then stored in localStorage with the nonce as the key.
         */
        export const storeEphemeralKeyPair = (
          ephemeralKeyPair: EphemeralKeyPair,
        ): void => {
          // Retrieve the current ephemeral key pairs from localStorage
          const accounts = getLocalEphemeralKeyPairs();
         
          // Store the new ephemeral key pair in localStorage
          accounts[ephemeralKeyPair.nonce] = ephemeralKeyPair;
          localStorage.setItem(
            "ephemeral-key-pairs",
            encodeEphemeralKeyPairs(accounts),
          );
        };
         
        /**
         * Retrieve all ephemeral key pairs from localStorage and decode them.
         */
        export const getLocalEphemeralKeyPairs = (): StoredEphemeralKeyPairs => {
          const rawEphemeralKeyPairs = localStorage.getItem("ephemeral-key-pairs");
          try {
            return rawEphemeralKeyPairs
              ? decodeEphemeralKeyPairs(rawEphemeralKeyPairs)
              : {};
          } catch (error) {
            // eslint-disable-next-line no-console
            console.warn(
              "Failed to decode ephemeral key pairs from localStorage",
              error,
            );
            return {};
          }
        };
         
        /**
         * Encoding for the EphemeralKeyPair class to be stored in localStorage
         */
        const EphemeralKeyPairEncoding = {
          decode: (e: any) => EphemeralKeyPair.fromBytes(e.data),
          encode: (e: EphemeralKeyPair) => ({
            __type: "EphemeralKeyPair",
            data: e.bcsToBytes(),
          }),
        };
         
        /**
         * Stringify the ephemeral key pairs to be stored in localStorage
         */
        export const encodeEphemeralKeyPairs = (
          keyPairs: StoredEphemeralKeyPairs,
        ): string =>
          JSON.stringify(keyPairs, (_, e) => {
            if (typeof e === "bigint") return { __type: "bigint", value: e.toString() };
            if (e instanceof Uint8Array)
              return { __type: "Uint8Array", value: Array.from(e) };
            if (e instanceof EphemeralKeyPair)
              return EphemeralKeyPairEncoding.encode(e);
            return e;
          });
         
        /**
         * Parse the ephemeral key pairs from a string
         */
        export const decodeEphemeralKeyPairs = (
          encodedEphemeralKeyPairs: string,
        ): StoredEphemeralKeyPairs =>
          JSON.parse(encodedEphemeralKeyPairs, (_, e) => {
            if (e && e.__type === "bigint") return BigInt(e.value);
            if (e && e.__type === "Uint8Array") return new Uint8Array(e.value);
            if (e && e.__type === "EphemeralKeyPair")
              return EphemeralKeyPairEncoding.decode(e);
            return e;
          });
        ```
    
    3. 准备登录 URL 的 URL 参数。将 redirect_uri 和 client_id 设置为您在 IdP 中配置的值。将随机数设置为步骤 1.1 中的临时密钥对的随机数。
    
        ```ts
        const redirectUri = 'https://.../login/callback'
        const clientId = env.IDP_CLIENT_ID
        // 获取与临时密钥对相关联的随机数
        const nonce = ephemeralKeyPair.nonce
        ```
    
    4. 为用户构建与 IdP 进行身份验证的登录 URL。确保设置了 openid 范围。其他范围，如电子邮件和个人资料，可以根据您的应用程序的需求进行设置。
    
        ```ts
        const loginUrl = `https://accounts.google.com/o/oauth2/v2/auth?response_type=id_token&scope=openid+email+profile&nonce=${nonce}&redirect_uri=${redirectUri}&client_id=${clientId}`
        ```
    
    5. 当用户点击登录按钮时，将用户重定向到在步骤 1.4 中创建的登录 URL。
    
2. 通过解析令牌处理回调并为用户创建一个无密钥账户
   
    1. 一旦用户完成登录流程，他们将被重定向到在步骤 1 中设置的 redirect_uri。JWT 将作为搜索参数在 URL 片段中设置，以 id_token 作为键。通过以下方式从 `windows` 中提取 JWT：
    
        ```ts
        const parseJWTFromURL = (url: string): string | null => {
          const urlObject = new URL(url);
          const fragment = urlObject.hash.substring(1);
          const params = new URLSearchParams(fragment);
          return params.get('id_token');
        };
         
        // window.location.href = https://.../login/google/callback#id_token=...
        const jwt = parseJWTFromURL(window.location.href)
        ```
    
    2. 解码 JWT 并从有效负载中提取随机数值。
    
        ```ts
        import { jwtDecode } from 'jwt-decode';
         
        const payload = jwtDecode<{ nonce: string }>(jwt);
        const jwtNonce = payload.nonce
        ```
    
    3. 使用解码的随机数获取在步骤 1.2 中存储的临时密钥对。
    
        ```ts
        const ephemeralKeyPair = getLocalEphemeralKeyPair(jwtNonce);
        ```
    
        getLocalEphemeralKeyPair 的示例实现
    
        
    
        >[!TIP] 提示
        >
        > 这种实现是一个示例，展示了如何使用随机数作为密钥从本地存储中检索临时密钥对。根据不同应用程序的需求，可以使用不同的实现方式。重要的是，您需要验证临时密钥对的过期时间戳，以确保它仍然有效。
    
        
    
        ```ts
        /**
         * Stored ephemeral key pairs in localStorage (nonce -> ephemeral key pair)
         */
        export type StoredEphemeralKeyPairs = { [nonce: string]: EphemeralKeyPair };
         
        /**
         * Retrieve the ephemeral key pair with the given nonce from localStorage.
         */
        export const getLocalEphemeralKeyPair = (
          nonce: string,
        ): EphemeralKeyPair | null => {
          const keyPairs = getLocalEphemeralKeyPairs();
         
          // Get the account with the given nonce (the generated nonce of the ephemeral key pair may not match
          // the nonce in localStorage), so we need to validate it before returning it (implementation specific).
          const ephemeralKeyPair = keyPairs[nonce];
          if (!ephemeralKeyPair) return null;
         
          // If the account is valid, return it, otherwise remove it from the device and return null
          return validateEphemeralKeyPair(nonce, ephemeralKeyPair);
        };
         
        /**
         * Retrieve all ephemeral key pairs from localStorage and decode them.
         */
        export const getLocalEphemeralKeyPairs = (): StoredEphemeralKeyPairs => {
          const rawEphemeralKeyPairs = localStorage.getItem("ephemeral-key-pairs");
          try {
            return rawEphemeralKeyPairs
              ? decodeEphemeralKeyPairs(rawEphemeralKeyPairs)
              : {};
          } catch (error) {
            console.warn(
              "Failed to decode ephemeral key pairs from localStorage",
              error,
            );
            return {};
          }
        };
         
        /**
         * Validate the ephemeral key pair with the given nonce and the expiry timestamp. If the nonce does not match
         * the generated nonce of the ephemeral key pair, the ephemeral key pair is removed from localStorage. This is
         * to validate that the nonce algorithm is the same (e.g. if the nonce algorithm changes).
         */
        export const validateEphemeralKeyPair = (
          nonce: string,
          ephemeralKeyPair: EphemeralKeyPair,
        ): EphemeralKeyPair | null => {
          // Check the nonce and the expiry timestamp of the account to see if it is valid
          if (
            nonce === ephemeralKeyPair.nonce &&
            ephemeralKeyPair.expiryDateSecs > BigInt(Math.floor(Date.now() / 1000))
          ) {
            return ephemeralKeyPair;
          }
          removeEphemeralKeyPair(nonce);
          return null;
        };
         
        /**
         * Remove the ephemeral key pair with the given nonce from localStorage.
         */
        export const removeEphemeralKeyPair = (nonce: string): void => {
          const keyPairs = getLocalEphemeralKeyPairs();
          delete keyPairs[nonce];
          localStorage.setItem(
            "ephemeral-key-pairs",
            encodeEphemeralKeyPairs(keyPairs),
          );
        };
        ```
    
    4. 实例化用户的无密钥账户
    
        ```ts
        import {Aptos, AptosConfig, Network} from '@aptos-labs/ts-sdk';
         
        const aptos = new Aptos(new AptosConfig({network: Network.DEVNET})); // Configure your network here
        const keylessAccount = await aptos.deriveKeylessAccount({
            jwt,
            ephemeralKeyPair,
        });
        ```

3. 向 Aptos 区块链提交交易
   
    1. 创建您要提交的交易。以下是一个简单的硬币转移交易示例：
    
        ```ts
        import {Account} from '@aptos-labs/ts-sdk';
        
        const bob = Account.generate();
        const transaction = await aptos.transferCoinTransaction({
            sender: keylessAccount.accountAddress,
            recipient: bob.accountAddress,
            amount: 100,
        });
        ```
    
    2. 签署并向链提交交易。
    
        ```ts
        const committedTxn = await aptos.signAndSubmitTransaction({ signer: keylessAccount, transaction });
        ```
    
    3. 等待交易在链上处理
    
        ```ts
        const committedTransactionResponse = await aptos.waitForTransaction({ transactionHash: committedTxn.hash });
        ```
    
        
# 4. 无密钥如何工作

Aptos 无密钥使 dApp 能够为通过 OIDC 提供商（例如 Google）成功登录到 dApp 的用户**派生**和**访问**区块链账户。重要的是，此区块链账户**限定于该 dApp**。这意味着其他 dApp，即使可以通过相同的 OIDC 提供商登录相同的用户，也无法访问此账户，而是会获得自己的账户。

*但这是如何工作的呢？*

<iframe class="aspect-video w-full" src="https://www.youtube.com/embed/sKqeGR4BoI0" title="无密钥演示" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"></iframe>

## 4.1 概述

在非常高的层面上，通过 OIDC 提供商成功登录到 dApp 将导致 dApp 接收由 OIDC 提供商签名的**JSON Web 令牌（JWT）**。JWT 将包含，除其他事项外，三个重要信息：

1. 用户的身份（包含在 JWT 的`sub`字段中）
2. dApp 的身份（包含在 JWT 的`aud`字段中）
3. 特定于应用程序的数据；具体而言，一个**临时公钥（EPK）**（包含在 JWT 的`nonce`字段中），其相关的**临时私钥（ESK）**只有用户知道。

现在，假设用户的区块链账户地址（或多或少）是上述`sub`中的用户身份和`aud`中的 dApp 身份的哈希值。

那么，**关键观察**是，签名的 JWT 有效地充当**数字证书**，**暂时**将此区块链地址与 EPK 绑定，并允许 EPK 为其签署 TXN。换句话说，它将此区块链账户的 TXN 签名权安全地委托给 EPK。（注意：EPK 包含到期日期，因此是短暂的。）

重要的是，如果用户丢失了他们的 ESK，用户可以通过应用程序在新的 EPK 上获得新的签名 JWT，只需再次通过 OIDC 提供商登录即可。（或者，在某些情况下，通过使用 OAuth 刷新令牌请求新的签名 JWT。）

在这个系统中，**挑战**是维护隐私，因为在链上揭示 JWT 会泄露用户的身份。此外，向 OIDC 提供商透露 EPK 将允许其跟踪用户在链上的 TXN。

我们在下面解释无密钥账户如何工作以及它们如何应对这些挑战。

## 4.2 流程：为 dApp 中的用户派生无密钥账户

首先，让我们看看 dApp 如何通过（例如）Google 登录用户，派生该用户的无密钥区块链地址，并例如向该用户发送资产。

![无密钥账户图](https://aptos.dev/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fkeyless-account.d03af45f.png&w=3840&q=75)

**步骤 1**：用户生成一个临时密钥对：一个带有到期日期的 EPK 及其相关的 ESK。dApp 保留 EPK，并将 ESK 安全地存储在用户端（例如，在浏览器的本地存储中，或者如果 ESK 是 WebAuthn 密码钥匙，则在受信任的飞地中）。

**步骤 2**：dApp 将 EPK 提交为 𝐻(𝑒𝑝𝑘,𝜌)*H*(epk,*ρ*)，其中 𝜌*ρ*是一个盲化因子。当用户点击“使用 Google 登录”按钮时，dApp 将用户重定向到 Google 的登录页面，重要的是，将 URL 中的`nonce`参数设置为此 EPK 提交。这对 Google 隐藏了 EPK，维护了用户的 TXN 活动的隐私。

**步骤 3**：通常，用户由于之前登录到他们的 Google 账户而具有 HTTP  Cookie，因此 Google 仅检查此 Cookie。如果用户有多个 Google 账户，Google 会要求用户选择他们要登录到 dApp 的账户。（不太常见的路径是用户必须输入他们的 Google 用户名和密码。）

**步骤 4**：一旦用户登录，Google 会向 dApp 发送一个签名的 JWT，其中包括用户的`sub`标识符（例如，`uid-123`），应用程序的`aud`标识符（例如，`"dapp-xyz"`）和带有 EPK 提交的`nonce`。（这假定 dApp 之前已在 Google 注册并接收了此`"dapp-xyz"`标识符。）

**步骤 5**：dApp 现在几乎拥有为用户派生无密钥账户所需的一切：用户的标识符（`sub`）和 dApp 的标识符（`aud`）。但是，为了保护用户的隐私，dApp 将使用第三个信息：一个称为**辣椒**的盲化因子 𝑟*r*。dApp 将联系所谓的**守护者**，守护者将从给定的（`sub`，`aud`）确定性地派生一个随机的 𝑟*r*。重要的是，守护者只有在看到针对查询的（`sub`，`aud`）的有效签名 JWT 时才会向 dApp 透露 𝑟*r*。

**步骤 6**：dApp 将账户地址派生为 𝑎𝑑𝑑𝑟=𝐻("uid-123","dapp-xyz",𝑟)addr=*H*("uid-123","dapp-xyz",*r*)，其中 𝐻*H*是一个加密哈希函数。

请注意，辣椒 𝑟*r*用于在地址中隐藏用户和应用程序的身份，因为如上所述，只有具有有效 JWT 的授权用户才能获得此辣椒。

另外，请注意地址与 EPK 无关。这就是为什么 ESK 不必长期存在并且可以丢失的原因。

最后，dApp 可以，例如，在用户的地址 𝑎𝑑𝑑𝑟addr 向用户发送一个 NFT。

但是 dApp 如何从 𝑎𝑑𝑑𝑟addr 这个账户授权 TXN 呢？我们接下来讨论。

## 4.3 流程：在交易前获取零知识证明

在上一个流程中，我们展示了 dApp 如何在守护者的帮助下登录 Google 用户并派生其保护隐私的无密钥地址。

接下来，我们展示此 dApp 如何获取零知识证明（ZKP），这将允许它为用户从此地址授权交易。重要的是，交易将隐藏用户的识别信息（例如，`sub`字段）。

![无密钥证明图](https://aptos.dev/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fkeyless-proof.44f23c6f.png&w=3840&q=75)

**步骤 1**：dApp 将所有必要的公共信息（即 𝑒𝑝𝑘epk，𝐺𝑃𝐾GPK）和私有信息（即 JWT，来自 Google 的签名 𝜎𝐺*σ**G*，EPK 盲化因子 𝜌*ρ*，和辣椒 𝑟*r*）发送到**证明服务**。

**步骤 2**：证明者派生用户的地址 𝑎𝑑𝑑𝑟addr 并为无密钥关系 𝑅𝑘𝑒𝑦𝑙𝑒𝑠𝑠Rkeyless（如下所述）计算零知识证明（ZKP） 𝜋*π*。此证明充当**保护隐私**的数字证书，并将用户的地址 𝑎𝑑𝑑𝑟addr 绑定到临时公钥 𝑒𝑝𝑘epk。然后证明者将 𝜋*π*发送到 dApp。

为了将 𝑒𝑝𝑘epk 与用户的地址 𝑎𝑑𝑑𝑟addr 绑定，ZKP 将用于使验证者相信用户拥有（1）由 Google 签名的 JWT，（2）其在`nonce`字段中提交到 𝑒𝑝𝑘epk，（3）包含与地址中相同的信息，而不会泄露关于 JWT，其签名 𝜎𝐺*σ**G*，𝜌*ρ*或 𝑟*r*的任何信息。

更正式地，ZKP 𝜋*π*使具有公共输入（𝑎𝑑𝑑𝑟，𝑒𝑝𝑘，𝐺𝑃𝐾)(addr,epk,GPK)的验证者（即区块链）相信证明者知道秘密输入（𝑗𝑤𝑡，𝜎𝐺，𝜌，𝑟)(jwt,*σ**G*,*ρ*,*r*)，使得下面描述的关系 𝑅𝑘𝑒𝑦𝑙𝑒𝑠𝑠Rkeyless 成立：

![无密钥关系图](https://aptos.dev/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fkeyless_relation.0a266122.png&w=3840&q=75)

回想一下，之前签名的 JWT 本身将区块链地址 𝑎𝑑𝑑𝑟addr 绑定到 𝑒𝑝𝑘epk，以便 𝑒𝑝𝑘epk 可以为 𝑎𝑑𝑑𝑟addr 签署交易。但是，JWT 会泄露用户的身份，因此 ZKP 用于在论证适当的检查成立（即 𝑅𝑘𝑒𝑦𝑙𝑒𝑠𝑠Rkeyless 中的检查）时隐藏 JWT（和其他私有信息）。

接下来，我们展示 dApp 现在如何从 𝑎𝑑𝑑𝑟addr 授权 TXN。

## 4.4 流程：从无密钥账户发送 TXN

上一个流程解释了 dApp 如何从证明服务获得 ZKP。接下来，我们描述 dApp 如何利用此 ZKP 为账户进行交易。

![无密钥签名图](https://aptos.dev/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fkeyless-signing.40ca70cb.png&w=3840&q=75)

**步骤 1**：dApp 从用户那里获得对 TXN 的临时签名 𝜎𝑒𝑝ℎ*σ*eph。这可以在用户不知情的情况下由 dApp 本身完成，dApp 可能管理 ESK。或者，它可能是发送给用户的实际签名请求，例如当 ESK 是存储在用户受信任硬件上的 WebAuthn 密码钥匙时。

**步骤 2**：dApp 将 TXN，ZKP 𝜋*π*，临时公钥 𝑒𝑝𝑘epk 和临时签名 𝜎𝑒𝑝ℎ*σ*eph 发送到区块链验证器。

**步骤 3**：为了检查 TXN 是否有效签名，验证器执行几个步骤：（1）检查 𝑒𝑝𝑘epk 是否未过期，（2）从 TXN 中获取用户的地址 𝑎𝑑𝑑𝑟addr，（3）根据（𝑎𝑑𝑑𝑟，𝑒𝑝𝑘，𝐺𝑃𝐾)(addr,epk,GPK)验证 ZKP，（4）根据 𝑒𝑝𝑘epk 验证 TXN 上的临时签名 𝜎𝑒𝑝ℎ*σ*eph。如果所有这些检查都通过，他们可以安全地执行 TXN。



## 5. 术语

- **OpenID Connect (OIDC)**: 是用于实现联合身份验证的身份认证协议。例如，当用户经历“使用 Google 登录”流程时，使用的便是此协议。

- **身份提供商（IdP）**: 是通过 OIDC 对您的身份进行验证的可信权威。支持的示例包括：Google。

- JSON Web Token (JWT):

     

    是一种用于在双方（客户端和服务器）之间共享安全信息的开放标准。每个 JWT 都包含编码的 JSON 对象，包括一组声明。JWT 使用加密算法进行签名，以确保在令牌发布后声明无法被更改。

    - `iss`，OIDC 提供商的标识符（例如，[https://accounts.google.com](https://accounts.google.com/)）

    - `aud`，用户登录的应用程序的 OAuth `client_id`（例如，[Notion.so](https://notion.so/)）

    - ```
        sub
        ```

        ，OIDC 提供商用于识别用户的标识符

        - 这可能是此 `client_id` 所特定的标识符
        - 或者，它可能是跨不同 `client_id` 共享的标识符（例如，Facebook 的 OIDC 就是这样）

    - ```
        email
        ```

        ，一些提供商可能还会将用户的电子邮件作为字段之一公开（例如，Google）

        - 此外，一个 `email_verified` 字段将被公开以表明提供商是否已验证用户拥有此电子邮件地址

    - `nonce`，应用程序希望 OIDC 提供商签署的任意数据

    - `iat`，JWT 发布的时间。

- **临时密钥对**: 一个用于为 Aptos 无密钥账户签署交易的临时公钥/私钥对。公钥及其到期日期通过 `nonce` 字段在 JWT 令牌中提交。

- **无密钥账户**: 一个直接从（1）用户的 OIDC 账户（例如，`alice@gmail.com`）和（2）相关应用程序的 OAuth `client_id`（例如，Notion.so）派生的区块链账户。用户通过 OIDC 流程进行身份验证。

- **JSON Web 密钥（JWK）**: 是 OIDC 提供商的加密公钥。此公钥用于验证 OIDC 提供商向客户端应用程序发布的 JWT 的签名。这样，客户端应用程序可以验证令牌的真实性并确保它们未被篡改。

- **client_id**：您在向 IdP 注册应用程序后将从其接收的应用程序的 OAuth 标识符。这将在我们的无密钥架构中用于为您的用户进行地址派生。

- **redirect_uri**：用户成功认证后的回调处理程序的 URI。需要在您的 IdP 中注册。

## 5.1 仪式

Aptos 参与了迭代的可信设置仪式，以保障我们基于 Groth16 的 ZK 电路的安全。可信设置仪式是一种多方计算（MPC），输出在 zkSNARK 系统中使用的证明者和验证者密钥，常用于高效的零知识证明系统。只要仪式中的单个参与者是诚实的，该过程就被视作是安全的，并且输出将是有效的。我们最初的仪式由 140 多个 Aptos 生态系统成员组成，这是去中心化、安全性和社区力量的惊人展示 - 并且在开发者反馈阶段之后举行了后续仪式，使我们能够识别并实施对我们电路的改进，帮助我们确保无密钥是普遍可访问的。我们最终的仪式贡献可以在这个存储库[这里]找到，并使用[这里]概述的过程进行验证。

## 5.2 常见问题

**使用无密钥账户的最佳方式是什么？**

- 使用无密钥账户的最佳方式取决于您的用例。如果在我们的生态系统中实现无缝的账户互操作性对您的 dApp 体验至关重要（比如：在您的平台上铸造 NFT 并允许用户在外部 NFT 市场上出售他们的 NFT），您或许想要考虑集成支持无密钥的钱包。如果您想在您的 dApp 中创建完全嵌入式的账户体验，允许用户在不离开您的应用程序的情况下进行交易，您可能想要直接集成 Aptos 无密钥 SDK。

**无密钥是否适用于赞助交易，还是我的用户总是需要为他们自己的 gas 付费？**

- 是的，无密钥适用于赞助交易，如同任何基于常规私钥的账户一样。

**如果我使用 Aptos 无密钥 SDK，我的用户能否在其他 dApp 中使用他们的账户？**

- 无密钥账户的范围限定于创建它们的域，因为地址派生包含应用程序的唯一标识符。

**什么是 Aptos Connect？**

- 账户管理基础设施：无密钥账户范式的核心是一个强大的账户管理基础设施，它有助于用户账户的创建、删除和管理，以及相关元数据的存储和检索。
- 虽然无密钥账户的采用预示着朝着增强可用性和安全性的范式转变，但对于开发人员而言，必须意识到与该系统相关的权衡与像明文私钥这样的常见替代方案的差异。

**是否依赖外部服务？**

- 是的，无密钥账户引入了对外部认证服务（辣椒和证明者）的一定程度的依赖，这就需要应急计划和备用机制来减轻服务中断并确保用户不间断访问。

**如果我的 dApp 宕机，我的用户无法访问他们的无密钥账户。在这种情况下，我如何帮助保护他们？**

- 我们鼓励 dApp 开发人员在将无密钥集成到 dApp 时为用户支持额外的备份恢复选项。具体而言，我们建议您支持在您的 dApp 中的无密钥账户中添加备份私钥。实际上，这会将账户转换为 2 个多重签名账户中的 1 个，其中两个密钥都由用户拥有。这将允许用户继续通过您的 dApp 使用 OIDC 登录来访问他们的无密钥账户，但会增添用户将其备份私钥导出到任何自托管产品的能力，在那里他们可以使用他们的传统私钥从同一个账户签署交易。这样做将确保用户永远不会失去对其数字资产的访问权限，即使您的 dApp 关闭或用户失去对其 OIDC 账户的访问权限。
- 您应该确定在用户旅程的哪个点为您的 dApp 并入备份是合适的。在用户旅程的后期并入备份方法将保留无密钥提供的无缝入职体验，但可能导致较少的用户收到恢复密钥。在入职过程中提示用户添加备份密钥可能会导致更多用户收到恢复密钥，但可能会在入职过程中增加潜在的摩擦。
