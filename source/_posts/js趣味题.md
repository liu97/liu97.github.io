---
title: js趣味题
date: 2018-09-19 11:24:31
categories: Blogs
tags: [js]
---
&emsp;&emsp;昨天公司的大佬给我出了一个难题，弱弱的我说一定有解决办法，但是以知识点不熟搪塞过去。然后问大佬这个难题的解决办法，大佬给了一点提示，然后起身对我说：你慢慢想，要是明天还没解决我再告诉你。留下我只身在风中凌乱。不过我又立马回过神来，作为科班出身的我肯定要自己一探究竟啊，遂立马开始思考。<!--more-->
## 题目
```javascript
//以下的代码不能动，以上可以随意发挥，最终需要输出1
if( a==1 && a==2 && a==3){
	console.log(1);
}
else{
	console.log(2);
}
```
&emsp;&emsp;乍一看，这问题简直是无理啊，而且我平时判断相等也是用双等，没出过什么问题啊。这道题要是解决了那我以前的代码岂不是有大大的漏洞？皇天不负有心人，思考良久后终于找到了解决办法。那么你思考好了么？要是实在是想不出来那就继续往下看吧！
##解决方法
&emsp;&emsp;要命的是这道题竟然不止一种解决方法(目前我知道两种)。
### 方法一
&emsp;&emsp;说一下我的思路：
&emsp;&emsp;1. 首先思考一下`a && b`的判断规则，先判断`a`是否为真，如果`a`为真才开始判断`b`,重点不在规则，而在`a && b`是有一个顺序关系的，所以我们可以在访问a上面做手脚，让每次访问`a`都会让`a=a+1`，这样的话`a==1 && a==2 && a==3`就有可能成立啦。
&emsp;&emsp;2. 以第一个思路为起点，js存不存在自加变量，每次访问该变量自加？恩 答案是没有。
&emsp;&emsp;3. 那咱们可不可以将a等于一个自执行函数，然后每次访问都会执行该自执行函数？试了一下之后突然发现是不是傻，自执行函数的性质都没搞懂，下一个。
&emsp;&emsp;4. 关键点来啦，记得js里defineProperty有访问器属性，每次访问obj.name属性时都会执行get函数，那么我们可以在get函数里做手脚，这样完美的实现了访问自加的效果啦：
```javascript
var obj = {};
var i = 0;
Object.defineProperty(obj, 'a', {
    enumerable: true,
    configurable: true,
    get: function() {
    	window.i++;
        return window.i;
    },
    set: function(val) {
        a = val;
    }
});
```
&emsp;&emsp;5. 上面实现的是`obj.a==1 && obj.a==2 && obj.a==3`，还差一步，那就是把obj换成window就好啦：
```javascript
var i = 0;
Object.defineProperty(window, 'a', {
    enumerable: true,
    configurable: true,
    get: function() {
		window.i++;
		return window.i;
    },
    set: function(val) {
        //调用处理函数
        name = val;
    }
});
```
### 方法二
&emsp;&emsp;第二天也就是今天找大佬求证，大佬说这也是一种解决办法，还有一种解决办法，通过在`==`的隐式转换里做手脚。 当将一个数字和其他类型进行`==`判断时会讲其他类型转换成数字，也就是说`1=='1'`会讲字符串`'1'`通过Number函数转换成数字`1`。
关键点来啦，将数字与对象比较时会将先访问对象valueOf函数，我们可以`var a = new Number(1)`,这样a就是Number构造函数的一个实例，当进行比较`a == 1`的时候会先执行`a.valueOf()`,那我们可以修改a的valueOf函数来达到目的:
```javascript
var i = 0;
var a = new Number('1');
a.valueOf = function(){
	window.i++;
	return window.i;
}
```

这样一来，就完美解决了难题啦！