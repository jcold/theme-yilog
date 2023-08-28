# @VITE_RELEASE=prod ~/.cargo/bin/daobox-site serve \

serve:
	@VITE_RELEASE=prod RUST_BACKTRACE=1 DAOBOX_LOG=debug ~/Coder/yiibox/daobox-server-next/wz-server/target/debug/daobox-site serve \
		--content-dir ./content \
		--base-prefix /site \
		--dist-dir ./dist \
		--dev-dir ./src \
		--listen=0.0.0.0:9081

export-all:
	@~/.cargo/bin/daobox-site serve \
		--content-dir ./content \
		--dev-dir ./src \
		--dist-dir ./dist \
		--cdn-prefix https://assets.daobox.cc/daobox-site/ \
		--base-prefix /site \
		--export

package-tpls:
	@~/.cargo/bin/daobox-site package-tpls \
		--dev-dir ./src \
		--dist-dir ./dist \
		--with-tpls

preview:
	@~/.cargo/bin/daobox-site serve \
		--base-prefix /site 

publish:
	@~/.cargo/bin/daobox-site serve \
		--base-prefix /site \
		--theme-dir ./theme/forever \
		--export

fe-dev:
	pnpm run dev

fe-build:
	pnpm run build

dist: fe-build export-all

dist-tpls: fe-build package-tpls

sync-fe:
	./sync_fe_dev_2.sh /Users/dayu/Coder/yiibox/daobox_fe


.PHONY: tag
tag:
	@if [ "$(TAG)" != "" ]; then \
		git tag -f $(TAG); \
		git push -f github $(TAG); \
	fi