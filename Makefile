####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################
help:
	@echo ""
	@echo "Please specify a target."
	@echo ""
	@echo "To make all projects:"
	@echo "    make all"
	@echo ""
	@echo "To build a specific project:"
	@echo "    make proj.board"
	@echo "e.g.,"
	@echo "    make adv7511.zed"


PROJECTS := $(filter-out $(NO_PROJ), $(shell ls projects))
define PROJECT_RULE
$1.$2:
	cd projects/$1/$2; $(MAKE)
endef
define APROJECT_RULE
	$(foreach archname,$(shell ls projects/$1), $(eval $(call PROJECT_RULE,$1,$(archname))))
endef
$(foreach projname,$(PROJECTS), $(eval $(call APROJECT_RULE,$(projname))))


.PHONY: lib all clean clean-all

lib:
	$(MAKE) -C library/ all


all:
	$(MAKE) -C projects/ all


clean:
	$(MAKE) -C projects/ clean


clean-all:clean
	$(MAKE) -C projects/ clean
	$(MAKE) -C library/ clean

####################################################################################
####################################################################################
