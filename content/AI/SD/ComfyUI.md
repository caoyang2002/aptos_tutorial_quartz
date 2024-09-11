# ComfyUI 安装


有了Stable Diffusion webui 屎山珠玉在前，ComfyUI的安装就简单多了。

  

# Win方式一，官方整合包

ComfyUI官方提供了整合包，直接下载运行即可。  
https://github.com/comfyanonymous/ComfyUI#installing

![图片](https://i0.hdslb.com/bfs/article/a7149bb82b68523c5e346cd02f340e5c309452713.png@1256w_748h_!web-article-pic.avif)

下载的是一个压缩包。  
7z格式，常见解压软件应该均可，没有的话在7-zip.org下载。

解压后的文件：

可以看到最大的文件夹是 **python_embeded**，内置了运行所需的python环境、pytorch等各种包。  

启动运行有两个选择：

- **run_cpu.bat**是cpu模式，如果没有Nvidia显卡可以选用。
    
- **run_nvidia_gpu.bat**是gpu模式，有能跑AI的Nivdia显卡用此模式。
    

双击运行即可启动。

命令行窗口：  

类似webui，ComfyUI也是自动打开一个网页窗口使用，默认地址是：

127.0.0.1:8188

启动画面：

此时代表安装和启动成功。  

当然，整合包里没有带模型，需要把模型装在ComfyUI文件夹下的models/checkpoints文件夹里。

checkpoints里放的就是“大模型”。

另外还有clip、controlnet、lora等文件也都摆好了，按需存放。

  

后续也可以参考我另一篇教程，让 webui 和 ComfyUI 共用一套模型文件：  

[一台电脑装多套Stable Diffusion时共享模型文件的方法](https://www.bilibili.com/read/cv27218597)  

  

装好模型文件后，无需重启，点击右侧的 Refresh ，就可在左侧的 Load Checkpoint 中刷到新放进去的模型文件。

它在中间的 CLIP Text Encode (Prompt) 节点里已经填好了默认的关键词，运行右上角的 Queue Prompt 即可开始生成。

## Win方式二，借助webui运行环境

如果之前装了webui，那ComfyUI运行所需的环境条件其实都具备了，此时可以直接通过git克隆ComfyUI的源代码，借助webui的环境来启动。

  

先git clone ComfyUI的源代码工程。

git的使用方法教程很多，实验编程课程也讲过。

如果命令行git clone不擅长，也可以安装GitHub官方客户端来使用。

不建议直接Download ZIP源代码包，这样不便于后续更新版本。搞不定的话可以选择Windows方式1。  

克隆到本地后，打开ComfyUI文件夹。  

  

**接下来的关键 Trick：**

**使用webui的python环境来启动ComfyUI。**

  

**1. 如果平时用****conda****启动webui**

非常简单，直接用同一套conda环境来运行ComfyUI即可。  

- 用命令行窗口打开ComfyUI文件夹；
    
- 切换到webui的conda环境；
    
- 运行 python main.py 即可启动ComfyUI。
    

命令行与conda基本操作见实验编程AI艺术课程入门篇，网上教程也繁多。  

  

**2. 如果之前安装****webui****时是默认方式**

那就需要指定webui安装文件夹下的venv里的python来运行。

例如我的原版webui的文件结构：

**`H:\prjs\sd\webui\automatic1111\installtest3\stable-diffusion-webui\venv\Scripts\python.exe`**

  

具体操作：

a. 打开命令提示符(cmd)，切换到ComfyUI安装目录；

b. 激活原版webui目录下的venv环境，即运行venv\Script\activate.bat；

我的目录较长，替换你自己的即可。

**`H:\prjs\sd\webui\automatic1111\installtest3\stable-diffusion-webui\venv\Scripts\activate.bat`**

c. 激活环境后，继续在同一个命令行窗口里运行 **python main.py** 即可启动。

官网也有教程：  
https://github.com/comfyanonymous/ComfyUI#i-already-have-another-ui-for-stable-diffusion-installed-do-i-really-have-to-install-all-of-these-dependencies

# **其他手动方式**

如果需手动安装，或是**AMD显卡（仅Linux）**，参考官网手动安装的步骤：

https://github.com/comfyanonymous/ComfyUI#manual-install-windows-linux

**Mac**：  
https://github.com/comfyanonymous/ComfyUI#apple-mac-silicon
