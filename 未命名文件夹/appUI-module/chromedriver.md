>注意：测试开发宝典中提及的**触屏操作自动化**链接改为：https://ceshiren.com/t/topic/4619 ，请有意向者移步该帖进行浏览

>chromedriver的介绍与相关资料地址，方便自动化测试工程师查阅


## 错误提示

未安装chromedriver
> No Chromedriver found that can automate Chrome '76.0.3809'. You could also try to enable automated chromedrivers download server feature. See https://github.com/appium/appium/blob/master/docs/en/writing-running-appium/web/chromedriver.md for more details

安装的版本不对
>Chrome version must be >=


## 海外版地址

https://chromedriver.storage.googleapis.com/index.html

## 淘宝CDN

https://registry.npmmirror.com/binary.html?path=chromedriver/

## appium的配置

```java

//简单的方案

        caps.setCapability("chromedriverExecutable", "/Users/seveniruby/projects/chromedriver/72/chromedriver");

//完善的方案
        caps.setCapability("chromedriverExecutableDir", "/Users/seveniruby/projects/chromedriver/2.20");
        caps.setCapability("chromedriverChromeMappingFile", "/Users/seveniruby/projects/Java3/src/test/java/test_app/wechat/mapping.json");
        caps.setCapability("showChromedriverLog", true);


```

## mapping.json

```json
{
  "83.0.4103.39": "83.0.4103.39",
  "81.0.4044.138": "81.0.4044.138",
  "81.0.4044.69": "81.0.4044.69",
  "81.0.4044.20": "81.0.4044.20",
  "80.0.3987.106": "80.0.3987.106",
  "80.0.3987.16": "80.0.3987.16",
  "79.0.3945.36": "79.0.3945.36",
  "79.0.3945.16": "79.0.3945.16",
  "78.0.3904.105": "78.0.3904.105",
  "78.0.3904.70": "78.0.3904.70",
  "78.0.3904.11": "78.0.3904.11",
  "77.0.3865.40": "77.0.3865.40",
  "77.0.3865.10": "77.0.3865.10",
  "76.0.3809.126": "76.0.3809.126",
  "76.0.3809.68": "76.0.3809.68",
  "76.0.3809.25": "76.0.3809.25",
  "76.0.3809.12": "76.0.3809.12",
  "75.0.3770.140": "75.0.3770.140",
  "75.0.3770.90": "75.0.3770.90",
  "75.0.3770.8": "75.0.3770.8",
  "74.0.3729.6": "74.0.3729",
  "73.0.3683.68": "70.0.3538",
  "2.46": "71.0.3578",
  "2.45": "70.0.0",
  "2.44": "69.0.3497",
  "2.43": "69.0.3497",
  "2.42": "68.0.3440",
  "2.41": "67.0.3396",
  "2.40": "66.0.3359",
  "2.39": "66.0.3359",
  "2.38": "65.0.3325",
  "2.37": "64.0.3282",
  "2.36": "63.0.3239",
  "2.35": "62.0.3202",
  "2.34": "61.0.3163",
  "2.33": "60.0.3112",
  "2.32": "59.0.3071",
  "2.31": "58.0.3029",
  "2.30": "58.0.3029",
  "2.29": "57.0.2987",
  "2.28": "55.0.2883",
  "2.27": "54.0.2840",
  "2.26": "53.0.2785",
  "2.25": "53.0.2785",
  "2.24": "52.0.2743",
  "2.23": "51.0.2704",
  "2.22": "49.0.2623",
  "2.21": "46.0.2490",
  "2.20": "44.0.2403",
  "2.19": "43.0.2357",
  "2.18": "43.0.2357",
  "2.17": "42.0.2311",
  "2.16": "42.0.2311",
  "2.15": "40.0.2214",
  "2.14": "39.0.2171",
  "2.13": "38.0.2125",
  "2.12": "36.0.1985",
  "2.11": "36.0.1985",
  "2.10": "33.0.1751",
  "2.9": "31.0.1650",
  "2.8": "30.0.1573",
  "2.7": "30.0.1573",
  "2.6": "29.0.1545",
  "2.5": "29.0.1545",
  "2.4": "29.0.1545",
  "2.3": "28.0.1500",
  "2.2": "27.0.1453",
  "2.1": "27.0.1453",
  "2.0": "27.0.1453"
}
```



## appium中的chromedriver说明

https://github.com/appium/appium/blob/master/docs/en/writing-running-appium/web/chromedriver.md

## firefox geckodriver

https://github.com/mozilla/geckodriver/releases