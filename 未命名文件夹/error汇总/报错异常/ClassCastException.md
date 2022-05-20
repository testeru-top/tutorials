## 报错状态
- 编译正常
- 运行发生`ClassCastException`
- 类型转换异常  

>强转的时候对应的类型不是正确的类型
## 场景一
```
List linkedList = new LinkedList();
//添加的是Integer类型
linkedList.add(1);
//获取的时候为String类型
String s1 = (String) linkedList.get(0);  
System.out.println("获取到的元素是：" + s1);
```

报错信息：
```
Exception in thread "main" java.lang.ClassCastException:
class java.lang.Integer cannot be cast to class java.lang.String (java.lang.Integer and java.lang.String are in module java.base of loader 'bootstrap')

```