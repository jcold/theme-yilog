<template>
  <div class="fixed inset-0 z-50 bg-white/90" @click="handleClose">
    <div
      class="max-w-screen-lg bg-white shadow-lg md:mx-4 md:my-8 md:rounded-lg md:border lg:mx-auto"
      @click.stop=""
    >
      <!-- 搜索框 -->
      <div
        class="flex h-12 items-center"
        :class="{'border-b': noResults || hitItems.length}"
      >
        <span
          class="icon-[material-symbols--search-rounded] ml-4 mr-2 flex-shrink-0 flex-grow-0 text-xl"
        ></span>
        <input
          type="text"
          ref="elWd"
          v-focus
          v-model.trim="wd"
          class="min-w-12 flex-1 px-1 text-xl outline-0"
        />
        <div
          class="inline-flex flex-shrink-0 flex-grow-0 items-center rounded-lg p-2 text-lg opacity-60 hover:bg-black/5 hover:opacity-100"
          :class="{invisible: !wd.length}"
          @click.prevent.stop="handleClearSearch"
        >
          <span class="icon-[material-symbols--close]"></span>
        </div>
        <div
          class="ml-2 flex h-full flex-shrink-0 flex-grow-0 cursor-pointer select-none items-center whitespace-nowrap border-l px-4 hover:bg-black/5"
          @click="handleClose"
        >
          {{ $t('in_search:cancel') }}
        </div>
      </div>

      <!-- 空结果列表 -->
      <div
        class="flex flex-col items-center gap-4 py-8 text-center"
        v-if="noResults"
      >
        <span
          class="icon-[oui--cross-in-circle-empty] text-[2.5em] text-gray-400"
        ></span>
        <div class="">{{ $t('in_search:no_results', {wd: wd}) }}</div>
      </div>
      <!-- 结果列表 -->
      <div
        class="flex h-[calc(100vh-3rem)] flex-col md:h-[calc(100vh-7rem)]"
        v-show="hitItems.length"
      >
        <div class="flex flex-1 overflow-hidden">
          <div
            class="flex flex-1 flex-col divide-y overflow-y-auto md:basis-2/5 md:overflow-y-scroll"
          >
            <div
              class="cursor-pointer space-y-1 px-2 py-3 hover:bg-gray-100"
              :class="{'!bg-blue-50': item.link === selectedPage}"
              v-for="item in hitItems"
              :key="item.id"
              :id="`hit-${item.id}`"
              @click="handleSelectItem(item.link)"
            >
              <h2
                class="inline font-medium underline-offset-2 hover:underline"
                v-html="item.title"
                @click.prevent.stop="handleOpenInNewTab(item.link)"
              ></h2>
              <p class="text-sm text-gray-600" v-html="item.summary"></p>
            </div>
            <InfiniteLoaderVue
              class="py-2 text-center text-sm text-gray-400"
              :offScreenLoad="true"
              :loader="loadMore"
              :infiniteId="infiniteId"
            />
          </div>
          <div
            ref="elPageFrame"
            class="relative hidden flex-1 basis-3/5 md:block"
          >
            <iframe
              v-if="selectedPage"
              border="0"
              class="h-full w-full"
              :src="selectedPage"
            />

            <div
              class="absolute right-[1em] top-0.5 leading-[0]"
              v-if="selectedPage"
            >
              <div
                class="inline-block cursor-pointer rounded bg-black/10 p-2 hover:bg-black/20"
                @click="handleOpenInNewTab(selectedPage)"
              >
                <span class="icon-[material-symbols--open-in-new]"></span>
              </div>
            </div>
          </div>
        </div>
        <div
          class="flex items-center justify-between border-t bg-slate-50 px-4 py-2 md:rounded-b-lg"
        >
          <div class="md:hidden"></div>
          <div class="hidden gap-3 text-sm text-gray-500 md:flex">
            <div>
              <span class="keycode">↵</span>
              <span class="ml-1.5">{{ $t('in_search:to_select') }}</span>
            </div>
            <div>
              <span class="keycode">↓</span>
              <span class="keycode ml-1">↑</span>
              <span class="ml-1.5">{{ $t('in_search:to_navigate') }}</span>
            </div>
            <div>
              <span class="keycode">Esc</span>
              <span class="ml-1.5">{{ $t('in_search:to_close') }}</span>
            </div>
          </div>
          <div class="">
            <a href="https://www.algolia.com/?utm_source=everkm" target="_blank"
              ><Algolia></Algolia
            ></a>
          </div>
        </div>
      </div>
      <!-- 搜索结果列表 结束 -->
    </div>
  </div>
