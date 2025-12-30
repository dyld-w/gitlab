.PHONY: upload upload-dev upload-prod clean

SUFFIX ?=
VERSION_SUFFIX ?=

upload:
	@# Generate maubot.yaml from template
	@sed 's/{{SUFFIX}}/$(SUFFIX)/g; s/{{VERSION_SUFFIX}}/$(VERSION_SUFFIX)/g' \
		maubot.yaml.template > maubot.yaml
	@# Create module symlink if needed
	@if [ -n "$(SUFFIX)" ] && [ ! -e "gitlab_matrix$(SUFFIX)" ]; then \
		ln -s gitlab_matrix "gitlab_matrix$(SUFFIX)"; \
	fi
	mbc build -u
	@# Cleanup symlink
	@if [ -n "$(SUFFIX)" ] && [ -L "gitlab_matrix$(SUFFIX)" ]; then \
		rm "gitlab_matrix$(SUFFIX)"; \
	fi

upload-prod:
	$(MAKE) upload SUFFIX= VERSION_SUFFIX=

upload-dev:
	$(MAKE) upload SUFFIX=_testing VERSION_SUFFIX=-dev

clean:
	rm -f maubot.yaml *.mbp gitlab_matrix_testing
