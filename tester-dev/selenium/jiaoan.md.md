
# 开场白

同学们下午好！我是今天的主讲老师：盖盖。欢迎大家参加今天的web自动化测试实战！<br />非常高兴又和大家又见面了！

- [x] web自动化测试的专题的录播课内容还是挺多的，录播视频基本看完的同学，给我一点反馈，帮忙在讨论区上扣个1

当然了，没看完的同学也不要紧，先跟上今天的实战课程。如果遇到不熟悉的知识点，课后记得找时间再补回来。


OK，我们正式进入今天的课程。

---

# 课程目录

首先，介绍下本期课程的安排。

一共分为两节课，今天是第一节，注重基础；下节课在7月10号，注重PO设计模式。

这2次直播课内容是围绕企业微信产品，带领大家复习目前学过的web自动化知识。<br />然后进行用例分析，并且根据特定的业务场景，留出一部分时间给大家进行课堂练习，编写实战脚本。<br />最后，我再来讲解下具体的web自动化代码实现。

下节课，会略微增加一点难度，将在今天课程代码的基础上，进行一系列的优化，重点是PO设计模式。



# 产品介绍
那么刚刚可能已经剧透了对吧，今天我们选用的知名产品就是企业微信了。<br />它是一款非常强大的企业通讯与办公工具，拥有非常丰富的OA应用。

那为什么选择企业微信呢？主要有两点原因。

第一点是，企业微信产品非常成熟，并且UI界面相对稳定，复杂度适中，非常适合web自动化练习。
企业微信是一款符合大厂流程规范的`app`，对应的业务流程审批及打卡都很规范，而且，每个人都可以创建属于自己的企业，不需要认证。所以，我们选用这一款来进行UI自动化演示。


第二点是，企业微信的终端支持非常全面，不仅有web端，而且还有app，并且它的接口文档也是非常完备。因此非常适合用来作为全流程的实战训练。<br />基本上面面俱到，这样大家就可以围绕一款产品，来模拟真实的工作中遇到的各类自动化测试场景，做到一站式的练习。

同时，这里需要大家提前准备一下企业微信的测试账号，是可以免费注册的。过程非常简单，具体步骤在这里就不赘述了。<br />如果没有用过这款产品的同学呢，可以先听课，稍后再课堂练习的时间注册测试账号即可。

---

那么，产品和业务场景我们都见识过来，气氛已经烘托到这里了，欸，我们又到了喜闻乐见的环节了，讲个故事对吧。我们来聊聊一个关于点工成长历程的故事。
# 第一回：点点点


话说，我们今天的主人公，当然是虚拟的了，是一位十分辛苦的点工，刚好负责的项目正是企业微信web端的测试，每天的工作呢自然是点点点了。因此江湖人称点点。

OK，我们来看看点点最近在忙啥，他最近的任务刚好就是，测试企业微信通讯录的添加成员功能。具体怎么个功能呢？就是这样点的，先来打个样。

【演示】手工场景：演示手工执行添加企业微信通讯录的场景
```
功能测试场景：企业微信添加成员（web端）

1. 登录
2. 点击添加成员按钮
3. 填写成员信息
4. 查看结果

```

好，那我们来分析看看，他的手工测试，也就是功能测试的过程。
# 用例设计：手工测试
这张时序图中，一共有两个参与角色，一个是测试工程师，一个是我们的被测web页面。

那在功能测试的过程当中，第一步，是由我们的测试工程师对我们的被测系统的页面做一些点击或者输入等等类型的一个操作。<br />那这时候系统的交互操作，会产生一定的页面的响应。也就是我们的第二步，页面响应。<br />然后，第三步，我们的测试工程师，要拿到这个系统运行的这个响应，那也就是它的一个实际结果，和我们测试用例当中编写的一个预期结果去做一个对比。那这个是我们功能测试的一个场景，非常的简单。


- 痛点

就这样日复一日，我们的点点同学发现心好累，每次不管是迭代需求，还是回归测试，都要来回点点点，没完没了，日子啥时候是个头。

