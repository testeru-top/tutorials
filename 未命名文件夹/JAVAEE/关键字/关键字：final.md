# 关键字：final
## 概念
首先`final`翻译过来就是：最终的;
它是一个修饰符，用在不同的地方作用不同，但是本质又很相似。

它可以用来修饰一下几种：
- 类
    - 不可被继承
- 方法
    - 不可被子类覆盖
- 变量
    - 不可被重新赋值「这个最难」

具体说明：
>当final修饰的时候代表这个内容是不可以被继承的，就是当前是什么样子就最终是什么样子了。


## 为什么学final
前面学了继承，但是对应的继承还是有弊端的。它打破封装性，就是我们本来封装好的方法或者类，如果被继承了，就可以重写对应的类里面方法的实现逻辑了。这样就会有一个问题，如果恶意继承某个类并进行不正确的覆盖，那会导致原来的功能错误

比如说，下面这个是一个父类，对应实现了一个sleep()方法
```java
public class Animal {
    public void sleep(){
        System.out.println("父类Animal的sleep方法...");
    }
}
```
下面是一个子类，继承了上面的Animal类后重写了对应的sleep()方法，那么在创建实例并调用sleep()的时候，真正方法的实现就是子类Dog里面的sleep()方法实现，而非父类Animal的sleep()方法的实现内容。
```java
//子类
public class Dog extends Animal {
    public void sleep(){
        System.out.println("子类Dog的sleep方法...");
    }
}
```

进行对应的测试验证：
```java
public class FinalTest {
    public static void main(String[] args) {
        Dog dog = new Dog();
        dog.sleep();
    }
}
```
测试代码实际最后运行的是子类Dog的sleep()方法。
![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202202161547640.png)
## final修饰类
**修饰的类不可以被继承。**

`final`用来修饰一个类的时候，代表这个类不能被其他的类继承 `extends`；不能再对这个类进行改变
- 比如`java`源码里面的 `String类` `System类` `StringBuffer类` 
- java不允许别人去扩展这个String类或者重写这个类，如果想要重写这个类是不可以的

- final 修饰的类==不能有子类==，但是==可以有父类==


![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202201261111789.png)

回到上面的例子，如果想要父类的实现内容不被重写，则直接在父类声明上添加对应的final关键字，代码如下：
```java
//public class Animal {
//被final修饰的类不能被继承 Animal这个类就不能被其他的类extends
public final class Animal {
    public void sleep(){
        System.out.println("父类Animal的sleep方法...");
    }
}
```
![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202202161548865.png)
对应Dog类就无法进行继承，直接就是新的一个类进行重新编写。
```java
//public class Animal extends Animal {
//被final修饰的类是不可以被继承的 Animal不能被Dog继承
public class Dog {
	//重新一个类的方法
    public void sleep(){
        System.out.println("Dog的sleep方法...");
    }
}
```

### 总结
-   被`final`修饰的类是==不能被继承的==
-   `final`修饰的类==可以继承其他类==

## 修饰方法
**修饰的方法不可被覆盖。**

>`final`用来修饰方法的时候，表示这个方法不能被重写，代表这是这个方法最终的一个形式

- 比如`java`里面的`Object`类「是所有类的父类」，它其中的`getClass()`方法就是`final`修饰的

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202201261128113.png)

### 修饰构造方法
- `final`修饰构造方法会直接报错
	- 因为`final`不能修饰构造方法

>别的方法可以正常覆盖，但是构造方法不同，构造方法必须和类名一致，就无法直接覆盖；「子类也没有诉求说去覆盖父类的构造方法」
所以final放在构造方法上也没有意义。 

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202202161550262.png)

```java
//被final修饰的类不能被继承 Animal这个类就不能被其他的类extends
//public class Animal {
public final class Animal {
  public void sleep(){
    System.out.println("父类Animal的sleep方法...");
  }
  //final修饰构造方法直接报错
  public final Animal() {
  }
}
```

### 修饰一般方法

