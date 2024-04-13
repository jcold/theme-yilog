import './style.scss'
import './assets/github-markdown.css'
import 'everkm-wa/main.css'
import {
  setupLayoutHeight,
  lazyImg,
  setupDrawerToggle,
  changeLang,
} from 'everkm-wa'
import $ from 'cash-dom'
import i18next from './i18n/i18n'
import I18NextVue from 'i18next-vue'
import {createApp} from 'vue'
import VueObserveVisibility from 'vue3-observe-visibility'
import VueClickAway from 'vue3-click-away'
import {initPageMark} from './assets/js/PageHighlights'
import {HotKeysManager} from './components/keymap/HotKeysManager'
import {HOT_KEYS_MGR} from './components/keymap/useHotKeysManager'

const ekmTags = {
  'ekm-in-search': import('./in_search/InSearch.vue'),
  'ekm-app-download': import('./app_download/DownloadWidget.vue'),
}

// 创建全局快捷键管理器
const hotKeysMgr = new HotKeysManager()

function loadBoxComponent() {
  Object.keys(ekmTags).forEach((cmpType) => {
    const els = Array.from(document.querySelectorAll(cmpType))
    console.log('found elements', els)

    let mod = ekmTags[cmpType]

    mod?.then((comp) => {
      // console.log('comp', comp)
      els?.forEach((el) => {
        const attrs = {}
        for (const attr of el.attributes) {
          attrs[attr.name] = attr.value
        }
        console.log('attrs', attrs)

        const app = createApp(comp.default, attrs)
        app.use(I18NextVue, {i18next})
        app.use(VueObserveVisibility)
        app.use(VueClickAway)
        app.provide(HOT_KEYS_MGR, hotKeysMgr)
        app.directive('focus', {
          // 当被绑定的元素插入到 DOM 中时……
          mounted: function (el: HTMLElement) {
            setTimeout(() => {
              el.focus()
              // caretToEnd(el)
            }, 10)
          },
        })
        app.mount(el)
      })
    })
  })
}

function globalInit() {
  setupLayoutHeight()
  lazyImg()
  // installFormulaView()
  setupDrawerToggle('#aside-nav', '#drawer')
}

if (typeof (window as any).everkm === 'undefined') {
}

;(window as any).everkm = {
  async bootstrap(module: string) {
    // const { default: _ } = await import('lodash');
    switch (module) {
      case 'download':
        {
          const {init} = await import('./download')
          init()
        }
        break
      case 'book':
        {
          const {init} = await import('./book')
          init()
        }
        break
    }
  },
}

// 基础初始化
;(async () => {
  const lang = (window as any).__everkm_lang || ''
  if (lang) {
    await changeLang(lang)
  }

  $(document).ready(() => {
    globalInit()
    loadBoxComponent()
    initPageMark()
  })
})()
