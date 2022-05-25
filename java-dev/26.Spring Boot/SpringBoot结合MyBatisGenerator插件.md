
# 步骤
## 1. 引入Mybatis-Generator插件

````ad-note
title:MyBatisGenerator

  

- pom文件导入依赖

  
  

```xml

<plugin>
	<groupId>org.mybatis.generator</groupId>
	<artifactId>mybatis-generator-maven-plugin</artifactId>
	<version>1.3.7</version>
</plugin>

```
导入成功后对应maven可以看到有该插件，命令行运行：
```
mvn mybatis-generator:generate
```
````

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaweb-module/202205151748527.png)

````ad-bug
```note-red
[ERROR] Failed to execute goal org.mybatis.generator:mybatis-generator-maven-plugin:1.3.7:generate (default-cli) on project 项目名: configfile /Users/.../src/main/resources/generatorConfig.xml does not exist -> [Help 1]

```
````

````ad-tip
由于没有该插件的相关配置文件导致，需要编写配置文件<span class="red">generatorConfig.xml</span>
````


## 2. generatorConfig.xml
### properties
````ad-hint
title:properties标签


- [*] 引入配置文件
	- [k] <span class="red">resource</span>为对应配置文件的全路径
````
### context
````ad-hint
title:context标签


- [*] 生成一组对象
	- [k] <span class="red">defaultModelType</span>：flat，每个表只生成一个实体类
	- [k] <span class="red">targetRuntime</span>：MyBatis3Simple，避免生成Example相关的代码和方法
````
#### property

````ad-hint
title:property标签


- [*] 配置起始 <span class="red">beginningDelimiter</span> 与结束 <span class="red">endingDelimiter</span> 标识符 指明数据库的用于标记数据库对象名的符号
	- [k] ORACLE：<span class="red">双引号</span>
	- [k] MYSQL：<span class="red">`反引号</span>
````
#### plugin

````ad-hint
title:plugin标签


- [*] 定义一个插件
	
````


#### jdbcConnection

````ad-hint
title:jdbcConnection标签


- [*] 数据库连接配置
	
````
#### javaModelGenerator

````ad-hint
title:javaModelGenerator标签


- [*] 配置生成的实体类
	- [k] <span class="red">targetPackage</span>：放置生成的类的包
	- [k] <span class="red">targetProject</span>：包所在的project下的位置 <span class="red">src/main/java</span>
````

#### sqlMapGenerator

````ad-hint
title:sqlMapGenerator标签


- [*] 配置SQL映射生成器mapper.xml
	- [k] <span class="red">targetPackage</span>：生成映射文件存放的包名
	- [k] <span class="red">targetProject</span>：项目路径 <span class="red">mapper</span>
````
#### javaClientGenerator

````ad-hint
title:javaClientGenerator标签


- [*] 配置接口位置
	- [k] <span class="red">targetPackage</span>：生成Mapper文件存放的包名
	- [k] <span class="red">targetProject</span>：指定目标targetPackage的项目路径
	- [k] <span class="red">typetype="XMLMAPPER"</span>：接口和XML完全分离；所有方法都在XML中，接口用依赖Xml文件
````


```xml
<?xml version="1.0" encoding="UTF-8"?>  
<!DOCTYPE generatorConfiguration PUBLIC "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN"  
        "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd">  
  
  
<!-- 配置生成器 -->  
<generatorConfiguration>  
  
  
    <!--执行generator插件生成文件的命令： call mvn mybatis-generator:generate -e -->  
    <!-- 引入配置文件 -->    
    <properties resource="generator/config.properties"/>  
    <!--classPathEntry:数据库的JDBC驱动,换成你自己的驱动位置 可选 -->  
