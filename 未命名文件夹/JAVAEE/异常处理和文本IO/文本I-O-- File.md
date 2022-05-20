# 文本I/O-- File
## 为什么要存储文件？
- 存储在程序中的数据都是暂时的，程序运行终止的时候对应数据就会丢失
- 为了永久保存程序相关的数据
    - 需要把这些相关数据存储到磁盘或其他永久的存储设备中
    - 这样这些数据相关文件就可被其他程序 **传输** 或 **读取**
- File类
    - `java.io.File`类主要用于描述文件或目录路径的抽象表示信息，可以获取文件或目录的特征信息
    - 获取文件/目录属性
    - 删除/重命名 文件/目录
    - 创建目录
## 文件名路径
### 绝对文件名
- 完整名称
- 依赖机器
- 文件名及其完整路径
    - window系统：`C:\project\Welcome.java`
    - Mac系统：`/Users/**/project/Welcome.java`
    - Linux系统：`/home/**/project/Welcome.java`
### 相对文件名
- 相对于当前工作目录
- 完整目录路径被忽略
- 当前工作目录为`project`
    - 对应的相对文件名为`Welcome.java`
    


|方法声明|功能描述|
|---|---|
|`File(pathname:String)`|通过给定的路径名​​来创建一个File 实例<br/>pathname可是一个目录或一个文件<br/>pathname是空字符串，则结果是空的抽象路径名|
|`File(pathname:String, child:String)`|目录parent下创建一个子路径File<br/>child可以是一个目录或一个文件|
|`File(parent:File, child:String)`|目录parent下创建一个子路径File<br/>parent是File对象<br/>child字符串是绝对路径，会以系统相关的方式转换为相对路径名|
|`File(String pathname, int prefixLength)`||
|`File(String pathname, int prefixLength)`||
|`File(String pathname, int prefixLength)`||
|`File(String pathname, int prefixLength)`||
|`File(String pathname, int prefixLength)`||

