<template>
  <div>
    <DownloadItem :item="item" />
  </div>
</template>
<script lang="ts" setup>
import {computed} from 'vue'
import {IDownloadItem, IDownloadSource} from './download_types'
import DownloadItem from './DownloadItem.vue'
import {useTranslation} from 'i18next-vue'

const props = defineProps({
  source: {
    type: String,
    required: true,
  },
  icon: {
    type: String,
    default: 'icon-[ant-design--appstore-filled]',
  },
  title: {
    type: String,
    default: '',
  },
  buttonText: {
    type: String,
    default: '',
  },
  invalidationTips: {
    type: String,
    default: '',
  },
  invalidationHelp: {
    type: String,
    default: '',
  },
  forMobile: {
    type: Boolean,
    default: false,
  },
  mobileButtonText: {
    type: String,
    default: '',
  },
  onlyDesktop: {
    type: Boolean,
    default: false,
  },
})

const tDownload = useTranslation('download')
const chipsetText = tDownload.t('chipset')

const desktopNames = [
  {
    key: 'windows-x64',
    title: 'Windows',
  },
  {
    key: 'darwin-x64',
    title: `macOS (Intel ${chipsetText})`,
  },
  {
    key: 'darwin-aarch64',
    title: `macOS (Apple ${chipsetText})`,
  },
  {
    key: 'android-universial',
    title: `Android`,
  },
]

const item = computed(() => {
  const source = window[props.source]
  const sourceList = Object.keys(source.platforms).reduce<IDownloadSource[]>(
    (a, c) => {
      const desktop = desktopNames.find((v) => v.key === c)
      if (!desktop) {
        return a
      }

      const value = source.platforms[c]

      const val: IDownloadSource = {
        caption: desktop.title,
        url: value.url,
      }

      a.push(val)
      return a
    },
    [],
  )

  // 按定义的顺序
  const sortKeys = desktopNames.map((v) => v.title)
  sourceList.sort((a, b) => {
    return sortKeys.indexOf(a.caption) - sortKeys.indexOf(b.caption)
  })

  // icon-[simple-line-icons--screen-desktop]
  // icon-[uiw--android]
  // icon-[uiw--apple]
  // icon-[fontisto--tablet]
  const ret: IDownloadItem = {
    version: source.version,
    downloadSource: sourceList,
    icon: props.icon,
    title: props.title,
    buttonText: props.buttonText,
    invalidationTips: props.invalidationTips,
    invalidationHelp: props.invalidationHelp,
    forMobile: props.forMobile,
    mobileButtonText: props.mobileButtonText,
    onlyDesktop: props.onlyDesktop,
  }

  return ret
})
</script>