<!--    <classPathEntry location="${jdbc.jar.path}"/>-->  
  
    <!-- 一个数据库一个context 配置对象环境-->    <!--    id="MysqlTable" ：此上下文的唯一标识符。此值将用于一些错误消息。    targetRuntime="MyBatis3Simple"：为了避免生成Example相关的代码和方法。如果需要则改为Mybatis3    defaultModelType="flat" ：每个表只生成一个实体类    -->    
    <context id="MysqlTable" targetRuntime="MyBatis3Simple" defaultModelType="flat">  
  
        <!-- 配置起始与结束标识符 指明数据库的用于标记数据库对象名的符号-->  
        <!-- ORACLE就是双引号，MYSQL默认是`反引号  数据库使用mysql,所以前后的分隔符都设为”`”-->        
        <property name="beginningDelimiter" value="`"/>  
        <property name="endingDelimiter" value="`"/>  
  
  
<!--用来定义一个插件，用于扩展或者修改MBG生成的代码，不常用，可以配置0个或者多个，个数不受限制。  
只有一个Type标签，其中填插件的全限定名。  
常用的有缓存插件，序列化插件，RowBounds插件，ToString插件等。-->  
        <plugin type="${mapper.plugin}">  
            <property name="mappers" value="${mapper.Mapper}"/>  
        </plugin>  
<!--数据库连接配置-->  
        <jdbcConnection driverClass="${jdbc.driver}"  
                        connectionURL="${jdbc.url}"  
                        userId="${jdbc.username}"  
                        password="${jdbc.password}">  
        </jdbcConnection>  
  
<!--        <jdbcConnection driverClass="com.mysql.cj.jdbc.Driver" connectionURL="jdbc:mysql://localhost:3306/db_shiro_prod" userId="root" password="000000"></jdbcConnection>-->  
        <!-- 配置生成的实体类位置 type使用XMLMAPPER，会使接口和XML完全分离。  
            targetPackage：放置生成的类的包。 MyBatis Generator 将根据需要为生成的包创建文件夹            targetProject：包所在的project下的位置，指定了将保存对象的项目和源文件夹。该目录不存在，MyBatis Generator 将不会创建该目录        -->        <javaModelGenerator targetPackage="${java.targetPackage}" targetProject="${java.targetProject}">  
            <!-- 设置一个根对象，  
            如果设置了这个根对象，那么生成的keyClass或者recordClass会继承这个类；在Table的rootClass属性中可以覆盖该选项            注意：如果在key class或者record class中有root class相同的属性，MBG就不会重新生成这些属性了，包括：                1，属性名相同，类型相同，有相同的getter/setter方法；  
            rootClass：所有实体类的父类，如果父类定义了一些字段以及对应的getter、setter方法，那么实体类中就不会再生成。必须要类的安全限定名，如com.momo.test.BasePo         -->            
            <property name="rootClass"  
                      value="${java.rootClass}"/>  
        </javaModelGenerator>  
  
  
        <!-- sqlMapGenerator：配置SQL映射生成器（Mapper.xml文件）的属性，可选且最多配置1个  配置映射位置  
                只有两个必选属性(和实体类的差不多)：                        targetPackage：生成映射文件存放的包名，可能会受到其他配置的影响。                        targetProject：指定目标targetPackage的项目路径，可以用相对路径或者绝对路径        -->        <sqlMapGenerator targetPackage="${mapper.targetPackage}" targetProject="${mapper.targetProject}"/>  
  
        <!-- 配置接口位置  
            typetype="XMLMAPPER"：接口和XML完全分离；所有方法都在XML中，接口用依赖Xml文件            targetPackage：生成Mapper文件存放的包名，可能会受到其他配置的影响。            targetProject：指定目标targetPackage的项目路径，可以用相对路径        -->        
            <javaClientGenerator targetPackage="${java.targetMapperPackage}" targetProject="${java.targetProject}"  
                             type="XMLMAPPER"/>  
  
        <!-- table可以有多个,每个数据库中的表都可以写一个table，  
        tableName表示要匹配的数据库表,也可以在tableName属性中通过使用%通配符来匹配所有数据库表,只有匹配的表才会自动生成文件 -->        <!-- 配置数据库表 -->        <table schema="aitest_mini" tableName="hogwarts_%">  
            <!-- generatedKey：用来指定自动生成的主键的属性。针对MySql,SQL Server等自增类型主键  
                   indetity：设置为true时会被标记为indentity列，                   并且selectKey标签会被插入在Insert标签（order=AFTER）。                   设置为false时selectKey会插入到Insert之前（oracal序列），默认为false.            -->            
                   <generatedKey column="id" sqlStatement="Mysql" identity="true"/>  
        </table>  
  
        <!-- 生成用户的相关类 -->  
