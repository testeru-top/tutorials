```
java.lang.NoSuchMethodError: com.google.common.collect.ImmutableMap.of(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Lcom/google/common/collect/ImmutableMap;

```

#### 解决方式一：
```java
    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>com.google.guava</groupId>
                <artifactId>guava</artifactId>
                <version>31.0.1-jre</version>
            </dependency>
        </dependencies>
    </dependencyManagement>
```
#### 解决方式2：

```
<dependency>  
    <groupId>io.github.bonigarcia</groupId>  
    <artifactId>webdrivermanager</artifactId>  
    <version>5.0.3</version>  
    <exclusions>  
        <exclusion>  
            <groupId>com.google.guava</groupId>  
            <artifactId>guava</artifactId>  
        </exclusion>  
    </exclusions>  
</dependency>
```

## cookie
```java
public class CookieBaseProTest {

    @Test
    public void test(){
        System.setProperty("webdriver.chrome.driver","/Users/gaigai/Desktop/chromedriver");
        WebDriver webDriver = new ChromeDriver();
        webDriver.get("https://work.weixin.qq.com/wework_admin/loginpage_wx");
```

```
if(!Paths.get("cookies.yaml").toFile().exists()) {

//如果cookie文件不存在，显示等待链接跳转 获取页面cookie 并写入cookie的yaml文件

            WebDriverWait wait = new WebDriverWait(webDriver, Duration.ofSeconds(30), Duration.ofSeconds(2));
            wait.until(webDriver1 -> !webDriver1.getCurrentUrl().equals(preUrl));
            Set<Cookie> cookies1 = webDriver.manage().getCookies();
            ObjectMapper objectMapper = new ObjectMapper(new YAMLFactory());
            try {
                objectMapper.writeValue(
                        Paths.get("cookies.yaml").toFile(), cookies1);
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }else {
		
```

```
//如果文件存在，读取文件内的cookie
//对应cookie时间校验 是否2个小时内，如果是直接加载cookie登录
//如果不是，则扫码登录

            List<HashMap<String, Object>> cookies;
            try {
                ObjectMapper objectMapper = new ObjectMapper(new YAMLFactory());
                TypeReference<List<HashMap<String,Object>>> typeReference = new TypeReference<List<HashMap<String, Object>>>() {
                };
                cookies = objectMapper.readValue(Paths.get("cookies.yaml").toFile(), typeReference);
            } catch (IOException e) {
                throw new RuntimeException(e);
            }            List<Long> expiryList = new ArrayList<>();
            cookies.forEach(
                    cookie -> {
                        if(cookie.get("expiry") != null){
                            String expiryStr = cookie.get("expiry").toString();
                            Long expireL = Long.valueOf(expiryStr);
                            expiryList.add(expireL);
                        }
                    }
            );
            long nowCookieTime = expiryList.get(0) - 31536000000L;//毫秒级别
            long nowTime = System.currentTimeMillis();//毫秒级别
            if((nowTime - nowCookieTime)/1000 < 7200){
                System.out.println("使用cookie文件");
                cookies.stream()
                        .filter(
                                cookie -> cookie.get("domain").toString().contains(".weixin.qq.com")
                        )
                        .forEach(cookie -> {
                            //cookie 放入浏览器
                            webDriver.manage().addCookie(
                                    new Cookie(cookie.get("name").toString(),cookie.get("value").toString())
                            );
                        });
                //刷新浏览器，刷新的时候会把新的cookie放入，服务器才会返回登录后的页面
                webDriver.navigate().refresh();
            }else {
                System.out.println("扫码登录，cookie失效");
                //同时写入cookie文件
                WebDriverWait wait = new WebDriverWait(webDriver, Duration.ofSeconds(30),Duration.ofSeconds(2));
                wait.until(webDriver1 -> !webDriver1.getCurrentUrl().equals(preUrl));
                Set<Cookie> cookies1 = webDriver.manage().getCookies();
                ObjectMapper objectMapper = new ObjectMapper(new YAMLFactory());
                try {
                    objectMapper.writeValue(
                            Paths.get("cookies.yaml").toFile(),cookies1);
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            }
            String afterURL = webDriver.getCurrentUrl();
            System.out.println(!afterURL.equals(preUrl)?"登录成功":"登录失败");
        }

    }
}
```


