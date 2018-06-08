---
title: js事件模型系列知识(二)捕获、冒泡及事件委托
date: 2018-3-12 15:15:03
categories: Blogs
tags: [js]
---
既然讲到了事件，必然少不了“会出很多莫名的bug”的冒泡，系列一也讲过由W3C规定的DOM2标准中，冒泡还有一个兄弟--捕获。了解了冒泡和捕获后，我们是不是应该会有这样的想法，冒泡和捕获有什么用呢，那么事件委托就是一个很好的解释。介绍了了本节需要了解什么，接下来进入正题吧。<!--more-->

## 事件的捕获与冒泡
在W3C模型中，任何事件发生时，先从顶层开始进行事件捕获，直到事件触发到达了事件源元素。然后，再从事件源往上进行事件冒泡，直到到达document。程序员可以自己选择绑定事件时采用事件捕获还是事件冒泡，方法就是绑定事件时通过addEventListener函数，它有三个参数，第三个参数若是true，则表示采用事件捕获，若是false，则表示采用事件冒泡。
下面为事件执行图：

![冒泡捕获](/img/事件模型/21.png)
执行图有点难懂？没事，我们来几组代码例子你就懂了，下面点击目标都为儿子：
```javascript
父亲节点的监听函数在捕获阶段执行,alert顺序为：1、父亲被点击了；2、孩子被点了
var parent1 = document.getElementById('parentdiv1');
var child1 = document.getElementById('childdiv1');
parent.addEventListener('click',function(){alert('父亲被点击了');},true);//第三个参数为true
child.addEventListener('click',function(){alert('孩子被点击了');},false);

父亲节点的监听函数在冒泡阶段执行,alert顺序为：1、孩子被点击了；2、父亲被点了
var parent2 = document.getElementById('parentdiv2');
var child2 = document.getElementById('childdiv2');
parent.addEventListener('click',function(){alert('父亲被点击了');},false);//第三个参数为false
child.addEventListener('click',function(){alert('孩子被点击了');},false);

父亲节点的监听函数在捕获冒泡阶段都执行,alert顺序为：1、父亲被点击了；2、孩子被点了；3、父亲被点了
var parent3 = document.getElementById('parentdiv3');
var child3 = document.getElementById('childdiv3');
parent.addEventListener('click',function(){alert('父亲被点击了');},true);//第三个参数为true
parent.addEventListener('click',function(){alert('父亲被点击了');},false);//第三个参数为false
child.addEventListener('click',function(){alert('孩子被点击了');},false);
```
需要注意的是，当使用DOM0级事件处理程序样式的代码为父亲和儿子都设置点击事件后，相当于addEventListener的第三个参数为false，点击儿子后：
```javascript
alert顺序为：1、孩子被点击了；2、父亲被点了
parent.onclick=function(){alert("父亲被点击了")}
child.onclick=function(){alert("儿子被点击了")}
```
了解了冒泡和捕获后，假如我们不想有冒泡或者捕获怎么办，我就想当点击目标为儿子，只弹出“儿子被点击了”，当点击目标为父亲，才弹出“父亲被点击了”，这时候就该阻止冒泡出场了。什么，为什么只有阻止冒泡没有阻止捕获？嘿嘿逗你呢，其实有的，阻止事件有两种：
> 1、阻止捕获：当使用DOM事件模型，只要我们将父亲第三个参数设置为false时（不设置第三个参数，默认为false）就只有冒泡没有捕获了呀；IE事件处理时只承认事件冒泡，没有事件捕获这回事。
2、阻止冒泡：当addEventListener第三个参数设置为true时就可以阻止冒泡。

上面两种其实算不上真正的阻止冒泡和捕获，DOM事件对象中有一个方法叫stopPropagation()，当调用此方法后会阻止事件的进一步冒泡或者捕获。

