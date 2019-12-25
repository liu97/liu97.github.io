---
title: React中的错误边界
date: 2019-12-25 21:57:10
categories: Blogs
tags: [react]
---
在使用react开发中，经常会遇到某一段js写的有问题而导致整个应用直接卡死崩溃。如果在线上用户遇到这样的问题，会非常影响使用体验。这时候错误边界的作用就体现出来了。<!--more-->

## 定义
错误边界是一种 React 组件，这种组件可以捕获并打印发生在其子组件树任何位置的 JavaScript 错误，并且，它会渲染出备用 UI，而不是渲染那些崩溃了的子组件树。错误边界在渲染期间、生命周期方法和整个组件树的构造函数中捕获错误。
> 注意
错误边界无法捕获以下场景中产生的错误：
事件处理（[了解更多](https://react.docschina.org/docs/error-boundaries.html#how-about-event-handlers)）
异步代码（例如 setTimeout 或 requestAnimationFrame 回调函数）
服务端渲染
它自身抛出来的错误（并非它的子组件）

## 作用
错误边界可以对上面提到的问题有一个比较友好的处理：
1. 在开发时遇到程序崩溃，可以将错误捕获并打印出错误具体信息，方便开发人员排错；
2. 在线上遇到错误时能够比较友好的显示错误页面，引导用户遇到错误后进行相关的处理；
3. 线上遇到错误时能够捕获错误，进行错误上报，方便开发人员排查线上bug。

## API使用
当组件中使用了生命周期函数 static getDerivedStateFromError(error) 或 componentDidCatch(error, info) 这两个生命周期方法中的任意一个（或两个）时，那么它就变成一个错误边界。当抛出错误后，请使用 static getDerivedStateFromError() 渲染备用 UI ，使用 componentDidCatch() 打印错误信息。

看到这里是不是会有一点点懵，既然这两个生命周期函数中任意一个都能让组件变成错误边界，那为什么要两个API呢，为什么用 static getDerivedStateFromError() 渲染备用 UI 而使用 componentDidCatch() 打印错误信息呢？

Reat提供两个API是有原因的：static getDerivedStateFromError() 在render阶段触发，时机足够早防止出现连锁错误，不允许含有副作用（否则多次执行会出问题）；而componentDidCatch是在commit阶段触发，因此允许含有副作用（如logErrorToMyService）。所以 static getDerivedStateFromError() 比较适合做更新 state 使下一次渲染可以显示降级 UI，而 componentDidCatch() 适合做打印错误，上报错误等需要的操作。

使用官网展示的例子：
```javascript
class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(error) {
    // 更新 state 使下一次渲染可以显示降级 UI
    return { hasError: true };
  }

  componentDidCatch(error, info) {
    // "组件堆栈" 例子:
    //   in ComponentThatThrows (created by App)
    //   in ErrorBoundary (created by App)
    //   in div (created by App)
    //   in App
    logComponentStackToMyService(info.componentStack);
  }

  render() {
    if (this.state.hasError) {
      // 你可以渲染任何自定义的降级 UI
      return <h1>Something went wrong.</h1>;
    }

    return this.props.children; 
  }
}
```

*注意错误边界仅可以捕获其子组件的错误，它无法捕获其自身的错误。如果一个错误边界无法渲染错误信息，则错误会冒泡至最近的上层错误边界，这也类似于 JavaScript 中 catch {} 的工作机制。*

## 感谢链接
[what's the difference between getDerivedStateFromError and componentDidCatch](https://stackoverflow.com/questions/52962851/whats-the-difference-between-getderivedstatefromerror-and-componentdidcatch)