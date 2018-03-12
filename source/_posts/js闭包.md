---
title: js闭包
date: 2018-3-3 15:15:03
categories: Blogs
tags: [js]
---
闭包（closure）是Javascript语言的一个难点，也是它的特色，很多高级应用都要依靠闭包实现。<!--more-->
记得还没学闭包的时候，写过下面这段代码，当时硬是搞不明白问题到底出现在了哪里，直到我学到了js闭包，才恍然大悟原来是这样。
```javascript
function count(){
	var arr = [];
	for(var i =1;i <= 3;i++){
		arr.push(function(){
			return i;
		});
	}
	return arr;
}
var a = count();
console.log(a[0]()); //4
console.log(a[1]()); //4
console.log(a[2]()); //4
```
这种情况最好的解释就是:<u>JavaScript中的函数运行在它们被定义的作用域里，而不是它们被执行的作用域里。每次定义一个函数，都会产生一个作用域链（scope chain）。当JavaScript寻找变量varible时（这个过程称为变量解析），总会优先在当前作用域链的第一个对象中查找属性varible ，如果找到，则直接使用这个属性；否则，继续查找下一个对象的是否存在这个属性；这个过程会持续直至找到这个属性或者最终未找到引发错误为止。
那如果我要想实现原本想要的效果怎么办呢？</u>
**第一种：**
```javascript
function count(){
	var arr = [];
	for(let i =1;i <= 3;i++){ //将var改成let
		arr.push(function(){
			return i;
		});
	}
	return arr;
}
var a = count();
console.log(a[0]()); //1
console.log(a[1]()); //2
console.log(a[2]()); //3
```
ES6新增了let命令，用来声明变量。它的用法类似于var，但是所声明的变量，只在let命令所在的代码块内有效。上面代码中，变量i是let声明的，当前的i只在本轮循环有效，所以每一次循环的i其实都是一个新的变量，所以最后输出的是递增。你可能会问，如果每一轮循环的变量i都是重新声明的，那它怎么知道上一轮循环的值，从而计算出本轮循环的值？这是因为 JavaScript引擎内部会记住上一轮循环的值，初始化本轮的变量i时，就在上一轮循环的基础上进行计算。
另外，for循环还有一个特别之处，就是设置循环变量的那部分是一个父作用域，而循环体内部是一个单独的子作用域。
**第二种：**
```javascript
function count(){
	var arr = [];
	for(var i =1;i <= 3;i++){ 
		arr.push((function(n){
			return function(){
				return n;
			}
		})(i));
	}
	return arr;
}
var a = count();
console.log(a[0]()); //1
console.log(a[1]()); //2
console.log(a[2]()); //3
```
这里用了一个“创建一个匿名函数并立刻执行”的语法：
```javascript
(function(n){
	return function(){
		return n;
	}
})(i)
```
闭包有非常大的作用：1.使用闭包可以在JavaScript中模拟块级作用域；2.闭包可以用于在对象中创建私有变量。

## 感谢链接
[廖雪峰的官方网站](https://www.liaoxuefeng.com/wiki/001434446689867b27157e896e74d51a89c25cc8b43bdb3000/00143449934543461c9d5dfeeb848f5b72bd012e1113d15000#0)
[如何才能通俗易懂的解释javascript里面的‘闭包’](https://www.zhihu.com/question/34547104)
[阮一峰ECMAScript 6 入门](http://es6.ruanyifeng.com/#docs/let)