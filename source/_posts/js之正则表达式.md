---
title: js之正则表达式
date: 2018-06-13 09:19:59
categories: Blogs
tags: [js]
---
## 前言
记得大一的时候学js基础知识就学到了正则，刚学到感觉正则真的是无比的强大，看似很难的匹配问题、查找问题，通过正则可以很简单的解决。当时学的时候把基本的正则规则都搞明白了，这得多谢智能社的blue老师，blue老师讲的通俗易懂。但是由于平时用的不多，导致经常会忘掉正则的用法，加上今天这次的学习可能算第五次学习正则基础知识了，今天想把正则的基础知识概括一下，以后用的时候就不用搜索或者看视频了。<!--more-->

## 正则基础知识
### 字符类匹配
> […] 查找方括号之间的任何字符
> [^…] 查找任何不在方括号之间的字符
> [a-z] 查找任何从小写 a 到小写 z 的字符
> [A-Z] 查找任何从大写 A 到大写 Z 的字符
> [A-z] 查找任何从大写 A 到小写 z 的字符
> . 查找单个字符，除了换行和行结束符
> \w 查找英文、数字、下划线，等价于[a-zA-Z0-9_]
> \W 查找非\w，等价于[^a-zA-Z0-9_]
> \s 查找空白字符
> \S 查找非空白字符
> \d 查找数字，等价于[0-9]
> \D 查找非数字字符，等价于[^0-9]
> \b 匹配单词边界
> \r 查找回车符
> \t 查找制表符
> \0 查找 NULL 字符
> \n 查找换行符

### 重复字符匹配
> {n,m} 匹配前一项至少n次，但不能超过m次
> {n,} 匹配前一项n次或更多次
> {n} 匹配前一项n次
> n? 匹配前一项0次或者1次，也就是说前一项是可选的，等价于{0，1}
> n+ 匹配前一项1次或多次，等价于{1，}
> n* 匹配前一项0次或多次，等价于{0，}
> n$ 匹配任何结尾为 n 的字符串
> ^n 匹配任何开头为 n 的字符串
> ?=n 匹配任何其后紧接指定字符串 n 的字符串
> ?!n 匹配任何其后没有紧接指定字符串 n 的字符串

## 字符串操作

### search函数
search基础的操作是在字符串a里查找是否存在另一个字符串b
。如果存在，输出b在a的所在位置，与indexOf的功能相同。用法：
```javascript
'aaabb'.search('bb')   // 3
'aaabb'.indexOf('bb')  // 3
```
既然search和indexOf功能一样，为什么要提供两个查找方法呢，事实上search()的参数是字符串或正则表达式，而indexOf()的参数只是普通字符串。indexOf()是比search()更加底层的方法。如果只是对一个具体字符串来查找，那么使用indexOf()的系统资源消耗更小，效率更高。那么知道了，search还有匹配正则的功能：
```javascript
'aaabb'.search(/.b/)   // 2
```
这就发挥正则的作用啦，这个表达式匹配的是'ab',所以输出的是2。这就是search的内容啦，search的作用依靠正则后会变得很强大。

### match函数
把匹配的东西全提取出来。这个方法的行为在很大程度上有赖于是否具有标志g，如果没有标志g，那么match()方法就只能在stringObject中执行一次匹配，如果没有找到任何匹配的文本，match()将返回 null，否则，它将返回一个类数组对象，其中存放了与它找到的匹配文本有关的信息。如果有标志g，没匹配到返回null，匹配到的话返回所有匹配成功的参数组成的数组。用法：
```javascript
'a1a2a3'.match(/ass\d/g) // null
'a1a2a3'.match(/a\d/)   // ["a1", index: 0, input: "a1a2a3", groups: undefined]
'a1a2a3'.match(/a\d/g)  // ["a1", "a2", "a3"]
```

### replace函数
在字符串中用一些字符替换另一些字符，或替换一个与正则表达式匹配的子串，返回一个新的字符串。用法：
```javascript
'操,去你妈的'.replace(/操|你妈的/g,'*')   //"*,去*" 
```
这就是常见的敏感词过滤啦。

### split函数
返回分割后各部分组成的数组。用法：
```javascript
'js,node.js,，editor.md,  ,html5'.split(/[,，\s]+/g)  // ["js", "node.js", "editor.md", "html5"]
```
通过对','、'，'、'\s'的中的任意一个匹配多次对字符串分割，分割后提取重要字符串组成数组。

### test函数
检索字符串中指定的值。返回 true 或 false。 如果正则表达式带有g修饰符，则每一次test方法都从上一次匹配结束的位置开始匹配。用法：
```javascript
var reg = /abc/g;
var str = "123abc456abc";
console.log(reg.lastIndex);//0
console.log(reg.test(str));//true
console.log(reg.lastIndex);//6
console.log(reg.test(str));//true
console.log(reg.lastIndex);//12
console.log(reg.test(str));//false
```

## 正则表达式的应用
### 过滤html标签
```javascript
let rhtml = `<head>
 <meta charset="utf-8">
 <meta http-equiv="X-UA-Compatible" content="IE=edge">
 <title>从url中提取子域名</title>
</head>`;
let fhtml = rhtml.replace(/<[^<>]*>|\n|\s/g,'');
console.log(fhtml);  // "从url中提取子域名"
```

### 匹配邮箱
```javascript
let reg = /^\w+\@+[0-9a-zA-Z]+\.(com|com.cn|edu|hk|cn|net)$/;
reg.test('1139012329@qq.com') // true
reg.test('sasa@') //false
```

## 感谢链接
[js正则表达式学习和总结(必看篇)](https://www.jb51.net/article/97901.htm)