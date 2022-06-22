---
tags: note
status: todo
priority: 1
time: 2022-06-21 15:22
things:  "[🧊](things:///show?id=JtkDsmtmq6Bd8ZbzKBJTW4)"
---
# allure报告
## 命令
### 直接打开报告
```shell
allure serve allure文件地址

allure serve allure-results 
allure serve target/surefire-reports
```
- 默认生成`allure`报告文件地址有2个：
  - 1」在项目下的`allure-results`
  - 2」在项目下的`/target/surefire-reports`
    - 1.`pom`文件配置对应的`surefire`插件
    - 2.命令行运行测试用例
### 合并多个报告命令
##### 方式一
- 1」多个`allure-results`文件夹内的`json`文件复制粘贴到一个文件夹下
- 2」使用`allure serve` 命令打开

##### 方式二

- `generate` 使`allure`报告的`json`文件转换为`html`
```
allure generate -c -o 生成报告目录 历史报告1 历史报告2 历史报告3 ...
```
- `-c` 生成报告前清空报告中的内容。默认不清空
- `-o` 生成报告目录
```shell
allure generate -c -o allureall allure-results1 allure-results2 

```
## Features
| 注解           | 说明                             |
|--------------|--------------------------------|
| `@DisplayName` | 方法和类上使用；添加显示名；                 |
| `@Description` | 只能在方法上使用；Overview内添加详细描述       |
| `Steps` | 只能在方法上使用；添加操作步骤，方法参数引用："{参数名}" |
|`@Attachment`| 添加附件 |

# 演示
## pom文件添加依赖
- 只添加allure相关依赖
```xml
<properties>
    <allure.version>2.17.2</allure.version>
</properties>

<dependencies>
    <dependency>
        <groupId>io.qameta.allure</groupId>
        <artifactId>allure-junit5</artifactId>
        <version>${allure.version}</version>
    </dependency>
</dependencies>
```
- 添加`surefire`插件，生成`surefire-reports`
```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <version>3.0.0-M7</version>
            <configuration>
              <includes>
                <include>**/*Test.java</include>
              </includes>
              <argLine>
                -javaagent:"${settings.localRepository}/org/aspectj/aspectjweaver/${aspectj.version}/aspectjweaver-${aspectj.version}.jar"
              </argLine>
            </configuration>
        </plugin>
    </plugins>
</build>

```
## 
### @DisplayName
```java
package top.testeru;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * @program: junit5_samples
 * @author: testeru.top
 * @description:
 * @Version 1.0
 * @create: 2022/6/21 3:19 PM
 */
@DisplayName("allure-MySUT")
class MySUTTest {

    static MySUT sut ;
    @BeforeAll
    static void beforeAll(){
        sut = new MySUT("params");
    }

    @DisplayName("allure-1+1")
    @Test
    void allure1Test() {
        int result = 1 + 1;
        assertEquals(2,result,"1+1结果错误");
    }
    @DisplayName("allure-2+1")
    @Test
    void allure2Test() {
        int result = 2 + 1;
        assertEquals(3,result,"2 + 1结果错误");
    }
}
```
### @Description
```java
@DisplayName("allure2-1+1")
@Description("v Some detailed test description")
@Test
void allureTest() {
    int result = sut.sum(11,55);
    assertEquals(220,result,"1+1结果错误");

}
```

### @Step
- 业务逻辑代码添加
```java
 //连续添加
@Step("Num: {numbers}.")
public int sum(int... numbers) {
    if(Arrays.stream(numbers).anyMatch(u -> u == 100)){
        log.warn("integer is 100！");
        throw new NumberFormatException("integer is 100！");
    }else if(Arrays.stream(numbers).anyMatch(u -> u > 99) | Arrays.stream(numbers).anyMatch(u -> u < -99)){
        log.warn("请输入范围内的整数");
        throw new IllegalArgumentException("请输入范围内的整数！");
    }else {
        return IntStream.of(numbers).sum();
    }
}
```


### @Attachment