- 提取对应的重复代码，或代码封装为方法
#### 文件读取封装
```java
public List<HashMap<String, Object>> readCookieYaml() {
    List<HashMap<String, Object>> cookies;
    try {
    ObjectMapper objectMapper = new ObjectMapper(new YAMLFactory());
    TypeReference<List<HashMap<String,Object>>> typeReference = new TypeReference<List<HashMap<String, Object>>>() {
    };
    cookies = objectMapper.readValue(Paths.get("cookies.yaml").toFile(), typeReference);
    } catch (IOException e) {
    throw new RuntimeException(e);
    }
    return cookies;
}
```

#### 扫码登录封装
```java
public void saomaLogin(WebDriver webDriver, String preUrl) {
    WebDriverWait wait = new WebDriverWait(webDriver, Duration.ofSeconds(30),Duration.ofSeconds(2));
    wait.until(webDriver1 -> !webDriver1.getCurrentUrl().equals(preUrl));
    Set<Cookie> cookies1 = webDriver.manage().getCookies();
    ObjectMapper objectMapper = new ObjectMapper(new YAMLFactory());
    try {
        objectMapper.writeValue(
                Paths.get("cookies.yaml").toFile(),cookies1);
    } catch (IOException e) {
        throw new RuntimeException(e);
    }
}
```
#### 登录cookie封装
```java
public void loginWithCookie(WebDriver webDriver, String preUrl) {
        List<HashMap<String, Object>> cookies = readCookieYaml();
        List<Long> expiryList = new ArrayList<>();
        cookies.forEach(
                cookie -> {
                    if(cookie.get("expiry") != null){
                        String expiryStr = cookie.get("expiry").toString();
                        Long expireL = Long.valueOf(expiryStr);
                        expiryList.add(expireL);
                    }

                }
        );
        long nowCookieTime = expiryList.get(0) - 31536000000L;//毫秒级别
        long nowTime = System.currentTimeMillis();//毫秒级别
        if((nowTime - nowCookieTime)/1000 < 7200){
            System.out.println("使用cookie文件");
            cookies.stream()
                    .filter(
                            cookie -> cookie.get("domain").toString().contains(".weixin.qq.com")
                    )
                    .forEach(cookie -> {
                        //cookie 放入浏览器
                        webDriver.manage().addCookie(
                                new Cookie(cookie.get("name").toString(),cookie.get("value").toString())
                        );
                    });
            //刷新浏览器，刷新的时候会把新的cookie放入，服务器才会返回登录后的页面
            webDriver.navigate().refresh();
        }else {
            System.out.println("扫码登录，cookie失效");
            saomaLogin(webDriver, preUrl);
        }
        String afterURL = webDriver.getCurrentUrl();
        System.out.println(!afterURL.equals(preUrl)?"登录成功":"登录失败");
    }
```

#### 调用
```java
public class CookieProTest {
    static WebDriver webDriver;
    GetCookie getCookie = new GetCookie();
    @BeforeAll
    public static void beforeAll(){
        System.setProperty("webdriver.chrome.driver","/Users/gaigai/Desktop/chromedriver");
        webDriver = new ChromeDriver();
        webDriver.get("https://work.weixin.qq.com/wework_admin/loginpage_wx");
    }
    @Test
    public void getCookiePro(){
        String preUrl = webDriver.getCurrentUrl();
        if(!Paths.get("cookies.yaml").toFile().exists()){
            getCookie.saomaLogin(webDriver, preUrl);
        }else {
            getCookie.loginWithCookie(webDriver, preUrl);
        }
    }
}
```


## 通讯录

```xml
<javafaker.verison>1.0.2</javafaker.verison>

<!--        随机生成数据-->
<dependency>
    <groupId>com.github.javafaker</groupId>
    <artifactId>javafaker</artifactId>
    <version>${javafaker.verison}</version>
</dependency>
```



