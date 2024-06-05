---
title: 搭建一个简单的在线 Move 运行环境
---
```yaml
original: 原创
status: 已完成
note: "本人测试过 Mac 和 Windows，可以完美运行"
```
# 一、前端（ts、react）

> 前端配置：TypeScript、React
>  依赖项：axios、codemirror、react-codemirror2


## 1. 初始化模板

> 任意选一个就行

### 1.1 交互式

```bash
npm init vite
```
> 可能需要先安装
> `npm install vite --save-dev`

```
caoyang@cccy del % npm init vite
# 使用 上下键 选择
✔ Project name: … playground  # playground 是项目名称，它会创建一个该名称的文件夹作为项目根目录
✔ Select a framework: › React  # 使用 React 库
✔ Select a variant: › TypeScript  # 使用 TS 语言开发

Scaffolding project in /Users/caoyang/Documents/Aptos/del/playground...

Done. Now run:

# 需要先运行以下代码
  cd playground
  npm install
  npm run dev
```

### 1.2 一键创建

```bash
npm init vite playground -- --template react-ts
```

或者

```bash
npx create-vite playground --template react-ts
```

或者

```bash
npm init @vitejs/app playground -- --template react-ts
```
{bs-accord style=line title=解析}
`npm init vite` : 是一个 npm 初始化命令，它使用了 Vite 工具，
`my-react-ts-app` : 是您希望创建的项目的名称。
`--` : 是用来分隔 npm 命令行选项和参数的，
`--template react-ts` : 是向 Vite 提供的选项，它告诉 Vite 使用 React TypeScript 模板来生成项目。
{/bs-accord}


## 2. 安装并运行模板

```bash
# 需要先运行以下代码
  cd playground
  npm install
  npm run dev
```

> ```bash
> caoyang@cccy playground %   npm install
> added 218 packages, and audited 219 packages in 59s
> 41 packages are looking for funding
>  run `npm fund` for details
> found 0 vulnerabilities
> ```

> 在 vscode 中打开，并编辑

## 3. 删除不需要的文件

建议删除，否则可能出现非预期的情况
- `public / vite.svg`
- `src / App.css`
- `src / index.css`
- 删除 `App.tsx` 和 `main.tsx` 中的导入



## 4. 创建 `playground.tsx` 组件

> 安装依赖项

```bash
npm install axios codemirror react-codemirror2
# 或者
npm install axios codemirror react-codemirror2 --legacy-peer-deps
# 或者
npm install axios@1.6.8 codemirror@5.65.16 react@18.2.0 react-codemirror2@7.3.0 react-dom@18.2.0
```


```tsx
import React, { useState } from 'react';
import { Controlled as CodeMirror } from 'react-codemirror2';
import axios from 'axios';
import 'codemirror/lib/codemirror.css';
import 'codemirror/theme/material.css';
import './move.js'; // 导入 move.js 文件

const Playground: React.FC = () => {
	const [code, setCode] = useState('');
	const [output, setOutput] = useState('');

	const handleCodeChange = (editor: any, data: any, value: string) => {
		setCode(value);
	};

	const executeCode = async () => {
		try {
			// 发送 Move 代码到后端服务
			const response = await axios.post('http://127.0.0.1:8081/run_move', code);
			setOutput(response.data);
		} catch (error) {
			console.error('执行 Move 代码时出错:', error);
		}


	};

	return (
		<div>
			<CodeMirror
				value={code}
				options={{
					mode: 'move', // 使用 move 模式
					theme: 'material',
					lineNumbers: true,
				}}
				onBeforeChange={(editor, data, value) => {
					setCode(value);
				}}
				onChange={handleCodeChange}
			/>
			<button onClick={executeCode}>执行</button>
			<div>
				<h3>执行结果:</h3>
				<pre>{output}</pre>
			</div>
		</div>
	);
};

export default Playground;
```


## 5. 修改`main.tsx`
```tsx
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.tsx'

ReactDOM.createRoot(document.getElementById('root')!).render(
  // <React.StrictMode>
  <App />
  // </React.StrictMode>,
)
```

