####################################################################################
## Copyright (c) 2024 Analog Devices, Inc.
## SPDX short identifier: BSD-1-Clause
####################################################################################

LATTICE_IP_TOOL := tclsh

CYGPATH_VERSION := $(shell command -v cygpath --version)

ifneq ($(CYGPATH_VERSION),)
LATTICE_INTERFACE_PATH := $(shell cygpath -H)/$(shell whoami)/PropelIPLocal/interfaces
LATTICE_IP_PATH := $(shell cygpath -H)/$(shell whoami)/PropelIPLocal
else
LATTICE_INTERFACE_PATH := ~/PropelIPLocal/interfaces
LATTICE_IP_PATH := ~/PropelIPLocal
endif
