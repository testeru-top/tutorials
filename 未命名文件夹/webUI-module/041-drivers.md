---
notebook: web_auto
title: 4.多浏览器的自动化环境
tags: auto,ui
---



# `webdriver`
版本适配：`webdriver`和浏览器是有强版本适配的，`selenium`的`jar`包没有关系。

# 脚本中`webdriver`
1、可以配置系统环境变量的`path`，让系统自动能找到。
2、脚本中设置临时环境变量，告诉脚本去哪找。
```
建议可以把driver都复制到项目中去，用项目相对路径，这样，方便于项目移植。
```
## `close()` && `quit()`
注意：`driver.close()`方法和`driver.quit()`方法的区别，记得调用`quit`关闭`driver`进程。
```java
//关闭webdriver的应用进程，并且关闭浏览器。
 web_driver.quit();
//关闭当前的窗口，如果只有一个窗口那么会把浏览器也关闭，注意！不会关闭driver。
 web_driver.close();
```

# 各个浏览器不同的`webdriver`
- `Chrome`浏览器和IE浏览器通常会自动安装在默认位置，不需要指定浏览器启动路径。
- `Firefox`浏览器通过`System.setProperty(“webdriver.firefox.bin”, “火狐安装路径”);`进行指定
# 多浏览器共用

