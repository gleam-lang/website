.PHONY: build
build: docs/book/index.html ## Build the book

.PHONY: serve
serve: ## Run the book dev server
	mdbook serve --open --websocket-port 4200

.PHONY: help
help:
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

#
# Files
#

docs/book/index.html: $(shell find book -type f)
	rm -fr docs/book
	mdbook build --dest-dir docs/book/
