.PHONY: build
## Build the book
build: writing-gleam/command-line-reference.md
	rm -fr book
	mdbook build --dest-dir book/

.PHONY: serve
## Run the book dev server
serve:
	jekyll server --watch --safe --port 3000 --drafts

.PHONY: help
help:
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

writing-gleam/command-line-reference.md: writing-gleam/command-line-reference.sh
	sh writing-gleam/command-line-reference.sh > writing-gleam/command-line-reference.md
