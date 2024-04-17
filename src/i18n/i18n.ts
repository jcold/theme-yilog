import i18next from 'i18next'
import enDownload from './locales/en_US/download.json'
import zhDownload from './locales/zh_CN/download.json'
import enInSearch from './locales/en_US/embed_search.json'
import zhInSearch from './locales/zh_CN/embed_search.json'
import en_infinite_load from './locales/en_US/infinite_load.json'
import zh_infinite_load from './locales/zh_CN/infinite_load.json'

// export const defaultNS = 'ns1'
// export const fallbackNS = 'fallback'

let curLang = (window as any).__everkm_lang || ''

i18next.init({
  debug: false,
  lng: curLang,
  fallbackLng: 'en_US',
  //   defaultNS,
  //   fallbackNS,
  resources: {
    en_US: {
      download: enDownload,
      embed_search: enInSearch,
      infinite_load: en_infinite_load,
    },
    zh_CN: {
      download: zhDownload,
      embed_search: zhInSearch,
      infinite_load: zh_infinite_load,
    },
  },
})

export default i18next

export async function changeLang(lang: string) {
  curLang = lang
  // console.log('changeLang before', lang)
  await i18next.changeLanguage(lang)
  // console.log('changeLang', lang)
}
