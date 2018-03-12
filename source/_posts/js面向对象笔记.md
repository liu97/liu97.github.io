---
title: js面向对象笔记
date: 2018-2-27 15:15:03
categories: Blogs
tags: [js]
---
在学习js面向对象时，每次学了不运用，不过多久就会忘，所以今天跟着阮一峰老师的理解记下笔记，以下为学习时自己的理解。<!--more-->
## 1.封装
**一、构造函数的实例对象的constructor指向构造函数	**
```javascript
function Cat(name,color){
	this.name=name;
	this.color=color;
}
let cat1 = new Cat('tom' , 'orange');
let cat2 = new Cat('jack' , 'black');
console.log(cat1.constructor == Cat) // true
```
**二、构造函数有prototype属性，指向一个对象，这个对象的所有属性和方法都会被构造函数的实例继承**
```javascript
Cat.prototype.type = "猫科动物";
Cat.prototype.action = ()=> console.log("吃老鼠");

cat1.type == "猫科动物" // true
```

这时每个实例的的type和action都是指向同一内存地址，也就是prototype对象，节省了内存。
当实例改变了prototype上的属性时，只会改变当前实例的属性，prototype的属性并不会更改，也就不会影响其他实例，方法同上，以下也只说属性，方法同样。
原因：既然实例会继承prototype指向的对象，于是cat1.__proto__ == Cat.prototype,当访问实例属性时，先会在实例上找有没有该属性，没有的话便顺着原型链往上一级找，上一级也就是Cat.prototype。当实例改变了prototype上的属性(cat1.type)，相当于在实例上添加了属性，并不会改变原型链上祖辈的属性，于是下次访问该属性(cat1.type)时，在实例上找到了该属性，便不会再往原型链上级找。

```javascript
cat1.type = "哺乳动物";
console.log(cat1.type) // "哺乳动物"
console.log(cat2.type) // "猫科动物"
console.log(Cat.prototype.type) // "猫科动物"
```

**三、几个实用的验证方法**

```javascript
isPrototypeOf() 验证实例与prototype之间的关系
console.log(Cat.prototype.isPrototypeOf(cat1)) // true

hasOwnProperty() 验证是实例上的属性还是prototype上的属性
console.log(cat1.hasOwnProperty("type")) // true
console.log(cat2.hasOwnProperty("type")) // false

in运算符 验证某个实例是否含有某个属性，不管是不是本地属性
console.log("type" in cat1) // true
console.log("type" in cat2) // true
console.log("haha" in cat1) // false
```

## 2.构造函数的继承

**一、构造函数绑定**
用call或者apply的方法将父对象的构造函数绑定在子对象的构造函数中。*这种方法只能继承构造器里的属性和方法*
```javascript
function Animal(){
	this.species = "动物";
}
function Cat(name,color){
	Animal.apply(this,arguments); // 绑定
	this.name=name;
	this.color=color;
}
```

**二、prototype修改**
将子对象的构造函数的prototype直接指向父对象的构造函数的实例。由于直接修改了prototype指向的对象，导致prototype的constructor的值变为父对象的构造函数，每当访问实例或者prototype的constructor属性，都会调用prototype对象的constructor属性，这样当然会破坏constructor的原本设计初衷，于是也要讲prototype的constructor重新指向子对象的构造函数。*这种方法能继承构造器里的属性和方法，也能继承原型链上的属性和方法*

```javascript
Cat.prototype = new Animal();
let cat3 = new Cat("aimi","white");
console.log(Cat.prototype.__proto__ == Animal.prototype) // true
console.log(Cat.prototype.constructor == Animal) // true
console.log(cat3.constructor == Animal) // true
console.log(cat3.__proto__ == Cat.prototype) // true
Cat.prototype.constructor = Cat; //修改prototype.constructor
let cat3 = new Cat("aimi","white");
console.log(cat4.constructor == Cat) // true
```

**三、直接赋值prototype** 
将父对象的prototype直接赋值给子对象的prototype，实现了继承，这种方法有一个很大的特性就是Cat.prototype和Animal.prototype现在指向了同一个对象，那么任何对Cat.prototype的修改，都会反映到Animal.prototype。*这种方法只能继承原型链上的属性和方法*
```javascript
function Animal(){ }
Animal.prototype.species = "动物";
Cat.prototype = Animal.prototype;
Cat.prototype.constructor = Cat;
var cat1 = new Cat("大毛","黄色");
console.log(cat1.species); // "动物"
console.log(Animal.prototype.constructor); // "Cat"
```

