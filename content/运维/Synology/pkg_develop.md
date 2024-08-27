---
title: 群晖套件开发
aliases:
  - 群晖套件开发
link: https://help.synology.cn/developer-guide/
tags:
  - synology
---
# 一、官方工具开发
## 环境

**开发设备:** 

```bash
$ hostnamectl
 Static hostname: simons-yannis
       Icon name: computer-desktop
         Chassis: desktop 🖥️
      Machine ID: d2ca6f513c924e379fdeafea1ba5f99e
         Boot ID: 98db35ffa2bc4c4b9fbe573d930494f9
Operating System: Ubuntu 24.04 LTS                
          Kernel: Linux 6.8.0-39-generic
    Architecture: x86-64
 Hardware Vendor: ASUS
  Hardware Model: ROG STRIX B660-A GAMING WIFI D4
Firmware Version: 1620
   Firmware Date: Fri 2022-08-12
    Firmware Age: 2y 2w          
```



**部署环境：**

| 型号      | CPU 型号         | 核心数 （单一 CPU） | 线程数 （单一 CPU） | FPU  | 套件架构 | RAM                 |
| :-------- | :--------------- | :------------------ | :------------------ | :--- | :------- | :------------------ |
| DS923+    | AMD Ryzen R1600  | 2                   | 4                   | ✓    | R1000    | DDR4 ECC SODIMM 4GB |

**文件：**

Package script: https://github.com/SynologyOpenSource/pkgscripts-ng

Example Package:  https://github.com/SynologyOpenSource/ExamplePackages

Archive: https://archive.synology.com/download/



## 案例

> 在 DS923+ 设备上安装一个自己编译的 ExamplePackage 程序

### 创建目录

```bash
# 创建并进入目录
mkdir -p toolkit
cd toolkit
```

### 下载 toolkit framework

```bash
# 克隆工具包
git clone https://github.com/SynologyOpenSource/pkgscripts-ng.git
```

### 安装依赖项

```bash
# 安装
apt-get install cifs-utils \
    python \
    python-pip \
    python3 \
    python3-pip
```

### 目录结构

```bash
$ tree -h -L 1 
[4.0K]  .
├── [2.8K]  EnvDeploy
├── [5.4K]  ParallelProjects.py
├── [7.7K]  PkgCreate.py
├── [ 13K]  ProjectDepends.py
├── [1.6K]  README.md
├── [4.5K]  SynoBuild
├── [ 245]  SynoCC
├── [2.2K]  SynoCustomize
├── [2.9K]  SynoInstall
├── [4.0K]  include
├── [ 301]  strings.js
└── [4.0K]  tool
```



### 下载群晖编译环境

#### 下载指定环境（建议）

```bash
# 下载指定环境
sudo ./EnvDeploy -v 7.2 -p r1000
# 避免 tar: dev/sdbz14: Cannot mknod: Operation not permitted
```

#### 下载所有环境（可选）

```bash
# 下载所有环境
sudo ./EnvDeploy -v 7.2 
# 列出可用平台
caoyang@simons-yannis:~/synology/toolkit/pkgscripts-ng$ ./EnvDeploy -v 7.2 --list
[2024-08-25 23:49:07,824] INFO: Available platforms: avoton braswell bromolow grantley alpine alpine4k monaco armada38x kvmcloud kvmx64 rtd1296 broadwellnk denverton apollolake armada37xx purley v1000 broadwell geminilake broadwellntbap r1000 broadwellnkv2 rtd1619b epyc7002
```



### 文件结构

```bash
# 查看文件夹结构
caoyang@simons-yannis:~/synology/toolkit$ tree -h -L 1 
[4.0K]  .
├── [4.0K]  build_env
├── [ 946]  envdeploy.log
├── [ 466]  envdeploy.log.old
├── [4.0K]  pkgscripts-ng
└── [4.0K]  toolkit_tarballs
```



### 下载程序文件

```bash
mkdir source
git clone https://github.com/SynologyOpenSource/ExamplePackages.git
mv ExamplePackages/ExamplePackage/ ./

# or
git clone https://github.com/SynologyOpenSource/ExamplePackages.git --depth 1
mv ExamplePackages/ExamplePackage/ ./
```



### 打包

```bash
sudo ./PkgCreate.py -v 7.2 -p r1000 -c ../source/ExamplePackage

# /home/caoyang/synology/toolkit/result_spk/ExamplePackage-1.0.0-0001/ExamplePackage-x86_64-1.0.0-0001.spk
```

### 安装到群晖

`套件中心` > `手动安装`


---
# 二、spksrc 开发

spksrc: https://github.com/SynoCommunity/spksrc

https://synocommunity.com/

## 准备环境

### docker

