.PHONY: build
build: book/book.js ## Build the book

.PHONY: serve
serve: ## Run the book dev server
	jekyll server --watch --safe --port 3000 --host 0.0.0.0 --livereload --drafts

.PHONY: help
help:
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

#
# Files
#

book/book.js: $(shell find book -type f)
	rm -fr book
	mdbook build --dest-dir book/
