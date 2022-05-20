Version:0.9 StartHTML:0000000105 EndHTML:0000006840 StartFragment:0000000141 EndFragment:0000006800

Collections类

15.4.1 基本概念

java.util.Collections类主要提供了对集合操作或者返回集合的静态方法。

15.4.2 常用的方法方法声明 功能介绍

static <T extends Object & Comparable<? super T>> T

max(Collection<? extends T> coll)

根据元素的自然顺序返回给定集

合的最大元素

static T max(Collection<? extends T> coll, Comparator<?

super T> comp)

根据指定比较器引发的顺序返回

给定集合的最大元素

static <T extends Object & Comparable<?super T>> T

min(Collection<? extends T> coll)

根据元素的自然顺序返回给定集

合的最小元素

static T min(Collection<? extends T> coll, Comparator<?

super T> comp)

根据指定比较器引发的顺序返回

给定集合的最小元素

static void copy(List<? super T> dest, List<? extends T>

src)

将一个列表中的所有元素复制到

另一个列表中

方法声明 功能介绍

static void reverse(List<?> list) 反转指定列表中元素的顺序

static void shufflfflffle(List<?> list) 使用默认的随机源随机置换指定的列表

static <T extends Comparable<? super T>> void

sort(List list)

根据其元素的自然顺序将指定列表按升

序排序

static void sort(List list, Comparator<? super T> c)

根据指定比较器指定的顺序对指定列表

进行排序

static void swap(List<?> list, int i, int j) 交换指定列表中指定位置的元素