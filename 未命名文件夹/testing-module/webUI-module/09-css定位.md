---
notebook:  ui_base
title: css定位
tags: auto
---
# css定位
- 不能代替link_text(link_text是根据text定位)
- 层叠样式表
- 描述了如何在屏幕或其他媒体上显示的HTML元素
- 节省了大量工作，可以同时控制多个页面布局
- 外部样式表存储在css文件中
  
## 基础语法
### id
- `#id的值`
```
#username

<input type="text" class="s_ipt" name="wd" id="kw" maxlength="100" autocomplete="off">

[id=kw]
[id~=kw]
```


### class
- `.class的值`
```
.
```
### tag
- 标签名
```

```
### 组合
- `tagName#id_value.class_value1.class_value2`
```
input#username.class_Value
```

- `ins+script`
  - 同等级相加，找➕后面的那个
  ![](https://gitee.com/datau001/picgo/raw/master/images/202112081628933.png)



## CSS属性

#### [属性名=属性值]

#### [属性名~=属性值]

- 包含

### 模糊

#### [属性名^=属性值]
- 开头是
```
input[name^='username']
```
#### [属性名$=属性值]
- 结尾
```
input[name$='ername']
```
#### [属性名*=属性值]
- 包含

```
input[name*='erna']
```
### 第一个元素
#### `:first-child`
```
p:first-child
```
- 父标签下的第一个标签是p的元素

### 第几个元素
#### `tagname:nth-child(n)`
```
body>div:nth-child(3)
```
- body下第三个标签是div「不是第三个div」


```
父节点下的第二个元素是input
input:nth-child(2)
```
### 最后一个
#### `:last-child`
```
body>:last-child
```
- body标签下的最后一个标签


```
em:last-child
```
- em是父节点下的最后一个元素
### 倒数第几个元素
#### `:nth-last-child(n)`

```
body>div:nth-last-child(4)
```
- body下的倒数第4个标签是div「不是第4个div」

```
em:nth-last-child(1)
```
- em是父节点下的最后一个元素
```
input:nth-last-child(2)
```
- 父节点下的倒数第2个标签是 input「不是第2个input」

# class='a1 a2 a3 a4'

##### className定位的时候只能写一个

- 要写多个

```
a1.a2.a3.a4
```



##### xpath的时候都能写
##### css可以写一个或多个，如果是多个前面需要加`.`

```
.a1.a2.a3.a4
```



##### css的class语法是
- `.class_value1`

# 元素定位互相转换
## id-xpth-css
```java
//<input type="text" class="s_ipt" name="wd" id="kw" maxlength="100" autocomplete="off">

WebElement kw = webDriver.findElement(By.id("kw"));

WebElement element = webDriver.findElement(By.xpath("//*[@id='kw']"));

WebElement kw1 = webDriver.findElement(By.cssSelector("#kw"));
WebElement element1 = webDriver.findElement(By.cssSelector("[id='kw']"));
```

## name-xpth-css

```java
//<input type="text" class="s_ipt" name="wd" id="kw" maxlength="100" autocomplete="off">

WebElement wd = webDriver.findElement(By.name("wd"));

WebElement xelement = webDriver.findElement(By.xpath("//*[@name='wd']"));

WebElement element = webDriver.findElement(By.cssSelector("[name='wd']"));
```

