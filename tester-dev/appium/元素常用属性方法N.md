---
tags: note
status: todo
priority: 1
time: 2022-05-31 13:36
things:  "[🧊](things:///show?id=JtkDsmtmq6Bd8ZbzKBJTW4)"
---
## 元素常用属性

#####  获取元素文本
```java
String text = element1.getText();
System.out.println("获取输入框内默认文本：" + text);
```


#####  元素是否可见
```java
boolean runDisplayed = element.isDisplayed();  
System.out.println("元素是否可见："+runDisplayed);
```     
#####  元素属性获取
- 获取元素的给定属性的值
- 以字符串形式返回元素的属性值
- 对于具有布尔值的属性，getAttribute() 方法将返回 true 或 null。
```java
//元素是否可被点击
String runClickable = element.getAttribute("clickable");  
System.out.println("元素是否可被点击："+runClickable);
```
![](https://cdn.jsdelivr.net/gh/testeru-top/images/tester/202205311411547.png)

#####  元素是否可用
```java
boolean seekBarEnabled = element.isEnabled();  
System.out.println("元素是否可用："+seekBarEnabled);
```

#####  获取元素坐标
- [p] 元素左上角的位置坐标
```java
Point location = element1.getLocation();
System.out.println("元素坐标："+location);//元素坐标：(30, 102)
```  


#####  获取元素尺寸
-（高和宽）
```java
Dimension size = element1.getSize();
System.out.println(size);//(878, 88)width,height
```

#### 获取元素中心点
- 根据元素<mark style="background: #6FE26FA6;">起始坐标</mark>「`getLocation`」和<mark style="background: #6FE26FA6;">元素尺寸</mark>「`getSize`」获取元素的中心坐标
```java
Point location = element1.getLocation();
System.out.println("元素坐标："+location);//元素左上角的位置
Dimension size = element1.getSize();
System.out.println(size);//获取元素尺寸
        
int startX = location.getX();//元素起始x点
int startY = location.getY();//元素起始y点
int mid = size.width / 2;//元素长度的一半
int midh = size.height / 2;//元素高度的一半

int middleX = startX + mid;//中心点x
int middleY = startY + midh;//中心点y
System.out.println("中心点坐标为："+middleX+ "，" +middleY);
```


