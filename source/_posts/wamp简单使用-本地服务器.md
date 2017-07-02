---
title: wamp简单使用-本地服务器
date: 2017-05-11 23:58:11
categories: Blogs
tags: [wamp]
---
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;wamp是Windows下的Apache+Mysql/MariaDB+Perl/PHP/Python，一组常用来搭建动态网站或者服务器的开源软件，本身都是各自独立的程序，但是因为常被放在一起使用，拥有了越来越高的兼容度，共同组成了一个强大的Web应用程序平台。<!--more-->
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;在大二上学期的时候学过一点点PHP，慕课老师教我们怎么用wamp，当时跟着老师一步一步的操作过来，偶尔出现点问题百度也能解决问题。这次还是在慕课学习vue，由于编写程序时会有跨域情况，所以准备在本地服务器上运行vue项目。但是从上次学习操作wamp已经很久了，根本不记得怎么用，所以又看了一遍PHP老师的教程。知识不用就会忘，所以今天熬夜想把wamp简单操作记下来。

*wamp服务控制面板就不介绍了，一目了然*

> 自定义网站根目录

- 用编辑器打开D:\wamp\bin\apache\apache2.4.9\conf\httpd.conf（软件wamp目录下）
- ctrl+f查找documentroot，将“D:/wamp/www”改成想要当网站根目录的路径（类似“F:/webpage/wamp/”）

![documentroot](/img/wamp/wamp1.png)

- 往下找到 < directory > 将路径改成上面一样

![documentroot](/img/wamp/wamp2.png)

> 更改控制面板网站根目录

- 用编辑器打开D:\wamp\wampmanager.ini（软件wamp目录下）
- ctrl+f查找menu.left，将FileName改成刚刚设置的根目录路径(注意看清是哪一行的FileName)

![documentroot](/img/wamp/wamp3.png)

- 用编辑器打开D:\wamp\wampmanager.tpl（软件wamp目录下）同上一步操作


> 允许其他主机地址访问服务器资源

- 用编辑器打开D:\wamp\bin\apache\apache2.4.9\conf\httpd.conf（软件wamp目录下）
- ctrl+f查找Directory，将Deny from all改成Allow from all,表示允许

![documentroot](/img/wamp/wamp4.png)

> 自定义端口号

*由于服务器端口号有可能和别的产生冲突，可自行修改服务器端口号*
- 用编辑器打开D:\wamp\bin\apache\apache2.4.9\conf\httpd.conf（软件wamp目录下）
- ctrl+f查找listen，后面的数字就是端口号，可以改成自己想要的规范端口号

![documentroot](/img/wamp/wamp5.png)

- ctrl+f查找ServerName localhost,将后面端口号改成刚刚修改后的端口号

![documentroot](/img/wamp/wamp6.png)

> 友情提示

- 每次修改了配置文件后要重启wamp，否则当前看不到修改的效果




