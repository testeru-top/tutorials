# 1.xUnit
5W1H法则

## 什么是xUnit？
What「何事」 

   xUnit是一个测试体系的思想，不是某一个具体的框架。国外的大佬们习惯把一些通用的规则或者规范总结，抽象成为方法论相关的东西分享出来，这个xUnit大家可以想象为一个测试框架的方法论。
    
 xUnit严格来说是**多个单测框架及其通用架构的统称**。

## 为什么要学xUnit? 
Why「何因」

   因为我们目前测开主要的语言就是Java和python，无论这两个哪种语言，我们都有对应的单测框架，如果大家接触过Java的测试框架也接触过python的测试框架，就会发现一个问题，这些测试框架的功能点大体上都是相像的。
   
   这是因为这些测试框架的底层设计思想都是一样的，只不过每个框架基于自己本身的语言特性以及其它特性来做了个一些针对性的扩展

## 哪里用到xUnit？
Where「何地」when「何时」

   在进行自动化测试的时候我们就会用到xUnit框架，只不过到时候根据我们对应选择的语言来选择对应的具体的框架。比如说我们用的是Java，那么我们可以选择Junit5或者是TestNG;如果我们用的是Python，那么我们可以
选择Unittest或者是Pytest。

   只要是公司说做自动化，无论是UI的还是接口的，对应的xUnit的选择是避免不了的。
   
## 谁会用xUnit？
Who「谁」

   谁编写自动化相关脚本或框架，谁就需要用到，点点点工程师是用不到的。
   
## 怎么用xUnit？
How「怎么用」

   首先需要选好特定的语言，再在特定语言内选好自己要使用的测试框架，这个时候就可以根据具体的框架来讲解对应的使用规则。
   我们这里了用的是Java的单测框架，选择的是Junit5来进行学习
   
   
## xUnit体系结构


|||
|---|---|
|Test Case|测试用例
|Assertions|断言
|Test Execution|测试执行,以何种顺序执行
|Test Fixture| 测试装置,用来管理测试用例的执行
|Test Suites|测试套件,用来编排测试用例
|Test Runner|测试的运行器
|Test Result Formatter|测试结果,具备相同的格式,可被整合


### Test Case   
   这部分就是我们测试脚本的主体，我们写的测试用例的业务逻辑就在这里面。
### Assertions
   断言，这部分对我们测试demo来说很重要。
   
   大家可以想一下，我们写了很多的测试相关的业务逻辑，但是我们这个逻辑执行的对错，是不知道的，那我们写的脚本是不是其实相当于白写。测试测试测的就是这块内容的正确性，所以我们一定要在测试相关的 脚本内添加断言，来给我们一个最终结果的断定。不然真的就是，一顿操作猛如虎，定眼一看原地杵～
   

### Test Execution
   这个是测试框架里面的测试驱动，就是我们一个测试框架，是有哪些注解去驱动这个测试方法的运行，比如Test注解，比如ParameterTest注解，或者是重复注解

### Test Fixture

   这块的功能主要是减少我们

# 2.Junit5 介绍

   这里给大家简单说一下为什么我们最后选择JUnit5而不是TestNG
    
   首先从时间线上，Junit5在TestNG后出来的，对应的功能点也有很多借鉴了TestNG。
   
   但是，Junit5比TestNG又多了很多特性，比如说JUnit5的可扩展性做就非常好，还有对应的Junit5     


JUnit是 Java 生态系统中最流行的单元测试框架之一。JUnit 5 版本包含许多令人兴奋的创新，目标是支持 Java 8 及更高版本的新功能，以及支持多种不同风格的测试


- JUnit 5 中的许多新功能都与利用 Java 8 中的新特性有关

