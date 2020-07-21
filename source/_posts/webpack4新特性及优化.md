---
title: webpack4新特性及优化
date: 2020-07-16 18:12:34
tags: [webpack]
---

## 前言

> webpack 是一个用于现代 JavaScript 应用程序的静态模块打包工具。当 webpack 处理应用程序时，它会在内部构建一个 依赖图(dependency graph)，此依赖图对应映射到项目所需的每个模块，并生成一个或多个 bundle。

本着能站在巨人肩膀上就站在巨人肩膀上的原则，为了避免繁杂的webpack配置，我们有Vue CLI和Create React App等优秀的脚手架工具帮助我们快速搭建项目。

在大多数项目中我们都可以通过脚手架完美的进行搭建项目，但是随着业务类型的变化，我们可能需要对项目结构、打包性能优化等等做一些改变这时候这些通用的脚手架可能就不太适合，所以我们需要了解webpack，编写出自己的一套webpack配置，需要的情况下搭建一套[自己的脚手架](https://yeoman.io/learning/index.html)。<!--more-->

目前`webpack5`还在[beta](https://github.com/webpack/webpack/tags)阶段，所以这里介绍`webpack4`。

## webpack4的一些新知识

### 1. 环境支持

在使用webpack4的时候，需要保证NodeJs版本>=8.9.4。

### 2. 零配置

从版本4开始，Webpack不需要任何配置也可使用，它有一组默认值。我们只需要保证我们有入口文件src/index.js就可以了。

### 3. 引入mode配置属性

> string = 'none' | 'development' | 'production'

mode有上面三种选项，默认值是production设置mode的方式有两种：

```javascript
module.exports = {
  mode: 'development'
};
```

或者从CLI参数中传递：
```javascript
webpack --mode=development
```

(1) 当我们把 mode 设置为 development 的时候，会将 DefinePlugin 中 process.env.NODE_ENV 的值设置为 development，启用 NamedChunksPlugin(以名称固化 chunk id)和 NamedModulesPlugin(以名称固化 module id)。

在默认情况下webpack会为我们的 module 和 chunk 维护一个自增id的list，当我们在开发的时候，经常会新增删除 module 或者 chunk，这时由于增删的原因导致id需要重排，因为这些id和名字会在最终的输出产物中使用，修改它们会导致文件hash的变化，即使这些文件使用的模块本身并没有改变，导致浏览器的缓存失效。这个时候 NamedModulesPlugin 和 NamedChunksPlugin 就派上了用场，这两个插件会把module的文件路径和chunk名称作为id，保证了不会生成不必要的hash文件。

(2) 当我们把 mode 设置为 production 的时候，会将 DefinePlugin 中 process.env.NODE_ENV 的值设置为 production。并启用以下插件功能：

* FlagDependencyUsagePlugin ：编译时标记被使用的依赖
* FlagIncludedChunksPlugin ：给每个 chunk 添加了 ids，用于判断避免加载不必要的 chunk
* ModuleConcatenationPlugin ：作用域提升(scope hosting),预编译功能,提升或者预编译所有模块到一个闭包中，提升代码在浏览器中的执行速度
* NoEmitOnErrorsPlugin ：在输出阶段时，遇到编译错误跳过
* OccurrenceOrderPlugin ：根据模块初始调用次数或者总调用次数排序（配置），这样在后面分配 ID 的时候常被调用 ID 就靠前
* SideEffectsFlagPlugin ：识别 package.json 或者 module.rules 的 sideEffects 标志（纯的 ES2015 模块)，安全地删除未用到且无副作用的的 export 导出
* UglifyJsPlugin ：删除未引用代码，并压缩

(3) 当我们设置 mode 为 none 是，将不使用任何默认优化选项。

### 插件和优化

在webpack4中新增了 optimization 配置项，一些默认插件由 optimization 配置替代了，如下：
* CommonsChunkPlugin废弃，由 optimization.splitChunks 和 optimization.runtimeChunk 替代，前者拆分代码，后者提取runtime代码。
* NoEmitOnErrorsPlugin 废弃，由 optimization.noEmitOnErrors 替代，生产环境默认开启。
* NamedModulesPlugin 废弃，由 optimization.namedModules 替代，生产环境默认开启。
* ModuleConcatenationPlugin 废弃，由 optimization.concatenateModules 替代，生产环境默认关闭。
* optimize.UglifyJsPlugin 废弃，由 optimization.minimize 替代，生产环境默认开启。

具体一些修改可以查看官网[To v4 from v3](https://webpack.docschina.org/migrate/4/#nodejs-v4)和[Optimization](https://webpack.js.org/configuration/optimization/#optimizationnamedchunks)。

在 optimization 配置项，提供了如下默认配置：

```javascript
optimization: {
    minimize: env === 'production' ? true : false, // 开发环境不压缩
    splitChunks: {
        chunks: "async", // 共有三个值可选：initial(初始模块)、async(按需加载模块)和all(全部模块)
        minSize: 30000, // 模块超过30k自动被抽离成公共模块
        minChunks: 1, // 模块被引用>=1次，便分割
        maxAsyncRequests: 5,  // 异步加载chunk的并发请求数量<=5
        maxInitialRequests: 3, // 一个入口并发加载的chunk数量<=3
        name: true, // 默认由模块名+hash命名，名称相同时多个模块将合并为1个，可以设置为function
        automaticNameDelimiter: '~', // 命名分隔符
        cacheGroups: { // 缓存组，会继承和覆盖splitChunks的配置
            default: { // 模块缓存规则，设置为false，默认缓存组将禁用
                minChunks: 2, // 模块被引用>=2次，拆分至vendors公共模块
                priority: -20, // 优先级
                reuseExistingChunk: true, // 默认使用已有的模块
            },
            vendors: {
                test: /[\\/]node_modules[\\/]/, // 表示默认拆分node_modules中的模块
                priority: -10
            }
        }
    }
}
```

其中需要重点关注的是 optimization.splitChunks，webpack4已经为我们做了上述的默认配置，如果我们需要定制化分割代码，就可以对配置项做一些改变。

**splitChunks.chunks**

splitChunks.chunks 有三个属性 initial、async、all：

* initial：优化非异步模块的复用性，如：

```javascript
import a from './a.js'
// or
const a = require('./a.js')。
```

* async：优化异步模块的复用性,如：

```javascript
import(/* webpackChunkName: "a" */ './a.js').then(a => {
  console.log(a)
})
```

* all：包含上述两种情况。

**splitChunks.cacheGroups**

使用 splitChunks.cacheGroups 可以自定义配置分割打包块。我们可以把代码分为四类：

(1) 基础组件库libs
它是构成我们项目必不可少的一些基础类库，比如React、React-Router、React-Redux、lodash等等等等。

(2) UI组件库
理论上 UI 组件库也可以放入 libs 中，但这里单独拿出来的原因是： 它实在是比较大，不管是 Element-UI还是Ant Design gizp 压缩完都可能要 200kb 左右，它可能比 libs 里面所有的库加起来还要大不少，而且 UI 组件库的更新频率也相对的比 libs 要更高一点。我们不时的会升级 UI 组件库来解决一些现有的 bugs 或使用它的一些新功能。所以建议将 UI 组件库也单独拆成一个包。

(3) 自定义组件/函数 commons
这类组件我们自己定义的一些使用比较高频的组件或者函数，由于它们的体积不会很大，它们都会被默认打包到到每一个懒加载页面的 chunk 中，这样会造成不少的浪费。你有十个页面引用了它，就会包重复打包十次。所以应该将那些被大量共用的组件单独打包成commons。

(4) 业务代码
这类chunk就是我们一般以模块或者路由为单位将代码动态引入，分割。

完整配置：
```javascript
splitChunks: {
  chunks: "all",
  cacheGroups: {
    libs: {
      name: "libs",
      test: /[\\/]node_modules[\\/]/,
      priority: 10,
      chunks: "initial" // 只打包初始时依赖的第三方
    },
    ui: {
      name: "ui", // 单独将 elementUI 拆包
      priority: 20, // 权重要大于 libs 和 app 不然会被打包进 libs 或者 app
      test: /[\\/]node_modules[\\/]antd[\\/]/
    },
    commons: {
      name: "commons",
      test: resolve("src/components"), // 可自定义拓展你的规则
      minChunks: 2, // 最小共用次数
      priority: 5,
      reuseExistingChunk: true
    }
  }
};
```

## 一些有用的webpack用法

### 1、每次打包前清空dist目录
安装依赖:

```javascript
npm install clean-webpack-plugin -D
```

```javascript
const { CleanWebpackPlugin } = require('clean-webpack-plugin');

module.exports = {
    //...
    plugins: [
        new CleanWebpackPlugin() 
    ]
}
```

### 2、url-loader进行图片、字体文件处理

1、安装依赖:

```javascript
npm install url-loader -D
```

2、在 webpack.config.js 中进行配置:
```javascript
module.exports = {
    //...
    modules: {
        rules: [
            {
                test: /\.(png|jpg|gif|jpeg|webp|svg|eot|ttf|woff|woff2)$/,
                use: [
                {
                    loader: 'url-loader',
                    options: {
                        limit: 10240, // 10K
                        esModule: false, // 否则，<img src={require('XXX.jpg')} /> 会出现 <img src=[Module Object] />
                        name: '[name]_[chunkhash:8].[ext]',
                        outputPath: 'assets',
                    }
                }
                ],
                exclude: /node_modules/,
            }
        ]
    }
}
```

### 2、前端模拟数据
1、安装依赖:

```javascript
npm install mocker-api -D
```

2、在项目中新建mock文件夹，新建 mocker.js.文件，文件如下:
```javascript
module.exports = {
    'GET /user': {name: 'sohu'},
    'POST /login/account': (req, res) => {
        const { password, username } = req.body
        if (password === 'sohu' && username === 'sohu') {
            return res.send({
                status: 'ok',
                code: 0,
                token: 'sdfsdfsdfdsf',
                data: { id: 1, name: 'sohu' }
            })
        } else {
            return res.send({ status: 'error', code: 403 })
        }
    }
}
```
3、修改webpack.config.js
```javascript
const apiMocker = require('mocker-api');
module.export = {
    //...
    devServer: {
        before(app){
            apiMocker(app, path.resolve('./mock/mocker.js'))
        }
    }
}
```

### 3、webpack-bundle-analyzer查看打包情况
1、安装依赖:

```javascript
npm install webpack-bundle-analyzer -D
```

2、修改webpack.config.js
```javascript
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;
module.exports = {
    //....
    plugins: [
        //...
        new BundleAnalyzerPlugin(),
    ]
}
```
使用`npm run build`构建后，打开`http://127.0.0.1:8888/`,可以看到像下面一样的打包结构图：
![打包结构图](/img/webpack4新特性及优化/morenfenge.png)

### 4、修改打包上传CDN流程
目前咱们的hui等等一些React项目上传CDN的流程是：运行一个NodeJS程序 => 删除dist目录 => 运行webpack打包 => 挂载资源 => 上传CDN，这个流程能很好的工作，但是代码有些繁杂，所以我们在做一些简化：
* 删除dist目录通过上述`clean-webpack-plugin`插件完成
* 运行webpack打包 和 挂载资源 步骤可以直接通过CLI完成，挂载路径通过`publicPath`配置：
```javascript
output: {
    publicPath: `${cdnProject}-${process.env.NODE_ENV}/`,
  }
```
* 上传CDN不变

所以我们的流程变成了：运行一个shell脚本 => 打包 => 上传CDN。流程控制用一个shell脚本控制：
```javascript
env=$1

echo 打包中...
cross-env NODE_ENV=$env  webpack --config webpack/build.js
echo 打包完成！

node server/uploadFile.js $env
```