那么问题点来了，又苦又累，没有技术含量，意味着没有竞争力，容易怎么样？喜提毕业对吧。

【互动】从点点同学的这个处境中，或多或少，有没有看到自己当年，或者是现在的影子？<br />如果有感同身受的同学，可以扣波1。

- 对策

那究竟怎么突破这个瓶颈呢，答案就是，使用UI自动化测试技术对吧。

# 第二回：UI自动化测试

那，说到UI自动化，难免经常会听到吐槽说，UI自动化存在执行效率越低，成本又高啊之类的。

就像这张图中所示，UI 和接口测试，还有单元测试一个对比。<br />乌龟和兔子，表示的是效率由低到高；这里的美元符号和欧元符号，则表示的是成本由高到低。<br />那其实对比来说，UI相对是效率较低，成本较高的一个阶段。

那么有的同学不禁要问，那为什么UI还会占据这样一个比重，而没有干脆消失呢？或者说，那我们为什么还需要学习UI自动化技术呢？

那是因为，第一点，相对于手工，或者人力测试来说，UI自动化的执行效率则更高。尤其是，通过持续集成的加成，同样可以做到成本更低。所以，这是它的一个用武之处，看问题的角度非常关键。特别是遇到需要频繁回归的场景，还有非常重点的核心业务场景，就非常适合做UI自动化。当然有一个前提，就是UI或者业务流程变动不能太大。

第二点，有些场景，比如说涉及到，如果需要测试浏览器的兼容性，那么这个领域，其实单元测试和接口测试是不能够完成任务的，那么可以通过selenium分布式执行等方式，来很好地实现和满足这样的需求。

那么第三点，就是市场需求。那么测试行业越来越卷对吧，如果没有掌握自动化的相关知识，那么面试官内容毫无波澜。而且，UI自动化中的webdriver，PO思想，都是非常有价值的，绝对是升职加薪，提升职场竞争力的秘诀。<br />就像刚刚说的，点点同学遇到的痛点一样对吧。

所以，以上这些，就是UI自动化的价值所在。

Ok，那么接下来，我们来看看，点点同学要学的技术栈，selenium自动化框架。
# selenium架构（脑图展示）



- 特点

先来说说，Selenium都有什么特点呢：

- **开源，免费**
- **多浏览器支持：Firefox、Chrome、IE**
- **多平台支持：Linux、Windows、Mac**
- **多语言支持：Java、Python、Ruby、Php、C#**
- **对Web页面支持友好**
- **API简单，调用灵活，开发语言驱动**
- **支持分布式测试用例的执行**

那么这些就是选用selenium的理由。

当然可能还有其他的web自动化技术，大家可以根据自己的兴趣了解下，比如Cypress，Airtest等等，都有一些自己的特点。

- 架构图

>我要开门
>我就是写的脚本
>开门需要钥匙或者密码 driver就相当于这个钥匙
>门这个对象就相当于被测的产品

OK，我们回到这张图，这是selenium的基本的架构示意图。<br />这里有3个角色，我们从右往左看，依次是browser表示浏览器、driver表示webdriver，client表示测试脚本。

我们都直到，市面上的浏览器非常多，但是主流的就几种，比如chrome，Firefox火狐，还有微软的IE。那么浏览器是web应用的载体。

那么driver呢，就是表示我们selenium提供的webdriver，它通过浏览器的原生组件，转换web service的命令给浏览器native的调用，从而完成发过来的指令操作。

那么这个web service是哪里来的呢？那就是从我们客户端client这部分来的，也就是源自我们的测试脚本。前面我们提到过，selenium的多语言支持，包括Java、Python、Ruby等等一系列的语言。

- 运行机制

当我们的测试脚本运行后，会打开指定的浏览器；<br />
比如打开的是chrome 浏览器，会使用chromedriver这样的驱动，
这时候，webdriver会将目标浏览器绑定到特定的端口，启动后的浏览器，作为webdriver的远程服务器（相当于经常说的一个概念remote server服务端），持续的接收测试脚本的指令<br />然后，脚本的指令通过CommadExecutor执行器 发送HTTP请求给这个远程服务器remote server。

