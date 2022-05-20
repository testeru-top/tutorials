# ArrayList LinkedList 区别

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/interview-module/java/202203301359369.png)

- ArrayList 是基于数组实现的，LinkedList 是基于双向链表实现的
- ArrayList 在新增和删除元素时，因为涉及到数组复制，所以效率比 LinkedList 低，而在遍历的时候，ArrayList 的效率要高于 LinkedList





## 共同点
- ArrayList、LinkedList 都实现了 List 接口
  - 对应的List的方法都可以使用，只不过实现类的底层的实现逻辑不同
  - 都允许有重复元素、有先后放入次序
  - 都可以位置（索引）访问，元素的添加、删除，迭代器遍历



>ArrayList 和 LinkedList 都实现集合框架中的 List，也就是所谓的有序集合。
>
>因此具体功能也比较近似，比如都提供按照位置进行定位、添加或者删除的操作，都提供迭代器以遍历其内容等。
>
>但因为具体的设计区别，在行为、性能、线程安全等方面，表现又有很大不同。

- `ArrayList` 继承的是 `AbstractList` 抽象类
- `LinkedList` 是一个继承自 `AbstractSequentialList` 的双向链表，因此它也可以被当作堆栈、队列或双端队列进行操作，
  - `AbstractSequentialList` 继承 `AbstractList` 抽象类

## 不同点
### 1. 底层数据结构不同
#### ArrayList
- `ArrayList`的数据结构为数组
##### Object数组 
- `ArrayList` 底层是基于**数组**实现的，对应成员变量声明都是一个 `Object` 类型的==数组==
  - 内存中一块连续的空间
  - 默认初始化大小的容量是 10  「`default-capacity`」
  - 成员变量`size` 是数组里==真正元素的个数==
   >不声明数组长度的时候，添加第一个元素，这时，
   >数组长度`elementData.length` 为10，
   >数组里==真正元素的个数==`size`为1

```java
pulic class ArrayList<E> extends AbstractList<E>
        implements List<E>, RandomAccess, Cloneable, java.io.Serializable
{
    private static final int DEFAULT_CAPACITY = 10;

    private static final Object[] EMPTY_ELEMENTDATA = {};

    private static final Object[] DEFAULTCAPACITY_EMPTY_ELEMENTDATA = {};

    transient Object[] elementData; 

    private int size;
}

```

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/interview-module/java/202203301415359.png)
#### LinkedList

-  `LinkedList`的数据结构为队列，==先进先出==
-  `LinkedList` 底层是一个个==双向链表==的**Node节点**
##### Node节点
- 内存中不是一块连续的存储空间
- 一个 `Node` 结点包含 3 个部分：
  - 元素内容 `item`
  - 前引用 `prev` 
  - 后引用 `next`

```java
    private static class Node<E> {
        E item;
        Node<E> next;
        Node<E> prev;

        Node(Node<E> prev, E element, Node<E> next) {
            this.item = element;
            this.next = next;
            this.prev = prev;
        }
    }
```
![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/interview-module/java/202203301417728.png)
### 2. 构造方法不同
- 都可以构造一个包含指定集合元素的列表
#### ArrayList
##### 有参构造
- `ArrayList` 有==有参构造==和==无参构造==

  - 业务上==已知 数组长度==，声明 `ArrayList` 的时候就声明大小
	  - 这样内存空间不会有浪费

>​	比如已知数组存储数据个数是7，即已经知道数组长度，
>
>​	如果声明ArrayList的时候不声明大小，那么默认在内存中ArrayList实际数据占用的空间是10个的大小空间，这样对应有3个大小的空间其实是被浪费掉的。
>
>​	若这种情况用带有数组长度参数的构造方法去声明，则可以节约内存占用空间，声明7个大小，对应不会有空间浪费

```
ArrayList arrayListSize = new ArrayList(7);
```

##### 无参构造
- 只是声明一个空集合，内存中没有占空间

```
ArrayList arrayList = new ArrayList();
```
#### LinkedList
- `LinkedList`  只有无参构造方法
	- 只是声明一个空集合，内存中没有占空间

```
LinkedList linkedList = new LinkedList();
```

### 3. 添加元素不同
#### ArrayList

新增元素有两种情况，一种是直接将元素添加到队尾，一种是将元素插入到指定位置。

- ArrayList 无参构造声明，添加元素时默认初始化10个空间大小；

>对象在内存中存储布局是3部分：对象头、对象实际数据 instance data、对齐补充padding



