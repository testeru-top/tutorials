## JUnit入门
`JUnit`是最受欢迎的基于 `JVM` 的测试框架，我们目前熟悉知道的就是JUnit4、JUnit5，但是在第 5 个主要版本中进行了彻底的改造。所以，我们选择学习新的框架，这个JUnit5也不算很新的框架，毕竟版本已经从2016年的5.0版本更新到了现在最新的5.9.0版本。
1. `JUnit 5` 是面向 Java 8 及更高版本的开源测试框架，可以完全替换或兼容`JUnit 4`。
>新的版本肯定要兼容旧的版本以及旧版本的技术，只是新版本增加了自己特有的一些特性，或者是有些使用方式上「比如：导包，对应包的位置及导入的包名方式有改变」有些改变。
2. `JUnit 5` 提供了丰富的功能——从改进的==注解==、==标签==和==过滤器==到==条件判断执行==和==分组断言==。
>这让基于 TDD 编写单元测试变得轻而易举。
3. 新框架还带来了一个强大的==扩展模型==。开发人员可以使用这个新模型向 JUnit 5 中添加自定义功能。
>这种自定义扩展机制为 Java 程序员提供了一种创建和执行故事和行为（即 BDD 规范测试）的方法。
4. JUnit 5 在运行时需要 Java 8 或更高版本。本教程系列使用的是==Java 11==。






在我们的 JUnit 5 教程系列中，我们介绍了JUnit5的大部分的使用方法


## JUnit5组成

与以前的 JUnit 版本不同，JUnit 5由 由三个部分组成。
>JUnit5不是一个模块里面写完所有的功能及特性，在JUnit 5这个新一代的JUnit框架中，分了3个不同的子模块来进行框架的业务特性的区分。
- 一个基础平台、一个新的编程和扩展模型 Jupiter，以及一个名为 Vintage 的向后兼容的测试引擎。
```
JUnit 5 =  JUnit Platform  +  JUnit Jupiter  +  JUnit Vintage
```

### Junit Platform
- 是在 JVM 上启动测试框架的基础


- 在jvm上启动测试框架的基础，定义了测试引擎的API，可以在cmd命令行启动这个平台。
- 
Junit Platform：它是 `JVM` 上测试框架的 `Launcher`，定义了用于发现和执行测试的 TestEngine API，提供了用于运行 Junit 复古和 Junit Jupiter 测试的 ConsoleLauncher，以及对 IDE 和构建工具（如 Gradle、Maven 等）的一流支持。



### Junit Jupiter
Junit Jupiter：用于编写单元测试的新编程模型，Junit 4 的扩展模型并提供标准断言。
### Junit Vintage
Junit Vintage：一个运行 JUnit 3 和 JUnit 4 测试和迁移支持到 JUnit 5 (JUnit Jupiter) 的测试引擎。
-   JUnit 5 Jupiter 的扩展模型可用于向 JUnit 中添加自定义功能。
-   扩展模型 API 测试生命周期提供了钩子和注入自定义参数的方法（即依赖注入）。





在本 JUnit 5 教程中，我们通过编写和执行测试的示例介绍了以下概念。


在这个 Junit 5 教程中，我们专注于用于编写测试的 Junit Jupiter 和用于执行测试的 Junit 平台。



https://www.infoq.cn/article/deep-dive-junit5-extensions