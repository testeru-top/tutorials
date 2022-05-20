# Num Comparison
数字匹配比较器
## Proximity Matchers
- 接近匹配器

### double-closeTo
- 邻近匹配器
```java
    /**邻近匹配器
     * 假设我们有一个数字存储在一个名为actual的双变量中
     * 想测试实际值是否接近 1 +/- 0.5
     * 1 - 0.5 <= actual <= 1 + 0.5
     *     0.5 <= actual <= 1.5
     *
|   |   |   |
|---|---|---|
|   |   |   |


     *      1.3 介于 0.5 和 1.5 之间
     */
    @Test
    public void givenADouble_whenCloseTo_thenCorrect() {
        double actual = 1.3;
        double operand = 1;
        double error = 0.5;
        assertThat(actual, is(closeTo(operand, error)));
    }
```


```java
    /**邻近匹配器
     * 测试不介于场景
     */
    @Test
    public void givenADouble_whenNotCloseTo_thenCorrect() {
        double actual = 1.6;
        double operand = 1;
        double error = 0.5;
        assertThat(actual, is(not(closeTo(operand, error))));
    }
```

### BigDecimal-closeTo
```java
    /**邻近匹配器
     * isClose With BigDecimal Values
     * isClose 已重载，可以与 double 值相同使用，但与 BigDecimal 对象一起使用
     *
     * 请注意， is 匹配器只装饰其他匹配器，而没有添加额外的逻辑。它只是使整个断言更具可读性。
     *
     */
    @Test
    public void givenABigDecimal_whenCloseTo_thenCorrect() {
        BigDecimal actual = new BigDecimal("1.0003");
        BigDecimal operand = new BigDecimal("1");
        BigDecimal error = new BigDecimal("0.0005");
        assertThat(actual, is(closeTo(operand, error)));
    }


    @Test
    public void givenABigDecimal_whenNotCloseTo_thenCorrect() {
        BigDecimal actual = new BigDecimal("1.0006");
        BigDecimal operand = new BigDecimal("1");
        BigDecimal error = new BigDecimal("0.0005");
        assertThat(actual, is(not(closeTo(operand, error))));
    }
```

# Order Matchers
- 有助于对订单进行断言

包含5种：
- `comparesEqualTo`
- `greaterThan`
- `greaterThanOrEqualTo`
- `lessThan`
- `lessThanOrEqualTo`


### comparesEqualTo
- 创建 `Comparable` 对象的匹配器，当检查对象等于指定值时匹配，如检查对象的 `compareTo` 方法报告的那样。例如：
  - `assertThat(1, comparesEqualTo(1))`
- 参数：
  - `value` 
    - 当传递给被检查对象的 compareTo 方法时，应该返回零的值
```java

    @Test
    public void given5_whenComparesEqualTo5_thenCorrect() {
        Integer five = 5;
        assertThat(five, comparesEqualTo(five));
    }

    @Test
    public void given5_whenNotComparesEqualTo7_thenCorrect() {
        Integer seven = 7;
        Integer five = 5;
        assertThat(five, not(comparesEqualTo(seven)));
    }
```

### greaterThan
- 创建 `Comparable` 对象的匹配器，当检查对象大于指定值时匹配，如检查对象的 `compareTo` 方法报告的那样。例如：
  - `assertThat(seven, is(greaterThan(five)))`
- 参数：
  - `value` 
    - 当传递给被检查对象的 `compareTo` 方法时，应该返回大于零的值
```java
    @Test
    public void given7_whenGreaterThan5_thenCorrect() {
        Integer seven = 7;
        Integer five = 5;
        assertThat(seven, is(greaterThan(five)));
    }
```
### greaterThanOrEqualTo
- 创建 `Comparable` 对象的匹配器，当检查对象大于或等于指定值时匹配，如检查对象的 `compareTo` 方法报告的那样。例如：
  - `assertThat(1, GreaterThanOrEqualTo(1))`
- 参数：
- `value` 
  - 当传递给被检查对象的 `compareTo` 方法时，应该返回大于或等于零的值
```java
    @Test
    public void given7_whenGreaterThanOrEqualTo5_thenCorrect() {
        Integer seven = 7;
        Integer five = 5;
        assertThat(seven, is(greaterThanOrEqualTo(five)));
    }

    @Test
    public void given5_whenGreaterThanOrEqualTo5_thenCorrect() {
        Integer five = 5;
        assertThat(five, is(greaterThanOrEqualTo(five)));
    }
```