```bash
cd spksrc # Go to the cloned repository's root folder.

# If running on Linux:
docker run -it --platform=linux/amd64 -v $(pwd):/spksrc -w /spksrc ghcr.io/synocommunity/spksrc /bin/bash

# If running on macOS:
docker run -it --platform=linux/amd64 -v $(pwd):/spksrc -w /spksrc -e TAR_CMD="fakeroot tar" ghcr.io/synocommunity/spksrc /bin/bash
```

### 主机

```bash
git clone https://github.com/SynoCommunity/spksrc.git
# 可能需要安装的依赖
sudo apt-get update
sudo apt-get install ninja-build
sudo apt-get install imagemagick
sudo apt-get install moreutils
```

### 虚拟机

```bash
sudo dpkg --add-architecture i386 && sudo apt-get update
sudo apt update
sudo apt install autoconf-archive autogen automake autopoint bash bc bison build-essential check cmake curl cython3 debootstrap ed expect fakeroot flex g++-multilib gawk gettext git gperf imagemagick intltool jq libbz2-dev libc6-i386 libcppunit-dev libffi-dev libgc-dev libgmp3-dev libltdl-dev libmount-dev libncurses-dev libpcre3-dev libssl-dev libtool libunistring-dev lzip mercurial moreutils ninja-build patchelf php pkg-config python2 python3 python3-distutils rename ruby-mustache rsync scons subversion swig texinfo unzip xmlto zip zlib1g-dev
wget https://bootstrap.pypa.io/pip/2.7/get-pip.py -O - | sudo python2
sudo pip2 install wheel httpie
wget https://bootstrap.pypa.io/get-pip.py -O - | sudo python3
sudo pip3 install meson==1.0.0
```

## 打包 transmission 

ds 923+

dsm 7.2

```bash
git clone https://github.com/SynoCommunity/spksrc.git
cd spksrc/
make setup
cd spk/transmission
make arch-r1000-7.2

# or 
git clone https://github.com/SynoCommunity/spksrc.git
make -C spksrc spk-transmission-r1000-7.2
```

















---
---
---




# 三、官方文档
## 准备环境

## 安装工具包

### 工具包安装：

