# Yaml文件解析
## List结构解析
## List+Map结构解析
### Yaml文件
`orderlist.yaml`

```yaml
- item: No. 9 Sprockets
  quantity: 12
  unitPrice: 1.23
  orderDate: 2019-04-17
- item:  No. Widget (10mm)
  quantity: 10
  unitPrice: 3.45
  orderDate: 2022-01-16
```

### 直接声明类型解析
- `List<HashMap<String, Object>>`


```java
@Test
void listMapTest() throws IOException {
    ObjectMapper mapper = new ObjectMapper(new YAMLFactory());
    TypeReference<List<HashMap<String, Object>>> typeReference =
            new TypeReference<List<HashMap<String, Object>>>() {};
    List<HashMap<String, Object>> hashMaps = mapper.readValue(
            new File("src/test/resources/yaml/orderlist.yaml"), typeReference);
    System.out.println(hashMaps);
}
```
### 声明实体类解析
#### 成员变量与key一致
```java
@Data
public class OrderLine{
    private String item;
    private int quantity;
    private BigDecimal unitPrice;
    private LocalDate orderDate;
}
```


```java
@Test
public void orderLineTest() throws IOException {
    ObjectMapper mapper = new ObjectMapper(new YAMLFactory());
    //功能上等价的便捷方法： mapper.registerModules(mapper.findModules());
    //我们需要使用 findAndRegisterModules方法，以便 Jackson正确处理我们的日期
    //Jackson也可以自动搜索所有模块，不需要我们手动注册
    mapper.findAndRegisterModules();
    TypeReference<List<OrderLine>> typeReference = new TypeReference<List<OrderLine>>() {
    };
    List<OrderLine> orderLines = mapper.readValue(new File("src/test/resources/yaml/orderlist.yaml"), typeReference);
    System.out.println(orderLines);
}
```
#### 成员变量与key不一致
- @JsonProperty
    - 表明对应的成员变量与yaml的key对应关系
```java
@Data
public class OrderList {
    @JsonProperty("item")
    private String otherItem;
    @JsonProperty("quantity")
    private int qua;
    @JsonProperty("unitPrice")
    private BigDecimal price;
    @JsonProperty("orderDate")
    private LocalDate date;
}
```


```java
@Test
public void orderListTest() throws IOException {
    ObjectMapper mapper = new ObjectMapper(new YAMLFactory());
    //功能上等价的便捷方法： mapper.registerModules(mapper.findModules());
    //我们需要使用 findAndRegisterModules方法，以便 Jackson正确处理我们的日期
    //Jackson也可以自动搜索所有模块，不需要我们手动注册
    mapper.findAndRegisterModules();
    TypeReference<List<OrderList>> typeReference = new TypeReference<List<OrderList>>() {
    };
    List<OrderList> orderLists = mapper.readValue(new File("src/test/resources/yaml/orderlist.yaml"), typeReference);
    System.out.println(orderLists);
}
```

## Map+List+Map解析
### Yaml文件
`orderlines.yaml`

```yaml
orderLines:
  - item: No. 9 Sprockets
    quantity: 12
    unitPrice: 1.23
    orderDate: 2019-04-17
  - item:  No. Widget (10mm)
    quantity: 10
    unitPrice: 3.45
    orderDate: 2022-01-16
```

### 直接声明类型解析
- `HashMap<String,List<HashMap<String, Object>>>`


```java
@Test
void mapListMapTest() throws IOException {
    ObjectMapper mapper = new ObjectMapper(new YAMLFactory());
    TypeReference<HashMap<String,List<HashMap<String, Object>>>> typeReference =
            new TypeReference<HashMap<String,List<HashMap<String, Object>>>>() {};
    HashMap<String,List<HashMap<String, Object>>> hashMaps = mapper.readValue(
            new File("src/test/resources/yaml/orderlines.yaml"), typeReference);
    System.out.println(hashMaps);

}
```
### 声明实体类解析
#### 成员变量与key一致
```java
@Data
public class OrderLine{
    private String item;
    private int quantity;
    private BigDecimal unitPrice;
    private LocalDate orderDate;
}



```


```java
@Data
public class OrderLines {
    private List<OrderLine> orderLines;
}
```


```java
@Test
public void orderListTest() throws IOException {
    ObjectMapper mapper = new ObjectMapper(new YAMLFactory());
    //功能上等价的便捷方法： mapper.registerModules(mapper.findModules());
    //我们需要使用 findAndRegisterModules方法，以便 Jackson正确处理我们的日期
    //Jackson也可以自动搜索所有模块，不需要我们手动注册
    mapper.findAndRegisterModules();
    TypeReference<OrderLines> typeReference = new TypeReference<OrderLines>() {
    };
    OrderLines orderLists = mapper.readValue(new File("src/test/resources/yaml/orderlines.yaml"), typeReference);
    System.out.println(orderLists);
}
```
#### 成员变量与key不一致
- @JsonProperty
    - 表明对应的成员变量与yaml的key对应关系
