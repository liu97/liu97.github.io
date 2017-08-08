---
title: jQuery学习笔记之jQuery对象与dom对象互相转换
date: 2017-06-02 23:50:11
categories: Blogs
tags: [jQuery]
---

通过标准的JavaScript操作DOM与jQuyer操作DOM的对比，我们不难发现：
1. 通过jQuery方法包装后的对象，是一个类数组对象。它与DOM对象完全不同，唯一相似的是它们都能操作DOM。
2. 通过jQuery处理DOM的操作，可以让开发者更专注业务逻辑的开发，而不需要我们具体知道哪个DOM节点有那些方法，也不需要关心不同浏览器的兼容性问题，我们通过jQuery提供的API进行开发，代码也会更加精短。

## jQuery对象转成DOM对象

> **利用数组下标的方式读取到jQuery中的DOM对象**

```javascript
var $div = $('div') //jQuery对象
var div = $div[0] //转化成DOM对象
div.style.color = 'red' //操作dom对象的属性
```

用jQuery找到所有的div元素（3个），因为jQuery对象也是一个数组结构，可以通过数组下标索引找到第一个div元素，通过返回的div对象，调用它的style属性修改第一个div元素的颜色。这里需要注意的一点是，数组的索引是从0开始的，也就是第一个元素下标是0

> **通过jQuery自带的get()方法**

```javascript
var $div = $('div') //jQuery对象
var div = $div.get(0) //通过get方法，转化成DOM对象
div.style.color = 'red' //操作dom对象的属性
```

get方法就是利用的第一种方式处理的，只是包装成一个get让开发者更直接方便的使用。

## DOM对象转化成jQuery对象

如果传递给$(DOM)函数的参数是一个DOM对象，jQuery方法会把这个DOM对象给包装成一个新的jQuery对象
HTML代码

```javascript
var div = document.getElementsByTagName('div'); //dom对象
var $div = $(div); //jQuery对象
var $first = $div.first(); //找到第一个div元素
$first.css('color', 'red'); //给第一个元素设置颜色
```