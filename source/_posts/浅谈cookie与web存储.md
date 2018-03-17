---
title: 浅谈cookie、localStorage与sessionStorage
date: 2018-03-17 20:31:10
categories: Blogs
tags: [js,html5]
---
Cookie的作用是与服务器进行交互，作为HTTP规范的一部分而存在，而Web Storage仅仅是为了在本地“存储”数据而生<!--more-->
## cookie
**了解cookie**
cookie 是存储于访问者的计算机中的变量。每当同一台计算机通过浏览器请求某个页面时，就会发送这个 cookie。你可以使用 JavaScript 来创建和取回 cookie 的值。它的主要用途有保存登录信息，比如你登录某个网站市场可以看到“记住密码”，这通常就是通过在 Cookie 中存入一段辨别用户身份的数据来实现的。
> 1.要表示唯一的一个cookie值需要：name、domain、path。
2.一个cookie就是一个小型的文本文件。
3.虽然cookie保存在浏览器端，但是一般是在服务器端设置的。
4.可以在HTTP返回体里，通过设置Set-Cookie来告诉浏览器端所要存储的cookie。
5.用来保存客户浏览器请求服务器页面的请求信息。

**cookie相关字段的说明**
    
> * 名称：一个唯一确定cookie的名称。cookie名称是不区分大小写的。cookie的名称必须是经过URL编码的。
* 值：储存在cookie中的字符串值。值必须被URL编码。
* 域：cookie对于哪个域是有效的。如果设置为“.google.com”，则所有以“google.com”结尾的域名都可以访问该Cookie。注意第一个字符必须为“.”。如果没有明确设定，那么这个域会被认作来自设置cookie的那个域。
* 路径：对于指定域中的那个路径，应该向服务器发送cookie。如果设置为“/sessionWeb/”，则只有contextPath为“/sessionWeb”的程序可以访问该Cookie。如果设置为“/”，则本域名下contextPath都可以访问该Cookie。注意最后一个字符必须为“/”。
* 失效时间：表示cookie何时应该被删除的时间戳（也就是，何时应该停止向服务器发送这个cookie）。默认情况下，浏览器会话结束时即将所有cookie删除；不过也可以自己设置删除时间。这个值是个GMT格式的日期（Wdy,DD-Mon-YYYY HH:MM:SSGMT），用于指定应该删除cookie的准确时间。因此，cookie可在浏览器关闭后依然保存在用户的机器上。如果你设置的失效日期是个以前的时间，则cookie会被立刻删除。
* 安全标志：指定后，cookie只有在使用SSL连接的时候才发送到服务器。例如，cookie信息只能发送给https://www.baidu.com, 而http://www.baidu.com 的请求则不能发送cookie。

**cookie的应用场景**
    
> * 简单来说，Cookie就是服务器暂存放在你的电脑里的资料（.txt格式的文本文件），好让服务器用来辨认你的计算机。当你在浏览网站的时候，Web服务器会先送一小小资料放在你的计算机上，Cookie 会把你在网站上所打的文字或是一些选择都记录下来。当下次你再访问同一个网站，Web服务器会先看看有没有它上次留下的Cookie资料，有的话，就会依据Cookie里的内容来判断使用者，送出特定的网页内容给你。
* 网站可以利用cookie跟踪统计用户访问该网站的习惯，比如什么时间访问，访问了哪些页面，在每个网页的停留时间等。利用这些信息，一方面是可以为用户提供个性化的服务，另一方面，也可以作为了解所有用户行为的工具，对于网站经营策略的改进有一定参考价值。
* 目前Cookie最广泛的是记录用户登录信息，这样下次访问时可以不需要输入自己的用户名、密码了——当然这种方便也存在用户信息泄密的问题，尤其在多个用户共用一台电脑时很容易出现这样的问题。

**设置／修改 cookie**
```javascript
//直接复制 【直接复制不是覆盖，而是追加】
document.cookie = 'name=value;'

//封装setCookie方法
//setCookie 首先对name和value进行编码
function setCookie(name,value,expires,path,domain,secure){

    var cookie = encodeURIComponent(name)+ '=' +encodeURIComponent(value);
    //注意分号后面要有空格
    //后面的4个参数是可选的，所以用if判断并追加
    if(expires){ //过期时间
        cookie +='; expires='+expires.toGMTString();
    }
    if(path){ //路径
        cookie += '; path='+path;
    }
    if(domain){ //域
        cookie += '; domain='+domain;
    }
    if(secure){ //安全标志
        cookie += '; secure='+secure;
    }
    document.cookie = cookie;
}
```
**删除cookie**
> 输入参数为name、path、domain 这3个是唯一标识cookie的,将max-age设置为0，就可以立即删除了.

