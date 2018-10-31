---
title: call、apply、bind的用法及模拟
date: 2018-10-31 16:39:23
categories: Blogs
tags: [js]
---
call、apply、bind的作用是改变函数运行时this的指向。<!--more-->
## 用法
```javascript
var name = 'window';
var obj = {
	name: 'obj',
}
function fn(arg1, arg2){
	this.age = '18';
	console.log(this.name, arg1, arg2);
}

// call
fn.call(obj, 'hello', 'call'); // obj, hello, call

// apply
fn.apply(obj, ['hello','apply']); // obj, hello, apply

// bind
var bFun = fn.bind(obj, 'hello');
bFun('bind'); // obj, hello, apply

// bind 构造
fn.prototype.sex = 'man';
var bFun = fn.bind(obj, 'hello');
var nObj = new bFun('apply'); // undefined hello apply
console.log(nObj.age); // 18 继承自fn
console.log(nObj.sex); //man 继承自fn原型链
```
## 使用场景
* 将类数组对象转为真正的数组
```javascript
let arrayLike = {
    '0': 'a',
    '1': 'b',
    '2': 'c',
    length: 3
};
var arr1 = [].slice.call(arrayLike); // ['a', 'b', 'c']

var domNodes = Array.prototype.slice.apply(document.getElementsByTagName("div"));
```

* 防止setTimeout导致this丢失
```javascript
var id="not awesome";
var obj={ 
	id:"awesome",
	cool:function coolFn(){
	  		console.log(this.id);
	 	 }
};
obj.cool(); // awesome
setTimeout(obj.cool, 1000); // not awesome
setTimeout(obj.cool.bind(obj), 1000); // awesome
```

## call、apply、bind的模拟
```javascript
// call
Function.prototype.call2 = function(obj, ...args){
	obj = obj || window;
	obj.fun = this; //隐式绑定
	var res = obj.fun(...args);
	delete obj.fun;
	return res;
}


// apply
Function.prototype.apply2 = function(obj, args){
	obj = obj || window;
	obj.fun = this; 
	var res = obj.fun(...args);
	delete obj.fun;
	return res;
}
// or
Function.prototype.apply2 = function(obj, args){
	this.call2(obj, ...args);
}


// bind
Function.prototype.bind2 = function(oThis, ...args) {
	if (typeof this !== "function") {
		throw new TypeError( "Function.prototype.bind - what is trying to be bound is not callable");
	}

	var fToBind = this,
		fNOP = function(){},
		fBound = function(bindArgs){
			// 当作为构造函数时，this指向实例，当作为普通函数时this指向oThis
			return fToBind.apply( this instanceof fNOP ? this : oThis, [...args, ...bindArgs] );
		};
	// 修改返回函数的 prototype 为绑定函数的一个实例，我们new出来的实例就可以继承函数的原型中的值
	fNOP.prototype = this.prototype;
	fBound.prototype = new fNOP();

	return fBound;
};
```