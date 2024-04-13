import {Ref, ref} from 'vue'

export enum LoadState {
  Init,
  Loaded,
  Completed,
}

export class StateChanger {
  private _state: Ref<LoadState> = ref(LoadState.Init)
  private _changedId = ref(0)

  public get state(): Ref<LoadState> {
    return this._state
  }

  public get changedId(): Ref<number> {
    return this._changedId
  }

  public hasMore(): boolean {
    return this._state.value !== LoadState.Completed
  }

  public loaded() {
    this._state.value = LoadState.Loaded
    this._changedId.value++
  }

  public complete() {
    this._state.value = LoadState.Completed
    // this._changedId.value++
  }

  public reset() {
    this._state.value = LoadState.Init
    this._changedId.value++
  }
}

export type TLoaderFn = (state: StateChanger) => Promise<void>