- 添加元素的时候如果内存空间不够，则需要进行扩容，ArrayList 使用的是==动态扩容==，每次扩容1.5倍

> 数组声明为data，具体的数据存放在堆中，data在栈中，栈指向堆
>
> 动态扩容的时候在堆中新生成一份内存空间，data进行一个重新指向就可以了，以前引用的直接java垃圾回收「GC」。
>
> 对于我们来说看到的还是data，只不过对应的data指向了新的引用空间，老的内存空间就干掉了。
>
> 底层而言，数组对应的物理地址引用，指向了新的内存空间。但是前面无感知。



>arrayList声明时为3个大小。add添加元素第4个元素的时候触发动态扩容，扩容为原有数组大小的1.5倍，数组copy后，直接底层arrayList指向的物理地址更新。
![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/interview-module/java/202203301431051.png)

##### 直接添加元素
添加元素到数组末尾。
- `add(E e)`  
 ```java
 add(e, elementData, size);
 ```
- `add(E e, Object[] elementData, int s)` 

 ```java
  if (s == elementData.length)
        elementData = grow();
  ```
##### 指定位置添加元素

- `add(int index, E element) `
  ```java
  if ((s = size) == (elementData = this.elementData).length)
        elementData = grow();
  ```
  
##### 动态扩容
- 动态扩容概念：
	- ==从原有数组拷贝到新扩容后的数组==
- 动态扩容 触发条件：
	-  添加元素时，**数组内元素个数** 和 **数组长度** 进行对比，如果相等，则进行动态扩容



```java
elementData = Arrays.copyOf(elementData,
                         newCapacity(minCapacity));
```
- 动态扩容 倍数：
	- 扩容倍数为原有数组长度的==1.5==
```java
int oldCapacity = elementData.length;
int newCapacity = oldCapacity + (oldCapacity >> 1);
```




#### LinkedList
增加元素的方式有三种：
- 链表头部插入值；
- 尾部插入值；
- 中间某个元素前插入值。


##### 尾部插入值

- `add(E e)`
 ```java
 linkLast(e);
 ```
- `linkLast(E e) `

 ```java
  final Node<E> l = last;
  final Node<E> newNode = new Node<>(l, e, null);
  last = newNode;
  if (l == null)
      first = newNode;
  else
      l.next = newNode;
  ```

1. 最后一个结点 `last` 放在临时变量 `l` 
2. 根据添加的元素生成新 `Node` 结点 `(l, e, null)`
3.  `last` 结点更新为刚刚新生成的 `Node` 结点
4. 如果原集合尾结点为 `null` ,那头结点 `first` 为新结点
5. 否则新结点 赋值给原集合尾结点的 `next`

##### 指定位置添加

- `add(int index, E element)`
 ```java
  if (index == size)
      linkLast(element);
  else
      linkBefore(element, node(index));
 ```
- `linkBefore(element, node(index));`
  - `node(index)`
 ```java
    Node<E> node(int index) {
        if (index < (size >> 1)) {
            Node<E> x = first;
            for (int i = 0; i < index; i++)
                x = x.next;
            return x;
        } else {
            Node<E> x = last;
            for (int i = size - 1; i > index; i--)
                x = x.prev;
            return x;
        }
    }
 ```
  - `linkBefore`
 ```java
    final Node<E> pred = succ.prev;
    final Node<E> newNode = new Node<>(pred, e, succ);
    succ.prev = newNode;
    if (pred == null)
        first = newNode;
    else
        pred.next = newNode;
 ```

1.  如果指定位置是集合长度，直接最后追加
2.  如果不是，则进行指定位置添加 `linkBefore`
3.  添加前调用 `node()` 方法查找指定位置上的元素
4.  ` node(index)` 里面遍历 `LinkedList` 。
    如果下标`index`是前半段，则从头开始遍历；
    如果下标`index`是后半段，则从尾开始遍历。
    所以，插入的位置`index` 越靠近中间位置，遍历花费的时间越多。
5.  找到指定位置元素（`succ`），开始执行`linkBefore`
6.  将 `succ` 的前一个节点（`prev`）存放到临时变量 `pred` 中
7.  生成新的 `Node` 节点（`newNode`）
8.  将 `succ` 的前一个节点变更为 `newNode`
9.  若  `pred` 为 `null`，说明插入的是队头，所以 `first` 为新节点；
    否则将 `pred` 的后一个节点变更为 `newNode`。



### 4. 添加元素性能对比
前提： 

当两者的起始长度一样

