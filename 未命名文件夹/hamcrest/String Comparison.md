# String Comparison
string类型比较器

`pom`文件导入:
```xml
<dependency>
    <groupId>org.hamcrest</groupId>
    <artifactId>hamcrest</artifactId>
    <version>2.2</version>
    <scope>test</scope>
</dependency>
```
# String相关断言
## containsString
## containsStringIgnoringCase
- 断言实际字符串是否包含测试字符串
## startsWith
## startsWithIgnoringCase
- 断言实际字符串是否以测试字符串开头

## endsWith
## endsWithIgnoringCase
- 来断言实际字符串是否以测试字符串结尾
```java
public class HamcrestStringUnitTest {

    @Test
    void UsingIsForMatch(){
        String testString = "Rhaegar Targaryen";
        //我们可以使用 containsString(String) 或 containsStringIgnoringCase(String) 来断言实际字符串是否包含测试字符串
        assertThat(testString, containsString("aegar"));
        assertThat(testString, containsStringIgnoringCase("AEGAR"));

        //或者 startsWith(String) 和 startsWithIgnoringCase(String) 断言实际字符串是否以测试字符串开头
        assertThat(testString, startsWith("Rhae"));
        assertThat(testString, startsWithIgnoringCase("rhae"));

        //我们还可以使用endsWith(String) 或endsWithIgnoringCase(String) 来断言实际字符串是否以测试字符串结尾
        assertThat(testString, endsWith("aryen"));
        assertThat(testString, endsWithIgnoringCase("ARYEN"));
    }
}

```