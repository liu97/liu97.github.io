---
title: 理解BFC及其的作用
date: 2018-03-18 21:51:51
categories: Blogs
tags: [css]
---
在写样式时，往往是添加了一个样式，又或者是修改了某个属性，就达到了我们的预期。而BFC就潜藏在其中，当你修改样式时，一不小心就能触发它而毫无察觉，因此没有意识到BFC的神奇之处。那那么我们今天来看看BFC到底是什么。<!--more-->

## BFC是什么
Block Formatting Context，中文直译为块级格式上下文，BFC就是一种布局方式。一旦BFC创建，它就会阻止它内部的元素逃离并从盒子里伸出来。当一个HTML盒子拥有下面任意一个属性时，它就是BFC：
> * 根元素或其它包含它的元素
* float的值不为none
* overflow的值不为visible(flow-root是一种新的方式，兼容性还在焦急等待)
* position的值为absolute或者fixed
* display的值为inline-block、table-cell、table-caption、flex或者inline-flex中的其中一个
* 另外当使用多列布局时，使用了column-span:all也可以创建BFC。Flexbox和Grid布局中的元素也会自动创建类似BFC的机制，只是它们被称为FFC（弹性格式上下文）和GFC（网格格式上下文）。这反映了它们所参与的布局类型。一个BFC表明他内部的元素参与了块级布避，一个FFC意味着它内部的元素参与了Flexbox布局。在实践中，这几种布局的结果是相似的，浮动元素会被包裹，外边距不会叠加。

## BFC的作用
### 1.BFC防止文字环绕
当我们像下面示例，在div中有一个img图片和p元素，p元素包含一些文字,当文字足够多的时候，文字会把图片包围。
```css
<div id="main">
    <img src="erke.jpg" alt="周二珂" id="floatImg">
    <p id="p1">在div中有一个img图片和一些文字,当文字足够多的时候，文字会把图片包围。在div中有一个img图片和一些文字,当文字足够多的时候，文字会把图片包围。在div中有一个img图片和一些文字,当文字足够多的时候，文字会把图片包围。在div中有一个img图片和一些文字,当文字足够多的时候，文字会把图片包围。在div中有一个img图片和一些文字,当文字足够多的时候，文字会把图片包围。</p>
 </div>

#main{
 	background: pink;
 	width: 400px;
}
#floatImg{
 	float: left;
 	width: 200px;
}
#p1{
	background:orange;
}
```
效果图如下：
![文字包围图片](/img/理解BFC/1.png)
但是有时候我们就像让文字和图片并排，该怎么办呢?这时候就该BFC发挥作用了，按照上面设置BFC属性，比如我们将p添加属性overflow:auto。
```javascript
#p1{
	background:orange;
    overflow: auto;
}
```
添加BFC属性后，效果变成下面这样：
![文字包围图片](/img/理解BFC/2.png)

### 2.解决高度塌陷问题
还是上一个例子，当p元素中文字不怎么多的时候，div的高度的决定权在p，不管img有多高。这时候给人感觉img不被div包含。
当我们像下面示例，在div中有一个img图片和p元素，p元素包含一些文字,当文字足够多的时候，文字会把图片包围。
```css
<div id="main">
    <img src="erke.jpg" alt="周二珂" id="floatImg">
    <p id="p1">在div中有一个img图片和一些文字</p>
</div>

#main{
	background: pink;
 	width: 400px;
 	border:3px solid black;
}
#floatImg{
	float: left;
	width: 200px;
}
#p1{
	background:orange;
}
```
效果图如下：
![父元素高度塌陷](/img/理解BFC/3.png)
为了解决父元素的高度塌陷该怎么办呢?[可以看看大漠老师的这篇](https://www.w3cplus.com/css/clear-float)，这里我们讲BFC，我们可以将main添加overflow: auto属性：
```css
<div id="main">
    <img src="erke.jpg" alt="周二珂" id="floatImg">
    <p id="p1">在div中有一个img图片和一些文字</p>
</div>

#main{
	background: pink;
 	width: 400px;
 	border:3px solid black;
 	overflow: auto;
}
#floatImg{
	float: left;
	width: 200px;
}
#p1{
	background:orange;
}
```
效果图如下：
![父元素重振雄风](/img/理解BFC/4.png)

### 3.垂直margin叠加
在CSS当中，相邻的两个盒子的外边距可以结合成一个单独的外边距。这种合并外边距的方式被称为折叠，并且因而所结合成的外边距称为折叠外边距。折叠的结果：
> * 两个相邻的外边距都是正数时，折叠结果是它们两者之间较大的值。
* 两个相邻的外边距都是负数时，折叠结果是两者绝对值的较大值。
* 两个外边距一正一负时，折叠结果是两者的相加的和。

在常规文档流中，盒子都是从包含块的顶部开始一个接着一个垂直堆放。两个兄弟盒子之间的垂直距离是由他们个体的外边距所决定的，但不是他们的两个外边距之和。
如下所示：
```css
<div class="container"> 
    <p>Sibling 1</p> 
    <p>Sibling 2</p> 
    <div id="newBFC">
    	<p>Sibling 3</p>
    </div> 
</div>

.container { 
  	background-color: pink; 
  	overflow: auto; /* creates a block formatting context */ 
  	text-align: center;
} 
p { 
    background-color: blue; 
    margin: 10px 0; 
}
```
效果图如下：
![垂直margin叠加](/img/理解BFC/5.png)
解决办法也是讲newBFC的div元素设置BFC属性:
```javascript
#newBFC{
    overflow: hidden;
}
```
效果图如下：
![消除叠加情况](/img/理解BFC/6.png)

不知道你有没有注意到上面的例子中，我们给container添加了overflow: auto属性，意味着container也是个BFC盒子。我们为什么要这么做呢？不知道你平时有没有遇到这种情况，当我们给第一个子元素设置margin-top时，父元素也跟着设置了margin-top，且父元素和子元素的上边框还是重合着，这也是因为margin叠加的情况。
```css
<div class="container"> 
    <p>Sibling 1</p> 
    <p>Sibling 2</p> 
</div>

.container { 
  	background-color: pink; 
  	text-align: center;
} 
p { 
    background-color: blue; 
    margin: 10px 0; 
}
```
效果图如下：
![垂直margin叠加](/img/理解BFC/7.png)
父元素是设置了pink背景颜色的，但是上例父元素跟随子元素p一起设置了margin，导致看不到顶端和底端的pink背景色。
解决方案就像上面说的，将父元素container设置BFC属性：
```css
.container { 
    background-color: pink; 
    overflow: hidden; /* creates a block formatting context */ 
    text-align: center;
} 
```
效果图如下：
![消除叠加情况](/img/理解BFC/8.png)

以上的例子都是将元素设置overflow属性，其实像文章开头那样，我们可以设置float，display等属性，但是设置后很有可能会改变元素的样式，所以设置BFC时应该仔细考虑到底该设置什么BFC属性才是最好的方案。

## 感谢链接
[理解CSS布局和BFC](https://www.w3cplus.com/css/understanding-css-layout-block-formatting-context.html)
[理解CSS中BFC](https://www.w3cplus.com/css/understanding-block-formatting-contexts-in-css.html)