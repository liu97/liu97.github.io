---
title: Hexo伪自动部署
date: 2017-07-02 20:50:38
categories: Blogs
tags: [hexo]
---
上次初步学习了用[hexo搭建博客](https://liu97.github.io/2017/05/02/%E5%88%9D%E5%B0%9Dhexo%E6%90%AD%E5%BB%BA%E5%8D%9A%E5%AE%A2/)，但是每次修改或者增加文章后都要执行git add、git commit、git push、hexo d -g 。。。感觉很繁琐,于是我想到了shell脚本，嘿嘿。<!--more-->

## 创建脚本文件

我们在本机博客根目录下创建一个脚本文件，比如叫push.sh。

## 一步完成所有操作

接下来我们编写脚本内容，将我们写完博客后所要做的操作用脚本一步完成，以下为脚本内容：

	#确定当前目录为hexo工作根目录
	echo  -e "\033[32;49;1m [正在提交新文章]"
	git  add  .
	git  commit  -am "Update Docs"
	echo -e "\033[32;49;1m 提交成功，正在推送至远程仓库...\033[39;49;0m"
	git  push origin blog-source
	echo -e  "\033[32;49;1m 源文件推送成功...\033[39;49;0m"
	echo  -e  "\033[32;49;1m 正在生成静态页面...\033[39;49;0m"
	hexo g
	echo -e "\033[32;49;1m 正在推送静态页面...\033[39;49;0m"
	hexo d
	echo  -e "\033[32;49;1m 全部搞定！！！\033[39;49;0m"

## 写完博客我们要做的事

保存博客，双击push.sh脚本文件，等脚本文件运行完成后，去浏览器看你的博客吧！
