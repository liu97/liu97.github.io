---
title: js面向对象笔记
categories: Blogs
tags: [js]
---

## 1.构造函数的实例对象的constructor指向构造函数	
```javascript
function Cat(name,color){
	this.name=name;
	this.color=color;
}
let cat1 = new Cat('tom' , 'orange');
let cat2 = new Cat('jack' , 'black');
console.log(cat1.constructor == Cat) // true
```

## 2.构造函数有prototype属性，指向一个对象，这个对象的所有属性和方法都会被构造函数的实例继承

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

## 3.几个实用的验证方法
```javascript
isPrototypeOf() 验证实例与prototype之间的关系
console.log(Cat.prototype.isPrototypeOf(cat1)) // true

hasOwnProperty() 验证是实例上的属性还是prototype上的属性
console.log(cat1.hasOwnProperty("type")) // true
console.log(cat2.hasOwnProperty("type")) // false

in运算符 //验证某个实例是否含有某个属性，不管是不是本地属性
console.log("type" in cat1) // true
console.log("type" in cat2) // true
console.log("haha" in cat1) // false
```