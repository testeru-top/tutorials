---
tags: note,selenium,js
status: todo
priority: 1
time: 2022-07-05 20:31
things:  "[🧊](things:///show?id=JtkDsmtmq6Bd8ZbzKBJTW4)"
---
-   从 (0,0) 滑动 x,y 距离

```
window.scroll(x,y)
```

-   从当前位置滑动 x,y 距离

```
window.scrollBy(x,y)
```

-   滑动到底部位置

```
window.scroll(0, document.documentElement.scrollHeight)
```

-   滑动到顶部位置

```
window.scroll(0, 0)
```

-   滑动元素至顶部对齐，可以使用 selenium 自带的，也可以用 js

```
element.location_once_scrolled_into_view
或者
driver.execute_script('arguments[0].scrollIntoView({block: "start"})', element)
或者
driver.execute_script('arguments[0].scrollIntoView(true)', element)
```

-   滑动元素至屏幕中间

```
driver.execute_script('arguments[0].scrollIntoView({block: "center"})', element)
```

-   滑动元素至屏幕底部对齐

```
driver.execute_script('arguments[0].scrollIntoView({block: "end"})', element)
或者
driver.execute_script('arguments[0].scrollIntoView(flase)', element)
```

-   缩放页面

```
js = "document.body.style.zoom='60%'"
```