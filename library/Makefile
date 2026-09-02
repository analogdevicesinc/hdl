####################################################################################
####################################################################################
## Copyright (c) 2018 - 2024 Analog Devices, Inc.
### SPDX short identifier: BSD-1-Clause
## Auto-generated, do not modify!
####################################################################################
####################################################################################

include ../quiet.mk

.PHONY: all lib lib-intel lib-xilinx lib-lattice clean clean-all
all: lib

_LIBS := $(dir $(shell find . -mindepth 2 -name Makefile | sort))

# Create virtual targets "$library/all", "$library/clean"
_LIBS_ALL := $(addsuffix all, $(_LIBS))
_LIBS_INTEL := $(addsuffix intel, $(filter-out %_ltt/, $(_LIBS)))
_LIBS_XILINX := $(addsuffix xilinx, $(filter-out %_ltt/, $(_LIBS)))
_LIBS_LATTICE := $(addsuffix lattice, $(_LIBS))
_LIBS_CLEAN := $(addsuffix clean, $(_LIBS))

$(_LIBS_ALL) $(_LIBS_INTEL) $(_LIBS_XILINX) $(_LIBS_LATTICE):
	$(MAKE) -C $(@D) $(@F)

$(_LIBS_CLEAN):
	$(MAKE) -C $(@D) $(@F)

clean: $(_LIBS_CLEAN)
clean-all: clean

lib: $(_LIBS_ALL)
lib-intel: $(_LIBS_INTEL)
lib-xilinx: $(_LIBS_XILINX)
lib-lattice: $(_LIBS_LATTICE)

####################################################################################
####################################################################################
