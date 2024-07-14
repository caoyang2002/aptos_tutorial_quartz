---
title: " xinference 使用"
---
Xorbits Inference (Xinference) 是一个开源平台，用于简化各种 AI 模型的运行和集成。借助 Xinference，您可以使用任何开源 LLM、嵌入模型和多模态模型在云端或本地环境中运行推理，并创建强大的 AI 应用。

https://inference.readthedocs.io/zh-cn/latest/getting_started

# 安装

```bash
pip install "xinference[all]"  # 安装所有
```



# 启动

```bash
xinference-local --host 0.0.0.0 --port 9997
```


建议使用

qwen2-instruct