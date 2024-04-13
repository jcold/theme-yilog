<template>
  <div v-observe-visibility="handleVisibilityChange" class="">
    <slot v-if="stateChanger.state.value === LoadState.Loaded" name="loading">
      <div class="yb-more-status">{{ $t('infinite_load:loading') }}</div>
    </slot>
    <slot
      v-if="stateChanger.state.value === LoadState.Completed"
      name="no-more"
    >
      <div class="yb-more-status">{{ $t('infinite_load:no_more') }}</div>
    </slot>
  </div>
</template>
<script setup lang="ts">
import {PropType, ref, watch} from 'vue'
import {LoadState, StateChanger, TLoaderFn} from './InfiniteLoaderTypes'

const props = defineProps({
  // 自定义加载函数，完成后标记是否有更多结果
  loader: {
    type: Function as PropType<TLoaderFn>,
    required: true,
  },

  // 数字变化时，会触发重新加载
  infiniteId: {
    type: Number,
    required: false,
    default: () => {
      return ref(0)
    },
  },

  maxLoad: {
    type: Number,
    default: 30,
  },

  autoLoad: {
    type: Boolean,
    default: true,
  },

  // 允许离屏加载
  offScreenLoad: {
    type: Boolean,
    default: false,
  },
})

const stateChanger = new StateChanger()
let loopCounter = 0
let inViewport = true
let visibleChangeCount = 0
let loading = false

const maybeLoad = () => {
  if (loading) {
    return
  }

  // debugger
  if (!inViewport && !props.offScreenLoad) {
    console.warn('infinite_loader not in view')
    return
  }

  // 防止死循环
  if (loopCounter-- <= 0) {
    console.error('auto load reach to 30, abort!')
    return
  }

  if (stateChanger.hasMore()) {
    // debugger
    loading = true
    props.loader(stateChanger).finally(() => {
      loading = false
    })
  }
}

// 当一次数据加载完成后，外部会做状态变更，然后检测是否需要加载
watch(stateChanger.changedId, () => {
  // 如果继续在视窗内，则继续加载
  if (inViewport && stateChanger.hasMore()) {
    setTimeout(() => {
      maybeLoad()
    }, 50)
  }
})

const handleVisibilityChange = (isVisible: boolean) => {
  console.log('handleVisibilityChange ', isVisible)

  // 禁用第一次自动加载
  visibleChangeCount++
  if (visibleChangeCount === 1 && !props.autoLoad) {
    inViewport = isVisible
    return
  }

  if (!isVisible) {
    inViewport = false
    return
  }

  loopCounter = props.maxLoad
  inViewport = true
  maybeLoad()
}

const reset = () => {
  inViewport = true

  loopCounter = props.maxLoad
  stateChanger.reset()
}

watch(
  () => props.infiniteId,
  () => {
    reset()
  },
)

defineExpose({
  reset,
})
</script>
