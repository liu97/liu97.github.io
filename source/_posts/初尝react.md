---
title: 初尝react
date: 2018-08-13 21:46:24
categories: Blogs
tags: [react]
---
时间过得真快啊，从找到实习工作到现在算起来也有一个多月了，这段时间一直在学习新知识和完成工作需求，许久没写记录博客了，最近一个项目慢慢进入尾声，现在有些许时间可以让我沉淀下。进入正题，这一个多月从听过react到能简单试用react，学习了许多，现在简单回忆下react的知识点<!--more-->

## react工作原理
> Virtual dom机制：由虚拟dom管理真实dom的更新。
> 对于每一个组件，react会在内存中构建一个相对应的dom树，当组件状态发生变化时，react都会重新构建整个dom数据，将当前整个dom树和上一次的dom树通过diff算法进行对比，得出dom结构变化的部分，计算出最小的步骤更新真实dom。整个过程在内存中进行，因此效率比较高。

## react特点
> 高效：虚拟dom，通过对dom的模拟，最大限度减少与dom的交互。 
> 灵活：可以与已有的框架或库很好的配合。 
> jsx：直观定义用户界面，react的核心组成部 
> 组件：构建组件，使代码更容易得到复用。 
> 单项响应数据流：变化可预计、可控制。

## react基本应用
### 1.神奇的JSX
```javascript
let element = <h1>Hello, world!</h1>;
```
乍一看还真不知道这是什么，一个html标签被赋值给一个js变量。这个看似奇怪的东西叫做JSX。React 不一定非要使用JSX，使用原生的JavaScript也是可以的，只是语法会变得很复杂，因为它能定义简洁且我们熟知的包含属性的树状结构语法。
XML 有固定的标签开启和闭合。这能让复杂的树更易于阅读，优于方法调用和对象字面量的形式。
它没有修改JavaScript语义，JSX本身其实也是一种表达式，在编译之后呢，JSX其实会被转化为普通的JavaScript对象：
```javascript
<MyButton color="blue" shadowSize={2}>
  Click Me
</MyButton>
```
会编译为：
```javascript
React.createElement(
  MyButton,
  {color: 'blue', shadowSize: 2},
  'Click Me'
)
```
### 2.组件
react中组件分为函数定义组件和类定义组件。
**函数定义组件**
定义一个组件最简单的方式是使用函数定义：
```javascript
function Welcome(props) {
  return <h1>Hello, {props.name}</h1>;
}
```
与类定义组件的最大区别是：函数定义组件没有生命周期函数，所以一般被用作简单的输出作用。
**类定义组件**
> 你可以通过5个步骤将函数组件 Clock 转换为类
> 创建一个名称扩展为 React.Component 的ES6 类
> 创建一个叫做render()的空方法
> 将函数体移动到 render() 方法中
> 在 render() 方法中，使用 this.props 替换 props
> 删除剩余的空函数声明

```javascript
class Clock extends React.Component {
  constructor(props) {
    super(props);
    this.state = {date: new Date()};
  }

  componentDidMount() {

  }

  componentWillUnmount() {

  }

  render() {
    return (
      <div>
        <h1>Hello, world!</h1>
        <h2>It is {this.state.date.toLocaleTimeString()}.</h2>
      </div>
    );
  }
}
```
### 3.生命周期函数
了解react的生命周期函数对学习react来说非常重要，在数据频繁变换的情况下，要准确知道哪个生命周期内会修改哪些数据，会对后面的生命周期函数的执行产生什么影响。
(1).下面为react v16.3.1版本中的组件生命周期执行顺序：
![生命周期执行图](/img/初尝react/1.png)
(2).父子组件的生命周期执行顺序：
> parent_constructor -> ... -> parent_render -> child_constructor -> ... child_render -> ... child_componentDidMount -> ... -> parent_componentDidMount

### 4.props & state
**props**
> 父级向子级传递数据的一种方式。 
> 只读的属性，从父组件传入，组件内部不能更改

**state** 
> 存在于组件内部： 
> 只能在组件内部通过this.setState()进行更改。 
> 更新state之后重新渲染用户界面。

**哪些应该设置为state**
> 仅包括能表示拥护界面状态所需要的最少数据。 
> state应该包括那些可能被组件的事件处理器改变并触发用户界面更新的数据。 
> 保持数据的精简，冗余数据无需存入state中

## 总结
此篇博客只是简单的介绍了一下react的常见知识点，对每个知识点都没有深入剖析，以后学到深处会针对重要的知识点逐个进行介绍。