那么这是selenium的一个运行机制。
比如，要完成一个寻找元素操作，会发送请求给chromedriver ，会发给我们启动的浏览器，然后根据它的定位方式 ，去页面上找它，去解析原码，然后把找到的元素返回，

然后进行后续操作，循环往复

如果没有找到呢？没有登录进去，没有找到添加成员的按钮，就会返回404，（404接口测试中，服务一个通用的响应状态码）


- [x] 那对于selenium的架构和运行机制，能够理解的同学，帮忙扣一个1.

存在有疑问的同学，请随时把问题随时写出来。

当然，这里的知识是非常深奥的，大家先做一个概念性的理解。如果面试时候被问到selenium的机制，就可以按照这样的思路回答即可。


OK，接下来，我们将围绕录播视频所涵盖的selenium自动化的知识，来帮助大家做一个知识回顾。

这里打开一个脑图工具，来捋一捋。大家一定要跟着老师一起，努力回想一下。<br />知识，重在总结归纳，才能易于吸收，最后变成自己成长的营养。
# 知识回顾
开启思维导图。


**IDE**就是常用的可视化集成开发工具，用于录制，回放自动化测试用例。

**Grid**就是分布式，是Selenium支持分布式的关键模块。能够对不同的软件，采取分布式方式运行，在同一时间段运行不同的脚本，对BS结构服务器进行测试，以及支持多台机器上并行运行。

**webdriver则是核心，提供很多的api给我们的测试脚本调用。**


UI自动化=定位元素+操作元素。



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




### **Selenium 中的 iframe 是什么？**

iframe 也称为内联框架。它是 HTML5 中用于在父 HTML 文档中嵌入 HTML 文档的标签。iframe 标签是使用`<iframe></iframe>`标签定义的。 

### **Selenium 中的 frame 和 iframe 有什么区别？**

**框架**使开发人员可以使用框架集标签水平或垂直分割屏幕。

**注意**：Frame 和 frameset 标记已被弃用，因为 HTML 5 不再支持它们。


