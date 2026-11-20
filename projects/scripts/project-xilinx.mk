####################################################################################
## Copyright (c) 2018 - 2023, 2025 - 2026 Analog Devices, Inc.
## SPDX short identifier: BSD-1-Clause
####################################################################################

# Assumes this file is in projects/scripts/project-xilinx.mk
HDL_PROJECT_PATH := $(subst scripts/project-xilinx.mk,,$(lastword $(MAKEFILE_LIST)))
HDL_LIBRARY_PATH := $(HDL_PROJECT_PATH)../library/

include $(HDL_PROJECT_PATH)../quiet.mk
include $(HDL_PROJECT_PATH)scripts/project-params.mk

ifneq ($(DIR_NAME),)
    VIVADO := vivado -tempDir $(DIR_NAME)/.Xil -log $(DIR_NAME)/vivado.log -journal $(DIR_NAME)/vivado.jou -mode batch -source
else
    VIVADO := vivado -tempDir .Xil -mode batch -source
endif

CLEAN_TARGET := *.cache
CLEAN_TARGET += *.data
CLEAN_TARGET += *.xpr
CLEAN_TARGET += xgui
CLEAN_TARGET +=  gui
CLEAN_TARGET += *.runs
CLEAN_TARGET += *.srcs
CLEAN_TARGET += *.sdk
CLEAN_TARGET += *.hw
CLEAN_TARGET += *.sim
CLEAN_TARGET += *.ip_user_files
CLEAN_TARGET += *.str
CLEAN_TARGET += mem_init_sys.txt
CLEAN_TARGET += *.csv
CLEAN_TARGET += *.hbs
CLEAN_TARGET += *.gen
CLEAN_TARGET += *.xpe
CLEAN_TARGET += *.xsa
CLEAN_TARGET += *.log
CLEAN_TARGET += *.jou
ifneq ($(strip $(DIR_NAME)), )
    CLEAN_TARGET := $(addprefix $(DIR_NAME)/,$(CLEAN_TARGET))
endif
CLEAN_TARGET += .Xil

CLEAN_DIRS := $(sort $(dir $(wildcard */*_vivado.log */build_params.txt)))

# Common dependencies that all projects have
M_DEPS += system_project.tcl
M_DEPS += system_bd.tcl
M_DEPS += $(wildcard system_top*.v)
M_DEPS += $(wildcard system_constr*.xdc) # Not all projects have this file
M_DEPS += $(wildcard system_constr*.tcl) # Not all projects have this file
M_DEPS += $(HDL_PROJECT_PATH)scripts/adi_project_xilinx.tcl
M_DEPS += $(HDL_PROJECT_PATH)../scripts/adi_env.tcl
M_DEPS += $(HDL_PROJECT_PATH)scripts/adi_board.tcl
M_DEPS += $(EXTERNAL_DEPS)

M_DEPS += $(foreach dep,$(LIB_DEPS),$(HDL_LIBRARY_PATH)$(dep)/component.xml)

.PHONY: all lib clean clean-all

all: external_dependencies $(PROJECT_NAME).sdk/system_top.xsa

lib: $(M_DEPS)

clean:
	-rm -f reference.dcp
	$(call clean, \
		$(CLEAN_TARGET), \
		$(HL)$(PROJECT_NAME)$(NC) project)
	-rm -Rf ${DIR_NAME}

clean-all: clean
	@rm -Rf $(CLEAN_DIRS)
	@for lib in $(LIB_DEPS); do \
		$(MAKE) -C $(HDL_LIBRARY_PATH)$${lib} clean; \
	done

external_dependencies: external_dependencies_cleanup $(EXTERNAL_DEPS)

external_dependencies_cleanup:
	rm -f missing_external.log

$(EXTERNAL_DEPS):
	if [ ! -d $@ ]; then \
		echo $@ >> missing_external.log ; \
	fi

MODE ?= "default"

$(PROJECT_NAME).sdk/system_top.xsa: $(M_DEPS)
	@$(adi_project_dir_setup)
	@if [ $(MODE) = incr ]; then \
		if [ -f */impl_1/system_top_routed.dcp ]; then \
			echo Found previous run result at `ls */impl_1/system_top_routed.dcp`; \
			cp -u */impl_1/system_top_routed.dcp ./reference.dcp ; \
		fi; \
		if [ -f ./reference.dcp ]; then \
			echo Using reference checkpoint for incremental compilation; \
		fi; \
	else \
		rm -f reference.dcp; \
	fi;
	$(call skip_if_missing, \
		Project, \
		$(PROJECT_NAME), \
		true, \
	rm -rf $(CLEAN_TARGET) ; \
	$(call build, \
		$(VIVADO) system_project.tcl, \
		$(PROJECT_NAME)_vivado.log, \
		$(HL)$(PROJECT_NAME)$(NC) project))

$(HDL_LIBRARY_PATH)%/component.xml: TARGET:=xilinx
FORCE:
$(HDL_LIBRARY_PATH)%/component.xml: FORCE
	flock $(dir $@).lock sh -c " \
	if [ -n \"${REQUIRED_VIVADO_VERSION}\" ]; then \
		$(MAKE) -C $(dir $@) $(TARGET) REQUIRED_VIVADO_VERSION=${REQUIRED_VIVADO_VERSION}; \
	else \
		$(MAKE) -C $(dir $@) $(TARGET); \
	fi"; exit $$?
