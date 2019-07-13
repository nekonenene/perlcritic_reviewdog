DOCKER_IMG_TAG := 0.0.2
PERLCRITIC_TARGET_PATH := src

# for reviewdog_pr formula
REVIEWDOG_GITHUB_API_TOKEN :=
CI_PULL_REQUEST :=

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
	docker run -it --rm \
		-v $(shell pwd)/src:/home/perl/src \
		perlcritic_reviewdog:${DOCKER_IMG_TAG} /bin/bash -c \
			"carton exec perlcritic --severity=1 --verbose='%f:%l:%c:**%m**, near <code>%r</code>.<br>(Ref: [%p](https://metacpan.org/pod/Perl::Critic::Policy::%p))\n' ${PERLCRITIC_TARGET_PATH}"

.PHONY: reviewdog
reviewdog:
	docker run -it --rm \
		-v $(shell pwd)/src:/home/perl/src \
		perlcritic_reviewdog:${DOCKER_IMG_TAG} /bin/bash -c \
			"carton exec perlcritic --severity=1 --verbose='%f:%l:%c:**%m**, near <code>%r</code>.<br>(Ref: [%p](https://metacpan.org/pod/Perl::Critic::Policy::%p))\n' ${PERLCRITIC_TARGET_PATH} \
			| reviewdog -efm=%f:%l:%c:%m -name=perlcritic -diff='git diff master'"

.PHONY: reviewdog_pr
reviewdog_pr:
	docker run -it --rm \
		-e REVIEWDOG_GITHUB_API_TOKEN="${REVIEWDOG_GITHUB_API_TOKEN}" \
		-e CI_REPO_OWNER="nekonenene" \
		-e CI_REPO_NAME="perlcritic_reviewdog" \
		-e CI_COMMIT="$(shell git rev-parse HEAD)" \
		-e CI_PULL_REQUEST=${CI_PULL_REQUEST} \
		-v $(shell pwd)/src:/home/perl/src \
		perlcritic_reviewdog:${DOCKER_IMG_TAG} /bin/bash -c \
			"carton exec perlcritic --severity=1 --verbose='%f:%l:%c:**%m**, near <code>%r</code>.<br>(Ref: [%p](https://metacpan.org/pod/Perl::Critic::Policy::%p))\n' ${PERLCRITIC_TARGET_PATH} \
			| reviewdog -efm=%f:%l:%c:%m -name=perlcritic -reporter=github-pr-review"
