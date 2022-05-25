---
notebook: web_auto
title: 10. WebElement 操作
tags: auto,ui
---
#### 元素点击
- 如果这会加载新页面，则应放弃对此元素的所有引用
  - 对该元素执行的任何进一步操作都将引发 `StaleElementReferenceException`
- 单击元素先决条件：
  - 该元素必须是可见的，并且它的**高度**和**宽度**必须大于 0
- `click()` 通过发送本机事件完成
  - 该方法不等待下一页加载，代码自行验证
```java
element.click();
```
#### 元素输入
- 元素内追加输入

keysToSend – 发送到元素的字符序列
抛出：
IllegalArgumentException – 如果 keysToSend 为 null 
```java
element.sendKeys("selenium");
```


#### 该元素内容清空

如果此元素是表单条目元素，这将重置其值。
有关更多详细信息，请参阅 W3C WebDriver 规范和 HTML 规范。
```java
element.clear();
element.sendKeys("selenium");
```

#### 该元素是否被选中


- 此操作仅适用于输入元素
  - 例如复选框、选择中的选项和单选按钮

```java
boolean selected = element.isSelected();
```

#### 该元素当前是否启用
```java
boolean enabled = element.isEnabled();
```


#### 该元素是否显示
- 避免了必须解析元素的“样式”属性的问题
```java
boolean displayed = element.isDisplayed();
```

#### 该元素被提交
- 这个当前元素是**一个表单**/**一个表单中的一个元素**，那么这将被提交到远程服务器
- 如果元素被提交导致当前页面发生变化，则此方法将阻塞，直到加载新页面
- `NoSuchElementException` 
  - 给定元素不在表单中

```java
element.submit();
```


# 验证码登录
用