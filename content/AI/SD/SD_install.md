---
title: SD 安装方法
---
# stable diffusion极简安装教程

目前，stable diffusion 的运用非常的火热，我也紧跟潮流，加入建筑设计与 AI 结合的行列。经过一段时间的实践，个人认为目前的 AI还只是工具，它可以提供更多的设计图形和更多的设计灵感，供建筑师选择，所以作为工具其便捷性和时效性是非常重要的。

本视频是一个系列教程的开始，后面将逐步记录与更新，建筑设计与AI互动的相关教程。

在安装stable diffusion前，要先将其使用的环境在电脑中配置好。他主要依赖两个软件，第一个是 Git，是用来克隆下载来自 Github 网站的 stable diffusion 源代码，第二个是 python，是运行 stable diffusion 的网页用户界面 Web UI 的运行环境。这两个软件的安装在百度和B站有大量的教程，可以自己浏览学习，这里不再赘述。提醒注意在安装 python 的时候选择与stable diffusion 对应的版本，即 python3.10.6版本。

然后，就是安装stable diffusion，整个过程都需要在命令行中进行，使用windows键加R键进入运行，输入C M D，确定后进入命令行，选择一个剩余空间较大的硬盘，输入盘符，如D，冒号并回车，进入该盘符下，建立新的目录，输入M D加S D ，建立名为S D的目录，然后再输入如下命令，

git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui

点击回车，电脑便开始自动克隆下载源代码到当前的文件夹中，视网络环境下载的过程所需时间可能很长，需要耐心等待。

待源代码下载完成后，要安装stable diffusion的网页用户界面，即Web U I。在当前文件夹下，输入.\webui.bat命令，程序会自动运行，建立stable diffusion web U I的运行环境。在程序下载安装停顿时，在当前根目录下找到venv目录，用记事本打开并编辑该目录下的pyvenv.cfg文件，将include-system-site-packages = false改为include-system-site-packages = true。

配置python库的管理器pip，方便起见，在\venv\Scripts下打开cmd后执行如下命令：

pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/

以上代码用于创建阿里云的镜像

pip freeze > requirements_versions.txt

以上代码用于创建文件

pip install -r requirements_versions.txt

以上代码用于执行pip的安装命令，在执行此条命令前，请检查你的剩余磁盘空间是否充足

pip install xformers

以上代码用于安装xformers程序，xformers还可以在后续使用中降低显卡占用。

然后就是安装过程，期间会出现点击任意键继续，点击并再次输入.\webui.bat，回车继续安装。直到安装界面出现如下字段，证明安装已经成功。

在浏览器中输入网址：http://127.0.0.1:7860，即可进入stable diffusion的网页用户界面。

  

本文为我原创本文禁止转载或摘编

 [教程](https://search.bilibili.com/article?keyword=%E6%95%99%E7%A8%8B&from_source=article) [安装](https://search.bilibili.com/article?keyword=%E5%AE%89%E8%A3%85&from_source=article) [stable diffusion](https://search.bilibili.com/article?keyword=stable%20diffusion&from_source=article)

分享到： 

- 
- [](http://service.weibo.com/share/share.php?appkey=2841902482&language=zh_cn&url=https%3A%2F%2Fwww.bilibili.com%2Fread%2Fcv24970591%2F&title=%23bilibili%E4%B8%93%E6%A0%8F%23%20undefined%20-%20%E5%93%94%E5%93%A9%E5%93%94%E5%93%A9%E4%B8%93%E6%A0%8F&pic=https%3A%2F%2Fstatic.hdslb.com%2Fmobile%2Fimg%2Fapp_logo.png&pics=https%3A%2F%2Fstatic.hdslb.com%2Fmobile%2Fimg%2Fapp_logo.png&site=&summary=&searchPic=true)
- 
- [](http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?style=203&width=98&height=22&otype=share&url=https%3A%2F%2Fwww.bilibili.com%2Fread%2Fcv24970591%2F&title=&pic=https%3A%2F%2Fstatic.hdslb.com%2Fmobile%2Fimg%2Fapp_logo.png&pics=https%3A%2F%2Fstatic.hdslb.com%2Fmobile%2Fimg%2Fapp_logo.png&site=&summary=&searchPic=true)
- [](http://connect.qq.com/widget/shareqq/index.html?url=https%3A%2F%2Fwww.bilibili.com%2Fread%2Fcv24970591%2F&title=&pic=https%3A%2F%2Fstatic.hdslb.com%2Fmobile%2Fimg%2Fapp_logo.png&pics=https%3A%2F%2Fstatic.hdslb.com%2Fmobile%2Fimg%2Fapp_logo.png&site=&summary=&searchPic=true)

投诉或建议

召集队员、团队争霸，谁是团战之王！

- 评论2
- 最热
    
    最新
    

发布

北大BIM老龙

必须是3.10.6，我干脆把原来的卸载了，将python3重新安装了，缺失会报一堆错

2023-07-21 14:15回复

缘起音无

如果必须是Python3.10.6的话我可能明白我为什么报了一大把错了![[捂脸]](https://i0.hdslb.com/bfs/emote/6921bb43f0c634870b92f4a8ad41dada94a5296d.png@48w_48h.webp)

2023-07-18 22:12回复

3

0

3

2