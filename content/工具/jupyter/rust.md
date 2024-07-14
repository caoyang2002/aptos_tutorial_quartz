# 安装Miniconda
有很多方法可以安装并建立交互式编程环境，这里我推荐用Miniconda。

Miniconda是一款小巧的python环境管理工具，安装包大约只有50M多点，其安装程序中包含conda软件包管理器和Python。一旦安装了Miniconda，就可以使用conda命令安装任何其他软件工具包并创建环境等。

你也可以不装Miniconda，直接安装Jupyter Lab。但我建议用Miniconda，因为除了交互式编程环境，我们还需要Miniconda来管理包和虚拟环境。

Miniconda的官网上有详细的安装教程。如果你像我一样使用Linux，你可以在控制台运行如下命令：
```bash
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

chmod +x Miniconda3-latest-Linux-x86_64.sh 

./Miniconda3-latest-Linux-x86_64.sh
```


上面的命令将下载Miniconda的安装脚本并启动交互式安装。按照提示一步步完成安装，当你看到

Thank you for installing Miniconda3!
说明安装成功。

2. 创建环境
Miniconda安装好后，我们需要创建并配置环境。如果在安装时已经将Miniconda加入到环境变量PATH中，那么你可以直接在控制台、Poweshell或CMD中运行conda命令。

我们可以通过下面的命令创建并配置环境：

```bash
conda create -n rustenv python=3
```

其中rustenv是环境名，你可以替换成任意你喜欢的名字。

上面的命令会创建一个名叫rustenv的conda环境并下载最新的Python 3包。你将看到一个即将下载安装的包的列表，并询问你是否继续。输入y进行安装。等待安装成功后，你将看到如下信息：
```
Preparing transaction: done
Verifying transaction: done
Executing transaction: done
#
# To activate this environment, use
#
# $ conda activate rustenv
#
# To deactivate an active environment, use
#
# $ conda deactivate

消息提示输入如下命令激活并进入环境：

conda activate rustenv
1
输入执行后你将看到控制台提示符最前端会出现括号括起来的环境名。

(rustenv) jarod_laptop:~ jarod$
1
命令行提示符前的环境名有助于你识别当前在那个环境下。每次电脑重启，都需要执行conda activate rustenv进入rustenv环境。
```

3. 安装Jupyter Lab
环境安装好后，你可以输入jupyter lab启动Jupyter Lab实例。但是，如果你是新建的环境，执行jupyter lab会看到一个报错，
```bash
jupyter lab

```

>`-bash: jupyter: command not found`


这是因为没有安装Jupyter Lab造成的。接下来我们通过如下命令安装Jupyter Lab：
```bash
conda install -c conda-forge jupyterlab
```

4. 安装Jupyter Lab扩展
Jupyter Lab有很多扩展插件可以实现丰富的扩展功能，其中一个非常有用的插件是plotly。它可以让Jupyter渲染Plotly可视化图表。在conda环境下执行下面的命令即可安装：

jupyter labextension install jupyterlab-plotly
1
这个安装可能需要花点时间。安装成功后控制台会再次出现输入提示符。

Jupyter Lab还支持主题换肤，如果你喜欢深色主题，可以试一下下面这个主题：

jupyter labextension install @shahinrostami/theme-purple-please
1


图1. Jupyter Lab深色主题
5. 安装Rust
有很多中方法可以安装Rust，大家可以参考Rust官方教程。推荐用rustup安装。我用的操作系统是Linux，可以在控制台通过如下命令安装：

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
1
本专栏的示例代码兼容多个Rust版本，由于我本机的Rust版本为1.65.0，我可以保证所有代码和包都可以在Rust 1.65.0下正常运行。你可以通过下面命令将Rust版本锁定为1.65.0：

rustup default 1.65.0

运行上面代码可能会提示你将Cargo加入环境变量PATH，

```bash
source $HOME/.cargo/env
```


其他控制台，如zsh，输入上面命令可能无效，你可以用跟基本的命令添加环境变量
```bash
export PATH="$HOME/.cargo/bin:$PATH"
```

添加完后重启控制台，确保环境变量写入。你可以输入
```bash
cargo version
```

确认是否安装成功。如果控制台上输出cargo版本（cargo 1.65.0），说明安装好了。

## 安装 EvCxR

https://github.com/evcxr/evcxr/tree/main/evcxr_jupyter


接下来我们来安装EvCxR Jupyter内核。EvCxR可以让Rust运行在Jupyter Notebook上。你可以参考官网的方法来完成EvCxR的安装。我这里推荐的安装方法是：
```bash
cargo install evcxr_jupyter
evcxr_jupyter --install
```

