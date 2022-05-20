# 关键字：static
（结合Java语言程序设计第12版-9.7）
本篇文章主要讲解static关键字，内容从概述和用法两点来讲解，关于概述大家能理解就可以，用法是它的重点。

## 概念
static翻译过来就是静态的意思
- 静态的
## 作用
- Java中`static`可以修饰==类的成员==

>static既可以修饰对应类里面的==成员变量==，也可以修饰类里面的==方法==。

- 被static修饰的内容就不再属于这个对象了，而是属于这个类。

>static修饰的==成员变量==叫==静态变量==「`static variable`」，也叫类变量「`class variable`」。
>static修饰的方法叫==静态方法==，也叫类方法。

下面👇，我们分别来看一下对应的静态变量和静态方法。
### 静态变量
首先，我们来看一下对应的静态变量。上面介绍的时候说到了，静态变量就是`static`修饰的成员变量。

>无论是我们产生多少个对象，对应某些特定的属性值在内存空间中只有一份，那就是静态变量的属性值。

#### 调用方式
```
类名.静态变量名
```
#### 特点
静态变量「`static variable`」的特点就是==让一个类的所有实例都共享数据==
>被static修饰的内容就不再属于某一个对象了，而是属于类

==变量值存储在一个公共的内存地址==


#### 说明




##### 需求一
- 想要一个类的所有实例共享数据，怎么解决？？

>定义质量控制部类，让每位测试工程师进行自我介绍

效果如图：

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202202151119628.png)
###### 分析
- 质量控制部成员统称为测试工程师，定义类名为`TestEngineer`
- 定义TestEngineer类的每个人普通的属性和行为：

>当我们创建一个实体类的时候，其实就是描述这个实体类的相关属性和行为，属性就是对应的成员变量，行为就是在该实体类中的具体实现的方法，但是没有产生实质性的对象。

>只有通过new关键字来创建的时候，对应的系统才会分配相对应的内存空间给对象，这样该对象的属性和方法才能被外部使用。
```java
package top.testeru.keywords.staticp;

/**
 * @Package: top.testeru.keywords.staticp
 * @author: testeru.top
 * @Description: 定义质量控制部类，让每位测试工程师进行自我介绍
 * @date: 2022年02月15日 10:53 AM
 */
//质量控制部
public class TestEngineer {
    //姓名
    private String name;
    //工作内容
    private String work;
    //部门名
    private String department;
    //成员方法
    //进行自我介绍
    public void selfIntroduction(){
        System.out.println("我是" + getName() +",我的工作是"+ getWork() +",我所属部门是"+ getDepartment());
    }

    public String getDepartment() {
        return department;
    }
    public void setDepartment(String department) {
        this.department = department;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getWork() {
        return work;
    }
    public void setWork(String work) {
        this.work = work;
    }
}
```


- 由上面看到每位测试工程师所属的部门相同，所以属性`department`可以直接在`TestEngineer`中赋值为`质量控制部`
```
private String department = "质量控制部";
```
![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202202151126528.png)

>可以看到对应也是同样的显示效果，但是有一个问题，如果说有成员自己突然修改了部门，对应的两个人就不是同一部门了，这不是我想要的效果。

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202202151128399.png)


- 改造为用`static`修饰`department`变为`静态变量`
「同一个类的所有实例对象的部门归属`department`都是质量控制部」

>静态变量将变量值存储在一个公共的内存地址。

```
private static String department = "质量控制部";
```


- 测试类中创建`TestEngineer`对象并使用

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202202151137752.png)

>可以看到无论是怎么修改，对应的部门会一直是一个统一的

##### 需求二
- 想要修改 类的所有实例共享的数据，怎么解决？？

>公司进行部门名称改革，`质量控制部`改为`测试部`

###### 分析
- 在测试类中直接修改`TestEngineer`对象的静态变量`department`

>因为static变量存放的是公共地址，所以如果修改了某个类的静态变量值，那该类的所有实例的静态变量都会被影响到，即都会被修改

```
TestEngineer.setDepartment("测试部");
```

- 修改了`department`，对应所有人的所属部门都会进行更改。

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202202151141152.png)

#### 注意⚠️
随意修改static修饰的属性有风险，我们一般为了避免风险，会把final和static配合使用，即把==静态变量==变为==静态常量==

```
private final static String department = "质量控制部";
```

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202202151143137.png)


```
//部门名 让大家都能使用到，权限修饰符为public  
//常量命名规则，变量名全部大写  
public final static String DEPARTMENT = "质量控制部";
```

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202202151147648.png)



#### 作用
- 成员变量由对象层级提升为类层级
- 整个类只有一份并被所有对象共享
- static修饰的成员变量随着类的加载准备就绪，与是否创建对象无关

```
//static修饰的成员变量随着类的加载准备就绪，与是否创建对象无关  
System.out.println(TestEngineer.department);  
System.out.println(TestEngineer.DEPARTMENT);
```
![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202202151434056.png)

>可以看到在没有创建对象之前打印对应的部门变量，也是可以打印成功的，对应的有赋值的打印赋值内容；没有赋值的就打印声明类型的默认值

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202202151629072.gif)

### 静态方法
#### 调用方式
```
类名.静态方法名(参数)
```
#### 特点
静态方法「`static method`」的特点：
- ==不能调实例方法或访问实例数据域==，因为静态方法中没有对象this关键字。
```java
public class ReverseList {
    int num1 = 15;
    static int num2 = 22;

    public static void reverse(){
        System.out.println(num1);
    }
}
```
![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202202151514905.png)

