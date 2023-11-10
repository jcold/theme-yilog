---
title: 道盒 Markdown 示例
date: 2023-08-16
tags: ["demo", "markdown"]
slug: hello-everkm-markdown
weight: 99
---

## 宏

### include

{{everkm::include(file="_everkm-theme.inc.yaml", as="code")}}


# 内容示例

段落1


我是图片![Alt Text](3.webp)

```yaml dcard/bilibili
vid: BV1sz4y197L8
description: 简介
```



```js
function main(name){
    var arr = name.split('-')
    if (arr[3] === 'windows'){
        var s = arr[4].match(/\d+$/)[0]
        return s ? s+'位' : ''
    }
    return arr[4].replace(/^\S/,function(s){return s.toUpperCase()})
}
main(name)
```
