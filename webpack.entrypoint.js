function getEntrypoint() {
  return {
    main: ['./src/main.ts'],
    // download: ['./src/download.ts'],
    // app_download: ['./src/app_download/app_download.ts'],
    // book: ['./src/book.ts'],
  }
}

module.exports = {
  getEntrypoint,
}