## 6. 修改`App.tsx`
```tsx
import { useState } from 'react'
import Playground from './playground'

function App() {
  const [count, setCount] = useState(0)

  return (
    <>
      <Playground />
    </>
  )
}

export default App
```

## 7. 创建语法高亮 `move.js`

> 这部分没有完全适配，只是一个 rust 模板。

```js
import CodeMirror from 'codemirror';

CodeMirror.defineMode("move", function (config, parserConfig) {
	var indentUnit = config.indentUnit,
		statementIndentUnit = parserConfig.statementIndentUnit || indentUnit,
		dontAlignCalls = parserConfig.dontAlignCalls,
		keywords = parserConfig.keywords || {},
		builtin = parserConfig.builtin || {},
		blockKeywords = parserConfig.blockKeywords || {},
		atoms = parserConfig.atoms || {},
		hooks = parserConfig.hooks || {},
		multiLineStrings = parserConfig.multiLineStrings;
	var isOperatorChar = /[+\-*&%=<>!?|\/]/;

	var curPunc;

	function tokenBase(stream, state) {
		var ch = stream.next();
		if (hooks[ch]) {
			var result = hooks[ch](stream, state);
			if (result !== false) return result;
		}
		if (ch == '"' || ch == "'") {
			state.tokenize = tokenString(ch);
			return state.tokenize(stream, state);
		}
		if (/[\[\]{}\(\),;\:\.]/.test(ch)) {
			curPunc = ch;
			return null;
		}
		if (/\d/.test(ch)) {
			stream.eatWhile(/[\w\.]/);
			return "number";
		}
		if (ch == "/") {
			if (stream.eat("*")) {
				state.tokenize = tokenComment;
				return tokenComment(stream, state);
			}
			if (stream.eat("/")) {
				stream.skipToEnd();
				return "comment";
			}
		}
		if (isOperatorChar.test(ch)) {
			stream.eatWhile(isOperatorChar);
			return "operator";
		}
		stream.eatWhile(/[\w\$_]/);
		var cur = stream.current();
		if (keywords.propertyIsEnumerable(cur)) {
			if (blockKeywords.propertyIsEnumerable(cur)) curPunc = "newstatement";
			return "keyword";
		}
		if (builtin.propertyIsEnumerable(cur)) {
			if (blockKeywords.propertyIsEnumerable(cur)) curPunc = "newstatement";
			return "builtin";
		}
		if (atoms.propertyIsEnumerable(cur)) return "atom";
		return "variable";
	}

	function tokenString(quote) {
		return function (stream, state) {
			var escaped = false, next, end = false;
			while ((next = stream.next()) != null) {
				if (next == quote && !escaped) { end = true; break; }
				escaped = !escaped && next == "\\";
			}
			if (end || !(escaped || multiLineStrings))
				state.tokenize = null;
			return "string";
		};
	}

	function tokenComment(stream, state) {
		var maybeEnd = false, ch;
		while (ch = stream.next()) {
			if (ch == "/" && maybeEnd) {
				state.tokenize = null;
				break;
			}
			maybeEnd = (ch == "*");
		}
		return "comment";
	}

	function Context(indented, column, type, align, prev) {
		this.indented = indented;
		this.column = column;
		this.type = type;
		this.align = align;
		this.prev = prev;
	}
	function pushContext(state, col, type) {
		var indent = state.indented;
		if (state.context && state.context.type == "statement")
			indent = state.context.indented;
		return state.context = new Context(indent, col, type, null, state.context);
	}
	function popContext(state) {
		var t = state.context.type;
		if (t == ")" || t == "]" || t == "}")
			state.indented = state.context.indented;
		return state.context = state.context.prev;
	}

	// Interface

	return {
		startState: function (basecolumn) {
			return {
				tokenize: null,
				context: new Context((basecolumn || 0) - indentUnit, 0, "top", false),
				indented: 0,
				startOfLine: true
			};
		},

		token: function (stream, state) {
			var ctx = state.context;
			if (stream.sol()) {
				if (ctx.align == null) ctx.align = false;
				state.indented = stream.indentation();
				state.startOfLine = true;
			}
			if (stream.eatSpace()) return null;
			curPunc = null;
			var style = (state.tokenize || tokenBase)(stream, state);
			if (style == "comment" || style == "meta") return style;
			if (ctx.align == null) ctx.align = true;

			if ((curPunc == ";" || curPunc == ":" || curPunc == ",") && ctx.type == "statement") popContext(state);
			else if (curPunc == "{") pushContext(state, stream.column(), "}");
			else if (curPunc == "[") pushContext(state, stream.column(), "]");
			else if (curPunc == "(") pushContext(state, stream.column(), ")");
			else if (curPunc == "}") {
				while (ctx.type == "statement") ctx = popContext(state);
				if (ctx.type == "}") ctx = popContext(state);
				while (ctx.type == "statement") ctx = popContext(state);
			}
			else if (curPunc == ctx.type) popContext(state);
			else if (((ctx.type == "}" || ctx.type == "top") && curPunc != ';') || (ctx.type == "statement" && curPunc == "newstatement"))
				pushContext(state, stream.column(), "statement");
			state.startOfLine = false;
			return style;
		},

		indent: function (state, textAfter) {
			if (state.tokenize != tokenBase && state.tokenize != null) return CodeMirror.Pass;
			var ctx = state.context, firstChar = textAfter && textAfter.charAt(0);
			if (ctx.type == "statement" && firstChar == "}") ctx = ctx.prev;
			var closing = firstChar == ctx.type;
			if (ctx.type == "statement") return ctx.indented + (firstChar == "{" ? 0 : statementIndentUnit);
			else if (ctx.align && (!dontAlignCalls || ctx.type != ")")) return ctx.column + (closing ? 0 : 1);
			else if (ctx.type == ")" && !closing) return ctx.indented + statementIndentUnit;
			else return ctx.indented + (closing ? 0 : indentUnit);
		},

		electricChars: "{}",
		blockCommentStart: "/*",
		blockCommentEnd: "*/",
		lineComment: "//",
		fold: "brace"
	};
});

(function () {
	function words(str) {
		var obj = {}, words = str.split(" ");
		for (var i = 0; i < words.length; ++i) obj[words[i]] = true;
		return obj;
	}
	var rustKeywords = "abstract async await become box break const continue crate do dyn else enum extern false fn for if impl in let loop macro match mod move mut pub ref return self Self static struct super trait true type union unsafe use where while yield";

	function rustHook(stream, state) {
		if (!state.startOfLine) return false;
		for (; ;) {
			if (stream.skipTo("\\")) {
				stream.next();
				if (stream.eol()) {
					state.tokenize = rustHook;
					break;
				}
			} else {
				stream.skipToEnd();
				state.tokenize = null;
				break;
			}
		}
		return "meta";
	}

	// Rust-style strings where "" escapes a quote.
	function tokenAtString(stream, state) {
		var next;
		while ((next = stream.next()) != null) {
			if (next == '"' && !stream.eat('"')) {
				state.tokenize = null;
				break;
			}
		}
		return "string";
	}

	function mimes(ms, mode) {
		for (var i = 0; i < ms.length; ++i) CodeMirror.defineMIME(ms[i], mode);
	}

	mimes(["text/x-rustsrc", "text/x-rust"], {
		name: "rust",
		keywords: words(rustKeywords),
		blockKeywords: words("enum struct"),
		atoms: words("true false None Some"),
		hooks: { "#": rustHook }
	});
}());
```

