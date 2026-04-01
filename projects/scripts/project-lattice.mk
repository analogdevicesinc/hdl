####################################################################################
## Copyright (c) 2023 - 2026 Analog Devices, Inc.
## SPDX short identifier: BSD-1-Clause
####################################################################################

################################################################################
## Make script for building Lattice projects. ##################################
#
# * Make commands: all pb rd sge rd-force pb-force sim sim-cli open-pb
# *   open-v open-rd clean clean-all.
#
# * pb: checks if dependencies exist and builds the Propel Builder project.
#   (block design)
# * rd: checks for dependencies and builds the Radiant Project
#   based on Propel Builder Project.
# * force: you can build the whole project without
#   checking for dependencies.
# * pb-force and rd-force: you can build the respective projects without
#   checking for dependencies.
# * sim: runs Questasim simulation using qsim.do in GUI mode.
# * sim-cli: runs Questasim simulation using qsim.do in command-line mode.
# * open-pb: opens the generated Propel Builder project (.sbx).
# * open-v: opens the generated verification Propel Builder project (.sbx).
# * open-rd: opens the generated Radiant project file (.rdf).
# * sge: creates a zip file with the build artifacts.
# * clean: deletes the whole project and log files.
# * clean-all: deletes all the generated files during build.
#
# * Note: The limitation for Propel Builder project is that it does not exit
#   with error code no matter if the design was built or failed to,
#   so the red FAILED message will never appear by default.
#   As a workaround I search for the Propel Builder project build targets,
#   if one of them is not found I write the red FAILED message and exit
#   with error code. That means the Propel Builder project failed to build.
################################################################################

HDL_PROJECT_PATH := $(subst scripts/project-lattice.mk,,$(lastword $(MAKEFILE_LIST)))
HDL_LIBRARY_PATH := $(HDL_PROJECT_PATH)../library/

include $(HDL_PROJECT_PATH)../quiet.mk
include $(HDL_LIBRARY_PATH)scripts/lattice_tool_set.mk

RADIANT := radiantc
RADIANT_GUI := radiant

PROPEL_BUILDER := propelbldc
PROPEL_BUILDER_GUI := propelbld

SIMULATOR ?= vsim

# Common dependencies that all projects have.
M_DEPS += system_project_pb.tcl
M_DEPS += system_pb.tcl
M_DEPS += system_project.tcl
M_DEPS += $(HDL_PROJECT_PATH)scripts/adi_project_lattice_pb.tcl
M_DEPS += $(HDL_PROJECT_PATH)scripts/adi_project_lattice.tcl
M_DEPS += $(HDL_PROJECT_PATH)../scripts/adi_env.tcl
M_DEPS += system_top.v
M_DEPS += _bld/$(PROJECT_NAME)/$(PROJECT_NAME)/$(PROJECT_NAME).v
M_DEPS += $(wildcard *system_constr.pdc)
M_DEPS += $(wildcard *system_constr.sdc)

PB_DEPS_FILTER += %.tcl
PB_DEPS_FILTER += %.mem
PB_DEPS_FILTER_OUT += %system_project.tcl
PB_DEPS_FILTER_OUT += %adi_project_lattice.tcl

R_DEPS_FILTER += %.v
R_DEPS_FILTER += %.vhdl
R_DEPS_FILTER += %.sdc
R_DEPS_FILTER += %.pdc
R_DEPS_FILTER += %.mem
R_DEPS_FILTER += %.ipx
R_DEPS_FILTER += %adi_env.tcl
R_DEPS_FILTER += %adi_project_lattice.tcl
R_DEPS_FILTER += %system_project.tcl
R_DEPS_FILTER += %.log

DEFAULT_PB_DEPS := $(filter-out $(PB_DEPS_FILTER_OUT),$(filter $(PB_DEPS_FILTER), $(M_DEPS)))
PB_DEPS ?= $(DEFAULT_PB_DEPS)

DEFAULT_SGE_DIR := _bld/$(PROJECT_NAME)/sge
SGE_DIR ?= $(DEFAULT_SGE_DIR)

DEFAULT_PROJECT_SBX := _bld/$(PROJECT_NAME)/$(PROJECT_NAME)/$(PROJECT_NAME).sbx
PROJECT_SBX ?= $(DEFAULT_PROJECT_SBX)
PROJECT_SBX_NAME := $(basename $(notdir $(PROJECT_SBX)))
PB_STAMP_FILE ?= _bld/pb_design_finished.stamp

