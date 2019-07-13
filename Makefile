.PHONY: build
build:
	docker build . -t perlcritic_reviewdog:0.0.1

.PHONY: run
run:
	docker run -it --rm perlcritic_reviewdog:0.0.1 /bin/bash
