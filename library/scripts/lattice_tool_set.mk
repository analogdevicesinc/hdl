####################################################################################
## Copyright (c) 2024 Analog Devices, Inc.
## SPDX short identifier: BSD-1-Clause
####################################################################################

ifeq ($(OS), Windows_NT)
	PROPEL_BUILDER := propelbld
else
	PROPEL_BUILDER := propelbldwrap
endif

PROPEL_BUILDER_PATH := $(shell command -v $(PROPEL_BUILDER))

ifneq ($(PROPEL_BUILDER_PATH),)
	ifneq ($(wildcard $(HDL_LIBRARY_PATH)/scripts/propel_ip_paths.pth),)
		PROPEL_IP_LOCAL_PATHS := $(shell cat $(HDL_LIBRARY_PATH)/scripts/propel_ip_paths.pth)
	endif

	ifeq ($(PROPEL_IP_LOCAL_PATHS),)
		PROPEL_IP_LOCAL_PATHS := $(shell ${PROPEL_BUILDER} $(HDL_LIBRARY_PATH)scripts/adi_ip_paths_lattice.tcl $(HDL_LIBRARY_PATH)scripts/propel_ip_paths.pth)
	endif

	ifneq ($(PROPEL_IP_LOCAL_PATHS),)
		LATTICE_INTERFACE_PATH := $(word 1, $(PROPEL_IP_LOCAL_PATHS))
		LATTICE_IP_PATH := $(word 2, $(PROPEL_IP_LOCAL_PATHS))
		PROPEL_BUILDER := tclsh
	endif
endif
