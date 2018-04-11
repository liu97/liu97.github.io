---
title: js之ajax的实现及封装
date: 2018-3-8 15:15:03
categories: Blogs
tags: [js,ajax]
---
今天在网上无意间看到ajax的实现，仔细一想，ajax好久没用了，只记得大概运用的流程，也不记得每个函数和属性的定义了，所以觉得还是写下来，以后再忘看起来也方便点。<!--more-->

## 什么是ajax？
AJAX = Asynchronous JavaScript and XML（异步的 JavaScript 和 XML）。
AJAX 不是新的编程语言，而是一种使用现有标准的新方法。
传统的网页（不使用 AJAX）如果需要更新内容，必需重载整个网页面，但是AJAX的出现，实现了在不重新加载整个页面的情况下，对网页的某部分进行更新，AJAX 是与服务器交换数据并更新部分网页的艺术。

## XMLHttpRequest对象
XMLHttpRequest 对象提供了对 HTTP 协议的完全的访问，包括做出 POST 和 HEAD 请求以及普通的 GET 请求的能力。XMLHttpRequest 可以同步或异步地返回 Web 服务器的响应，并且能够以文本或者一个 DOM 文档的形式返回内容。
所有现代浏览器 (IE7+、Firefox、Chrome、Safari 以及 Opera) 都内建了 XMLHttpRequest 对象:
> new XMLHttpRequest()

老版本的 Internet Explorer （IE5 和 IE6）使用 ActiveX 对象：
> new ActiveXObject("Microsoft.XMLHTTP")

**主要的属性：**
* 1.responseText:作为响应主题被返回的文本。
* 2.responseXML:如果响应的内容类型是"text/xml"或"application/xml",这个属性将保存包含着响应数据的XML Dom文档。如果非XML数据则为null。
* 3.status:响应的HTTP状态，若是200，则表示成功;304表示请求的资源并没有被修改，可以用浏览器中缓存的版本;404，表示为未找到。
* 4.statusText:HTTP状态的说明，在跨浏览器使用时不太可靠。
* 5.readyState属性有五个状态值:
> 0：是uninitialized，未初始化。已经创建了XMLHttpRequest对象但是未初始化。
1：是loading，send for request but not called .已经开始准备好要发送了。
2：是loaded, send called,headers and status are available。已经发送，但是还没有收到响应。
3：是interactive，downloading response,but responseText only partial set.正在接受响应，但是还不完整。
4：是completed，finish downloading.接受响应完毕。

**主要的方法：**
* 1.open
> open(method,url,async)：规定请求的类型、URL 以及是否异步处理请求。
method：请求的类型；GET 或 POST
url：文件在服务器上的位置
async：true（异步）或 false（同步）
* 2.send
> send(string): 将请求发送到服务器。
string：仅用于 POST 请求

## AJAX实现
前面说那么多，新手看的可能会有点晕，下面就是AJAX的代码实现：
获取XMLHttpRequest对象
```javascript
function createXHR(){
	if(typeof XMLHttpRequest != "undefined"){ //支持XMLHttpRequest
		return new XMLHttpRequest();
	}
	else if(typeof ActiveXObject != "undefined"){ //支持ActiveXObject
		var versions = ["MSXML2.XMLHttp.6.0","MSXML2.XMLHttp.3.0","MSXML2.XMLHttp"], i , len;
		for(i=0,len = versions.length; i<len;i++){
			try{
				new ActiveXObject(versions[i]);
				arguments.callee.activeXString = versions[i];
				break;
			} catch(e){
				//跳过
			}
		}
	}
	else{
		throw new Error("No XHR object avilable.");
	}
}
```
GET请求
get是最常见的请求，最常用语向服务器查询某些信息。必要时，可以将查询字符串参数追加到URL的末尾，类似于"example.php?name=liu97&qq=1139472029"。
```javascript
function addURLParam(url, name ,value){
	url += (url.indexOf("?") == -1 ? "?" : "&");
	url += encodeURLComponent(name) + "=" + encodeURLComponent(value);
	return url;
}
var url = "example.php";
url = addURLParam(url, "name", "liu97");
var xhr = createXHR();
xhr.onreadystatechange = function(){
	if(xhr.readyState == 4){
		if((xhr.status >=200 && xhr.status< 300) || xhr.status == 304){
			alert(xhr.responseText);
		}
		else{
			alert("Request was unsuccessful: "+xhr.status);
		}
	}
}
xhr.open("get",url,true);
xhr.send(null);
```

