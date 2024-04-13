<template>
  <div
    class="relative flex h-56 w-56 flex-col items-center justify-center gap-2 rounded-[0.5rem] border-2 border-blue-200"
    :class="{
      'mb-12': item.invalidationHelp,
    }"
    @mouseenter="handleMainEnter"
    @mouseleave="handleMainLeave"
  >
    <div class="mt-8">
      <span
        class="inline-block text-[64px] text-[#5c7eff]"
        :class="item.icon"
      ></span>
    </div>
    <div
      class="text-lg font-medium"
      v-text="item.title"
      v-if="item.title"
    ></div>
    <div class="flex w-full cursor-default flex-col items-center gap-0.5">
      <div
        v-if="buttonText && !(item.onlyDesktop && isMobileDevice)"
        ref="elAction"
        class="w-2/3 rounded bg-blue-500 py-1.5 text-center text-white"
        v-text="buttonText"
        @mouseenter="handleHover(1)"
        @mouseleave="handleDelayHide(1)"
        @click="handleDownload"
      ></div>

      <div
        class="text-gray-500"
        v-else-if="item.invalidationTips"
        v-text="item.invalidationTips"
      ></div>
      <div class="text-sm text-gray-400" v-text="item.version"></div>
    </div>

    <!-- 底部帮助 -->
    <div
      class="absolute inset-x-0 top-full mt-2 w-full text-center text-gray-500"
      v-if="item.onlyDesktop && isMobileDevice && item.invalidationHelp"
      v-text="item.invalidationHelp"
    ></div>

    <!-- 多链接下载菜单 -->
    <div
      ref="elPopup"
      class="absolute inset-x-0 z-10 rounded border bg-white py-2 shadow"
      v-show="popupVisible"
      v-if="item.downloadSource.length > 1"
      @mouseenter="handleHover(2)"
      @mouseleave="handleDelayHide(2)"
    >
      <div
        class="px-3 py-1.5"
        v-for="v in item.downloadSource"
        :key="v.caption"
      >
        <a :href="v.url" v-text="v.caption"></a>
      </div>
    </div>

    <!-- qr -->
    <div
      v-show="qrcodeVisible"
      class="absolute inset-0 my-2 flex flex-col items-center justify-end bg-white"
    >
      <canvas class="" ref="elQr"></canvas>
      <div class="text-center text-sm">
        {{ $t('download:scan_qrcode_to_download') }}
      </div>
    </div>

    <!-- 右上角二维码 -->
    <div class="tr-qrcode" v-if="item.forMobile && !isMobileDevice">
      <div></div>
    </div>
  </div>
</template>
<script lang="ts" setup>
import {PropType, computed, nextTick, onUnmounted, ref, watch} from 'vue'
import {IDownloadItem} from './download_types'
import {createPopper, Instance} from '@popperjs/core'
import QRCode from 'qrcode'
import UAParser from 'ua-parser-js'

const props = defineProps({
  item: {
    type: Object as PropType<IDownloadItem>,
    required: true,
  },
})

const elQr = ref<HTMLElement>()
const elAction = ref<HTMLElement>()
const elPopup = ref<HTMLElement>()
const popupVisible = ref(0)
let popupInst: Instance | null = null

watch(
  [elAction, elPopup],
  () => {
    if (!(elAction.value && elPopup.value)) {
      return
    }

    if (popupInst) {
      return
    }

    nextTick(() => {
      if (elAction.value && elPopup.value) {
        popupInst = createPopper(elAction.value, elPopup.value, {
          placement: 'bottom',
          modifiers: [
            {
              name: 'offset',
              options: {
                offset: [0, 4],
              },
            },
          ],
        })
      }
    })
  },
  {immediate: true},
)

onUnmounted(() => {
  popupInst?.destroy()
  popupInst = null
})

const hasManySource = computed(() => {
  return props.item.downloadSource.length > 1
})

const handleDelayHide = (id: number) => {
  setTimeout(() => {
    if (popupVisible.value === id) {
      popupVisible.value = 0
    }
  }, 300)
}

const handleHover = (id: number) => {
  if (!hasManySource.value) {
    return
  }

  if (!isMobileDevice && props.item.forMobile) {
    return
  }

  popupVisible.value = id
  nextTick(() => {
    popupInst?.update()
  })
}

