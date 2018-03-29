---
title: js执行机制
date: 2018-03-28 10:44:37
categories: Blogs
tags: [js]
---
前段时间看见一篇关于[JavaScript执行机制](https://juejin.im/post/59e85eebf265da430d571f89)的文章,看完仔细回味后感觉受益匪浅，于是想借着文章作者的思路，简单的介绍一下javascript执行机制，想仔细的了解就戳前面那篇文章。<!--more-->
## 前言
&ensp;&ensp;&ensp;&ensp;javascript是一门单线程语言是众所周知的，所谓的异步、Web-Worker都是模拟出来的（HTML5提出Web Worker标准，允许JavaScript脚本创建多个线程，但是子线程完全受主线程控制，且不得操作DOM。所以，这个新标准并没有改变JavaScript单线程的本质。）。因为是单线程啊，代码也需要排队，那这样的话是不是可以猜想javascript代码出现的越早就执行的越早呢？其实远不是这么简单，单线程是真的，排队也是真的，但是不一定按代码出现的顺序执行。那javascript的执行顺序到底是什么呢？
## javascript的单线程
&ensp;&ensp;&ensp;&ensp;以前一直依着javascript是代码出现顺序执行的理念，给出以下的代码：
```javascript
console.log("输出1")；
console.log("输出2")；
console.log("输出3")；
console.log("输出4")；
```
&ensp;&ensp;&ensp;&ensp;看完这段代码是不是嘴角微微上扬，这么简单，毫无疑问当然是按代码出现顺序，依次输出：
```
输出1;
输出2;
输出3;
输出4。
```
&ensp;&ensp;&ensp;&ensp;对的，就是这样输出，但是我们再看这段代码：
```javascript
setTimeout(function(){
    console.log('定时器开始啦')
});

new Promise(function(resolve){
    console.log('马上执行for循环啦');
    for(var i = 0; i < 10000; i++){
        i == 99 && resolve();
    }
}).then(function(){
    console.log('执行then函数啦')
});

console.log('代码执行结束');
```
&ensp;&ensp;&ensp;&ensp;是不是还是微微一笑，还不是一样的按顺序执行输出：
```
定时器开始啦
马上进入循环啦
执行then函数啦
代码执行结束
```
&ensp;&ensp;&ensp;&ensp;然而事实并不是这样，事实上是这样输出：
```
马上执行for循环啦
代码执行结束
执行then函数啦
定时器开始啦
```
&ensp;&ensp;&ensp;&ensp;看完后，what？？？这是什么鬼。javascript的单线程不简单，并不是简单地以代码出现顺序执行的。那到底是怎样的机制呢？继续往下看。

## 事件循环
&ensp;&ensp;&ensp;&ensp;事件循环的顺序，决定js代码的执行顺序。进入整体代码(宏任务)后，开始第一次循环。接着执行所有的微任务。然后再次从宏任务开始，找到其中一个任务队列执行完毕，再执行所有的微任务。
> * macro-task(宏任务)：包括整体代码script，setTimeout，setInterval
> * micro-task(微任务)：Promise，process.nextTick

&ensp;&ensp;&ensp;&ensp;事件循环，宏任务，微任务的关系如图所示：
![关系图](/img/js执行机制/1.png)
## 验证所学的知识
&ensp;&ensp;&ensp;&ensp;我们来分析一段较复杂的代码，看看你是否真的掌握了js的执行机制：
```javascript
console.log('1');

setTimeout(function() {
    console.log('2');
    process.nextTick(function() {
        console.log('3');
    })
    new Promise(function(resolve) {
        console.log('4');
        resolve();
    }).then(function() {
        console.log('5')
    })
})
process.nextTick(function() {
    console.log('6');
})
new Promise(function(resolve) {
    console.log('7');
    resolve();
}).then(function() {
    console.log('8')
})

setTimeout(function() {
    console.log('9');
    process.nextTick(function() {
        console.log('10');
    })
    new Promise(function(resolve) {
        console.log('11');
        resolve();
    }).then(function() {
        console.log('12')
    })
})
```
第一轮事件循环流程分析如下：
* 整体script作为第一个宏任务进入主线程，遇到console.log，输出1。
* 遇到setTimeout，其回调函数被分发到宏任务Event Queue中。我们暂且记为setTimeout1。
* 遇到process.nextTick()，其回调函数被分发到微任务Event Queue中。我们记为process1。
* 遇到Promise，new Promise直接执行，输出7。then被分发到微任务Event Queue中。我们记为then1。
* 又遇到了setTimeout，其回调函数被分发到宏任务Event Queue中，我们记为setTimeout2。
* 我们发现了process1和then1两个微任务。
* 执行process1,输出6。
* 执行then1，输出8。

好了，第一轮事件循环正式结束，这一轮的结果是输出1，7，6，8。那么第二轮时间循环从setTimeout1宏任务开始：

* 首先输出2。接下来遇到了process.nextTick()，同样将其分发到微任务Event Queue中，记为process2。new Promise立即执行输出4，then也分发到微任务Event Queue中，记为then2。

第二轮事件循环宏任务结束，我们发现有process2和then2两个微任务可以执行。
* 输出3。
* 输出5。
第二轮事件循环结束，第二轮输出2，4，3，5。

第三轮事件循环开始，此时只剩setTimeout2了，执行。
* 直接输出9。
* 将process.nextTick()分发到微任务Event Queue中。记为process3。
* 直接执行new Promise，输出11。
* 将then分发到微任务Event Queue中，记为then3。
第三轮事件循环宏任务执行结束，执行两个微任务process3和then3。
* 输出10。
* 输出12。
* 第三轮事件循环结束，第三轮输出9，11，10，12。

整段代码，共进行了三次事件循环，完整的输出为1，7，6，8，2，4，3，5，9，11，10，12。(请注意，node环境下的事件监听依赖libuv与前端环境不完全相同，输出顺序可能会有误差)

## 感谢链接
[这一次，彻底弄懂 JavaScript 执行机制](https://juejin.im/post/59e85eebf265da430d571f89)
