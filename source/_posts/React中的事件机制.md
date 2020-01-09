---
title: React中的事件机制
date: 2019-12-26 10:37:21
categories: Blogs
tags: [react]
---
react自己有一套事件机制，包括事件注册、事件的合成、事件冒泡、事件派发等，与原生的事件不是同一个东西，但是react事件机制是基于原生事件来完成的。<!--more-->

## 基本认知

react将所有绑定在react元素上的事件全部托管到document上，最后通过冒泡或捕获来响应事件。react中合成事件的默认代理注册的都是冒泡阶段的事件监听器。如需注册捕获阶段的事件处理函数，则应为事件名添加 Capture。例如，处理捕获阶段的点击事件请使用 onClickCapture，而不是 onClick。

需要注意的是，事实上合成事件都是注册在真实dom事件的冒泡阶段，并不存在所谓的“捕获”，onClickCapture所谓的捕获阶段执行只是react把doc上事件绑定的监听序列从后往前依次触发执行。合成事件总是晚于dom原生事件的捕获冒泡监听函数，可以简单理解为先执行一遍dom原生的事件捕获和冒泡阶段，再走一遍react自定义事件的“捕获和冒泡”。

## 为什么要合成事件

### 1. 减少内存消耗，提升性能。

react将事件统一托管到document上，一种事件类型只在 document 上注册一次，减少了事件监听次数，所以可以减少内存消耗。

### 2. 统一规范，解决 ie 事件兼容问题，简化事件逻辑

react会对事件做一些兼容处理，比如判断当前浏览器API支持，现代浏览器使用adEventListener，而在IE上使用attachEvent等等。对开发人员比较友好，提高了程序的可用性。

### 3. 对某些原生事件的升级和改造

react会对一些原生事件做一些升级和改造，比如原生input的onChange事件需要在当前input失焦后才会触发，而react对onChange做了一些比较合理的改进。如下图，可以通过Event Listeners看到，react为input绑定了许多相关的函数，来配合onChange和其他功能。

![react绑定在input上额事件](/img/React中的事件机制/1.png)

## 合成事件的使用

SyntheticEvent 实例将被传递给你的事件处理函数，它是浏览器的原生事件的跨浏览器包装器。除兼容所有浏览器外，它还拥有和浏览器原生事件相同的接口，包括 stopPropagation() 和 preventDefault()。

如果因为某些原因，当你需要使用浏览器的底层事件时，只需要使用 nativeEvent 属性来获取即可。每个 SyntheticEvent 对象都包含以下属性：

> boolean bubbles
> boolean cancelable
> DOMEventTarget currentTarget
> boolean defaultPrevented
> number eventPhase
> boolean isTrusted
> DOMEvent nativeEvent
> void preventDefault()
> boolean isDefaultPrevented()
> void stopPropagation()
> boolean isPropagationStopped()
> DOMEventTarget target
> number timeStamp
> string type

## 阻止事件冒泡

由于react自身实现了一套事件机制，虽然react合成事件的api和原生事件api类似，但毕竟不是一个东西。下面我们来分析这几种情况中怎么阻止冒泡：

### 1. 只涉及到react合成事件

当在开发中，只涉及到react合成事件，阻止冒泡的方法比较简单，使用e.stopPropagation()：

``` javascript
handleParentClick = (e: React.MouseEvent) => {
    // 这句不会打印，因为被子元素给阻止冒泡了
    console.log('parent react绑定点击')
}
handleChildClick = (e: React.MouseEvent) => {
    e.stopPropagation();
    console.log('child react绑定点击')
}
render() {
    return ( 
        <div onClick = { this.handleParentClick} >
            <div onClick = { this.handleChildClick } >点我</div> 
        </div>
    )
}
```

### 2. 涉及到react合成事件和document上绑定原生事件

这种情况也需要区分两种情况：
* document原生事件在react合成事件之后绑定
``` javascript
componentDidMount() {
    document.addEventListener('click', function () {
        // 这句不会打印，被stopImmediatePropagation阻止了
        console.log('document 原生绑定点击')
    }, false);
}
handleChildClick = (e: React.MouseEvent) => {
    // 通过获取浏览器底层事件，使用stopImmediatePropagation阻止同层同类型事件(还可以防止冒泡，但document已经是顶层了)
    e.nativeEvent.stopImmediatePropagation();
    console.log('child react绑定点击')
}
render() {
    return ( 
        <div onClick = { this.handleChildClick } >点我</div> 
    )
}
```

* document原生事件在react合成事件之前绑定
这种情况只能和下面非document原生事件情况一样处理。
``` javascript
constructor(props: IPorps) {
    super(props);
    document.addEventListener('click', function () {
        console.log('document 原生绑定点击')
    }, false);
}
handleChildClick = (e: React.MouseEvent) => {
    // 这里阻止不了，因为stopImmediatePropagation只能阻止同层 后续 同类型事件
    e.nativeEvent.stopImmediatePropagation();
    console.log('child react绑定点击')
}
render() {
    return ( 
        <div onClick = { this.handleChildClick } >点我</div> 
    )
}
```

### 3.涉及到react合成事件和非document上绑定原生事件
由于非document原生事件冒泡阶段一定在合成事件冒泡阶段之前，所以其实这种情况已经不是阻止冒泡了。
``` javascript
componentDidMount() {
    document.body.addEventListener('click', function (e) {
        // 这里通过e.target来阻止
        if (e.target && e.target === document.querySelector('#child')) {
            return;
        }
        console.log('body 原生绑定点击')
    }, false);
}
handleChildClick = (e: React.MouseEvent) => {
    // 这里阻止无效，因为到冒泡到这里(document)时已经经过了body
    e.stopPropagation();
    e.nativeEvent.stopImmediatePropagation();
    console.log('child react绑定点击')
}
render() {
    return ( 
        <div id="child" onClick = { this.handleChildClick } >点我</div> 
    )
}
```

## 感谢链接

[【长文慎入】一文吃透 react 事件机制原理](https://juejin.im/post/5d7678b06fb9a06b2b47a03c)
[React 合成事件](https://happy-alex.github.io/js/react/syntheticEvent/)