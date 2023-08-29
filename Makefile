

.PHONY: tag
tag:
	@if [ "$(TAG)" != "" ]; then \
		git tag -f $(TAG); \
		git push -f github $(TAG); \
	fi

build:
	pnpm install
	pnpm run build

demo_pack:
	mv dist yilog && mkdir -p dist/theme && mv yilog dist/theme
	cp daobox.yaml dist
	cp -r content dist/

demo_l:
	~/Coder/yiibox/daobox-server-next/wz-server/target/debug/daobox-site serve \
		--work-dir ./dist \
		--dist-dir ./dist 
export_l:
	DAOBOX_LOG=info,daobox_site=trace ~/Coder/yiibox/daobox-server-next/wz-server/target/debug/daobox-site serve \
		--work-dir ./dist \
		--dist-dir ./dist --export

demo:
	daobox-site serve \
		--work-dir ./dist \
		--dist-dir ./dist 

demo-pages: build demo_pack
	daobox-site serve --work-dir ./dist --dist-dir=dist-pages --export

