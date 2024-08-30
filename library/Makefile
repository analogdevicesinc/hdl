####################################################################################
####################################################################################
## Copyright (c) 2018 - 2024 Analog Devices, Inc.
### SPDX short identifier: BSD-1-Clause
## Auto-generated, do not modify!
####################################################################################
####################################################################################

include ../quiet.mk

.PHONY: all lib clean clean-all
all: lib

_LIBS := $(dir $(shell find . -mindepth 2 -name Makefile | sort))

# Create virtual targets "$library/all", "$library/clean"
_LIBS_ALL := $(addsuffix all, $(_LIBS))
_LIBS_CLEAN := $(addsuffix clean, $(_LIBS))

$(_LIBS_ALL):
	$(MAKE) -C $(@D) $(@F)

$(_LIBS_CLEAN):
	$(MAKE) -C $(@D) $(@F)

clean: $(_LIBS_CLEAN)
clean-all: clean

lib: $(_LIBS_ALL)

####################################################################################
####################################################################################
