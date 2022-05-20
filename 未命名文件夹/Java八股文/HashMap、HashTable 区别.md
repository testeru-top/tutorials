- 对比 Hashtable、HashMap、TreeMap 有什么不同？


## 典型回答
- `Hashtable`、`HashMap`、`TreeMap` 都是最常见的一些 `Map` 实现，是以==键值对==的形式存储和操作数据的容器类型。

- `Hashtable` 是早期 Java 类库提供的一个哈希表实现，本身是同步的，==不支持 null 键和值==，由于同步导致的性能开销，所以已经很少被推荐使用。


- `HashMap` 是应用更加广泛的哈希表实现，行为上大致上与 HashTable 一致，==主要区别在于 HashMap 不是同步的==，==支持 null 键和值==等。通常情况下，HashMap 进行 `put` 或者 `get` 操作，可以达到常数时间的性能，所以它是绝大部分利用键值对存取场景的首选
	- 比如，实现一个用户 ID 和用户信息对应的运行时存储结构


- `TreeMap` 则是基于红黑树的一种提供顺序访问的 `Map`，和 `HashMap` 不同，它的 `get`、`put`、`remove` 之类操作都是 O（log(n)）的时间复杂度，具体顺序可以由==指定的 Comparator ==来决定，或者根据==键的自然顺序==来判断。

## 相同点
2个方向
共同点：
都可以存储key-value的数据

- 三者均实现了Map接口，存储的内容是基于`key-value`的键值对映射
- 一个映射不能有重复的键，一个键最多只能映射一个值
![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/interview-module/java/202203311358082.png)
## 不同点

不同点
表象上
- hashmap
### 1. 元素特性 
- `HashTable`中的 ==key、value==都**不能**为`null`
>本身是同步的，==不支持 null 键和值==，由于同步导致的性能开销，所以已经很少被推荐使用。

- `HashMap`中的==key、value== 可以为`null`
	- 只能有一个`key`为`null`的键值对
	>key为Set集合，不能重复
	- 允许有多个`值` {`value`}为`null`的键值对
- `TreeMap`中当未实现 `Comparator` 接口时，==key 不可以为null==；
	- 实现 `Comparator` 接口时，若未对`null`情况进行判断，则`key`不可以为`null`，反之亦然


### 2. 顺序特性
- `HashTable`、`HashMap`具有无序特性。
- `TreeMap`是利用红黑树来实现的（树中的每个节点的值，都会大于或等于它的左子树种的所有节点的值，并且小于或等于它的右子树中的所有节点的值），实现了`SortMap`接口，能够对保存的记录根据键进行排序。
- 所以一般需要排序的情况下是选择`TreeMap`来进行，默认为升序排序方式（深度优先搜索），可自定义实现`Comparator`接口实现排序方式


### 3. 初始化与增长方式 
#### 初始化时
- `HashTable`在不指定容量的情况下的默认容量为**11**，且不要求底层数组的容量一定要为2的整数次幂；
- `HashMap`默认容量为**16**，且要求**容量一定为2的整数次幂**。
####  扩容时
- `Hashtable`扩容将容量变为原来的2倍加1
	- **2n+1**
- `HashMap` 扩容将容量变为原来的2倍
	- **2n**

### 4.线程安全性 
- `HashTable` 其方法函数都是同步的（采用synchronized修饰），不会出现两个线程同时对数据进行操作的情况，因此保证了线程安全性。
	- 也正因为如此，在多线程运行环境下==效率表现非常低下==。
	>因为当一个线程访问HashTable的同步方法时，其他线程也访问同步方法就会进入阻塞状态。比如当一个线程在添加数据时候，另外一个线程即使执行获取其他数据的操作也必须被阻塞，大大降低了程序的运行效率，在新版本中已被废弃，不推荐使用。
- `HashMap`不支持线程的同步，即任一时刻可以有多个线程同时写HashMap;可能会导致数据的不一致。
	- 效率高
	- 如果需要同步
		- （1）可以用 `Collections` 的 `synchronizedMap` 方法；
		- （2）使用 `ConcurrentHashMap` 类，相较于 `HashTable` 锁住的是对象整体， `ConcurrentHashMap` 基于 `lock` 实现锁分段技术。
		>首先将Map存放的数据分成一段一段的存储方式，然后给每一段数据分配一把锁，当一个线程占用锁访问其中一个段的数据时，其他段的数据也能被其他线程访问。ConcurrentHashMap不仅保证了多线程运行环境下的数据访问安全性，而且性能上有长足的提升。


