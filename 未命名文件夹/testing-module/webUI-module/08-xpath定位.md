---
notebook:  ui_base
title: xpath定位
tags: auto
---
# xpath定位
## 什么是xpath
- xpath 在XML中查找信息的语言
- 在XML文档中对元素和属性进行遍历
- xpath使用路径表达式在XML文档中进行导航
- 包含一个标准函数库，是一个W3C标准
- `xpath`其实就是一个`path`「路径」,一个描述元素位置信息的路径,相当于元素的坐标
- `xpath`基于`XML`文档树状结构,是`XML`路径语言,用来查询`XML`文档中的节点
## 一般语法

### 绝对路径
- 从根开始查找
#### 表达式
- `/`「根路径」
```java
//百度搜索页面:
/html/body/div[1]/div[2]/div[5]/div[1]/div/form/span[1]/input
```
#### 描述
- 绝对路径以单个`/`表示,而且是让解析引擎从文档的根节点开始,也就是`html`这个节点下开始解析，**逐级往下**
- 对应层级不跳跃
#### 下标区分元素
- 第一个元素的下标是1不是0
##### `[1]`
  - 上级节点下的第一个div元素

#### 缺点

- 一旦页面结构发生变化,「重新设计/路径减少」这个路径也就失效了,必须重新写
- 不是因为太长，是因为受其他元素影响，关联性太强

### 相对路径
- 只要不是`/`开头的就是相对路径

#### 表达式
- `//`
  - 表示让`xpath`从文档中**任意符合元素节点**开始进行解析
```
//*

//span

//*[@id="ember62"]/td[1]
//*[@name='wd']

//input[@name='wd']

//input[last()]
//*[@id="ember62"]/td[last()]

//*[@id="ember62"]/td[last()-1]

//*[@id="ember62"]/td[position()<3]
```

#### 基本描述

##### `//`
- 匹配指定节点
##### `*`
- 通配符,匹配任意元素节点
##### `@`
- 选取属性
##### `[]`
- 属性判断条件表达式
##### `last()`
- 上级节点下的最后一个标签
#### 使用  
##### `//*`
- 所有标签

##### `//span`
- 通过元素名定位
- 所有`span`标签


```java
//input
获取页面所有input元素
```
##### `//*[@id="ember62"]`
```
[@属性名='属性值']
```
- 使用元素名+属性
- 结合路径法
- 任意属性都支持


```java
//*[@id='phone']

容易重复的属性建议缩小搜索范围
//input[@name='phone']

<input type="submit" value="百度一下" id="su" class="btn self-btn bg s_btn">

//input[@class='btn self-btn bg s_btn']


<span class="s-menu-item" data-id="1">导航<span class="s-menu-item-underline"></span></span>

所有元素都可以用
//span[@data-id='1']

/html//span[@data-id='1']

运算符
//*[@height='16']
```
##### `[1]`
- 通过元素名+索引定位
- `id="ember62"`下的第一个td标签

```
//*[@id="ember62"]/td[1]
```

```java
//form/div[1]/input

获取手机号输入框
```

##### `[last()]`

- `id="ember62"`下的最后一个td标签

```
//*[@id="ember62"]/td[last()]
```
- 只有1个的情况下也是最后一个

##### `[last()-1]`

- `id="ember62"`下的倒数第2个`td`标签

```
//*[@id="ember62"]/td[last()-1]
```

##### `[position()<3]`

- `id="ember62"`下的前2个`td`标签

```
//*[@id="ember62"]/td[position()<3]
```

#### 优点
- 灵活,方便,耦合性低

### 特殊符号

#### 表达式
- `.`
- `..`

##### `.`
- 当前节点
- 一般不用

##### `..`

- 父节点
```java
//*[@id="ember62"]/..
找id="ember62"的父节点元素
```
- 子代元素可明显、快速定位，且父代元素无明显特征



#### xpath可覆盖的基本定位
- id
- class
- name
- tagName

## 函数法

xpath函数

### `starts-with(@属性名,'属性开头的值')`

- `start`有个`s`

```java
//<input type="text" class="s_ipt" name="wd" id="kw" maxlength="100" autocomplete="off">
//百度首页搜索
WebElement element1 = webDriver.findElement(By.xpath("//*[starts-with(@id,'k')]"));
```

### `contains(@属性名,'属性包含的值')`
```java
//*[contains(@name,'phone')]
```
- `contain`有个`s`
- 使用元素(html元素-->标签)名+包含部分属性值

```java
WebElement element2 = webDriver.findElement(By.xpath("//*[contains(@name,'usern')]"));
```

### ends-with()

- Xpath 有但是selenium没有

### `text()='文本的值'`

```java
//*[@text()='免费注册']

//a[text()='抗击肺炎']
```

- 替代`By.linkText("")`
- 使用元素名+元素的文本内容


```java
//<a href="http://www.baidu.com/more/" name="tj_briicon" class="s-bri c-font-normal c-color-t" target="_blank">更多</a>
//<a href="http://www.baidu.com/more/" class="s-tab-item s-tab-more">更多</a>
//百度搜索页面，有2个更多，需要点击最后一个
List<WebElement> elements = webDriver.findElements(By.xpath("//*[text()='更多']"));
System.out.println(elements.size());

WebElement more = elements.get(1);
more.click();
```





### `contains(text(),'文本包含的值')`
```java
//*[contains(text(),'免费')]

//a[contains(text(),'肺炎')]

//input[contains(@type,'submi')]
```

- 替代`By.partialLinkText("")`

- 使用元素名+包含元素的部分文本内容



## `Xpath` 轴定位
- 当某个元素的各个属性及其组合都不足定位的时候,可以利用兄弟节点或父节点等各种可以定位的元素进行定位

|轴名称|备注|
|---|---|
|`ancestor`|当前节点的所有祖先节点|
|`parent`|当前节点的父节点|
|`preceding`|当前节点之前的所有节点|
|`preceding-sibling`|当前节点之前的所有兄弟节点|
|`following`|当前节点后的所有节点|
|`following-sibling`|当前节点后的所有兄弟节点|

### 使用语法:
`/轴名称::节点名称[@属性=值]`


- 当前节点xpath定位表达式/轴名称::二次定位的元素


### 使用
#### `ancestor`
```java
//input[1]/ancestor::*

//div[@id='div1']/ancestor::div
找id='div1'的所有先辈（父节点）div
```
- 儿子有明显特征，找它的上代
- 上代本身没有可定位的属性
#### `following`
```
//div[@id='div1']/following::*
```
#### `following-sibling`
//input[1]/ancestor::div

//input[1]/ancestor-or-self::*
//input[1]/attribute::id

//input[1]/attribute::value

//input[1]/attribute::*

//div[@id='div1']/child::*

//div[@id='div1']/descendant::*

//div[@id='div1']/descendant-or-self::*



## 逻辑运算符

### `and`

- 多个属性拼接
```java
//input[@name='wd' and @autocomplete='off']
```

### `or`

- 一般不用or来扩大元素范围
