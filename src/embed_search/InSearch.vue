<template>
  <div class="inline-flex items-center" @click="handleToggleSearch">
    <div
      class="inline-flex cursor-pointer items-center gap-2 rounded-2xl py-1.5"
      :class="{
        'border px-3 shadow hover:shadow-lg': !justOnlyButton,
        'text-[1.3rem]': justOnlyButton,
      }"
    >
      <span class="icon-[material-symbols--search]"></span>

      <template v-if="!justOnlyButton">
        <span class="mr-4 text-[0.9em] text-gray-500">{{
          $t('embed_search:search')
        }}</span>
        <div class="space-x-[1px] text-[0.8em] text-gray-400">
          <span class="" v-text="cmdKey"></span>
          <span class="">-</span>
          <span class="">K</span>
        </div>
      </template>
    </div>
    <Teleport to="body">
      <FloatSearch
        v-show="searchVisible"
        :visible="searchVisible"
        :api-config="apiConfig"
        @close="handleClose"
      />
    </Teleport>
  </div>
</template>
<script lang="ts" setup>
import {computed, onUnmounted, ref} from 'vue'
import FloatSearch from './FloatSearch.vue'
import {EventBindings} from '@/components/keymap/keymap'
import {IApiConfig} from './types'
import {isMacPlatform} from '../components/keymap/keymap'
import {injectHotKeysManager} from '@/components/keymap/useHotKeysManager'

const props = defineProps({
  appId: {
    type: String,
    default: true,
  },
  apiKey: {
    type: String,
    default: true,
  },
  index: {
    type: String,
    default: true,
  },
  onlyButton: {
    type: String,
    default: false,
  },
})

/**
 * 搜索框占位界面，点击后弹出搜索浮动界面
 */

const searchVisible = ref(false)

const handleToggleSearch = () => {
  searchVisible.value = !searchVisible.value
}

const handleClose = () => {
  searchVisible.value = false
}

const apiConfig = computed(() => {
  const ret: IApiConfig = {
    appId: props.appId,
    apiKey: props.apiKey,
    index: props.index,
  }
  return ret
})

// 注册快捷键
const hotkeys = injectHotKeysManager()
const bindings: EventBindings = {
  'Meta-k': () => {
    if (searchVisible.value) {
      return false
    }

    searchVisible.value = true
    return true
  },
}
hotkeys.newSession(bindings)
onUnmounted(() => {
  hotkeys.destroy()
})

const cmdKey = computed(() => {
  if (isMacPlatform) {
    return '⌘'
  } else {
    return 'Ctrl'
  }
})

const justOnlyButton = computed(() => {
  return props.onlyButton === 'true'
})
</script>
<style lang="scss">
.keycode {
  @apply inline-flex h-8 w-8 items-center justify-center rounded border p-1 text-xs;
}
</style>
