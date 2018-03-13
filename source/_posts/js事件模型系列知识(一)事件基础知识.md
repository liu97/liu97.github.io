---
title: js事件模型系列知识(一)事件基础知识
date: 2018-3-11 15:15:03
categories: Blogs
tags: [js]
---
事件模型，记得第一次看这个名词的我一脸懵逼，学了这么久js，事件模型是什么鬼，只听过像click、mouseover、load、keypress这样的事件啊。所以我查了一下，发现原来和事件捕获和事件冒泡有关哦，当时学到事件冒泡的时候，貌似老师说过事件冒泡用的不好会出很多莫名的bug，所以打心底的很抵触冒泡，随处乱用stopPropagation()。如果你现在还是像我刚刚讲的那种状态，那么你可以看看我写的这几篇对事件模型系列知识的简单介绍，不一定写的很好，请见谅。<!--more-->

## 事件处理程序
事件就是用户活着的浏览器自身执行的某种动作。入click、load和mouseover。而响应某种事件的函数就是事件处理程序（或事件侦听器）。

### 1.HTML事件处理程序
某个元素支持的每种事件，都可以使用一个与响应时间处理程序同名的HTML特性来制定。例如，要在按钮被单击时执行一些javascript，可以像下面这样：
```javascript
//第一种
<input type="button" value="clickMe" onclick="console.log("我被点击了")"/>
//第二种
<input type="button" value="clickMe" onclick="clickBtn()"/>
<script>
	function clickBtn(){
		console.log("我被点击了");
	}
</script>
```

### 2.DOM0级事件处理程序
通过javascript指定事件处理程序的传统方式，就是将一个函数赋值给一个事件处理程序属性。还是按钮点击的例子：
```javascript
<script>
	var btn = document.getElementById("btn");
	btn.onclick = function(){
		console.log("我被点击了");
	}
</script>

```

### 3.DOM2级事件处理程序
"DOM2级事件"定义了两个方法，用于处理指定和删除事件处理程序的操作：addElementListener()和removeEventListener()。所有DOM节点都包含这两个方法，他们都接受3个参数：盐处理的事件名、作为事件处理程序的函数和一个布尔值。醉的布尔值为true时便是在事件捕获阶段调用事件处理程序函数，为false表示在事件冒泡阶段调用事件处理程序函数。
在按钮上为click事件添加事件处理程序：
```javascript
var btn = document.getElementById("btn");
btn.addEventListener("click",function(){
	console.log("我被点击了");
	},false);
```
这样看起来好像和DOM0级事件处理程序也没啥区别啊，别急，我们来看下面这种情况：
```javascript
//DOM0级
var btn = document.getElementById("btn");
btn.onclick = function(){
	console.log("输出第一次");
}
btn.onclick = function(){
	console.log("输出第二次");
}
//当点击按钮会会发现只有一次输出，输出为"输出第二次"

//DOM2级
var btn = document.getElementById("btn");
btn.addEventListener("click",function(){
	console.log("输出第一次");
},false);
btn.addEventListener("click",function(){
	console.log("输出第二次");
},false);
//当点击按钮后会发现有两个输出分别为"输出第一次"和输出"输出第二次"
```
*其实DOM2与DOM0的差别并不止上面这种情况，后面讲冒泡和捕获的时候就能体现出来。*
通过addEventListener()添加的事件处理程序只能用removeEventListener()来一出；移除时传入的参数必须与添加事件处理程序的使用的参数必须一样，这就表明通过addEventListener()添加的匿名函数将无法移除，就像下面这样：
```javascript
var btn = document.getElementById("btn");
btn.addEventListener("click",function(){
	console.log("输出第一次");
},false);
btn.remeoveEventListener("click",function(){
	console.log("输出第一次");
},false);
//点击按钮后依然会有输出，因为添加时事件处理函数与移除时事件处理函数并不是同一个函数，虽然代码一样。
```
正确移除addEventListener()添加的事件处理程序应该像下面这样：
```javascript
var btn = document.getElementById("btn");
function handler(){
	console.log("输出第一次");
}
btn.addEventListener("click",handler,false);
btn.remeoveEventListener("click",handler,false);
//点击按钮后不会有输出。
```

