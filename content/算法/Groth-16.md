参考： 

[https://learnblockchain.cn/2019/12/19/zkp-Groth16](https://learnblockchain.cn/2019/12/19/zkp-Groth16)

[https://learnblockchain.cn/2019/05/27/groth16/](https://learnblockchain.cn/2019/05/27/groth16/)

[https://www.cnblogs.com/1024th/p/11623258.html](https://www.cnblogs.com/1024th/p/11623258.html)

# 零知识证明 - Groth16 算法介绍

## 文章目录

- [术语介绍](https://learnblockchain.cn/2019/05/27/groth16/#%E6%9C%AF%E8%AF%AD%E4%BB%8B%E7%BB%8D)
    
- [Jens Groth是谁？](https://learnblockchain.cn/2019/05/27/groth16/#%E6%98%AF%E8%B0%81%EF%BC%9F)
    
- [NILP](https://learnblockchain.cn/2019/05/27/groth16/#NILP)
    
- QAP的NILP
    
    - [完备性证明（Completeness)：](https://learnblockchain.cn/2019/05/27/groth16/#%E5%AE%8C%E5%A4%87%E6%80%A7%E8%AF%81%E6%98%8E%EF%BC%88Completeness)：)
        
    - [可靠性证明 (Soundness):](https://learnblockchain.cn/2019/05/27/groth16/#%E5%8F%AF%E9%9D%A0%E6%80%A7%E8%AF%81%E6%98%8E%20(Soundness):)
        
- [QAP的NIZK Arguments](https://learnblockchain.cn/2019/05/27/groth16/#QAP%E7%9A%84NIZK%20Arguments)
    
- [证明元素的最小个数](https://learnblockchain.cn/2019/05/27/groth16/#%E8%AF%81%E6%98%8E%E5%85%83%E7%B4%A0%E7%9A%84%E6%9C%80%E5%B0%8F%E4%B8%AA%E6%95%B0)
    
- [总结：](https://learnblockchain.cn/2019/05/27/groth16/#%EF%BC%9A)
    

## 开始

Groth16，是由 Jens Groth 在 2016 年提出的算法。GGPR13，是由 Rosario Gennaro，Craig Gentry，Bryan Parno，Mariana Raykova 在 2013 年提出的算法。

看 zk-SNARK 的文章或者资料的时候，经常会碰到一些算法名称，比如 Groth16，GGPR13 等等。这些名称是由算法提出的作者名称或者名称首字母以及相应的年份组成。Groth16，是由 Jens Groth 在 2016 年提出的算法。GGPR13，是由 Rosario Gennaro，Craig Gentry，Bryan Parno，Mariana Raykova 在 2013 年提出的算法。

零知识证明（[zk-SNARK](https://learnblockchain.cn/2019/04/18/learn-zkSNARK/) )，从[QSP/QAP](https://learnblockchain.cn/2019/05/07/qsp-qap/)到 Groth16，期间也有很多学者专家，提出各种优化（优化计算时间，优化证明的大小，优化电路的尺寸等等）。Groth16 提出的算法，具有非常少的证明数据（2/3个证明数据）以及一个表达式验证。

Groth16 论文（On the Size of Pairing-based Non-interactive Arguments）可在[这里](https://eprint.iacr.org/2016/260.pdf)下载。

本文主要从工程应用理解的角度介绍 Groth16 算法的证明和验证过程。文章中所用的中文字眼可能和行业中不一样，欢迎批评指出。

## **术语介绍**

**Proofs** - 在零知识证明的场景下，Proofs指具有完美的完备性（Completeness）以及完美的可靠性（Soundness）。也就是，具有无限计算资源也无法攻破。

**Arguments** - 在零知识证明的场景下，Arguments 是指具有完美的完备性以及多项式计算的可靠性。也就是，在多项式计算能力下，是可靠的。

**Schwartz-Zippel 定理** - 假设 是个 元多项式，多项式总的阶为 。如果 是从有限集合 中随机选取，则 的概率是小于等于 。简单的说，如果多元多项式，在很大的集合中随机选取参数，恰好函数 等于 的概率几乎为 。参见[Schwartz-Zippel 定理 Wiki](https://brilliant.org/wiki/schwartz-zippel-lemma/)

**线性（Linear）函数** - 假设函数f满足两个条件：

2. ，则称函数 为线性函数。
    

**Affine 函数** - 假设函数 ，能找到一个线性函数 ，满足 ，则称函数 为 Affine 函数。也就是，Affine 函数是由一个线性函数和偏移构成。

**Trapdoor函数** - 假设一个Trapdoor函数 ， 很容易，但是 非常难。但是，如果提供一个 secret， 也非常容易。

## **Jens Groth**是谁？

Groth 是英国伦敦 UCL 大学的计算机系的教授。他的[介绍页](http://www0.cs.ucl.ac.uk/staff/j.groth/)。

伦敦大学学院 (_University College London_），简称UCL，建校于 1826 年，位于英国伦敦，是一所世界著名的顶尖高等学府，为享有顶级声誉的综合研究型大学，伦敦大学联盟创始院校，英国金三角名校，与剑桥大学、牛津大学、帝国理工、伦敦政经学院并称G5超级精英大学。

Groth 从 2009 年开始，每年发表一篇或者多篇密码学或者零知识证明的文章，所以你经常会听到 Groth09，Groth10 等等算法。

简言之，牛人～。

## NILP

Groth16 的论文先引出 NILP（non-interactive linear proofs）的定义：

1. ：设置过程，生成 。
    
2. ：证明过程，证明过程又分成两步：
    
    1. 生成线性关系 ，其中 是个多项式算法。
        
    2. 生成证明：。
        
3. ：验证过程，验证者使用 生成电路 ，并验证 是否成立。
    

在`NILP`定义的基础上，Groth16 进一步定义了 split NILP ，也就是说，CRS 分成两部分 ，证明者提交的证明也分成两部分 。

总的来说，核心在“Linear”上，证明者生成的证明和 CRS 成线性关系。

## QAP 的 NILP

QAP的定义为"Relation"： 。也就是说，statements 为 ， witness 为 ，并且 的情况下，满足如下的等式：

的阶为 。

1. 设置过程：随机选取 ，生成 。
    

2. 证明过程：随机选择两个参数 和 ，计算
    

3. 验证过程：
    

验证过程，计算如下的等式是否成立：

注意，设置过程中的 是一个值，不是代表多项式。在理解证明 / 验证过程的时候，必须要明确，的计算是和 中的参数成线性关系（NILP的定义）。在明确这一点的基础上，可以看出 和 的参数能保证 的计算采用统一的 参数。因为 会包含 子项，要保证 和 相等，必须采用统一的 参数。参数 和 增加随机因子，保证零知识（验证者无法从证明中获取有用信息）。参数 和 保证了验证等式的最后两个乘积独立于 和 的参数。

### **完备性证明（Completeness)：**

完备性证明，也就是验证等式成立。

### **可靠性证明 (Soundness):**

Groth16 算法证明的是 **statistical knowledge soundness**，假设证明者提供的证明和 CRS 成**线性**关系。也就是说，证明 A 可以用如下的表达式表达( A 和 CRS 的各个参数成线性关系）：

同理，B/C都可以写成类似的表达：

从 Schwartz-Zippel 定理，我们可以把 A/B/C看作是α,β,γ,δ,x_α_,_β_,_γ_,_δ_,_x_的多项式。观察这个验证等式，发现一些变量的限制条件：

1） (等式的右边没有α2因子_α_2因子)

不失一般性，可以假设 。

2） AαBβ+AβBα=AαBβ=1_A**α**B**β_+_A**β**B**α_=_A**α**B**β_=1 （等式右边αβ=1_α**β_=1）

不失一般性，可以假设Aα=Bβ=1_A**α_=_B**β_=1。

3） AβBβ=Aβ=0_A**β**B**β_=_A**β_=0(等式的右边没有β2_β_2因子)

也就是Aβ=0_A**β_=0。

在上述三个约束下，A/B的表达式变成：

A=α+Aγγ+Aδδ+A(x)+∑i=0ℓAiβui(x)+αvi(x)+wi(x)γ+∑i=ℓ+1mAiβui(x)+αvi(x)+wi(x)δ+Ah(x)t(x)δ_A_=_α_+_A**γ**γ_+_A**δ**δ_+_A_(_x_)+∑_i_=0ℓ_A**i**γ**β**u**i_(_x_)+_α**v**i_(_x_)+_w**i_(_x_)+∑_i_=ℓ+1_m**A**i**δ**β**u**i_(_x_)+_α**v**i_(_x_)+_w**i_(_x_)+_A**h_(_x_)_δ**t_(_x_)

B=β+Bγγ+Bδδ+B(x)+∑i=0ℓBiβui(x)+αvi(x)+wi(x)γ+∑i=ℓ+1mBiβui(x)+αvi(x)+wi(x)δ+Bh(x)t(x)δ_B_=_β_+_B**γ**γ_+_B**δ**δ_+_B_(_x_)+∑_i_=0ℓ_B**i**γ**β**u**i_(_x_)+_α**v**i_(_x_)+_w**i_(_x_)+∑_i_=ℓ+1_m**B**i**δ**β**u**i_(_x_)+_α**v**i_(_x_)+_w**i_(_x_)+_B**h_(_x_)_δ**t_(_x_)

4）等式的右边没有1δ2_δ_21

(∑i=ℓ+1mAi(βui(x)+αvi(x)+wi(x))+Ah(x)t(x))(∑i=ℓ+1mBi(βui(x)+αvi(x)+wi(x))+Ah(x)t(x))=0(∑_i_=ℓ+1_m**A**i_(_β**u**i_(_x_)+_α**v**i_(_x_)+_w**i_(_x_))+_A**h_(_x_)_t_(_x_))(∑_i_=ℓ+1_m**B**i_(_β**u**i_(_x_)+_α**v**i_(_x_)+_w**i_(_x_))+_A**h_(_x_)_t_(_x_))=0

不失一般性，∑i=ℓ+1mAi(βui(x)+αvi(x)+wi(x))+Ah(x)t(x)=0∑_i_=ℓ+1_m**A**i_(_β**u**i_(_x_)+_α**v**i_(_x_)+_w**i_(_x_))+_A**h_(_x_)_t_(_x_)=0

5）等式的右边没有1γ2_γ_21

(∑i=0ℓAi(βui(x)+αvi(x)+wi(x)))(∑i=0ℓBi(βui(x)+αvi(x)+wi(x)))=0(∑_i_=0ℓ_A**i_(_β**u**i_(_x_)+_α**v**i_(_x_)+_w**i_(_x_)))(∑_i_=0ℓ_B**i_(_β**u**i_(_x_)+_α**v**i_(_x_)+_w**i_(_x_)))=0

不失一般性，∑i=0ℓAi(βui(x)+αvi(x)+wi(x))=0∑_i_=0ℓ_A**i_(_β**u**i_(_x_)+_α**v**i_(_x_)+_w**i_(_x_))=0。

6）等式的右边没有αγ_γ**α_， αδ_δ**α_

α∑i=0ℓBi(βui(x)+αvi(x)+wi(x))γ=0_α**γ_∑_i_=0ℓ_B**i_(_β**u**i_(_x_)+_α**v**i_(_x_)+_w**i_(_x_))=0

α∑i=ℓ+1mBi(βui(x)+αvi(x)+wi(x))+Bh(x)t(x)δ=0_α**δ_∑_i_=ℓ+1_m**B**i_(_β**u**i_(_x_)+_α**v**i_(_x_)+_w**i_(_x_))+_B**h_(_x_)_t_(_x_)=0

所以，∑i=0ℓBi(βui(x)+αvi(x)+wi(x))=0，∑i=ℓ+1mBi(βui(x)+αvi(x)+wi(x))+Bh(x)t(x)∑_i_=0ℓ_B**i_(_β**u**i_(_x_)+_α**v**i_(_x_)+_w**i_(_x_))=0，∑_i_=ℓ+1_m**B**i_(_β**u**i_(_x_)+_α**v**i_(_x_)+_w**i_(_x_))+_B**h_(_x_)_t_(_x_) 。

7）等式的右边没有βγ_β**γ_和αγ_α**γ_

Aγβγ=0,Bγαγ=0_A**γ**β**γ_=0,_B**γ**α**γ_=0

所以，Aγ=0,Bγ=0_A**γ_=0,_B**γ_=0。

在上述七个约束下，A/B的表达式变成：

A=α+Aδδ+A(x)_A_=_α_+_A**δ**δ_+_A_(_x_)

B=β+Bδδ+B(x)_B_=_β_+_B**δ**δ_+_B_(_x_)

再看验证的等式：

A⋅B=α⋅β+∑i=0ℓai(βui(x)+αvi(x)+wi(x))γ⋅γ+C⋅δ_A_⋅_B_=_α_⋅_β_+_γ_∑_i_=0ℓ_a**i_(_β**u**i_(_x_)+_α**v**i_(_x_)+_w**i_(_x_))⋅_γ_+_C_⋅_δ_

=α⋅β+∑i=0ℓai(βui(x)+αvi(x)+wi(x))+C⋅δ=_α_⋅_β_+∑_i_=0ℓ_a**i_(_β**u**i_(_x_)+_α**v**i_(_x_)+_w**i_(_x_))+_C_⋅_δ_

观察C⋅δ_C_⋅_δ_，因为不存在 δγ_γ**δ_，所以，∑i=0ℓCiβui(x)+αvi(x)+wi(x)γ=0∑_i_=0ℓ_C**i**γ**β**u**i_(_x_)+_α**v**i_(_x_)+_w**i_(_x_)=0。

也就是说，C=Cαα+Cββ+Cγγ+Cδδ+C(x)+∑i=ℓ+1mCiβui(x)+αvi(x)+wi(x)δ+Ch(x)t(x)δ_C_=_C**α**α_+_C**β**β_+_C**γ**γ_+_C**δ**δ_+_C_(_x_)+∑_i_=ℓ+1_m**C**i**δ**β**u**i_(_x_)+_α**v**i_(_x_)+_w**i_(_x_)+_C**h_(_x_)_δ**t_(_x_)。

代入验证等式，所以可以推导出：

αB(x)=∑i=0ℓaiαvi(x)+∑i=ℓ+1mCiαvi(x)_α**B_(_x_)=∑_i_=0ℓ_a**i**α**v**i_(_x_)+∑_i_=ℓ+1_m**C**i**α**v**i_(_x_)，

βA(x)=∑i=0ℓaiβui(x)+∑i=ℓ+1mCiβui(x)_β**A_(_x_)=∑_i_=0ℓ_a**i**β**u**i_(_x_)+∑_i_=ℓ+1_m**C**i**β**u**i_(_x_)

如果，假设，对于i=ℓ+1,...,m，ai=Ci_i_=ℓ+1,...,_m_，_a**i_=_C**i_，则

A(x)=∑i=0maiui(x)_A_(_x_)=∑_i_=0_m**a**i**u**i_(_x_)

B(x)=∑i=0maivi(x)_B_(_x_)=∑_i_=0_m**a**i**v**i_(_x_)

代入A/B，可以获取以下等式：

∑i=0maiui(x)⋅∑i=0maivi(x)=∑i=0maiwi(x)+Ch(x)t(x)∑_i_=0_m**a**i**u**i_(_x_)⋅∑_i_=0_m**a**i**v**i_(_x_)=∑_i_=0_m**a**i**w**i_(_x_)+_C**h_(_x_)_t_(_x_)

在证明和CRS线性关系下，所有能使验证等式成立的情况下，(aℓ+1,...,am)=(Cℓ+1,...,Cm)(_a_ℓ+1,...,_a**m_)=(_C_ℓ+1,...,_C**m_)等式必须成立。也就说，能提供正确证明的，肯定知道witness。

## **QAP的NIZK Arguments**

从QAP的NILP可以演化为QAP的NIZK Arguments。也就是说Groth16算法并不是完美的可靠，而是多项式计算情况下可靠。QAP的定义为"**R**elation"：R=(p,G1,G2,GT,e,g,h,ℓ,{ui(X),vi(X),wi(X)}i=0m,t(X))_R_=(_p_,_G_1,_G_2,_G**T_,_e_,_g_,_h_,ℓ,{_u**i_(_X_),_v**i_(_X_),_w**i_(_X_)}_i_=0_m_,_t_(_X_))。也就是说，在一个域Zp_Z**p_中，statements为(a1,...,aℓ)∈Zpℓ(_a_1,...,_a_ℓ)∈_Z**p_ℓ， witness为(al+1,...,am)∈Zpm−ℓ(_a**l_+1,...,_a**m_)∈_Z**p**m_−ℓ，并且a0=1_a_0=1的情况下，满足如下的等式（t(X)_t_(_X_)的阶为n）：

∑i=0maiui(X)⋅∑i=0maivi(X)=∑i=0maiwi(X)+h(X)t(X)∑_i_=0_m**a**i**u**i_(_X_)⋅∑_i_=0_m**a**i**v**i_(_X_)=∑_i_=0_m**a**i**w**i_(_X_)+_h_(_X_)_t_(_X_)

也就是说，三个有限群G1,G2,GT_G_1,_G_2,_G**T_, 对应的生成元分别是g,h,e(g,h)_g_,_h_,_e_(_g_,_h_)。为了方便起见，也为了和论文的表达方式一致，G1有限群_G_1有限群的计算用[y]1=gy[_y_]1=_g**y_表示，G2有限群_G_2有限群的计算用[y]2=hy[_y_]2=_h**y_表示。

1). 设置过程：随机选取α,β,γ,δ,x←Zp∗_α_,_β_,_γ_,_δ_,_x_←_Z**p_∗，生成σ,τ_σ_,_τ_。

τ=(α,β,γ,δ,x)_τ_=(_α_,_β_,_γ_,_δ_,_x_)

σ=([σ1]1,[σ2]2)_σ_=([_σ_1]1,[_σ_2]2)

σ1=(α,β,δ,{xi}i=0n−1,{βui(x)+αvi(x)+wi(x)γ}i=0ℓ,{βui(x)+αvi(x)+wi(x)δ}i=ℓ+1m,{xit(x)δ}i=0n−2)_σ_1=(_α_,_β_,_δ_,{_x**i_}_i_=0_n_−1,{_γ**β**u**i_(_x_)+_α**v**i_(_x_)+_w**i_(_x_)}_i_=0ℓ,{_δ**β**u**i_(_x_)+_α**v**i_(_x_)+_w**i_(_x_)}_i_=ℓ+1_m_,{_δ**x**i**t_(_x_)}_i_=0_n_−2)

σ2=(β,γ,δ,{xi}i=0n−1)_σ_2=(_β_,_γ_,_δ_,{_x**i_}_i_=0_n_−1)

2). 证明过程：随机选择两个参数r和s_r_和_s_，计算π=Πσ=([A]1,[C]1,[B]2)_π_=Π_σ_=([_A_]1,[_C_]1,[_B_]2)

A=α+∑i=0maiui(x)+rδ_A_=_α_+∑_i_=0_m**a**i**u**i_(_x_)+_rδ_

B=β+∑i=0maivi(x)+sδ_B_=_β_+∑_i_=0_m**a**i**v**i_(_x_)+_sδ_

C=∑i=ℓ+1mai(βui(x)+αvi(x)+wi(x))+h(x)t(x)δ+As+rB−rsδ_C_=_δ_∑_i_=ℓ+1_m**a**i_(_β**u**i_(_x_)+_α**v**i_(_x_)+_w**i_(_x_))+_h_(_x_)_t_(_x_)+_A**s_+_r**B_−_rsδ_

3). 验证过程：验证如下的等式是否成立。

[A]1⋅[B]2=[α]1⋅[β]2+∑i=0ℓai[βui(x)+αvi(x)+wi(x)γ]1⋅[γ]2+[C]1⋅[δ]2[_A_]1⋅[_B_]2=[_α_]1⋅[_β_]2+∑_i_=0ℓ_a**i_[_γ**β**u**i_(_x_)+_α**v**i_(_x_)+_w**i_(_x_)]1⋅[_γ_]2+[_C_]1⋅[_δ_]2

很容易发现，验证过程的等式也可以用4个配对函数表示:

e([A]1,[B]2)=e([α]1,[β]2)⋅e(∑i=0ℓai[βui(x)+αvi(x)+wi(x)γ]1,[γ]2)⋅e([C]1,[δ]2)_e_([_A_]1,[_B_]2)=_e_([_α_]1,[_β_]2)⋅_e_(∑_i_=0ℓ_a**i_[_γ**β**u**i_(_x_)+_α**v**i_(_x_)+_w**i_(_x_)]1,[_γ_]2)⋅_e_([_C_]1,[_δ_]2)

证明过程和QAP的NILP的证明过程类似，不再详细展开。

## **证明元素的最小个数**

论文指出zk-SNARK的最少的证明元素是**2个**。上述的证明方式是需要提供3个证明元素（A/B/C）。论文进一步说明，如果将电路进行一定方式的改造，使用同样的理论，可以降低证明元素为2个，但是，电路的大小会变的很大。

## **总结**：

Groth16算法是Jens Groth在2016年发表的算法。该算法的优点是提供的证明元素个数少（只需要3个），验证等式简单，保证完整性和多项式计算能力下的可靠性。Groth16算法论文同时指出，zk-SNARK算法需要的最少的证明元素为2个。目前Groth16算法已经被ZCash，Filecoin等项目使用。

**题外：**

最近好多朋友表示对零知识证明的基础知识感兴趣，但是，zk-SNARK相关的技术涉及到比较多的数学公式的推导，比较难理解。我打算有空录个QSP/QAP/Groth16的介绍视频，方便工程开发人员快速的入门和理解。觉得有需要的小伙伴，大家可扫描以下二维码关注我的公众号-星想法留言“零知识证明”。

本文参与[登链社区写作激励计划](https://learnblockchain.cn/site/coins) ，好文好收益，欢迎正在阅读的你也加入。

- [零知识证明编程 - 使用 Circom、Groth16 构建证明及验证](https://learnblockchain.cn/article/9178) 158 浏览
    
- [ZK技术的历史发展脉络梳理](https://learnblockchain.cn/article/8991) 414 浏览
    
- [【视频】Tornado Cash 代码实践系列](https://learnblockchain.cn/article/8984) 402 浏览
    
- [解读Cysic：硬件加速与ZK矿业的崛起前夜](https://learnblockchain.cn/article/8850) 524 浏览
    
- [以太坊Layer2扩容方案之Rollup](https://learnblockchain.cn/article/8408) 756 浏览
    
- [本地搭建和测试zkLogin零知识证明服务 @SUI Move开发必知必会](https://learnblockchain.cn/article/8371) 798 浏览
    
- [Circle STARKs 系列（一）：梅森素域](https://learnblockchain.cn/article/8352) 834 浏览
    
- [零知识证明 - 说说Binius](https://learnblockchain.cn/article/8225) 973 浏览
    
- [以太坊 Layer2：Rollup 战争](https://learnblockchain.cn/article/7808) 1239 浏览
    
- [基于 ZK 的资产证明](https://learnblockchain.cn/article/7801) 1309 浏览
    
- [了解零知识证明历史](https://learnblockchain.cn/article/7422) 2114 浏览
    
- [如何使用 Circom 和 SnarkJS 实现极简 NFT zkRollup](https://learnblockchain.cn/article/7407) 1712 浏览
    

# 零知识证明 - Groth16 计算详解

原文： [https://learnblockchain.cn/2019/12/19/zkp-Groth16](https://learnblockchain.cn/2019/12/19/zkp-Groth16)

Groth16 算法是 zkSNARK 的典型算法，目前在 ZCash，Filecoin，Coda 等项目中使用。本文从计算量的角度详细分析 Groth16 计算。Groth16 计算分成三个部分：

1. Setup 针对电路生成 Pk/Vk（证明/验证密钥）
    
2. Prove 在给定 witness/statement 的情况下生成证明
    
3. Verify 通过 Vk 验证证明是否正确。
    

Groth16 算法是 zkSNARK 的典型算法，目前在 ZCash，Filecoin，Coda 等项目中使用。本文从计算量的角度详细分析 Groth16 计算。Groth16 计算分成三个部分：Setup 针对电路生成 Pk/Vk（证明/验证密钥），Prove 在给定 witness/statement 的情况下生成证明，Verify 通过 Vk 验证证明是否正确。

本文中所有的术语和数学符号和 Groth16 论文保持一致（[On the Size of Pairing-based Non-interactive Arguments](https://eprint.iacr.org/2016/260.pdf)，具体的计算在17/18页）：

对Groth16算法的理解可查看：

[零知识证明 - Groth16算法介绍](https://learnblockchain.cn/2019/05/27/groth16/)

对libSnark代码库的理解可查看：

[零知识证明 - libsnark源代码分析](https://learnblockchain.cn/2019/08/15/libsnark-source/)

## 1. 电路描述

所有的电路描述有个专业的术语：Relation（变量和变量的关系描述）。描述Relation的语言很多：R1CS，QAP，tinyRAM，bacs等等。目前开发，电路一般采用R1CS语言描述。R1CS相对来说，非常直观。A*B=C（A/B/C分别是输入变量的线性组合）。但是，要应用Groth16算法，需要将R1CS描述的电路，转化为QAP描述。两种电路描述语言的转化，称为Reduction。

### 1.1 R1CS描述

给定M'个变量（第一个变量约定为恒量1），以及N'个约束，所有的R1CS描述可以表示如下： ![R1CS](https://img.learnblockchain.cn/2019/12/15767182331506.jpg)

每一行是一个约束。举例，第一行的约束表示的是： ![约束](https://img.learnblockchain.cn/2019/12/15767201351613.jpg)

### 1.2 QAP转化

介绍具体的转化之前，先介绍一个简单的术语，拉格朗日插值以及拉格朗日basis。

给定一系列的x和y的对应关系，通过拉格朗日插值的方式，可以确定多项式： ![多项式](https://img.learnblockchain.cn/2019/12/15767211841961.jpg)

其中l0(x),l1(x),...ln(x)_l_0(_x_),_l_1(_x_),..._l**n_(_x_)就称为拉格朗日basis，计算公式如下： ![公式](https://img.learnblockchain.cn/2019/12/15767212375102.jpg)

简单的说，在给定一系列的x/y的对应关系后，可以通过拉格朗日插值表示成多项式。在R1CS的表达方式下，U/V/W多项式很自然用拉格朗日basis表示，并不是以多项式的系数表示。 在R1CS转化为QAP之前，必须**对现有约束进行增强**，增加ai∗0=0_a**i_∗0=0的约束。增加这些约束的原因是为了保证转化后的QAP的各个多项式不线性依赖。 ![转化](https://img.learnblockchain.cn/2019/12/15767212675254.jpg)

### 1.3 domain选择

针对每个变量，已经知道N个y值。如何选择这些y值，对应的x值？这个就是domain的选择。选择domain，主要考虑两个计算性能：

1. 拉格朗日插值
    
2. FFT和iFFT。
    

libfqfft的源码提供了几种domain：

1. Basic Radix-2
    
2. Extended Radix-2
    
3. Step Radix-2
    
4. Arithmetic Sequence
    
5. Geometric Sequence
    

选择哪一种domain和输入个数（M）有关。为了配合特定domain的计算，domain的阶（M）会稍稍变大。

确定了domain，也就确定了domain上的一组元素s： ![一组](https://img.learnblockchain.cn/2019/12/15767213883884.jpg)

## 2. Setup计算

随机生成 α,β,γ,δ,x∈Fr_α_,_β_,_γ_,_δ_,_x_∈_F**r_ 。注意这里的和上一节中的x含义不同，不要混淆。

### 2.1 拉格朗日插值

已知的情况下，通过1.2的公式，先通过domain计算拉格朗日basis。再乘上系数，可以获得ui(x),vi(x),wi(x)_u**i_(_x_),_v**i_(_x_),_w**i_(_x_)。这些多项式的阶是M。

### 2.2 计算xi_x**i_ 和 t(x)_t_(_x_)

xi_x**i_ 的计算相对简单，注意幂次计算都是在Fr_F**r_的计算。在domain确定后，多项式t也确定，从而可以计算出t(x)_t_(_x_)。

### 2.3 生成Pk/Vk

按照如下的公式，计算Pk/Vk。σ1_σ_1 是G1上的点，σ2_σ_2是G2上的点。 ![h](https://img.learnblockchain.cn/2019/12/15767218514113.jpg)

其中， ![i](https://img.learnblockchain.cn/2019/12/15767218630732.jpg)

是Vk。其他部分是Pk。可以看出，Vk的大小取决于公共输入的变量个数，相对来说数量比较小。Pk的数据量大小和所有的变量个数相关。计算过程，主要由scalarMul组成。

## 3. Prove计算

在domain选择后，U*V=W，可以变换为如下的多项式方程： ![多项式方程](https://img.learnblockchain.cn/2019/12/15767218954398.jpg)

### 3.1 多项式系数ui(x),vi(x),wi(x)_u**i_(_x_),_v**i_(_x_),_w**i_(_x_)多项式系数

通过iFFT，在已知domain上元素s和值对应关系，可以计算出多项式系数。

### 3.2 ui(x),vi(x),wi(x)_u**i_(_x_),_v**i_(_x_),_w**i_(_x_) 在coset的值

ui(x),vi(x),wi(x)_u**i_(_x_),_v**i_(_x_),_w**i_(_x_)在coset的值 已知多项式系数，通过FFT，计算出多项式在coset的值。注意，元素s以及对应的coset是特殊设计的，便于FFT/iFFT的计算，和domain的选择有关系。

### 3.3 h(X)在coset的值

h(X)多项式的计算公式如下： ![公式](https://img.learnblockchain.cn/2019/12/15767220190023.jpg)

代入3.1/3.2，直接计算出h(X)在coset的值。

### 3.4 计算h(X)多项式系数

通过iFFT，获取h(X)的多项式系数，阶为N-2。

### 3.5 生成证明

随机选择r,s∈Fr_r_,_s_∈_F**r_，在已知ui(x),vi(x),wi(x),h(x)_u**i_(_x_),_v**i_(_x_),_w**i_(_x_),_h_(_x_)的情况下，通过如下的公式计算证明A，B，C： ![证明](https://img.learnblockchain.cn/2019/12/15767221030541.jpg)

其中，A需要计算在G1上的点，B需要计算在G1/G2上的点，C需要计算G1上的点。C中h(x)t(x)δ_δ**h_(_x_)_t_(_x_)计算如下： ![计算](https://img.learnblockchain.cn/2019/12/15767221449716.jpg)

很显然，生成证明的计算量主要由四个Multiexp组成（A-1，B-1，C-2），和变量个数以及约束的个数有关。在一个大型电路中，生成证明的时间比较长（秒级，甚至分钟级）。

## 4. Verify计算

在已知证明以及Vk的情况下，通过配对（pairing）函数，很容易计算如下的等式是否成立。计算在毫秒级。 ![计算](https://img.learnblockchain.cn/2019/12/15767221787917.jpg)

## 总结：

Groth16算法的主要计算量由两部分组成：FFT/iFFT以及MultiExp。在生成证明时，需要4次iFFT以及三次FFT计算。Setup计算和生成证明时，需要大量的MultiExp。Verify计算量相对较小。

我是Star Li，我的公众号**星想法**有很多原创高质量文章，欢迎大家扫码关注。

![公众号-星想法](https://img.learnblockchain.cn/2019/15572190575887.jpg!/scale/20)

- [转载](https://mp.weixin.qq.com/s/lBz255xbY82YyX2A-Cj3wA)
    

- 学分: 20
    

- 分类: [零知识证明](https://learnblockchain.cn/categories/zkp)
    

- 标签: [零知识证明](https://learnblockchain.cn/tags/%E9%9B%B6%E7%9F%A5%E8%AF%86%E8%AF%81%E6%98%8E) [Groth16](https://learnblockchain.cn/tags/Groth16) [zkSNARK](https://learnblockchain.cn/tags/zkSNARK)
    

点赞 0

收藏 1

分享

本文参与[登链社区写作激励计划](https://learnblockchain.cn/site/coins) ，好文好收益，欢迎正在阅读的你也加入。

- [零知识证明编程 - 使用 Circom、Groth16 构建证明及验证](https://learnblockchain.cn/article/9178) 158 浏览
    
- [可编程密码学 - 第一篇](https://learnblockchain.cn/article/9015) 405 浏览
    
- [ZK技术的历史发展脉络梳理](https://learnblockchain.cn/article/8991) 414 浏览
    
- [【视频】Tornado Cash 代码实践系列](https://learnblockchain.cn/article/8984) 402 浏览
    
- [zk-SNARK 系列 - #2 证明多项式的知识](https://learnblockchain.cn/article/8952) 426 浏览
    
- [解读Cysic：硬件加速与ZK矿业的崛起前夜](https://learnblockchain.cn/article/8850) 524 浏览
    
- [zk-SNARK 系列 - #1 SNARK介绍 & 证明媒介](https://learnblockchain.cn/article/8829) 423 浏览
    
- [17 个关于 SNARKs 的误解（以及为什么会有这样的误解）](https://learnblockchain.cn/article/8808) 453 浏览
    
- [以太坊Layer2扩容方案之Rollup](https://learnblockchain.cn/article/8408) 756 浏览
    
- [本地搭建和测试zkLogin零知识证明服务 @SUI Move开发必知必会](https://learnblockchain.cn/article/8371) 798 浏览
    
- [Circle STARKs 系列（一）：梅森素域](https://learnblockchain.cn/article/8352) 834 浏览
    
- [零知识证明 - 说说Binius](https://learnblockchain.cn/article/8225) 973 浏览
    

## 0 条评论

请先 [登录](https://learnblockchain.cn/login) 后评论

[![Star Li](https://learnblockchain.cn/image/avatar/28_big.jpg?hl69qjQB)](https://learnblockchain.cn/people/28)

**Star Li**

![img](https://learnblockchain.cn/css/default/github_gra.svg) ![img](https://learnblockchain.cn/css/default/twitter.svg)

关注

[**贡献值: 1051**](https://learnblockchain.cn/people/28/credits)[**学分: 8297**](https://learnblockchain.cn/people/28/coins)

Trapdoor Tech创始人，前猎豹移动技术总监，香港中文大学访问学者。

## 文章目录

- 1. 电路描述
        
    
    - [1.1 R1CS描述](https://learnblockchain.cn/2019/12/19/zkp-Groth16#1.1%20R1CS%E6%8F%8F%E8%BF%B0)
        
    - [1.2 QAP转化](https://learnblockchain.cn/2019/12/19/zkp-Groth16#1.2%20QAP%E8%BD%AC%E5%8C%96)
        
    - [1.3 domain选择](https://learnblockchain.cn/2019/12/19/zkp-Groth16#1.3%20domain%E9%80%89%E6%8B%A9)
        
- 2. Setup计算
        
    
    - [2.1 拉格朗日插值](https://learnblockchain.cn/2019/12/19/zkp-Groth16#2.1%20%E6%8B%89%E6%A0%BC%E6%9C%97%E6%97%A5%E6%8F%92%E5%80%BC)
        
    - [2.2 计算xix^ixi 和 t(x)t(x)t(x)](https://learnblockchain.cn/2019/12/19/zkp-Groth16#t(x)t(x)t(x))
        
    - [2.3 生成Pk/Vk](https://learnblockchain.cn/2019/12/19/zkp-Groth16#2.3%20%E7%94%9F%E6%88%90Pk/Vk)
        
- 3. Prove计算
        
    
    - [3.1 多项式系数ui(x),vi(x),wi(x)u_i(x),v_i(x),w_i(x)ui(x),vi(x),wi(x)多项式系数](https://learnblockchain.cn/2019/12/19/zkp-Groth16#%E5%A4%9A%E9%A1%B9%E5%BC%8F%E7%B3%BB%E6%95%B0)
        
    - [3.2 ui(x),vi(x),wi(x)u_i(x),v_i(x),w_i(x)ui(x),vi(x),wi(x) 在coset的值](https://learnblockchain.cn/2019/12/19/zkp-Groth16#%20%E5%9C%A8coset%E7%9A%84%E5%80%BC)
        
    - [3.3 h(X)在coset的值](https://learnblockchain.cn/2019/12/19/zkp-Groth16#3.3%20h(X)%E5%9C%A8coset%E7%9A%84%E5%80%BC)
        
    - [3.4 计算h(X)多项式系数](https://learnblockchain.cn/2019/12/19/zkp-Groth16#3.4%20%E8%AE%A1%E7%AE%97h(X)%E5%A4%9A%E9%A1%B9%E5%BC%8F%E7%B3%BB%E6%95%B0)
        
    - [3.5 生成证明](https://learnblockchain.cn/2019/12/19/zkp-Groth16#3.5%20%E7%94%9F%E6%88%90%E8%AF%81%E6%98%8E)
        
- [4. Verify计算](https://learnblockchain.cn/2019/12/19/zkp-Groth16#4.%20Verify%E8%AE%A1%E7%AE%97)
    
- [总结：](https://learnblockchain.cn/2019/12/19/zkp-Groth16#%E6%80%BB%E7%BB%93%EF%BC%9A)
    

[![img](https://learnblockchain.cn/image/show/banners-BQ8K7zJO666ac16d80b23.jpg)](https://learnblockchain.cn/maps/Web3)

- 关于
    
    [关于我们](https://learnblockchain.cn/article/265)
    
    [社区公约](https://learnblockchain.cn/article/297)
    
    [学分规则](https://learnblockchain.cn/article/298)
    
    [Github](https://github.com/lbc-team)
    
- 伙伴们
    
    [DeCert](https://decert.me/)
    
    [ChainTool](https://chaintool.tech/)
    
    [GCC](https://www.gccofficial.org/)
    
- 合作
    
    [广告投放](https://learnblockchain.cn/article/4458)
    
    [发布课程](https://learnblockchain.cn/courses)
    
    [联系我们](https://learnblockchain.cn/article/5650)
    
    [友情链接](https://learnblockchain.cn/friends/)
    
- 关注社区
    
    [Discord](https://discord.gg/hRZrM92hfw)
    
    [Twitter](https://twitter.com/UpchainDAO)
    
    [Youtube](https://www.youtube.com/@upchain)
    
    [B 站](https://space.bilibili.com/581611011)
    
- 公众号
    
    ![img](https://img.learnblockchain.cn/qrcode/dlsq-qrcode.jpg)关注不错过动态
    
- 微信群
    
    ![img](https://img.learnblockchain.cn/attachments/2024/03/LXatRfGs65e58b8734830.png)加入技术圈子
    

©2024 [登链社区](https://learnblockchain.cn/) 版权所有 | Powered By [Tipask3.5](http://www.tipask.com/)| [站长统计](https://www.cnzz.com/stat/website.php?web_id=1265946080)

 [![img](https://img.learnblockchain.cn/pics/20201202144947.png) 粤公网安备 44049102496617号](http://www.beian.gov.cn/) [粤ICP备17140514号](http://beian.miit.gov.cn/) [粤B2-20230927](https://dxzhgl.miit.gov.cn/dxxzsp/xkz/xkzgl/resource/qiyesearch.jsp?num=%E7%B2%A4B2-20230927&type=xuke) [增值电信业务经营许可证](https://img.learnblockchain.cn/attachments/2023/09/8FoWAmn064fe6378cea88.jpg)

### 核心概念

1. **零知识证明**：
    
    - 零知识证明是一种特殊的证明协议，允许证明者向验证者证明某个断言的正确性，同时不泄露任何关于该断言的具体信息，除了它是正确的。
        
2. **Groth16 签名方案**：
    
    - Groth16 是由 Jens Groth 在2016年提出的一种零知识证明方案，其基础建立在双线性映射和配对操作之上，通常应用于椭圆曲线密码学和相关的离散对数问题。
        
3. **双线性映射和配对**：
    
    - 在椭圆曲线密码学中，双线性映射和配对操作是一种特殊的数学运算，它将椭圆曲线群中的元素映射到扩展的有限域上，具有一些特定的代数性质，如双线性性和非退化性。
        

### Groth16 的构成要素

Groth16 零知识证明系统包含以下重要的构成要素：

1. **声明 (Statement)**：
    
    - 要验证的断言或声明，通常表示为某种数学关系或特性的存在。
        
2. **证明 (Proof)**：
    
    - 由证明者生成的数据结构，用于证明声明的真实性。Groth16 证明由三部分组成：( (A, B, C) )。这些部分分别属于椭圆曲线群和扩展的有限域。
        
3. **验证者 (Verifier)**：
    
    - 使用公开的验证密钥验证证明的有效性。验证者不需要了解证明的生成过程，只需检查证明的结构和使用配对函数来验证其正确性。
        
4. **双线性映射和配对操作**：
    
    - 在 Groth16 中，配对操作起着核心作用。它们将椭圆曲线群中的元素映射到扩展的有限域 ( \mathbb{F}_{q^{12}} ) 上，并具有以下性质：
        
        - 双线性性：对于椭圆曲线群中的元素 ( P ) 和 ( Q )，以及标量 ( a, b )，有 ( e(aP, bQ) = e(P, Q)^{ab} )。
            
        - 非退化性：如果 ( P \neq 0 ) 或 ( Q \neq 0 )，则配对 ( e(P, Q) ) 不等于单位元 ( 1 )。
            

### Groth16 的应用

Groth16 零知识证明系统在实际中有多种应用，包括但不限于：

- **隐私保护**：例如，验证某个用户拥有特定数字资产的所有权，而不泄露该用户的身份信息。
    
- **身份验证**：验证某个用户知道其私钥，而无需披露私钥本身。
    
- **安全协议**：作为构建更复杂加密协议的组成部分，如多方计算和零知识交互协议。
    

### 总结

Groth16 是一种强大的零知识证明系统，基于现代密码学的数学基础和算法，提供了一种有效的方法来验证断言的真实性，同时保护相关信息的隐私。它的核心在于双线性映射和配对操作，这些操作在椭圆曲线密码学中具有重要的应用和理论基础。

# python 实现

实现 Groth16 零知识证明系统的完整代码在 Python 中同样涉及复杂的数学概念和算法，特别是涉及椭圆曲线密码学和有限域运算。下面我将展示一个简化版本的 Python 代码框架，帮助你理解如何实现 Groth16 验证部分的逻辑。

### 1. 添加依赖

在 Python 中，你可以使用现有的密码学库来处理椭圆曲线和配对操作。在本例中，我们将使用 `py_ecc` 库来进行椭圆曲线操作。

pip install py_ecc

### 2. 导入必要的库和模块

from py_ecc import bls12_381  
from py_ecc.bls12_381 import G1, G2, FQ12, pairing  
from hashlib import sha256  
from typing import List

### 3. 定义 Groth16 验证函数

def verify_groth16(  
    vk_alpha_g1: G1,  
    vk_beta_g2: G2,  
    vk_gamma_g2: G2,  
    vk_delta_g2: G2,  
    vk_uvw_gamma_g1: List[G1],  
    public_inputs: List[int],  
    proof_a: G1,  
    proof_b: G2,  
    proof_c: G1,  
) -> bool:  
    # Compute left-hand side pairing e(proof_a, proof_b)  
    pairing_ab = pairing(proof_a, proof_b)  
​  
    # Compute left-hand side pairing e(proof_c, vk_delta_g2)  
    pairing_cd = pairing(proof_c, vk_delta_g2)  
​  
    # Compute right-hand side pairings  
    multi_pairing = pairing(  
        proof_a, vk_alpha_g1  
    ) * pairing(  
        proof_b, vk_beta_g2  
    ) * pairing(  
        proof_c, vk_gamma_g2  
    )  
​  
    for uvw_gamma_g1, input in zip(vk_uvw_gamma_g1, public_inputs):  
        multi_pairing *= pairing(uvw_gamma_g1, vk_gamma_g2.scalar_mul(input))  
​  
    # Compare pairings  
    return pairing_ab == multi_pairing and pairing_cd == FQ12.one()

### 4. 示例代码

def main():  
    # Example setup  
    alpha = G1(bls12_381.G1)  # replace with actual alpha value  
    beta = G2(bls12_381.G2)  # replace with actual beta value  
    gamma = G2(bls12_381.G2)  # replace with actual gamma value  
    delta = G2(bls12_381.G2)  # replace with actual delta value  
    uvw_gamma = [G1(bls12_381.G1), G1(bls12_381.G1), G1(bls12_381.G1)]  # replace with actual uvw_gamma values  
    inputs = [1, 2, 3]  # replace with actual public inputs  
    proof_a = G1(bls12_381.G1)  # replace with actual proof_a value  
    proof_b = G2(bls12_381.G2)  # replace with actual proof_b value  
    proof_c = G1(bls12_381.G1)  # replace with actual proof_c value  
​  
    # Verification  
    verified = verify_groth16(  
        alpha,  
        beta,  
        gamma,  
        delta,  
        uvw_gamma,  
        inputs,  
        proof_a,  
        proof_b,  
        proof_c,  
    )  
​  
    print(f"Verification result: {verified}")  
​  
if __name__ == "__main__":  
    main()

### 解释

- **依赖和导入**：使用 `py_ecc` 提供的 `bls12_381` 模块，这里选择了 BLS12-381 曲线作为椭圆曲线。`hashlib` 用于哈希函数。
    
- **验证函数**：`verify_groth16` 函数执行 Groth16 验证步骤。它计算左侧的配对值和右侧的多重配对值，并将它们进行比较来验证证明的有效性。
    
- **示例代码**：在 `main` 函数中，展示了如何设置测试数据，并调用 `verify_groth16` 函数进行验证。
    

请注意，实际的 Groth16 实现可能需要更多的复杂数学运算和安全考虑。此代码提供了一个简单的入门点，帮助你理解如何在 Python 中开始实现 Groth16 验证功能。在实际应用中，你需要根据具体的需求和库函数的使用方法进行详细的实现和测试。

# rust 实现

实现 Groth16 零知识证明系统的完整代码可能比较复杂，涉及到椭圆曲线密码学、有限域运算等复杂的数学概念和算法。在 Rust 中，通常会使用相应的密码学库和数学库来实现这些功能。下面我将展示一个简化版本的 Rust 代码框架，帮助你开始理解如何实现 Groth16 零知识证明系统的验证部分。

### 1. 添加依赖

首先，你需要在 `Cargo.toml` 文件中添加依赖，例如：

[dependencies]  
pairing-plus = "0.6.1"  # 提供椭圆曲线和配对操作的库  
rand = "0.8.5"          # 提供随机数生成器

### 2. 导入必要的库

extern crate pairing_plus;  
extern crate rand;  
​  
use pairing_plus::{  
    bls12_381::{Bls12, Fr, G1Affine, G2Affine, Gt},  
    hash_to_field::ExpandMsgXmd,  
    CurveProjective, Engine, MultiMillerLoop,  
};  
use rand::{Rng, SeedableRng};  
use rand::rngs::StdRng;  
use std::convert::TryInto;

### 3. 定义 Groth16 验证函数

fn verify_groth16(  
    vk_alpha_g1: G1Affine,  
    vk_beta_g2: G2Affine,  
    vk_gamma_g2: G2Affine,  
    vk_delta_g2: G2Affine,  
    vk_uvw_gamma_g1: Vec<G1Affine>,  
    public_inputs: Vec<Fr>,  
    proof_a: G1Affine,  
    proof_b: G2Affine,  
    proof_c: G1Affine,  
) -> bool {  
    // 1. Compute left-hand side pairing <proof_a, proof_b>  
    let pairing_ab = Bls12::pairing(proof_a, proof_b);  
​  
    // 2. Compute left-hand side pairing <proof_c, vk_delta_g2>  
    let pairing_cd = Bls12::pairing(proof_c, vk_delta_g2);  
​  
    // 3. Compute right-hand side pairings  
    let mut multi_pairing = Bls12::multi_miller_loop(&[  
        (&proof_a.prepare(), &vk_alpha_g1.prepare()),  
        (&proof_b.prepare(), &vk_beta_g2.prepare()),  
        (&proof_c.prepare(), &vk_gamma_g2.prepare()),  
    ]);  
​  
    for (uvw_gamma_g1, input) in vk_uvw_gamma_g1.iter().zip(public_inputs.iter()) {  
        let pairing_uv = Bls12::pairing(*uvw_gamma_g1, vk_gamma_g2.mul(*input));  
        multi_pairing = multi_pairing.mul_pairing(pairing_uv);  
    }  
​  
    // 4. Compare pairings  
    pairing_ab == multi_pairing.final_exponentiation() && pairing_cd == Gt::identity()  
}

### 4. 示例代码

fn main() {  
    // Example setup  
    let rng = &mut StdRng::seed_from_u64(0u64);  
    let alpha = G1Affine::rand(rng).into();  
    let beta = G2Affine::rand(rng).into();  
    let gamma = G2Affine::rand(rng).into();  
    let delta = G2Affine::rand(rng).into();  
    let uvw_gamma = vec![  
        G1Affine::rand(rng).into(),  
        G1Affine::rand(rng).into(),  
        G1Affine::rand(rng).into(),  
    ];  
    let inputs = vec![  
        Fr::random(rng),  
        Fr::random(rng),  
        Fr::random(rng),  
    ];  
    let proof_a = G1Affine::rand(rng).into();  
    let proof_b = G2Affine::rand(rng).into();  
    let proof_c = G1Affine::rand(rng).into();  
​  
    // Verification  
    let verified = verify_groth16(  
        alpha,  
        beta,  
        gamma,  
        delta,  
        uvw_gamma,  
        inputs,  
        proof_a,  
        proof_b,  
        proof_c,  
    );  
​  
    println!("Verification result: {}", verified);  
}

### 解释

- **依赖和导入**：使用 `pairing-plus` 库提供的 `bls12_381` 模块，这里选择了 BLS12-381 曲线作为椭圆曲线。`rand` 库用于生成随机数。
    
- **验证函数**：`verify_groth16` 函数执行 Groth16 验证步骤。它计算左侧的配对值和右侧的多重配对值，并将它们进行比较来验证证明的有效性。
    
- **示例代码**：在 `main` 函数中，展示了如何设置测试数据，并调用 `verify_groth16` 函数进行验证。
    

请注意，实际的 Groth16 实现可能需要更多的复杂数学运算和安全考虑。此代码提供了一个简单的入门点，帮助你理解如何在 Rust 中开始实现 Groth16 验证功能。