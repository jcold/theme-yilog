```toml
title: 内容示例
date: 2023-08-16
tags: ["work", "abc"]
slug: hello-dayu
weight: 100
```

# 内容示例

段落1


我是图片![Alt Text](@media/3.webp)

```dcard2
card: bilibili
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