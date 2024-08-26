---
title: 附录：Move 中的密码学
aliases:
  - 附录：Move 中的密码学
---
密码学在确保区块链系统中数据的安全性、完整性、机密性和不变性方面起着不可或缺的作用。Move 的 Aptos 适配器为开发人员提供了一系列密码原语来满足这一需求。本文深入探讨了 Aptos 上的 Move 所提供的密码学功能，并阐明了驱动其设计的原则。

## 密码原语

通过 Aptos 适配器，Move 涵盖了几个基本的密码工具：

1. [密码哈希函数](https://aptos.dev/en/build/smart-contracts/cryptography#cryptographic-hash-functions) - 从可变大小的输入数据生成固定大小输出（哈希）的算法。支持的函数包括 SHA2-256、SHA3-256、Keccak256 和 Blake2b-256。
2. [数字签名验证](https://aptos.dev/en/build/smart-contracts/cryptography#digital-signature-verification) - 用于签署消息以确保其完整性、验证发送者、确保不可否认性或其任意组合的算法。支持的签名方案包括 Ed25519、ECDSA 和 BLS。
3. [椭圆曲线算术](https://aptos.dev/en/build/smart-contracts/cryptography#elliptic-curve-arithmetic) - 椭圆曲线是高级密码原语（如数字签名、公钥加密或可验证秘密共享）的构建块之一。支持的曲线包括 Ristretto255 和 BLS12-381。
4. [零知识证明 (ZKP)](https://aptos.dev/en/build/smart-contracts/cryptography#building-powerful-cryptographic-applications) - 这些密码技术使一方能够证明公共声明 𝑥 上的关系 𝑅(𝑥;𝑤) 得到满足，而不会泄露使其成立的秘密见证 𝑤。目前，我们支持 Groth16 ZKP 验证和 Bulletproofs ZK 范围证明验证。

三个基本原则指导 Aptos 密码扩展到 Move 的设计和集成：

1. **经济的 Gas 使用** - 通过将关键原语实现为 [Move 原生函数](https://aptos.dev/en/build/smart-contracts/book/functions#native-functions)，努力为 Move 开发人员最小化 Gas 成本。例如，请查看 [BLS12-381 椭圆曲线上的 BLS 签名模块](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-stdlib/sources/cryptography/bls12381.move)。
2. **类型安全的 API** - 确保 API 能够抵抗常见错误，类型安全增强了代码的可靠性，并促进了高效的开发过程。例如，请查看 [Ed25519 签名模块](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-stdlib/sources/cryptography/ed25519.move)。
3. **赋予开发人员权力** - 在原生函数不可用的情况下，我们赋予开发人员在诸如 *有限域* 和 *阿贝尔群* 等抽象密码构建块之上构建自己的密码原语的能力。有关更多见解，请参考 [`aptos_std::crypto_algebra`](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-stdlib/sources/cryptography/crypto_algebra.move) 模块。

继续阅读以更深入地探讨这些扩展背后的一些复杂性，以及它们所支持的应用范围。为了对这个主题有最全面的理解，请参考 [密码学 Move 模块代码](https://github.com/aptos-labs/aptos-core/tree/main/aptos-move/framework/aptos-stdlib/sources/cryptography)。

## 密码哈希函数

开发人员现在可以通过 [`aptos_std::aptos_hash`](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-stdlib/sources/hash.move) 模块在 Move 中使用更多的密码哈希函数：

| 哈希函数 | 哈希大小（位） | 对 1KiB 进行哈希的成本（以内部 Gas 单位计） | 抗碰撞安全性（位） |
| ------------- | ---------------- | --------------------------------------------- | ------------------------------------ |
| Keccak256     | 256              | 1,001,600                                     | 128                                  |
| SHA2-256      | 256              | 1,084,000                                     | 128                                  |
| SHA2-512      | 512              | 1,293,600                                     | 256                                  |
| SHA3-256      | 256              | 1,001,600                                     | 128                                  |
| SHA3-512      | 512              | 1,114,000                                     | 256                                  |
| RIPEMD160     | 160              | 1,084,000                                     | 80（**弱**）                        |
| Blake2b-256   | 256              | 342,200                                       | 128                                  |

所有哈希函数具有相同的安全属性（例如，单向性、抗碰撞性等），但它们的安全级别不同。

⚠️

由于其 80 位的安全级别，应避免将 RIPEMD160 用作抗碰撞函数。主要是出于向后兼容的原因支持它：例如，比特币地址推导依赖于 RIPEMD160。

其中一些函数可用于与其他链的互操作性（例如，通过 [`aptos_std::aptos_hash::keccak256`](https://github.com/aptos-labs/aptos-core/blob/137acee4c6dddb1c86398dce25b041d78a3028d3/aptos-move/framework/aptos-stdlib/sources/hash.move#L35) 验证以太坊 Merkle 证明）。其他函数的 Gas 成本较低，例如 [`aptos_std::aptos_hash::blake2b_256`](https://github.com/aptos-labs/aptos-core/blob/137acee4c6dddb1c86398dce25b041d78a3028d3/aptos-move/framework/aptos-stdlib/sources/hash.move#L69) 。一般来说，更多种类的哈希函数为开发人员在安全性和与其他链下密码系统的互操作性方面提供了更多的自由。

## 数字签名验证

开发人员现在可以在 Move 中使用 *类型安全* 的 API 来验证多种数字签名：

| 签名方案                                             | 曲线         | 签名大小（字节） | 公钥大小（字节） | 可延展性 | 假设 | 优点          | 缺点                |
| ------------------------------------------------------------ | ------------- | ----------------- | --------------- | ------------ | ----------- | ------------- | ------------------- |
| [ECDSA](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-stdlib/sources/cryptography/secp256k1.move) | secp256k1     | 64                | 64              | 是          | GGM         | 广泛采用 | 安全证明      |
| [Ed25519](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-stdlib/sources/cryptography/ed25519.move) | Edwards 25519 | 64                | 32              | 否          | DLA, ROM    | 快速          | 微妙之处          |
| [MultiEd25519](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-stdlib/sources/cryptography/multi_ed25519.move) | Edwards 25519 | 4+𝑡⋅644+*t*⋅64    | 𝑛⋅32*n*⋅32      | 否          | DLA, ROM    | 易于采用 | 大签名大小     |
| [MinPK BLS](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-stdlib/sources/cryptography/bls12381.move) | BLS12-381     | 96                | 48              | 否          | CDH, ROM    | 多功能     | 验证较慢 |
| [MinSig BLS](https://github.com/aptos-labs/aptos-core/blob/7d4fb98c6604c67e526a96f55668e7add7aaebf6/aptos-move/move-examples/drand/sources/drand.move#L57) | BLS12-381     | 48                | 96              | 否          | CDH, ROM    | 多功能     | 验证较慢 |

- CDH 代表 *“计算性 Diffie-Hellman 假设”*
- DLA 代表 *“离散对数假设”*
- GGM 代表 *“通用群模型”*
- ROM 代表 *“随机预言模型”*

上述数字签名模块可用于构建基于智能合约的钱包、空投的安全声明机制，或任何基于数字签名的 dapp 访问控制机制。

在您的 dapp 中选择正确的签名方案可能取决于许多因素：

1. 向后兼容性
    - 如果您的 dapp 的用户群主要使用特定的签名机制，为了便于过渡和采用，支持该机制将是明智的。
        - 示例：如果用户主要使用 Ed25519 签名，那么它就成为一个合理的选择。
2. 易于实现
    - 尽管在理论上是合理的，但复杂的协议在实践中可能具有挑战性。
        - 示例：即使存在 Ed25519 的 𝑡*t*-out-of-𝑛*n* 阈值协议，但由于签名者方面的复杂性，开发人员可能由于其更直接的签名实现而倾向于 MultiEd25519。
3. 效率
    - 根据 dapp 的要求，您可能会优先考虑效率的某一方面而不是另一方面。
        - 签名大小与公钥大小：某些应用可能优先考虑较小的签名占用空间，而其他应用可能强调紧凑的 PK。
        - 签名时间与验证时间：对于某些 dapp，签名速度可能更关键，而对于其他 dapp，快速的签名验证可能是优先事项。
4. 安全分析
    - 考虑签名方案的基本假设和潜在漏洞是至关重要的。
        - 示例：ECDSA 的安全性是在诸如通用群模型 (GGM) 等强假设下证明的。
        - 可延展性问题：某些签名方案容易受到可延展性的影响，其中有效的签名 𝜎*σ* 可以被篡改成为相同消息 𝑚*m* 的另一个仍然有效的签名 𝜎*σ* 。
5. 通用性
    - 签名方案的适应性和灵活性很重要，因此您可以适当地满足 dapp 的密码学需求。
        - 示例：𝑡*t*-out-of-𝑛*n* 阈值 BLS 签名非常易于实现。

⚠️

尽管经过了仔细的、有原则的设计[1](https://aptos.dev/en/build/smart-contracts/cryptography#user-content-fn-ed25519)，Ed25519 有已知的实现微妙之处。例如，不同的实现可能在签名的有效性上容易产生分歧，特别是在使用批量验证时[2](https://aptos.dev/en/build/smart-contracts/cryptography#user-content-fn-devalence),,[3](https://aptos.dev/en/build/smart-contracts/cryptography#user-content-fn-eddsa)。

我们的 [`aptos_std::bls12381`](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-stdlib/sources/cryptography/bls12381.move) 模块对于 [MinPK BLS](https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-bls-signature-05#name-variants) 支持单个签名、**多重**签名、**聚合**签名和**阈值**签名的验证。

## 椭圆曲线算术

虽然 [哈希函数](https://aptos.dev/en/build/smart-contracts/cryptography#cryptographic-hash-functions) 和 [数字签名](https://aptos.dev/en/build/smart-contracts/cryptography#digital-signature-verification) 模块应该为大多数应用提供足够的功能，但某些应用将需要更强大的密码学。通常，此类应用的开发人员必须等到他们所需的密码功能作为 [Move 原生函数](https://aptos.dev/en/build/smart-contracts/book/functions#native-functions) 在 [Aptos Move 框架](https://aptos.dev/en/network/blockchain/move) 中有效地实现。相反，我们公开了开发人员可以直接在 Move 语言中使用并高效实现自己的密码原语的基本构建块。

具体来说，我们目前公开了两个流行的椭圆曲线群及其相关的有限域上的低级算术运算：

1. Ristretto255，通过 [`aptos_std::ristretto255`](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-stdlib/sources/cryptography/ristretto255.move)
2. BLS12-381，通过 [`aptos_std::crypto_algebra`](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-stdlib/sources/cryptography/crypto_algebra.move) 和 [`aptos_std::bls12381_algebra`](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-stdlib/sources/cryptography/bls12381_algebra.move)

这些模块支持低级操作，例如：

- 椭圆曲线上点的标量乘法
- 多标量乘法 (MSMs)
- 配对
- 标量加法、乘法、求逆
- 哈希到标量或点
- 等等

可以在此之上构建的强大应用示例包括：

1. **有效性汇总** - 请参阅 [`groth16` zkSNARK 验证器示例](https://aptos.dev/en/build/smart-contracts/cryptography#groth16-zksnark-verifier)。
2. **基于随机性的游戏** - 请参阅 [`drand` 验证器示例](https://aptos.dev/en/build/smart-contracts/cryptography#verifying-randomness-from-the-drand-beacon)。
3. **隐私保护应用** - 请参阅 [`veiled_coin` 示例](https://aptos.dev/en/build/smart-contracts/cryptography#veiled-coins)。

### Ristretto255 算术

[`aptos_std::ristretto255`](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-stdlib/sources/cryptography/ristretto255.move) 模块为流行的 [Ristretto255 曲线](https://ristretto.group/)上的椭圆曲线算术提供支持。Ristretto255 的主要优点之一是它是一个素数阶群（与 Edwards 25519 曲线不同），这避免了基于它构建的更高级密码系统的小子群攻击。此外，Ristretto255 序列化是规范的，反序列化仅接受规范编码，这避免了更高级协议中的可延展性问题。

此模块已被证明对实现多种密码原语有用：

1. **零知识 ΣΣ-协议** - 请参阅 [`veiled_coin` 示例](https://aptos.dev/en/build/smart-contracts/cryptography#veiled-coins)。
2. **ElGamal** 加密 - 请参阅 [`aptos_std::ristretto255_elgamal`](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-stdlib/sources/cryptography/ristretto255_elgamal.move)
3. **Pedersen** 承诺 - 请参阅 [`aptos_std::ristretto255_pedersen`](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-stdlib/sources/cryptography/ristretto255_pedersen.move)
4. **Bulletproofs** ZK 范围证明[4](https://aptos.dev/en/build/smart-contracts/cryptography#user-content-fn-bulletproofs) - 请参阅 [`aptos_std::ristretto255_bulletproofs`](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-stdlib/sources/cryptography/ristretto255_bulletproofs.move)

需要在 `ristretto255` 之上构建密码系统的想法？您可以轻松构建的一个流行原语是 [schnorrkel](https://github.com/w3f/schnorrkel) 签名方案，它是 Ristretto255 群上的 Schnorr 签名的强化版本。

### 通用椭圆曲线算术

一个曲线好，还是更多曲线好？更多曲线！

[`aptos_std::crypto_algebra`](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-stdlib/sources/cryptography/crypto_algebra.move) 为 **任何** 支持的椭圆曲线（包括配对友好曲线）提供椭圆曲线算术运算。因此，Move 开发人员可以在 **任何** 现在或将来支持的曲线上通用地实现密码系统。与在代码中固定特定曲线（例如，通过针对 

[Ristretto255 模块](https://aptos.dev/en/build/smart-contracts/cryptography#ristretto255-arithmetic) 实现相比，这种方法在迁移到不同曲线时提供了更大的灵活性并缩短了开发时间。

尽管目前 `crypto_algebra` 模块仅通过 [`aptos_std::bls12381_algebra`](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-stdlib/sources/cryptography/bls12381_algebra.move) 中的标记类型支持 BLS12-381 曲线上的算术运算，但未来将支持更多曲线（例如，BN254、Ristretto255、BLS12-377、BW6-761、secp256k1、secp256r1）。

例如，Move 开发人员可以通过在其实现中使用曲线类型的 [类型参数](https://aptos.dev/en/build/smart-contracts/book/functions#type-parameters) 来通用地实现流行的 Boneh-Lynn-Shacham (BLS) 签名方案，适用于 **任何** 曲线：

```
use std::option;
use aptos_std::crypto_algebra::{eq, pairing, one, deserialize, hash_to};
/// 示例：一个在任何配对友好的三元组 `Gr1`、`Gr2`、`GrT` 上工作的 BLS 签名验证函数，其中签名在 `Gr1` 中，公钥在 `Gr2` 中。
/// 点使用 `FormatG1` 和 `FormatG2` 格式进行序列化，哈希方法为 `HashMethod`。
/// 
/// 警告：此示例是类型不安全的，可能不太适合生产代码。
public fun bls_verify_sig<Gr1, Gr2, GrT, FormatG1, FormatG2, HashMethod>(
    dst:        vector<u8>,
    signature:  vector<u8>,
    message:    vector<u8>,
    public_key: vector<u8>): bool{
    let sig  = option::extract(&mut deserialize<Gr1, FormatG1>(&signature));
    let pk   = option::extract(&mut deserialize<Gr2, FormatG2>(&public_key));
    let hash = hash_to<Gr1, HashMethod>(&dst, &message); 
    // 检查是否 $e(H(m), pk) = e(sig, g_2)$，其中 $g_2$ 生成 $\mathbb{G}_2$
    eq(
        &pairing<Gr1, Gr2, GrT>(&hash, &pk),
        &pairing<Gr1, Gr2, GrT>(&sig, &one<Gr2>())
    )
}
```

使用上述的 `bls_verify_sig` *通用* 函数，开发人员可以验证 **任何** 支持的（配对友好的）曲线上的 BLS 签名。例如，可以通过使用正确的 BLS12-381 标记类型作为其类型参数来调用上述函数，来验证 BLS12-381 曲线上的 [MinSig BLS](https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-bls-signature-05#name-variants) 签名：

```
use aptos_std::bls12381_algebra::{
    G1, G2, Gt, FormatG1Compr, FormatG2Compr, HashG1XmdSha256SswuRo
};
// 如果 BLS12-381 曲线上的 MinSig BLS 签名验证失败，则以代码 1 中止。
assert(
    bls_verify_sig<G1, G2, Gt, FormatG1Compr, FormatG2Compr, HashG1XmdSha256SswuRo>(
        dst, signature, message, public_key
    ),
    1
);
```

有关 `crypto_algebra` 模块的更多用例，请查看一些 Move 示例：

1. [在 **任何** 曲线上验证 Groth16 zkSNARK 证明](https://aptos.dev/en/build/smart-contracts/cryptography#groth16-zksnark-verifier)
2. [验证来自 `drand` 信标的随机性](https://aptos.dev/en/build/smart-contracts/cryptography#verifying-randomness-from-the-drand-beacon)

## 构建强大的密码应用

### 隐形币

[`veiled_coin` 示例](https://github.com/aptos-labs/aptos-core/tree/main/aptos-move/move-examples/veiled_coin/sources) 演示了如何使用 [上述的 Ristretto255 模块](https://aptos.dev/en/build/smart-contracts/cryptography#ristretto255-arithmetic) 为币余额和交易添加合理的机密性层。

具体来说，用户可以 **隐藏** 他们的余额，使其对包括验证者在内的所有人隐藏。此外，用户可以发送一个 **隐形交易**，对包括验证者在内的所有人隐藏交易金额。一个重要的注意事项是，隐形交易 **不** 隐藏发送方或接收方的身份。

🚫

此模块是教育性的。它 **未** 准备好用于生产。使用它可能导致资金损失。

### Groth16 zkSNARK 验证器

[`groth16` 示例](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/move-examples/groth16_example/sources/groth16.move) 演示了如何验证 Groth16 zkSNARK 证明[5](https://aptos.dev/en/build/smart-contracts/cryptography#user-content-fn-groth16)，这是最短、验证最快、通用的零知识证明。重要的是，如 [上文](https://aptos.dev/en/build/smart-contracts/cryptography#generic-elliptic-curve-arithmetic) 所述，此实现对 **任何** 曲线都是 *通用的*，这使得 Move 开发人员可以非常轻松地将其与他们喜欢的（支持的）曲线一起使用。

此代码尚未经过第三方组织的审计。如果在生产系统中使用，请自行承担风险。

### 验证来自 `drand` 信标的随机性

[`drand` 示例](https://github.com/aptos-labs/aptos-core/tree/main/aptos-move/move-examples/drand/sources) 展示了如何验证来自 [drand](https://drand.love/) 随机信标的公共随机性。这种随机性可用于游戏或任何其他基于机会的智能合约。我们在 [`lottery.move`](https://github.com/aptos-labs/aptos-core/tree/main/aptos-move/move-examples/drand/sources/lottery.move) 中给出了一个基于 `drand` 随机性实现的简单彩票示例。

此代码尚未经过第三方组织的审计。如果在生产系统中使用，请自行承担风险。

另一个可以基于 `drand` 构建的应用是时间锁加密[6](https://aptos.dev/en/build/smart-contracts/cryptography#user-content-fn-tlock)，它允许用户加密信息，使其只能在未来的块中解密。我们目前没有实现，但鼓励读者自行编写！

## 脚注

1. *ed25519:* **Ed25519: 高速高安全性签名**, 作者：Daniel J. Bernstein, Niels Duif, Tanja Lange, Peter Schwabe, Bo-Yin Yang, https://ed25519.cr.yp.to/ [↩](https://aptos.dev/en/build/smart-contracts/cryptography#user-content-fnref-ed25519)
2. *devalence:* **现在是 255:19AM。您知道您的验证标准是什么吗？**, 作者：Henry de Valence, https://hdevalence.ca/blog/2020-10-04-its-25519am [↩](https://aptos.dev/en/build/smart-contracts/cryptography#user-content-fnref-devalence)
3. *eddsa:* **驯服众多 EdDSAs**, 作者：Konstantinos Chalkias, François Garillot, Valeria Nikolaenko, 发表于 SSR 2020, https://dl.acm.org/doi/abs/10.1007/978-3-030-64357-7_4 [↩](https://aptos.dev/en/build/smart-contracts/cryptography#user-content-fnref-eddsa)
4. *bulletproofs:* **Bulletproofs: 用于保密交易及更多的短证明**, 作者：B. Bünz 和 J. Bootle 和 D. Boneh 和 A. Poelstra 和 P. Wuille 和 G. Maxwell; 发表于 2018 IEEE 安全与隐私研讨会 [↩](https://aptos.dev/en/build/smart-contracts/cryptography#user-content-fnref-bulletproofs)
5. *groth16:* **关于基于配对的非交互式参数的大小**, 作者：Groth, Jens; 发表于 EUROCRYPT 2016 [↩](https://aptos.dev/en/build/smart-contracts/cryptography#user-content-fnref-groth16)
6. *tlock:* **tlock: 基于阈值 BLS 的实用时间锁加密**, 作者：Nicolas Gailly 和 Kelsey Melissaris 和 Yolan Romailler; https://eprint.iacr.org/2023/189 [↩](https://aptos.dev/en/build/smart-contracts/cryptography#user-content-fnref-tlock)
