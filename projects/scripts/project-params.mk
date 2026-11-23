####################################################################################
## Copyright (c) 2026 Analog Devices, Inc.
## SPDX short identifier: BSD-1-Clause
####################################################################################

# Derives the build sub-folder (DIR_NAME) from the CFG file and from the
# parameters given on the make command line, keeping their command-line order:
#   make RX_LANE_RATE=2.5 RX_JESD_L=8  ->  RXRATE2_5_RXL8/
#
# A project may restrict which command-line variables are parameters by
# defining PROJECT_PARAMS before including the project makefile:
#   PROJECT_PARAMS := RX_LANE_RATE RX_JESD_L
# Variables in NON_PARAM_VARS control the build flow and never affect DIR_NAME.

NON_PARAM_VARS += CFG MODE VERBOSE MAKE_TERMOUT REQUIRED_VIVADO_VERSION
NON_PARAM_VARS += ADI_PROJECT_DIR ADI_HDL_DIR ADI_GHDL_DIR ADI_VIVADO_IP_LIBRARY
NON_PARAM_VARS += ADI_MATLAB ADI_IGNORE_VERSION_CHECK ADI_DISABLE_MESSAGE_SUPPRESION
NON_PARAM_VARS += ADI_USE_OOC_SYNTHESIS ADI_MAX_OOC_JOBS ADI_MAX_THREADS
NON_PARAM_VARS += ADI_SKIP_SYNTHESIS ADI_GENERATE_BIN ADI_GENERATE_UTILIZATION
NON_PARAM_VARS += ADI_GENERATE_XPA ADI_EXTRACT_PORTS ADI_NO_BITSTREAM_COMPRESSION
NON_PARAM_VARS += ADI_POWER_OPTIMIZATION ADI_POST_ROUTE_SCRIPT
NON_PARAM_VARS += ADI_POST_ROUTE_POD_PRE_SCRIPT
PROJECT_PARAMS ?= %

# Words removed from the parameter names to keep the folder name short
PARAMS_REPLACE_LIST := JESD LANE

adi_empty :=
adi_space := $(adi_empty) $(adi_empty)
adi_reverse = $(if $(1),$(call adi_reverse,$(wordlist 2,$(words $(1)),$(1))) $(firstword $(1)))
adi_uniq = $(if $(1),$(firstword $(1)) $(call adi_uniq,$(filter-out $(firstword $(1)),$(1))))
adi_var_name = $(patsubst %+,%,$(patsubst %:,%,$(patsubst %:,%,$(firstword $(subst =, ,$(1))))))
adi_strip_words = $(if $(2),$(call adi_strip_words,$(subst $(firstword $(2)),,$(1)),$(wordlist 2,$(words $(2)),$(2))),$(1))
adi_mangle = $(subst /,_,$(subst .,_,$(subst _,,$(call adi_strip_words,$(1),$(PARAMS_REPLACE_LIST)))))

DIR_NAME :=
ifdef CFG
    include $(CFG)
    export $(shell sed 's/=.*//' $(CFG) | tr '\n' ' ')
    DIR_NAME := $(basename $(notdir $(CFG)))
endif

# GNU make lists command-line variables in reverse order and every recursive
# make reverses the list again, so restore the user's order on even levels.
ADI_CMD_WORDS := $(if $(filter %0 %2 %4 %6 %8,$(MAKELEVEL)),$(call adi_reverse,$(MAKEOVERRIDES)),$(MAKEOVERRIDES))
ADI_CMD_VARS := $(call adi_uniq,$(foreach w,$(ADI_CMD_WORDS),$(if $(findstring =,$(w)),$(call adi_var_name,$(w)))))
ADI_CMD_VARS := $(foreach v,$(ADI_CMD_VARS),$(if $(filter command line,$(origin $(v))),$(v)))
ADI_PARAM_VARS := $(filter $(PROJECT_PARAMS),$(filter-out $(NON_PARAM_VARS),$(ADI_CMD_VARS)))
GEN_NAME := $(subst $(adi_space),_,$(strip $(foreach v,$(ADI_PARAM_VARS),$(call adi_mangle,$(v)_$(value $(v))))))
DIR_NAME := $(DIR_NAME)$(if $(and $(DIR_NAME),$(GEN_NAME)),_)$(GEN_NAME)

ifneq ($(DIR_NAME),)
    PROJECT_NAME := $(DIR_NAME)/$(PROJECT_NAME)
    ADI_PROJECT_DIR := $(DIR_NAME)/
    export ADI_PROJECT_DIR
endif

# Recipe line: create the build sub-folder and record its parameters
adi_project_dir_setup = $(if $(DIR_NAME),mkdir -p $(DIR_NAME) && printf '%s\n' $(if $(CFG),'CFG=$(CFG)') $(foreach v,$(ADI_PARAM_VARS),'$(v)=$(value $(v))') > $(DIR_NAME)/build_params.txt)
