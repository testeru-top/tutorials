---
notebook: web_auto
title: 5.Selenium demo
tags: auto,ui
---
# idea导入依赖
```XML
<!--        web自动化-->
<dependency>
    <groupId>org.seleniumhq.selenium</groupId>
    <artifactId>selenium-java</artifactId>
    <version>4.0.0</version>
</dependency>
```
# 脚本自动化流程
编写脚本实现自动化：
## 1、启动浏览器

需要指定webdriver应用所在的路径，让idea能够找到它：

### 1、配置环境变量
### 2、在脚本中进行设置
## 2、访问被测网页    
## 3、定位元素并且操作它，将用例的每个步骤实现出来
## 4、预期结果断言

## 5、关闭浏览器

# 创建第一个自动化demo

## 1.启动浏览器
```java
//打开一个Chrome浏览器
WebDriver webDriver = new ChromeDriver();
//打开火狐浏览器
WebDriver driver = new FirefoxDriver();
```
- `webdriver`启动的浏览器默认是启动一个完全不带任何设置的干净的初始浏览器
- 启动`webdriver`浏览器的时候，会启动起来一个`chromedriver`的进程
## 2.在打开的浏览器上打开要被测的网站
```java
//在打开的浏览器(webDriver)上(.)打开(get方法)一个网站(URL)
webDriver.get("https://ceshiren.com/");
```
#### URL格式：
```
schema(http/https/ftp)://host[:port]/
```


- 直接复制浏览器地址栏的内容
## 3.编写对应基本操作
### 3.1 元素点击
```java
//在打开的网站上(webDriver)找到(find)一个'搜索'的元素(元素的定位符)
WebElement element = webDriver.findElement(By.cssSelector(".d-icon-search"));
//点击(click)搜索元素(element)
element.click();
```

### 3.2 元素输入
```java
//在打开的网站上(webDriver)找到(find)搜索输入框(元素的定位符)  By.id("search-term")
WebElement element1 = webDriver.findElement(By.id("search-term"));
//在搜索输入框(元素的定位符)内输入(sendKeys)搜索内容("selenium")
element1.sendKeys("selenium");
```

### 元素操作
- 对于元素的操作，实际上是对`Webelement`对象来完成操作，对于元素的动作都可以在其中来完成 

## 4.基本断言

#### 获取打开页面title进行断言

##### `getTitle`

```java
/**
 * 1.第一个业务逻辑：看看打开的网站是不是我想要的
 */
//拿到(get)打开浏览器(chromeDriver)的标题(title)
String title = chromeDriver.getTitle();
System.out.println(title);
//断言title
/**
 * Object expected, 期望内容
 * Object actual, 实际内容
 * String message  错误信息描述
 */
assertEquals("测试人",title,"对应的title文本内容不一致");


```

##### `assertEquals`

- 基本的`junit`断言

## 5.关闭浏览器

- `driver.quit()`

使用`driver.quit()` 关闭浏览器并且结束`chromedriver`的运行。
		如果想要杀死所有的`chromedriver.exe`? 

执行`cmd`命令`taskkill`。

## 完整demo
```java
@Test
void test(){
    //打开一个Chrome浏览器
    WebDriver webDriver = new ChromeDriver();
    //打开火狐浏览器
//        WebDriver driver = new FirefoxDriver();

    //在打开的浏览器(webDriver)上(.)打开(get方法)一个网站(URL)
    //URL格式：schema(http/https/ftp)://host[:port]/
    webDriver.get("https://ceshiren.com/");
//        webDriver.get("www.baidu.com");
    //在打开的网站上(webDriver)找到(find)一个'搜索'的元素(元素的定位符)
    WebElement element = webDriver.findElement(By.cssSelector(".d-icon-search"));
    //点击(click)搜索元素(element)
    element.click();
    //在打开的网站上(webDriver)找到(find)搜索输入框(元素的定位符)  By.id("search-term")
    WebElement element1 = webDriver.findElement(By.id("search-term"));
    //在搜索输入框(元素的定位符)内输入(sendKeys)搜索内容("selenium")
    element1.sendKeys("selenium");
}
```


# 常见异常
## 没找到webdriver

```
Exception in thread "main" java.lang.IllegalStateException: The path to the driver executable must be set by the webdriver.chrome.driver system property;
```

- 未指定`webdriver`应用的路径。



## URL格式不对报错

- 非法参数：`url`填写错误 `org.openqa.selenium.InvalidArgumentException: invalid argument`


![](https://gitee.com/datau001/picgo/raw/master/images/202112071054400.png)

## 元素没在页面上


	Exception in thread "main" org.openqa.selenium.StaleElementReferenceException: stale element reference: element is not attached to the page document
- 元素已经没有在页面上了
- 通常由于页面出现了刷新，导致之前的元素已经消失了，可以重新定位一下
- 也有可能是因为等待时间不够


# Chromedriver扩展
https://chromedriver.chromium.org/capabilities

##  `ChromeOptions`
- 使用`ChromeOptions`类。`Java`、`Python` 等都支持这一点。

- 使用`DesiredCapabilities`类。这被 `P​​ython`、`Ruby` 等支持。虽然它在 `Java` 中也可用，但它在 `Java` 中的使用已被弃用。

- 设置 `ChromeDriver` 特定功能的便捷方法
- 可以将`ChromeOptions`对象传递给 `ChromeDriver` 构造函数

```java
ChromeOptions options = new ChromeOptions();

options.addExtensions( new File(" /path/to/extension.crx "));

ChromeDriver driver = new ChromeDriver(options);
```

## 阻止弹出窗口
默认情况下，`ChromeDriver` 将 `Chrome` 配置为允许弹出窗口。如果要阻止弹出窗口（即在不受 `ChromeDriver` 控制时恢复正常的 `Chrome` 行为），请执行以下操作：
```java
ChromeOptions options = new ChromeOptions();

options.setExperimentalOption("excludeSwitches",

     Arrays.asList("disable-popup-blocking"));
```

