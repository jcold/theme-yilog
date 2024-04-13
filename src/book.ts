import './nav_tree.scss'
import $ from 'cash-dom'
import {lazyImg, buildNavTree, setupToc, setupLinkAjax} from 'everkm-wa'

export async function init() {
  const updateNavActive = await buildNavTree('.nav-tree', -1)
  const updateToc = await setupToc('.js-toc-content', '#js-toc')

  const onAjaxLoaded = (doc: Document) => {
    const titleElement = doc.querySelector('title')

    globalThis.document.title = titleElement?.textContent?.trim() || ''
    $('#article-body').html(doc.querySelector('#article-body')?.innerHTML || '')
    globalThis.window.scroll(0, 0)

    updateToc()
    updateNavActive()

    lazyImg()
    // installFormulaView()
    ;(window as any)?.Prism?.highlightAll()
  }

  const ajaxPath = (globalThis.window as any).daoboxAjaxPathSeg || ''
  if (ajaxPath) {
    setupLinkAjax(ajaxPath, onAjaxLoaded)
  }
}
