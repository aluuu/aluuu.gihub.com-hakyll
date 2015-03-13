./dist/build/site/site: deps
	cabal configure && cabal build

deps:
	cabal install --only-dependencies

clean:
	./dist/build/site/site clean && rm -r ./dist ./site.o ./site.hi

watch: ./dist/build/site/site
	./site watch

.PHONY: clean watch deps

.DEFAULT_GOAL: ./dist/build/site/site