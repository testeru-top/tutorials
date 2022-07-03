# 总结

## 八大元素定位方式

1.  **id**: id属性。
2.  **name**: name属性。
都是由开发定义的，通常都会取不一样的名字，所以定位准确率高，定位速度快。因为用的是css选择器的遍历方式找#id。
3.  **classname**:元素的`class`属性
4.  **tagname**：元素的标签名。
通常会定位到多个元素，所以基本是和findelements连一起来用。

5.  **linktext** : a元素的文本内容。
6.  **partiallinktext**： a元素的部分文本内容。

5、6局限性大，只能用于a元素定位。
### 进阶定位方式：

7.  **xpath**：查询速度慢。但是 对于肉眼感知来说，基本无法感知， 大约是 10~1000ms的差距。根本没有意义。

最大优势：可以使用文本内容，稳定性强，并且可读性最高。

8.  **css selector**： 速度快。 较长的表达式更简洁。

**xpath和css万能。只要html中能看到的元素，就能定位到。Xpath或css选择器定位时，记得先在浏览器中用开发者工具进行校验之后再写进脚本！**
##### css selector比xpath更快的原因

因为xpath是遍历元素进行定位，css 直接是xml样式进行定位

# 企业微信实战
- `cookie.yaml`文件分析，发现里面有两个时间戳。
>对应时间戳转换后，发现第一个时间戳是cookie的获取时间，第二个时间戳是cookie的失效时间。

>为了避免，多次获取cookie，企业微信封账号之类的情况，我们做一个判断，获取当前的时间戳，
> 如果当前时间戳减去最小失效时间小于7200秒，那么我们直接使用cookie文件

## 扫码写入cookie
步骤：
- 1、设置一下全局变量，`Chromedriver`如果没有配置全局变量则会报错
- 2、打开Chrome浏览器
- 3、访问企业微信登录页面
- 4、扫码过程
  - 方式一：强制等待扫码
  - 方式二：显示等待扫码，时间更加灵活 
- 5、扫码后`cookie`保存到本地`yaml`文件


```java
public class WeWorkAuthBaseTest {

    @Test
    void weWorkTest() {
        /**
         *  java.lang.IllegalStateException:
         *  The path to the driver executable The path to the driver executable must be set by the webdriver.chrome.driver system property;
         */
        //1、设置一下全局变量，Chromedriver如果没有配置全局变量则会报错
        System.setProperty("webdriver.chrome.driver", "driver/chromedriver");
        //2、打开Chrome浏览器
        WebDriver webDriver = new ChromeDriver();
        //3、访问企业微信登录页面
        webDriver.get("https://work.weixin.qq.com/wework_admin/frame#index");

        //4、扫码过程
        //方式一：强制等待扫码,无论10秒内是否扫码成功都要等待10秒
//        try {
//            sleep(10000);
//        } catch (InterruptedException e) {
//            e.printStackTrace();
//        }
        //方式二：扫码过程
        //打开浏览器后网址可能会有跳转，获取最新的url地址
        String url = webDriver.getCurrentUrl();
        WebDriverWait wait = new WebDriverWait(webDriver, Duration.ofMinutes(1));
        //一旦扫码完成，url会跳转，跳转后自动停止等待并执行后续的操作
        wait.until(webDriver1 -> !webDriver.getCurrentUrl().equals(url));

        //5、扫码后cookie保存
        //获取扫码后的cookie内容 set集合是一个元素不重复的集合
        Set<Cookie> cookies = webDriver.manage().getCookies();
        //把cookie写入文件，这样什么时候想去拿直接去文件里面拿，不需要去找这个set集合对象
        //写入yaml文件我们需要用到第三方-fasterjson
        ObjectMapper objectMapper = new ObjectMapper(new YAMLFactory());
        try {
            //读取文件是 readValue 写入文件就是writeValue
            objectMapper.writeValue(Path.of("cookies.yaml").toFile(), cookies);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

## cookie解读
- `key`、`value`结构
- 对应每个字段含义：
```yaml
- name: "wwrtx.refid" #cookie的名称
  value: "10349750992271972" #cookie的值
  path: "/" #cookie的存储路径
  domain: ".work.weixin.qq.com" #对应域名路径，只有相同域名才会覆盖cookie，其他域名不会把cookie带过去
  expiry: null #到期时间戳
  sameSite: null #同一站点
  secure: false
  httpOnly: true #只能通过http访问
