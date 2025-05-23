####################################################################################
## Copyright (c) 2025 Analog Devices, Inc.
## SPDX short identifier: BSD-1-Clause
####################################################################################

LATTICE_IP_TOOL := tclsh

CYGPATH_VERSION := $(shell command -v cygpath --version)

ifeq ($(LATTICE_DEFAULT_PATHS),1)
ifneq ($(CYGPATH_VERSION),)
LATTICE_DEFAULT_INTERFACE_PATH := $(shell cygpath -H)/$(shell whoami)/PropelIPLocal/interfaces
LATTICE_DEFAULT_IP_PATH := $(shell cygpath -H)/$(shell whoami)/PropelIPLocal
else
LATTICE_DEFAULT_INTERFACE_PATH := ~/PropelIPLocal/interfaces
LATTICE_DEFAULT_IP_PATH := ~/PropelIPLocal
endif
endif
