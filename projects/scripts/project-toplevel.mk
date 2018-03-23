####################################################################################
## Copyright 2018(c) Analog Devices, Inc.
####################################################################################

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
