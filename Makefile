

.PHONY: tag
tag:
	@if [ "$(TAG)" != "" ]; then \
		git tag -f $(TAG); \
		git push -f github $(TAG); \
	fi

build:
	pnpm run build

demo_pack:
	mv dist yilog && mkdir -p dist/theme && mv yilog dist/theme
	cp daobox.yaml dist
	cp -r content dist/

demo:
	~/Coder/yiibox/daobox-server-next/wz-server/target/debug/daobox-site serve \
		--work-dir ./dist \
		--dist-dir ./dist 