### 4.IE事件处理程序
IE实现与DOM类似的两种方法：attachEvent()和detachEvent()。这两个函数接受相同的两个参数：事件处理程序名称和事件处理程序函数。由于IE8及更早版本只支持事件冒泡，所以通过attachEvent()函数添加的事件处理函数会被添加到事件冒泡阶段。
IE事件处理程序与DOM2事件处理程序类似，比如可以为一个元素添加多个类型相同或不同的事件处理程序、使用attachEvent()函数添加的事件处理程序可以通过detachEvent()函数来移除，且参数必须相同(不能使用匿名函数来作为事件处理程序的参数)。使用方法如下：
```javascript
var btn = document.getElementById("btn");
function handler(){
	console.log("输出第一次");
}
btn.attachEvent("onclick",handler);//注意这里是用了"on"
btn.detachEvent("onclick",handler);//注意这里是用了"on"
```
与DOM2不同的是：
> 1、使用DOM2级方法时，事件处理程序会在其所属元素的作用域运行；而使用attachEvent()方法添加的情况下事件处理程序会在全局作用域中运行，因此this=window；
2、使用DOM2级方法啊是，事件处理程序是以添加他们的顺序执行，而IE方法是以添加他们相反的顺序执行。

## DOM事件对象
兼容DOM的浏览器会将一个event对象传入到事件处理程序中。无论指定事件处理程序时使用什么方法，都会传入event对象，来看下面例子。
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
### 1.事件对象常用的属性及方法
**一.事件定位相关属性**
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

**二.其他常用属性**
> timeStamp：事件发生的时间，时间戳。
keyCode：按下的键的值。

**三.所有事件对象都有的属性和方法**

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

在事件处理程序内部，对象this始终等于currentTarget的值，而target则只包含事件的实际目标。

### 2.IE事件对象
与DOM中的event对象，要访问IE中的ecent对象有几种不同的方式，取决于指定事件处理程序的方法。在使用DOM0级方法添加事件处理程序时，event对象作为window的一个属性存在。
```javascript
var btn = document.getElementById("btn");
btn.onclick=function(){
	var event = window.event;
	console.log(event.type); // click
}
```
而当如果事件处理程序时使用attachEvent()添加的，那么就会有一个event对象作为参数被传入到事件处理程序函数中。
```javascript
var btn = document.getElementById("btn");
btn.attachEvent("click", function(event){
	console.log(event.type); //click
	})
```
如果是通过HTML特性指定的事件处理程序，我们可以通过一个名叫event的变量来访问。
```javascript
<input type="button" value="clickMe" onclick="console.log(event.type)"/>
```
IE中所有事件对象都会包含下列属性和方法：

|属性/方法|类型|读/写|说明|
|:----:|:----:|:----:|----|
|cancelBubbles|Boolean|读/写|默认值false，但将其值设置为true就可以取消事件冒泡(与DOM中的stopPropagation()方法的作用相同)|
|returnValue|Boolean|读/写|默认值为true，但将其设置为false可以取消时间的默认行为(与DOM中的preventDefault()的方法作用相同)|
|srcElement|Element|只读|事件的目标(与DOM中的target属性相同)|
|type|Element|只读|被触发的事件类型|

## 事件的三种模型

### 1.原始事件模型
在原始事件模型中（也有说DOM0级），事件发生后没有传播的概念，没有事件流。事件发生，马上处理，完事，就这么简单。监听函数只是元素的一个属性值，通过指定元素的属性值来绑定监听器。书写方式有两种，也就是第一节**事件处理程序**中的**HTML事件处理程序**和**DOM0级事件处理程序**中的书写方法。

### 2. DOM2事件模型
此模型是W3C制定的标准模型，既然是标准，那大家都得按这个来，我们现在使用的现代浏览器（指IE6~8除外的浏览器）都已经遵循这个规范。W3C制定的事件模型中，一次事件的发生包含三个过程：
>(1)capturing phase:事件捕获阶段。事件被从document一直向下传播到目标元素,在这过程中依次检查经过的节点是否注册了该事件的监听函数，若有则执行。
(2)target phase:事件处理阶段。事件到达目标元素,执行目标元素的事件处理函数。
(3)bubbling phase:事件冒泡阶段。事件从目标	元素上升一直到达document，同样依次检查经过的节点是否注册了该事件的监听函数，有则执行。所有的事件类型都会经历captruing phase但是只有部分事件会经历bubbling phase阶段,例如submit事件就不会被冒泡。 

书写方式在第一节**DOM2事件处理程序中有**

### 3.IE事件处理模型
IE的事件模型只有两步，先执行元素的监听函数，然后事件沿着父节点一直冒泡到document。冒泡机制后面系列会讲，此处暂记。
书写方式参考第一节**IE事件处理程序**的代码。

## 感谢链接
[Javascript事件模型系列（一）事件及事件的三种模型](http://www.cnblogs.com/lvdabao/p/3265870.html)