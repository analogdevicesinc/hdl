####################################################################################
## Copyright 2018(c) Analog Devices, Inc.
####################################################################################

# Assumes this file is in library/scripts/library.mk
HDL_LIBRARY_PATH := $(subst scripts/library.mk,,$(lastword $(MAKEFILE_LIST)))

VIVADO := vivado -mode batch -source

CLEAN_TARGET := *.cache
CLEAN_TARGET += *.data
CLEAN_TARGET += *.xpr
CLEAN_TARGET += *.log
CLEAN_TARGET += component.xml
CLEAN_TARGET += *.jou
CLEAN_TARGET +=  xgui
CLEAN_TARGET += *.ip_user_files
CLEAN_TARGET += *.srcs
CLEAN_TARGET += *.hw
CLEAN_TARGET += *.sim
CLEAN_TARGET += .Xil

M_DEPS += $(HDL_LIBRARY_PATH)scripts/adi_env.tcl
M_DEPS += $(HDL_LIBRARY_PATH)scripts/adi_ip.tcl

M_DEPS += $(foreach dep,$(LIB_DEPS),$(HDL_LIBRARY_PATH)$(dep)/$(notdir $(dep)).xpr)

.PHONY: all dep clean clean-all
all: dep $(LIBRARY_NAME).xpr

clean: clean-all

clean-all:
	rm -rf $(CLEAN_TARGET)

$(LIBRARY_NAME).xpr: $(M_DEPS)
	-rm -rf $(CLEAN_TARGET)
	$(VIVADO) $(LIBRARY_NAME)_ip.tcl  >> $(LIBRARY_NAME)_ip.log 2>&1

dep:
	@for lib in $(LIB_DEPS); do \
		$(MAKE) -C $(HDL_LIBRARY_PATH)$${lib} || exit $$?; \
	done
	@for intf in $(INTERFACE_DEPS); do \
		$(MAKE) -C $(HDL_LIBRARY_PATH)$${intf} || exit $$?; \
	done