```
## cookie读取判断时间
- 1、读取`cookie`的`yaml`文件
- 2、从`cookie`里面获取非空的时间戳列表，如果是`null`则不需要关注
- 3、`cookie`使用规则
  - 逻辑：获取到期时间戳
  - （当前时间戳 - cookie获取的时间戳） < 7200s ，可直接使用`cookie`文件
  - 注意⚠️：第一个时间戳为cookie获取的一年以后的时间戳，需要进行计算转换。
```java
public class WeWorkAuthBaseTest {
  @Test
  public void getCookieYaml() {
    //1、读取cookie的yaml文件
    ObjectMapper objectMapper = new ObjectMapper(new YAMLFactory());
    TypeReference<List<HashMap<String, Object>>> typeReference = new TypeReference<List<HashMap<String, Object>>>() {
    };
    List<HashMap<String, Object>> readValue = null;
    try {
      readValue = objectMapper.readValue(Paths.get("cookies.yaml").toFile(), typeReference);
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
    System.out.println(readValue);

    //2、从cookie里面获取时间戳列表 null值忽略
    List<Long> cookieList = new ArrayList<>();
    //获取cookie的时间
    readValue.forEach(stringObjectHashMap -> {
      if (stringObjectHashMap.get("expiry") != null) {
        Long expiry = Long.valueOf(stringObjectHashMap.get("expiry").toString());
        cookieList.add(expiry);
      }
    });
    //3、cookie使用规则
    //获取当前时间戳
    System.out.println(cookieList);
    long now = System.currentTimeMillis();//1656574451000  1659163447000
    System.out.println((cookieList.get(0) - 31536000000L));//获取当前cookie获取的时间戳
    System.out.println((now - (cookieList.get(0) - 31536000000L)));
    if ((now - (cookieList.get(0) - 31536000000L)) / 1000 < 7200) {
      System.out.println("直接使用cookie文件");
    } else {
      System.out.println("扫码保存cookie文件");
    }
  }
}
```



## cookie文件读取登录
```java
public class WeWorkAuthBaseTest {
  //cookie文件登录
  @Test
  public void getCookieLoginTest() {
    /**
     *  java.lang.IllegalStateException:
     *  The path to the driver executable The path to the driver executable must be set by the webdriver.chrome.driver system property;
     */
    //1、设置一下全局变量，Chromedriver如果没有配置全局变量则会报错
    System.setProperty("webdriver.chrome.driver", "driver/chromedriver");
    //2、打开Chrome浏览器
    WebDriver webDriver = new ChromeDriver();
    //3、访问企业微信登录页面
    webDriver.get("https://work.weixin.qq.com/wework_admin/frame#index");

    //打开浏览器后网址可能会有跳转，获取最新的url地址
    String url = webDriver.getCurrentUrl();
    //4、读取cookie的yaml文件
    ObjectMapper objectMapper = new ObjectMapper(new YAMLFactory());
    TypeReference<List<HashMap<String, Object>>> typeReference = new TypeReference<List<HashMap<String, Object>>>() {
    };
    List<HashMap<String, Object>> readValue = null;
    try {
      readValue = objectMapper.readValue(Paths.get("cookies.yaml").toFile(), typeReference);
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
    System.out.println(readValue);
    readValue.stream()
            //过滤企业微信的cookie
            .filter(cookie -> cookie.get("domain").toString().contains("work.weixin.qq.com"))
            .forEach(cookie -> {
              //写cookie到浏览器
              webDriver.manage().addCookie(
                      new Cookie(cookie.get("name").toString(), cookie.get("value").toString()));
            });
    //刷新的时候，浏览器会把新的cookie带到服务器，服务器返回登录后的页面
    webDriver.navigate().refresh();

    //cookie文件进行企业微信登录
    String url2 = webDriver.getCurrentUrl();
    System.out.println(!url2.equals(url) ? "登录成功" : "登录失败");

  }
}
```
## 优化代码
- 1、设置一下全局变量，`Chromedriver`如果没有配置全局变量则会报错
- 2、打开`Chrome`浏览器
- 3、访问企业微信登录页面
- 4、获取当前的`url`地址
- 5、`cookie`判断
  - `cookie.yaml`文件获取失效时间戳
  - `cookie`获取的时间戳：第1个失效时间戳「一年后」 - 31536000000L
  - （当前时间戳 - cookie获取的时间戳） < 7200s 
    - 直接使用cookie文件
    - 否则，扫码获取cookie
- 6、扫码过程
  - 方式一：强制等待扫码
  - 方式二：显示等待扫码，时间更加灵活
- 7、扫码后`cookie`保存到本地`yaml`文件
- 8、扫码后要重新加载`cookie`文件
- 9、写`cookie`到浏览器
- 10、刷新浏览器
- 11、获取浏览器当前的`URL`
- 12、判断输出是否登录成功

```java
public class WeWorkAuthTest {
    @Test
    public void cookieLoginTest(){
        /**
         *  java.lang.IllegalStateException:
         *  The path to the driver executable The path to the driver executable must be set by the webdriver.chrome.driver system property;
         */
        //1、设置一下全局变量，Chromedriver如果没有配置全局变量则会报错
        System.setProperty("webdriver.chrome.driver","driver/chromedriver");
        //2、打开Chrome浏览器
        WebDriver webDriver = new ChromeDriver();
        //3、访问企业微信登录页面
        webDriver.get("https://work.weixin.qq.com/wework_admin/frame#index");
        
      
        //4、打开浏览器后网址可能会有跳转，获取最新的url地址
        String url = webDriver.getCurrentUrl();
        //5、`cookie`判断
        //5.1、获取cookie.yaml的失效时间
        List<HashMap<String, Object>> cookies = readCookieYaml();
        List<Long> cookieList = new ArrayList<>();
        //获取cookie的失效时间
        cookies.forEach(cookie -> {
            if(cookie.get("expiry")!=null){
                Long expiry = Long.valueOf(cookie.get("expiry").toString());
                cookieList.add(expiry);
            }
        });

        //cookie获取的时间戳
        long cookieMills = cookieList.get(0) - 31536000000L;
        //获取当前时间戳
        long now = System.currentTimeMillis();
        if((now - cookieMills)/1000 < 7200){
            System.out.println("直接使用cookie文件-不需要保存cookie");
        }else {
            System.out.println("扫码保存cookie文件");
            //6、扫码过程 7、扫码后`cookie`保存到本地`yaml`文件
            saveCookie(webDriver, url);
            //8、扫码后要重新加载`cookie`文件
            cookies = readCookieYaml();

        }
        cookies.stream()
                //过滤企业微信的cookie
                .filter(cookie -> cookie.get("domain").toString().contains("work.weixin.qq.com"))
                .forEach(cookie -> {
                    //写cookie到浏览器
                    webDriver.manage().addCookie(
                            new Cookie(cookie.get("name").toString(), cookie.get("value").toString()));
                });
        //刷新的时候，浏览器会把新的cookie带到服务器，服务器返回登录后的页面
        webDriver.navigate().refresh();

        //cookie文件进行企业微信登录
        String url2 = webDriver.getCurrentUrl();
        System.out.println(!url2.equals(url)?"登录成功":"登录失败");
    }
    private List<HashMap<String, Object>> readCookieYaml() {
        ObjectMapper objectMapper = new ObjectMapper(new YAMLFactory());
        TypeReference<List<HashMap<String,Object>>> typeReference = new TypeReference<List<HashMap<String, Object>>>() {
        };
        List<HashMap<String, Object>> readValue = null;
        try {
          readValue = objectMapper.readValue(Paths.get("cookies.yaml").toFile(), typeReference);
        } catch (IOException e) {
          throw new RuntimeException(e);
        }
        System.out.println(readValue);
        return readValue;
    }
}
```