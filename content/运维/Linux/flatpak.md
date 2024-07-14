
|用途|命令|
|---|---|
|搜索包|`flatpak search`|
|安装包|`flatpak install`|
|列出已安装的包|`flatpak list`|
|从 flatpakref 安装|`flatpak install <package-name.flatpakref>`|
|卸载软件包|`flatpak uninstall`|
|卸载未使用的运行时和包|`flatpak uninstall --unused`|


# 开始安装


ubuntu本身是不包含Flatpak框架的

# 安装Flatpak框架

```bash
sudo apt-get install flatpak
# 如果出现依赖问题，我推荐使用 sudo aptitude install flatpak
```

# 添加源

```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```


#  国内镜像源 

```bash
sudo flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub
# 出现错误可以重试
wget https://mirror.sjtu.edu.cn/flathub/flathub.gpg
sudo flatpak remote-modify --gpg-import=flathub.gpg flathub

```

2.安装deepin-wine平台
其实本教程的实现原理就是通过flatpak框架把deepin下的wine平台移植到了其他平台上，借此来运行windows程序
（题外话：笔者已经被wine和crossover的依赖问题折磨得没脾气了）
将笔者提供的framwork.7z文件解压，得到名为com.deepin.wine.Platform.2.18-10.flatpak的安装程序
在解压文件夹下打开终端运行命令，期间会让输入密码，安装wine平台是运行windows程序的前提
```bash
flatpak install com.deepin.wine.Platform.2.18-10.flatpak
```

下载地址：链接: https://pan.baidu.com/s/1guT1k-YPhV3FVEp8PA4p5g 密码: kvpd

3.开始安装软件吧！
安装好两个框架后，我们就可以开始安装windows程序了！
先放出安装包：

TIM：https://www.lanzous.com/i1si94f

微信：https://www.lanzous.com/i1siabi

迅雷：https://www.lanzous.com/i1sic6f

百度云：https://www.lanzous.com/i26eamj

将下载好的压缩包解压，会得到以 `*.flatpak` 为后缀的文件，这就是打包好的安装包
安装命令:
```bash
flatpak install com.tencent.tim.2.0.flatpak  # 这里用TIM作示范
```

1
安装好后，在控制台运行
```bash
flatpak list
```

其中，Ref 下面的就是安装好的软件的RunID，这个ID非常重要
接下来就是如何运行软件了，实际上，软件安装好后就会在菜单生成图标，单击图标就能运行。
但是，偏偏有的时候单击了图标却没有反应，也不知道错误出在哪里，这就尴尬了。。
所以，ID就派上用场了！使用以下命令运行软件并输出日志
```bash
flatpak run ID
# 例如flatpak run com.baidu.pan/i386/5.5  (打开百度云并输出日志)
```

这样，我们就知道问题出在哪里了
一般软件打不开大多是wine框架没装好的问题
尝试以下命令解决：
```bash
flatpak run ID -e 	# 清除wine虚拟环境
flatpak run ID -r 	# 重新解压wine虚拟环境
```


教程到此结束
目前已知的问题：
1.微信有时候会出现黑色方块，经测试重新扫码登陆可解决
2.TIM中文输入有问题，在gnome下使用ibus似乎没问题，其他桌面环境请自行摸索
3.司空见惯的问题：偶尔闪退
4.测试中……
————————————————

                            版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。
                        
原文链接：https://blog.csdn.net/u011469138/article/details/82320761