>非静态成员必须类创建对应实例对象的时候才能进行访问，而静态方法和静态变量是不需要创建实例对象，在类初始化的时候就可以访问静态的方法和变量了。
> 而且类是优先于对象存在的，所以无法在静态方法里面访问非静态成员变量
- 可以==调用静态方法及访问静态数据域==。
```java
public class ReverseList {
    int num1 = 15;
    static int num2 = 22;

    public void show(){
        System.out.println(num1);
        System.out.println(num2);
    }
    public static void show1(){
        //非静态变量必须是  实例化名.变量名
//        System.out.println(num1);//静态方法不能调用非静态变量
        System.out.println(num2);//静态方法可以调用静态变量
    }
}
```

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202202151526280.png)

因为静态方法和静态数据域不属于某个特定的对象，只属于这个类。

>被static修饰的内容就不再属于某一个对象了，而是属于类

##### 使用场景
首先第一个场景就是==只访问静态成员==的时候就可以使用静态方法了，第二个场景就是==不关心对象的状态，所有需要的参数都由参数列表显示提供==

>当想要调用一个方法的时候，想要通过`类名.方法名`的方式去调用，而不是`实例对象名.方法名`的方式去调用，就可以使用静态方法


#### 说明
##### 需求
-  定义静态方法，反转数组中的元素
```
数组下标 0,1,2,3,4
        1,3,5,7,9
转换：	9,7,5,3,1

```

>[0]和[4]换，[1]和[3]换;下面demo先介绍下对应交换变量的业务逻辑 

```java
public class ReverseListDemo {
    public static void main(String[] args) {
        //交换变量
        int a = 1;
        int b = 2;
        int temp = a;

        //temp=1,a = 1,b = 2
        a = b;//temp=1,a = 2,b = 2
        b = temp;//temp=1,a = 2,b = 1
        System.out.println("a:" + a);
        System.out.println("b:" + b);
    }
}
```


###### 分析

- 先明确定义方法的三要素
	- 方法名： `reverseList`{反转数组}
	- 参数列表：`int[] arrays`
	- 返回值类型：`void`

>这里只需要进行数组反转，不需要返回对象进行其它操作，所以用void当返回值

- 明确需求
	- 遍历数组
		- 在遍历的时候交换数组对应索引
		```
		arrays[i] <=> arrays[arrays.length-1-i]

		[0]       <=>   [4]  

		[1]       <=>   [3]
		```
		-  当`i>=(length-1-i)`时，停止交换

```java
package top.testeru.keywords.staticp;

/**
 * @Package: top.testeru.keywords.staticp
 * @author: testeru.top
 * @Description:
 * @date: 2022年02月15日 3:13 PM
 */
public class ReverseList {
    int num1 = 15;
    static int num2 = 22;

    public void show(){
        System.out.println(num1);
        System.out.println(num2);
    }
    public static void show1(){
        //非静态变量必须是  实例化名.变量名
//        System.out.println(num1);//静态方法不能调用非静态变量
        System.out.println(num2);//静态方法可以调用静态变量
    }
    
    public static void reverse(int[] arrays){
        //非静态方法必须是 实例化名.方法名
        //show(); //静态方法不能调用非静态方法
        show1();//静态方法可以调用静态方法
        /**
         * 交换元素的动作就可以
         * 假设数组元素值为： int[] arrays = [1,2,3,4,5]
         * 明确交换内容：lastIndex = length-1
         *              a                   b
         *          arrays[0]=1  arrays[lastIndex]=5   交换
         *          arrays[1]=2  arrays[lastIndex-1]=4 交换
         *          ...
         *          arrays[i]     arrays[lastIndex-i]  交换
         * 明确交换次数：
         *          length/2
         */
        for (int i = 0; i < arrays.length/2; i++) {
            int temp = arrays[i];
            int lastIndex = arrays.length-1;
            arrays[i] = arrays[lastIndex];
            arrays[lastIndex] = temp;
        }
    }
}
```


```java
package top.testeru.keywords.staticp;

/**
 * @Package: top.testeru.keywords.staticp
 * @author: testeru.top
 * @Description:
 * @date: 2022年02月15日 3:24 PM
 */
public class ReverseListDemo {
    public static void main(String[] args) {
        int[] arrays = {1,2,3,4,5};

        for (int array : arrays) {
            System.out.print(array+",");
        }
        System.out.println("");
        System.out.println("-----开始数组转换-----");
        //开始数组转换
        ReverseList.reverse(arrays);
        for (int array : arrays) {
            System.out.print(array+",");
        }
    }
}
```

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202202151610803.png)


## 总结
static关键字

1. 概念

>理解就可以，知道对应的修饰内容是静态的

2. 作用

>static的作用，可以修饰成员变量也可以修饰成员方法

3. static修饰成员变量的特点

>也就是变量被该类下所有的对象所共享，这是需要我们掌握和会用的

4. static修饰成员方法的特点

>这个方法可以通过`类名.方法名`的形式直接进行调用，并且静态方法是没有this关键字的，所以不能访问非静态成员，这个应用需要我们掌握的，至于概念大家理解就可以

- main方法是static修饰；Math类里面的方法也都是static修饰


```
static用于修饰类的成员：
	成员变量：静态变量、类变量「被类中的所有对象所共享」
	方法：静态方法、类方法「不能访问类中的实例成员-实例数据和方法」
```

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/keywords/202202142213338.gif)


>实体类中new创建的对象分配内存地址在栈区，具体的赋值内容在堆区，静态的成员变量/方法{static修饰}则被放在方法区内
>>
>类刚被加载时，所有类的信息都放在方法区





- ==实例方法==可调用==实例方法==和==静态方法==，访问==实例数据域==或==静态数据域==。
- ==静态方法==可调用==静态方法==，访问==静态数据域==。
-  ==静态方法==不可调用==实例方法==，或者访问==实例数据域==
	- ==静态方法====和==静态数据域==不属于某个特定的对象。