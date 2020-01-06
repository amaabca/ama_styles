.PHONY: all assets

all: app/assets/stylesheets/_design_tokens.scss assets

assets:
	BRANCH=master bin/assets staging build

app/assets/stylesheets/_design_tokens.scss:
	$(MAKE) -C design_tokens scss
