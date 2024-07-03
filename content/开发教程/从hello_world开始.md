---
title: 从 hello_world 开始
---
> 建议使用 Linux & Mac

# 写一个 hello world 程序

1. 创建一个目录

    ```bash
    mkdir hello_world
    ```

2. 初始化项目结构为 move 结构

    ```bash
    aptos mvoe init --name hello_move
    #  --name <NAME>       Name of the new Move package
    # 这里的 --name 会作为配置文件中的 name 名称
    ```

    > - 返回的结果
    >
    > ```move
    > {
    > "Result": "Success"
    > }
    > ```
    > - Move 程序的配置文件
    >
    > ```toml
    > caoyang@cccy hello_world % cat Move.toml 
    > 
    > [package]
    > name = "hello_move"
    > version = "1.0.0"
    > authors = []
    > 
    > [addresses]
    > 
    > [dev-addresses]
    > 
    > [dependencies.AptosFramework]
    > git = "https://github.com/aptos-labs/aptos-core.git"
    > rev = "mainnet"
    > subdir = "aptos-move/framework/aptos-framework"
    > 
    > [dev-dependencies]
    > ``` 

3. 初始化 aptos 账户

    ```bash
    aptos init --network testnet # 选择测试网
    ```

    >- 选择
    >
    >```bash
    >caoyang@cccy hello_world % aptos init --network testnet
    >
    >Configuring for profile default
    >Configuring for network Testnet
    >Enter your private key as a hex literal (0x...) [Current: None | No input: Generate new key (or keep one if present)]
    ># 按回车键
    >No key given, generating key...
    >
    >Account 0x869babd17f0891d535f25fb6e407cc3dc53e2744538ab959f04b799bc83a59d9 doesn't exist, creating it and funding it with 100000000 Octas
    >Account 0x869babd17f0891d535f25fb6e407cc3dc53e2744538ab959f04b799bc83a59d9 funded successfully
    >
    >---
    >Aptos CLI is now set up for account 0x869babd17f0891d535f25fb6e407cc3dc53e2744538ab959f04b799bc83a59d9 as profile default!  Run `aptos --help` for more information about commands
    >```
    >
    >- 返回结果
    >
    >```json
    >{
    >  "Result": "Success"
    >}
    >```

4. 写入程序代码

    ```bash
    cd sources 
    # 可以使用任何编辑软件写入
    # vim hello_move.move 
    ```

    - 写入

        ```move
        module 0x42::hello {
            #[test_only]
            use std::string;
            #[test_only]
            use std::debug::print;
        
            #[test]
            fun test() {
                let hello = string::utf8(b"hello_world");
                print(&hello);
            }
        }
        ```
    
    - 测试
      
        > ```json
        > caoyang@cccy hello_world % aptos move test
        > INCLUDING DEPENDENCY AptosFramework
        > INCLUDING DEPENDENCY AptosStdlib
        > INCLUDING DEPENDENCY MoveStdlib
        > BUILDING hello_move
        > Running Move unit tests
        > [debug] "hello_world"
        > [ PASS    ] 0x42::hello::test
        > Test result: OK. Total tests: 1; passed: 1; failed: 0
        > {
        >   "Result": "Success"
        > }
        > ```





> 可能遇到的问题：
> 
>- 网络问题
>
> ```json
>caoyang@cccy sources % aptos move test
> {
>   "Error": "Unexpected error: Failed to run tests: Unable to resolve packages for package 'hello_move': While resolving dependency 'AptosFramework' in package 'hello_move': Failed to fetch to latest Git state for package 'AptosFramework', to skip set --skip-fetch-latest-git-deps | Exit status: exit status: 128"
> }
> ```
> 
> 解决方法：
>
> 1. 切换为能访问 GitHub 的网络
>
>     自行修改
>
> 2. 修改 `Move.toml` 中的 GitHub 官方地址为 Gitee 地址
>
>     ```toml
>    [dependencies.AptosFramework]
>     # git = "https://github.com/aptos-labs/aptos-core.git"
>     git = "https://gitee.com/WGB5445/aptos-core.git"
>     rev = "mainnet"
>     subdir = "aptos-move/framework/aptos-framework"
>    ```



