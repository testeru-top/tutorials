---
notebook: web_auto
title: 10. Webdriver操作
tags: auto,ui
---
# 
|方法名|说明|
|---|---|
|`void get(String url)`|打开指定URL|
|`back`|浏览器后退|
|`close`|关闭tab页面，不主动关闭driver进程|
|`quit`|退出浏览器，关闭driver进程|
|`String getCurrentUrl()`|获取当前的URL地址|
|`execute_script`|执行js脚本|
|`forward`|前进|
|`fullscreen_window`|全屏|
|`get_window_position`|获取当前窗口位置|
|get_window_rect|获取当前创建的矩形|
|get_window_size|获取当前浏览器窗口大小|
|Maximize_window|浏览器窗口最大化|
|Minimize_window|浏览器窗口最小化|
|Name|获取浏览器的名字|
|page_source|获取页面源代码|
|refresh|刷新界面|
|save_screenshot|保存洁面截图，建议png|

### 打开指定`URL`
```java
void get(String url);
```
- 在当前浏览器窗口中加载一个新网页

- 使用 `HTTP POST` 发送请求
  - 该方法将阻塞直到加载完成 
  - 或超过服务器的超时时间

- 参数：`url` 
  - 要加载的 `URL`
  - 必须是完全限定的 `URL`

```java
driver.get("http://8.129.212.238/login");
```
### 获取当前的URL地址
```java
String getCurrentUrl();
```
- 只获取当前浏览器第一个标签的URL


```java
String currentUrl = webDriver.getCurrentUrl();
System.out.println(currentUrl);
```
![](https://gitee.com/datau001/picgo/raw/master/images/202112072144112.png)


### 获取当前页面的标题
```java
String getTitle();
```
- 当前页面的标题，去掉前导和尾随空格
- 如果未设置，则为` null `
- head中的title用该方法获取