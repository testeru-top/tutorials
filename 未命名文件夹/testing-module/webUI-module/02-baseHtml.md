---
notebook: web_auto
title: 2.前端基础知识汇总
tags: auto,ui
---


对应元素定位
如果有name优先使用By.name()来定位

name研发不会随便改,影响后端
name稳定性更高

# javascript

## 作用

##### 1.改变页面HTML元素

##### 2.改变页面HTML属性

##### 3.改变页面css属性,对页面所有事件作出反应

##### 4.获取文本内容

## 找`html`元素

### 通过`id`属性找`html`元素

- `Web`前端页面的`id`属性**唯一**且**不重复**

{`web`端的`id`属性是不会重复的,`id`相当于我们的身份证;
如果是**app端的id则有可能会重复**}

用`chrome dev`工具编写`javascript`代码验证



![](https://gitee.com/testeru/pichub/raw/master/images/202111021927736.png)
- 可以看到上图中对应的`element`查找只有`id`不带`s`

### 通过标签名`tag`来查找`html`元素
- 下面使用标签名来定位元素

```javascript
document.getElementsByTagName("input")
```
![](https://gitee.com/testeru/pichub/raw/master/images/202111021929445.png)

### 通过类名`class`查找`html`元素

- 相同的`class`具有相同的`css`

```javascript
> var ele = document.getElementsByName("tj_briicon")
```


## `javascript`改变元素相关属性

### 获取元素属性
方式:`元素.属性`
#### 获取id为test的value属性

```javascript
var value = document.getElementById("test").value

```
#### 设置id为test元素的value属性值为测试

```javascript
document.getElementById("kw").value="测试";
```


```javascript
//获取到的对象放在声明的变量element
var element = document.getElementById("kw")
//查看element的name属性
element.name
//直接更改element的name属性
element.name="new111";
//查看标签
document.getElementById("kw")
<input type=​"text" class=​"s_ipt" name=​"new111" id=​"kw" maxlength=​"100" autocomplete=​"off">​
```
![](https://gitee.com/testeru/pichub/raw/master/images/202111021936246.png)

#### input标签的属性通过value来控制它的值

```javascript
element.value="北京疫情"
```
![](https://gitee.com/testeru/pichub/raw/master/images/202111021944483.png)

- 其他属性取值、赋值方式也是一样

### 获取元素间的内容
#### 获取元素间的文本内容
##### 获取文本内容`ele.innerText`

```javascript
> var ele = document.getElementsByName("tj_briicon")

> ele[0]
<a href=​"http:​/​/​www.baidu.com/​more/​" name=​"tj_briicon" class=​"s-bri c-font-normal c-color-t" target=​"_blank">​更多​</a>​

>ele[0].innerText

```
![](https://gitee.com/testeru/pichub/raw/master/images/202111021956948.png)


# `HTML DOM`事件
## `onload`()
##### 当页面已加载完成时触发此事件

##### `window.onload `表示当前窗口已经加载结束
- 设置了一个监听的事件
##### `function()` 表示一个方法

```javascript
window.onload = function()
{
    alert("page is loaded");
}
```

- 编写对应的`11.html`
```html
<html>
	<head>
		<script type="text/javascript">
			window.onload = function(){
				    alert("page is loaded");
			}
		</script>
	</head>
	<body>
		dfsaf
	</body>
</html>
```
![](https://gitee.com/testeru/pichub/raw/master/images/202111031008536.png)

## `onblur`()
##### 当元素失去焦点时触发此事件

```html
<html>
	<head>
		<script type="text/javascript">
			window.onload = function(){
				document.getElementById("test1").onblur = function(){
					alert("输入框失去焦点");
				}
			}
		</script>
	</head>
	<body>
		dfsaf
		<input id="test1" type="text" name="">
	</body>
</html>
```


![](https://gitee.com/testeru/pichub/raw/master/images/202111031036115.png)


## `onfocus`()
##### 当元素焦点时触发此事件

```html
<html>
	<head>
		<script type="text/javascript">
			window.onload = function(){
				document.getElementById("test1").onfocus = function(){
					alert("输入框得到了焦点");
				}
			}
		</script>
	</head>
	<body>
		dfsaf
		<input id="test1" type="text" name="">
	</body>
</html>
```

![](https://gitee.com/testeru/pichub/raw/master/images/202111031050888.png)

## `onchange`()
##### 当元素的`value`值改变时触发此事件

##### `value`属性不会同步刷新

对应输入其他内容,`value`值不同步刷新

```html
<html>
	<head>
		<script type="text/javascript">
			window.onload = function(){
				document.getElementById("test1").onchange = function(){
					// alert("输入框得到了焦点");
					alert(this.value);

				}
			}
		</script>
	</head>
	<body>
		dfsaf
		<input id="test1" type="text" name="" value="123">
	</body>
</html>

```
![](https://gitee.com/testeru/pichub/raw/master/images/202111031106058.png)


## `ondblclick`()
##### 按钮双击触发

```html

<html>
	<head>
		<script type="text/javascript">
			window.onload = function(){
				document.getElementById("test4").ondblclick = function(){
					alert("按钮被双击了");
				}
			}
		</script>
	</head>
	<body>
		dfsaf
		<input id="test1" type="text" name="" value="123">
		<!-- 按钮 -->
		<input id="test4" type="button" name="" value="登录按钮">

	</body>
</html>
```

![](https://gitee.com/testeru/pichub/raw/master/images/202111031139119.png)


## 注意
- 一个html里面只能用一个script,如果多个script写对应的window.onload 则前面的会被覆盖掉,只执行最后一个
# 作业:
## 1.编写如下个人信息页面
- 「1」页面内容包含:
用户名,密码,性别,头像,住址,爱好,备注信息
- 「2」头像可以按钮选择上传图片
- 「3」住址选择框选择
- 「4」爱好可多选
- 「5」密码为加密形式
- 「6」性别为单选按钮
- 「7」备注信息输入框内默认文字为:这是第一个作业

```javascript
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>个人信息页面</title>
</head>
<body>
	用户名:<input type="text" name="" value="name"><br/>
	密码:<input type="password" name=""><br/>
	性别:<input type="radio" name="sex">男
	<input type="radio" name="sex">女<br/>
	头像:<input type="file" name=""><br/>
	住址:
	<select>
		<option>河北</option>
		<option>北京</option>
	</select>省
	<select>
		<option>邯郸</option>
		<option>北京</option>
	</select><br/>
	爱好:<input type="checkbox">Java
	<input type="checkbox">python
	<input type="checkbox">c++<br/>
	备注信息:<textarea value="">这是第一个作业</textarea>

</body>
</html>
```

## 2.编写登录页面
- 「1」页面内容包含:
用户名(文本输入框),密码(文本输入框),登录按钮,重置按钮
- 「2」实现重置按钮,点击重置,清除填写的数据
- 「3」点击登录,获取到用户名和密码通过alert提示框展示出来

```
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>个人信息页面</title>
	<script type="text/javascript">
		window.onload = function(){
			document.getElementById("reset").onclick = function(){
				document.getElementById("username").value="";
				document.getElementById("pwd").value="";

			}
			document.getElementById("login").onclick = function(){
				var username  = document.getElementById("username").value;
				var password = document.getElementById("pwd").value;
				alert("用户名:"+username+"\n密码:"+password);

			}
		}
	</script>
</head>
<body>
	用户名:<input id="username" type="text" name=""><br/>
	密码:<input id="pwd" type="password" name=""><br/>
	<input id="login" type="button" name="" value="登录">
	<input id="reset" type="button" name="" value="重置">
	
	
	<!-- 性别:<input type="radio" name="sex">男
	<input type="radio" name="sex">女<br/>
	头像:<input type="file" name=""><br/>
	住址:
	<select>
		<option>河北</option>
		<option>北京</option>
	</select>省
	<select>
		<option>邯郸</option>
		<option>北京</option>
	</select><br/>
	爱好:<input type="checkbox">Java
	<input type="checkbox">python
	<input type="checkbox">c++<br/>
	备注信息:<textarea value="">这是第一个作业</textarea> -->

</body>
</html>
```