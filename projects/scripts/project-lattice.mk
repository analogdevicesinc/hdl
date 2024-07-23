####################################################################################
## Copyright (c) 2023 - 2024 Analog Devices, Inc.
## SPDX short identifier: BSD-1-Clause
####################################################################################

################################################################################
## Make script for building Lattice projects. ##################################
#
# * Make commands: all pb rd rd-force pb-force clean clean-all clean-pb clean-rd.
#
# * pb: checks if dependencies exist and builds the Propel Builder project.
#   (block design)
# * rd: checks for dependencies and builds the Radiant Project
#   based on Propel Builder Project.
# * pb-force and rd-force: you can build the respective projects without
#   checking for dependencies.
# * clean: deletes the whole project and log files.
# * clean-all: deletes all the generated files during build.
# * clean-pb: deletes the Propel Builder project files and directories.
#   After this you can rebuild the Propel Builder project separately by
#   'make pb' but only if you created the project without using the '-sbc'
#   template file option wich is used in official project creation command,
#   because if you create with '-sbc' option the command will not create
#   the project becouse the first <project_name> folder from
#   <adi_project_folder>/<project_name>/<project_name> is not deleted,
#   becouse that contains the Radiant project files. Also deletes the log
#   file for Propel Builder project.
# * clean-rd: cleans the content of <adi_project_folder>/<project_name>/
#   folder ralated to Radiant project except the
#   <adi_project_folder>/<project_name>/<project_name> folder.
#   Also deletes the log file for Radiant project.
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

ifeq ($(OS), Windows_NT)
	RADIANT := pnmainc
	PROPEL_BUILDER := propelbld
else
	RADIANT := radiantc
	PROPEL_BUILDER := propelbldwrap
endif

# Common dependencies that all projects have.
M_DEPS += system_project_pb.tcl
M_DEPS += system_pb.tcl
M_DEPS += system_project.tcl
M_DEPS += $(HDL_PROJECT_PATH)scripts/adi_project_lattice_pb.tcl
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
PB_DEPS_FILTER += %metadata.xml

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

.PHONY: all pb rd rd-force pb-force clean clean-all clean-pb clean-rd

all: pb rd

pb: $(PB_TARGETS)

rd: $(R_TARGETS)

clean:
	-rm -Rf ${PROJECT_NAME}
	-rm -f $(wildcard *.log)
	-rm -Rf ./ipcfg
	-rm -Rf ./sge

clean-all:
	-rm -Rf ${PROJECT_NAME}
	-rm -f $(wildcard *.log)
	-rm -Rf ./ipcfg
	-rm -Rf $(filter-out . .. ./. ./.., $(wildcard .*))
	-rm -Rf ./sge
	@for lib in $(LIB_DEPS); do \
		$(MAKE) -C $(HDL_LIBRARY_PATH)$${lib} clean; \
	done

clean-pb:
	-rm -Rf $(wildcard $(PROJECT_NAME)/$(PROJECT_NAME)/*)
	-rm -f $(PROJECT_NAME)/.socproject
	-rm -Rf ./ipcfg
	-rm -f $(PROJECT_NAME)_propel_builder.log
	-rm -Rf ./sge

clean-rd:
	-rm -Rf $(filter-out $(PROJECT_NAME)/$(PROJECT_NAME) \
		$(PROJECT_NAME)/.socproject, \
		$(wildcard $(PROJECT_NAME)/*))
	-rm -Rf $(filter-out $(PROJECT_NAME)/$(PROJECT_NAME) \
		$(PROJECT_NAME)/.socproject \
		$(PROJECT_NAME)/. \
		$(PROJECT_NAME)/.., $(wildcard $(PROJECT_NAME)/.*))
	-rm -f $(PROJECT_NAME)_radiant.log

# The library name in .tcl script must be the same as the library folder name
M_DEPS += $(foreach dep,$(LIB_DEPS),$(HDL_LIBRARY_PATH)$(dep)/$(lastword $(subst /, ,$(dep)))/metadata.xml)

$(HDL_LIBRARY_PATH)%/metadata.xml: TARGET:=lattice
FORCE:
$(HDL_LIBRARY_PATH)%/metadata.xml: FORCE
	flock $(patsubst %/$(lastword $(subst /, ,$(dir $@)))/,%,$(dir $@)).lock sh -c " \
	if [ -n \"${REQUIRED_LATTICE_VERSION}\" ]; then \
		$(MAKE) -C $(patsubst %/$(lastword $(subst /, ,$(dir $@)))/,%,$(dir $@)) $(TARGET) REQUIRED_LATTICE_VERSION=${REQUIRED_LATTICE_VERSION}; \
	else \
		$(MAKE) -C $(patsubst %/$(lastword $(subst /, ,$(dir $@)))/,%,$(dir $@)) $(TARGET); \
	fi"; exit $$?

$(PB_TARGETS): $(filter-out $(PB_DEPS_FILTER_OUT),$(filter $(PB_DEPS_FILTER), $(M_DEPS)))
	-rm -f $(PROJECT_NAME)_propel_builder.log
	$(call build, \
		$(PROPEL_BUILDER) system_project_pb.tcl, \
		$(PROJECT_NAME)_propel_builder.log, \
		$(HL)$(PROJECT_NAME)$(NC) project)
	@for file in $(filter $(R_DEPS_FILTER), $(M_DEPS)); do \
		if [ ! -f $$file ]; then \
			echo "No [$(HL)$$file$(NC)] found. ... $(RED)FAILED$(NC)"; \
			echo "For details see $(HL)$(CURDIR)/$(PROJECT_NAME)_propel_builder.log$(NC)"; \
			exit 2; \
		fi \
	done

$(R_TARGETS): $(filter $(R_DEPS_FILTER), $(M_DEPS))
	-rm -f $(PROJECT_NAME)_radiant.log
	-rm -f $(PROJECT_NAME)/system_constr.pdc
	-rm -f $(PROJECT_NAME)/system_constr.sdc
	$(call build, \
		$(RADIANT) system_project.tcl, \
		$(PROJECT_NAME)_radiant.log, \
		$(HL)$(PROJECT_NAME)$(NC) project)

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

