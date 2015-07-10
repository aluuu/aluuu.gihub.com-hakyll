BUILD_DIR = ./dist/build/site

./.cabal-sandbox:
	cabal sandbox init

$(BUILD_DIR)/site: deps
	cabal configure && cabal build

deps: ./.cabal-sandbox
	cabal install --only-dependencies

clean:
	$(BUILD_DIR)/site clean && rm -r $(BUILD_DIR)

watch: $(BUILD_DIR)/site
	$(BUILD_DIR)/site watch

build: $(BUILD_DIR)/site
	$(BUILD_DIR)/site build

clean-gh-pages:
	rm -rf ./.gh-pages

gh-pages: clean-gh-pages build
	git clone `git config --get remote.origin.url` .gh-pages --reference .
	git -C .gh-pages checkout --orphan gh-pages
	git -C .gh-pages reset
	git -C .gh-pages clean -dxf
	cp -r _site/* .gh-pages/
	git -C .gh-pages add .
	git -C .gh-pages commit -m "Update Pages"
	git -C .gh-pages push origin gh-pages -f
	rm -rf .gh-pages

.PHONY: clean watch deps

.DEFAULT_GOAL: $(BUILD_DIR)/site
