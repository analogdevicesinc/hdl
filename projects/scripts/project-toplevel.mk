####################################################################################
## Copyright (c) 2018 - 2021 Analog Devices, Inc.
## SPDX short identifier: BSD-1-Clause
####################################################################################

# Assumes this file is in projects/scripts/project-toplevel.mk
HDL_PROJECT_PATH := $(subst scripts/project-toplevel.mk,,$(lastword $(MAKEFILE_LIST)))

include $(HDL_PROJECT_PATH)../quiet.mk

SUBDIRS := $(dir $(wildcard */Makefile))

# Create virtual targets "$project/all", "$project/clean", "$project/clean-all"
SUBDIRS_ALL := $(addsuffix all,$(SUBDIRS))
SUBDIRS_CLEAN := $(addsuffix clean,$(SUBDIRS))
SUBDIRS_CLEANALL := $(addsuffix clean-all,$(SUBDIRS))

.PHONY: all clean clean-all $(SUBDIRS_ALL) $(SUBDIRS_CLEAN) $(SUBDIRS_CLEANALL)

all: $(SUBDIRS_ALL)
clean: $(SUBDIRS_CLEAN)
clean-all: $(SUBDIRS_CLEANALL)

$(SUBDIRS_ALL) $(SUBDIRS_CLEAN) $(SUBDIRS_CLEANALL):
	$(MAKE) -C $(@D) $(@F)