DEFAULT_PB_TARGETS += $(PROJECT_SBX)
DEFAULT_PB_TARGETS += _bld/$(PROJECT_NAME)/$(PROJECT_NAME)/$(PROJECT_NAME).v
DEFAULT_PB_TARGETS += $(SGE_DIR)
DEFAULT_PB_TARGETS += $(SGE_DIR)/sys_env.xml
PB_TARGETS ?= $(DEFAULT_PB_TARGETS)

DEFAULT_VER_PROJECT_SBX := _bld/$(PROJECT_NAME)/verification/$(PROJECT_NAME)_v.sbx
VER_PROJECT_SBX ?= $(DEFAULT_VER_PROJECT_SBX)
VER_PROJECT_SBX_NAME := $(basename $(notdir $(VER_PROJECT_SBX)))

DEFAULT_GEN_SIM_DO := _bld/$(PROJECT_NAME)/verification/sim/qsim.do
GEN_SIM_DO ?= $(DEFAULT_GEN_SIM_DO)
DEFAULT_ADI_SIM_DO := $(dir $(GEN_SIM_DO))adi_sim.do
ADI_SIM_DO ?= $(DEFAULT_ADI_SIM_DO)

ifneq ($(wildcard system_v_pb.tcl),)
DEFAULT_SIM_DEPS += system_v_pb.tcl
DEFAULT_PB_TARGETS += $(VER_PROJECT_SBX)
DEFAULT_SIM_DEPS += $(VER_PROJECT_SBX)
DEFAULT_PB_TARGETS += $(GEN_SIM_DO)
DEFAULT_SIM_DEPS += $(GEN_SIM_DO)
DEFAULT_SIM_DEPS += $(ADI_SIM_DO)
endif

SIM_DEPS ?= $(DEFAULT_SIM_DEPS)

SIM_STAMP_FILE := _bld/sim_finished.stamp
DEFAULT_SIM_TARGETS += $(SIM_STAMP_FILE) $(CURDIR)/$(PROJECT_NAME)_sim.log
SIM_TARGETS ?= $(DEFAULT_SIM_TARGETS)

DEFAULT_R_DEPS := $(filter $(R_DEPS_FILTER), $(M_DEPS))
R_DEPS ?= $(DEFAULT_R_DEPS)

DEFAULT_BIT_TARGET := _bld/$(PROJECT_NAME)/impl_1/$(PROJECT_NAME)_impl_1.bit
BIT_TARGET ?= $(DEFAULT_BIT_TARGET)

DEFAULT_PROJECT_RDF := _bld/$(PROJECT_NAME)/$(PROJECT_NAME).rdf
PROJECT_RDF ?= $(DEFAULT_PROJECT_RDF)
R_STAMP_FILE ?= _bld/rd_finished.stamp

DEFAULT_R_TARGETS += $(PROJECT_RDF)
DEFAULT_R_TARGETS += $(BIT_TARGET)
R_TARGETS ?= $(DEFAULT_R_TARGETS)

SYSTEM_TOP_PARAMETERS := $(wildcard _bld/system_top_parameters.txt)
DEFAULT_SGE_ZIP_INPUTS += $(SGE_DIR) $(BIT_TARGET) $(SYSTEM_TOP_PARAMETERS)
SGE_ZIP_INPUTS ?= $(DEFAULT_SGE_ZIP_INPUTS)
DEFAULT_SGE_ZIP := _bld/$(PROJECT_NAME)/sge.zip
SGE_ZIP ?= $(DEFAULT_SGE_ZIP)

DEFAULT_CLEAN_TARGET += $(wildcard ./_bld)
DEFAULT_CLEAN_TARGET += $(wildcard *.log)
DEFAULT_CLEAN_TARGET += $(wildcard *.tmp)
DEFAULT_CLEAN_TARGET += mem_init_sys.txt
DEFAULT_CLEAN_TARGET += $(wildcard ./radiantc.*)
DEFAULT_CLEAN_TARGET += $(filter-out . .. ./. ./.., $(wildcard .*))
CLEAN_TARGET ?= $(DEFAULT_CLEAN_TARGET)

.PHONY: all pb rd sge rd-force pb-force sim sim-cli open-pb open-v \
	open-rd clean clean-all  lib_targets_all lib_targets_local \
	lib_targets_external FORCE

