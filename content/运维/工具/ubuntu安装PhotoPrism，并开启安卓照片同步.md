

 本文讲述了作者从黑群晖转移到开源的PhotoPrism进行照片管理，因其部署简单、配置灵活和局域网同步方便而选择。详细介绍了在Ubuntu上使用Docker部署PhotoPrism，并配置SMBSync2进行照片自动同步的过程。
摘要由CSDN通过智能技术生成
之前安装了黑群晖7.2，并开启了Photo，照片同步用的挺好。唯一的缺陷是群晖的照片搜索太弱鸡了，基本上关键字搜索是一点不可用，常见的“花”，“山”，“文件”，“证件”都是不可用的。

后来了解到了开源的PhotoPrism，发现搭建过程和使用体验都还不错，遂打算迁移到PhotoPrism上。

搭建过程：
首先要确保ubuntu上安装了docker环境，有compose最好，没有也行，当然其他支持docker的系统也都可以，centos，openwrt都可以。
```bash
docker run -d --name photoprism \
-e PHOTOPRISM_ADMIN_PASSWORD=photoprism \
-p 2342:2342 \
-v /mnt/sdb/photoprism/config:/photoprism/storage \
-v /mnt/sdb/photoprism/photos:/photoprism/originals \
--restart always \
photoprism/photoprism
```

其中目录`[/mnt/sdb/photoprism/config]`是存放缓存和配置的目录，建议不要太小，至少2G

其中目录`[/mnt/sdb/photoprism/photos]`是照片原始目录，根据情况设置

这个部署过程也是我选Photoprism的原因：

1.部署简单，一条docker命令，比安装黑群晖方便多了

2.配置文件在单独目录存储，后续重装缓存不会丢失，省去了费时的重建缓存时间

3.照片目录就是普通的linux目录，可以开samba，可以局域网同步



局域网同步：
上个章节提及了照片目录就是普通的linux文件路径，为了局域网访问方便，我也开了samba，所以文件同步方案就用的SMBSync2软件，安卓装个apk即可。如果是ios，可以用syncthing或者Resilio Sync。

SMBSync2可以在googleplay上下载，也有镜像站可以下载。



安装后，需要手动设置同步的目录和同步计划

我是这么设置的：

首先建立3个同步，分别把安卓的DCIM，Download，Picture3个目录同步到Linux服务器上，基本上这3个目录覆盖了安卓常用的照片路径。如果没有包含，可以自行添加。



详细设置如下：



注意：高级选择中要把隐藏文件和隐藏文件夹去勾选，安卓有不少隐藏文件，同步这些没用

再建个同步计划，固定某个周期同步，当然手动同步也是可以的



至此，教程结束，enjoy！











# 官方：使用Docker运行PhotoPrism[¶](https://docs.photoprism.app/getting-started/docker/#running-photoprism-with-docker "永久链接")

