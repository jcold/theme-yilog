

.PHONY: tag
tag:
	@if [ "$(TAG)" != "" ]; then \
		git tag -f $(TAG); \
		git push -f github $(TAG); \
	fi

build:
	rm -rf dist
	pnpm install
	pnpm run build
	cp -r ./src/templates ./dist/templates
	cp daobox*.yaml dist

demo_pack: build
	mv dist yilog && mkdir -p dist/theme && mv yilog dist/theme
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

