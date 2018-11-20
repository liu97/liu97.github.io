---
title: 那些年webpack项目探的坑
date: 2018-08-29 09:18:04
categories: Blogs
tags: [webpack,前端]
---
## 前言
`webpack`是当下最热门的前端资源模块化管理和打包工具。但是每次使用`webpack`管理项目的时候都会碰到一些坑，有的坑通过下面的配置就不会出现了，就不记录在这，有的坑可能下次还会遇到就记录下来，好方便下次碰到的时候查阅。<!--more-->

## 不支持es6语法
为了在项目中使用`es6`语法，需要安装`babel`，`babel`是一个广泛使用的`ES6`转码器，可以将`ES6`代码转为`ES5`代码，从而在现有环境执行。
**babel常见转义器的功能**
> babel-core: 如果某些代码需要调用Babel的API进行转码，就要使用`babel-core`模块
> babel-loader: 执行转义的核心包
> babel-preset-env: 包括了所有的`babel-preset-es`和`babel-preset-stage-4`，但是不包括`babel-polyfill`和`babel-react` 
> babel-polyfill: 转换`es6`新的API，`babel`默认只转换语法,而不转换新的API
> babel-preset-react: 转义`react`的`jsx`语法
> babel-plugin-react-transform: 动态修改`Component`，代替`react-hot-loader`的插件

**转换器的用法**
* `babel-core`、`babel-loader`、`babel-preset-react`及`babel-plugin-react-transform`只需直接安装
> npm install --save-dev babel-core babel-loader babel-preset-react babel-plugin-react-transform


* `babel-preset-env`安装后需要配置 `.babelrc`
```
{
  "presets": [
    "react",
    ["env", {
      "modules": false,
      "targets": {
        "browsers": ["last 2 versions", "ie >= 9"]
      },
      "useBuiltIns": true,
      "debug": true
    }]
  ],
  "plugins": []
}
```
* `babel-polyfill`配合`babel-preset-env`的`useBuiltIns`属性配置需要兼容的浏览器列表。然后在`webpack`入口文件中使用`import/require`引入`polyfill`, 如`import 'babel-polyfill'`
具体使用可查看[这里babel-preset-env](https://zhuanlan.zhihu.com/p/29506685)和[这里babel-polyfill](https://www.jianshu.com/p/3b27dfc6785c)

## plugins数组存在空字符串
> TypeError: Falsy value found in plugins

![plugins数组存在空字符串](/img/那些年webpack项目探的坑/1.png)

只需将`.babelrc`中`plugins`中的空字符串去掉

## 不支持修饰器decorator
![plugins数组存在空字符串](/img/那些年webpack项目探的坑/2.png)

需要安装`transform-decorators-legacy`
> npm install –save-dev babel-plugin-transform-decorators-legacy

安装完后在.babelrc的`plugins`数组填写：
> "plugins": [ "transform-decorators-legacy" ]

## react.js内使用箭头函数报错
![plugins数组存在空字符串](/img/那些年webpack项目探的坑/3.png)

由于babel-preset-env只包含了babel-preset-env和babel-preset-stage-4,而要stage-2支持该语法，索性就装个babel-preset-stage-0解决问题。
> npm install –save-dev babel-preset-stage-0

然后再`.babelrc`的`presets`的数组里添加`stage-0`。
```
"presets": [
  "react",
  ["env", {
    "modules": false,
    "targets": {
      "browsers": ["last 2 versions", "ie >= 9"]
    },
    "useBuiltIns": true,
    "debug": true
  }],
  "stage-0"
],
```
*注意： stage-0应该写在env后面*

## css和less打包报错
> ERROR in ./app/index.less ReferenceError: window is not defined

![plugins数组存在空字符串](/img/那些年webpack项目探的坑/4.png)
使用webpack4的extract-text-webpack-plugin插件提取单独打包css文件时，use里的顺序问题,只需按下面的顺序即可：
```
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
module.exports = {
   module: {
    rules: [
      {
        test: /\.css$/,
        use:["style-loader",MiniCssExtractPlugin.loader,"css-loader","postcss-loader"],
      },
      {
        test: /\.less$/,
        use:["style-loader",MiniCssExtractPlugin.loader,"css-loader","postcss-loader","less-loader"],
      }
    ]
  plugins: [
    new MiniCssExtractPlugin({
        // Options similar to the same options in webpackOptions.output
        // both options are optional
        filename: "[name].[chunkhash:8].css",
        chunkFilename: "[id].css"
    })
    ],
}
```