</template>
<script lang="ts" setup>
import {PropType, computed, nextTick, ref, watch} from 'vue'
import algoliasearch from 'algoliasearch/lite'
import {Hit, SearchResponse} from '@algolia/client-search'
import InfiniteLoaderVue from '../components/infinite_loader/InfiniteLoader.vue'
import {StateChanger} from '@/components/infinite_loader/InfiniteLoaderTypes'
import {debounce} from 'lodash-es'
import {HotKeysSession} from '@/components/keymap/HotKeysManager'
import {EventBindings} from '@/components/keymap/keymap'
import Algolia from './AlgoliaIcon.vue'
import {IApiConfig} from './types'
import $ from 'cash-dom'
import {injectHotKeysManager} from '@/components/keymap/useHotKeysManager'

interface IHitItem {
  id: string
  title: string
  summary: string
  link: string
  highlights: string[]
}

interface IHitField {
  title: string
  content: string
  link: string
}

const emits = defineEmits<{
  // <eventName>: <expected arguments>
  close: []
  //   update: [value: string] // named tuple syntax
}>()

const props = defineProps({
  visible: {
    type: Boolean,
    default: false,
  },
  apiConfig: {
    type: Object as PropType<IApiConfig>,
    required: true,
  },
})

const hotkeys = injectHotKeysManager()
const elPageFrame = ref<HTMLElement>()
const elWd = ref<HTMLInputElement>()
const wd = ref('')
const hitItems = ref<IHitItem[]>([])
const selectedPage = ref('')
const infiniteId = ref(+new Date())
const loadFinish = ref(false)

function mapHitItem(input: Hit<IHitField>) {
  let ret: IHitItem = {
    id: input.objectID,
    title: input._snippetResult?.title?.value || input.title,
    summary: input._snippetResult?.content?.value || '',
    link: input.link,
    highlights: [],
  }

  // Extract highlight words
  const words = new Set<string>()
  Object.keys(input._snippetResult || {}).forEach((k) => {
    const item = input._snippetResult![k]
    if (item.matchLevel !== 'none') {
      $(`<div>${item.value}</div>`)
        .find('em.hit-keyword')
        .each((_, el) => {
          const text = $(el).text()
          // console.log('item', text)
          if (text) {
            words.add(text)
          }
        })
    }
  })
  ret.highlights = [...words]

  // 转换为带高亮参数的链接
  if (ret.highlights.length) {
    const u = new URL(ret.link)
    if (ret.highlights.length > 0) {
      const v = JSON.stringify(ret.highlights)
      u.searchParams.append('__hlts', v)
    }
    const s = u.toString()
    console.log('highlightLink', s)
    ret.link = s
  }

  console.log('raw item', input, ret)
  return ret
}

// Enter 按键处理
const handleEnter = () => {
  if (selectedPage.value) {
    handleOpenInNewTab(selectedPage.value)
  }
}

const handleSearch = async () => {
  if (!wd.value.length) {
    console.warn('no search keyword')
    return
  }

  loadFinish.value = false
  hitItems.value = []
  infiniteId.value++
}

const noResults = computed(() => {
  return loadFinish.value && wd.value.length && hitItems.value.length === 0
})

const debounceDoSearch = debounce(() => {
  handleSearch()
}, 300)

watch(wd, () => {
  if (!wd.value.length) {
    handleClearSearch()
    return
  }

  loadFinish.value = false
  debounceDoSearch()
})

// 当数据变动时，自动选择第一个
watch(hitItems, (items) => {
  if (!items.length) {
    selectedPage.value = ''
    return
  }

  const links = items.map((v) => v.link)
  if (selectedPage.value && links.includes(selectedPage.value)) {
    return
  }

  selectedPage.value = items[0].link
})

