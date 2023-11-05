.PHONY: tag
tag:
	@if [ "$(TAG)" != "" ]; then \
		git tag -f $(TAG); \
		git push -f origin $(TAG); \
	fi

	
dev:
	@EVERKM_LOG=info \
		everkm-publish serve \
		--dev-dir ./ \
		--listen=0.0.0.0:9081

work:
	@EVERKM_LOG=info \
		everkm-publish serve \
		--work-dir ./ \
		--listen=0.0.0.0:9081

build-pages:
	@EVERKM_LOG=info \
		everkm-publish serve \
		--dev-dir ./ \
		--export

fe-env-init:
	pnpm i

fe-dev:
	pnpm run dev

fe-build:
	pnpm run build

dist: fe-build build-pages


preview:
	@everkm-publish web \
		--work-dir dist


package-theme:
	@EVERKM_LOG=info \
		everkm-publish package-theme \
		--dev-dir ./ 

dist-theme: fe-build package-theme
	@if [ ! -d theme/dev ]; then mkdir -p theme/dev; fi
	@cp -r dist/* theme/dev/

