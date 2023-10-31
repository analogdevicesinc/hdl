################################################################################
## Copyright (c) 2023 Analog Devices, Inc.
## SPDX short identifier: BSD-1-Clause
################################################################################

HDL_PROJECT_PATH := $(subst scripts/project-lattice.mk,,$(lastword $(MAKEFILE_LIST)))

include $(HDL_PROJECT_PATH)../quiet.mk

PROPEL_BUILDER := propelbld

ifeq ($(OS), Windows_NT)
    RADIANT := pnmainc
else
    RADIANT := radiant
endif

# Common dependencies that all projects have
M_DEPS += system_project_bd.tcl
M_DEPS += system_bd.tcl
M_DEPS += system_project.tcl
M_DEPS += $(HDL_PROJECT_PATH)scripts/adi_project_lattice_bd.tcl
M_DEPS += $(HDL_PROJECT_PATH)scripts/adi_project_lattice.tcl
M_DEPS += $(HDL_PROJECT_PATH)../scripts/adi_env.tcl
M_DEPS += system_top.v
M_DEPS += $(PROJECT_NAME)/$(PROJECT_NAME)/$(PROJECT_NAME).v
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

PB_TARGETS += $(PROJECT_NAME)/$(PROJECT_NAME)/$(PROJECT_NAME).sbx
PB_TARGETS += $(PROJECT_NAME)/$(PROJECT_NAME)/$(PROJECT_NAME).v

R_TARGETS += $(PROJECT_NAME)/$(PROJECT_NAME).rdf
R_TARGETS += $(PROJECT_NAME)/impl_1/$(PROJECT_NAME)_impl_1.bit

.PHONY: all pb rd rd-force clean clean-pb clean-rd # watch-pb watch-rd

all: pb rd

pb: $(PB_TARGETS)

rd: $(R_TARGETS)

clean:
	-rm -Rf ${PROJECT_NAME}
	-rm -f $(wildcard *.log)
	-rm -Rf ./ipcfg
	-rm -Rf $(filter-out . .. ./. ./.., $(wildcard .*))

clean-pb:
	-rm -Rf $(wildcard $(PROJECT_NAME)/$(PROJECT_NAME)/*)
	-rm -f $(PROJECT_NAME)/.socproject
	-rm -Rf ./ipcfg
	-rm -Rf $(filter-out . .. ./. ./.., $(wildcard .*))
	-rm -f $(PROJECT_NAME)_propel_builder.log

clean-rd:
	-rm -Rf $(filter-out $(PROJECT_NAME)/$(PROJECT_NAME) \
		$(PROJECT_NAME)/.socproject, \
		$(wildcard $(PROJECT_NAME)/*))
	-rm -Rf $(filter-out $(PROJECT_NAME)/$(PROJECT_NAME) \
		$(PROJECT_NAME)/.socproject \
		$(PROJECT_NAME)/. \
		$(PROJECT_NAME)/.., $(wildcard $(PROJECT_NAME)/.*))
	-rm -f $(PROJECT_NAME)_radiant.log

$(PB_TARGETS): $(filter-out $(PB_DEPS_FILTER_OUT),$(filter $(PB_DEPS_FILTER), $(M_DEPS)))
	$(call build, \
		$(PROPEL_BUILDER) system_project_bd.tcl ${PROJECT_NAME}, \
		$(PROJECT_NAME)_propel_builder.log, \
		$(HL)$(PROJECT_NAME)$(NC) project)

$(R_TARGETS): $(filter $(R_DEPS_FILTER), $(M_DEPS))
	$(call build, \
		$(RADIANT) system_project.tcl ${PROJECT_NAME}, \
		$(PROJECT_NAME)_radiant.log, \
		$(HL)$(PROJECT_NAME)$(NC) project)

rd-force:
	$(call build, \
	$(RADIANT) system_project.tcl ${PROJECT_NAME}, \
	$(PROJECT_NAME)_radiant.log, \
	$(HL)$(PROJECT_NAME)$(NC) project)

# for easily check included roject dependencies for propel builder and radiant
# watch-pb:
# 	echo $(filter-out $(PB_DEPS_FILTER_OUT),$(filter $(PB_DEPS_FILTER), $(M_DEPS)))

# watch-rd:
# 	echo $(filter-out $(R_DEPS_FILTER_OUT),$(filter $(R_DEPS_FILTER), $(M_DEPS)))