- 如果是从集合的头部新增元素，`ArrayList` 花费的时间应该比 `LinkedList` 多，因为需要对头部以后的元素进行复制。
    ```java
    addFromHeaderArrayListTest(10000);//56
    addFromHeaderLinkedListTest(10000);//7
    ```
- 如果是从集合的中间位置新增元素，ArrayList 花费的时间搞不好要比 LinkedList 少，因为 LinkedList 需要遍历。
  ```java
  addFromMidArrayListTest(10000);//10
  addFromMidLinkedListTest(10000);//170
  ```
- 如果是从集合的尾部新增元素，ArrayList 花费的时间应该比 LinkedList 少，因为数组是一段连续的内存空间，也不需要复制数组；而链表需要创建新的对象，前后引用也要重新排列。
  ```java
  addFromTailArrayListTest(10000);//84
  addFromTailLinkedListTest(10000);//240
  ```


```java
public class ArrayAndLinkedList {
    public static void main(String[] args) {
        System.out.println("----------------------1.list集合头添加元素-----------------------");
        //list集合头添加元素性能对比
        ArrayAndLinkedList.addFromHeaderArrayListTest(10000);//56
        ArrayAndLinkedList.addFromHeaderLinkedListTest(10000);//7
        System.out.println("----------------------2.list集合中间添加元素-----------------------");
        ArrayAndLinkedList.addFromMidArrayListTest(10000);//10
        ArrayAndLinkedList.addFromMidLinkedListTest(10000);//170
        System.out.println("----------------------3.list集合尾部添加元素-----------------------");
        ArrayAndLinkedList.addFromTailArrayListTest(1000000);//84
        ArrayAndLinkedList.addFromTailLinkedListTest(1000000);//240
    }
    //ArrayList从头部添加元素
    public static void addFromHeaderArrayListTest(int num) {
        int i = 0;
        ArrayList<String> list = new ArrayList<>(num);
        long timeStart = System.currentTimeMillis();
        while (i < num) {
            list.add(0, i + "Testeru");
            i++;
        }
        long timeEnd = System.currentTimeMillis();
        System.out.println("ArrayList从集合头部位置新增元素花费的时间" + (timeEnd - timeStart));
    }

    //LinkedList从头部添加元素
    public static void addFromHeaderLinkedListTest(int num) {
        int i = 0;
        LinkedList<String> list = new LinkedList<>();
        long timeStart = System.currentTimeMillis();
        while (i < num) {
            list.addFirst(i + "Testeru");
            i++;
        }
        long timeEnd = System.currentTimeMillis();
        System.out.println("LinkedList从集合头部位置新增元素花费的时间" + (timeEnd - timeStart));
    }

    //不计算动态扩容 ArrayList从中间位置新增元素
    public static void addFromMidArrayListTest(int num) {
        int i = 0;
        ArrayList<String> list = new ArrayList<>(num);//不计算动态扩容
        long timeStart = System.currentTimeMillis();
        while (i < num) {
            int temp = list.size();
            list.add(temp / 2, i + "Testeru");
            i++;
        }
        long timeEnd = System.currentTimeMillis();
        System.out.println("ArrayList从集合中间位置新增元素花费的时间" + (timeEnd - timeStart));
    }

    //LinkedList从中间位置新增元素
    public static void addFromMidLinkedListTest(int num) {
        int i = 0;
        LinkedList<String> list = new LinkedList<>();
        long timeStart = System.currentTimeMillis();
        while (i < num) {
            int temp = list.size();
            list.add(temp / 2, i + "Testeru");
            i++;
        }
        long timeEnd = System.currentTimeMillis();
        System.out.println("LinkedList从集合中间位置新增元素花费的时间" + (timeEnd - timeStart));
    }

    //ArrayList从集合的尾部新增元素
    public static void addFromTailArrayListTest(int num) {
        ArrayList<String> list = new ArrayList<>(num);
        int i = 0;
        long timeStart = System.currentTimeMillis();
        while (i < num) {
            list.add(i + "Testeru");
            i++;
        }
        long timeEnd = System.currentTimeMillis();
        System.out.println("ArrayList从集合尾部位置新增元素花费的时间" + (timeEnd - timeStart));
    }
    //LinkedList从集合的尾部新增元素
    public static void addFromTailLinkedListTest(int num) {
        LinkedList<String> list = new LinkedList<>();
        int i = 0;
        long timeStart = System.currentTimeMillis();
        while (i < num) {
            list.add(i + "Testeru");
            i++;
        }
        long timeEnd = System.currentTimeMillis();
        System.out.println("ArrayList从集合尾部位置新增元素花费的时间" + (timeEnd - timeStart));
    }
}
```


