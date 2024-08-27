---
title: 安装clash
aliases:
  - 安装 clash
---

# NAS系统折腾记 | 设置科学上网环境
2024年3月5日 4718点热度 10人点赞 131条评论

![](https://nas.yanghong.dev:8200/wp-content/uploads/2024/03/clash.png)

群晖的 NAS 系统搭建好了后，自然就要想办法下载各种各样的软件和内容下来自己玩玩折腾啦。我个人主要的用途一般是下载高清电影/电视剧集，在 `Container Manager` 里尝试各种有趣的容器化软件，去 github 拉取感兴趣的项目玩玩。基于国内的网络环境，TMDB，docker hub，github 都经常时不时抽风，所以怎样能正确地在 NAS 上设置科学上网的环境也成了一个需要解决的问题。

声明：本文仅涉及如何在 NAS 上设置 VPN 科学上网的环境，并不涉及 VPN 服务器的搭建或服务的购买。请选择合法的 VPN 服务来进行科学上网。以下是我收集到的关于 VPN 使用的一些法律规定，请遵守。

> 一、使用VPN是否违法  
> 在我国的法律中，并没有明确规定个人使用VPN违法，同时很多企业也要求员工使用VPN加密上网。但是根据《计算机信息网络国际互联网安全保护管理办法》第十二条的规定，互联单位、接入单位、使用计算机信息网络国际互联网的法人或者其他组织，应当自网络正式联通之日起三十日内，到所在地的省、自治区、直辖市人民政府公安机关指定的受理机关办理备案手续，并且将接入本网络的单位和用户情况备案，且及时报告接入单位和用户的变更情况。由此可知，在我国只是使用VPN并不违法，原则上也不予处罚，但是必须是使用相关单位构建并登记备案的VPN，私自搭建VPN甚至制售VPN有可能涉嫌为非法犯罪。  
> 二、使用VPN在什么情况下明确违法  
> 使用VPN在国际互联网制作、复制、查阅和传播下列信息的，属于是违法行为：  
> 1、煽动抗拒、破坏宪法和法律、行政法规实施，或者其他违反宪法和法律、行政法规的。  
> 2、煽动颠覆国家政权、分裂国家、破坏祖国统一和损害国家机关信誉的。  
> 3、煽动民族仇恨、民族歧视、破坏民族团结，或者捏造、歪曲事实，散布谣言，扰乱社会秩序的；  
> 4、宣扬封建迷信、淫秽、色情、赌博、暴力、凶杀、恐怖，教唆犯罪的；  
> 5、公然侮辱他人或者捏造事实诽谤他人的。  
> 可以由公安机关警告，如果有违法所得，则没收违法所得，对个人可以并处五千元以下的罚款，对单位可以并处一万五千元以下的罚款，情节严重的，并可以给予六个月以内停止网络、联机、停机整顿的处罚，必要时还可以吊销经营许可证或者取消联网资格。

## Clash简介

Clash 是一款流行的网络代理客户端软件，广泛用于跨平台环境，包括 Windows、macOS、Linux、Android 和 iOS。它支持多种代理协议，如 Socks5、Shadowsocks、Vmess、Trojan 等，使用户能够绕过网络限制，访问全球互联网资源。Clash 的特点在于其灵活的配置能力和高级路由功能，允许用户根据域名、IP、地理位置等多种条件来指定流量的走向，实现精细化的流量控制和管理。

## 核心功能

1. **多协议支持**：兼容多种代理协议，满足不同场景下的网络访问需求。
2. **智能路由**：可根据预设规则自动选择最佳代理，优化访问速度和稳定性。
3. **规则分流**：支持基于域名、IP 等条件的分流规则，方便用户根据需要自定义流量的走向。
4. **跨平台使用**：支持主流操作系统，用户可以在多种设备上使用 Clash。
5. **用户界面**：虽然 Clash 本身是一个命令行工具，但许多第三方开发了图形用户界面（GUI），使得普通用户也能轻松配置和使用。

## 准备Clash配置文件

请从VPN服务商那边获得配置文件，并保存为 `config.yaml` 。本文末尾也有一个可用的 `config.yaml` 文件供学习用途。

## 安装并运行Clash docker镜像

进入群晖 `Container Manager` 套件，搜索 `clash`，可以看到 `dreamacro/clash` ，双击下载下来。

![](https://nas.yanghong.dev:8200/wp-content/uploads/2024/03/image-18-1024x578.png)

找到刚才下载好的 Clash docker 镜像，点击“运行”。

![](https://nas.yanghong.dev:8200/wp-content/uploads/2024/03/image-19-1024x580.png)

Clash docker 常规设置可以保持缺省，或者按照自己机器的配置情况调整。

![](https://nas.yanghong.dev:8200/wp-content/uploads/2024/03/image-20.png)

在高级设置中，将 `/docker/clash` 目录映射到docker里的 `/root/.config/clash` 目录。注意将 `config.yaml` 文件拷贝到 `/docker/clash` 目录下。

![](https://nas.yanghong.dev:8200/wp-content/uploads/2024/03/image-23.png)

网络则可以选择 “bridge” 模式。

![](https://nas.yanghong.dev:8200/wp-content/uploads/2024/03/image-24.png)

点击“完成”开始运行容器。

![](https://nas.yanghong.dev:8200/wp-content/uploads/2024/03/image-25.png)

可以看到 `clash` 容器已经在正常运行了。

![](https://nas.yanghong.dev:8200/wp-content/uploads/2024/03/image-26-1024x432.png)

## 安装 Yacd 面板

完成上述的 `Clash docker` 安装步骤后，如果 `config.yaml` 文件配置没有问题的话，实际上科学上网的环境已经可以正常使用了。接下来我们再安装一个`Clash UI`的工具，方便今后的配置。

进入 `container manager`，搜索 `yacd`，下载 `haishanh/yacd` 并安装。

![](https://nas.yanghong.dev:8200/wp-content/uploads/2024/03/image-27-1024x579.png)

下载完成后，选择 `haishanh/yacd` 镜像，点击“运行”。

![](https://nas.yanghong.dev:8200/wp-content/uploads/2024/03/image-28-1024x581.png)

注意，在高级设置里，把容器的 80 端口映射到合适的本地端口。我这里设置为 9080 端口。然后点击“下一步”，完成容器设置并运行容器。

![](https://nas.yanghong.dev:8200/wp-content/uploads/2024/03/image-29.png)

## 配置Clash

通过浏览器访问 `http://nas_ip:9080` 就可以配置Clash了。

![](https://nas.yanghong.dev:8200/wp-content/uploads/2024/03/image-30-1024x562.png)

在 Proxies 页面中，选择自己的 VPN 配置就可以了。

![](https://nas.yanghong.dev:8200/wp-content/uploads/2024/03/image-31-1024x564.png)

## 配置客户端

客户端主要是把网络代理配置为 `http://nas_ip:7890` 。如下以PC端Firefox为例。其它设备如iPhone，群晖NAS等的设置方法可以自行百度。有不会设置的也可以给我留言。设置完了以后奈飞，谷歌都可以访问了。

![](https://nas.yanghong.dev:8200/wp-content/uploads/2024/03/image-32-1024x553.png)

![](https://nas.yanghong.dev:8200/wp-content/uploads/2024/03/image-33-1024x562.png)

![](https://nas.yanghong.dev:8200/wp-content/uploads/2024/03/image-34-1024x554.png)

如果您需要学习Clash，请从下面的地址下载 `config.yaml` （==此服务器是我个人购买，所以请大家注意节约流量，不要访问违法的内容。另外这个config.yaml文件也会不定期更新，所以如果发现无法连接上VPN的时候，可以访问本文重新下载新的config.yaml。谢谢配合==）。另外 Clash 也支持 MacOS，Windows，Linux 客户端，也可以从如下地址下载。

|                                                                                                                                                                                                                                                                                                                       |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| config.yaml：[https://nas.yanghong.dev:8203/Tools/Clash_for_Windows-0.20.39/config.yaml](https://nas.yanghong.dev:8203/Tools/Clash_for_Windows-0.20.39/config.yaml)  <br>Clash客户端程序下载：[https://nas.yanghong.dev:8203/Tools/Clash_for_Windows-0.20.39/](https://nas.yanghong.dev:8203/Tools/Clash_for_Windows-0.20.39/) |
