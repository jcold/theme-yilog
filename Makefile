ifneq (, $(shell echo $$DEBUG))
  EKMP = "/Users/dayu/Coder/everkm/everkm2/be/everkm-publish/target/debug/everkm-publish"
else
  EKMP = ./node_modules/.bin/everkm-publish
endif


.PHONY: tag
tag:
	@if [ "$(TAG)" != "" ]; then \
		git tag -f $(TAG); \
		git push -f origin $(TAG); \
	fi

	
dev:
	@echo Use everkm-publish $(EKMP)
	@EVERKM_LOG=info,everkm_publish=debug \
		$(EKMP) serve \
		--work-dir ./demo_posts \
		--dev-dir ./ \
		--listen=0.0.0.0:9081

work:
	@EVERKM_LOG=info \
		$(EKMP) serve \
		--work-dir ./demo_posts \
		--listen=0.0.0.0:9081

build-pages:
	@EVERKM_LOG=info \
		$(EKMP) serve \
		--work-dir ./demo_posts \
		--dev-dir ./ \
		--export

fe-env-init:
	pnpm i

fe-dev:
	pnpm run dev

fe-build:
	pnpm run build

dist-pages: fe-build build-pages

sync-config:
	@cp everkm-theme.yaml demo_posts/_everkm-theme.inc.yaml
	@cp everkm.yaml demo_posts/_everkm.inc.yaml


preview:
	@$(EKMP) web \
		--work-dir dist

# 复制 theme 相关的文件到发布目录，不包含前端项目构建产物
package-theme:
	@echo Use everkm-publish: $(EKMP)
	@$(EKMP) theme package --dev-dir ./ 

# 发布 theme, 包含前端构建产物
dist-theme: fe-build package-theme
	@if [ -e __everkm/theme/dev ]; then rm -rf __everkm/theme/dev; fi
	@mkdir -p __everkm/theme/dev
	@cp -r dist/* __everkm/theme/dev/

# 打包 theme
bundle-theme: 
	@cd __everkm/theme && \
		if [ -d yilog ]; then rm -rf yilog ; fi && \
		mv dev yilog && \
		zip -r yilog.zip ./yilog
