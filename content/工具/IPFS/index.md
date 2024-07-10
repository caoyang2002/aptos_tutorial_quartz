bilibili ---- jupiter 黑客松 workshop2 

> 可以吧 IPFS 理解成对象存储

访问
```
oss://
ipfs://
```


文件系统：

IPFS 技术栈：
LIBP2P 提供网络协议
IPLD 标准的数据格式生成 CID


获取数据：
- 内容寻址
- 点对点协议


# IPFS 开发工具
- 节点安装
- IPFS Desktop：GUI
- go-ipfs CLI ：命令行工具
- ipfs-update  
- NPM


HTTP 网关
```url
https://ipfs.io/ipfs/<CID-vAny>
https://<CID-v1>.ipfs.dweb.link
https://<CID-v1>.ipfs.cf-ipfs.com
https://ipfs.github.io/public-gateway-checker/
```

# IPFS 固定服务
我自己的 IPFS 节点服务关闭，数据怎么办？IPFS 固定服务（Pinning services）会保证你的应用程序和数据在线
- Infura   https://infura.io/product/ipfs
- Pinata https://www.pinata.cloud/
- Temporal  https://temporal.cloud/
- Eternum  https://www.eternum.io


# IPFS 开发工具 & 服务
## JS-IPFS：
> 类似于 SDK
- 一个比较完整的 IPFS 实现
- 适用于 Node.js 和浏览器
- 通过 npm 安装 IPFS
- 用于跨选项 共享实例的 ipfs-message-port-client/server

## go-ipfs
> 后端

相较高的抽象出更简易使用的开发工具：
- Textile：bucket、Powergate
- nft.storage
- web3.storage
- OrbitDB


# 网站托管 & 发布
- Fleek.co
- ipfs-deploy
- static site generators

# 使用 IPFS 托管网站
## 使用 IPFS 节点上传网站
- 安装 IPFS Desktop 或者 CLI 工具
- 创建你的网页/网站
- 上传网页至 IPFS
- 访问：
	- 通过 IPFS Gateway
	- 设置域名服务

## 通过固定服务上传文件
- 在 pinata 注册账户并登陆
- 上传网页至 IPFS
- 访问
	- 通过 IPFS Gateway
	- 设置域名服务

# 在开发中使用 IPFS
## 准备工具
- ipfs desktop 或者 go-ipfs cli
- ipfs-http-client
- nodejs
## 如何使用
- 在 react 应用中引入ipfs-http-client
- 连接 ipfs节点
- 上传文件至 ipfs 网络
- 通过 ipfs 网关获取文件


# 使用 nft.storage 在 IPFS 为 NFT 提供存储


# 在开发中使用 IPFS API

```
https://github.com/ipfs-examples
```


## 安装包

```bash
npm install ipfs-http-client
```

## 连接到 ipfs
`conntct.tsx`
```tsx
import {create} from 'ipfs-http-client'
export const Connect = ({setIpfs}) => {
	const [error,setError] = useState(null);
	// 1. 添加可以连接到 ipfs node 的 url
	const [url, setUrl] = useState('/ip4/127.0.0.1/tcy/5001');
	const connect = async(e) => {
		try{
			//2. 创建 ipfs实例 查看是否连接成功
			const isOnline = await ipfs.isOnline();
			if (isOnline){
				// 3. 返回创建的 ipfs client
				setIpfs(ipfs);
				setError(null)
			}
		}catch(err){
		setError(err.message)
		}
	}
	return(
	<>
	...
	</>)
}
```

`app.tsx`

```tsx
// 添加 connect 组件
import {Connect, }from 'path/to/Connect'
import {create} from 'ipfs-http-client'
function App(){
	// 引入 ipfs
	const [ipfs, setIpfs] = useState(null)
	const [id,setId] = useState(null) // 测试：展示 id
	const [version, setVersion] = useState(null)
	
	// 测试展示节点
	useEffect(() => {
		if (!ipfs)return
		const getVersion = async() => {
			const nodeId = await ipfs.version();
			setVersion(nodeid);
		}
		
		const getId = async() => {
			const nodeId = await ipfs.id();
			setId(nodeid);
		}
	},[ipfs])
	getVersion();
	getId();
	const ipfs = create(url);
	// 2. 创建 ipfs http client 实例 查看是否连接成功
	
	return(
	<>
	<Connect setIpfs={setIpfs}/>
	</>
	)
}

```


`saveFile.tsx`
```tsx
ipfs.add()
```