想要继承父类但是对应方法又不想被重写，则在不想重写的方法使用`final`关键字进行修饰。
```java
public class Animal {
    //对应方法不想重新实现，直接在方法上添加对应final
    public final void eat(){
        System.out.println("父类Animal的eat方法...");
    }
    public void sleep(){
        System.out.println("父类Animal的sleep方法...");
    }
    //final修饰构造方法直接报错
    public /*final*/ Animal() {
    }
}
```

对应子类的实现方法则会报错，报错信息如下图：
![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202201271447048.png)



所以子类对应的eat()方法进行注释掉，然后重写sleep()是没问题的
```java
public class Dog extends Animal {
    //因为Animal类中的eat方法被final修饰，所以在子类Dog 中无法进行重写
    /*
    public void eat(){
        //父类的eat方法被覆盖了
        System.out.println("子类Dog的eat方法...");
    }
    */
    // 没有使用final修饰的方法可以重写
    public void sleep(){
        System.out.println("子类Dog的sleep方法...");
    }
}
```

### 总结
- 子类无法重新加载final修饰的方法

- 不要随便定义final方法，可能会带来很多不必要的问题
>如果父类有些行为就很确定，不会进行更改，那该行为的方法可以使用final修饰



## 修饰变量
**修饰的变量是一个常量，只能被赋值一次。**
final 修饰变量，这个时候变量就叫常量了。

如果再次赋值，则对应代码报错，提示我们该变量不能被final修饰

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202201261142860.png)


正常声明的变量可以被再次赋值，只有final修饰的变量不能被再次赋值
```java
int age = 26;
age = 33;
System.out.println("年龄是："+age);
//final修饰的变量
final int number = 6;
//        number = 9;//java: 无法为最终变量number分配值
System.out.println("对应礼品个数是："+number);
```

### 赋值位置
>final修饰变量的时候对应的赋值位置「就是初始化变量」有以下3种：
#### 显示初始化
#### 代码块中初始化
#### 构造器中初始化

### 一般成员变量
首先第一个我们先来看一下对应的`final`修饰一般成员变量，这个就有2种赋值方式：

#### 直接赋值「显示初始化」
第一种是`直接赋值`，就是在声明的时候，直接对声明的成员变量进行赋值操作，也叫做显示初始化。

```java
package top.testeru.keywords.finalp;

//被final修饰的类不能被继承 Animal这个类就不能被其他的类extends
public class Animal {
//public final class Animal {

    //对应名称
    private String name;
    private int sex = 1;//0代表公，1代表母
    //多大
    private int age;

    //对应方法不想重新实现，直接在方法上添加对应final
    public final void eat(){
        System.out.println("父类Animal的eat方法...");
    }
    public void sleep(){
        System.out.println("父类Animal的sleep方法...");
    }

    //final修饰构造方法直接报错
    public /*final*/ Animal() {
    }

    public Animal(String name, int sex, int age) {
        this.name = name;
        this.sex = sex;
        this.age = age;
    }
}
```

- 对应`sex`变量用`final`修饰后，表示该变量不可被重新赋值，所以构造方法中对应`sex`变量赋值会报错，解决方案就是把红框内代码删除就好了

>构造方法删掉该参数传入

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202201271519126.png)

```java
public class Animal {
    //对应名称
    private String name;
    private final int sex = 1;//0代表公，1代表母
    //多大
    private int age;
    //对应方法不想重新实现，直接在方法上添加对应final
    public final void eat(){
        System.out.println("父类Animal的eat方法...");
    }
    public void sleep(){
        System.out.println("父类Animal的sleep方法...");
    }

    //final修饰构造方法直接报错
    public /*final*/ Animal() {
    }

  /*  public Animal(String name, int sex, int age) {
        this.name = name;
        this.sex = sex;
        this.age = age;
    }*/
  
    public Animal(String name, int age) {
        this.name = name;
        this.age = age;
    }
}
```


#### 构造方法赋值「构造器中初始化」

-   也可以直接声明成员变量，然后在对应的构造方法内赋值，也是只有一次，在每一次进行构造声明的时候进行赋值。
-   可以声明多个对象，进行多个赋值，只不过对应对象不同，对应内存地址也不同

