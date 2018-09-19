---
title: 移动端的video
date: 2018-09-11 22:31:38
categories: Blogs
tags: [移动端,video,canvas]
---
&emsp;&emsp;跌跌撞撞过完了上周，今天才缓过来。上上周五突然接到一个移动端的项目，从没做过移动端项目的我正好可以学习下。整个项目的过程就是边学习、边编码、边测试，由于项目面向的群体是大众，所以要考虑到各个浏览器的兼容，整个项目不大，但是麻烦的就是兼容。<!--more-->
## 需求
&emsp;&emsp;项目需要实现一个移动端自定义风格控件的行内播放器，有开始播放、暂停、继续播放、静音、全屏等功能。
## 问题
做的过程中存在以下几个问题：
* 首次进入页面出现浏览器video的默认图片
* 浏览器不支持`poster`
* `ios`不能行内video播放
* 浏览器不能自定义video控件
* 浏览器不能使用`canvas + video`

各个浏览器多多少少会出现上述某些问题，有的能解决，有的技术有限还未解决。

### 出现浏览器video的默认图片
&emsp;&emsp;部分浏览器在渲染video时，会先渲染一个默认视频图片,如果你不想要它的默认图片那要怎么办呢？其实这个简单，只要给video加上一个`poster`,浏览器便不会渲染默认图片。

### 浏览器不支持poster
&emsp;&emsp;假如你设置了poster，有的浏览器会直接忽略或者显示一下poster又立马隐藏掉。如果必须要的话，可以增加一个poster遮罩，`background-image`设置为poster图片就行，当点击播放后隐藏掉该poster遮罩。

### ios不能行内video播放
&emsp;&emsp;首先解释一下什么是行内video播放，行内播放就是指video标签在播放状态是占页面的固定宽高，而不是直接全屏播放。由于ios默认是全屏播放的，要解决问题就是在video标签上添加以下属性：
```html
<video 
	playsinline
	webkit-playsinline  /*针对webkit内核浏览器*/
	x5-playsinline      /*针对X5内核浏览器*/
	>
</video>
```
&emsp;&emsp;设置了上述属性后，ios端就会乖乖行内播放啦，但是，依然有某些浏览器会不支持。比如ios端的百度浏览器和UC浏览器会直接全屏。

### 浏览器不能自定义video控件	
&emsp;&emsp;每个浏览器都有自己的video控件，样式各不同。假如你不需要或者想自定义控件样式，video有个属性叫`control`,如果添加了这个属性表示显示默认控件，不加该属性默认去掉video控件。but各个浏览器不会这么配合你啊，你就是去不掉它的默认控件。这个时候就该`canvas+video`出场啦！
&emsp;&emsp;由于存在上述问题，我们可以使用canvas+video模拟播放，也就是说我们把video隐藏掉，将video的画面画到canvas上，这样就不用担心video的控件，因为video被我们隐藏掉啦！那么怎么将保持canvas和video同步呢？直接一点的方法就是使用定时器，每过n毫秒画一次canvas。但是我们还有更好地方法，毕竟定时器不是那么准确是吧，除了定时器我们还可以使用requestAnimationFrame。具体怎么实现canvas+video请看下面：
```html
<video src="xxx.mp4" style="display:none" id="h_video"></video>
<canvas id="h_canvas"></canvas>
<script>
	var video = document.getElementById("h_video");
	var canvas = document.getElementById("h_canvas");
	function drawCanvas() {  // 点击开始触发这个函数就可以实现canvas+video模拟播放啦
		var context = canvas.getContext("2d");
		context.drawImage(video, 0, 0, canvas.width, canvas.height);
	    if(!lp_video_id.paused){
	    	requestAnimationFrame(drawCanvas)
	    }
	};
	(function setRAF(addition) {
	    var lastTime = 0;
	    var vendors = ['webkit', 'moz'];
	    for(var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
	        window.requestAnimationFrame = window[vendors[x] + 'RequestAnimationFrame'];
	        window.cancelAnimationFrame = window[vendors[x] + 'CancelAnimationFrame'] ||
	                                      window[vendors[x] + 'CancelRequestAnimationFrame'];
	    }

	    if (!window.requestAnimationFrame || addition) {
	        window.requestAnimationFrame = function(callback, element) { //兼容不支持requestAnimationFrame的情况
	            var currTime = new Date().getTime();
	            var timeToCall = Math.max(0, 16.7 - (currTime - lastTime));
	            var id = window.setTimeout(function() {
	                callback(currTime + timeToCall);
	            }, timeToCall);
	            lastTime = currTime + timeToCall;
	            return id;
	        };
	    }
	    if (!window.cancelAnimationFrame || addition) {
	        window.cancelAnimationFrame = function(id) {
	            clearTimeout(id);
	        };
	    }
	})()
</script>
```

### 浏览器不能使用canvas + video
&emsp;&emsp;canvas + video很好的解决的去除video默认控件的问题，but新的问题出现了，有的浏览器不支持canvas + video。到了这里恩~hhh，我也不知道怎么办啦，暂时先放着，最理想的解决办法就是所有浏览器都支持自定义控件，那就慢慢等吧~。

## 最后
&emsp;&emsp;本次项目学习了很多，后面还会继续记录学习的知识，这里放一下本次项目所做的测试结果(不一定与本文章有关)，测试耗费了我好多天啊啊啊。测试环境: android 7; ios 11。
[进出页面触发函数支持情况](/doc/移动端的video/函数支持情况.docx)
[控件测试情况](/doc/移动端的video/控件测试情况.docx)
[控件触发情况](/doc/移动端的video/控件触发情况.docx)