```javascript
function remove(name,domain,path){
    document.cookie = 'name='+name
                    +'; domain='+domain
                    +'; path='+path
                    +'; max-age=0';
}
```

**cookie缺点**
> * Cookie数量和长度的限制。IE6或更低版本每个domian下最多20个cookie，IE7和之后的版本最多可以有 50个cookie，Firefox最多50个cookie，chrome和Safari没有做硬性限制，每个cookie长度不能超过4KB，否则会被截掉。
* IE和Opera 会清理近期最少使用的cookie，Firefox会随机清理cookie。这就导致不能永久储存信息。
* 安全性问题。如果cookie被人拦截了，那人就可以取得所有的session信息。即使加密也与事无补，因为拦截者并不需要知道cookie的意义，他只要原样转发cookie就可以达到目的了。
* 并且每次你请求一个新的页面的时候，cookie只要满足作用域和作用路径，Cookie都会被发送过去，这样无形中浪费了带宽。

## 本地储存

**了解本地存储**
使用HTML5可以在本地存储用户的浏览数据。
早些时候,本地存储使用的是 cookie。但是Web 存储需要更加的安全与快速. 这些数据不会被保存在服务器上，但是这些数据只用于用户请求网站数据上.它也可以存储大量的数据，而不影响网站的性能.
数据以 键/值 对存在, web网页的数据只允许该网页访问使用。

**localStorage && sessionStorage**
> * localStorage用于持久化的本地存储，除非主动删除数据，否则数据是永远不会过期的。
* sessionStorage用于本地存储一个会话（session）中的数据，这些数据只有在同一个会话中的页面才能访问并且当会话结束后数据也随之销毁。因此sessionStorage不是一种持久化的本地存储，仅仅是会话级别的存储。也就是说只要这个浏览器窗口没有关闭，即使刷新页面或进入同源另一页面，数据仍然存在。关闭窗口后，sessionStorage即被销毁。
* 不同浏览器无法共享localStorage或sessionStorage中的信息。相同浏览器的不同页面间可以共享相同的 localStorage（页面属于相同域名和端口），但是不同页面或标签页间无法共享sessionStorage的信息。这里需要注意的是，页面及标 签页仅指顶级窗口，如果一个标签页包含多个iframe标签且他们属于同源页面，那么他们之间是可以共享sessionStorage的。
* localStorage也受同源策略的限制。
* localStorage和sessionStorage都具有相同的操作方法，如setItem,getItem,removeItem,clear等方法，不像cookie需要前端开发者自己封装setCookie，getCookie。

**应用场景**
> * localStorage可以用于存储该浏览器对该页面的访问次数，当然，如果换个浏览器，这个次数就重新开始计数了。还可以用来存储一些固定不变的页面信息，这样就不需要每次都重新加载了，这个值也可以进行覆盖。
* sessionStorage 非常适合SPA(单页应用程序)，可以方便在各业务模块进行传值。

**localStorage和sessionStorage操作**
localStorage和sessionStorage都具有相同的操作方法，例如setItem、getItem和removeItem等
1.setItem存储value
> localStorage.setItem("site", "js8.in");

2.getItem获取value
> var site = localStorage.getItem("site");

3.removeItem删除key
> localStorage.removeItem("site");

4.clear清除所有的key/value
> localStorage.clear();

5.其他操作方法：点操作和[ ]
> var storage = window.localStorage; 
storage.key1 = "hello"; 
storage["key2"] = "world"; 
console.log(storage.key1); 
console.log(storage["key2"]);

## 三者的异同
| 特性 | Cookie   |  localStorage  | sessionStorage |
| :----: | :----:  | :----:  | :----: |
| 数据的生命期 | 一般由服务器生成，可设置失效时间。如果在浏览器端生成Cookie，默认是关闭浏览器后失效 |   除非被清除，否则永久保存    | 仅在当前会话下有效，关闭页面或浏览器后被清除 |
| 存放数据大小 |  4K左右  |   一般为5MB | 一般为5MB |
| 与服务器端通信 |   每次都会携带在HTTP头中，如果使用cookie保存过多数据会带来性能问题    |  仅在客户端（即浏览器）中保存，不参与和服务器的通信  | 仅在客户端（即浏览器）中保存，不参与和服务器的通信|
| 易用性 | 需要程序员自己封装，源生的Cookie接口不友好 | 源生接口可以接受，亦可再次封装来对Object和Array有更好的支持 | 源生接口可以接受，亦可再次封装来对Object和Array有更好的支持 |

## 感谢链接
[cookie、sessionStorage、localStorage 详解及应用场景](https://segmentfault.com/a/1190000010400892)
[详说 Cookie, LocalStorage 与 SessionStorage](https://segmentfault.com/a/1190000002723469)
[localStorage和sessionStorage区别](https://www.cnblogs.com/tylerdonet/p/4833681.html)