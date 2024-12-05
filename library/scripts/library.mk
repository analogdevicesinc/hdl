####################################################################################
## Copyright (c) 2018 - 2025 Analog Devices, Inc.
## SPDX short identifier: BSD-1-Clause
####################################################################################

# Assumes this file is in library/scripts/library.mk
HDL_LIBRARY_PATH := $(subst scripts/library.mk,,$(lastword $(MAKEFILE_LIST)))

include $(HDL_LIBRARY_PATH)../quiet.mk
include $(HDL_LIBRARY_PATH)scripts/lattice_tool_set.mk

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

ifneq ($(LATTICE_DEPS),)
	LATTICE_CLEAN_TARGET += ./*.log
	LATTICE_CLEAN_TARGET += ltt
	ifeq ($(LATTICE_DEFAULT_PATHS),1)
		LATTICE_CLEAN_TARGET += ${LATTICE_DEFAULT_IP_PATH}/${LIBRARY_NAME}
	endif
endif

GENERIC_DEPS += $(HDL_LIBRARY_PATH)../scripts/adi_env.tcl

.PHONY: all intel xilinx lattice clean clean-all ltt-interfaces clean-ltt-interfaces

all: intel xilinx lattice

clean: clean-all clean-ltt-interfaces

clean-all:
	$(call clean, \
		$(CLEAN_TARGET) $(LATTICE_CLEAN_TARGET) .lock, \
		$(HL)$(LIBRARY_NAME)$(NC) library)
	@for lib in $(XILINX_LIB_DEPS); do \
		$(MAKE) -C $(HDL_LIBRARY_PATH)$${lib} clean; \
	done

ifneq ($(INTEL_DEPS),)

INTEL_DEPS += $(GENERIC_DEPS)
INTEL_DEPS += $(EXTERNAL_DEPS)
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
XILINX_DEPS += $(EXTERNAL_DEPS)
XILINX_DEPS += $(HDL_LIBRARY_PATH)scripts/adi_ip_xilinx.tcl
_XILINX_LIB_DEPS = $(foreach dep,$(XILINX_LIB_DEPS),$(HDL_LIBRARY_PATH)$(dep)/component.xml)
_XILINX_INTF_DEPS = $(foreach dep,$(XILINX_INTERFACE_DEPS),$(HDL_LIBRARY_PATH)$(dep))

xilinx: external_dependencies component.xml

external_dependencies: external_dependencies_cleanup $(EXTERNAL_DEPS)

external_dependencies_cleanup:
	rm -f missing_external.log

$(EXTERNAL_DEPS):
	if [ ! -d $@ ]; then \
		echo $@ >> missing_external.log ; \
	fi

.DELETE_ON_ERROR:

component.xml: $(XILINX_DEPS) $(_XILINX_INTF_DEPS) $(_XILINX_LIB_DEPS)
	$(call skip_if_missing, \
		Library, \
		$(LIBRARY_NAME), \
		true, \
	rm -rf $(CLEAN_TARGET) ; \
	$(call build, \
		$(VIVADO) $(LIBRARY_NAME)_ip.tcl, \
		$(LIBRARY_NAME)_ip.log, \
		$(HL)$(LIBRARY_NAME)$(NC) library))

$(_XILINX_INTF_DEPS):
	$(MAKE) -C $(dir $@) $(notdir $@)
FORCE:
$(_XILINX_LIB_DEPS): FORCE
	flock $(dir $@).lock -c "$(MAKE) -C $(dir $@) xilinx"; exit $$?

%.xml:
	$(MAKE) -C $(dir $@) $(notdir $@)
endif

ifneq ($(LATTICE_DEPS),)

LATTICE_DEPS += $(GENERIC_DEPS)
LATTICE_DEPS += $(HDL_LIBRARY_PATH)scripts/adi_ip_lattice.tcl
_LATTICE_INTF_DEPS := $(foreach dep,$(LATTICE_INTERFACE_DEPS),$(HDL_LIBRARY_PATH)$(dep))

LATTICE_TARGETS := ./ltt/metadata.xml
ifeq ($(LATTICE_DEFAULT_PATHS),1)
LATTICE_TARGETS += $(LATTICE_DEFAULT_IP_PATH)/$(LIBRARY_NAME)/metadata.xml
endif

lattice: ltt-interfaces $(LATTICE_TARGETS)

.DELETE_ON_ERROR:

$(LATTICE_TARGETS): $(LATTICE_DEPS)
	$(call skip_if_missing, \
		Library, \
		$(LIBRARY_NAME), \
		true, \
	rm -rf $(LATTICE_CLEAN_TARGET) ; \
	$(call build, \
		$(LATTICE_IP_TOOL) $(LIBRARY_NAME)_ltt.tcl, \
		$(LIBRARY_NAME)_ltt.log, \
		$(HL)$(LIBRARY_NAME)$(NC) library))

ltt-interfaces:
	$(foreach dep,$(_LATTICE_INTF_DEPS), \
		flock $(dep)/.lock sh -c "$(MAKE) -C $(dep)"; exit $$?)

clean-ltt-interfaces:
	$(foreach dep,$(_LATTICE_INTF_DEPS),$(MAKE) -C $(dep) clean-all;)

endif
