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

.PHONY: clean watch deps

.DEFAULT_GOAL: $(BUILD_DIR)/site