ALL_RULES ?= sge

all: $(ALL_RULES)

DEFAULT_SIM_CLI_CMD := (cd $(dir $(ADI_SIM_DO)) && $(SIMULATOR) -c \
	-do $(notdir $(ADI_SIM_DO)))
SIM_CLI_CMD ?= $(DEFAULT_SIM_CLI_CMD)

SIM_RUN_CMD ?= run -all

$(ADI_SIM_DO): $(GEN_SIM_DO)
	@{ \
		echo "onbreak {exit -code 2}"; \
		echo "onerror {exit -code 2}"; \
		echo "onElabError {exit -code 2}"; \
		sed '/^[[:space:]]*run[[:space:]]/q' "$(GEN_SIM_DO)" | sed '$$d'; \
		echo "$(SIM_RUN_CMD)"; \
		echo "exit -code 0"; \
	} > "$(ADI_SIM_DO)"

sim-cli: $(SIM_STAMP_FILE)
	@for file in $(SIM_TARGETS); do \
		if [ ! -e $$file ]; then \
			echo "No [$(HL)$$file$(NC)] found. ... $(RED)FAILED$(NC)"; \
			echo "For details see $(HL)$(CURDIR)/$(PROJECT_NAME)_sim.log$(NC)"; \
			rm -f $(SIM_STAMP_FILE); \
			exit 2; \
		fi \
	done

$(SIM_STAMP_FILE): $(SIM_DEPS)
	$(call skip_if_missing, \
		Project, \
		$(PROJECT_NAME), \
		true, \
	rm -Rf $(SIM_TARGETS) ; \
	$(call build, \
	$(SIM_CLI_CMD), \
	$(CURDIR)/$(PROJECT_NAME)_sim.log, \
	$(HL)$(PROJECT_NAME)$(NC) simulation))
	@if grep -Eq "\*\* Fatal:|\*\* Error:|Errors: [1-9][0-9]*|FAILED|failed," "$(CURDIR)/$(PROJECT_NAME)_sim.log"; then \
		echo "Simulation incomplete ... $(RED)FAILED$(NC)"; \
		echo "For details see $(HL)$(CURDIR)/$(PROJECT_NAME)_sim.log$(NC)"; \
		exit 2; \
	fi
	@touch $(SIM_STAMP_FILE)

DEFAULT_SIM_CMD := cd $(dir $(ADI_SIM_DO)) && $(SIMULATOR) -do $(notdir $(ADI_SIM_DO))
SIM_CMD ?= $(DEFAULT_SIM_CMD)

sim: $(SIM_DEPS)
	$(SIM_CMD)

open-pb:
	if [ ! -e $(PROJECT_SBX) ]; then \
		echo "$(RED)ERROR:$(NC) No [$(HL)$(PROJECT_SBX)$(NC)] found. "; \
		exit 2; \
	fi
	@(printf '%s\n' "sbp_design open -name $(PROJECT_SBX_NAME) -path $(PROJECT_SBX)" > adi_prj_pb.tmp && \
	$(PROPEL_BUILDER_GUI) adi_prj_pb.tmp)
	rm -f adi_prj_pb.tmp

open-v:
	if [ ! -e $(VER_PROJECT_SBX) ]; then \
		echo "$(RED)ERROR:$(NC) No [$(HL)$(VER_PROJECT_SBX)$(NC)] found. "; \
		exit 2; \
	fi
	@(printf '%s\n' "sbp_design open -name $(VER_PROJECT_SBX_NAME) -path $(VER_PROJECT_SBX)" > adi_prj_v.tmp && \
	$(PROPEL_BUILDER_GUI) adi_prj_v.tmp)
	rm -f adi_prj_v.tmp

open-rd:
	if [ ! -e $(PROJECT_RDF) ]; then \
		echo "$(RED)ERROR:$(NC) No [$(HL)$(PROJECT_RDF)$(NC)] found. "; \
		exit 2; \
	fi
	$(RADIANT_GUI) $(PROJECT_RDF)

clean:
	$(call clean, \
		$(CLEAN_TARGET), \
		$(HL)$(PROJECT_NAME)$(NC) project)

clean-all:
	$(call clean, \
		$(CLEAN_TARGET), \
		$(HL)$(PROJECT_NAME)$(NC) project)
	@for lib in $(LIB_DEPS); do \
		$(MAKE) -C $(HDL_LIBRARY_PATH)$${lib} clean; \
	done

