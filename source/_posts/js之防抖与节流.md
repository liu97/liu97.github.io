---
title: js之防抖与节流
date: 2018-08-20 22:25:59
categories: Blogs
tags: [js]
---
在平时写代码的时候，经常会有一些频繁性的操作，比如：输入框输入、删除；浏览器窗口放大缩小；滚动条的滚动等等。这些操作会频繁触犯绑定的函数，如果你在绑定的函数里操作大量的DOM或者发送请求等等操作，将会耗费大量的资源。针对这些情况，出现了防抖(debounce)和节流(throttle)两个概念。<!--more-->

## 防抖动
>如果一个函数持续地触发，那么只在它结束后过一段时间只执行一次。

### 应用场景
现有一个input输入框，当输入框的内容改变时发送请求至后端查询相关内容，由于输入操作是频繁性的操作，导致每次输入一个字符或者删除一个字符都会发送一个请求，这无疑是浪费了资源，这时候我们就可以应用到防抖了，当用户停止输入后x毫秒再发送请求，避免了资源的浪费。

### 实现
我们可以将防抖封装成一个函数，传入的参数为需要出发的函数和防抖时间
```javascript
function debounce(fn,delay){
    var delay=delay||200;
    var timer;
    return function(){
        var th=this;
        var args=arguments;
        if (timer) {
            clearTimeout(timer);
        }
        timer=setTimeout(function () {
                timer=null;
                fn.apply(th,args);
        }, delay);
    };
}
```

## 节流
>如果一个函数持续的，频繁地触发，那么让它在一定的时间间隔后再触发。

### 应用场景
比如在页面的无限加载场景下，我们需要用户在滚动页面时，每隔一段时间发一次 Ajax 请求，而不是在用户停下滚动页面操作时才去请求数据。这样的场景，就适合用节流阀技术来实现。
> 主要有两种实现方法：
> 时间戳
> 定时器

### 时间戳实现
```javascript
var throttle = function(func,delay){
    var prev = Date.now();
    return function(){
        var context = this;
        var args = arguments;
        var now = Date.now();
        if(now-prev>=delay){
            func.apply(context,args);
            prev = Date.now();
        }
    }
}
```
当高频事件触发时，第一次应该会立即执行（给事件绑定函数与真正触发事件的间隔如果大于delay的话），而后再怎么频繁触发事件，也都是会每delay秒才执行一次。而当最后一次事件触发完毕后，事件也不会再被执行了。

### 定时器实现
```javascript
var throttle = fucntion(func,delay){
    var timer = null;

    return funtion(){
        var context = this;
        var args = arguments;
        if(!timer){
            timer = setTimeout(function(){
                func.apply(context,args);
                timer = null;
            },delay);
        }
    }
}
```
当第一次触发事件时，肯定不会立即执行函数，而是在delay秒后才执行。之后连续不断触发事件，也会每delay秒执行一次。 当最后一次停止触发后，由于定时器的delay延迟，可能还会执行一次函数。

### 综合
可以综合使用时间戳与定时器，完成一个事件触发时立即执行，触发完毕还能执行一次的节流函数：
```javascript
var throttle = function(func,delay){
    var timer = null;
    var startTime = Date.now();

    return function(){
        var curTime = Date.now();
        var remaining = delay-(curTime-startTime);
        var context = this;
        var args = arguments;

        clearTimeout(timer);
        if(remaining<=0){
            func.apply(context,args);
            startTime = Date.now();
        }else{
            timer = setTimeout(func.apply(context,args),remaining);
        }
    }
}
```

## 感谢链接
[js:防抖动与节流](https://blog.csdn.net/crystal6918/article/details/62236730)