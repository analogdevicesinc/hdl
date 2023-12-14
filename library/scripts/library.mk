####################################################################################
## Copyright (c) 2018 - 2023 Analog Devices, Inc.
## SPDX short identifier: BSD-1-Clause
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
CLEAN_TARGET +=  gui
CLEAN_TARGET += *.runs
CLEAN_TARGET += *.gen
CLEAN_TARGET += *.ip_user_files
CLEAN_TARGET += *.srcs
CLEAN_TARGET += *.hw
CLEAN_TARGET += *.sim
CLEAN_TARGET += .Xil
CLEAN_TARGET += .timestamp_intel
CLEAN_TARGET += *.hbs
CLEAN_TARGET += tb/*.log
CLEAN_TARGET += tb/*.xml
CLEAN_TARGET += tb/*.jou
CLEAN_TARGET += tb/*.dir
CLEAN_TARGET += tb/*.pb
CLEAN_TARGET += tb/*.vcd
CLEAN_TARGET += tb/*.wdb
CLEAN_TARGET += tb/dcv.
CLEAN_TARGET += tb/vsim.wlf
CLEAN_TARGET += tb/work
CLEAN_TARGET += tb/vcd
CLEAN_TARGET += tb/run
CLEAN_TARGET += tb/libraries
CLEAN_TARGET += tb/.Xil
CLEAN_TARGET += tb/xsim_gui_cmd.tcl
CLEAN_TARGET += tb/libraries

GENERIC_DEPS += $(HDL_LIBRARY_PATH)../scripts/adi_env.tcl

.PHONY: all intel xilinx clean clean-all

all: intel xilinx

clean: clean-all

clean-all:
	$(call clean, \
		$(CLEAN_TARGET) .lock, \
		$(HL)$(LIBRARY_NAME)$(NC) library)

ifneq ($(INTEL_DEPS),)

INTEL_DEPS += $(GENERIC_DEPS)
INTEL_DEPS += $(HDL_LIBRARY_PATH)scripts/adi_ip_intel.tcl
_INTEL_LIB_DEPS = $(foreach dep,$(INTEL_LIB_DEPS),$(HDL_LIBRARY_PATH)$(dep)/.timestamp_intel)

intel: .timestamp_intel

.timestamp_intel: $(INTEL_DEPS) $(_INTEL_LIB_DEPS)
	touch $@

$(_INTEL_LIB_DEPS):
	$(MAKE) -C $(dir $@) intel

endif

ifneq ($(XILINX_DEPS),)

XILINX_DEPS += $(GENERIC_DEPS)
XILINX_DEPS += $(HDL_LIBRARY_PATH)scripts/adi_ip_xilinx.tcl
_XILINX_LIB_DEPS = $(foreach dep,$(XILINX_LIB_DEPS),$(HDL_LIBRARY_PATH)$(dep)/component.xml)
_XILINX_INTF_DEPS = $(foreach dep,$(XILINX_INTERFACE_DEPS),$(HDL_LIBRARY_PATH)$(dep))

xilinx: component.xml

.DELETE_ON_ERROR:

component.xml: $(XILINX_DEPS) $(_XILINX_INTF_DEPS) $(_XILINX_LIB_DEPS)
	-rm -rf $(CLEAN_TARGET)
	$(call build, \
		$(VIVADO) $(LIBRARY_NAME)_ip.tcl, \
		$(LIBRARY_NAME)_ip.log, \
		$(HL)$(LIBRARY_NAME)$(NC) library)

$(_XILINX_INTF_DEPS):
	$(MAKE) -C $(dir $@) $(notdir $@)

$(_XILINX_LIB_DEPS):
	flock $(dir $@).lock -c "$(MAKE) -C $(dir $@) xilinx"; exit $$?

%.xml:
	$(MAKE) -C $(dir $@) $(notdir $@)
endif