**1.阻止冒泡**。
```javascript
var parent1 = document.getElementById('parentdiv1');
var child1 = document.getElementById('childdiv1');
//使用DOM0级事件处理程序样式的代码:
parent1.onclick=function(event){
	alert('父亲被点击了');
}
child1.onclick=function(event){
	alert('孩子被点击了');
	event.stopPropagation();
}
//只弹出“孩子被点击了”

//使用addEventListener时，我们将父亲第三个参数设置为false时
parent1.addEventListener('click',function(event){
	alert('父亲被点击了');
},false);//第三个参数为false
child1.addEventListener('click',function(event){
	alert('孩子被点击了');
	event.stopPropagation();
},false);
//只弹出“孩子被点击了”
```
与DOM处理程序不同，IE中的事件对象有一个属性叫cancelBubble，默认值为false，表示事件冒泡；如果将它设置为true，就可以取消进一步冒泡。
```javascript
var parent1 = document.getElementById('parentdiv1');
var child1 = document.getElementById('childdiv1');
//使用DOM0级事件处理程序样式的代码:
parent1.onclick=function(event){
	alert('父亲被点击了');
}
child1.onclick=function(event){
	alert('孩子被点击了');
	window.event.cancelBubble = true;//注意这里必须要用window.event
}
//只弹出“孩子被点击了”

//使用attachEvent：
parent1.attachEvent("onclick",function(event){
	alert('父亲被点击了');
})
child1.attachEvent("onclick",function(event){
	alert('孩子被点击了');
	event.cancelBubble = true;
})
//只弹出“孩子被点击了”
```
**2.阻止捕获**
```javascript
var parent1 = document.getElementById('parentdiv1');
var child1 = document.getElementById('childdiv1');
//使用addEventListener时，我们将父亲第三个参数设置为false时
parent1.addEventListener('click',function(event){
	event.stopPropagation();
	alert('父亲被点击了');
},true);//第三个参数为true
child1.addEventListener('click',function(event){
	alert('孩子被点击了');
},false);
//只弹出“父亲被点击了”
```

## 事件委托机制
知道了事件的捕获冒泡机制，我们可以利用它来实现更方便的程序控制，事件委托便是最典型的应用之一。下面来说说javascript中的事件委托机制。什么叫委托呢？想想我们现实生活中，自己不想干的事，让别人来帮忙完成，这就是把事情“委托”给别人。Javascript的事件委托机制也是这个道理，本来一个监听函数要处理节点a触发的事件，现在把这个监听函数绑定到节点a的父层节点上，让它的父辈来完成事件的监听，这样就把事情“委托”了过去。在父辈元素的监听函数中，可通过event.target属性拿到触发事件的原始元素，然后再对其进行相关处理。
那这样做有什么好处呢？最大的用处便是监听动态增加的元素。比如我们现在有这样的需求，点击下面每个列表项弹出各自的内容，现在随着web应用的盛行，网页中使用异步请求来动态加载节点已经变的很普遍，所以我们点击下方的按钮要在列表中增加一项，并且点击新增加的节点也要弹出内容。HTML结构如下：
	
```html
<ol id="olist">
    <li>列表内容1</li>
    <li>列表内容2</li>
    <li>列表内容3</li>
    <li>列表内容4</li>
    <li>列表内容5</li>
</ol>
```
若我们使用之前的监听器绑定方式，需要遍历所有的li元素并监听，代码应该是这样的：
```javascript
var listArray = document.getElementById('olist').childNodes;
for(var i=0;i<listArray.length;i++){
    listArray[i].addEventListener('click',function({
            alert(this.innerText);
        });
}
```
可以发现当新增元素后，点击它并没有弹出内容。那是当然的了，因为我们并没有给新增的元素绑定监听器，为了实现点击新增元素也弹出内容，我们不得不在每次新增一个元素后，再进行一次绑定。加一个绑一个，加一个绑一个，累不累啊！你不累浏览器都累了！这样做导致的性能开销是可想而知的，而且浏览器还要维系n多元素与应的监听函数的映射关系，会占用大量内存。
这个时候该事件委托机制出场了：
```javascript
var olist = document.getElementById('olist');
olist.addEventListener('click',function(){
    alert(event.target.innerText);
},false);
```
我们并未给li元素绑定任何监听器，而是监听它的父元素ul，等到事件冒泡上来的时候，在处理函数中通过event.target获得触发事件的li元素，进行相关处理。这样做的好处是显而易见的，首先只进行了一次监听器的绑定，浏览器轻松，其次动态增加元素后你也不必要再绑定监听器，你也轻松。

## 感谢链接
[Javascript事件模型系列（二）事件的捕获-冒泡机制及事件委托机制](http://www.cnblogs.com/lvdabao/p/3266421.html)