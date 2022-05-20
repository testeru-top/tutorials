- int和Integer有什么区别？
- 为什么要有包装类？
- 什么是自动拆装箱？



扩展：
> Java 10 有了局部变量类型推导，可以使用 var 来替代某个具体的数据类型，但在字节码阶段，Java 的变量仍有着明确的数据类型，且局部变量类型推导有着很多限制和不完善之处，也不是目前主流的应用版本，所以这里不做深入讨论。


# 概念
Java 是一种==强数据类型==的语言，因此所有的属性必须有一个数据类型。
>就像山姆超市一样，想要进去购物，先要有一个会员卡才行（刷卡入内）。
>
>`int` 是基本数据类型，`Integer` 是包装类。
## 数据类型

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/collection/202203151655370.png)

- Java 常用数据类型有 2大类：
	- 基本数据类型
	- 引用数据类型

### 基本数据类型
  >基本数据类型有 8 种。
  >其中有 4 种整型、2 种浮点类型、1 种用于表示 Unicode 编码的字符类型 char 和 1 种用于表示真假值的 boolean 类型。

-  **4 种整型**：`int`、`short`、`long`、`byte`   
-  **2 种浮点类型**：`float`、`double`
-   **字符类型**：`char`
-   **真假类型**：`boolean`


基本数据类型是指==不可再分的原子数据类型==，==内存中直接存==储此类型的值，通过==内存地址==即可直接==访问==到数据，并且此内存区域只能存放这种类型的值，**int 就是 Java 中一种常用的基础数据类型**。

#### 常用数据类型
就是基本数据类型的几种：

##### 整数
- 一般声明为 `int` 类型
- 如果值很大，则声明为 `long` 类型

##### 小数
- 常声明为 `double`类型
- 如果声明为float 要在后面加f F

### 包装类

- 在 Java 中每个基本数据类型都对应了一个包装类，而 **int 对应的包装类就是 Integer**

- **包装类的存在解决了基本数据类型无法做到的事情**

	- 泛型类型参数、序列化、类型转换、高频区间数据缓存等问题


| 基本数据类型 | 包装类 |
| ---- | ---- |
| `byte` |`java.lang.Byte` |
| `short` | `java.lang.Short` |
| `int` | `java.lang.Integer` |
| `long` | `java.lang.Long` |
| `float` | `java.lang.Float` |
| `double` | `java.lang.Double` |
| `char` | `java.lang.Character` |
| `boolean` | `java.lang.Boolean` |


### 装箱、拆箱
装箱：
- Java自动将==原始类型==值转换成对应的==包装类对象==
	- 将`int`的变量转换成`Integer`对象，这个过程叫做装箱

>就是把箱子打开，然后把对应内容放进去。其实就是一个打包的过程


拆箱：
- 将`Integer`对象转换成`int`类型值，这个过程叫做拆箱。
> 这个过程像收快递，把里面的东西取出来


因为这里的装箱和拆箱是自动进行的非人为转换，所以就称作为==自动装箱和拆箱==。

## int 和 Integer 的区别

int 和 Integer的区别主要体现在5个方面：

#####  1. 数据类型不同

>int 是基础数据类型
>Integer 是包装数据类型；
    
#####  2. 默认值不同

>int 的默认值是 0
>Integer 的默认值是 null；
    
#####  3. 内存中存储的方式不同

>int 在内存中直接存储的是数据值
>Integer 实际存储的是对象引用，当 new 一个 Integer 时实际上是生成一个指针指向此对象；
    
#####   4. 实例化方式不同

>Integer 必须实例化 new 才可以使用，而 int 不需要；
    
#####  5. 变量的比较方式不同
>int 可以使用 == 来对比两个变量是否相等
>Integer 一定要使用 equals 来比较两个变量是否相等





Integer 是 int 的包装类，它们的区别主要体现在 5 个方面：==数据类型不同==、==默认值不同==、==内存中存储的方式不同==、==实例化方式不同==以及==变量的比较方式==不同。

包装类的存在解决了基本数据类型无法做到的事情   泛型类型参数、序列化、类型转换、高频区间数据缓存等问题。




## 自动拆装箱

- 自动装箱实际上算是一种语法糖。
- 什么是语法糖？
	- 可以简单理解为 Java 平台为我们自动进行了一些转换，保证不同的写法在运行时等价
	- 在 Java 中，真正支持语法糖的是 Java 编译器，它们发生在编译阶段，
	- 也就是生成的字节码是一致的。



```java
Integer num1= new Integer(127);
Integer num2= new Integer(127);
System.out.println(num1==num2);//输出 false
```
- 创建的2个对象，比较的是两个对象的地址是否一致



```java
Integer num3=127;
Integer num4=127;
System.out.println(num3==num4);//输出 true
```
- 包装类的缓存区常量池
  指向的是同一个对象，并不是生成了两个不同对象

```java
Integer num5=128;
Integer num6=128;
System.out.println(num5==num6);//输出 false
```
- 超出缓存区常量池，new新的对象，对象的对比

```java
int num7=66;
Integer num8=new Integer(66);

System.out.println(num7==num8);//输出 true
```
- 数值大小的对比，自动拆箱
  - num7==num8.intValue()
  - 两边其实是两个 int 在比较
- num7指向的是栈中的变量
- num8指向的是堆中的对象

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/interview-module/java/202203311109338.png)



装箱就是 自动将基本数据类型转换为包装器类型
拆箱就是 自动将包装器类型转换为基本数据类型