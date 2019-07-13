DOCKER_IMG_TAG := 0.0.2
PERLCRITIC_TARGET_PATH := src

.PHONY: build
build:
	docker build . -t perlcritic_reviewdog:${DOCKER_IMG_TAG}

.PHONY: build_no_cache
build_no_cache:
	docker build . -t perlcritic_reviewdog:${DOCKER_IMG_TAG} --no-cache

.PHONY: run
run:
	docker run -it --rm perlcritic_reviewdog:${DOCKER_IMG_TAG} /bin/bash

.PHONY: perlcritic
perlcritic:
	docker run -it --rm perlcritic_reviewdog:${DOCKER_IMG_TAG} /bin/bash -c \
		"carton exec perlcritic --severity=1 --verbose='%f:%l:%c:**%m**, near <code>%r</code>.<br>(Ref: [%p](https://metacpan.org/pod/Perl::Critic::Policy::%p))\n' ${PERLCRITIC_TARGET_PATH}"

.PHONY: reviewdog
reviewdog:
	docker run -it --rm perlcritic_reviewdog:${DOCKER_IMG_TAG} /bin/bash -c \
		"carton exec perlcritic --severity=1 --verbose='%f:%l:%c:**%m**, near <code>%r</code>.<br>(Ref: [%p](https://metacpan.org/pod/Perl::Critic::Policy::%p))\n' ${PERLCRITIC_TARGET_PATH} \
		| reviewdog -efm=%f:%l:%c:%m -name=perlcritic -diff='git diff master'"
