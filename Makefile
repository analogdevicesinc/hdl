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
	@echo "    make fmcomms1.zed"


PROJECTS := $(filter-out $(NO_PROJ), $(shell ls projects))
define PROJECT_RULE
$1.$2:
	cd projects/$1/$2; make
endef
define APROJECT_RULE
	$(foreach archname,$(shell ls projects/$1), $(eval $(call PROJECT_RULE,$1,$(archname))))
endef
$(foreach projname,$(PROJECTS), $(eval $(call APROJECT_RULE,$(projname))))


.PHONY: lib all clean clean-all

lib:
	make -C library/ all


all:
	make -C projects/ all


clean:
	make -C projects/ clean


clean-all:clean
	make -C projects/ clean
	make -C library/ clean

####################################################################################
####################################################################################
