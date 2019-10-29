.PHONY: build
build: docs/index.html ## Build the book

.PHONY: serve
serve: ## Run the book dev server
	mdbook serve --open --websocket-port 4200

.PHONY: help
help:
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

#
# Files
#

docs/index.html: $(shell find src -type f)
	rm -fr docs
	mdbook build --dest-dir docs/