<!--        <table schema="aitest_mini" tableName="hogwarts_test_user" domainObjectName="HogwartsTestUser" enableCountByExample="false" enableDeleteByExample="false"-->  
<!--               enableSelectByExample="false" enableUpdateByExample="false" >-->  
<!--            <generatedKey column="id" sqlStatement="Mysql" identity="true"/>-->  
<!--        </table>-->  
    </context>  
</generatorConfiguration>
```

## 3. properties
```properties
#jdbc.jar.path=/Users/gaigai/.m2/repository/mysql/mysql-connector-java/8.0.29/mysql-connector-java-8.0.29.jar  
# 数据库配置 A  
jdbc.driver=com.mysql.cj.jdbc.Driver  
jdbc.url=jdbc:mysql://110.40.250.165:3307/aitest_mini?characterEncoding=UTF-8&useUnicode=true&nullCatalogMeansCurrent=true  
jdbc.username=root  
jdbc.password=root  
# 通用Mapper配置  
mapper.plugin=tk.mybatis.mapper.generator.MapperPlugin  
mapper.Mapper=top.testeru.sbm.common.MySqlExtensionMapper  
#dao类和实体类的位置  
java.targetProject=src/main/java  
#实体类的包名  
java.targetPackage=top.testeru.sbm.entity  
#实体类的根包名  
java.rootClass=top.testeru.sbm.entity.BaseEntityNew  
#mapper.xml位置  
mapper.targetProject=src/main/resources  
#mapperXML文件路径  
mapper.targetPackage=mapper  
  
#dao类的包名  
java.targetMapperPackage=top.testeru.sbm.dao
```

## 4. pom文件


```xml
<dependencies>  
    <dependency>  
        <groupId>mysql</groupId>  
        <artifactId>mysql-connector-java</artifactId>  
        <version>8.0.29</version>  
        <scope>runtime</scope>  
    </dependency>  
    <dependency>  
        <groupId>org.mybatis.spring.boot</groupId>  
        <artifactId>mybatis-spring-boot-starter</artifactId>  
        <version>2.1.0</version>  
    </dependency>  
  
    <!-- https://mvnrepository.com/artifact/tk.mybatis/mapper-spring-boot-starter -->  
    <dependency>  
        <groupId>tk.mybatis</groupId>  
        <artifactId>mapper-spring-boot-starter</artifactId>  
        <version>2.1.5</version>  
    </dependency>  
</dependencies>  
  
<build>  
    <plugins>  
        <plugin>  
            <groupId>org.mybatis.generator</groupId>  
            <artifactId>mybatis-generator-maven-plugin</artifactId>  
            <version>1.3.7</version>  
            <!--插件设置-->  
            <configuration>  
                <!--允许移动生成的文件-->  
                <verbose>true</verbose>  
                <!--启用覆盖-->  
                <overwrite>true</overwrite>  
                <!--自动生成配置 如果名字是generatorConfig.xml可以省略配置-->  
                <configurationFile>src/main/resources/generator/generatorConfig.xml</configurationFile>  
            </configuration>  
            <dependencies>  
                <dependency>  
                    <groupId>mysql</groupId>  
                    <artifactId>mysql-connector-java</artifactId>  
                    <version>8.0.29</version>  
                    <scope>runtime</scope>  
                </dependency>  
                <dependency>  
                    <groupId>tk.mybatis</groupId>  
                    <artifactId>mapper</artifactId>  
                    <version>4.1.5</version>  
                </dependency>  
            </dependencies>  
        </plugin>  
    </plugins>  
</build>

```