export interface IDownloadSource {
  caption: string
  url: string
}

export interface IDownloadItem {
  icon: string
  title: string
  version: string
  buttonText: string
  forMobile?: boolean // 移动端可用
  mobileButtonText?: string
  onlyDesktop?: boolean // 仅在桌面可用
  downloadSource: IDownloadSource[]
  invalidationTips?: string
  invalidationHelp?: string
}