const PAGE_SIZE = 10
const loadSearch = async (fireId: number, offset = 0) => {
  const searchClient = algoliasearch(
    props.apiConfig.appId,
    props.apiConfig.apiKey,
  )

  const resp = await searchClient.search([
    {
      indexName: props.apiConfig.index,
      query: wd.value,
      params: {
        attributesToRetrieve: ['title', 'link'],
        attributesToHighlight: [],
        offset,
        length: PAGE_SIZE,
        distinct: true,
        highlightPreTag: '<em class="hit-keyword">',
        highlightPostTag: '</em>',
        attributesToSnippet: ['title:200;', 'content:30;'],
      },
    },
  ])

  if (fireId !== infiniteId.value) {
    console.log('searching fire condition changed, skip...')
    return -1
  }

  console.log('resp', resp)
  const body = resp.results[0] as SearchResponse<IHitField>
  if (body.query !== wd.value) {
    console.log('search keyword changed, skip...')
    return -1
  }

  const items = body.hits
  // debugger
  if (!items.length) {
    return 0
  }

  const mappedItems = items.map((v) => mapHitItem(v))
  hitItems.value = hitItems.value.concat(mappedItems)
  const ret = mappedItems.length < PAGE_SIZE ? 0 : 1
  console.log('mapped length', mappedItems.length, PAGE_SIZE, ret, offset)
  return ret
}

const loadMore = async (state: StateChanger) => {
  const offset = hitItems.value?.length || 0
  const remainCount = await loadSearch(infiniteId.value, offset)

  // Invalidate response, ignore
  if (remainCount === -1) {
    return
  }

  if (remainCount === 0) {
    console.log('load complete')
    state.complete()
    loadFinish.value = true
  } else {
    state.loaded()
  }
}

const handleClose = () => {
  if (props.visible) {
    emits('close')
  }
}

const handleOpenInNewTab = (url: string) => {
  globalThis.window.open(url)
}

// 点击选中，如果已经选中，则新标签页打开
const handleSelectItem = (link: string) => {
  if (selectedPage.value === link) {
    handleOpenInNewTab(link)
  } else {
    selectedPage.value = link
    // 如果不在展示状态，直接打开
    if (elPageFrame.value) {
      const computedStyle = window.getComputedStyle(elPageFrame.value)
      if (computedStyle.display === 'none') {
        handleOpenInNewTab(link)
        return
      }
    }
  }
}

const handleClearSearch = () => {
  wd.value = ''
  elWd.value?.focus()
  hitItems.value = []
  selectedPage.value = ''
}

const upOrDownItem = (isUp: boolean) => {
  const idx = hitItems.value.findIndex((v) => v.link === selectedPage.value)
  let newIdx = 0

  if (isUp) {
    newIdx = idx - 1
    if (newIdx < 0) {
      newIdx = 0
    }
  } else {
    newIdx = idx + 1
    const len = hitItems.value.length
    if (newIdx >= len) {
      newIdx = len - 1
    }
  }

  const target = hitItems.value[newIdx]
  if (target) {
    selectedPage.value = target.link
    const el = document.querySelector(`#hit-${target.id}`)
    el?.scrollIntoView()
  }
}

// 快捷键控制
let hotkeySession: HotKeysSession | null = null
const bindings: EventBindings = {
  'Cmd-k': () => {
    elWd.value?.focus()
    return true
  },
  Enter: () => {
    elWd.value?.focus()
    handleEnter()
    return true
  },
  Escape: () => {
    handleClose()
    return true
  },
  ArrowUp: (evt: KeyboardEvent) => {
    elWd.value?.focus()
    upOrDownItem(true)
    evt.preventDefault()
    evt.stopPropagation()
    return true
  },
  ArrowDown: (evt: KeyboardEvent) => {
    elWd.value?.focus()
    upOrDownItem(false)
    evt.preventDefault()
    evt.stopPropagation()
    return true
  },
}
watch(
  () => props.visible,
  (isShow) => {
    if (isShow) {
      hotkeySession = hotkeys.newSession(bindings, {
        captureInput: true,
      })

      $(document.body).addClass('!overflow-hidden')

      nextTick(() => {
        elWd.value?.focus()
      })
    } else {
      $(document.body).removeClass('!overflow-hidden')

      hotkeySession?.destroy()
      hotkeySession = null
    }
  },
  {
    immediate: true,
  },
)
</script>
<style lang="scss">
em.hit-keyword{
  @apply text-[#003dff];
  font-style: normal;
}
</style>
