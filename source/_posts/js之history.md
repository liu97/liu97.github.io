---
title: js之history
date: 2018-04-12 17:34:21
categories: Blogs
tags: [js]
---
history是window对象的属性，它保存着用户上网的历史记录，借助用户访问过的页面列表，可以在不知道实际URL的情况下实现后退和前进。<!--more-->
## history的基本属性和方法
**属性:**
> length: history栈里url的数量
> state: URL对应的状态信息

**方法**
> back() : 回退到上一个访问页面(如果存在)
> forward() : 前进到下一个访问页面(如果存在)
> go(int) : 到达某个访问页面(比如go(2)是前进到下2个页面;go(-3)是回退到(上3个页面))
> pushState(stateData, title ,url) : 修改当前的访问记录，不能跨域，且不造成页面刷新
> replaceState(stateData, title, url) : 修改当前的访问记录，不能跨域，且不造成页面刷新
> onpopstate() : 当调用history.go()、history.back()、history.forward()时触发;pushState()/replaceState()方法不触发 
> onhashchange() : 当前 URL 的锚部分(以 '#' 号为开始) 发生改变时触发。触发情况:
> *1.通过设置Location 对象 的 location.hash 或 location.href 属性修改锚部分；*
> *2.使用不同history操作方法到带hash的页面;*
> *3.点击链接跳转到锚点。*

## 浏览器history变化
采用[蒲公英tt](https://www.cnblogs.com/hity-tt/p/7059192.html)的history栈变更图能很好的展示history的变化：
![history栈变化图](/img/js之history/1.png)
分析下这个history变化图：

> 1.step1-step4、step8就是history的当前页面在访问记录间的变化
> 2.step5通过location.href的修改创建一个新的页面记录，需要注意的是修改后url2后面的记录都会被删除，然后再加入location.href的值
> 3.step6通过pushState方法创建一个新的url记录，其也是清空、再新增记录
> 4.step9通过replaceState方法修改一个url记录，其不会产生新记录，而是将当前记录进行修改。

*需要注意的是，使用pushState和replaceState时不会刷新页面，只是修改页面参数信息(stateData, title, url),而locaiton.href生成的记录被访问时，页面将进行刷新,其中:*
**state : 状态对象是一个由 pushState()方法创建的、与历史纪录相关的JS对象。当用户定向到一个新的状态时，会触发popstate事件。事件的state属性包含了历史纪录的state对象。
title : 火狐浏览器现在已经忽略此参数，将来也许可能被使用。考虑到将来有可能的改变，传递一个空字符串是安全的做法。当然，你可以传递一个短标题给你要转变成的状态。
url : 这个参数提供了新历史纪录的地址。请注意，浏览器在调用pushState()方法后不会去加载这个URL，但有可能在之后会这样做，比如用户重启浏览器之后。新的URL不一定要是绝对地址，如果它是相对的，它一定是相对于当前的URL。新URL必须和当前URL在同一个源下;否则，pushState() 将丢出异常。这个参数可选，如果它没有被特别标注，会被设置为文档的当前URL。**

## history的应用场景

1.history的用的不多，但是在某些特殊页面需要后退或者前进页面，也就是history的go、back、forward的运用
2.有的时候需要阻止用户对页面的前进后退或者阻止锚点会用到onpopstate、onhashchange
3.一开始我会觉得pushState和replaceState好像是个鸡肋，没啥卵用，但是当我看到了这篇文章[ajax与HTML5 history pushState/replaceState实例](http://www.zhangxinxu.com/wordpress/2013/06/html5-history-api-pushstate-replacestate-ajax/)。/笑脸/，瞬间感觉很屌。

## 感谢链接
[window.history的跳转实质－HTML5 history API 解析](https://www.cnblogs.com/hity-tt/p/7059192.html)