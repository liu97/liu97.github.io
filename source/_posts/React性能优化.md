---
title: React性能优化
date: 2020-01-08 15:05:59
categories: Blogs
tags: [react]
---
在我们平常的 React 开发中，我们肆无忌惮的编写着代码，项目刚开始可能没什么大问题，但是随着项目越来越大，功能越来越多，问题就慢慢的就凸显出来了。为了让项目能够正常、稳定的运行，我们在编写代码的时候应该多思考，代码该怎么划分、该怎么编写。<!--more-->

以下为总结的一些关于react优化相关的知识：

## 多用React.PureComponent和React.memo
`React.PureComponent`和`React.memo`很相似，都是能够在一定的条件下减少组件的重新渲染，提高性能。

### React.PureComponent
`React.PureComponent`与`React.Component`很相似，两者的区别在于 `React.Component`并未实现`shouldComponentUpdate()`，而`React.PureComponent`中以浅层对比 prop 和 state 的方式来实现了`shouldComponentUpdate()`，所以当新的 props 或 state 出现的时候，`React.PureComponent`会自行将新的 props 和 state 与原来的进行浅对比，如果没有变化的话，组件就不会重新render。
>注意
`React.PureComponent`仅仅是做浅对比，如果 props 或者 state 有比较复杂的结构比如数组或者对象的话，这个时候比较容易出错，需要你在深层数据结构发生变化时调用`forceUpdate()`来确保组件被正确地更新。你也可以考虑使用 immutable 对象加速嵌套数据的比较。<br/>
`React.PureComponent`中如果编写了自定义的`shouldComponentUpdate()`，`React.PureComponent`将会取消默认的浅层对比，而使用自定义的`shouldComponentUpdate()`。

```javascript
class RegularChildComponent extends Component<IProps, IState> {
    render() {
        console.log("Regular Component Rendered.."); // 每次父组件更新都会渲染
        return <div>{this.props.name}</div>;
    }
}

class PureChildComponent extends PureComponent<IProps, IState> {

  readonly state: Readonly<IState> = {
    age: "18",
  }

  updateState = () => {
    setInterval(() => {
      this.setState({
        age: "18"
      })
    }, 1000)
  }

  componentDidMount() {
    this.updateState();
  }

  render() {
    console.log("Pure Component Rendered..")  // 只渲染一次
    return <div>{this.props.name}</div>;
  }
}

class Demo extends Component<IProps, IState> {
  readonly state: Readonly<IState> = {
    name: "liu",
  }

  componentDidMount() {
    this.updateState();
  }

  updateState = () => {
    setInterval(() => {
      this.setState({
        name: "liu"
      })
    }, 1000)
  }

  render() {
    console.log("Render Called Again") // 每次组件更新都会渲染
    return (
      <div>
        <RegularChildComponent name={'this.state.name'} />
        <PureChildComponent name={this.state.name} />
      </div>
    )
  }
}
```

### React.memo(component, areEqual)
`React.memo`和`React.PureComponent`功能差不多，但是`React.memo`适用于函数组件，但不适用于 class 组件。

如果你的函数组件在给定相同 props 的情况下渲染相同的结果，那么你可以通过将其包装在`React.memo`中调用，以此通过记忆组件渲染结果的方式来提高组件的性能表现。这意味着在这种情况下，React 将跳过渲染组件的操作并直接复用最近一次渲染的结果。

默认情况下其只会对复杂对象做浅层对比，如果你想要控制对比过程，那么请将自定义的比较函数通过第二个参数传入来实现。
```javascript
// 父组件和上面一样
function ChildComponent(props: IProps){
  console.log("Pure Component Rendered..")  // 只渲染一次
  return <div>{props.name}</div>;
}
const PureChildComponent = React.memo(ChildComponent);
```

## 巧用shouldComponentUpdate(nextProps, nextState)
在这个函数里面，我们可以自己来决定是否重新渲染组件，返回 false 以告知 React 可以跳过更新。首次渲染或使用 forceUpdate() 时不会调用该方法。
>注意
不建议在 shouldComponentUpdate() 中进行深层比较或使用 JSON.stringify()。这样非常影响效率，且会损害性能。<br/>
返回 false 并不会阻止子组件在 state 更改时重新渲染。