为了让浏览器自动开始与网页交互，浏览器必须识别框架下的元素以进行[Selenium 测试](https://www.browserstack.com/automate "自动化硒测试")。 

想要定位其中的[iframe]并切进去，可以通过如下代码：

通常采用id和name就能够解决绝大多数问题。但有时候frame并无这两项属性，则可以用index和WebElement来定位：

index从0开始，传入整型参数即判定为用index定位，传入str参数则判定为用id/name定位
WebElement对象，即用find_element系列方法所取得的对象，我们可以用tag_name、xpath等来定位frame对象


## 等待

在运行 Selenium 测试时，测试人员通常会收到消息“ _Element Not Visible Exception_ ”。当 WebDriver 必须与之交互的特定 Web 元素的加载延迟时，就会出现这种情况。为防止此异常，必须使用 Selenium 等待命令。
在自动化测试中，等待命令指示测试执行暂停一段时间，然后再进行下一步。这使 WebDriver 能够检查一个或多个 Web 元素是否存在/可见/丰富/可点击等。

但是，隐式等待会增加测试脚本的执行时间。它使每个命令在恢复测试执行之前等待定义的时间。如果应用程序正常响应，隐式等待会减慢测试脚本的执行速度。**专业提示：** 如果您担心减慢 selenium 测试脚本的速度，**[请查看这 6 件要避免的事情。](https://www.browserstack.com/guide/things-to-avoid-in-selenium-test-scripts "硒提示")**

不要混合使用隐式和显式等待。这样做会导致不可预测的等待时间。例如，将隐式等待设置为10秒，将显式等待设置为15秒，可能会导致在20秒后发生超时。









# 用例设计：自动化测试
那么学了这么多知识，是时候大显身手了。<br />还记得我们之前的手工测试用例吗？那么，再开始编写代码之前，我们需要先梳理下思路，web自动化的测试用例，应该长啥样呢？



那这时候我们来看一下 UI 自动化测试场景。<br />是我们的测试工程师来通过这个编程语言去编写我们自动化测试的一个脚本。然后这个编程语言会调用我们的selenium去执行我们自动化测试的一个脚本。然后这个selenium或者等自动化测试的一个工具，它会在我们的被测系统上面，做一些模拟点击或者输入等等类型操作，然后并会获取自动化运行的一个响应结果。<br />那我们拿到这个系统对应的响应结果之后，会与我们提前设定好的预习结果去做一个对比。<br />那如果对比一致的话，就证明我们的自动化测试是用例通过了。那如果对比失败的话，代表的是我们自动化测试的用例也就失败了？那这个是我们 UI 自动化测试的这样的一个场景。


然后我们来和手工用例对比一下，我们就会发现，角色是发生了一些变化，添加编程语言和selenium这两个角色。<br />那动作是什么？动作以前是测试工程师在系统页面对做点击输入等等类型操作。那现在换成谁？现在换成了我们的编程语言在做这个事情。<br />然后以前是测试工程师拿到实际结果和预期结果去做对比，那现在也换成了编程语言去做这件事情。

- 一样

UI自动化和功能自动化和这个功能测试它的一个过程其实都是一模一样的，都是在对系统页面做点击、输入等操作，并且拿到实际结果和预期结果去做对比对吧？那这一部分是他们一样的地方，

- 不一样

那我们来看他们不一样的地方是什么？以前是由测试工程师直接去对系统发起操作，那现在换成了编程语言。所以说其实 UI 自动化测试和功能自动化测试，从本质上来说他们是一样的，只是说操作的角色从测试工程师换成了编程语言和selenium。

其实理解起来也不难对吧，以前靠我们小手点一点，现在换成代码告诉浏览器点哪里，输入什么内容，判断结果是否则正确对吧。因此，步骤上其实没有变化，还是这些步骤。

```
自动化场景：企业微信添加成员（web端）

1. 登录
2. 点击添加成员按钮
3. 填写成员信息
4. 断言结果  (肉眼查看，变成了assert断言)

```

OK，那么现在就到了练习时间了。

# 实战练习1（30分钟）

题目1：cookie植入，企业微信登录（预备）

实现的效果就是，能够保证首次人工扫码，然后保存cookie到本地文件，最后，其他的测试用例，可以直接读取本地的cookie进行植入，并且成功登录。






## 1. 扫码写入cookie
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

## 2. cookie解读
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



## 3.cookie文件读取登录
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


# 讲解

# 实战练习2（30分钟）

题目2：企业微信添加成员（线性脚本）

# 讲解

最简单代码：
```java


```


成员数据（固定）
```java
"""填写成员信息"""
self.driver.find_element(By.NAME, 'username').send_keys('点点6')
self.driver.find_element(By.NAME, 'acctid').send_keys('1231241241241242124')
self.driver.find_element(By.NAME, 'mobile').send_keys('18033335555')
self.driver.find_element(By.CSS_SELECTOR,'a.qui_btn.ww_btn.js_btn_save').click()
```

- 优化：使用faker造测试数据
```bash
$ pip install faker
```

用法：
```python
# 实例化
fake = Faker('zh_CN')

fake.name()
fake.ssn()
fake.phone_number()
```



技巧：冒泡消息调试<br />F12/Sources

问大家一个问题，目前我们做的足够完美吗？
# 痛点分析

- 大段重复代码
- 无法适应UI的变化


# 课后作业

- 登录成功后，进入通讯录页面，完成添加成员的自动化操作
- 完成添加部门的自动化操作


# 结束语
最后的最后，希望每位同学认真复习，认真做笔记。


---

好的，快乐的时光总是过得飞快，又要到了说再见的时候了。

最后，非常感谢今天的**助教老师**，也非常感谢线上的每一位**同学**的支持，大家的勤奋和努力非常宝贵，希望大家再接再厉，勇攀高峰。

我是霍格沃兹的百里，5月15号的第二节训练营，我们不见不散！

👋    同学们，拜拜！


