---
title: livereload安装与应用
date: 2017-05-04 09:44:12
categories: Blogs
tags: [livereload]
---
在上次搭建博客的时候在知乎上找到一个神器livereload。宣传一下Sublime text3是非常好用的编辑器。配合LiveReload插件可以在浏览器中实时预览，也就是说写完html/css/js等不用再到浏览器里按F5啦，在Ctrl+S时浏览器会自动刷新，是不是想想都很爽，多屏的同学更爽了~~~<!--more-->

----------

下面开始进入正题。
## LiveReload的安装

> 1、安装浏览器插件browser extensions

根据自己的浏览器选择对应的extension。对于chrome浏览器用户，需要配置下LiveReload插件：勾选允许访问文件网址。

![扩展程序](/img/livereload/livereload1.png)

> 2、在sublime text3 配置LiveReload。

Ctrl+Shift+P ==> install ==> livereload 回车；
直接用这种方法的可能会出问题，要检查一下配置：Preference ==> Package Settings ==> LiveReload ==> Settings - Default ，要和下面代码一样。
![sublime插件](/img/livereload/livereload2.png)

	　{
     　　"enabled_plugins": [
	      　　"SimpleReloadPlugin",
	      　　"SimpleRefresh"
	    　　 ]
		}

* *到这里就安装好了*

## LiveReload的应用
> 先启用浏览器中的LiveReload。

点一下黑色圈圈，中心的小圆圈会变成实心，表示启用。

![浏览器启用livereload](/img/livereload/livereload3.png)

> 在启用sublime里的LiveReload。

因为在Sublime Text里没有启动LiveReload，每次重新打开Sublime都需要启动，启动方法：Ctrl+Shift+P ==> LiveReload enable/disable plug-ins ==> simple reload。

下面是使用神器的示例：

![使用livereload](/img/livereload/livereload4.gif)