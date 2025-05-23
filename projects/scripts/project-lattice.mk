####################################################################################
## Copyright (c) 2023 - 2025 Analog Devices, Inc.
## SPDX short identifier: BSD-1-Clause
####################################################################################

################################################################################
## Make script for building Lattice projects. ##################################
#
# * Make commands: all pb rd rd-force pb-force clean clean-all.
#
# * pb: checks if dependencies exist and builds the Propel Builder project.
#   (block design)
# * rd: checks for dependencies and builds the Radiant Project
#   based on Propel Builder Project.
# * force: you can build the whole project without
#   checking for dependencies.
# * pb-force and rd-force: you can build the respective projects without
#   checking for dependencies.
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

ifeq ($(OS), Windows_NT)
	RADIANT := pnmainc
	PROPEL_BUILDER := propelbld -console
else
	RADIANT := radiantc
	PROPEL_BUILDER := propelbldwrap -console
endif

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
M_DEPS += _bld/pb_design_finished.log

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

PB_TARGETS += _bld/$(PROJECT_NAME)/$(PROJECT_NAME)/$(PROJECT_NAME).sbx
PB_TARGETS += _bld/$(PROJECT_NAME)/$(PROJECT_NAME)/$(PROJECT_NAME).v
PB_TARGETS += _bld/pb_design_finished.log

R_TARGETS += _bld/$(PROJECT_NAME)/$(PROJECT_NAME).rdf
R_TARGETS += _bld/$(PROJECT_NAME)/impl_1/$(PROJECT_NAME)_impl_1.bit

CLEAN_TARGET += $(wildcard ./*/)
CLEAN_TARGET += $(wildcard *.log)
CLEAN_TARGET += $(wildcard ./radiantc.*)
CLEAN_TARGET += $(filter-out . .. ./. ./.., $(wildcard .*))

.PHONY: all pb rd force rd-force pb-force clean clean-all

all: pb rd

pb: $(PB_TARGETS)

rd: $(R_TARGETS)

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
LIB_TARGETS := $(LIB_TARGETS) $(foreach dep,$(LIB_DEPS),${LATTICE_DEFAULT_IP_PATH}/$(lastword $(subst /, ,$(dep)))/metadata.xml)
endif

$(LIB_TARGETS):
	$(foreach dep,$(LIB_DEPS), \
		flock $(HDL_LIBRARY_PATH)$(dep)/.lock -c "cd $(HDL_LIBRARY_PATH)$(dep) \
		&& $(MAKE) lattice";) exit $$?

$(PB_TARGETS): $(filter-out $(PB_DEPS_FILTER_OUT),$(filter $(PB_DEPS_FILTER), $(M_DEPS))) $(LIB_TARGETS)
	$(call skip_if_missing, \
		Project, \
		$(PROJECT_NAME), \
		true, \
	rm -Rf $(CLEAN_TARGET) ; \
	$(call build, \
		$(PROPEL_BUILDER) system_project_pb.tcl, \
		$(PROJECT_NAME)_propel_builder.log, \
		$(HL)$(PROJECT_NAME)$(NC) project))
	@for file in $(filter $(R_DEPS_FILTER), $(M_DEPS)); do \
		if [ ! -f $$file ]; then \
			echo "No [$(HL)$$file$(NC)] found. ... $(RED)FAILED$(NC)"; \
			echo "For details see $(HL)$(CURDIR)/$(PROJECT_NAME)_propel_builder.log$(NC)"; \
			exit 2; \
		fi \
	done

$(R_TARGETS): $(filter $(R_DEPS_FILTER), $(M_DEPS))
	-rm -f $(PROJECT_NAME)_radiant.log
	-rm -f _bld/$(PROJECT_NAME)/system_constr.pdc
	-rm -f _bld/$(PROJECT_NAME)/system_constr.sdc
	$(call build, \
		$(RADIANT) system_project.tcl, \
		$(PROJECT_NAME)_radiant.log, \
		$(HL)$(PROJECT_NAME)$(NC) project)
	@for file in $(R_TARGETS); do \
		if [ ! -f $$file ]; then \
			echo "No [$(HL)$$file$(NC)] found. ... $(RED)FAILED$(NC)"; \
			echo "For details see $(HL)$(CURDIR)/$(PROJECT_NAME)_radiant.log$(NC)"; \
			exit 2; \
		fi \
	done

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
