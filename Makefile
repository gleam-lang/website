.PHONY: build
build: ## Build the book
	rm -fr book
	mdbook build --dest-dir book/

.PHONY: serve
serve: ## Run the book dev server
	jekyll server --watch --safe --port 3000 --livereload --drafts

.PHONY: help
help:
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
