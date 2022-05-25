---
notebook: web_auto
title: 4.Selenium IDE
tags: auto,ui
---


- selenium ide
- katalon studio【了解】

# Selenium IDE 使用

- 录制脚本/回放脚本
##### 优势:
- 上手快速
##### 缺点
- 录制的脚本容易出现问题
- 稳定性不好
- 页面样式发生变化 --- 脚本失效 --- 维护成本比较高

## 界面介绍


![](https://gitee.com/datau001/picgo/raw/master/images/202112061623632.png)

## 开始录制
### 1.创建自己的project
- ⚠️注意：命名规则为英文


![](https://gitee.com/datau001/picgo/raw/master/images/202112061654950.png)

### 2.填写录制的URL

![](https://gitee.com/datau001/picgo/raw/master/images/202112061657369.png)


### 3.对应网站打开


![](https://gitee.com/datau001/picgo/raw/master/images/202112061659257.png)


### 4.进行操作步骤的录制
- 想要录制什么步骤的自动化，直接在打开的URL页面进行操作


### 5.定义测试名称

![](https://gitee.com/datau001/picgo/raw/master/images/202112061701387.png)


![](https://gitee.com/datau001/picgo/raw/master/images/202112061705330.png)

- 注意⚠️：
  - 刚开始定义的是一个project名称
  - 最后结尾定义的是一个test名称
  - 一个project有多个test


### 6.录制步骤解读

![](https://gitee.com/datau001/picgo/raw/master/images/202112061713226.png)


### 7.test目录解读
![](https://gitee.com/datau001/picgo/raw/master/images/202112061744572.png)

### 8.导出Java代码

![](https://gitee.com/datau001/picgo/raw/master/images/202112061745652.png)

- `SearchtestTest.java`
-  1.Java代码导出，以java结尾的文件
-  2.自己选择保存地址
-  3.在自己方法名后自动跟上Test作为文件名/类名


### 9.idea代码验证


![](https://gitee.com/datau001/picgo/raw/master/images/202112061820792.png)


### 10.IDE其他功能说明

##### test标签
![](https://gitee.com/datau001/picgo/raw/master/images/202112061807470.png)

- 运行一个test


![](https://gitee.com/datau001/picgo/raw/master/images/202112061807757.png)

- 运行所有的test

![](https://gitee.com/datau001/picgo/raw/master/images/202112061809497.png)

- 调试test

![](https://gitee.com/datau001/picgo/raw/master/images/202112061808004.png)


##### project标签

![](https://gitee.com/datau001/picgo/raw/master/images/202112061813544.png)

- 保存到本地
![](https://gitee.com/datau001/picgo/raw/master/images/202112061818037.png)

- 本地项目导入到IDE