1
2
7. 小试牛刀
安装完EvCxR后，我们就可以试一下整个环境能够跑起来。打开控制台，进入上面我们创建的conda环境，然后运行如下命令：

jupyter lab
1
这条命令将启动Jupyter Lab服务，并打开浏览器显示Jupyter Lab的前端界面。



图2. Jupyter Lab前端界面
如果在界面上Notebook和Console中能看到Rust图标，这就说明我们环境搭建好了。

我们可以新建一个Rust Notebook。点击Notebook栏的Rust图标就可以创建一个以Rust为内核的notebook。如果环境搭建没问题，那么会在当前目录下新建一个名为Untitled.ipynb 的空白notebook。我们可以试着在上面写一些Rust代码，按照管理，我们来写个“Hello World!”：

println!("Hello World!");
1
如果环境配置一切正常，那么运行上面代码你将看到输出Hello World!

总结
本章我们已经下载、安装、配置和测试了我们的Rust交互式编程环境。我们喜爱的Jupyter环境现在可以运行Rust代码了！随着Rust的日渐壮大，很多原本Python上好用的包在Rust都有相对应的实现。后面我将陆续给大家介绍Python机器学习常用包的Rust替代，让大家逐渐用Rust替代Python完成机器学习任务。


————————————————

                            版权声明：本文为博主原创文章，遵循 CC 4.0 BY-NC-SA 版权协议，转载请附上原文出处链接和本声明。
                        
原文链接：https://blog.csdn.net/jarodyv/article/details/127783416










---


步骤一：安装Rust和Cargo  
确保你的系统已经安装了Rust和Cargo。你可以从Rust官网下载安装包，并按照官方指南进行安装。

步骤二：安装Jupyter和kernel  
如果你还没有安装Jupyter，可以从Anaconda官网下载并安装。为了在Jupyter中运行Rust代码，你需要安装Rust kernel。你可以使用`ipykernel`包来安装Rust kernel。在终端中运行以下命令：

1. `pip install ipykernel`

步骤三：配置Jupyter的kernel  
为了在Jupyter中运行Rust代码，你需要将Rust kernel添加到Jupyter的kernel列表中。在终端中运行以下命令：

1. `python -m ipykernel install --user --name=rust`

这将添加一个名为“rust”的kernel到Jupyter的kernel列表中。

步骤四：创建Jupyter notebook  
打开Jupyter notebook，创建一个新的notebook。在菜单栏中选择“File”->“New Notebook”，然后选择“Rust”。这将创建一个新的notebook，并在代码单元格中自动显示Rust语言的提示符。

步骤五：编写和运行Rust代码  
现在你可以在Jupyter notebook中编写和运行Rust代码了。在代码单元格中输入Rust代码，然后运行单元格。按下“Shift+Enter”即可运行当前单元格并进入下一个单元格。你也可以使用“Ctrl+Enter”来运行当前单元格而不进入下一个单元格。

例如，下面是一个简单的Rust代码示例，演示如何在Jupyter notebook中编写和运行：
```bash
fn main() {
	println!("Hello, world!");
}
```


将上述代码复制到一个新的代码单元格中，然后按下“Shift+Enter”，你将看到输出结果“Hello, world!”。

步骤六：使用第三方库  
如果你需要使用第三方库，可以使用Cargo来管理依赖项。在终端中进入你的项目目录，然后运行以下命令来添加依赖项：

1. `cargo add <package-name>`

例如，要添加一个名为“rand”的随机数生成库，可以运行以下命令：

1. `cargo add rand`

然后，在Jupyter notebook的代码单元格中导入并使用该库即可。例如：
```bash

```
1. `use rand::Rng;`
2. `fn main() {`
3.     `let mut rng = rand::thread_rng();`
4.     `let n: u32 = rng.gen();`
5.     `println!("Random number: {}", n);`
6. `}`

将上述代码复制到一个新的代码单元格中，然后按下“Shift+Enter”，你将看到输出结果包含一个随机数。

通过以上步骤，你就可以在Jupyter上搭建Rust交互式编程环境，并在notebook中编写和运行Rust代码了。这为学习和探索Rust语言提供了一个方便的交互式环境。


# 配置 Jupyter 的 kernel  
为了在Jupyter中运行Rust代码，你需要将Rust kernel添加到Jupyter的kernel列表中。在终端中运行以下命令：


1. `pip install ipykernel`

```bash
python -m ipykernel install --user --name=rust
```


```bash

```