---
title: 创建一个 SpringBoot 项目
---
# 环境

- JDK 17
- Java 17
- Spring 3.3.1

# 配置

- Spring Web
- Mybatis framework
- MySQL Deiver

没有mysql，则需要先[[../../SQL/mysql_install_and _collocate]]

```bash title="apolication.properties"
# 你的项目名称，这里spring会自动给你配置好
spring.application.name=your_application_name 
# 应用服务器端口号  
server.port=8000  
# 以下内容是为了让 MyBatis 正常工作  
# 指定 Mybatis 的 Mapper 文件位置  
mybatis.mapper-locations=classpath:mappers/*.xml  
# 指定 Mybatis 的模型别名包  
mybatis.type-aliases-package=com.caoyang2002.jobandhunter.mybatis.entity  
spring.datasource.username=root  
spring.datasource.password=your_password 
spring.datasource.url=jdbc:mysql://127.0.0.1:3306/jobandhunter?autoReconnect=true&useUnicode=true&characterEncoding=utf8&serverTimezone=GMT%2B8 
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```

# 运行

```bash
mvn spring-boot:run
```


> MyBatis 提供的是一个映射


# 配置

> 需要配置的地方：
> MyBatis 这是一个 mapper
## 创建配置类

```bash
com.xxx.your_application_name.config
```

> 这里面可以放一些其他的配置，例如字符验证、Mybatis、Knif4j等
> 





