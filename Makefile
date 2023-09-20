

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

theme-dist: build
	if [ -d yilog ]; then rm -rf yilog ; fi
	mv dist yilog
	zip -r yilog.zip ./yilog

demo-mock-struct: build
	mv dist yilog && mkdir -p dist/theme && mv yilog dist/theme
	cp -r content dist/
	cp dist/theme/yilog/daobox.yaml dist/

demo_l:
	~/Coder/yiibox/daobox-server-next/wz-server/target/debug/daobox-publish serve \
		--work-dir ./dist \
		--dist-dir ./dist 
export_l:
	DAOBOX_LOG=info,daobox_publish=trace ~/Coder/yiibox/daobox-server-next/wz-server/target/debug/daobox-publish serve \
		--work-dir ./dist \
		--dist-dir ./dist --export

demo-web:
	daobox-publish web --work-dir ./dist-pages

demo-dist: demo-mock-struct
	daobox-publish serve --work-dir ./dist --dist-dir=dist-pages --export

