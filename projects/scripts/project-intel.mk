####################################################################################
## Copyright (c) 2020 - 2021 Analog Devices, Inc.
## SPDX short identifier: BSD-1-Clause
####################################################################################

# Assumes this file is in projects/scripts/project-intel.mk
HDL_PROJECT_PATH := $(subst scripts/project-intel.mk,,$(lastword $(MAKEFILE_LIST)))
HDL_LIBRARY_PATH := $(HDL_PROJECT_PATH)../library/

include $(HDL_PROJECT_PATH)../quiet.mk

ifeq ($(NIOS2_MMU),)
  NIOS2_MMU := 1
endif

export NIOS_MMU_ENABLED := $(NIOS2_MMU)

# Parse the config file and convert it to environment variables
PARAMS_REPLACE_LIST := JESD LANE # list of words that should be removed from the parameter names
GEN_SED := '$(foreach name, $(PARAMS_REPLACE_LIST), s/$(name)//g;);s/_//g'
ifdef CFG
    include $(CFG)
    export $(shell sed 's/=.*//' $(CFG) | tr '\n' ' ')
    PARAMS := $(shell cat $(CFG) | tr '\n' ' ')
    DIR_NAME := $(basename $(notdir $(CFG)))
endif

# Parse the variables passed to make and convert them to the filename format
CMD_VARIABLES := $(shell echo $(-*-command-variables-*-) | tac -s ' ')
ifneq ($(strip $(CMD_VARIABLES)), )
    PARAMS := $(shell echo $(CMD_VARIABLES) | sed -e 's/[=]/_/g')
    GEN_NAME := $(shell echo $(PARAMS) | sed -e $(GEN_SED) | sed -e 's/[ .]/_/g')
    DIR_NAME := $(if $(strip $(DIR_NAME)),$(DIR_NAME)_$(GEN_NAME),$(GEN_NAME))
endif

ifneq ($(strip $(DIR_NAME)), )
    PROJECT_NAME := $(DIR_NAME)/$(PROJECT_NAME)
    $(shell test -d $(DIR_NAME) || mkdir $(DIR_NAME))
    ADI_PROJECT_DIR := $(DIR_NAME)/
    export ADI_PROJECT_DIR
endif

INTEL := quartus_sh --64bit -t

CLEAN_TARGET += *_INFO.txt
CLEAN_TARGET += *_dump.txt
CLEAN_TARGET += db
CLEAN_TARGET += *.asm.rpt
CLEAN_TARGET += *.done
CLEAN_TARGET += *.eda.rpt
CLEAN_TARGET += *.fit.*
CLEAN_TARGET += *.map.*
CLEAN_TARGET += *.sta.*
CLEAN_TARGET += *.syn.*
CLEAN_TARGET += *.retime.*
CLEAN_TARGET += *.flow.*
CLEAN_TARGET += *.qsf
CLEAN_TARGET += *.qpf
CLEAN_TARGET += *.qws
CLEAN_TARGET += *.sof
CLEAN_TARGET += *.cdf
CLEAN_TARGET += *.sld
CLEAN_TARGET += *.qdf
CLEAN_TARGET += *.bin
CLEAN_TARGET += hc_output
CLEAN_TARGET += system_bd
CLEAN_TARGET += hps_isw_handoff
CLEAN_TARGET += hps_sdram_*.csv
CLEAN_TARGET += *ddr3_*.csv
CLEAN_TARGET += incremental_db
CLEAN_TARGET += reconfig_mif
CLEAN_TARGET += *.sopcinfo
CLEAN_TARGET +=  *.jdi
CLEAN_TARGET += *.pin
CLEAN_TARGET += qdb
CLEAN_TARGET += ip
CLEAN_TARGET += synth_dumps
CLEAN_TARGET += tmp-clearbox
CLEAN_TARGET += *_summary.csv
CLEAN_TARGET += *.dpf
CLEAN_TARGET += system_qsys_script.tcl
CLEAN_TARGET += system_bd.qsys
CLEAN_TARGET += .qsys_edit
CLEAN_TARGET += *.rpt
CLEAN_TARGET += *.smsg
CLEAN_TARGET += *.summary
CLEAN_TARGET += ip
CLEAN_TARGET += qdb
CLEAN_TARGET += tmp-clearbox
CLEAN_TARGET += *.log
ifneq ($(strip $(DIR_NAME)),)
    CLEAN_TARGET := $(addprefix $(DIR_NAME)/,$(CLEAN_TARGET))
endif

CLEAN_DIRS := $(dir $(wildcard */*_quartus.log))

M_DEPS += $(wildcard system_top*.v)
M_DEPS += system_qsys.tcl
M_DEPS += system_project.tcl
M_DEPS += system_constr.sdc
M_DEPS += $(HDL_PROJECT_PATH)scripts/adi_tquest.tcl
M_DEPS += $(HDL_PROJECT_PATH)scripts/adi_project_intel.tcl
M_DEPS += $(HDL_PROJECT_PATH)../scripts/adi_env.tcl

M_DEPS += $(foreach dep,$(LIB_DEPS),$(HDL_LIBRARY_PATH)$(dep)/.timestamp_intel)

.PHONY: all lib clean clean-all
all: $(PROJECT_NAME).sof

lib: $(M_DEPS)

clean:
	$(call clean, \
		$(CLEAN_TARGET), \
		$(HL)$(PROJECT_NAME)$(NC) project)
	-rm -Rf ${DIR_NAME}

clean-all: clean
	@rm -Rf $(CLEAN_DIRS)
	@for lib in $(LIB_DEPS); do \
		$(MAKE) -C $(HDL_LIBRARY_PATH)$${lib} clean; \
	done

$(PROJECT_NAME).sof: $(M_DEPS)
	-rm -rf $(CLEAN_TARGET)
	$(call build,\
		$(INTEL) system_project.tcl, \
		$(PROJECT_NAME)_quartus.log, \
		$(HL)$(PROJECT_NAME)$(NC))

$(HDL_LIBRARY_PATH)%/.timestamp_intel: TARGET:=intel
FORCE:
$(HDL_LIBRARY_PATH)%/.timestamp_intel: FORCE
	$(MAKE) -C $(dir $@) $(TARGET) || exit $$?; \
