####################################################################################
## Copyright 2018(c) Analog Devices, Inc.
####################################################################################

# Assumes this file is in prpojects/scripts/project-xilinx.mk
HDL_PROJECT_PATH := $(subst scripts/project-xilinx.mk,,$(lastword $(MAKEFILE_LIST)))
HDL_LIBRARY_PATH := $(HDL_PROJECT_PATH)../library/

include $(HDL_PROJECT_PATH)../quiet.mk

VIVADO := vivado -mode batch -source

CLEAN_TARGET := *.cache
CLEAN_TARGET += *.data
CLEAN_TARGET += *.xpr
CLEAN_TARGET += *.log
CLEAN_TARGET += *.jou
CLEAN_TARGET +=  xgui
CLEAN_TARGET += *.runs
CLEAN_TARGET += *.srcs
CLEAN_TARGET += *.sdk
CLEAN_TARGET += *.hw
CLEAN_TARGET += *.sim
CLEAN_TARGET += .Xil
CLEAN_TARGET += *.ip_user_files
CLEAN_TARGET += *.str

# Common dependencies that all projects have
M_DEPS += system_project.tcl
M_DEPS += system_bd.tcl
M_DEPS += $(wildcard system_top*.v)
M_DEPS += $(wildcard system_constr.xdc) # Not all projects have this file
M_DEPS += $(HDL_PROJECT_PATH)scripts/adi_project.tcl
M_DEPS += $(HDL_PROJECT_PATH)scripts/adi_env.tcl
M_DEPS += $(HDL_PROJECT_PATH)scripts/adi_board.tcl

M_DEPS += $(foreach dep,$(LIB_DEPS),$(HDL_LIBRARY_PATH)$(dep)/component.xml)

.PHONY: all lib clean clean-all
all: lib $(PROJECT_NAME).sdk/system_top.hdf

clean:
	$(call clean, \
		$(CLEAN_TARGET), \
		$(HL)$(PROJECT_NAME)$(NC) project)

clean-all: clean
	@for lib in $(LIB_DEPS); do \
		$(MAKE) -C $(HDL_LIBRARY_PATH)$${lib} clean; \
	done

$(PROJECT_NAME).sdk/system_top.hdf: $(M_DEPS)
	-rm -rf $(CLEAN_TARGET)
	$(call build, \
		$(VIVADO) system_project.tcl, \
		$(PROJECT_NAME)_vivado.log, \
		$(HL)$(PROJECT_NAME)$(NC) project)

lib:
	@for lib in $(LIB_DEPS); do \
		$(MAKE) -C $(HDL_LIBRARY_PATH)$${lib} xilinx || exit $$?; \
	done
