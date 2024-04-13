import Mark from 'mark.js'
import scrollIntoView from 'scroll-into-view'
import $ from 'cash-dom'

// 从当前URL中获取高亮关键字
function getWordsFromPageUrl() {
  const u = new URL(window.location.href)
  const param = u.searchParams.get('__hlts') || ''
  if (!param) {
    return null
  }

  const words = JSON.parse(param)
  if (!Array.isArray(words)) {
    return
  }
  return words
}

function highlight(words: string[], container = document.body) {
  const mark = new Mark(container)
  mark.mark(words, {
    className: '!bg-[yellow]'
    // 忽略高亮，则无法定位，所以去除
    // exclude: ['pre code'],
  })
}

export function initPageMark() {
  const words = getWordsFromPageUrl()
  if (!words) {
    return
  }

  highlight(words)

  const target = $('mark[data-markjs]')
  const el = target.eq(0)
  if (el.length === 0) {
    return
  }
  let focusEl = target.get(0)

  // 向上搜索，确定是否代码块，若是则将目标修改为该代码块，
  // 因为代码高亮会修改dom, 造成节点无效
  const parents = el.parentsUntil('pre')
  console.log('parents', parents)
  if (parents.get(0)?.tagName.toLowerCase() === 'code') {
    focusEl = parents.get(0)
  }

  console.log('scrollIntoView ', focusEl)
  setTimeout(() => {
    scrollIntoView(focusEl, {}, (type: string) => {
      console.log('second mark highlight', type)
      if (type !== 'complete') {
        return
      }

      highlight(words, focusEl)
    })
  }, 300)
}