```java
@Data
public class OrderList {
    @JsonProperty("item")
    private String otherItem;
    @JsonProperty("quantity")
    private int qua;
    @JsonProperty("unitPrice")
    private BigDecimal price;
    @JsonProperty("orderDate")
    private LocalDate date;
}



```


```java
@Data
public class OrderLists {
    @JsonProperty("orderLines")
    private List<OrderList> lists;
}
```


```java
@Test
public void orderListsTest() throws IOException {
    ObjectMapper mapper = new ObjectMapper(new YAMLFactory());
    //功能上等价的便捷方法： mapper.registerModules(mapper.findModules());
    //我们需要使用 findAndRegisterModules方法，以便 Jackson正确处理我们的日期
    //Jackson也可以自动搜索所有模块，不需要我们手动注册
    mapper.findAndRegisterModules();
    TypeReference<OrderLists> typeReference = new TypeReference<OrderLists>() {
    };
    OrderLists orderLists = mapper.readValue(new File("src/test/resources/yaml/orderlines.yaml"), typeReference);
    System.out.println(orderLists);
}
```

## Maps+List+Map解析

### Yaml文件
`order.yaml`

```yaml
orderNo: A001
date: 2019-04-17
customerName: Customer, Joe
orderLines:
  - item: No. 9 Sprockets
    quantity: 12
    unitPrice: 1.23
  - item: No. Widget (10mm)
    quantity: 40
    unitPrice: 3.45
```


- 无法直接声明类型解析
### 声明实体类解析
#### 成员变量与key一致
```java
@Data
public class OrderLine{
    private String item;
    private int quantity;
    private BigDecimal unitPrice;
    private LocalDate orderDate;
}

```


```java


@Data
public class Order {
    private String orderNo;
    private LocalDate date;
    private String customerName;
    private List<OrderLine> orderLines;
}
```


```java
@Test
public void orderLinesTest() throws IOException {
    ObjectMapper mapper = new ObjectMapper(new YAMLFactory());
    //功能上等价的便捷方法： mapper.registerModules(mapper.findModules());
    //我们需要使用 findAndRegisterModules方法，以便 Jackson正确处理我们的日期
    //Jackson也可以自动搜索所有模块，不需要我们手动注册
    mapper.findAndRegisterModules();
    TypeReference<Order> typeReference = new TypeReference<Order>() {
    };
    Order order = mapper.readValue(new File("src/test/resources/yaml/order.yaml"), typeReference);
    System.out.println(order);
}
```
#### 成员变量与key不一致
- @JsonProperty
    - 表明对应的成员变量与yaml的key对应关系
```java
@Data
public class OrderList {
    @JsonProperty("item")
    private String otherItem;
    @JsonProperty("quantity")
    private int qua;
    @JsonProperty("unitPrice")
    private BigDecimal price;
    @JsonProperty("orderDate")
    private LocalDate date;
}

```


```java


@Data
public class OrderOther {
    @JsonProperty("orderNo")
    private String orderNum;
    @JsonProperty("date")
    private LocalDate Date;
    @JsonProperty("customerName")
    private String customername;
    @JsonProperty("orderLines")
    private List<OrderList> orderLists;
}
```


```java
@Test
public void orderOtherTest() throws IOException {
    ObjectMapper mapper = new ObjectMapper(new YAMLFactory());
    //功能上等价的便捷方法： mapper.registerModules(mapper.findModules());
    //我们需要使用 findAndRegisterModules方法，以便 Jackson正确处理我们的日期
    //Jackson也可以自动搜索所有模块，不需要我们手动注册
    mapper.findAndRegisterModules();
    TypeReference<OrderOther> typeReference = new TypeReference<OrderOther>() {
    };
    OrderOther orderOther = mapper.readValue(new File("src/test/resources/yaml/order.yaml"), typeReference);
    System.out.println(orderOther);
    orderOther.getOrderLists().forEach(orderList -> {
        assertAll(
                () -> assertThat(orderList.getOtherItem(), startsWith("No")),
                () -> assertThat(orderList.getQua(), is(greaterThan(9))),
                () -> assertThat(orderList.getPrice(), is(closeTo(new BigDecimal(1.0),new BigDecimal(4.00))))
        );
    });
}
```