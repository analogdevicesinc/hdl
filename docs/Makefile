SHELL         = /bin/bash
SPHINXOPTS   ?=
SPHINXBUILD  ?= sphinx-build
SOURCEDIR     = .
BUILDDIR      = _build

help:
	@echo "For help about the container instance, do \`make container-help\`"
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

#------------------------------------------------------------------------------
# Container commands
#------------------------------------------------------------------------------

CONTAINER_IMG      ?=hdl-docs
CONTAINER_ENGINE    =podman
CONTAINER_REPO      =${CONTAINER_IMG}
CONTAINER_IMAGE     =${CONTAINER_IMG}_build
CONTAINER_VERSION   ?=0.1
CONTAINER_SHELL     ?=bash -l
CONTAINER_RUN_EXTRA ?=
CONTAINER_FORMAT     =$(if $(filter podman,${CONTAINER_ENGINE}),--format docker,)

IF_CONTAINER_RUNS=$(shell ${CONTAINER_ENFINE} container inspect -f '{{.State.Running}}' ${CONTAINER_IMAGE} 2>/dev/null)

CONTAINER_RUN_PARAMS = -it --rm --name=${CONTAINER_IMG} \
		--name=${CONTAINER_IMAGE} \
		--workdir=/${CONTAINER_IMG} \
		--mount type=bind,source=${CURDIR}/../,target=/${CONTAINER_IMG} \
		${CONTAINER_RUN_EXTRA} \
		${CONTAINER_REPO}/${CONTAINER_IMAGE}:${CONTAINER_VERSION}

container-login:
	@if [ "${IF_CONTAINER_RUNS}" != "true" ]; then \
		${CONTAINER_ENGINE} run ${CONTAINER_RUN_PARAMS} \
			${CONTAINER_SHELL}; \
	else \
		${CONTAINER_ENGINE} exec -it ${CONTAINER_IMAGE} \
			${CONTAINER_SHELL}; \
	fi

container-build:
	@printf "Building container image\n"
	@${CONTAINER_ENGINE} build --no-cache=true ${CONTAINER_FORMAT} -t ${CONTAINER_REPO}/${CONTAINER_IMAGE}:${CONTAINER_VERSION} -f ./Containerfile .


container-html:
	@${CONTAINER_ENGINE} run ${CONTAINER_RUN_PARAMS} ${CONTAINER_SHELL} -c \
		"source /.venv/bin/activate ; cd docs ; make html"

container-pdf:
	@${CONTAINER_ENGINE} run ${CONTAINER_RUN_PARAMS} ${CONTAINER_SHELL} -c \
		"source /.venv/bin/activate ; cd docs ; make latexpdf"

container-clean:
	@${CONTAINER_ENGINE} run ${CONTAINER_RUN_PARAMS} ${CONTAINER_SHELL} -c \
		"source /.venv/bin/activate ; cd docs ; make clean"

.PHONY: container-build container-login container-html container-pdf container-clean

container-help:
	@printf "The container commands allow to use a container to build the documentation.\n"
	@printf "Both podman and docker are supported, change the CONTAINER_ENGINE variable to select which to use.\n\n"
	@printf "Usage: make [options]\n"
	@printf "\
Options:\n\
	container-build       Build the container image with dependencies (do once).\n\
	container-login       Access the container shell.\n\
	container-html        Build html documentation.\n\
	container-latexpdf    Build pdf documentation.\n\
\n"