# The library name in .tcl script must be the same as the library folder name
LIB_TARGETS := $(foreach dep,$(LIB_DEPS),${HDL_LIBRARY_PATH}$(dep)/ltt/metadata.xml)
ifeq ($(LATTICE_DEFAULT_PATHS),1)
LIB_TARGETS_EXTERNAL := $(LIB_TARGETS) $(foreach dep,$(LIB_DEPS),${LATTICE_DEFAULT_IP_PATH}/$(lastword $(subst /, ,$(dep)))/metadata.xml)
endif

.NOTPARALLEL: lib_targets_all

lib_targets_all: lib_targets_local lib_targets_external

lib_targets_local: $(LIB_TARGETS)
lib_targets_external: $(LIB_TARGETS_EXTERNAL)

$(HDL_LIBRARY_PATH)%/metadata.xml: TARGET:=lattice
FORCE:
$(HDL_LIBRARY_PATH)%/metadata.xml: FORCE
	flock $(patsubst %/ltt/,%/,$(dir $@)).lock sh -c " \
	$(MAKE) -C $(patsubst %/ltt/,%/,$(dir $@)) $(TARGET)"; exit $$?

pb: $(PB_TARGETS)

$(PB_TARGETS): $(PB_STAMP_FILE)

$(PB_STAMP_FILE): $(PB_DEPS) $(LIB_TARGETS)
	$(call skip_if_missing, \
		Project, \
		$(PROJECT_NAME), \
		true, \
	rm -Rf $(CLEAN_TARGET) ; \
	$(call build, \
		$(PROPEL_BUILDER) system_project_pb.tcl, \
		$(PROJECT_NAME)_propel_builder.log, \
		$(HL)$(PROJECT_NAME)$(NC) project))
	@for file in $(PB_TARGETS); do \
		if [ ! -e $$file ]; then \
			echo "No [$(HL)$$file$(NC)] found. ... $(RED)FAILED$(NC)"; \
			echo "For details see $(HL)$(CURDIR)/$(PROJECT_NAME)_propel_builder.log$(NC)"; \
			exit 2; \
		fi \
	done
	@touch $(PB_STAMP_FILE)

rd: $(R_TARGETS)

$(R_TARGETS): $(R_STAMP_FILE)

$(R_STAMP_FILE): $(R_DEPS)
	-rm -f $(PROJECT_NAME)_radiant.log
	-rm -f _bld/$(PROJECT_NAME)/system_constr.pdc
	-rm -f _bld/$(PROJECT_NAME)/system_constr.sdc
	$(call build, \
		$(RADIANT) system_project.tcl, \
		$(PROJECT_NAME)_radiant.log, \
		$(HL)$(PROJECT_NAME)$(NC) project)
	@for file in $(R_TARGETS); do \
		if [ ! -e $$file ]; then \
			echo "No [$(HL)$$file$(NC)] found. ... $(RED)FAILED$(NC)"; \
			echo "For details see $(HL)$(CURDIR)/$(PROJECT_NAME)_radiant.log$(NC)"; \
			exit 2; \
		fi \
	done
	@touch $(R_STAMP_FILE)

sge: $(SGE_ZIP)

$(SGE_ZIP): $(SGE_ZIP_INPUTS)
	{ \
		rm -rf "$(dir $@)/zip_tmp" && \
		rm -f "$@" && \
		mkdir "$(dir $@)/zip_tmp" && \
		cp -r $(SGE_ZIP_INPUTS) "$(dir $@)/zip_tmp" && \
		(cd "$(dir $@)/zip_tmp" && zip -r "$(abspath $@)" . ) \
	} > /dev/null || { \
		rm -rf "$(dir $@)/zip_tmp"; rm -f "$@"; \
		echo "ERROR: Creating [$(HL)$@$(NC)] $(RED)FAILED$(NC)."; \
		exit 2; \
	}
	-rm -rf "$(dir $@)/zip_tmp"

force: pb-force rd-force

pb-force:
	$(call build, \
	$(PROPEL_BUILDER) system_project_pb.tcl, \
	$(PROJECT_NAME)_propel_builder.log, \
	$(HL)$(PROJECT_NAME)$(NC) project)

rd-force:
	$(call build, \
	$(RADIANT) system_project.tcl, \
	$(PROJECT_NAME)_radiant.log, \
	$(HL)$(PROJECT_NAME)$(NC) project)
