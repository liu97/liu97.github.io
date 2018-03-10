---
title: js事件模型系列知识(一)
categories: Blogs
tags: [js]
---
事件模型，记得第一次看这个名词的我一脸懵逼，学了这么久js，事件模型是什么鬼，只听过像click、mouseover、load、keypress这样的事件啊。所以我查了一下，发现原来和事件捕获和事件冒泡有关哦，当时学到事件冒泡的时候，貌似老师说过事件冒泡用的不好会出很多莫名的bug，所以打心底的很抵触冒泡，随处乱用stopPropagation()。如果你现在还是像我刚刚讲的那种状态，那么你可以看看我写的这几篇对事件模型系列知识的简单介绍，不一定写的很好，请见谅。<!--more-->

## 事件对象
兼容DOM的浏览器会将一个event对象传入到事件处理程序中（事件处理程序后面会讲）。无论指定事件处理程序时使用什么方法，都会传入event对象，来看下面例子。
```javascript
var btn = document.getElementById("myBtn");
btn.onclick = function(event){
	console.log(event);
};
btn.addEventListener("click",function(event){
	console.log(event);
},false);
```
上面两种事件处理程序都会在控制台输出event对象，我们来看看点击后传入的event对象是个什么样子：
![MouseEvent对象](/img/事件模型/11.png)
我们可以看到是一个MouseEvent对象，里面有鼠标点击位置，事件类型等属性，当我们点开MouseEvent对象的__proto__属性时可以看到MouseEvent对象是MouseEvent构造函数的一个实例：
![MouseEvent对象](/img/事件模型/12.png)
继续查看构造函数MouseEvent.prototype的__proto__属性,发现构造函数MouseEvent是继承于构造函数UIEvent，再继续查看构造函数UIEvent.prototype的__proto__属性，发现构造函数UIEvent构造函数，再往上就是Object了。每级构造函数都有各自的属性或者方法:
![MouseEvent对象](/img/事件模型/13.png)
### 事件对象常用的属性及方法
**1.事件定位相关属性**
这部分属性平时用的还是挺多的，所以得着重介绍。如果你细细看了MouseEvent对象里的属性，一定发现了有很多带X/Y的属性，它们都和事件的位置相关。具体包括：x/y、clientX/clientY、pageX/pageY、screenX/screenY、layerX/layerY、offsetX/offset 六对。有点乱了吧，一个点击事件能有多少位置啊？不要着急，其实并不复杂，之所以能有这么多是因为各浏览器厂商在版本更迭的时候产生了很多不一致。下面简单介绍一下每个定位属性的意思：
> x/y与clientX/clientY值一样，表示距浏览器可视区域（工具栏除外区域）左/上的距离；
pageX/pageY，距页面左/上的距离，它与clientX/clientY的区别是不随滚动条的位置变化；
screenX/screenY，距计算机显示器左/上的距离，拖动你的浏览器窗口位置可以看到变化；
layerX/layerY与offsetX/offsetY值一样，表示距有定位属性的父元素左/上的距离。
之所以有那么多值一样的情况，就是由于浏览器兼容的原因。那我们平时该如何使用呢？请看下面的表格，列出了各属性的浏览器支持情况。（+支持，-不支持）
offsetX/offsetY：W3C- IE+ Firefox- Opera+ Safari+ chrome+
x/y：W3C- IE+ Firefox- Opera+ Safari+ chrome+
layerX/layerY：W3C- IE- Firefox+ Opera- Safari+ chrome+
pageX/pageY：W3C- IE- Firefox+ Opera+ Safari+ chrome+
clientX/clientY：W3C+ IE+ Firefox+ Opera+ Safari+ chrome+
screenX/screenY：W3C+ IE+ Firefox+ Opera+ Safari+ chrome+​

*上面的支持情况摘自其他文章，本人未做验证。*

**2.其他常用属性**
> timeStamp：事件发生的时间，时间戳。
keyCode：按下的键的值。

**3.所有事件对象都有的属性和方法**

|属性/方法|类型|读/写|说明|
|:----:|:----:|:----:|----|
|bubbles|Boolean|只读|表明事件是否冒泡|
|cancelable|Boolean|只读|表明是否可以取消事件的默认行为|
|currentTarget|Element|只读|其事件处理程序当前正在处理事件的那个元素|
|target|Element|只读|事件的目标|
|defaultPrevented|Boolean|只读|为true时表示已经调用了preventedDefault()|
|detail|Integer|只读|与事件相关的细节|
|eventPhase|Integer|只读|调用事件处理程序的阶段:1表示捕获阶段，2表示“处于目标”，2表示冒泡阶段|
|trusted|Boolean|只读|为true表示事件由浏览器生成的，为false表示事件是由开发人员通过javascript创建的|
|type|String|只读|被触发的事件的类型|
|view|AbstractView|只读|与事件关联的抽象视图。等同于发生事件的window对象|
|preventDefault()|Function|只读|取消事件的默认行为。如果cancelable是true，则可以使用这方法|
|ftopImmediatePropagation()|Function|只读|取消事件的进一步捕获或冒泡，同时阻止任何事件处理程序被调用|
|stopPropagation()|Function|只读|取消事件的默认行为。如果bubbles是true，则可以使用这方法|