```java
package com.tester.ceshiren;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.ie.InternetExplorerDriver;
import org.openqa.selenium.safari.SafariDriver;

import java.time.Duration;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.containsString;

/**
 * @program: web_ui
 * @author: testeru.top
 * @description:多浏览器共用
 * @create: 2021-11-04 10:43
 */
public class SearchDriversTest {
    static WebDriver driver;

    @BeforeAll
    public static void beforeAll(){
//        String browser = System.getenv("browser");
        String browser = "c";

        openBrowser(browser);
        //selenium3与4版本之间参数不一样
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(5));
    }



    @Test
    void search() {
        driver.get("https://ceshiren.com/");
        driver.findElement(By.id("search-button")).click();
        driver.findElement(By.id("search-term")).sendKeys("selenium" + Keys.ENTER);
        String real = driver.findElement(By.cssSelector(".topic-title")).getText();
        assertThat(real, containsString("selenium"));
    }


    private static void openBrowser(String browser) {
        switch (browser){
            case "firefox":
                System.setProperty(
                        "webdriver.chrome.driver",
                        "/Users/gaigai/firefoxdriver"
                );
                driver = new FirefoxDriver();
                break;
            case "ie":
                System.setProperty(
                        "webdriver.chrome.driver",
                        "/Users/gaigai/iedriver"
                );
                driver = new InternetExplorerDriver();
                break;
            case "sa":
                System.setProperty(
                        "webdriver.chrome.driver",
                        "/Users/gaigai/sadriver"
                );
                driver = new SafariDriver();
                break;
            default:
                System.setProperty(
                        "webdriver.chrome.driver",
                        "/Users/gaigai/chromedriver"
                );
                driver = new ChromeDriver();
        }
    }
}
```
# `Chrome`
[chrome下载](https://www.chromedownloads.net/)

- chromedriver不分32和64位系统，下win32的用就行。


在自己封装的driver里面，通过chromeoptions --user-data-dir chrome设置用户目录。

用户目录的位置：可以在chrome地址栏输入chrome://version 找个人资料路径，复制default之前的路径就可以。

另外如果用了用户文件，注意，设置一下chrome的搜索引擎，别用google，用百度。
同时跑自动化的时候不能开手动的浏览器，因为用户文件同时只能一个人用。

## 问题汇总

### 1.`Chrome`浏览器驱动路径

- 使用`Chrome`浏览器做测试的时候,报错:
```
java.lang.IllegalStateException: The path to the driver executable must be set by the webdriver.chrome.driver system property; 
```
#### 原因

`chrome`对应的`driver`不存在

#### 解决方案

- 1.下载对应版本的`chromedriver`

[chromedriver官网地址](https://sites.google.com/a/chromium.org/chromedriver/downloads)

[chromedriver镜像地址](https://npm.taobao.org/mirrors/chromedriver)
- 2.系统设置`Chrome`驱动文件的路径
```java
System.setProperty(
        "webdriver.chrome.driver",
        "/Users/gaigai/chromedriver"
);
```
### 2.Chrome浏览器与chromedriver匹配问题
使用chrome浏览器去完成自动化测试的时候,chrome浏览器停止运行
```
chromedriver已停止工作
```
原因:
- 对应chrome浏览器版本过高引起的,根据官网信息,看下对应chromedriver驱动支持的浏览器版本号

```java
package com.tester.ceshiren;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.chrome.ChromeDriver;

import java.time.Duration;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.containsString;

/**
 * @program: study_demo
 * @author: testeru.top
 * @description: selenium4
 * @create: 2021-10-31 11:36
 */
public class SearchTest {
    @Test
    void search() {
        //不建议使用这种方式，推荐使用环境变量
//        System.setProperty(
//                "webdriver.chrome.driver",
//                "/Users/seveniruby/projects/chromedriver/chromedrivers/chromedriver_95.0.4638.54/chromedriver"
//        );
        ChromeDriver driver = new ChromeDriver();
        //selenium3与4版本之间参数不一样
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(5));

        driver.get("https://ceshiren.com/");
        driver.findElement(By.id("search-button")).click();
        driver.findElement(By.id("search-term")).sendKeys("selenium" + Keys.ENTER);
        String real = driver.findElement(By.cssSelector(".topic-title")).getText();
        assertThat(real, containsString("selenium"));
    }
}

```
## 浏览器的复用
打开Chrome的debug模式
- 打开浏览器之前要关闭所有的`chrome`浏览器


Mac下配置Chrome浏览器的环境变量:
- 然后双击Google Chrome确实可以打开浏览器
- 所以Chrome浏览器执行文件路径在：`/Applications/Google\ Chrome.app/Contents/MacOS/目录下`

```
#将Google Chrome添加到环境变量中
export PATH=$PATH:/Applications/Google\ Chrome.app/Contents/MacOS

#给命令Google\ Chrome起别名chrome
alias chrome="Google\ Chrome"
```
对应source使环境变量生效
##### 命令行启动监听
```shell
chrome --remote-debugging-port=9222
#chrome为自己定义的环境变量名称

#如果不配置环境变量可以直接使用文件路径代替
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222
```

# `Firefox`

## 问题汇总

### 1.`Firefox`路径问题
`firefox`火狐浏览器去完成自动化测试的时候,代码报错
```
org.openqa.selenium.WebDriverException: Cannot find firefox binary in PATH. Make sure firefox is installed. OS appears to be: WIN8
```
#### 原因
`firefox` 必须安装在默认位置，如 ->`c:/Program Files (x86)/mozilla firefox OR c:/Program Files/mozilla firefox`

- 注意：在安装 `firefox` 时不要更改路径，所以让它在默认路径中安装）;如果 `firefox` 安装在其他地方，则 `selenium` 会显示这些错误。

#### 解决方案

- 在 `Systems(Windows)` 环境变量中设置了 `Firefox`，则将其删除或使用新的 `Firefox` 版本路径更新它。
- 设置全局属性`webdriver.firefox.bin`,让脚本知道`firefox`可执行文件在哪里

- 如果想在任何其他地方使用 `Firefox`，请使用以下代码

```java
//webdriver.firefox.bin
//System.setProperty("webdriver.firefox.bin","D:\\Program Files\\Mozilla Firefox\\firefox.exe");
System.setProperty("webdriver.gecko.driver","D:\\Workspace\\demoproject\\src\\lib\\geckodriver.exe");
File pathBinary = new File("C:\\Program Files\\Mozilla Firefox\\firefox.exe");
FirefoxBinary firefoxBinary = new FirefoxBinary(pathBinary);   
DesiredCapabilities desired = DesiredCapabilities.firefox();
FirefoxOptions options = new FirefoxOptions();
desired.setCapability(FirefoxOptions.FIREFOX_OPTIONS, options.setBinary(firefoxBinary));
WebDriver driver = new FirefoxDriver(options);
driver.get("https://www.google.co.in/");
```
[geckodriver下载](https://github.com/mozilla/geckodriver/releases)

### 2.`Selenium3.*` `Firefox`驱动问题
代码报错
```
Exception in thread "main" java.lang.IllegalStateException: The path to the driver executable must be set by the webdriver.gecko.driver system property; for more information, see https://github.com/mozilla/geckodriver. The latest version can be downloaded from https://github.com/mozilla/geckodriver/releases


```
#### 原因
缺少火狐浏览器驱动包
#### 解决办法
- 项目中添加火狐驱动包,加载驱动的配置
- 驱动版本适配的浏览器和`selenium`版本在驱动的`change log`里有说明

代码示例:
```java
System.setProperty("webdriver.gecko.driver","D:\\Workspace\\demoproject\\src\\lib\\geckodriver.exe");
```

# `IEDriver`
1、IE选项里面的安全的各个区域的保护模式一致。
2、缩放选项必须是100%。
3、IE10以上的版本有可能需要刷注册表，如果运行的时候出现异常或者打开浏览器不进行后续操作，用IE驱动有问题时用的注册表文件.reg注册表文件，双击运行一下。没问题就不要刷！！！！

## 问题汇总

### 1.`IE`浏览器驱动问题
使用`IE`浏览器完成自动化测试,代码报错:
```
The path to the driver executable must be set by the webdriver.ie.driver system property; for more information, 
```
#### 原因
缺少`IE`浏览器驱动包
#### 解决方案
往项目中添加`IE`驱动包,并加载驱动配置
```java
System.setProperty("webdriver.chrome.driver","C:\\Users\\vthaduri\\workspace\\LDCSuite\\IEDriverServer.exe");
```

- `IE`驱动版本与`Selenium`版本保持相同就可以
{建议下载版本3.7}
[下载地址](https://selenium-release.storage.googleapis.com/index.html?path=3.7/)

![](https://gitee.com/testeru/pichub/raw/master/images/202111031714768.png)

2.IE浏览器保护模式问题
使用IE浏览器去完成自动化测试,代码报错
```
Unexpected error launching Internet Explorer. Protected Mode settings are not the same for all zones
```
解决方案
- 1.浏览器设置(换电脑不适用)
打开IE浏览器 -- 工具 -- 安全 -- 全部勾选启用保护模式
![](https://gitee.com/testeru/pichub/raw/master/images/202111032139329.png)
- 2.忽略浏览器保护模式的设置InternetExplorerDriver.INTRODUCE_FLAKINESS_BY_IGNORING_SECURITY_DOMAINS代码
```java
DesiredCapabilities ieCapabilities = DesiredCapabilities.internetExplorer();		
ieCapabilities.setCapability("unexpectedAlertBehaviour" , "ignore");
//ieCapabilities.setCapability("enablePersistentHover", true);
//TM:22/01/2014- Added following for GAIC
ieCapabilities
.setCapability(
        InternetExplorerDriver.INTRODUCE_FLAKINESS_BY_IGNORING_SECURITY_DOMAINS,
        true);
```

https://cran.r-project.org/web/packages/RSelenium/vignettes/internetexplorer.html

# driver声明
```
new ChromeDriver()
```
- 1.打开驱动
- 2.打开对应浏览器