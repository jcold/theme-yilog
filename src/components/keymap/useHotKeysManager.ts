import {inject, onUnmounted, provide} from 'vue'
import {HotKeysManager} from './HotKeysManager'

export const HOT_KEYS_MGR = Symbol('hot keys manager')

export function useHotKeysMangerProvide() {
  const mgr = new HotKeysManager()
  provide(HOT_KEYS_MGR, mgr)

  onUnmounted(() => {
    mgr.destroy()
  })

  return {
    hotKeysManager: mgr,
  }
}

export function injectHotKeysManager() {
  return inject(HOT_KEYS_MGR) as HotKeysManager
}