##### ArrayList
性能好：
- ==中间位置新增元素==


- ==尾部新增元素==

##### LinkedList
性能好：
- ==头部新增元素==

#### 总结
前提：当ArrayList、LinkedList两者的长度固定，并且在添加元素时不涉及扩容，性能进行对比：
- ArrayList 在==中间位置新增元素==、==尾部新增元素==时性能比 LinkedList 好很多
- ArrayList只有==头部新增元素==的时候比 LinkedList 差
	- 因为数组复制的原因

### 5. 获取不同
#### 5.1 根据下标获取元素
`get(int index)`

##### ArrayList
ArrayList可以进行 快速随机访问。
- 快速随机访问是什么意思呢？
  - 就是说不需要遍历，就可以通过下标（索引）直接访问到内存地址
- `return elementData(index);`
- ==直接返回数组元素==
 ```java
    E elementData(int index) {
        return (E) elementData[index];
    }
 ```

- ArrayList 实现了 RandomAccess 接口，RandomAccess是一个标记接口：
  - 内部是空的，标记“实现了这个接口的类支持快速（通常是固定时间）随机访问”。快速随机访问是什么意思呢？就是说不需要遍历，就可以通过下标（索引）直接访问到内存地址。

##### LinkedList
- `return node(index).item;`

- 调用 `node(int)` 方法
- ==需要集合分前后半段遍历了==
>下标和集合size的一半做对比，如果下标在前半段，则进行前半段集合的遍历，如果下标在后半段，则进行后半段集合的遍历

 ```java
    Node<E> node(int index) {
        if (index < (size >> 1)) {
            Node<E> x = first;
            for (int i = 0; i < index; i++)
                x = x.next;
            return x;
        } else {
            Node<E> x = last;
            for (int i = size - 1; i > index; i--)
                x = x.prev;
            return x;
        }
    }
 ```


#### 5.2 根据元素获取下标
`indexOf(Object o)`

##### ArrayList
- `return indexOfRange(o, 0, size);`
	- 返回元素的最小的索引，没有返回-1
		- 可以有重复元素在集合内
	- 如果是`null`，则返回`null`的下标


 ```java
    int indexOfRange(Object o, int start, int end) {
        Object[] es = elementData;
        if (o == null) {
            for (int i = start; i < end; i++) {
                if (es[i] == null) {
                    return i;
                }
            }
        } else {
            for (int i = start; i < end; i++) {
                if (o.equals(es[i])) {
                    return i;
                }
            }
        }
        return -1;
    }
 ```
##### LinkedList
- 需要遍历整个链表，和 `ArrayList` 的 `indexOf()` 类似
```java

    if (o == null) {
        for (Node<E> x = first; x != null; x = x.next) {
            if (x.item == null)
                return index;
            index++;
        }
    } else {
        for (Node<E> x = first; x != null; x = x.next) {
            if (o.equals(x.item))
                return index;
            index++;
        }
    }
    return -1;

```
### 6. 遍历不同

- 对集合遍历，通常有两种做法：
    - 一种是  使用 `for` 循环
     ```java
     for (int i=0, n=list.size(); i < n; i++)
        list.get(i);
     ```
    - 一种是  使用迭代器（`Iterator`）
     ```java
     for (Iterator i=list.iterator(); i.hasNext(); )
        i.next();
     ```


#### ArrayList
##### get()
- `get` 非常的快，一步到位
  - `ArrayList` 是由数组实现的，所以根据索引找元素 (`get`) 非常的快，一步到位
#####  iterator()



#### LinkedList 
##### get()
- 在 `get` 的时候性能会非常差
  - 因为每一次外层的 `for` 循环，都要执行一次 `node(int)` 方法进行前后半段的遍历
##### iterator()
- 执行 `list.iterator() `

1. 执行的是 `AbstractSequentialList` 的 `iterator()`
2. 再调用 `AbstractList` 类的 `listIterator()`
3. 再调用 `LinkedList` 类的 `listIterator(int)` 方法
    - 返回的是 `LinkedList` 类的内部私有类 `ListItr` 对象