我们建议使用[Docker Compose](https://docs.photoprism.app/getting-started/docker-compose/)，因为它比[纯粹的Docker命令行界面](https://docs.docker.com/engine/reference/commandline/cli/)更容易，也为运行多个服务提供了更多的便利。在继续之前，请确保您在系统上安装了[Docker](https://store.docker.com/search?type=edition&offering=community)。它适用于Mac、Linux和Windows。

或者，支持[Podman](https://podman.io/)作为Red Hat兼容的Linux发行版（如RHEL、CentOS、Fedora、AlmaLinux和Rocky Linux）上的Docker的下拉式替代品。

### 步骤1：启动服务器[¶](https://docs.photoprism.app/getting-started/docker/#step-1-start-the-server "永久链接")

[Linux](https://docs.photoprism.app/getting-started/docker/#__tabbed_1_1)[波德曼](https://docs.photoprism.app/getting-started/docker/#__tabbed_1_2)

打开一个终端，在将`~/Pictures`替换为包含图片的文件夹后，运行此命令以启动应用程序：

修改：` PHOTOPRISM_ADMIN_PASSWORD="insecure" \` 登陆密码

```bash
docker run -d \
  --name photoprism \
  --security-opt seccomp=unconfined \
  --security-opt apparmor=unconfined \
  -p 2342:2342 \
  -e PHOTOPRISM_UPLOAD_NSFW="true" \
  -e PHOTOPRISM_ADMIN_PASSWORD="caoyang2002" \
  -v /photoprism/storage \
  -v ~/images:/photoprism/originals \
  photoprism/photoprism
```
服务器端口和其他[配置选项](https://docs.photoprism.app/getting-started/config-options/)可以根据需要进行更改。如果您没有提供数据库服务器凭据，SQLite数据库文件将在_存储_文件夹中创建。然而，请注意，对于需要可扩展性和高性能的用户来说，SQLite不是一个好的选择。因此，我们不建议使用此示例在不修改的情况下设置生产环境，例如将其连接到现有的MariaDB数据库实例。

始终更改`PHOTOPRISM_ADMIN_PASSWORD`，以便应用程序从**安全的初始密码**开始。切勿在公共可访问的服务器上使用易于猜测的密码或默认值（如`insecure`）。[如果没有提供密码，](https://docs.photoprism.app/user-guide/users/cli/#changing-a-password)则没有默认设置。长度至少需要8个字符。

当不作为root运行时，Linux上的命令可能必须以`sudo`前缀。请注意，这将在卷挂载中将主目录快捷方式`~`指向`/root`。据报道，AppArmor和SELinux等内核安全模块会导致[问题](https://docs.photoprism.app/getting-started/troubleshooting/)。

应用程序启动后，通过导航到[http://localhost:2342/](http://localhost:2342/)打开Web UI。你应该会看到一个登录屏幕。使用用户`admin`登录，并通过`PHOTOPRISM_ADMIN_PASSWORD`配置密码。您可以在[帐户设置页面上](https://docs.photoprism.app/user-guide/settings/account/)更改它。启用[公共模式](https://docs.photoprism.app/getting-started/config-options/)将禁用身份验证。

在调试时保持Docker在前台运行可能会有所帮助，以便直接显示日志消息。为此，重新启动时省略`-d`参数。

如果服务器已经在运行，或者您没有看到错误，您可能已经在其他主机和/或端口上启动了它。[您的浏览器、广告拦截器或防火墙设置](https://docs.photoprism.app/getting-started/troubleshooting/#connection-fails)也可能存在[问题](https://docs.photoprism.app/getting-started/troubleshooting/#connection-fails)。

首次启动应用程序后，您无法使用`PHOTOPRISM_ADMIN_PASSWORD`更改密码。要更改_管理员_密码，请在终端中运行`docker exec -ti photoprism photoprism passwd [username]`命令。您还可以运行`docker exec -ti photoprism photoprism reset`来删除现有的索引数据库并从头开始。

#### 卷[¶](https://docs.photoprism.app/getting-started/docker/#volumes "永久链接")

由于该应用程序在容器内运行，您必须显式[挂载](https://docs.docker.com/storage/bind-mounts/)要[使用的主机文件夹](https://docs.docker.com/storage/bind-mounts/)。PhotoPrism将无法看到尚未挂载的文件夹。这是一个重要的安全功能。

##### /摄影/原件[¶](https://docs.photoprism.app/getting-started/docker/#photoprismoriginals "永久链接")

_原始_文件夹包含您的原始照片和视频文件。它们从上面示例中的`~/Pictures`中安装，其中`~`是主目录的快捷方式。

您可以[挂载从主机访问的任何文件夹](https://docs.docker.com/storage/bind-mounts/)，包括[网络驱动器](https://docs.photoprism.app/getting-started/faq/#how-can-i-mount-network-shares-with-docker)。其他目录可以作为`/photoprism/originals`的子文件夹挂载：

`-v ~/Example:/photoprism/originals/Example`

如果启用_只读模式_，则禁用所有需要对_原始_文件夹_的_写入权限的功能，例如[WebDAV](https://docs.photoprism.app/user-guide/sync/webdav/)、上传和删除文件。为此，使用`-e PHOTOPRISM_READONLY="true"`运行应用程序。您可以使用[`:ro`标志挂载文件夹，](https://docs.docker.com/storage/bind-mounts/#use-a-read-only-bind-mount)以使Docker块也写入操作。

##### /摄影/存储[¶](https://docs.photoprism.app/getting-started/docker/#photoprismstorage "永久链接")

SQLite、配置、缓存、备份、缩略图和侧车文件保存在_存储_文件夹中：

- 必须始终挂载_存储_文件夹，以便您在重新启动或升级后不会丢失这些文件
- 切勿将_存储_文件夹配置为在_原始_文件夹中，除非名称以`.`开头，以表明它被隐藏
- 我们建议将_存储_文件夹放在[本地SSD驱动器上](https://docs.photoprism.app/getting-started/troubleshooting/performance/#storage)，以获得最佳性能
- 目前不支持在_存储_文件夹中安装[符号链接](https://en.wikipedia.org/wiki/Symbolic_link)或使用它们

使用我们的示例，创建一个[匿名卷](https://docs.docker.com/storage/bind-mounts/)并挂载为_存储_文件夹。您可以挂载特定的主机文件夹，就像_原始文件夹一样_，这更适合生产环境。

如果您以后想将实例移动到另一个主机，最简单、最省时的方法是将整个_存储_文件夹与原件和数据库一起复制。

##### /摄影/进口[¶](https://docs.photoprism.app/getting-started/docker/#photoprismimport "永久链接")

您可以选择挂载一个_导入_文件夹，从中可以以结构化的方式将文件传输到_原始_文件夹，避免重复：

- [导入的文件](https://docs.photoprism.app/user-guide/library/import/)会收到一个规范的文件名，并将按年份和月份进行组织
- 切勿将_导入_文件夹配置为_原始_文件夹内，因为这会通过导入已索引的文件导致循环

你可以安全地跳过这个。除非启用了[只读模式](https://docs.photoprism.app/getting-started/config-options/)或[禁用](https://docs.photoprism.app/user-guide/settings/general/)了[功能](https://docs.photoprism.app/user-guide/settings/general/)，否则仍然可以通过[Web Upload](https://docs.photoprism.app/user-guide/library/upload/)和[WebDAV](https://docs.photoprism.app/user-guide/sync/webdav/)添加文件。

### 第2步：第一步[¶](https://docs.photoprism.app/getting-started/docker/#step-2-first-steps "永久链接")

我们的[第一步👣](https://docs.photoprism.app/user-guide/first-steps/)教程指导您完成用户界面和设置，以确保您的库根据您的个人偏好进行索引。

很简单，不是吗？

### 第3步：当你完成后...[¶](https://docs.photoprism.app/getting-started/docker/#step-3-when-youre-done "永久链接")

您可以使用以下命令停止PhotoPrism并再次启动它：

`docker stop photoprism docker start photoprism`

要完全取出容器：

`docker rm -f photoprism`

### PhotoPrism® Plus[¶](https://docs.photoprism.app/getting-started/docker/#photoprism-plus "永久链接")

我们的会员可以通过登录[设置期间创建](https://docs.photoprism.app/getting-started/config-options/#authentication)的[管理员用户](https://docs.photoprism.app/getting-started/config-options/#authentication)，然后按照[我们的激活指南中描述的](https://www.photoprism.app/kb/activation)步骤来激活[其他功能](https://link.photoprism.app/membership)。感谢您的支持，这一直是并将继续对项目的成功至关重要！

[比较会员资格 ›](https://link.photoprism.app/membership) [查看会员资格常见问题 ›](https://www.photoprism.app/membership/faq)

我们建议新用户在[注册会员资格](https://link.photoprism.app/membership)之前安装我们的免费社区版。

### 故障排除[¶](https://docs.photoprism.app/getting-started/docker/#troubleshooting "永久链接")

如果您的服务器内存不足，索引经常被锁定，或者其他系统资源不足：

- 尝试通过将`PHOTOPRISM_WORKERS`设置为合理的小值来[减少工人数量](https://docs.photoprism.app/getting-started/config-options/#indexing)，这取决于CPU性能和内核数量
- 确保您的服务器配置了[至少4 GB的交换](https://docs.photoprism.app/getting-started/troubleshooting/docker/#adding-swap)，并避免设置[硬内存限制](https://docs.photoprism.app/getting-started/faq/#why-is-my-configured-memory-limit-exceeded-when-indexing-even-though-photoprism-doesnt-actually-seem-to-use-that-much-memory)，因为当索引器暂时需要更多内存来处理大文件时，这可能会导致意外重新启动
- 如果您使用的是SQLite，请切换到MariaDB，它[更适合高并发](https://docs.photoprism.app/getting-started/faq/#should-i-use-sqlite-mariadb-or-mysql)
- 作为最后一项措施，您可以[禁用TensorFlow](https://docs.photoprism.app/getting-started/config-options/#feature-flags)进行图像分类和面部识别

其他问题？我们的[故障排除清单可](https://docs.photoprism.app/getting-started/troubleshooting/)帮助您快速诊断和解决它们。

欢迎您在我们的[社区聊天](https://link.photoprism.app/chat)中寻求帮助。[赞助商](https://www.photoprism.app/membership)通过电子邮件获得直接[技术支持](https://www.photoprism.app/contact)。在[提交支持请求](https://docs.photoprism.app/getting-started/#getting-support)之前，请尝试[确定问题的原因](https://docs.photoprism.app/getting-started/troubleshooting/)。

### 命令行界面[¶](https://docs.photoprism.app/getting-started/docker/#command-line-interface "永久链接")

#### 介绍[¶](https://docs.photoprism.app/getting-started/docker/#introduction "永久链接")

`photoprism help`列出当前版本中可用的所有命令和[配置选项](https://docs.photoprism.app/getting-started/config-options/)：

`docker exec -ti photoprism photoprism help`

使用`--help`标志查看详细的命令描述，例如：

`docker exec -ti photoprism photoprism backup --help`

PhotoPrism的命令行界面也非常适合使用[调度器](https://dl.photoprism.app/docker/scheduler/)进行作业自动化。

使用_Docker_时，您可以预先添加`docker exec -ti [container] [command]`等命令在容器中运行它们。如果失败且_未找到容器_，请确保容器已启动，并且您已指定现有容器名称或ID。

#### 打开终端[¶](https://docs.photoprism.app/getting-started/docker/#opening-a-terminal "永久链接")

要打开终端会话，您可以运行以下操作（将`$UID`替换为要使用的用户ID，或完全省略`-u`标志以将终端作为根打开）：

`docker exec -ti -u $UID photoprism bash`

传递`-ti`标志对于交互式命令的工作很重要，例如，如果您需要确认操作。

#### 更改用户ID[¶](https://docs.photoprism.app/getting-started/docker/#changing-the-user-id "永久链接")

对于您使用Docker运行的所有命令，都可以指定带有`-u`标志的用户。在以下示例中，为了简洁，它被省略了。然而，请注意，您在没有显式用户ID的情况下运行的命令可能会作为root执行。目前支持的用户ID范围为0、33、50-99、500-600、900-1250和2000-2100。

#### 实例[¶](https://docs.photoprism.app/getting-started/docker/#examples "永久链接")

|行动|命令|
|---|---|
|_启动PhotoPrism_|`docker start photoprism`|
|_停止PhotoPrism_|`docker stop photoprism`|
|_下载更新_|`docker pull photoprism/photoprism:latest`|
|_卸载_|`docker rm -f photoprism`|
|_查看日志_|`docker logs --tail=100 -f photoprism`|
|_显示配置值_|`docker exec -ti photoprism photoprism show config`|
|_显示迁移状态_|`docker exec -ti photoprism photoprism migrations ls`|
|_重复失败的迁移_|`docker exec -ti photoprism photoprism migrations run -f`|
|_重置数据库_|`docker exec -ti photoprism photoprism reset --yes`|
|_备份数据库_|`docker exec -ti photoprism photoprism backup -a -i`|
|_恢复数据库_|`docker exec -ti photoprism photoprism restore -a -i`|
|_更改密码_|`docker exec -ti photoprism photoprism passwd [username]`|
|_显示用户管理命令_|`docker exec -ti photoprism photoprism users help`|
|_重置用户帐户_|`docker exec -ti photoprism photoprism users reset --yes`|
|_重置会话和访问令牌_|`docker exec -ti photoprism photoprism auth reset --yes`|
|_显示人脸识别命令_|`docker exec -ti photoprism photoprism faces help`|
|_索引面孔_|`docker exec -ti photoprism photoprism faces index`|
|_重置人和面孔_|`docker exec -ti photoprism photoprism faces reset -f`|
|_将视频转码为AVC_|`docker exec -ti photoprism photoprism convert`|
|_再生缩略图_|`docker exec -ti photoprism photoprism thumbs -f`|
|_更新索引_|`docker exec -ti photoprism photoprism index --cleanup`|
|[_移动到原件_](https://docs.photoprism.app/user-guide/library/import/)|`docker exec -ti photoprism photoprism import [path]`|
|[_复制到原件_](https://docs.photoprism.app/user-guide/library/import/)|`docker exec -ti photoprism photoprism cp [path]`|

_您也可以使用`podman`作为Red Hat兼容发行版上`docker`的drop-in替代品。_

完成重新扫描

`docker exec -ti photoprism photoprism index -f`
重新扫描所有原件，包括已索引和未更改的文件。在重大升级和迁移数据库模式后，这可能是必要的，特别是在搜索结果缺失或不正确的情况下。注意：您还可以通过导航到_库_>_索引_，选中“完全重新扫描”，然后单击“开始”[从用户界面](https://docs.photoprism.app/user-guide/library/originals/)开始[重新扫描。](https://docs.photoprism.app/user-guide/library/originals/)手动输入的标签、人物、标题或描述等信息在索引时不会被修改，即使您执行“完全重新扫描”。



# 重新部署

```bash
# 停止现有的容器
sudo docker stop photoprism 
# 删除现有的容器
sudo docker rm photoprism

sudo docker run -d \
  --name photoprism \
  --security-opt seccomp=unconfined \
  --security-opt apparmor=unconfined \
  -p 2342:2342 \
  -e PHOTOPRISM_UPLOAD_NSFW="true" \
  -e PHOTOPRISM_DISABLE_FACES="true" \
  -e PHOTOPRISM_ADMIN_PASSWORD="caoyang2002" \
  -v /home/ubuntu/photoprism/config:/photoprism/storage \
  -v /home/ubuntu/photoprism/photos:/photoprism/originals \
  photoprism/photoprism
```

