####################################################################################
## Copyright 2018(c) Analog Devices, Inc.
####################################################################################

# Assumes this file is in library/scripts/library.mk
HDL_LIBRARY_PATH := $(subst scripts/library.mk,,$(lastword $(MAKEFILE_LIST)))

include $(HDL_LIBRARY_PATH)../quiet.mk

CASE_INCLUDE := $(wildcard temporary_case_dependencies.mk)
ifneq ($(CASE_INCLUDE),)
  include temporary_case_dependencies.mk
endif

VIVADO := vivado -mode batch -source

CLEAN_TARGET += *.cache
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
CLEAN_TARGET += .timestamp_intel

GENERIC_DEPS += $(HDL_LIBRARY_PATH)scripts/adi_env.tcl

.PHONY: all intel intel_dep xilinx xilinx_dep clean clean-all

all: intel xilinx

clean: clean-all

clean-all:
	$(call clean, \
		$(CLEAN_TARGET), \
		$(HL)$(LIBRARY_NAME)$(NC) library)

ifneq ($(INTEL_DEPS),)

INTEL_DEPS += $(GENERIC_DEPS)
INTEL_DEPS += $(HDL_LIBRARY_PATH)scripts/adi_ip_intel.tcl
INTEL_DEPS += $(foreach dep,$(INTEL_LIB_DEPS),$(HDL_LIBRARY_PATH)$(dep)/.timestamp_intel)

intel: intel_dep .timestamp_intel

.timestamp_intel: $(INTEL_DEPS)
	touch $@

intel_dep:
	@for lib in $(INTEL_LIB_DEPS); do \
		$(MAKE) -C $(HDL_LIBRARY_PATH)$${lib} intel || exit $$?; \
	done
endif

ifneq ($(XILINX_DEPS),)

XILINX_DEPS += $(GENERIC_DEPS)
XILINX_DEPS += $(HDL_LIBRARY_PATH)scripts/adi_ip_xilinx.tcl
XILINX_DEPS += $(foreach dep,$(XILINX_LIB_DEPS),$(HDL_LIBRARY_PATH)$(dep)/component.xml)

xilinx: xilinx_dep component.xml

component.xml: $(XILINX_DEPS)
	-rm -rf $(CLEAN_TARGET)
	$(call build, \
		$(VIVADO) $(LIBRARY_NAME)_ip.tcl, \
		$(LIBRARY_NAME)_ip.log, \
		$(HL)$(LIBRARY_NAME)$(NC) library)

xilinx_dep:
	@for lib in $(XILINX_LIB_DEPS); do \
		$(MAKE) -C $(HDL_LIBRARY_PATH)$${lib} xilinx || exit $$?; \
	done
	@for intf in $(XILINX_INTERFACE_DEPS); do \
		$(MAKE) -C $(HDL_LIBRARY_PATH)$${intf} xilinx || exit $$?; \
	done
endif
