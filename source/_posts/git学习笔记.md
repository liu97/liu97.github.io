---
title: git学习笔记
categories: Blogs
tags: [git]
---



知识学了不用就会忘，忘了又得从头开始学，我学习git就是这样，学了一遍很久没用又忘了，所以想着把git的一些常用的知识点记下来，下次忘了就可以浏览一下，就没必要再去网上找各种学习资源啦。<!--more-->

本次笔记主要摘自[廖雪峰老师的网站](https://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000)
## 常用命令

### 1.git仓库创建
> git init

### 2.查看当前状态
> git status

### 3.把文件添加到缓存区
> git add file

### 4.把暂存区的所有内容提交到当前分支
> git commit -m "本次提交的说明"

### 5.显示从最近到最远的提交日志
> git log

## 时光机穿梭

### 1.回退到以前版本
> git reset --hard 版本

用git log可以查看提交历史，以便确定要回退到哪个版本
用git reflog查看命令历史，以便确定要回到未来的哪个版本

### 2.文件区别
> git diff -- file *是工作区(work dict)和暂存区(stage)的比较*
git diff --cached file  *是暂存区(stage)和分支(master)的比较*
git diff HEAD -- file  *命令可以查看工作区和版本库里面最新版本的区别*

### 3.撤销修改
> git checkout -- file

命令git checkout意思就是，把readme.txt文件在工作区的修改全部撤销，这里有两种情况：
一种是readme.txt自修改后还没有被放到暂存区，现在，撤销修改就回到和版本库一模一样的状态；
一种是readme.txt已经添加到暂存区后，又作了修改，现在，撤销修改就回到添加到暂存区后的状态。
总之，就是让这个文件回到最近一次git commit或git add时的状态。

### 4.把暂存区的修改回退到工作区
> git reset HEAD file

### 5.从版本库中删除文件
> git rm file

## 远程仓库

### 1.关联一个远程库
> git remote add origin git@server-name:path/repo-name.git

### 2.第一次推送master分支的所有内容
> git push -u origin master  第一次推送才需要-u

### 3.克隆一个本地库
> git clone git@github.com:michaelliao/gitskills.git

## 分支

### 1.创建分支
> git branch 分支

### 2.切换到分支
> git checkout 分支

### 3.查看当前分支
> git branch

### 4.合并分支
> git merge 分支

### 5.删除分支
> git branch -d 分支