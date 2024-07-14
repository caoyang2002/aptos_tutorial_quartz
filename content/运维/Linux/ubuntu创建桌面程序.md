---
title: " Ubuntu 创建桌面程序"
---
# 以 LM studio 为例

下载文件，图标 `.png` 和 `.Appimage`

- `LM_Studio-0.2.27.AppImage`  

- `lmstudio.png`

## 添加执行权限
```bash

 chmod +x LM_Studio-0.2.27.AppImage 
```

## 尝试运行

```absh
./LM_Studio-0.2.27.AppImage 
```

报错：

```
dlopen(): error loading libfuse.so.2
AppImages require FUSE to run. 
You might still be able to extract the contents of this AppImage 
if you run it with the --appimage-extract option. 
See https://github.com/AppImage/AppImageKit/wiki/FUSE 
for more information
```

安装包

```bash
sudo add-apt-repository universe
sudo apt install libfuse2
```

创建 `.desktop` 快捷启动文件

```bash
# 在 ~/desktop （有的可能是中文 ~/桌面 ）创建 AnotherRedisDesktop.desktop

# 编辑文件，编写以下内容
[Desktop Entry]
Name=LM Studio Desktop # 名字
Comment=LLm Meta Desktop #描述
Exec=/home/caoyang/Documents/Application/LM_Studio-0.2.27.AppImage # 程序的绝对路径
Icon=/home/caoyang/Documents/Application/lmstudio.png  # 图标的绝对路径
Terminal=false
Type=Application
Categories=Developer;
```


查看桌面目录

```bash
 echo $XDG_DATA_DIRS
```

```bash
/usr/share/gnome:/usr/local/share:/usr/share:/var/lib/snapd/desktop
# 冒号是分隔符号
```

移动到程序面板（在 home 目录的文件不会被执行，即时有执行权限）

```bash
sudo mv  ./LM_Studio.desktop /var/lib/snapd/desktop/applications/
```