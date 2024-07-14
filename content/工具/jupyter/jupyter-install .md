---
title: jupyter 的安装
---
# 安装

```bash
pip install notebook
```


# 启动

```bash
jupyter notebook
```


# 插件
```bash
pip install jupyter_contrib_nbextensions # 也可以使用 conda 安装，详见官方文档
jupyter contrib nbextension install --user
```

```bash
!pip install pandas
```



# 使用 conda 安装 Jupyter:

> 如果你已经安装了Anaconda，这通常已经包含了Jupyter

   ```bash
   conda install jupyter
   ```

7. **启动Jupyter Notebook**:
   安装完成后，你可以通过以下命令启动Jupyter Notebook：
   ```bash
   jupyter notebook
   ```
   这将在默认浏览器中打开Jupyter的界面。
   地址通常是： http://localhost:8889

8. **配置Jupyter** (可选):
   你可以配置Jupyter，例如设置密码保护、安装插件等。

9. **更新Anaconda和Jupyter** (可选):
   为了获取最新的功能和安全更新，你可以更新Anaconda和Jupyter：
   ```bash
   conda update anaconda
   conda update jupyter
   ```

10. **使用JupyterLab** (可选):
    如果你更喜欢使用JupyterLab，可以使用以下命令安装它：
    ```bash
    conda install jupyterlab
    ```
    然后通过运行`jupyter lab`命令来启动JupyterLab。

请注意，Anaconda安装过程中会询问你是否要执行`conda init`，这将修改你的shell配置文件（如`.bashrc`或`.zshrc`），以便在启动终端时自动初始化Conda环境。如果你选择跳过这一步，你可以稍后手动执行此操作。



# 附录
- 准备密码密文
    
    由于我们将以需要密码验证的模式启动 Jupyter，所以我们要预先生成所需的密码对应的密文。
    
    #### 生成密文
    
    使用下面的命令，创建一个密文的密码：
    
```bash
python -c "import IPython;print(IPython.lib.passwd())"
```
    
    执行后需要输入并确认密码，然后程序会返回一个 `'sha1:...'` 的密文，我们接下来将会用到它。