![](https://gitee.com/javaTesteru/picgo/raw/master/images/testeru/javaee-module/collection/202203151549601.png)

- 执行 `ListItr` 的构造方法时调用了一次 `node(int)` 方法，返回第一个节点
 ```java
ListItr(int index) {
    // assert isPositionIndex(index);
    next = (index == size) ? null : node(index);
    nextIndex = index;
}
 ```

- 之后，迭代器就执行 `hasNext()` 判断有没有下一个，执行 `next() `方法下一个节点


#### 总结
- for 循环遍历的时候，ArrayList 花费的时间远小于 LinkedList
- 迭代器遍历的时候，两者性能差不多


> LinkedList 的`get` 性能不好，每次get都需要遍历 ArrayList 的`get` 很快，直接返回
   迭代都差不多，LinkedList 迭代只遍历一次


|5000个|for循环遍历时间|迭代器遍历时间|for|迭代|
|---|---|---|---|---|
|ArrayList|0 |1| 1| 3|
|LinkedList|21 |2| 20| 1|

|10000个|for循环遍历时间|迭代器遍历时间|for|迭代|
|---|---|---|---|---|
|ArrayList|1  | 3 | 2 |  2|
|LinkedList|62  |3  | 66 | 2 |

```java
public class ArrayListTraver {
    public static void main(String[] args) {
        int num = 10000;
        int j = 0;
        ArrayList<String> arrayList = new ArrayList<>(num);
        while (j < num) {
            arrayList.add(0, j + "Testeru");
            j++;
        }
        //开始遍历
        long timeStart = System.currentTimeMillis();
        for (int i=0, n=arrayList.size(); i < n; i++)
            arrayList.get(i);
        long timeEnd = System.currentTimeMillis();
        System.out.println("ArrayList——get遍历元素花费的时间" + (timeEnd - timeStart));
        //迭代器遍历
        timeStart = System.currentTimeMillis();
        for (Iterator i = arrayList.iterator(); i.hasNext(); )
            i.next();
        timeEnd = System.currentTimeMillis();
        System.out.println("ArrayList——迭代器遍历元素花费的时间" + (timeEnd - timeStart));
    }
}
```


```java
public class LinkedListTraver {
    public static void main(String[] args) {
        int num = 10000;
        int j = 0;

        LinkedList<String> linkedList = new LinkedList<>();
        while (j < num) {
            linkedList.addFirst(j + "Testeru");
            j++;
        }

        //开始遍历
        long timeStart = System.currentTimeMillis();
        for (int i=0, n=linkedList.size(); i < n; i++)
            linkedList.get(i);
        long timeEnd = System.currentTimeMillis();

        System.out.println("linkedList——get遍历元素花费的时间" + (timeEnd - timeStart));//21

        //迭代器遍历
        timeStart = System.currentTimeMillis();
        for (Iterator i = linkedList.iterator(); i.hasNext(); )
            i.next();
        timeEnd = System.currentTimeMillis();
        System.out.println("linkedList——迭代器遍历元素花费的时间" + (timeEnd - timeStart));//2

    }

}
```
- 如果只是foreach遍历的话，在千万级的数据情况下，LinkedList要慢于ArrayList，大概4倍的差距


- **ArrayList** 和 **LinkedList** 都是==线性==的。
  - 都在一个平面上。
  - 存储的数据都是线性存储的。
  - **ArrayList** 是数组，所以支持随机的存储，查找快，但是删除、添加慢「因为要求连续，所以有个移动的过程」
  - **LinkedList** 不是一个连续的，所以添加、删除快一些，但是查找慢「因为需要遍历，为了提高性能，用了2分查找的思想」

## 总

-  ArrayList 作为动态数组，其内部元素以数组形式顺序存储的，所以非常适合==随机访问==的场合。
	-  **随机访问get和set，ArrayList要优于LinkedList**，因为LinkedList要移动指针
 
 除了尾部插入和删除元素，往往性能会相对较差，比如我们在中间位置插入一个元素，需要移动后续所有元素。
 - LinkedList 进行==节点插入、删除却要高效得多==，但是随机访问性能则要比动态数组慢。


>当插入的数据量很小时，两者区别不太大，当插入的数据量大时，大约在容量的1/10之前，LinkedList会优于ArrayList，在其后就劣与ArrayList，且越靠近后面越差。所以个人觉得，一般首选用ArrayList，由于LinkedList可以实现栈、队列以及双端队列等数据结构，所以当特定需要时候，使用LinkedList，当然咯，数据量小的时候，两者差不多，视具体情况去选择使用；当数据量大的时候，如果只需要在靠前的部分插入或删除数据，那也可以选用LinkedList，反之选择ArrayList反而效率更高。
