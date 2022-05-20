---
notebook: web_auto
title: 3.selenium介绍
tags: auto,ui
---
# `selenium`介绍
`Selenium` 是支持 `web` 浏览器自动化的一系列工具和库的综合项目。 

它提供了扩展来模拟用户与浏览器的交互，用于扩展浏览器分配的分发服务器， 以及用于实现 `W3C WebDriver` 规范 的基础结构， 该 规范 允许您为所有主要 `Web` 浏览器编写可互换的代码。


[selenium官网](https://www.selenium.dev/)

[selenium中文说明文档](https://www.selenium.dev/zh-cn/documentation/)
    

[selenium组件下载](https://www.selenium.dev/downloads/)

[selenium镜像](https://npm.taobao.org/mirrors/selenium)

## Selenium 三大组成部分
#### selenium WebDriver
进行UI自动化依赖的框架

如果你想创建健壮的、基于浏览器的回归自动化套件和测试，在许多环境中扩展和分发脚本，那么你想使用 Selenium WebDriver，一个特定于语言的绑定集合来驱动浏览器——它应该是这样的驱动。


#### selenium IDE
浏览器内插件，可以进行UI自动化录制
- 弊端：一个元素出现了，但是不能被点击，如果强行用sleep，无法掌握这个时间，sleep(1)时可能这个元素在红色线出现时间超过1s




#### selenium Gird
- 分布式UI自动化框架;
- 如果您想通过在多台机器上分发和运行测试来扩展，并从一个中心点管理多个环境，从而可以轻松地针对浏览器/操作系统的大量组合运行测试，那么您需要使用 Selenium Grid




### driver驱动原理
driver会将对应的浏览器绑定在特定端口启动，并作为一个服务器监听来自于测试脚本的命令，selenium测试脚本通过调用该服务操作本机安装的相应的浏览器。


## 环境
```XML
<properties>
    ...
    <!-- 尽可能使用最新版本 -->
    <selenium.version>4.0.0</selenium.version>
    ...
</properties>

<dependencies>
    ...
    <dependency>
        <groupId>org.seleniumhq.selenium</groupId>
        <artifactId>selenium-java</artifactId>
        <version>${selenium.version}</version>
    </dependency>

    ...
</dependencies>
```
### Webdriver
Webdriver驱动原理：Webdriver会将对应的浏览器绑定在特定端口启动，并作为一个服务器监听来自于测试脚本的命令，selenium测试脚本通过调用该服务操作本机安装的相应的浏览器。

webdriver启动的时候，默认不带任何用户配置，启动一个崭新的浏览器。
selenium 3.0 就是优化了各种方法和开发各种需求。



接口
- postman jmeter 可以迭代更新
自动化测试
- 回归性测试,冒烟测试  --- 提高测试效率






# Selenium原理
## selenium架构图

![](https://gitee.com/datau001/picgo/raw/master/images/202112061133469.png)

## WebDriver原理

- 每个Selenium脚本，会创建并发送一个http请求给浏览器的驱动
- 浏览器驱动中包含了一个HTTP Server，用来接收发送的http请求
- HTTP Server 接收请求后根据请求来具体操作浏览器
