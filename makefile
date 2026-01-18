# ---
# title: Makefile for obitanus-abitonus
# ---

# ---

TEXMF:=$(shell kpsewhich -var-value=TEXMFHOME)
DST:=$(TEXMF)/tex/latex
EXAMPLES:=examples/

.PHONY: help ln rm render compile build clean reset rebuild

help: ## Displays available targets with description
	@printf "Available targets for make:\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-13s: %s\n", $$1, $$2}'

# ---

# Package installation/removal

ln: ## Symlinks package into TEXMF
	@mkdir -p "$(DST)"
	@for package in src/*/; do \
		ln -sf "$${package}" "$(DST)/"; \
	done

cp: ## Copies package into TEXMF
	@mkdir -p "$(DST)"
	@for package in src/*/; do \
		cp -r "$${package}" "$(DST)/"; \
	done

rm: ## Removes package from TEXMF
	@for package in src/*/; do \
		rm -r "$(DST)/$$(basename "$${package}")/"; \
	done

# ---

# Example compilation

compile: ## Compiles filled templates
	@cd "$(EXAMPLES)" && latexmk

build: compile ## Compiles filled templates

clean: ## Removes intermediate compilation files
	@cd "$(EXAMPLES)" && latexmk -c

reset: ## Resets build directory
	@cd "$(EXAMPLES)" && latexmk -C

rebuild: reset build ## Executes reset and build