**四、利用空对象作为中介**
由于"直接继承prototype"存在上述的缺点，所以就有第四种方法，利用一个空对象作为中介。*这种方法只能继承原型链上的属性和方法*
```javascript
var F = function(){};
F.prototype = Animal.prototype;
Cat.prototype = new F();
Cat.prototype.constructor = Cat;
console.log(Animal.prototype.constructor); // Animal
console.log(Cat.prototype.__proto__ == Animal.prototype); // Animal
```
我们将上面的方法，封装成一个函数，便于使用。这个extend函数，就是YUI库如何实现继承的方法
```javascript
function extend(Child, Parent) {
　　var F = function(){};
　　F.prototype = Parent.prototype;
　　Child.prototype = new F();
　　Child.prototype.constructor = Child;
　　Child.uber = Parent.prototype; // 为子对象设一个uber属性，这个属性直接指向父对象的prototype属性

}
```

**五、拷贝继承**
把父对象的所有属性和方法，拷贝进子对象，也能够实现继承。*这种方法只能继承原型链上的属性和方法*
```javascript
function Animal(){}
Animal.prototype.species = "动物";
function extend2(Child, Parent) {
　　var p = Parent.prototype;
　　var c = Child.prototype;
　　for (var i in p) {
　　　　c[i] = p[i];
　　}
　　c.uber = p;
}
```

## 3.非构造函数的继承

**一、object()方法**
这个object()函数，其实只做一件事，就是把子对象的prototype属性，指向父对象，从而使得子对象与父对象连在一起。*类似第二节里《四、利用空对象作为中介》*
```javascript
let Chinese = {
　　nation:'中国'
};
function object(parent){
	function F(){};
	F.prototype = parent;
	return new F();
}
let Doctor = object(Chinese);
Doctor.career = '医生';
```

**二、浅拷贝**
除了使用"prototype链"以外，还有另一种思路：把父对象的属性，全部拷贝给子对象，也能实现继承。*类似第二节里《五、拷贝继承》*
```javascript
function extendCopy(parent){
	var c = {};
	for(let i in parent){
		c.i = parent.i;
	} 
	c.uber = parent;
	return c;
}
```
但是，这样的拷贝有一个问题。那就是，如果父对象的属性等于数组或另一个对象，那么实际上，子对象获得的只是一个内存地址，而不是真正拷贝，因此存在父对象被篡改的可能。
```javascript
Chinese.birthPlaces = ['北京','上海','香港'];
var Doctor = extendCopy(Chinese);
Doctor.birthPlaces.push('厦门');
console.log(Doctor.birthPlaces); //北京, 上海, 香港, 厦门
console.log(Chinese.birthPlaces); //北京, 上海, 香港, 厦门
```
所以，extendCopy()只是拷贝基本类型的数据，我们把这种拷贝叫做"浅拷贝"。这是早期jQuery实现继承的方式。

**三、深拷贝**
所谓"深拷贝"，就是能够实现真正意义上的数组和对象的拷贝。它的实现并不难，只要递归调用"浅拷贝"就行了。
```javascript
function deepCopy(p, c) {
　　var c = c || {};
　　for (var i in p) {
　　　　if (typeof p[i] === 'object') {
　　　　　　c[i] = (p[i].constructor === Array) ? [] : {};
　　　　　　deepCopy(p[i], c[i]);
　　　　} else {
　　　　　　　c[i] = p[i];
　　　　}
　　}
　　return c;
}
var Doctor = deepCopy(Chinese);
Chinese.birthPlaces = ['北京','上海','香港'];
Doctor.birthPlaces.push('厦门');
console.log(Doctor.birthPlaces); //北京, 上海, 香港, 厦门
console.log(Chinese.birthPlaces); //北京, 上海, 香港
```
目前，jQuery库使用的就是这种继承方法。

## 4.class继承

新的关键字class从ES6开始正式被引入到JavaScript中。class的目的就是让定义类更简单。class的定义包含了构造函数constructor和定义在原型对象上的函数hello()（注意没有function关键字），这样就避免了Student.prototype.hello = function () {...}这样分散的代码。

```javascript
class Student{
	constructor(name){
		this.name = name;
	}
	hello(){
		console.log("hello");
	}
}
let std1 = new Student("xiaoming");
let std2 = new Student("lining");
console.log(std1.hello == std2.hello); //true
class PrimaryStudent extend Student{
	constructor(name,grade){
		super(name);
		this.grade = grade;
	}
	myGrade(){
		return this.grade;
	}
}
```

## **感谢链接**
[Javascript 面向对象编程](http://www.ruanyifeng.com/blog/2010/05/object-oriented_javascript_encapsulation.html)
[廖雪峰的官方网站](https://www.liaoxuefeng.com/wiki/001434446689867b27157e896e74d51a89c25cc8b43bdb3000/001458267339633fd3a83c597d04b5fb59f7d1f6792efb3000)