```java
public class AddConcatProTest extends CookieProTest{
    @Test
    public void addMember(){

        //2、点击通讯录，进入到通讯录页面  id="menu_contacts"
        WebElement menu_contacts = webDriver.findElement(By.id("menu_contacts"));//通讯录定位
        menu_contacts.click();

        By addMemberButon = By.linkText("添加成员");
        ////*[@class='ww_operationBar']/a[text()='添加成员']
//        By addMemberButon = By.xpath("//*[@class=\"ww_operationBar\"]/a[text()=\"添加成员\"]");

        //显示等待 等待元素可被定位
        WebDriverWait wait = new WebDriverWait(webDriver, Duration.ofSeconds(30));
        wait.until(ExpectedConditions.elementToBeClickable(addMemberButon));
        webDriver.findElement(addMemberButon).click();

        //判断对应点击添加成员是否成功
        By username1 = By.name("username");
        wait.until(ExpectedConditions.elementToBeClickable(username1));

        //添加姓名：霍格
        String name = FakerUtil.get_name();
        WebElement username = webDriver.findElement(username1);
        username.clear();
        username.sendKeys(name);

        //添加账号：20220703171223
        String acctid1 = FakerUtil.get_acctid();

        WebElement acctid = webDriver.findElement(By.name("acctid"));
        acctid.clear();
        acctid.sendKeys(acctid1);
        //添加邮箱：20220703171223

        WebElement mail = webDriver.findElement(By.xpath("//*[@name=\"biz_mail\"]"));
        mail.clear();
        mail.sendKeys(acctid1);

        //添加手机号：
        String phone = FakerUtil.get_phone();
        WebElement memberAdd_phone = webDriver.findElement(By.id("memberAdd_phone"));
        memberAdd_phone.clear();
        memberAdd_phone.sendKeys(phone);
        
        //搜索刚刚添加的用户
        By memberSearchInput = By.id("memberSearchInput");
        driver.findElement(memberSearchInput).sendKeys(account);
        //结果断言 用户名 用户手机号
    }
}
```

```java
//搜索刚刚添加的用户
By memberSearchInput = By.id("memberSearchInput");
webDriver.findElement(memberSearchInput).sendKeys(name);
//显示等待页面加载出来删除
wait.until(ExpectedConditions.elementToBeClickable(By.linkText("删除")));

String userName = webDriver.findElement(
        By.cssSelector(".member_display_cover_detail_name")).getText();
String mobile=webDriver.findElement(
        By.cssSelector(".member_display_item_Phone .member_display_item_right")).getText();

//结果断言 用户名 用户手机号

assertAll(()-> assertThat(name,equalTo(userName)),
          ()-> assertThat(mobile,equalTo(phone)));
```


### 错误用例
```java
    @Test
    public void addErrorMember(){

        //2、点击通讯录，进入到通讯录页面  id="menu_contacts"
        WebElement menu_contacts=webDriver.findElement(By.id("menu_contacts"));//通讯录定位
        menu_contacts.click();

        //显示等待，页面真正的有 添加成员 这个元素
        //3、
        By addMemberButon=By.linkText("添加成员");
        ////*[@class='ww_operationBar']/a[text()='添加成员']
//        By addMemberButon = By.xpath("//*[@class=\"ww_operationBar\"]/a[text()=\"添加成员\"]");

        //显示等待 等待元素可被定位
        WebDriverWait wait=new WebDriverWait(webDriver,Duration.ofSeconds(30));
        wait.until(ExpectedConditions.elementToBeClickable(addMemberButon));
        webDriver.findElement(addMemberButon).click();

        //判断对应点击添加成员是否成功
        By username1=By.name("username");
        wait.until(ExpectedConditions.elementToBeClickable(username1));

        //添加姓名：霍格
        String name=FakerUtil.get_name();
        WebElement username=webDriver.findElement(username1);
        username.clear();
        username.sendKeys(name);

        //添加账号：20220703171223
        String acctid1=FakerUtil.get_acctid();

        WebElement acctid=webDriver.findElement(By.name("acctid"));
        acctid.clear();
        acctid.sendKeys(acctid1);
        //添加邮箱：20220703171223

        WebElement mail=webDriver.findElement(By.xpath("//*[@name=\"biz_mail\"]"));
        mail.clear();
        mail.sendKeys("gegai");

        //添加手机号：
        String phone=FakerUtil.get_zh_phone();
        WebElement memberAdd_phone=webDriver.findElement(By.id("memberAdd_phone"));
        memberAdd_phone.clear();
        memberAdd_phone.sendKeys(phone);
		
```

```
        //点击保存
        webDriver.findElement(By.linkText("保存")).click();

        String text=webDriver.findElement(By.xpath(
        "//*[contains(text(),\"@tester18.wecom.work\")]/following-sibling::div")).getText();
        System.out.println(text);
        assertThat(text,containsString("该企业邮箱已被"));

        }
```


# PO设计模式

我们随着脚本的增多，也逐渐发现，传统的这种写法，它会存在一些弊端：大量的find方法，而页面元素的细节和断言揉在了一起；并且元素一旦发生变更，后期维护的难度和成本非常大。 另外，我们可以很明显看到，作业1的通讯录页面添加成员，和之前的首页添加成员的之间，就只有一行代码之差，却又重写了一份。这还只是一两个场景，企业微信的功能多了去了，一想到这里，点点同学的刚露出的笑容，逐渐消失。

