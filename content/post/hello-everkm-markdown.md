---
title: 道盒 Markdown 示例
date: 2023-08-16
tags: ["demo", "markdown"]
slug: hello-everkm-markdown
weight: 99
---

{id="this-page"}
*本页目录*

[TOC]

{pa=1em corner=0.2em bgcolor=gold}
本页面仅作效果展示，格式文档请见[道盒发布](https://publish.everkm.cn/guide/everkm-markdown.html), 完整源文件请见 [github](https://raw.githubusercontent.com/everkm/theme-yilog/master/content/post/hello-everkm-markdown.md)。


# 一级标题
## 二级标题
### 三级标题
#### 四级标题
##### 五级标题
###### 六级标题

```md
# 一级标题
## 二级标题
### 三级标题
#### 四级标题
##### 五级标题
###### 六级标题
```

---

# 段落

段落之间由两次回车换行完成。一次回车换行仅用于分割文字，在前端表现上没有任何效果。连续两次换行会形成段落。  
一次换行之前敲入两个空格，前端的表现为段落内换行，也称作软换行。实际效果见本行。

```md
段落之间由两次回车换行完成。一次回车换行仅用于分割文字，在前端表现上没有任何效果。连续两次换行会形成段落。  
一次换行之前敲入两个空格，前端的表现为段落内换行，也称作软换行。实际效果见本行。
```

---


# 列表

* 无序列表1
* 无序列表2
* 无序列表3

- 无序列表方式2
- 无序列表方式2
- 无序列表方式2

1. 有序列表1
1. 有序列表2
1. 有序列表3
1. 可以顺序标号，或者全部用1
    最终渲染时会自动矫正编号。
    如果前面带有缩进，会自动归为上个列表项的范围。


- 多级列表
    - 多级列表
    - 多级列表
        - 多级列表
        - 多级列表
            - 多级列表
            - 多级列表
                - 多级列表
                - 多级列表
- 多级列表
- 多级列表


1. 多级列表
    1. 多级列表
    1. 多级列表
    1. 多级列表
        1. 多级列表
        1. 多级列表
        1. 多级列表
            1. 多级列表
            1. 多级列表
                1. 多级列表
                1. 多级列表
1. 多级列表
1. 多级列表


```md
* 无序列表1
* 无序列表2
* 无序列表3

- 无序列表方式2
- 无序列表方式2
- 无序列表方式2

1. 有序列表1
1. 有序列表2
1. 有序列表3
1. 可以顺序标号，或者全部用1
    最终渲染时会自动矫正编号。
    如果前面带有缩进，会自动归为上个列表项的范围。


- 1 多级列表
    - 1.1 多级列表
    - 1.2 多级列表
        - 1.2 多级列表
        - 1.2 多级列表
- 2 多级列表
- 3 多级列表
```

---


# 强调

强调，又叫做斜体，使用 *1个星号* 包裹。

重点强调，又叫做粗体，使用 **2个星号** 包裹。

组合强调，又叫粗斜体，使用 ***3个星号*** 包裹。


```md
强调，又叫做斜体，使用 *1个星号* 包裹。

重点强调，又叫做粗体，使用 **2个星号** 包裹。

组合强调，又叫粗斜体，使用 ***3个星号*** 包裹。
```

---




# 链接

[内嵌式链接](https://note.everkm.cn)

[带标题的内嵌式链接](https://note.everkm.cn "道盒笔记")

[引用式链接][arbitrary case-insensitive reference text]

或者空着什么都不写 [link text itself], 引用链接的地址放在后面。

[link text itself]: https://note.everkm.cn
[arbitrary case-insensitive reference text]: https://note.everkm.cn


```md
[内嵌式链接](https://note.everkm.cn)

[带标题的内嵌式链接](https://note.everkm.cn "道盒笔记")

[引用式链接][arbitrary case-insensitive reference text]

或者空着什么都不写 [link text itself], 引用链接的地址放在后面。

[link text itself]: https://note.everkm.cn
[arbitrary case-insensitive reference text]: https://note.everkm.cn
```

---


# 图片

1. 内嵌式
![alt text](https://images.unsplash.com/photo-1636821774147-89e9eb08c122?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D "Picture Title")

2. 引用式, 引用的内容放在后面。
![alt text][picture]


[picture]: https://images.unsplash.com/photo-1624778487485-98e0423140a8?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D "Picture Title"


```md
1. 内嵌式
![alt text](https://images.unsplash.com/photo-1636821774147-89e9eb08c122?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D "Picture Title")

2. 引用式, 引用的内容放在后面。
![alt text][picture]


[picture]: https://images.unsplash.com/photo-1624778487485-98e0423140a8?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D "Picture Title"
```
---



# 代码

```javascript
console.log('Hello world')
```


<pre><code>
```javascript
console.log('Hello world')
```
</code></pre>
---


# 水平分割线

如下 :point_down:


```md
---
```

---


# 块引用

> 引用内容
> 可以在块引用中使用其它Markdown格式
> > 嵌套引用内容


```md
> 引用内容
> 可以在块引用中使用其它Markdown格式
> > 嵌套引用内容
```

---


# 删除线

~~删除线~~


```md
~~删除线~~
```
---



# 任务列表


- [x] Write the press release
- [ ] Update the website
- [ ] Contact the media


```md
- [x] Write the press release
- [ ] Update the website
- [ ] Contact the media
```

---


# 自动转换链接

<https://www.everkm.cn>

```md
<https://www.everkm.cn>
```

---


# 脚注

本格式详细文档请见道盒发布[^everkm-publish]
[^everkm-publish]: 道盒Markdown扩展:point_right: <https://publish.everkm.cn>


```md
本格式详细文档请见道盒发布[^everkm-publish]
[^everkm-publish]: 道盒Markdown扩展:point_right: <https://publish.everkm.cn>
```
---



# 表格

| Tables        | Are           | Cool  |
| ------------- |:-------------:| -----:|
| col 3 is      | right-aligned | $1600 |
| col 2 is      | centered      |   $12 |
| zebra stripes | are neat      |    $1 |


Markdown | Less | Pretty
--- | --- | ---
*Still* | `renders` | **nicely**
1 | 2 | 3


{align=center}
| 默认对齐   | 左对齐 | 中对齐 | 右对齐 |
| ---       | :---  | :---: | ---:  |
| Content   | Content | Content | Content |
| Content   | Content | Content | Content |


```md
| Tables        | Are           | Cool  |
| ------------- |:-------------:| -----:|
| col 3 is      | right-aligned | $1600 |
| col 2 is      | centered      |   $12 |
| zebra stripes | are neat      |    $1 |


Markdown | Less | Pretty
--- | --- | ---
*Still* | `renders` | **nicely**
1 | 2 | 3


{align=center}
| 默认对齐   | 左对齐 | 中对齐 | 右对齐 |
| ---       | :---  | :---: | ---:  |
| Content   | Content | Content | Content |
| Content   | Content | Content | Content |
```
---


# TOC

见本页面顶部 :point_up:


```md
见本页面顶部 :point_up:
```
---


# 包含外部文件

{{everkm::include(file="_hello-everkm-markdown.inc.md", as="md")}}

```md
{{everkm::include(file="_hello-everkm-markdown.inc.md", as="md")}}
```
---


# 项目内部链接 

- [ ] 项目内链接

```markdown
[[文件名]]

[[目录/文件名]]
```
---


# 页内锚点跳转

返回[本页目录](#this-page) :point_up: 


```md
返回[本页目录](#this-page) :point_up: 
```
---


# 区块扩展属性

{bgcolor="rgba(0,0,0,0.1)" color=blue underline pa=1em corner=0.5em}
这是一段区块示例内容，它拥灰色背景、蓝色文字、下划线、1个字大小的边距、半个字大小的圆角。


```md
{bgcolor="rgba(0,0,0,0.1)" color=blue underline pa=1em corner=0.5em}
这是一段区块示例内容，它拥灰色背景、蓝色文字、下划线、1个字大小的边距、半个字大小的圆角。
```

---

# 行内扩展属性

我是{color=red}#红色#的文字。


```md
我是{color=red}#红色#的文字。
```
---


# 链接扩展属性

带有扩展属性的[道盒](https://www.everkm.cn){color=orange}橘色链接。


```md
带有扩展属性的[道盒](https://www.everkm.cn){color=orange}橘色链接。
```
---


# 图片扩展属性

圆角图片如下。

![图片圆角](https://images.unsplash.com/photo-1564979045531-fa386a275b27?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2532&q=80 "蓝天与狗尾巴草"){corner=1em}


```md
![图片圆角](https://images.unsplash.com/photo-1564979045531-fa386a275b27?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2532&q=80 "蓝天与狗尾巴草"){corner=1em}
```
---


# 下划线

{ul}#下划线#


```md
{ul}#下划线#
```
---


# 上标

E=MC^2^

```md
E=MC^2^
```
---


# 下标

H~2~O

```md
H~2~O
```
---


# 高亮

I need to highlight these ==very important words==.


```md
I need to highlight these ==very important words==.
```
---




# 定义列表 （Definition Lists）

Apple

:   Pomaceous fruit of plants of the genus Malus in 
    the family Rosaceae.

Orange

:   The fruit of an evergreen tree of the genus Citrus.


```md
Apple

:   Pomaceous fruit of plants of the genus Malus in 
    the family Rosaceae.

Orange

:   The fruit of an evergreen tree of the genus Citrus.
```
---


