---
title: React-Component
date: 2018-11-26 16:13:23
categories: Blogs
tags: [react]
---
经过一段时间的学习，逐渐对React有了一定的了解。这次我们来讲讲React组件中关于组件的一些知识，包括React组件生命周期、props及state。<!--more-->

## 组件生命周期

### 变动

React V16的这几次版本在生命周期这块改动非常大，改动的原因是React团队在致力于实现异步渲染机制，来提高React的渲染效率。总的来看，React删除了3个生命周期函数，增加了2个新的生命周期函数。
> 新增了`getDerivedStateFromProps`、`getSnapshotBeforeUpdate`
> 删除了`componentWillMount`、`componentWillReceiveProps`、`componentWillUpdate`

具体的迁移路径可以看[这里](https://reactjs.org/blog/2018/03/27/update-on-async-rendering.html)

### constructor(props)

组件在装配之前被调用`constructor`

构造函数是初始化状态的合适位置。若你不初始化状态且不绑定方法，那你也不需要为你的React组件定义一个构造函数。

### static getDerivedStateFromProps(nextProps, prevState)

组件实例化后和接受新属性时将会调用`getDerivedStateFromProps`。它应该返回一个对象来更新状态，或者返回null来表明新属性不需要更新任何状态。

注意，如果父组件导致了组件的重新渲染，即使属性没有更新，这一方法也会被调用。如果你只想处理变化，你可能想去比较新旧值。

这个函数是为新增函数，它的出现是为了代替`componentWillReceiveProps`。它一个静态函数，所以这个周期函数不能通过`this`来访问组件。而它的参数为nextProps和prevState，所以我们应该通过比较这两个参数来进行判断。更新子组件的state来响应props变化最适合适合这个周期函数。

* 基本使用

```javascript
static getDerivedStateFromProps(nextProps, prevState){
	if(nextProps.value != prevState.value){
		return {
			value
		};
	}
	return null;
}
```

* 处理异步操作

以前的版本我们有的情况会在`componentWillReceiveProps`进行异步操作：

```javascript
componentWillReceiveProps(nextProps){
	if(nextProps.value != this.props.value){
		this.setState({
			value: nextProps.value
		});
		this.fetch(); // 异步操作
	}
}
```

而我们现在可以和componentDidUpdate配合：

```javascript
static getDerivedStateFromProps(nextProps, prevState){
	if(nextProps.value != prevState.value){
		return {
			value
		};
	}
	return null;
}
componentDidUpdate() {
	// 仅在更新触发后请求数据
    this.fetch(); // 异步操作
 }
```

可以看到，通过使用static getDerivedStateFromProps我们会自觉地在`componentDidUpdate()`进行异步操作，因为我们别无选择。这样处理的好处是可以预防props在短时间内频繁的变动而导致发送许多不必要的异步请求。

### render()

render()触发方式：
> 1. 首次加载
> 2. setState改变组件内state
> 3. 接受新的props
> 4. 调用this.forceUpdate()

render()函数应该纯净，意味着其不应该改变组件的状态，其每次调用都应返回相同的结果，同时不直接和浏览器交互。若需要和浏览器交互，将任务放在`componentDidMount()`阶段或其他的生命周期方法。保持`render()` 方法纯净使得组件更容易思考。

### componentDidMount()

componentDidMount()在组件被装配后立即调用。

这一方法是一个发起任何订阅的好地方。如果你这么做了，别忘了在`componentWillUnmount()`退订。

在这个方法中调用setState()将会触发一次额外的渲染，但是它将在浏览器刷新屏幕之前发生。这保证了即使render()将会调用两次，但用户不会看到中间状态。

### shouldComponentUpdate(nextProps, nextState)

当组件接收到新的state或props时调用。和getDerivedStateFromProps一样，如果父组件导致了组件的重新渲染，即使属性没有更新，这一方法也会被调用。该方法并不会在初始化渲染或当使用forceUpdate()时被调用。

使用`shouldComponentUpdate()`以让React知道当前状态或属性的改变是否不影响组件的输出。默认行为是在每一次状态的改变重渲，在大部分情况下你应该依赖于默认行为。当这个函数返回false后，后续的render、getSnapshotBeforeUpdate和componentDidUpdate都不会触发。当他们状态改变时，返回false 并不能阻止子组件重渲。意思为当父子组件存在，父组件当前函数返回值为false的时候，当前组件的state变化也不会引起重新渲染。但是不会影响子组件的state变化导致的子组件的重新渲染。

### getSnapshotBeforeUpdate()

`getSnapshotBeforeUpdate()`在最新的渲染输出提交给DOM前将会立即调用。

* 典型场景：获取render之前的dom状态

借用[这里](https://blog.csdn.net/wust_cyl/article/details/84306393)的例子，情景模拟：假如有一个div盒子，我们每秒向div盒子里最上面添加一个p，我们如何保证每次添加不会下移当前我们看到的p，也就是保证我们视角里的p不移动？

```javascript
class SnapshotSample extends React.Component {
     constructor(props) {
        super(props);
        this.state = {
          messages: [],//用于保存子div
        }
     }
 
     handleMessage () {//用于增加msg
       this.setState( pre => ({
         messages: [`msg: ${ pre.messages.length }`, ...pre.messages],
       }))
     }
     componentDidMount () {
        
       for (let i = 0; i < 20; i++) this.handleMessage();//初始化20条
       this.timeID = window.setInterval( () => {//设置定时器
            if (this.state.messages.length > 200 ) {//大于200条，终止
              window.clearInterval(this.timeID);
              return ;
            } else {
              this.handleMessage();
            }
       }, 1000)
     }
     componentWillUnmount () {//清除定时器
       window.clearInterval(this.timeID);
     }
     getSnapshotBeforeUpdate () {//很关键的，我们获取当前rootNode的scrollHeight，传到componentDidUpdate 的参数perScrollHeight
       return this.rootNode.scrollHeight;
     }
     componentDidUpdate (perProps, perState, perScrollHeight) {
       const curScrollTop= this.rootNode.scrollTop;
       if (curScrollTop < 5) return ;
       this.rootNode.scrollTop = curScrollTop + (this.rootNode.scrollHeight  - perScrollHeight);
       //加上增加的div高度，就相当于不动
     }
     render () {
      
       return (
           <div className = 'wrap'  ref = { node => (  this.rootNode = node)} >
               { this.state.messages.map( msg => (
                 <p>{ msg } </p>
               ))}
          </div>
       );
     }
}
```
由于异步渲染，在“渲染”时期（如componentWillUpdate和render）和“提交”时期（如getSnapshotBeforeUpdate和componentDidUpdate）间可能会存在延迟。因为`getSnapshotBeforeUpdate()`是在最新渲染DOM的前调用，所以可以保证这个函数调用的时候值为我们看到的最新值，不会造成值延迟。

### componentDidUpdate(prevProps, prevState)

`componentDidUpdate()`会在更新发生后立即被调用。该方法并不会在初始化渲染时调用。

当组件被更新时，使用该方法是操作DOM的一次机会。这也是一个适合发送请求的地方，要是你对比了当前属性和之前属性（例如，如果属性没有改变那么请求也就没必要了）。

### componentWillUnmount()

componentWillUnmount()在组件被卸载和销毁之前立刻调用。

可以在该方法里处理任何必要的清理工作，例如解绑定时器，取消网络请求，清理任何在componentDidMount环节创建的DOM元素。

### componentDidCatch(error, info)

错误边界是React组件，并不是损坏的组件树。错误边界捕捉发生在子组件树中任意地方的JavaScript错误，打印错误日志，并且显示回退的用户界面。错误边界捕捉渲染期间、在生命周期方法中和在它们之下整棵树的构造函数中的错误。

如果定义了这一生命周期方法，一个类组件将成为一个错误边界。在错误边界中调用`setState()`让你捕捉当前树之下未处理的JavaScript错误，并显示回退的用户界面。只使用错误边界来恢复异常，而不要尝试将它们用于控制流。

![生命周期执行顺序](/img/React-Component/1.png)

## state

state必须能代表一个组件UI呈现的完整状态集，即组件的任何UI改变，都可以从state的变化中反映出来；同时，state还必须是代表一个组件UI呈现的最小状态集，即state中的所有状态都是用于反映组件UI的变化，没有任何多余的状态，也不需要通过其他状态计算而来的中间状态。

### 初始化

我们可以在组件的`constructor()`函数里初始化state。

```javascript
constructor(props){
	super(props);
	this.state = {
		value: 1
	}
}
```

### 修改

state不能通过赋值运算来直接修改，那样修改不会触发`render()`函数，我们应该通过`setState()`来更新值：

```javascript
this.setState({
	value: 1
})
```

由于`setState()`是异步的，所以我们不能保证当前取到的值是最新值，也就是说我们不应该依靠它们的值来计算下一个状态。
```javascript
constructor(props){
	super(props);
	this.state = {
		value: 1
	}
}

this.setState({
	value: this.state.value + 1
})
this.setState({
	value: this.state.value + 1
})
```

上面这两个连续setState由于异步的原因可能导致this.state.value == 2, 因为第2个取到的value可能是还未更新的值1。那我们怎么来避免呢？

```javascript
this.setState(function(prevState, props){
	value: prevState.value + 1
})
this.setState(function(prevState, props){
	value: prevState.value + 1
})
```

这样写的话this.state.value的值一定是3，因为第2个setState里的prevState一定是第1个setState更新后的值。

## props

我们想要在组件之间进行传值，那么props属性就起到了这个作用。

### props的只读性

所有的React组件必须像纯函数那样使用它们的props。但是，很有可能程序员们会不知不觉修改了props，那props能被修改吗？

```javascript
const { Button } = antd;

class App extends React.Component {
	constructor(props){
		super(props);
		this.state = {
			a: 0,
			b: {
			  	sta: 'loading',
			  	fresh: 1
			}
		};
	}
	freshState = ()=>{
		this.setState({
			a: 1
		})
	}
	render() {
		return (
			<div>
				{this.state.b.sta}
				<Child b={this.state.b} freshState={this.freshState}></Child>
			</div>
		);
	}
}
class Child extends React.Component {
	constructor(props){
		super(props);
	}
	btnClick = ()=>{
		this.props.b.sta = 'edit'+this.state.a; // 可修改b里的基本值，且会影响到父组件的值, 但是这里不会造成父组件render
		this.props.freshState(); // 让父组件重新render
		this.props.b = {sta: 'hah', fresh: 'hhh'}; // 直接修改b的地址会被忽略
	} 
	render(){
		let props = this.props
		return(
			<div>
				<h2>{props.b.sta}</h2>
				<button onClick={this.btnClick}>click</button>
			</div>
		)
	}
}
ReactDOM.render(<App />, mountNode);
```

上面的例子我们可以看出来，我们可以通过修改props里的值来影响父组件，但是当我们直接把props重新赋值时会被直接忽略。前面已经说了，我们不应该修改props，那我们怎么保证不会再无意间修改props呢？ 我们可以对props进行cloneDeep来来避免无意修改。

## 感谢链接

[拥抱react新生命周期--getDerivedStateFromProps](https://juejin.im/post/5bea68a6e51d450cb20fdd70)