[您需要从此链接](https://github.com/SynologyOpenSource/pkgscripts-ng/tree/DSM7.2)克隆前端脚本。`/toolkit`从现在起，我们将在本文档中使用它作为工具包基础。

```bash
apt-get install git
mkdir -p /toolkit
cd /toolkit
git clone https://github.com/SynologyOpenSource/pkgscripts-ng
```

然后需要安装一些工具来使构建的工具正常工作：

```bash
apt-get install cifs-utils \
    python \
    python-pip \
    python3 \
    python3-pip
```

此时您可以找到以下工具包文件：

```
/toolkit
├── pkgscripts-ng/
│   ├── include/
│   ├── EnvDeploy    (deployment tool for chroot environment)
│   └── PkgCreate.py (build tool for package)
└── build_env/       (directory to store chroot environments)
```

## 为不同的 NAS 目标部署 Chroot 环境

为了更快地开发，我们准备了几个不同架构的构建环境，其中包含一些预构建的项目，其可执行二进制文件或共享库是在 DSM 中构建的，例如，`zlib`等等`libxml2`。

您可以使用`EnvDeploy`来部署您的 NAS 的[相应环境](https://www.synology.com/knowledgebase/DSM/tutorial/Compatibility_Peripherals/What_kind_of_CPU_does_my_NAS_have)。例如，如果架构中有 NAS `avoton`，则可以使用以下命令来部署环境`avoton`：

```bash
cd /toolkit/pkgscripts-ng/
git checkout DSM7.2
./EnvDeploy -v 7.2 -p avoton # for DSM7.2.2
```

可以手动下载环境 tarball。您必须将`base_env-{version}.txz`、`ds.{platform}-{version}.dev.txz`和`ds.{platform}-{version}.env.txz`放入`toolkit/toolkit_tarballs`。

```
/toolkit
├── pkgscripts-ng/
└── toolkit_tarballs/
    ├── base_env-7.2.txz
    ├── ds.avoton-7.2.dev.txz
    └── ds.avoton-7.2.env.txz
cd /toolkit/pkgscripts-ng/
./EnvDeploy -v 7.2 -p avoton -D # -D implies no download
```

如前所述，部署的环境包含一些预构建的库和头文件，可以在**cross gcc sysroot**下找到。Sysroot 是编译器的默认搜索路径。如果 gcc 在给定的路径中找不到头文件或库，它将搜索`sysroot/usr/{lib,include}`。

```
/toolkit
├── pkgscripts-ng/
│   ├── include/
│   ├── EnvDeploy
│   └── PkgCreate.py
└── build_env/
    ├── ds.avoton-7.2/
    └── ds.avoton-6.2/
        └── usr/local/x86_64-pc-linux-gnu/x86_64-pc-linux-gnu/sys-root/
```

### 可用平台

您可以使用以下命令之一来显示可用平台。如果`-v`没有给出，则将列出所有版本的可用平台。

```
./EnvDeploy -v 7.2 --list
./EnvDeploy -v 7.2 --info platform
```

您可以使用属于同一平台系列的任何工具包为同一平台系列内的所有平台创建 spk。例如，您可以使用 braswell 工具包创建在所有 x86_64 兼容平台上运行的包。对于平台系列，请查看[平台和 Arch 值映射表](https://help.synology.cn/developer-guide/appendix)。

### 更新环境

再次使用`EnvDeploy`以更新环境。例如，您可以按如下方式更新 DSM 7.2.2 的 avoton。

```
./EnvDeploy -v 7.2 -p avoton
```

### 删除环境

要删除环境，首先需要卸载`/proc`文件夹，然后删除环境文件夹。以下命令说明如何删除版本 7.2 和平台 avoton 的环境。

```
umount /toolkit/build_env/ds.avoton-7.2/proc
rm -rf /toolkit/build_env/ds.avoton-7.2
```





---

## 您的第一个包

> 确保您已为 NAS[准备好开发环境。](https://help.synology.cn/developer-guide/getting_started/prepare_environment.html)

### 下载模板包

[您可以从https://github.com/SynologyOpenSource/ExamplePackages](https://github.com/SynologyOpenSource/ExamplePackages)下载我们的模板包并将`ExamplePackages/ExamplePackage`目录放在`/toolkit/source/ExamplePackage`。

```
/toolkit/
├── build_env/
│   └── ds.${platform}-${version}/
├── pkgscripts-ng/
│   ├── EnvDeploy
│   └── PkgCreate.py
└── source/
    └──ExamplePackage/
        ├── examplePkg.c
        ├── INFO.sh
        ├── Makefile
        ├── PACKAGE_ICON.PNG
        ├── PACKAGE_ICON_256.PNG
        ├── scripts/
        │   ├── postinst
        │   ├── postuninst
        │   ├── postupgrade
        │   ├── postreplace
        │   ├── preinst
        │   ├── preuninst
        │   ├── preupgrade
        │   ├── prereplace
        │   └── start-stop-status
        └── SynoBuildConf/
            ├── depends
            ├── build
            └── install
```

### 配置构建配置

在 `${project_path}/SynoBuildConf/` 下配置了 build package 和 pack package 的步骤，可以看到三个文件：

- **depends**：配置项目之间的依赖关系
- **build**：配置构建包的步骤
- **install**：配置将包打包成`.spk`文件的步骤

本示例将使用 C 语言编写的程序来回显一些消息，因此在构建阶段需要编译程序。我们应用`Makefile`此示例来帮助我们进行交叉编译。

我们不关心你在`build`配置中做了什么，甚至可以什么都不做。构建系统只会 chroot 到环境中，然后根据命令调用相应的`build`脚本`install`。

### 配置属性

包信息及其行为由 `INFO.sh` 控制，将被转换为`INFO`中的文件`install`。

```bash
#!/bin/bash
# INFO.sh
source /pkgscripts/include/pkg_util.sh 
package="ExamplePackage"
version="1.0.0000"
os_min_ver="7.0-40000"
displayname="ExamplePackage Package"
description="this is an example package"
arch="$(pkg_get_unified_platform)"
maintainer="Synology Inc."
pkg_dump_info
```

### 配置生命周期行为

包控制脚本可在 找到`${project_path}/scripts/`。您可以控制每个阶段的行为，例如`examplePkg`在包启动/停止时调用程序。

```bash
#!/bin/sh
# scripts/start-stop-status
case $1 in
    start)
        examplePkg "Start"
        echo "Hello World" > $SYNOPKG_TEMP_LOGFILE
        exit 0
    ;;
    stop)
        examplePkg "Stop"
        echo "Hello World" > $SYNOPKG_TEMP_LOGFILE
        exit 0
    ;;
    status)
        exit 0
    ;;
esac
```

### 编写程序并配置其编译和安装

通常将编译好的程序通过软件包带入 DSM。您只需用 C 编写程序并添加 Makefile 即可编译程序。



`examplePkg.c`

```c
// examplePkg.c
#include <sys/sysinfo.h>
#include <syslog.h>
#include <stdio.h>
int main(int argc, char** argv) {
    struct sysinfo info;
    int ret;
    ret = sysinfo(&info);
    if (ret != 0) {
        syslog(LOG_SYSLOG, "Failed to get info\n");
        return -1;
    }
    syslog(LOG_SYSLOG, "[ExamplePkg] %s sample package ...", argv[1]);
    syslog(LOG_SYSLOG, "[ExamplePkg] Total RAM: %u\n", (unsigned int) info.totalram);
    syslog(LOG_SYSLOG, "[ExamplePkg] Free RAM: %u\n", (unsigned int) info.freeram);
    return 0;
}
```





`Makefile`

```makefile
# Makefile
include /env.mak
EXEC= examplePkg
OBJS= examplePkg.o
all: $(EXEC)
$(EXEC): $(OBJS)
    $(CC) $(CFLAGS) $< -o $@ $(LDFLAGS)
install: $(EXEC)
    mkdir -p $(DESTDIR)/usr/bin/
    install $< $(DESTDIR)/usr/bin/
clean:
    rm -rf *.o $(EXEC)
```



任何附加文件（例如，编译后的程序、媒体资源）都应打包到`package.tgz`文件中`.spk`。我们提供了几个脚本命令来执行此类操作。在此示例中，我们将`examplePkg`通过`install`构建脚本打包编译后的可执行文件。

```bash
#  SynoBuildConf/install (partial)
create_package_tgz() {
    local firewere_version=
    local package_tgz_dir=/tmp/_package_tgz
    local binary_dir=$package_tgz_dir/usr/bin
    rm -rf $package_tgz_dir && mkdir -p $package_tgz_dir
    mkdir -p $binary_dir
    cp -av examplePkg $binary_dir
    make install DESTDIR="$package_tgz_dir"
    pkg_make_package $package_tgz_dir "${PKG_DIR}"
}
```

### 构建并打包

准备好包源代码后，您可以使用以下命令构建包并将其打包到`.spk`中`/toolkit/result_spk/${package}-${version}/*.spk`。

```bash
cd /toolkit/pkgscripts-ng/
cd./PkgCreate.py -v 7.0 -p avoton -c ExamplePackage
```

```bash
/toolkit/
├── pkgscripts-ng/
├── build_env/
│   └── ds.${platform}-${version}
└── result_spk/
    └── ${package}-${version}/
        └── *.spk # 打开
```

### 安装并测试软件包

转到**DSM > 套件中心 > 手动安装，**然后选择您的`.spk`文件进行安装。

![img](https://help.synology.cn/developer-guide/getting_started/examplePkg.png)

一旦您安装并启动了该包，您就可以在 UI 和日志上看到它的消息`/var/log/messages`。

## 构建成功



### 输出



```bash
caoyang@simons-yannis:~/synology/toolkit/pkgscripts-ng$ sudo ./PkgCreate.py -v 7.2 -p r1000 -c ../source/ExamplePackage
============================================================
                   Parse argument result                    
------------------------------------------------------------
platforms     : r1000
env_section   : default
env_version   : 7.2
dep_level     : 1
parallel_proj : 1
branch        : master
suffix        : 
collect       : True
collecter     : True
link          : True
update_link   : False
build         : True
install       : True
only_install  : False
parallel      : 20
build_opt     : 
install_opt   : 
print_log     : False
tee           : True
sdk_ver       : 6.2
package       : ../source/ExamplePackage

Processing [7.2-72726]: r1000
============================================================
              Start to run "Traverse project"               
------------------------------------------------------------
Projects: ../source/ExamplePackage

============================================================
                Start to run "Link Project"                 
------------------------------------------------------------
Link /home/caoyang/synology/toolkit/pkgscripts-ng -> /home/caoyang/synology/toolkit/build_env/ds.r1000-7.2/pkgscripts-ng
Link /home/caoyang/synology/toolkit/source/../source/ExamplePackage -> /home/caoyang/synology/toolkit/build_env/ds.r1000-7.2/source/../source/ExamplePackage


============================================================
                Start to run "Build Package"                
------------------------------------------------------------
[r1000] env PackageName=../source/ExamplePackage /pkgscripts-ng/SynoBuild --r1000 -c --min-sdk 6.2 ../source/ExamplePackage
Set cache size limit to 8.0 GB
Statistics zeroed
[INFO] projectList=ExamplePackage
[INFO] Start to build ExamplePackage.
[SCRIPT] build script: //source/ExamplePackage/SynoBuildConf/build
[INFO] ======= Run build script =======
rm -rf *.o examplePkg
/usr/local/x86_64-pc-linux-gnu/bin/x86_64-pc-linux-gnu-wrap-gcc -DSYNOPLAT_F_X86_64 -O2 -DBUILD_ARCH=64 -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -g -DSDK_VER_MIN_REQUIRED=602 -DSYNO_R1000 -DSYNO_PLATFORM=R1000 examplePkg.c -o examplePkg.dummy
make  -j 20
/usr/local/x86_64-pc-linux-gnu/bin/x86_64-pc-linux-gnu-wrap-gcc -DSYNOPLAT_F_X86_64 -O2 -DBUILD_ARCH=64 -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -g -DSDK_VER_MIN_REQUIRED=602 -DSYNO_R1000 -DSYNO_PLATFORM=R1000    examplePkg.c   -o examplePkg
===> WIZARD_UIFILES
GenerateModuleFiles.php WIZARD_UIFILES WIZARD_UIFILES
===> ui
GenerateModuleFiles.php ui ui
Skip parsing: config.define not exist
make -C WIZARD_UIFILES INSTALLDIR=/WIZARD_UIFILES DESTDIR= PREFIX= ;
make -C ui INSTALLDIR=/ui DESTDIR= PREFIX= ;
make[1]: Entering directory '/source/ExamplePackage/ui'
make[1]: Entering directory '/source/ExamplePackage/WIZARD_UIFILES'
/usr/local/tool/snpm i
/usr/bin/find: `dist': No such file or directory
/usr/local/tool/snpm i
Lockfile is up to date, resolution step is skipped
Progress: resolved 1, reused 0, downloaded 0, added 0
Packages: +328
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Packages are hard linked from the content-addressable store to the virtual store.
  Content-addressable store is at: /root/.local/share/pnpm/store/v3
  Virtual store is at:             node_modules/.pnpm
devDependencies:
+ @babel/core 7.18.6
+ @babel/eslint-parser 7.19.1
+ babel-loader 8.0.6
+ eslint 8.23.1
+ eslint-plugin-vue 9.1.1
+ eslint-webpack-plugin 3.2.0
+ terser-webpack-plugin 5.3.10
+ vue 2.7.14
+ vue-eslint-parser 7.0.0
+ vue-loader 15.10.1
+ vue-template-compiler 2.7.14
+ webpack 5.91.0
+ webpack-cli 5.1.4
Done in 661ms
Progress: resolved 328, reused 327, downloaded 0, added 328, done
/usr/local/tool/snpm build
Progress: resolved 0, reused 1, downloaded 0, added 0
Progress: resolved 449, reused 449, downloaded 0, added 0
Packages: +454
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Packages are hard linked from the content-addressable store to the virtual store.
  Content-addressable store is at: /root/.local/share/pnpm/store/v3
  Virtual store is at:             node_modules/.pnpm
devDependencies:
+ @babel/core 7.18.6
+ @babel/preset-env 7.18.6
+ babel-loader 8.0.6
+ css-loader 3.5.3
+ eslint 8.23.1
+ eslint-plugin-vue 9.1.1
+ eslint-webpack-plugin 3.2.0
+ mini-css-extract-plugin 0.12.0
+ terser-webpack-plugin 5.3.10
+ vue 2.7.14
+ vue-eslint-parser 7.0.0
+ vue-loader 15.10.1
+ vue-template-compiler 2.7.14
+ webpack 5.91.0
+ webpack-cli 5.1.4
Done in 2.1s
Progress: resolved 453, reused 453, downloaded 0, added 454, done
/usr/local/tool/snpm build
> WIZARD_UIFILES@1.0.0 build /source/ExamplePackage/WIZARD_UIFILES
> webpack --mode production
asset install_entry.bundle.js 4.92 KiB [emitted] [minimized] (name: install_entry)
asset remove_entry.bundle.js 3.65 KiB [emitted] [minimized] (name: remove_entry)
asset remove_notice_entry.bundle.js 2.46 KiB [emitted] [minimized] (name: remove_notice_entry)
orphan modules 22.2 KiB [orphan] 18 modules
runtime modules 1.96 KiB 9 modules
built modules 28 KiB [built]
  ./src/remove-entry.js + 7 modules 9 KiB [not cacheable] [built] [code generated]
  ./src/remove-notice-entry.js + 7 modules 7.34 KiB [not cacheable] [built] [code generated]
  ./src/install-entry.js + 8 modules 11.6 KiB [not cacheable] [built] [code generated]
webpack 5.91.0 compiled successfully in 1087 ms
make[1]: Leaving directory '/source/ExamplePackage/WIZARD_UIFILES'
<=== WIZARD_UIFILES
> ExamplePackage@1.0.0 build /source/ExamplePackage/ui
> webpack --mode production
asset example-package.bundle.js 1.44 KiB [emitted] [minimized] (name: main)
asset ./style/example-package.bundle.css 196 bytes [emitted] (name: main)
Entrypoint main 1.63 KiB = ./style/example-package.bundle.css 196 bytes example-package.bundle.js 1.44 KiB
orphan modules 5.63 KiB [orphan] 8 modules
runtime modules 663 bytes 3 modules
code generated modules 5.83 KiB (javascript) 195 bytes (css/mini-extract) [code generated]
  ./src/main.js + 7 modules 5.83 KiB [not cacheable] [built] [code generated]
  css ./node_modules/.pnpm/css-loader@3.5.3_webpack@5.91.0/node_modules/css-loader/dist/cjs.js!./src/styles/index.css 195 bytes [code generated]
webpack 5.91.0 compiled successfully in 628 ms
make -f Makefile.js.inc JSCompress JS_NAMESPACE=\""SYNO.SDS.App.ExamplePackage"\" JS_DIR="dist"
make[2]: Entering directory '/source/ExamplePackage/ui'
if [ -f scss/style.scss ]; then /usr/bin/compass  compile scss; fi
/usr/local/tool/parse_requires.py --makegoal=JSCompress dist "SYNO.SDS.App.ExamplePackage"
SYNO.SDS.App.ExamplePackage
Auto config js files:
['dist/example-package.bundle.js']
/usr/syno/bin/GenerateJSDepend.php /source/ExamplePackage/ui
/usr/local/tool/shrinksafe.php  -s -c skip -d ExamplePackage.js "/source/ExamplePackage/ui/config.depends"
/source/ExamplePackage/ui/config.depends
Skip JavaScript Validation
make[2]: Leaving directory '/source/ExamplePackage/ui'
cp "dist/style/example-package.bundle.css" style.css
make[1]: Leaving directory '/source/ExamplePackage/ui'
<=== ui
[INFO] No install-dev script.
Time cost: 00:00:04 [Build-->ExamplePackage]
[INFO] Build ExamplePackage finished!
----------------- Time cost statistics -----------------
Time cost: 00:00:04 [Build-->ExamplePackage]
1 projects, 0 failed, 0 blocked.

============================================================
        Start to run "Install Package[--with-debug]"        
------------------------------------------------------------
[r1000] env PackageName=../source/ExamplePackage /pkgscripts-ng/SynoInstall  --with-debug ../source/ExamplePackage
[INFO] projectList=ExamplePackage
[INFO] Start to install ExamplePackage.
[ENV] Using 64bit environment.
[INFO] Execute install script: //source/ExamplePackage/SynoBuildConf/install
'examplePkg' -> '/tmp/_package_tgz/usr/local/bin/examplePkg'
===> ui
GenerateModuleFiles.php ui ui
make -C ui INSTALLDIR=/tmp/_package_tgz/ui DESTDIR=/tmp/_package_tgz PREFIX= install;
make[1]: Entering directory '/source/ExamplePackage/ui'
# already install style.css install_JSCompress
[ -d  /tmp/_package_tgz/ui ] || install -d /tmp/_package_tgz/ui
if [ -f config ]; then cp config /tmp/_package_tgz/ui; fi
if [ -n "ExamplePackage.js" ]; then cp ExamplePackage.js /tmp/_package_tgz/ui; fi
if [ -f style.css ]; then cp -f style.css /tmp/_package_tgz/ui; fi
[ -d /tmp/_package_tgz/ui/texts ] || install -d /tmp/_package_tgz/ui/texts
cp -a texts /tmp/_package_tgz/ui
[ -d /tmp/_package_tgz/ui/images ] || install -d /tmp/_package_tgz/ui/images
cp -a images /tmp/_package_tgz/ui
make[1]: Leaving directory '/source/ExamplePackage/ui'
<=== ui
===> WIZARD_UIFILES
GenerateModuleFiles.php WIZARD_UIFILES WIZARD_UIFILES
Skip parsing: config.define not exist
make -C WIZARD_UIFILES INSTALLDIR=/tmp/_package_tgz/WIZARD_UIFILES DESTDIR=/tmp/_package_tgz PREFIX= install;
make[1]: Entering directory '/source/ExamplePackage/WIZARD_UIFILES'
/usr/local/tool/snpm i
Lockfile is up to date, resolution step is skipped
Already up to date
Done in 382ms
/usr/local/tool/snpm build
> WIZARD_UIFILES@1.0.0 build /source/ExamplePackage/WIZARD_UIFILES
> webpack --mode production
asset install_entry.bundle.js 4.92 KiB [compared for emit] [minimized] (name: install_entry)
asset remove_entry.bundle.js 3.65 KiB [compared for emit] [minimized] (name: remove_entry)
asset remove_notice_entry.bundle.js 2.46 KiB [compared for emit] [minimized] (name: remove_notice_entry)
orphan modules 22.2 KiB [orphan] 18 modules
runtime modules 1.96 KiB 9 modules
built modules 28 KiB [built]
  ./src/remove-entry.js + 7 modules 9 KiB [not cacheable] [built] [code generated]
  ./src/remove-notice-entry.js + 7 modules 7.34 KiB [not cacheable] [built] [code generated]
  ./src/install-entry.js + 8 modules 11.6 KiB [not cacheable] [built] [code generated]
webpack 5.91.0 compiled successfully in 1037 ms
make[1]: Leaving directory '/source/ExamplePackage/WIZARD_UIFILES'
<=== WIZARD_UIFILES
mkdir -p /tmp/_package_tgz/usr/local/bin/
install examplePkg /tmp/_package_tgz/usr/local/bin/
===> ui
GenerateModuleFiles.php ui ui
make -C ui INSTALLDIR=/ui DESTDIR=/tmp/_package_tgz PREFIX= packageinstall;
make[1]: Entering directory '/source/ExamplePackage/ui'
make[1]: Nothing to be done for 'packageinstall'.
make[1]: Leaving directory '/source/ExamplePackage/ui'
<=== ui
===> WIZARD_UIFILES
GenerateModuleFiles.php WIZARD_UIFILES WIZARD_UIFILES
Skip parsing: config.define not exist
make -C WIZARD_UIFILES INSTALLDIR=/WIZARD_UIFILES DESTDIR=/tmp/_package_tgz PREFIX= packageinstall;
make[1]: Entering directory '/source/ExamplePackage/WIZARD_UIFILES'
./create_uninstall_uifile.sh
./create_install_uifile.sh
[ -d /tmp/_test_spk/WIZARD_UIFILES ] || install -d /tmp/_test_spk/WIZARD_UIFILES
for i in uninstall_uifile install_uifile; do \
	install -c -m 644 $i /tmp/_test_spk/WIZARD_UIFILES; \
done
make[1]: Leaving directory '/source/ExamplePackage/WIZARD_UIFILES'
<=== WIZARD_UIFILES
ls /tmp/_package_tgz | tar cJf /tmp/_test_spk/package.tgz -C /tmp/_package_tgz -T /dev/stdin
'scripts' -> '/tmp/_test_spk/scripts'
'scripts/postinst' -> '/tmp/_test_spk/scripts/postinst'
'scripts/postuninst' -> '/tmp/_test_spk/scripts/postuninst'
'scripts/postupgrade' -> '/tmp/_test_spk/scripts/postupgrade'
'scripts/preinst' -> '/tmp/_test_spk/scripts/preinst'
'scripts/preuninst' -> '/tmp/_test_spk/scripts/preuninst'
'scripts/preupgrade' -> '/tmp/_test_spk/scripts/preupgrade'
'scripts/start-stop-status' -> '/tmp/_test_spk/scripts/start-stop-status'
'PACKAGE_ICON.PNG' -> '/tmp/_test_spk/PACKAGE_ICON.PNG'
'PACKAGE_ICON_256.PNG' -> '/tmp/_test_spk/PACKAGE_ICON_256.PNG'
'conf' -> '/tmp/_test_spk/conf'
'conf/privilege' -> '/tmp/_test_spk/conf/privilege'
'conf/resource' -> '/tmp/_test_spk/conf/resource'
'LICENSE' -> '/tmp/_test_spk/LICENSE'
creating package: ExamplePackage-x86_64-1.0.0-0001_debug.spk
source:           /tmp/_test_spk
destination:      /image/packages/ExamplePackage-x86_64-1.0.0-0001_debug.spk
[WARNING] /tmp/_install is empty!
[INFO] Install ExamplePackage finished!
1 projects, 0 failed, 0 blocked.
[INFO] Finished SynoInstall script.

============================================================
               Start to run "Install Package"               
------------------------------------------------------------
[r1000] env PackageName=../source/ExamplePackage /pkgscripts-ng/SynoInstall  ../source/ExamplePackage
[INFO] projectList=ExamplePackage
[INFO] Start to install ExamplePackage.
[ENV] Using 64bit environment.
[INFO] Execute install script: //source/ExamplePackage/SynoBuildConf/install
'examplePkg' -> '/tmp/_package_tgz/usr/local/bin/examplePkg'
===> ui
GenerateModuleFiles.php ui ui
make -C ui INSTALLDIR=/tmp/_package_tgz/ui DESTDIR=/tmp/_package_tgz PREFIX= install;
make[1]: Entering directory '/source/ExamplePackage/ui'
# already install style.css install_JSCompress
[ -d  /tmp/_package_tgz/ui ] || install -d /tmp/_package_tgz/ui
if [ -f config ]; then cp config /tmp/_package_tgz/ui; fi
if [ -n "ExamplePackage.js" ]; then cp ExamplePackage.js /tmp/_package_tgz/ui; fi
if [ -f style.css ]; then cp -f style.css /tmp/_package_tgz/ui; fi
[ -d /tmp/_package_tgz/ui/texts ] || install -d /tmp/_package_tgz/ui/texts
cp -a texts /tmp/_package_tgz/ui
[ -d /tmp/_package_tgz/ui/images ] || install -d /tmp/_package_tgz/ui/images
cp -a images /tmp/_package_tgz/ui
make[1]: Leaving directory '/source/ExamplePackage/ui'
<=== ui
===> WIZARD_UIFILES
GenerateModuleFiles.php WIZARD_UIFILES WIZARD_UIFILES
Skip parsing: config.define not exist
make -C WIZARD_UIFILES INSTALLDIR=/tmp/_package_tgz/WIZARD_UIFILES DESTDIR=/tmp/_package_tgz PREFIX= install;
make[1]: Entering directory '/source/ExamplePackage/WIZARD_UIFILES'
/usr/local/tool/snpm i
Lockfile is up to date, resolution step is skipped
Already up to date
Done in 389ms
/usr/local/tool/snpm build
> WIZARD_UIFILES@1.0.0 build /source/ExamplePackage/WIZARD_UIFILES
> webpack --mode production
asset install_entry.bundle.js 4.92 KiB [compared for emit] [minimized] (name: install_entry)
asset remove_entry.bundle.js 3.65 KiB [compared for emit] [minimized] (name: remove_entry)
asset remove_notice_entry.bundle.js 2.46 KiB [compared for emit] [minimized] (name: remove_notice_entry)
orphan modules 22.2 KiB [orphan] 18 modules
runtime modules 1.96 KiB 9 modules
built modules 28 KiB [built]
  ./src/remove-entry.js + 7 modules 9 KiB [not cacheable] [built] [code generated]
  ./src/remove-notice-entry.js + 7 modules 7.34 KiB [not cacheable] [built] [code generated]
  ./src/install-entry.js + 8 modules 11.6 KiB [not cacheable] [built] [code generated]
webpack 5.91.0 compiled successfully in 1034 ms
make[1]: Leaving directory '/source/ExamplePackage/WIZARD_UIFILES'
<=== WIZARD_UIFILES
mkdir -p /tmp/_package_tgz/usr/local/bin/
install examplePkg /tmp/_package_tgz/usr/local/bin/
===> ui
GenerateModuleFiles.php ui ui
make -C ui INSTALLDIR=/ui DESTDIR=/tmp/_package_tgz PREFIX= packageinstall;
make[1]: Entering directory '/source/ExamplePackage/ui'
make[1]: Nothing to be done for 'packageinstall'.
make[1]: Leaving directory '/source/ExamplePackage/ui'
<=== ui
===> WIZARD_UIFILES
GenerateModuleFiles.php WIZARD_UIFILES WIZARD_UIFILES
Skip parsing: config.define not exist
make -C WIZARD_UIFILES INSTALLDIR=/WIZARD_UIFILES DESTDIR=/tmp/_package_tgz PREFIX= packageinstall;
make[1]: Entering directory '/source/ExamplePackage/WIZARD_UIFILES'
[ -d /tmp/_test_spk/WIZARD_UIFILES ] || install -d /tmp/_test_spk/WIZARD_UIFILES
for i in uninstall_uifile install_uifile; do \
	install -c -m 644 $i /tmp/_test_spk/WIZARD_UIFILES; \
done
make[1]: Leaving directory '/source/ExamplePackage/WIZARD_UIFILES'
<=== WIZARD_UIFILES
ls /tmp/_package_tgz | tar cJf /tmp/_test_spk/package.tgz -C /tmp/_package_tgz -T /dev/stdin
'scripts' -> '/tmp/_test_spk/scripts'
'scripts/postinst' -> '/tmp/_test_spk/scripts/postinst'
'scripts/postuninst' -> '/tmp/_test_spk/scripts/postuninst'
'scripts/postupgrade' -> '/tmp/_test_spk/scripts/postupgrade'
'scripts/preinst' -> '/tmp/_test_spk/scripts/preinst'
'scripts/preuninst' -> '/tmp/_test_spk/scripts/preuninst'
'scripts/preupgrade' -> '/tmp/_test_spk/scripts/preupgrade'
'scripts/start-stop-status' -> '/tmp/_test_spk/scripts/start-stop-status'
'PACKAGE_ICON.PNG' -> '/tmp/_test_spk/PACKAGE_ICON.PNG'
'PACKAGE_ICON_256.PNG' -> '/tmp/_test_spk/PACKAGE_ICON_256.PNG'
'conf' -> '/tmp/_test_spk/conf'
'conf/privilege' -> '/tmp/_test_spk/conf/privilege'
'conf/resource' -> '/tmp/_test_spk/conf/resource'
'LICENSE' -> '/tmp/_test_spk/LICENSE'
creating package: ExamplePackage-x86_64-1.0.0-0001.spk
source:           /tmp/_test_spk
destination:      /image/packages/ExamplePackage-x86_64-1.0.0-0001.spk
[WARNING] /tmp/_install is empty!
[INFO] Install ExamplePackage finished!
1 projects, 0 failed, 0 blocked.
[INFO] Finished SynoInstall script.

============================================================
               Start to run "Collect package"               
------------------------------------------------------------
/home/caoyang/synology/toolkit/build_env/ds.r1000-7.2/image/packages/ExamplePackage-x86_64-1.0.0-0001_debug.spk -> /home/caoyang/synology/toolkit/result_spk/ExamplePackage-1.0.0-0001
/home/caoyang/synology/toolkit/build_env/ds.r1000-7.2/image/packages/ExamplePackage-x86_64-1.0.0-0001.spk -> /home/caoyang/synology/toolkit/result_spk/ExamplePackage-1.0.0-0001

============================================================
                    Time Cost Statistic                     
------------------------------------------------------------
00:00:00: Traverse project
00:00:00: Link Project
00:00:04: Build Package
00:00:04: Install Package[--with-debug]
00:00:04: Install Package
00:00:00: Collect package

[SUCCESS] ./PkgCreate.py -v 7.2 -p r1000 -c ../source/ExamplePackage finished.
caoyang@simons-yannis:~/synology/toolkit/pkgscripts-ng$ 

```

