.PHONY: all scss assets

all: scss assets

assets:
	BRANCH=master bin/assets staging build

scss:
	$(MAKE) -C design_tokens scss