```java
public class Animal {
    //对应名称
    private String name;
    private final int sex = 1;//0代表公，1代表母
    //多大
    private final int age;
    //对应方法不想重新实现，直接在方法上添加对应final
    public final void eat(){
        System.out.println("父类Animal的eat方法...");
    }
    public void sleep(){
        System.out.println("父类Animal的sleep方法...");
    }

    public Animal(String name, int age) {
        this.name = name;
        //构造函数初始化的时候进行一次赋值，后期无法再次进行更改
        this.age = age;
    }
}
```

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202201271524928.png)

验证的代码

```
Animal animal1 = new Animal("小黑",2);  
System.out.println(animal1);  
Animal animal2 = new Animal("小白",3);  
System.out.println(animal2);
```

运行的结果：

```
Animal{name='小黑', sex=1, age=2}
Animal{name='小白', sex=1, age=3}
```

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202202161651143.png)

#### 总结：
以上2种声明只能用其中一种，而且必须用2种的其中一个给它进行赋值，不然也是会报错。「不赋值会报错」

>final 就是过了这个村就没这个店了，所以你一定要在构造方法里赋值，并且只赋值一次。

### 静态成员变量
`final`修饰静态成员变量，这个有2种赋值方式：
#### 直接赋值「显示初始化」

第一种是`直接赋值`，就是在声明的时候，直接对声明的静态成员变量进行赋值操作，也就是显示初始化。
```
//和成员变量一样，一定要赋值并且只赋值一次
//动物最长的寿命 60年
static final int MAX_AGE = 60;
```

#### 在static代码块赋值「代码块中初始化」
```
//动物最短寿命1 年
static final int MIN_AGE;
//只能赋值一次，而且必须要赋值一次
static{
    MIN_AGE = 1;
}
```

- 在其它的方法里面赋值是不可以的

>调用的时候是直接使用`类名.变量名`进行静态变量的调用

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202202161656682.png)

#### 总结
>这个时候只要赋值的地方不是静态代码块内，无论你在哪个方法内添加对应的赋值，在声明变量的那一行都会报错，因为它会认为你都没有给我去赋值



### final修饰形参

>final修饰对应形参的时候，说明这个形参是一个常量。当我们调用这个方法的时候，给常量形参赋上一个实际的参数值。

>注意⚠️：形参被修饰后，在方法内实现业务逻辑代码中，无法再对该形参进行重新赋值，只能调用该参数。

形参也是==只能赋值一次==，在调用`类的.方法`的时候传入对应值。

```
public void sleep(final int time){
	System.out.println("大概几点开始睡觉："+ time);
//        time = 0;
	System.out.println("父类Animal的sleep方法...");
}
```

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202201271625387.png)


>形参一旦赋值了以后，就只能在方法体内使用这个形参，但是不能进行重新的赋值。
### final修饰局部变量
#### 直接赋值「显示初始化」
直接赋值就是在声明的时候，直接对声明的局部变量进行赋值操作，也就是显示初始化。


```
public void sleep(final int time){
    System.out.println("大概几点开始睡觉："+ time);
//        time = 0;
    //一般局部变量
    String selfHouse = "米小圈的家";
    selfHouse = house();

    final String otherHouse = "动物之家";
    //赋值后无法进行再次赋值的业务逻辑
    otherHouse = house();

    System.out.println("父类Animal的sleep方法...");
}
private String house(){
    return "My House";
}
```

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202201281511869.png)

#### 调用时赋值
```
  public void sleep(final int time){
      System.out.println("大概几点开始睡觉："+ time);
//        time = 0;
      //一般局部变量
      String selfHouse = "米小圈的家";
      selfHouse = house();

      final String otherHouse = "动物之家";
      //赋值后无法进行再次赋值的业务逻辑
      otherHouse = house();
      
      //final修饰声明的局部变量直接声明，在后面调用的时候赋值
      final String otherHouse1;
      otherHouse1 = house();

      System.out.println("父类Animal的sleep方法...");
  }
  private String house(){
      return "My House";
  }
```


### 什么时候修饰变量？
在程序中一些不会发生变化的数据，就是常量，比如：3.14。
直接写的时候代码复用性不高，也不利于阅读，所以一般就会给这个常量数据起一个相对容易阅读的变量名。

```java
final double PI = 3.14;
```

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202201271451665.png)

