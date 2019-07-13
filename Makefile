DOCKER_IMG_TAG := 0.0.1

.PHONY: build
build:
	docker build . -t perlcritic_reviewdog:${DOCKER_IMG_TAG}

.PHONY: run
run:
	docker run -it --rm perlcritic_reviewdog:${DOCKER_IMG_TAG} /bin/bash

.PHONY: perlcritic
perlcritic:
	docker run -it --rm perlcritic_reviewdog:${DOCKER_IMG_TAG} /bin/bash -c \
		"carton exec perlcritic --severity=1 --verbose='%f:%l:%c:**%m**, near <code>%r</code>.<br>(Ref: [%p](https://metacpan.org/pod/Perl::Critic::Policy::%p))\n' *.pl"

.PHONY: reviewdog
reviewdog:
	docker run -it --rm perlcritic_reviewdog:${DOCKER_IMG_TAG} /bin/bash -c \
		"carton exec perlcritic --severity=1 --verbose='%f:%l:%c:**%m**, near <code>%r</code>.<br>(Ref: [%p](https://metacpan.org/pod/Perl::Critic::Policy::%p))\n' *.pl \
		| reviewdog -efm=%f:%l:%c:%m -name=perlcritic -diff='git diff master'"