这个问题究竟怎么破？ 测试组长仿佛看穿了点点同学的心事，于是告诉他了一个优化方案：那就是使用PO设计模式，编写测试用例。

那，传说中的PO设计模式，究竟是什么东西呢？

## 概念

PO模式，是指 Page Object Model，也可以称为POM。它是一种设计模式/原则，而不是框架，注意区分。

> 说到概念，就绕不开这两篇文档。一个是PO思想的提倡者，Martin Fowler的博客；还有一个是Selenium的官方文档。 大家有时间的时候，不妨仔细阅读一下。相信会有不错的体会。

这一块在录播课程中有详细的介绍。所以今天，我们换一个方式，结合图画，来理解这个抽象的PO思想。

我们在这里总结一下，关于PO模式的核心思想： **PO模式核心思想是：封装。将一个web页面，封装成一个独立的类Class。** 展开来说，学过面向对象编程的同学应该知道，Java中的一个类，主要包含两个组成要素，一个是**属性**，一个是**方法**。 属性就包括类属性、成员属性；方法，就包括初始化方法、成员方法、类方法和静态方法。

我们以企业微信的首页这个页面为例，看看如何进行面向对象的封装。 ![](https://cdn.nlark.com/yuque/0/2022/jpeg/22693797/1652587426398-83a280aa-a429-4063-9822-7bc0efd04a97.jpeg) 因此，对于一个web页面，我们可以将页面元素，封装成类的属性；将页面提供的交互功能，比如登录，提交表单，获取列表数据，封装成类的方法。

OK，道理我们懂了，还是有点抽象。那么它和我们之前写的，传统的自动化脚本，到底区别之处在哪儿呢？

点点同学之前写的脚本，页面元素、操作和测试断言，全部写在一个测试用例中。那么PO模式的脚本，总体分成两个部分，一个是**页面类**，一个是**测试类**。

## 原则

-   属性意义
    
    -   不要暴露页面内部的元素给外部
        
    -   不需要建模 UI 内的所有元素
        
-   方法意义
    
    -   用公共方法代表 UI 所提供的功能
        
    -   方法应该返回其他的 PageObject 或者返回用于断言的数据
        
    -   同样的行为不同的结果可以建模为不同的方法
        
    -   不要在方法内加断言
        

#### （1）不要暴露页面内部的元素给外部

不要暴露很多细节，我们的这个方法内是可以有细节的，但是方法它一定是一个接口的形式。这些网页上的元素，抽象成PageObject的属性，在python中，我们可以设置成内部属性，通常属性名称前，用一个或者两个下划线开头，表示这是非公开的属性。

#### （2）不要建模UI内的所有元素

我们不要把页面中的每个元素进行建模，如果说这个页面中有非常多的功能，同样可能有几千上万个页面元素。如果为整个页面都去建一个模，这样会非常的繁琐复杂，是很不现实的。我们要学会挑重点，只需要为重要的元素进行建模就好了。

#### （3）用公共方法代表UI所提供的功能

我们公共方法应该去代替一个页面的服务，这个怎么理解呢？我们以登录场景为例，在登陆页面通常需要填写用户名，密码，然后点击登录，甚至有的还需要填写验证码。那么我们只需要让登录页面，提供一个登录方法，例如叫login()，然后具体如何去输入用户名、输入密码、点击登录的动作封装在其中，后面我们只需要调用login()方法就可以实现登录。

#### （4）方法应该返回其他的PageObject，或者返回用于断言的数据

这个是什么意思呢？这个指的是我们页面的公共方法的返回值。在我们的web自动化测试过程中，当一个页面进行了一些操作之后，通常会跳到其他的页面，比如登录页面登录成功后，通常会跳到系统的欢迎页，或者首页。这就是一个典型的页面跳转。那么如果说，这个场景已经执行完毕了，我们需要获得一些页面的反馈信息，用来帮助我们判断当前页面是否正确展示了对应的元素信息，那么就可以暴露一个返回元素信息的方法，这就是所讲的，方法可以返回用于断言的数据。。

#### （5）同样的行为，不同的结果可以建模为不同的方法

一个页面可能会有相同的动作，还是以登录为例，有时候我们需要测试登录成功，也要测试登录失败，那么就要封装成两个不同的方法，两个方法分别代表登录成功和登录失败，而不是写在一个方法里。一个方法只代表一种特定结果。

#### （6）不要在方法内加断言

这个原则要求我们，将页面功能和测试用例解耦，断言是测试用例该做的时候，一定要和业务逻辑分开。不能写在一起。


## 优化
- 提取公共方法
- 定位提取
- 方法进行参数化