const mainPackageUrl = computed(() => {
  return props.item.downloadSource[0].url || ''
})

const handleDownload = () => {
  if (hasManySource.value) {
    return
  }

  if (mainPackageUrl.value) {
    window.location.href = mainPackageUrl.value
  }
}

watch(
  [elQr, mainPackageUrl],
  ([el, u]) => {
    if (el && u) {
      QRCode.toCanvas(el, u, {
        width: 164,
        scale: 4,
        margin: 2,
      }).catch((err) => {
        console.error(err)
      })
    }
  },
  {immediate: true},
)

const qrcodeVisible = ref(false)
const ua = new UAParser()
const device = ua.getDevice().type || ''
console.log('device', ua.getDevice())
const isMobileDevice = device && ['mobile', 'tablet'].includes(device)
const handleMainEnter = () => {
  // 仅移动设备有效
  if (!props.item.forMobile) {
    return
  }

  if (isMobileDevice) {
    return
  }

  qrcodeVisible.value = true
}

const handleMainLeave = () => {
  qrcodeVisible.value = false
}

const buttonText = computed(() => {
  if (!props.item.forMobile) {
    return props.item.buttonText
  }

  return (
    (isMobileDevice ? props.item.mobileButtonText : props.item.buttonText) ||
    props.item.buttonText
  )
})
</script>
<style lang="scss">
.tr-qrcode {
  @apply absolute;
  top: -2px;
  right: -2px;
  width: 0;
  height: 0;
  border-color: #5c7eff #5c7eff transparent transparent;
  border-width: 2rem;
  border-radius: 0px 0.5rem 0px 0px;

  & > div {
    position: absolute;
    top: -1.4rem;
    left: 0.2rem;
    width: 1.2rem;
    height: 1.2rem;
    background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADQAAAA0CAYAAADFeBvrAAACpUlEQVR4Ae3B8XHTBhgH0PfpNIA2qDZIOgFhgtIJIF0gSRdImKDJBDWdIJ3A3qBmArwBYoJf/2jvMI6DLWRKyfk9R0dHR+vKFklOcY3ONIuqem1DklucmGaFq6oarGlt9xvOTHeW5E1VrfwryQtcOIy3uLWm8d/rHE5nQ2u3Je7s7xQX9jPgyjjX6D2itdtdVc2MkOTCfpZVNTNCkjP0HtF4YlojJelwak1VLRxAkg6n1lTVwgiNEZL0eIc55phjnuTSYfyFOeaYY57kxgiNcXp0HjoxUZIevYdeGqHxxDSemMY4g+0+mG7A4KGVERojVNUS55hhhhnucGOiqhpwjhlmmGGGcyO0RqqqGWa+gqq6x70JGk9MY7cTIyTp7e80SW9PSTqc+IzWbpdJLn0dHd4lcSiNJ6ax3Z8OY1lVK59aYGW6ATMbyiOSdOhMUFUrWyTp0JlmqKrB0dG3VbZI0uGF6RZVtTJCkmv0dltU1RsbyhZJZnhpuhV+rKrBHpK8wu/297yqFtY0tvvBYfTo7G8wTm9Da7cBS/vr0fsCVXWf5By9x71E7xGt3V5X1a09Jenw3heqqpnPSPIMvUc0dhuMUFWDb6j1BZL0PhqqanAgSXofDVU1GKE1QpIec/TWJPm5qu5NlGSOM2uSXFXVrT01xunRe+gnEyXpceahCyO0vj/vEf9Y2ND6/vyCPzBU1cqG1jiD7T6YbrDdO2uqasC9RzRGqKol7rDECisscGuiqhrwGkussMIcvxqhNVJVXfpKquoGNyZoPDGt/5kkZU9VFRtau10neWZ/vc9IcoEXplsmuaoq61q79XjlcG4dxhneYGlNY7vBYQwYfGrloSAIgiAIgiAIguA9Bhta213hrekWVTX41HOcojPNfVUNjo6ODupvgEP4enJr/+IAAAAASUVORK5CYII=');
    background-size: cover;
  }
}
</style>
