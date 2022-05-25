---
tags: auto,ui
---
Web自动化模块知识点:
- 1. `web`前端基础知识
- 2. `selenium IDE`脚本录制回放
- 3. `Chrome`、`Firefox`、`IE`、`Saraf`主流浏览器自动化测试环境
- 4. 八大元素定位、特殊元素定位
- 5. `web`元素常用操作
- 6. 自动化测试框架、模型
- 7. `web`自动化流程、用例设计
- 8. `PageObject`设计模式应用
- 9. 数据驱动
- 10. `BasePage`公共特性提取
- 11. 用例失败监听截图
- 12. 用例失败重试
- 13. `Allure`报告集成
- 14. `Jenkins CI`


### 测试用例关键元素
```
导入依赖
创建对应driver
执行自动化步骤
断言结果
```

### 自动化测试基本流程
- 1. 制定测试计划，明确测试目标和场景
- 2. 选定（设计）测试用例，编写脚本实现测试流程与断言
- 3. 集成框架，完成自动化用例管理执行，生成报告
- 4. 持续集成，将自动化运行纳入项目开发流程

谷歌浏览器提供一个`debug`模式，里面有一个`remote Debug`我们可以进行浏览器的复用


### python对应的第三方库安装
#### pip安装
```python

pip install 库名==版本号
pip uninstall 库名==版本号

例子：
pip install django=1.11.11
pip uninstall django=1.11.11
```

如果下载太慢需要加速，则加上对应代理`-i https://pypi.tuna.tsinghua.edu.cn/simple`

```shell
pip install opencv-contrib-python==3.4.2.16 -i https://pypi.tuna.tsinghua.edu.cn/simple
```