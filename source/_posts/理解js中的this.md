---
title: 理解js中的this
date: 2018-04-22 22:28:39
categories: Blogs
tags: [js,jquery]
---
this是Javascript语言的一个关键字。它代表函数运行时，自动生成的一个内部对象，只能在函数内部使用。<!--more-->

## js中this的基础用法
**1.在函数中使用**
全局性调用函数时，this就代表全局对象window。
```javascript
var x = 1;
function test_this(){
	console.log(this.x);
	console.log(this);
}
test_this(); // 输出  1    window;
```
当调用test_this函数时，运行到console.log(this)时，这里的this是指window,所以下一行的this.x == 1。

**2.通过对象方法调用**
函数还可以作为某个对象的方法调用，这时this就指这个上级对象。
```javascript
var x = 1;
function test_this(){
	console.log(this.x);
	console.log(this);
}
obj = {
	x : 2,
	test_this : test_this
}
obj.test_this(); // 输出  2    obj;
```

**3.通过构造函数**
当通过构造函数的一个对象调用函数时，this指向这个对象。
```javascript
var x = 1;
function test_this(){
	console.log(this.x);
	console.log(this);
}
test_this.prototype.x = 2;
var t = new test_this() // 输出  2     t;
```

## this的4种绑定规则
上面的介绍知识this的几个最基本的用法，下面我们来介绍this的4种绑定规则。
### 默认绑定
**1.全局环境**
全局环境中，this默认绑定到window
```javascript
console.log(this === window);//true
```
**2.函数独立调用**
函数独立调用时，this默认绑定到window
也就是上一节**js中this的基础用法**的第一例
**3.嵌套的函数独立调用**
被嵌套的函数独立调用时，this默认绑定到window
```javascript
var x = 1;
function test_this(){
	function nest(){
		console.log(this.x);
		console.log(this);
	}
	nest();
}
obj = {
	x : 2,
	test_this : test_this
}
obj.test_this(); // 输出  1    window;
//虽然是通过obj对象调用,但是nest函数时独立调用，而不是方法调用。所以this默认绑定到window。
```
**4.立即执行函数**
立即执行函数实际上是函数声明后直接调用执行
```javascript
var x = 1;
function test_this(){
	(function nest(){
		console.log(this.x);
		console.log(this);
	})()
	
}
obj = {
	x : 2,
	test_this : test_this
}
obj.test_this(); // 输出  1    window;
```
**5.闭包**
类似地，nest()函数是独立调用，而不是方法调用，所以this默认绑定到window
```javascript
var x = 1;
function test_this(){
	function nest(){
		console.log(this.x);
		console.log(this);
	}
	return nest
}
obj = {
	x : 2,
	test_this : test_this
}
obj.test_this()(); // 输出  1    window;
```

### 隐式绑定
一般地，被直接对象所包含的函数调用时，也称为方法调用，this隐式绑定到该直接对象。
也就是上一节**js中this的基础用法**的第二例

### 隐式丢失
隐式丢失是指被隐式绑定的函数丢失绑定对象，从而默认绑定到window。这种情况容易出错却又常见。
**1.给对象函数取别名**
```javascript
var x = 1;
function test_this(){
	console.log(this.x);
	console.log(this);
}
obj = {
	x : 2,
	test_this : test_this
}
var lost = obj.test_this;
lost(); // 输出  1    window;
```
**2.把对象函数作为参数**
```javascript
var x = 1;
function test_this(){
	console.log(this.x);
	console.log(this);
}
obj = {
	x : 2,
	test_this : test_this
}
function lost(fun){
	fun()
}
lost(obj.test_this); // 输出  1    window;
```
**通过内置函数**
内置函数与上例类似，也会造成隐式丢失
```javascript
var x = 1;
function test_this(){
	console.log(this.x);
	console.log(this);
}
obj = {
	x : 2,
	test_this : test_this
}
window.setTimeout(obj.test_this,1000)
```
**间接引用**
```javascript
var x = 1;
function test_this(){
	console.log(this.x);
	console.log(this);
}
obj = {
	x : 2,
	test_this : test_this
}
obj1 = {
	x : 3,
}
(obj1.test_this = obj.test_this)() // 输出  1    window;
//将obj.test_this赋值给obj1.test_this,然后立即调用相当于仅仅是test_this函数的立即执行
```

```javascript
var x = 1;
function test_this(){
	console.log(this.x);
	console.log(this);
}
obj = {
	x : 2,
	test_this : test_this
}
obj1 = {
	x : 3,
}
obj1.test_this = obj.test_this // 输出  1    window;
obj1.test_this()
//将obj.test_this赋值给obj1.test_this,然后通过obj1调用test_this时this指向obj1
```

### 显式绑定
通过call()、apply()、bind()方法把对象绑定到this上，叫做显式绑定。对于被调用的函数来说，叫做间接调用。
```javascript
var x = 1;
function test_this(){
	console.log(this.x);
	console.log(this);
}
obj = {
	x : 2,
	test_this : test_this
}
test_this.call(obj); // 输出  2    obj;
test_this.apply(obj); // 输出  2    obj;
test_this.bind(obj)(); // 输出  2    obj;
```

## 箭头函数中this
Arrow Function中的this机制和一般的函数是不一样的。
本质来说Arrow Function并没有自己的this，它的this是派生而来的，根据“词法作用域”派生而来。也就是箭头函数在定义时this就已经确定好，当在本作用域中找不到，就会一直向父作用域中查找，直到找到为止。
举个例子：
```javascript
function taskA() {
  this.name = 'hello';
  
  var fn = function() {
    console.log(this);
    console.log(this.name);
  }
  
  var arrow_fn = () => {
    console.log(this);
    console.log(this.name);
  }
  fn();
  arrow_fn();
}
taskA()
```
> 最终我们会发现，两个内部函数的this都是window，而且this.name都是hello。
好像没什么区别。其实两个函数的this的产生流程是不一样的。
fn的this是在运行时产生的，由于我们是直接调用fn()，所以其this就是指向window。
arrow_fn根据“词法作用域”，由于它本身没有this，于是便向上查找this，于是发现taskA是有this的，于是便直接继承了taskA的作用域。而taskA的this就是window。

再看一个例子：
```javascript
function taskA() {
  var arrow_fn = () => {
    console.log(this)
    console.log(this.name)
  }
  arrow_fn()
}
var obj = {name: 'Jack'}
taskA.bind(obj)()
```
> 这时候，Arrow Function中的this便变成了obj对象了，name便是Jack。
可能有人会说，不是说Arrow Function中的this是定义的时候就决定了么，怎么现在又变成了运行的时候决定了呢。
Arrow Function中的this是定义的时候就决定的，这句话是对的。
该案例中，Arrow Function中，即arrow_fn的this便是taskA的this，在定义这个arrow_fn时候便决定了，于是又回到了上面说的，taskA是一个普通的函数，普通函数的this是在运行时决定的，而此时由于bind的原因，taskA的this已经变为obj，因此arrow_fnd的this便是obj了。
