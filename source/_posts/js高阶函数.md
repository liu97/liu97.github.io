---
title: js高阶函数
date: 2018-3-7 15:15:03
categories: Blogs
tags: [js]
---

JavaScript的函数其实都指向某个变量。既然变量可以指向函数，函数的参数能接收变量，那么一个函数就可以接收另一个函数作为参数，这种函数就称之为高阶函数。js常用的系统定义的高阶函数有map、reduce、filter、sort。<!--more-->
## map函数
由于map()方法定义在JavaScript的Array中，我们调用Array的map()方法，传入我们自己的函数，就得到了一个新的Array作为结果。
假如我们现在要将函数f(x) = 2 * x作用在数组[1,2,3,4,5,6,7]上，就可以用map实现。
```javascript
function byTwo(x){
	return 2 * x;
}
var arr = [1,2,3,4,5,6,7];
var result = arr.map(byTwo);
console.log(result); //[2, 4, 6, 8, 10, 12, 14]
```
*注意：map()传入的参数是pow，即函数对象本身。调用完函数后会重新生成一个数组，不会改变原来数组。*

## reduce函数
Array的reduce()把一个函数作用在这个Array的[x1, x2, x3...]上，这个函数必须接收两个参数，reduce()把结果继续和序列的下一个元素做累积计算，其效果就是：
> [x1, x2, x3, x4].reduce(f) = f(f(f(x1, x2), x3), x4)
假如我们要对一个数组求和，数组为[1,3,5,7,9]
```javascript
function sum(x,y){
	return x+y;
}
var arr = [1,3,5,7,9];
var result = arr.reduce(sum);
console.log(result); // 25
```

## filter函数
filter也是一个常用的操作，它用于把Array的某些元素过滤掉，然后返回剩下的元素。
和map()类似，Array的filter()也接收一个函数。和map()不同的是，filter()把传入的函数依次作用于每个元素，然后根据返回值是true还是false决定保留还是丢弃该元素。
例如，在一个Array中，删掉大于10的数，可以这么写：
```javascript
var arr = [1,3,5,17,19];
var result = arr.filter(function(x){
		return x<=10;
	});
console.log(result); // 25
```
**回调函数**
filter()接收的回调函数，其实可以有多个参数。通常我们仅使用第一个参数，表示Array的某个元素。回调函数还可以接收另外两个参数，表示元素的位置和数组本身：
```javascript
var arr = ['A', 'B', 'C'];
var r = arr.filter(function (element, index, self) {
    console.log(element); // 依次打印'A', 'B', 'C'
    console.log(index); // 依次打印0, 1, 2
    console.log(self); // self就是变量arr
    return true;
});
```

## sort函数
JavaScript的Array的sort()方法就是用于排序的，但是排序结果不是你简单想象的那样，我们来看下下面这几组输出：
```javascript
console.log([1,12,3,4,23].sort()); //[1, 12, 23, 3, 4]
console.log(["jack","japan","abandon","back"].sort()); //["abandon", "back", "jack", "japan"]
```
第一个莫名其妙，说好的排序呢？12和23明显比3和4大啊，怎么还排在他们前面？原来当调用sort()函数后默认把所有元素先转换为String再排序，因为'12'第一个数'1'和'23'的第一个数'2'比3和4的ascii码小，所以排在他们前面。那么问题又来了，我们就是要按数字大小排序啊，现在怎么搞。别急，下面就是答案：
```javascript
var arr = [1,12,3,4,23];
arr.sort(function (x, y) { //如果要从大到小排序，下面的大于号改成小于号，小于号改成大于号就好了
    if (x < y) {
        return -1; 
    }
    if (x > y) {
        return 1;
    }
    return 0;
});
console.log(arr); //[1,3,4,12,23]
```
第二个又是怎么排序的呢？其实默认情况下，对字符串排序，是按照ASCII的大小比较的，哦，原来是这样，但是这里还是有一个要小心的，就是字母大小写：
```javascript
console.log(["jack","Japan","Abandon","back"].sort()); //["Abandon", "Japan", "back", "jack"]
var arr = ["jack","Japan","Abandon","back"];
arr.sort(function (s1, s2) {
    x1 = s1.toUpperCase();
    x2 = s2.toUpperCase();
    if (x1 < x2) {
        return -1;
    }
    if (x1 > x2) {
        return 1;
    }
    return 0;
}); // 
```
*注意：sort()方法会直接对Array进行修改*

## 感谢链接
[廖雪峰的官方网站](https://www.liaoxuefeng.com/wiki/001434446689867b27157e896e74d51a89c25cc8b43bdb3000/001434499355829ead974e550644e2ebd9fd8bb1b0dd721000)