- static final 
    - 修饰属性：全局常量
    - 修饰方法「很少用，可用」
    - 这2个关键字不冲突
- abstract final
    - 关键字冲突

    
final 有一个引用 纸上的内容可以擦了再写擦了再写，但是纸对应的地址，是第几张纸，这个是不可以进行更改的


## 应用
### 单例模式-饿汉式
    
```java
package top.testeru.keywords;

/**
 * @Package: top.testeru.keywords
 * @author: testeru.top
 * @Description: 单例模式,饿汉式【工作中常用】
 * 类加载的时候就创建对象
 * @date: 2022年01月26日 1:58 PM
 */
public class Single {
    //1.私有化构造函数
    private Single() {}
    //2.创建一个私有并且静态的本类对象
    private static final Single s = new Single();
    //3.创建一个公共的static方法返回该对象
    public static Single getInstance(){
        return s;
    }

    void show(){
        System.out.println("这是单例的一个方法");
    }
}

```


```java
package top.testeru.keywords;

/**
 * @Package: top.testeru.keywords
 * @author: testeru.top
 * @Description:
 * @date: 2022年01月26日 2:06 PM
 */
public class SingleTest {
    public static void main(String[] args) {
        Single single = Single.getInstance();
        single.show();
    }
}

```
    

## final面试题
### 题目一
```java
public class FinalInterView {
    public int add(final int x){
        //return ++x;//编译报错，相当于给x重新赋值
        return x+1;
    }
}
```
- ++x 相当于给x进行了重新赋值，对应的编译就会报错
- x+1 x对应的值不更改，只是返回x+1后的结果
- 只要x的值不变




### 题目二

```java
public class FinalInterView {
    public static void main(String[] args) {
        Other o = new Other();
        new FinalInterView().addOne(o);
    }
    private void addOne(final Other o) {
//        o = new Other();//o传入过来的就是一个不变的对象，不能重新new
        System.out.println(o.i+6);//虽然o这个对象不能变了但是这个对象的一些属性和方法是可以变的
        //比如说，我选中了你是我一辈子的朋友，但是你的一些工资收入以及年龄大小这些属性和工作内容的方法是可以进行变化的
    }
}
class Other{
    public int i;
}
```
![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202201261424142.png)





# 商场货品「进阶」
```java
public class Merchandise {

    //商品名称
    public String name;
    //商品ID
    public String id;
    //商品数量
    public int count;
    //商品售价
    public double soldPrice;
    //商品实际购买价格
    public double purchasePrice;


    public Merchandise(String name, String id, int count, double soldPrice, double purchasePrice) {
        this.name = name;
        this.id = id;
        this.count = count;
        this.soldPrice = soldPrice;
        this.purchasePrice = purchasePrice;
    }
}
```
## 手机
```java
public class Phone extends Merchandise{
    //todo： final修饰成员变量看看
    //修饰成员变量赋值有2种方式，一个是在构造方法里面进行赋值，一个直接在声明的时候进行赋值
    //这两种只能用其中一种，而且必须用2种的其中一个给它进行赋值，不然也是会报错
    //private final double screenSize = 8.5;
    //屏幕大小，分辨率
    private double screenSize;
    //8G
    private int memoryG;
    //256G
    private int storageG;
    //手机品牌
    private String brand;
    //手机系统
    private String os;

    public Phone(String name, String id, int count, double soldPrice, double purchasePrice,
                 double screenSize, int memoryG, int storageG, String brand, String os) {
        super(name, id, count, soldPrice, purchasePrice);
        this.screenSize = screenSize;
        this.memoryG = memoryG;
        this.storageG = storageG;
        this.brand = brand;
        this.os = os;
    }
}
```

### 安卓手机
```java
public class AndroidPhone extends Phone{

    private boolean enableColorChange;

    public AndroidPhone(String name, String id, int count, double soldPrice,
                        double purchasePrice, double screenSize, int memoryG,
                        int storageG, String brand, String os, boolean enableColorChange) {
        super(name, id, count, soldPrice, purchasePrice, screenSize, memoryG, storageG, brand, os);
        this.enableColorChange = enableColorChange;
    }
}

```
## final修饰类
- 如果对应Phone类被final修饰，则AndroidPhone报错
    - 被final修饰的类是不能被继承的
    - final修饰的类可以继承其他类