```javascript
class Demo extends Component<IProps, IState> {
  readonly state: Readonly<IState> = {
    name: "liu",
    age: 18,
  }

  componentDidMount() {
    this.setState({
      name: "liu",
      age: 19,
    })
  }

  shouldComponentUpdate(nextProps: IProps, nextState: IState){
    if(this.state.name === nextState.name){
      return false
    }
    return true;
  }

  render() {
    console.log("Render Called Again") // 只会打印一次
    return (
      <div>
        {this.state.name}
      </div>
    )
  }
}
```
上面的例子中，因为组件只渲染了 state.name ，所以当 age 改变但是 name 没有改变的时候我们并不需要重新渲染，所以我们可以在`shouldComponentUpdate()`中阻止渲染。在上面例子中阻止渲染是对的，但是当前组件或子组件如果用到了 state.age ，那么我们就不能只根据 name 来判断是否阻止渲染，否则会出现数据和界面不一致的情况。

因此，当我们在使用`shouldComponentUpdate()`应该始终清楚我们什么情况下才能阻止重新渲染。

## bind函数位置
当我们在 React 中创建函数时，我们需要使用 bind 关键字将函数绑定到当前上下文。绑定可以在构造函数中完成，也可以在我们将函数绑定到 DOM 元素的位置上完成。

但是当我们将函数绑定到 DOM 元素的位置后，每次render的时候都会进行一次bind，这将会有一些不必要的性能损耗，而且还有可能导致子组件不必要的渲染。所以我们可以在构造函数中绑定，也可以直接写箭头函数。同理，我们尽量不写内联函数和内联属性。
```javascript
// good
class Binding extends React.Component {
  constructor() {
    this.handleClick = this.handleClick.bind(this);
  }
  
  handleClick() {
    alert("Button Clicked")
  }
  
  render() {
    return (
      <input type="button" value="Click" onClick={this.handleClick} />
    )
  }
}
// good
class Binding extends React.Component {
  handleClick = () => {
    alert("Button Clicked")
  }
  
  render() {
    return (
      <input type="button" value="Click" onClick={this.handleClick} />
    )
  }
}
// bad
class Binding extends React.Component {
  handleClick() {
    alert("Button Clicked")
  }
  
  render() {
    return (
      <input type="button" value="Click" onClick={this.handleClick.bind(this)} />
    )
  }
}
```

## 使用key
key 帮助 React 识别哪些元素改变了，比如被添加或删除。因此你应当给数组中的每一个元素赋予一个确定的标识。因为有key的存在，使得 React 的diff算法有质的飞跃。

一个元素的 key 最好是这个元素在列表中拥有的一个独一无二的字符串。通常，我们使用数据中的 id 来作为元素的 key。如果列表项目的顺序可能会变化，我们不建议使用索引来用作 key 值，因为这样做会导致性能变差，还可能引起[组件状态的问题](https://jsbin.com/wohima/edit?output)。
```javascript
const todoItems = todos.map((todo) =>
  <li key={todo.id}>
    {todo.text}
  </li>
);
```

## 代码分割
当我们在一个界面有两个或多个互斥或者不太可能同时出现的”大组件“的时候，我们可以将那些组件分割出来，以减少主js的体积。
```javascript
// 该组件是动态加载的
const OneComponent = React.lazy(() => import('./OneComponent'));
const OtherComponent = React.lazy(() => import('./OtherComponent'));

function MyComponent() {
  let isIOS = getCurrentEnv();
  return (
    // 显示 <Spinner> 组件直至 OneComponent 或 OtherComponent 加载完成
    <React.Suspense fallback={<Spinner />}>
      <div>
        {
          isIOS ? <OneComponent /> : <OtherComponent />>
        }
      </div>
    </React.Suspense>
  );
}
```
上面的代码示例中， OneComponent 和 OtherComponent 是两个比较大的组件，在ios环境下我们渲染 OneComponent，在非ios环境下渲染 OtherComponent，正常情况下两个组件只会被加载其中的一个，所以我们可以将代码分割出来，保证主js不会包括不需要用到的js。

在大多数情况下，我们也会将代码以路由为界限进行分割，来提升界面首次加载速度。