<想要线程安全又想要效率高 ： concurentHashMap>

# HashMap 设计与实现

大部分使用 Map 的场景，通常就是放入、访问或者删除，而对顺序没有特别要求，HashMap 在这种情况下基本是最好的选择。


是个非常高频的面试题，所以我会在这进行相对详细的源码解读，主要围绕：
- HashMap 内部实现基本点分析。
- 容量（capacity）和负载系数（load factor）。
- 树化 。


## 内部的结构
hashMap 是一个链表散列 ，即数组链表的结合组成的复合结构
```
transient Node<K,V>[] table;
```

- 数组被分为一个个桶（bucket），通过哈希值决定了键值对在这个数组的寻址；哈希值相同的键值对，则以链表形式存储，你可以参考下面的示意图。这里需要注意的是，如果链表大小超过阈值（TREEIFY_THRESHOLD, 8），图中的链表就会被改造为树形结构。


```java
//桶中链表长度大于8时转为树
//自动扩容把链表转成红黑树的数据结构来把时间复杂度从O(n)变成O(logN)提高了效率
static final int TREEIFY_THRESHOLD = 8;
//桶中数量少于6时从树转为链表
static final int UNTREEIFY_THRESHOLD = 6;
//
static final int MIN_TREEIFY_CAPACITY = 64;
```


### 添加元素
```java
HashMap hashMap = new HashMap<>();
hashMap.put("one",1);

```


调用源码：
```java
public V put(K key, V value) {
	return putVal(hash(key), key, value, false, true);
}
```
- 只有一个 putVal 的调用
```java
final V putVal(int hash, K key, V value, boolean onlyIfAbsent,
                   boolean evict){
		Node<K, V>[]tab;Node<K, V> p;int n,i;
		if((tab=table)==null||(n=tab.length)==0)
			n=(tab=resize()).length;
		if((p=tab[i=(n-1)&hash])==null)
			tab[i]=newNode(hash,key,value,null);
		else{
		...
		}
		if(++size>threshold)
			resize();
}
```

- 如果表格是 null，resize 方法会负责初始化它，这从 tab = resize() 可以看出。
- resize 方法兼顾两个职责，创建初始存储表格，或者在容量不满足需求的时候，进行扩容（resize）。
- 在放置新的键值对的过程中，如果发生下面条件，就会发生扩容。
  ```java
	if(++size>threshold)
		resize();
  ```


```java

static final int hash(Object key) {
	int h;
	// h = key.hashCode() 为第一步 取hashCode值
	// h ^ (h >>> 16)  为第二步 高位参与运算	
	return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
}
```  
Hash算法本质上就是三步:
- 取key的hashCode值、高位运算、取模运算。



```java
newCap = DEFAULT_INITIAL_CAPACITY; //16
newThr = (int)(DEFAULT_LOAD_FACTOR * DEFAULT_INITIAL_CAPACITY);//16*0.75=12
```


![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/interview-module/java/202203311809603.jpg)


图中的步骤总结如下：

①. 判断键值对数组table[i]是否为空或为null，否则执行resize()进行扩容；

②. 根据键值key计算hash值得到插入的数组索引i，如果table[i]==null，直接新建节点添加，转向⑥，如果table[i]不为空，转向③；

③. 判断table[i]的首个元素是否和key一样，如果相同直接覆盖value，否则转向④，这里的相同指的是hashCode以及equals；

④. 判断table[i] 是否为treeNode，即table[i] 是否是红黑树，如果是红黑树，则直接在树中插入键值对，否则转向⑤；

⑤. 遍历table[i]，判断链表长度是否大于8，大于8的话把链表转换为红黑树，在红黑树中执行插入操作，否则进行链表的插入操作；遍历过程中若发现key已经存在直接覆盖value即可；

⑥. 插入成功后，判断实际存在的键值对数量size是否超多了最大容量threshold，如果超过，进行扩容。