## final修饰一般成员变量
- 修饰一般成员变量赋值有2种方式:
    - 一个是在构造方法里面进行赋值

    ```java
    public Phone(..., double screenSize, ...) {
            ...
            this.screenSize = screenSize;
            ...
    }
    ```

    - 一个直接在声明的时候进行赋值;构造方法删掉该参数传入
    ```java    
    private final double screenSize = 8.5;
    
    public Phone(String name, String id, int count, double soldPrice, double purchasePrice,
                 int memoryG, int storageG, String brand, String os) {
        super(name, id, count, soldPrice, purchasePrice);
        this.memoryG = memoryG;
        this.storageG = storageG;
        this.brand = brand;
        this.os = os;
    }
    ```
- 这两种只能用其中一种，而且必须用2种的其中一个给它进行赋值，不然也是会报错

- final 就是过了这个村就没这个店了，所以你一定要在构造方法里赋值，并且只赋值一次

## final修饰静态成员变量

- 修饰静态成员变量赋值有2种方式:
    - 一个直接在声明的时候进行赋值
    ```java
     //和成员变量要求一样，一定要赋值，且赋值一次，赋值有2种：一种就是在声明的时候直接赋值
     //一次最多购买的数量
    private final static int MAXNUM_BUY_ONEORDER = 5; 
    ```
    - 直接在static代码块里面赋值；在其它的方法里面是不可以的
    ```java
    //一次订单最少购买的数量
    private final static int MINNUM_BUY_ONEORDER;
    //第二种：直接在static代码块里面赋值
    //只能赋值一次，而且必须要赋值一次
    static {
        MINNUM_BUY_ONEORDER = 1;
    }
    ```
    
>这个时候只要赋值的地方不是静态代码块内，无论你在哪个方法内添加对应的赋值，在声明变量的那一行都会报错，因为它会认为你都没有给我去赋值

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202201261704595.png)

>总结：静态成员变量「final static」必须要赋值；
> 2种方式，一种声明的时候赋值；一种static代码块
## final修饰构造方法
会直接报错，因为final不能修饰构造方法
![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202201261715152.png)
>别的方法可以正常覆盖，但是构造方法不同，构造方法必须和类名一致，就无法直接覆盖；「子类也没有诉求说去覆盖父类的构造方法」所以final放在构造方法上也没有意义

## final修饰方法
>和修饰类有一些类似，说明这个方法不可以被子类覆盖，代码如下截图

- 不要随便定义final方法，可能会带来很多不必要的问题

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202201261732118.png)

>如果父类有些行为就很确定，不会进行更改，那该行为的方法可以使用final修饰

## final修饰形参
- 对应形参在方法内实现业务逻辑的时候不能再被赋值
- 只有在调用该方法传参的时候才能被赋值

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202201261744643.png)

## final修饰局部变量

```java
final double cost = 0;
cost = super.buy(count);
```
- final 修饰局部变量，如果声明的时候已经给该局部变量赋值，那么在后面写对应的业务逻辑的时候，对应的局部变量不能再次被赋值。


完整代码demo：
```java
    // todo:  final 修饰方法
    // todo:  final 修饰形参
    public /*final*/ double buy(final int count) {
        System.out.println("Phone里的buy(int count)方法");
        if (count > MAXNUM_BUY_ONEORDER) {
            System.out.println("购买失败，该手机在一个订单内填写的数量最多为" + MAXNUM_BUY_ONEORDER + "个");
            return -2;
        }
        //对应形参在方法内实现业务逻辑的时候不能再被赋值
//        count = 88;
        //todo： final修饰局部变量
        /*
        final double cost = 0;
        cost = super.buy(count);
         */
        final double cost;
        cost = super.buy(count);
        return cost;
    }
```

## final修饰引用对象的成员变量

```java
private final Merchandise gift;

```

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202201271150693.png)

final 有一个引用 纸上的内容可以擦了再写擦了再写，但是纸对应的地址，是第几张纸，这个是不可以进行更改的