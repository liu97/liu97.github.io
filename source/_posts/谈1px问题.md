---
title: 谈1px问题
date: 2020-09-15 09:07:05
categories: Blogs
tags: [js]
---
## 前言
在网上一搜1px问题，大片大片的文章会弹出来，都是先讲一遍DPR的概念，然后就说需要将1px转换成真正的1物理像素（device pixels），在我的理解里只要在这个问题上谈到DPR，那他就是还没有真正理解css中1px与物理像素（device pixels）的关系。<!--more-->

在我的[这篇文章](https://liu97.github.io/2019/09/21/%E5%83%8F%E7%B4%A0%E4%B8%8E%E8%AE%BE%E5%A4%87%E9%97%B4%E7%9A%84%E7%88%B1%E6%81%A8%E6%83%85%E4%BB%87%E4%BA%8C/)有讲到，其实css中的1px就是设备独立像素。
> css中px是网页中的长度单位，由于不同的物理设备的物理像素的大小是不一样的，所以css认为浏览器应该对css中的像素进行调节，使得浏览器中 1css像素的大小在不同物理设备上看上去大小总是差不多 ，目的是为了保证阅读体验一致。为了达到这一点浏览器可以直接按照设备的物理像素大小进行换算，而css规范中使用参考像素来进行换算。<br/>
>1参考像素即为从一臂之遥看解析度为96DPI的设备输出（即1英寸96点）时，1点（即1/96英寸）的视角。它并不是1/96英寸长度，而是从一臂之遥的距离处看解析度为96DPI的设备输出一单位（即1/96英寸）时视线与水平线的夹角。通常认为常人臂长为28英寸，所以它的视角是:(1/96)in / (28in 2 PI / 360deg) = 0.0213度。<br/>
>由于css像素是一个视角单位，所以在真正实现时，为了方便基本都是根据设备像素换算的。浏览器根据硬件设备能够直接获取css像素，而具体的值可以认为同等于上面Android设备中的dp和ios设备中的pt。

在上面的理论之下，其实本质上是没有1px的问题，在css中给边框设置为1px，那就是1设备独立像素，看起来也是正常的，并非其他文章中所说的看起来很粗。那为什么网上说有1px的问题呢？

## 真正原因
在我们将`visual viewport`、`layout viewport`和`ideal viewport`设置为一样后，且`ideal viewport`等于375px（设备独立像素），所以我们在开发的时候css中的1px就是相对于`ideal viewport`中的1px，当我们的设计稿是750px的时候，设计稿中如果出现相对于750px的1px，那在我们的css中就是0.5px，所以当我们将css设置为1px时相当于设计稿中的2px，这才是出现1px问题的真正来源。

## 解决办法
网上有好几种解决办法，我这里推荐一种：tranform加伪类标签
```css
.border-onepx{
  position: relative;
  &::before{
    content: "";
    position: absolute;
    left: 0;
    top: 0;
    border:1px solid #ccc;
    color: #ccc;
    height: 200%; // 按照设计稿和设备独立像素来设置
    width: 200%; // 按照设计稿和设备独立像素来设置
    transform-origin: left top;
    transform: scale(0.5); // 按照设计稿和设备独立像素来设置
    box-sizing: border-box;
    pointer-events: none;
  }
}
```