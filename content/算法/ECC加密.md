---
title: ECC加密
---
# 困难问题：椭圆曲线离线对数问题

椭圆曲线上的两个点 P 和 Q，k为整数

$$Q=kP$$
> 在椭圆曲线上有两个点 `P` 和 `Q`，其中 `P` 记作 `P(x,y)`，而 `Q`的值不是简单地将 `k` 和 `P` 进行数学乘积运算

椭圆曲线加密的数学原理：

点 `P` 称为基点（base point）：`k` 为私钥（private key）；Q 为公钥（public key）

> 给定 `k` 和 `P`，依据加法法则，可以轻易地计算出 `Q`
> 
> 但给定 `P` 和 `Q`，求 `k` 非常困难（实际应用 ECC，质数 `p` 取的非常大，穷举出 `k` 非常困难）


[[椭圆曲线]]

$$y^2 = x^3 + ax - 4$$
$$(4a^3 + 27b^2 \neq 0)$$
这条曲线不存在奇点（不可导的点，不光滑）

![[椭圆曲线-1.png]]
椭圆曲线的特点：
- 关于 x 轴对称

加密步骤

数学知识



链接：https://pan.baidu.com/s/1u3KgcI420F4ELs3QsLPurw 
提取码：lhtd
加水印了的PDF版本资料，有需自取，介意勿喷。

# 附录

```python
import numpy as np
import matplotlib.pyplot as plt

# 定义x的范围
x = np.linspace(-2, 2, 400)

# 根据给定方程计算y的值
y = (x**3 - 2*x + 4)**0.5

# 因为y是平方根，需要考虑正负两个方向
y_positive = np.where(y >= 0, y, 0)
y_negative = np.where(y < 0, -y, 0)

# 绘制曲线
plt.figure(figsize=(8, 6))
plt.plot(x, y_positive, label='y = sqrt(x^3 - 2x + 4)')
plt.plot(x, -y_positive, '--', label='y = -sqrt(x^3 - 2x + 4)')

# 添加图例
plt.legend()

# 添加标题和轴标签
plt.title('Curve y^2 = x^3 - 2x + 4')
plt.xlabel('x')
plt.ylabel('y')

# 显示图形
plt.grid(True)
plt.show()
```