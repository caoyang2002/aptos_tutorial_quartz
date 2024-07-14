---
title: 下载 conda
---
https://www.anaconda.com/download/success


```bash
bash <conda-installer-name>-latest-Linux-x86_64.sh
# 会显示协议
q # 退出

```


```
# 选择安装位置
Anaconda3 will now be installed into this location:
/home/caoyang/anaconda3

  - Press ENTER to confirm the location
  - Press CTRL-C to abort the installation
  - Or specify a different location below

回车 # 确定
```


```bash
# 初始化
conda config --set auto_activate_base false
You can undo this by running `conda init --reverse $SHELL`? [yes|no]

yes
```

然后关闭 `shell` 重新打开

`conda` 是 Anaconda 的命令行界面工具，用于管理 Anaconda 环境中的包和环境。以下是一些常用的 `conda` 命令及其用法：

1. **激活 Conda 初始化**：
   ```bash
   source ~/anaconda3/bin/activate
   conda init
   ```

2. **查看 Conda 版本**：
   ```bash
   conda --version
   ```

3. **创建新的环境**：
   ```bash
   conda create --name 新环境名称
   ```

4. **创建环境并指定 Python 版本**：
   ```bash
   conda create --name 新环境名称 python=3.8
   ```

5. **激活环境**：
   ```bash
   conda activate 新环境名称
   ```

6. **列出所有 Conda 环境**：
   ```bash
   conda env list
   ```

7. **在环境中安装包**：
   ```bash
   conda install package_name
   ```

8. **更新包**：
   ```bash
   conda update package_name
   ```

9. **卸载包**：
   ```bash
   conda remove package_name
   ```

10. **列出环境中安装的包**：
    ```bash
    conda list
    ```

11. **搜索包**：
    ```bash
     conda search package_name
    ```

12. **查看包详细信息**：
    ```bash
     conda info package_name
    ```

13. **导出环境变量**：
    ```bash
     conda env export > environment.yml
    ```

14. **从导出的文件创建环境**：
    ```bash
     conda env create -f environment.yml
    ```

15. **移除环境**：
    ```bash
     conda env remove --name 环境名称
    ```

16. **更新 Conda**：
    ```bash
     conda update -n base -c defaults conda
    ```

17. **查看 Conda 帮助**：
    ```bash
     conda --help
    ```

请根据您的需求替换上述命令中的 `新环境名称` 和 `package_name`。这些命令提供了对 Anaconda 环境和包的基本管理功能。如果需要更多高级功能或选项，可以使用 `conda --help` 查看帮助文档或访问 Anaconda 官方文档。