POST请求
使用频率仅次于get的是post请求，通常用于向服务器发送应该被保存的数据，下面是使用post模仿提交表单。
```javascript
var xhr = createXHR();
xhr.onreadystatechange = function(){
	if(xhr.readyState == 4){
		if((xhr.status >=200 && xhr.status< 300) || xhr.status == 304){
			alert(xhr.responseText);
		}
		else{
			alert("Request was unsuccessful: "+xhr.status);
		}
	}
}
xhr.open("post","example.php",true);
var form = document.getElementById("userInfo");
xhr.send(new FormData(form));
```

## AJAX封装
上面是分了get和post请求，每次请求就要写一次代码，索性来个封装，类似于jquery的$.ajax.
```javascript
var $={
	createXHR:function(){
		if(typeof XMLHttpRequest != "undefined"){ //支持XMLHttpRequest
			return new XMLHttpRequest();
		}
		else if(typeof ActiveXObject != "undefined"){ //支持ActiveXObject
			var versions = ["MSXML2.XMLHttp.6.0","MSXML2.XMLHttp.3.0","MSXML2.XMLHttp"], i , len;
			for(i=0,len = versions.length; i<len;i++){
				try{
					new ActiveXObject(versions[i]);
					arguments.callee.activeXString = versions[i];
					break;
				} catch(e){
					//跳过
				}
			}
		}
		else{
			throw new Error("No XHR object avilable.");
		}
	}
    /*传递参数对象，返回拼接之后的字符串*/
    /*{‘name’:’jack,’age’:20}=>  name=jack&age=20&*/
    getParmeter:function(data){
        var result="";
        for(var key in data){
            result=result+key+"="+data[key]+"&";
        }
        /*将结果最后多余的&截取掉*/
        return result.slice(0,-1);
    },
    /*实现ajax请求*/
    ajax:function(obj){
        /*1.判断有没有传递参数，同时参数是否是一个对象*/
        if(obj==null || typeof obj!="object"){
            return false;
        }
        /*2.获取请求类型,如果没有传递请求方式，那么默认为get*/
        var type=obj.type || 'get';
        /*3.获取请求的url  location.pathname:就是指当前请求发起的路径*/
        var url=obj.url || location.pathname;
        /*4.获取请求传递的参数*/
        var data=obj.data || {};
        /*4.1获取拼接之后的参数*/
        data=this.getParmeter(data);
        /*5.获取请求传递的回调函数*/
        var success=obj.success || function(){};
        
        /*es6语法obj = Object.assign({type:"get",url:"location.pathname",data:"{}"})*/

        /*6:开始发起异步请求*/
        /*6.1:创建异步对象*/
        var xhr=this.createXHR();
        /*6.2:设置请求行,判断请求类型，以此决定是否需要拼接参数到url*/
        if(type=='get'){
            url=url+"?"+data;
            /*重置参数，为post请求简化处理*/
            data=null;
        }
        xhr.open(type,url);
        /*6.2:设置请求头:判断请求方式，如果是post则进行设置*/
        if(type=="post"){
            xhr.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
        }
        /*6.3:设置请求体,post请求则需要传递参数*/
        xhr.send(data);

        /*7.处理响应*/
        xhr.onreadystatechange=function(){
            /*8.判断响应是否成功*/
            if(xhr.status==200 && xhr.readyState==4){
                /*客户端可用的响应结果*/
                var result=null;
                /*9.获取响应头Content-Type ---类型是字符串*/
                var grc=xhr.getResponseHeader("Content-Type");
                /*10.根据Content-Type类型来判断如何进行解析*/
                if(grc.indexOf("json") != -1){
                    /*转换为js对象*/
                    result=JSON.parse(xhr.responseText);
                }
                else if(grc.indexOf("xml") != -1){
                    result=xhr.responseXML;
                }
                else{
                    result=xhr.responseText;
                }
                /*11.拿到数据，调用客户端传递过来的回调函数*/
                success(result);
            }
        }

    }
};
```
调用方式与jquery类似：
```javascript
$.ajax({
    url:'',
    type:'',
    data: {},
    success:function(result){
        //code...
    }
});
```
[跨域请求 戳阮一峰老师的文章](http://www.ruanyifeng.com/blog/2016/04/cors.html)
## 感谢链接
[AJAX的实现原理以及封装](http://blog.csdn.net/u011032902/article/details/54728710)
[谈谈Ajax原理实现过程](http://www.jb51.net/article/74357.htm)