## 创建maven项目
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>testing-modules</artifactId>
        <groupId>com.testeru</groupId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>junit5-basic</artifactId>


    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <java.version>11</java.version>
        <!-- 使用 Java 11 语言特性 ( -source 11 ) 并且还希望编译后的类与 JVM 11 ( -target 11 )兼容，您可以添加以下两个属性，它们是默认属性插件参数的名称-->
        <maven.compiler.target>11</maven.compiler.target>
        <maven.compiler.source>11</maven.compiler.source>
        <!-- 对应junit Jupiter的版本号;放在这里就不需要在每个依赖里面写版本号，导致对应版本号会冲突-->
        <junit.jupiter.version>5.8.2</junit.jupiter.version>

        <maven.compiler.version>3.8.1</maven.compiler.version>
        <maven.surefire.version>3.0.0-M5</maven.surefire.version>
        <hamcrest.version>2.2</hamcrest.version>
        <!-- plugins -->
        <maven-surefire-plugin.version>3.0.0-M5</maven-surefire-plugin.version>
        <slf4j.version>1.7.32</slf4j.version>
        <logback.version>1.2.10</logback.version>
    </properties>

    <!--    物料清单 (BOM)-->
    <dependencyManagement>
        <dependencies>
            <!--当使用 Gradle 或 Maven 引用多个 JUnit 工件时，此物料清单 POM 可用于简化依赖项管理。不再需要在添加依赖时设置版本-->
            <dependency>
                <groupId>org.junit</groupId>
                <artifactId>junit-bom</artifactId>
                <version>${junit.jupiter.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>

        </dependencies>
    </dependencyManagement>



    <dependencies>
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-api</artifactId>
            <version>${slf4j.version}</version>
        </dependency>
        <dependency>
            <groupId>ch.qos.logback</groupId>
            <artifactId>logback-classic</artifactId>
            <version>${logback.version}</version>
        </dependency>


        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <!--            对应添加的依赖的作用范围-->
            <scope>test</scope>
        </dependency>

        <dependency>
            <groupId>org.junit.platform</groupId>
            <artifactId>junit-platform-suite</artifactId>
            <scope>test</scope>
        </dependency>



        <dependency>
            <groupId>org.hamcrest</groupId>
            <artifactId>hamcrest</artifactId>
            <version>${hamcrest.version}</version>
            <scope>test</scope>
        </dependency>




    </dependencies>


    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>${maven-surefire-plugin.version}</version>
                <configuration>
                    <!-- <groups>mytag</groups>
                     <includes>
                         <include>com/testeru/classes/*</include>
                     </includes>-->
                    <!--                    <excludes>-->
                    <!--                        <exclude>com/testeru/suites/cases2/*Test.class</exclude>-->
                    <!--                        <exclude>*Suite*Test</exclude>-->
                    <!--                    </excludes>-->
                </configuration>
                <dependencies>
                    <dependency>
                        <groupId>org.junit.jupiter</groupId>
                        <artifactId>junit-jupiter-engine</artifactId>
                        <version>${junit.jupiter.version}</version>
                    </dependency>
                    <dependency>
                        <groupId>org.junit.vintage</groupId>
                        <artifactId>junit-vintage-engine</artifactId>
                        <version>${junit.jupiter.version}</version>
                    </dependency>
                </dependencies>
            </plugin>
        </plugins>
    </build>
</project>
```


## 配置对应log格式
- `logback.xml`


```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
<!-- name指定<appender>的名称    class指定<appender>的全限定名  ConsoleAppender的作用是将日志输出到控制台-->
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
<!--   写入的文件名，可以使相对目录也可以是绝对目录，如果上级目录不存在则自动创建     -->
<!--        <file>123.log</file>-->
<!--  append 为true表示日志被追加到文件结尾，如果是false表示清空文件 -->
<!--        <append>true</append>-->
<!--        encoder表示对输出格式进行格式化  FileAppender的作用是将日志写到文件中-->
        <encoder>
<!--            输出时间格式-->
            <pattern>%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36}.%M\(%line\) -- %msg%n</pattern>
        </encoder>
    </appender>

    <logger name="com.testeru" level="DEBUG" />
    <logger name="com" level="WARN" />
    <logger name="testeru" level="WARN" />
    <logger name="org" level="WARN" />

    <root level="INFO">
        <appender-ref ref="STDOUT" />
    </root>

</configuration>

```



## 编写业务代码
- MySUT

```java

package com.testeru;

import org.slf4j.Logger;

import java.util.UUID;
import java.util.stream.IntStream;

import static java.lang.invoke.MethodHandles.lookup;
import static org.slf4j.LoggerFactory.getLogger;

/**
 * @program: tutorials
 * @author: testeru.top
 * @description: 我的被测系统软件
 * @Version 1.0
 * @create: 2022/1/17 4:58 下午
 */
public class MySUT {
    //获得具有所需名称的记录器
    static final Logger logger = getLogger(lookup().lookupClass());

    //用例名
    String name;
    //唯一ID标识
    String id;


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public MySUT(String name) {
        this.name = name;
        logger.info("创建 {} ", name);
    }


    public void initId(){
        id = UUID.randomUUID().toString();
        logger.info("生成ID：{} ", id);

    }
    public void destroyId() {
        if (id == null) {
            throw new IllegalArgumentException(name + " 没有初始化对应ID");
        }
        logger.info("释放ID: {} ", id);
        id = null;
    }


    public void close() {
        logger.info("关闭 {} ", name);
    }


    //连续添加
    public int sum(int... numbers) {
        return IntStream.of(numbers).sum();
    }

    //从100进行减法
    public int subtract(int... numbers) {
        int sum = IntStream.of(numbers).reduce(100, (a, b) -> a-b);
        return sum;
    }

    public int subtract(int x,int y) {
        return x-y;
    }


    //平均值 average
    public double average(int... numbers) {

        return IntStream.of(numbers).average().getAsDouble();

    }


    //连续拼接
    public String concatStr(String... words) {
        return String.join(" ", words);
    }



}

```


[[1.基本的注解、断言]]
[[2.常用注解]]
[[3.顺序执行测试方法]]
[[4.参数化测试方法]]
[[5.Suite套件]]
[[6.动态测试]]
