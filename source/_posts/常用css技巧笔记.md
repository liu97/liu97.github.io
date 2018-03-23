---
title: 常用css技巧笔记
date: 2018-03-23 13:37:12
categories: Blogs
tags: [css]
---
## 前言
在编写前端页面时，偶尔会碰到自己感觉很奇怪的样式或者不知道怎么去实现的样式，各种各种，这篇就写下我平时遇到的css，以后如果碰到了还会加到这里来。<!--more-->
下面只会讲个大概，如果想深入了解还需自行搜索啊，进入正题：
## vertical-align
> vertical-align这个是设置元素的垂直排列的；
用来定义行内元素的基线相对于该元素所在行的基线的垂直对齐；
它的值比较多：baseline | sub | super | top | text-top | middle | bottom | text-bottom | inherit。

其实vertical-align是一个非常复杂的属性，要完全掌握真的很难。
下面这段代码会产生“一个很奇怪的样式”：
```
<style>
	div{
		width: 100px;
		height: 100px;
		border: 1px solid #ccc;
		display: inline-block;/* 或者inline-flex */
	}
</style>
<body>
	<div id="div1"></div>
	<div id="div2">
		我是div2
	</div>
</body>
```
效果图如下：
![div错位](/img/常用css笔记/1.png)
为什么会出现这种情况呢？因为div1里没有文字，而div2中有文字，div2的文字位置会根据baseline确定。咦~，baseline又是什么东西？下面简单介绍一下baseline的确定规则：
> 1、inline-table元素的baseline是它的table第一行的baseline。
2、父元素【line box】的baseline是最后一个inline box 的baseline。
3、inline-flex元素的baseline对齐项目的第一行文字的基线 
3、inline-block元素的baseline确定规则
&ensp;&ensp;&ensp;&ensp; 规则1：inline-block元素，如果内部有line box，则inline-block元素的baseline就是最后一个作为内容存在的元素[inline box]的baseline，而这个元素的baseline的确定就要根据它自身来定了。
&ensp;&ensp;&ensp;&ensp; 规则2：inline-block元素，如果其内部没有line box或它的overflow属性不是visible，那么baseline将是这个inline-block元素的底margin边界。

我们要怎么解决的，其实就是将div2的垂直对齐方式改变一下：
```
#div2{
	width: 100px;
	height: 100px;
	border: 1px solid #ccc;
	display: inline-block;/* 或者inline-flex */
	vertical-align: top;
}
```

## 不定宽高水平垂直居中
在css界，居中有许多方法，各种方式适用于不同的情况，例如：
> 1、margin:auto;居中的要求是居中容器需要固定宽度和高度; 
> 2、text-align:center;对行内元素水平居中
> 3、父元素position:relative; top:50%;left:50%;子元素position:relative;top:-50%;left:50%;水平垂直居中。
> 4、父元素position:relative;子元素position:relative;top:50%;left:50%;margin-left:-(宽度值/2);margin-top:-(高度值/2)。需要确定居中容器的宽高。

还有许多元素居中的方法，每个居中方式都有优点和缺点，一种居中方式难以满足所有的居中情况。下面是我碰到的挺好的得居中方式(兼容ie6)，不定宽高水平垂直居中：
```
<style type="text/css">
    * { margin:0; padding:0; list-style:none;  }
    #vertical_box {
        width:100%;
        display:table;
        border:1px red solid;
        height:400px;
        *position:relative; /*针对IE的hack*/
    }
    #vertical_box_sub {
        display: table-cell;
        vertical-align: middle;
        *position:absolute; /*针对IE的hack*/
        *top:50%;
        *left:50%;
    }
    #vertical_box_container {
        font-family:"宋体";
        border:1px green solid;
        *position:relative; /*针对IE的hack*/
        *top:-50%;
        *left:-50%;
        margin:0 auto;
        width:200px;
    }
</style>
<body>
<div id="vertical_box">
    <div id="vertical_box_sub">
        <div id="vertical_box_container">
            <p>我是居中的文字</p>
            <p>我居中</p>
            <p>你也居中</p>
        </div>
    </div>
</div>
</body>
```
