---
title: new的用法及模拟
date: 2020-09-24 14:11:56
categories: Blogs
tags: [js]
---
`new`运算符可以创建一个用户定义的对象类型的示例或者构造哈数的内置对象的示例。<!--more-->

## 用法
```javascript
function Animal(type){
  this.type = type;
}
let dog = new Animal('dog') // { type: 'dog' }

function Animal(type){
  this.type = type;
  return { name: 'animal' } // 在构造函数里返回对象
}
let dog = new Animal('dog') // { name: 'animal' }

function Animal(type){
  this.type = type;
  return function fun(){} // 在构造函数里返回函数
}
let dog = new Animal('dog') // function fun(){}

function Animal(type){
  this.type = type;
  return null // 在构造函数里返回null or 非对象
}
let dog = new Animal('dog') // { type: 'dog' }
```

## 模拟

```javascript
new constructor([arguments])
```

运行`new`运算符后的执行的步骤：

1. 判断`constructor`是否为函数或者类，不是抛出错误
2. 创建一个空对象
3. 将该对象的原型指向`constructor.prototype`
4. 将步骤2新创建的对象作为`this`的上下文 
5. 如果该函数没有返回对象，则返回`this`

由于class只能通过new操作符来实例化，所以这里只能实现模拟构造函数的`new`操作：
```javascript
function isObject(obj){
  return typeof obj === 'object' && obj !== null
}
function isFunction(fun){
  return typeof fun === 'function'
}
function newOperator(fun, ...args){
  if(typeof fun !== 'function'){
    return throw Error(`${JSON.stringify(fun)} is not a constructor`)
  }
  let obj = Object.create(fun.prototype)
  let back = fun.call(obj, ...args)
  if(isObject(back) || isFunction(back)){
    return back
  }else{
    return obj
  }
}
```