### lessThan
* 创建 `Comparable` 对象的匹配器，当检查对象小于指定值时匹配，如检查对象的 `compareTo` 方法报告的那样。例如：
  * `assertThat(1, lessThan(2))`
* 参数：
* `value` 
  * 当传递给被检查对象的 `compareTo` 方法时，应该返回小于零的值

```java

    @Test
    public void given3_whenLessThan5_thenCorrect() {
        Integer three = 3;
        Integer five = 5;
        assertThat(three, is(lessThan(five)));
    }
```
### lessThanOrEqualTo
- 创建 `Comparable` 对象的匹配器，当检查对象小于或等于指定值时匹配，如检查对象的 `compareTo` 方法报告的那样。例如：
  - `assertThat(1, lessThanOrEqualTo(1))`
- 参数：
- `value` 
  - 当传递给被检查对象的 `compareTo` 方法时，应该返回小于或等于零的值

```java

    @Test
    public void given3_whenLessThanOrEqualTo5_thenCorrect() {
        Integer three = 3;
        Integer five = 5;
        assertThat(three, is(lessThanOrEqualTo(five)));
    }

    @Test
    public void given5_whenLessThanOrEqualTo5_thenCorrect() {
        Integer five = 5;
        assertThat(five, is(lessThanOrEqualTo(five)));
    }
```
## String Values
- 带有字符串值的订单匹配器
### greaterThan

* 尽管比较数字完全有意义，但很多时候比较其他类型的元素很有用
* 这就是订单匹配器可以应用于任何实现`Comparable`接口的类的原因
* `String`在`Comparable`接口的`compareTo`方法中实现字母顺序。
```java

    @Test
    public void givenBenjamin_whenGreaterThanAmanda_thenCorrect() {
        String amanda = "Amanda";
        String benjamin = "Benjamin";
        assertThat(benjamin, is(greaterThan(amanda)));
    }
```
### lessThan
```java

    @Test
    public void givenAmanda_whenLessThanBenajmin_thenCorrect() {
        String amanda = "Amanda";
        String benjamin = "Benjamin";
        assertThat(amanda, is(lessThan(benjamin)));
    }
```
## LocalDate
- 与 `Strings` 一样，我们可以比较日期

```java
    @Test
    public void givenToday_whenGreaterThanYesterday_thenCorrect() {
        LocalDate today = LocalDate.now();
        LocalDate yesterday = today.minusDays(1);
        assertThat(today, is(greaterThan(yesterday)));
    }


    @Test
    public void givenToday_whenLessThanTomorrow_thenCorrect() {
        LocalDate today = LocalDate.now();
        LocalDate tomorrow = today.plusDays(1);
        assertThat(today, is(lessThan(tomorrow)));
    }
```
## Custom Classes
- 利用订单匹配器与自定义订单规则一起使用
```java

    @Test
    public void givenAmanda_whenOlderThanBenjamin_thenCorrect() {
        Person amanda = new Person("Amanda", 20);
        Person benjamin = new Person("Benjamin", 18);
        assertThat(amanda, is(greaterThan(benjamin)));
    }

    @Test
    public void givenBenjamin_whenYoungerThanAmanda_thenCorrect() {
        Person amanda = new Person("Amanda", 20);
        Person benjamin = new Person("Benjamin", 18);
        assertThat(benjamin, is(lessThan(amanda)));
    }

    class Person implements Comparable<Person> {
        String name;
        int age;

        public Person(String name, int age) {
            this.name = name;
            this.age = age;
        }

        public String getName() {
            return name;
        }

        public int getAge() {
            return age;
        }

        //compareTo实现按年龄比较两个人
        @Override
        public int compareTo(Person o) {
            if (this.age == o.getAge()) return 0;
            if (this.age > o.age) return 1;
            else return -1;
        }
    }
```
# NaN Matcher
- 一个额外的数字匹配器来定义一个数字是否实际上是一个数字
```java
    @Test
    public void givenNaN_whenIsNotANumber_thenCorrect() {
        double zero = 0d;
        assertThat(zero / zero, is(notANumber()));
    }
```