## 8. 测试运行

```bash
npm run dev
```
访问页面

```bash
 VITE v5.2.8  ready in 177 ms

  ➜  Local:   http://localhost:5173/  # 访问这个地址可以打开
  ➜  Network: use --host to expose
  ➜  press h + enter to show help
```

> 如果无法运行
> 报错：
> ```bash
>  [vite] Internal server error: Missing "./lib/codemirror.css" specifier in "codemirror" package
>  ```
>  检查 `paclage.json` 中的 ` "codemirror": "^5.65.16" ` 版本是否正确

![前端](https://www.caoyang2002.top/usr/uploads/2024/04/2369201853.png)

> 这时候点击 `执行` 会出错，因为还没写服务端

# 二、服务端（rust）

## 1. 安装 Rust（安装 Rust 时会默认安装 Cargo）

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

> 按照提示操作，选择默认选项安装即可。

## 2. Rust 环境

> 安装完成后，根据终端中的提示，运行以下命令将 Rust 工具链添加到您的 shell 环境中：

 ```bash
source $HOME/.cargo/env
```

## 3. 验证安装

> 在终端中运行以下命令来验证 Rust 和 Cargo 是否成功安装：

```bash
rustc --version # 或者 rustc -V
cargo --version   # 或者 cargo -V
```

> 查看帮助
> ```bash
> rustc --help
> cargo --help
> cargo run --help
> cargo build --help
> ```

## 4. 创建 Rust 项目

> 在您选择的目录中，打开终端。

创建一个新的 Rust 项目
```bash
cargo new rust_move_server  # rust_move_server 是项目的名称，它会创建一个该名称的文件夹作为项目根目录
``` 
{bs-accord style=line title=文件解析}
`Cargo.toml` 是 Rust 项目的配置文件，类似于其他语言中的 package.json 或者 requirements.txt。它用来指定项目的元数据、依赖项以及构建配置等信息。您可以在 Cargo.toml 中指定项目的名称、版本号、作者信息等，同时也可以列出项目的依赖项和构建脚本。

`src` 目录是 Rust 项目的源代码目录，其中包含了您编写的 Rust 源代码文件。通常情况下，Rust 项目的主要源代码文件会放在 src 目录下。您可以在 src 目录中创建 Rust 源代码文件（通常以 .rs 扩展名结尾），并在这些文件中编写 Rust 代码来实现项目的功能。

> 初始的 `src` 目录内包含一个 `main.rs` 文件
> ```rust
> fn main() {
>     println!("Hello, world!");
> }
> ```

{/bs-accord}


## 5. 进入项目目录

```bash
cd rust_move_server
```

> 进入您新创建的项目目录。

## 6. 构建项目

> 您新创建的项目目录内

```bash 
cargo build
``` 
> Cargo 将会自动下载和构建项目的依赖项，并生成可执行文件。

## 7. 运行项目

> 构建完成后，您可以在项目目录中找到生成的可执行文件。

执行项目

```bash
./target/debug/your_project_name
``` 

{bs-accord style=line title=构建同时运行}
```bash
cargo run
```
用于构建并运行 Rust 项目的可执行文件。它实际上是 `cargo build` 和执行生成的可执行文件的组合操作。

具体来说，`cargo run` 命令会执行以下操作：

1. **构建项目**：如果项目尚未构建，`cargo run` 会首先执行与 `cargo build` 相同的操作，即编译 Rust 项目的源代码并生成可执行文件。如果项目已经构建过，它会跳过这一步，除非代码或依赖项发生了变化。

2. **运行可执行文件**：一旦项目构建完成，`cargo run` 会自动在项目的 `target/debug` 目录中查找生成的可执行文件，并将其运行起来。如果项目是库项目而不是可执行文件项目，则 `cargo run` 不会执行任何操作，因为库项目没有可执行文件。

3. **传递参数**：`cargo run` 命令可以接受额外的参数，并将它们传递给生成的可执行文件。这些参数可以在执行可执行文件时使用，例如指定程序的运行配置或传递运行时参数。
{/bs-accord}


## 8. 写入 Rust 服务端代码

### 8.1 配置依赖项 `Cargo.toml`
```bash
[package]
name = "test_server"
version = "0.1.0"
edition = "2021"

# See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html

[dependencies]
actix-web = "4.0"
actix-cors = { version = "0.6.0-beta.10" }
```

### 8.2 写入Rust 代码

```bash
use actix_web::{web, App, HttpResponse, HttpServer, Responder};
use std::process::{Command, Stdio};
use std::fs;
use std::path::Path;
use std::str;
use actix_cors::Cors;

async fn compile_and_run_move(move_code: web::Bytes) -> impl Responder {
    println!("Received Move code: {:?}", move_code);
    // 创建临时文件目录
    let tmp_dir = "/tmp";
    if !Path::new(tmp_dir).exists() {
        fs::create_dir(tmp_dir).expect("Failed to create temporary directory");
    }

    // 将接收到的 Move 代码写入临时文件
    let tmp_file = "/Users/caoyang/Documents/Aptos/ts_playground/move_code/sources/test.move";
    fs::write(tmp_file, move_code).expect("写入文件：Failed to write Move code to file");

    // 编译 Move 代码
let compile_output = Command::new("aptos")
    .arg("move")
    .arg("test")
    .arg("--package-dir")
    .arg("/Users/caoyang/Documents/Aptos/ts_playground/move_code")
    .output()
    .expect("Failed to execute aptos move test command");

if !compile_output.status.success() {
    let stderr = str::from_utf8(&compile_output.stderr).unwrap_or("Error reading stderr");
    return HttpResponse::InternalServerError().body(format!("Move compilation failed: {}", stderr));
}

    // 将运行结果作为响应返回给客户端
    HttpResponse::Ok().body(String::from_utf8_lossy(&compile_output.stdout).to_string())
}


#[actix_web::main]
async fn main() -> std::io::Result<()> {
    // 启动服务器
    HttpServer::new(|| {
        App::new()
            // 添加CORS中间件
            .wrap(
                Cors::permissive() // <- 使用 Cors::permissive() 替换 Cors::new()
                    .allowed_origin("http://localhost:5173")
            )
            // 定义路由
            .route("/run_move", web::post().to(compile_and_run_move))
    })
    .bind("127.0.0.1:8081")?
    .run()
    .await
}
```

## 9. 发送 post 请求进行测试

```bash
 curl -X POST -d 'module 0x12::test{
  use std::debug::print;
  use std::string::utf8;
  #[test]
  fun test_server(){
    print(&utf8(b"server is running"));
  }
}' http://127.0.0.1:8081/run_move
```

## Rust 部分完成


# 三、move 临时代码

> 这个目录主要是用于存储前端的代码，然后执行这段代码，将结果返回给前端

- 先创建目录
```bash
mkdir move_code_tmp
cd move_code_tmp 
```
## 1. 初始化 Move 项目
```bash
aptos move init  --name move_code
```
> 这个命令会在当前目录下初始化一个 move 项目，不会新创建项目，
> 根据提示输入内容，或者直接回车
> 创建的 `Move.toml` 包含了程序的配置信息

返回结果

> ```bash
> caoyang@cccy move_code_tmp % aptos move init  --name move_code
> {
>  "Result": "Success"
> }
> ```

## 2. 初始化 aptos 账户
```bash
aptos init --network testnet
```
> 这个命令会在 `.aptos` 目录下创建一个  `config.yaml` 文件，这个文件包含了账户的所有信息

返回结果

> ```bash
> caoyang@cccy move_code_tmp % aptos init --network testnet
> Configuring for profile default
> Configuring for network Testnet
> Enter your private key as a hex literal (0x...) [Current: None | No input: Generate new key (or keep one if present)]
>  No key given, generating key...
>  Account 0x3846fb4052a41807816c58611911e913526e2370cd97a160025cc7dc670efeff doesn't exist, creating it and funding it with 100000000 Octas
>  Account 0x3846fb4052a41807816c58611911e913526e2370cd97a160025cc7dc670efeff funded successfully
>  ---
>  Aptos CLI is now set up for account 0x3846fb4052a41807816c58611911e913526e2370cd97a160025cc7dc670efeff as profile default!  Run `aptos --help` for more information about commands
>  {
>    "Result": "Success"
>    }


## 3. 创建临时 Move 代码文件 `temp.move`

> 用于临时存储前端发送的 Move 代码，并执行代码

### 3.1 输入一段 Move 代码

```move
module 0x42::test{
    use std::debug::print;
	  use std::string::utf8;
    #[test]
    fun test_my(){
        print(&utf8(b"server is running"));
    }
}
```

### 3.2 测试运行

```bash
aptos move test
```
返回的结果

>```bash
> caoyang@cccy move_code_tmp % aptos move test
> INCLUDING DEPENDENCY AptosFramework
> INCLUDING DEPENDENCY AptosStdlib
> INCLUDING DEPENDENCY MoveStdlib
> BUILDING move_code
> warning: unused alias
>   ┌─ /Users/caoyang/Documents/Aptos/del/move_code_tmp/sources/temp.move:2:21
>   │
> 2 │     use std::debug::print;
>   │                     ^^^^^ Unused 'use' of alias 'print'. Consider removing it    # 这是正常的，因为未使用
>
> warning: unused alias
>   ┌─ /Users/caoyang/Documents/Aptos/del/move_code_tmp/sources/temp.move:3:21
>   │
> 3 │       use std::string::utf8;
>   │                        ^^^^ Unused 'use' of alias 'utf8'. Consider removing it    # 这是正常的，因为未使用
>
> Running Move unit tests
> [debug] "server is running"   # 输出了源码中预期的结果
> [ PASS    ] 0x42::test::test_my
> Test result: OK. Total tests: 1; passed: 1; failed: 0
> {
>   "Result": "Success"
> }
> ```

## Move 部分完成

# 四、测试

> 输入以下代码后，点击 `执行`，等待一段时间后，可以看到执行结果区域有输出
```move
module 0x12::test{
  use std::debug::print;
  use std::string::utf8;
  #[test]
  fun test_server(){
    print(&utf8(b"server is running"));
  }
}
```

![](https://www.caoyang2002.top/usr/uploads/2024/04/2477546867.png)



# 五、目录结构

```bash
 tree -I 'node_modules|build|target' ./ 
 ```

```bash
caoyang@cccy ts_playground % tree -I 'node_modules|build|target' ./
./
├── move_code   # move 程序代码
│   ├── Move.toml  # 可以更换为国内源
│   ├── scripts
│   ├── sources
│   │   └── temp.move  # move 临时代码
│   └── tests
├── playground
│   ├── README.md
│   ├── codemirror.d.ts
│   ├── index.html
│   ├── package-lock.json
│   ├── package.json
│   ├── public
│   │   └── vite.svg # 这个可以删掉
│   ├── src
│   │   ├── App.tsx # 取消严格模式，防止渲染两个输入框
│   │   ├── assets
│   │   │   └── react.svg  # 这个可以删掉
│   │   ├── main.tsx
│   │   ├── move.js  # 高亮语法
│   │   ├── playground.tsx  # 文本编辑器
│   │   └── vite-env.d.ts
│   ├── tsconfig.json
│   ├── tsconfig.node.json
│   └── vite.config.ts
└── rust_move_server  # rust 服务端，用于接受 post 请求，并返回 move 的执行结果
    └── test_server
        ├── Cargo.lock
        ├── Cargo.toml  # 需要配置依赖项
        └── src
            └── main.rs # 服务端代码
```


# 附录
## playground
### package.json
```json
{
  "name": "playground",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "lint": "eslint . --ext ts,tsx --report-unused-disable-directives --max-warnings 0",
    "preview": "vite preview"
  },
  "dependencies": {
    "axios": "^1.6.8",
    "codemirror": "^5.65.16",
    "react": "^18.2.0",
    "react-codemirror2": "^7.3.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@types/codemirror": "^5.60.15",
    "@types/react": "^18.2.66",
    "@types/react-dom": "^18.2.22",
    "@typescript-eslint/eslint-plugin": "^7.2.0",
    "@typescript-eslint/parser": "^7.2.0",
    "@vitejs/plugin-react": "^4.2.1",
    "eslint": "^8.57.0",
    "eslint-plugin-react-hooks": "^4.6.0",
    "eslint-plugin-react-refresh": "^0.4.6",
    "typescript": "^5.2.2",
    "vite": "^5.2.0"
  }
}
```

## rust
### Cargo.toml
```toml
[package]
name = "rust_move_server"
version = "0.1.0"
edition = "2021"

# See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html

[dependencies]
actix-web = "4.0"
actix-cors = { version = "0.6.0-beta.10" }
```

## move
### Move.toml
```move
[package]
name = "move_code"
version = "1.0.0"
authors = []

[addresses]

[dev-addresses]

[dependencies.AptosFramework]
git = "https://github.com/aptos-labs/aptos-core.git"
rev = "mainnet"
subdir = "aptos-move/framework/aptos-framework"

[dev-dependencies]
```
