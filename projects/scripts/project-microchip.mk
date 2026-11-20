####################################################################################
## Copyright (c) 2026 Analog Devices, Inc.
## SPDX short identifier: BSD-1-Clause
####################################################################################

################################################################################
## Make script for building Microchip Libero SoC projects. #####################
#
# * Make commands: all lib open info clean clean-all
#                  hss hss-job
#                  sim sim-cli sim-prj open-sim clean-sim
#                  tb tb-cli clean-tb
#
# * all: builds the Libero project, exports the FlashPro job and packs it with
#   the bitstream, the MSS configuration XML (for the HSS and bare-metal
#   software) and the build information into <project>.zip next to the job.
# * hss: builds the HSS (scripts/adi_make_hss.sh) with the MSS configuration of
#   the build directory, into <build>/hss.
# * hss-job: the same, and exports the FlashPro job of the project with the
#   HSS in the eNVM (<build>/hss/system_top_hss.job); builds the project first
#   if needed. Both take the parameters of the build, e.g.
#   `make PARAM1=val1 hss-job`; HSS_FLAGS passes further options to the script.
# * lib: refreshes library-side `.timestamp_microchip` stamps used mainly by CI/dependency checks.
# * open: opens the Libero project (.prjx) in the GUI.
# * info: prints the build directories, the parameters and the artifacts.
# * clean: deletes the project build of the current parameter set.
# * clean-all: deletes _bld, _bld_sim, _bld_tb and the logs and cleans library
#   builds; the builds with parameters are kept.
#
# * sim: system simulation of the simulation project (system_project_sim.tcl:
#   system_top with the testbench), in the GUI.
# * sim-cli: the same in batch mode; fails if the testbench reports an error.
#   A passed simulation runs again only if one of its dependencies changed
#   (the simulation project, SIM_RUN_FILES, the simulator and its options, the
#   makefiles). SIM_RUN_FILES (by default BFM_FILES and MEM_FILES, the
#   verification/*.bfm and *.mem files) are copied into the simulation
#   directory before every run; a change of them does not rebuild the
#   simulation project.
# * sim-prj: builds the simulation project; sim and sim-cli build it if it is
#   missing or one of its sources changed.
# * sim-ddr-init (optional): regenerates the DDR init file of the simulation
#   (DDR_INIT_OUTPUT) from a user memory file with AXI addresses
#   (DDR_INIT_USER_MEM), for the DDR configuration of the MSS (its netlist
#   from the MSS generation; no simulation project needed).
#   It needs python3 and the Microchip script pfsoc_mss_ddr_init_v2.py, which
#   is not in the repository: download DDR_INIT_CONVERTER_URL (with a
#   Microchip login) and unzip it anywhere into the repository (e.g. its
#   root; the rule searches it there), or pass its path in DDR_INIT_CONVERTER.
# * open-sim: opens the simulation project in the GUI.
# * clean-sim (clean-sim-prj): deletes the simulation build.
#
# * tb: simulates the testbench TB_TOP of TB_FILES without a Libero project,
#   in the GUI, with TB_SCRIPT (default: library/common/tb/run_tb_microchip.sh,
#   the script of the library testbenches too); TB_OPTS passes further options
#   of the script (e.g. TB_OPTS="-G NAME=1 --wave wave.do").
# * tb-cli: the same in batch mode; fails if the testbench reports an error.
#   A passed testbench runs again only if one of TB_FILES, TB_DEPS (the files
#   the testbench includes or reads), TB_SCRIPT, the command (libero, TB_TOP,
#   TB_OPTS) or the makefiles changed.
# * clean-tb: deletes the testbench builds.
#
# * Rules: all, sim-prj, sim, sim-cli, tb, tb-cli and clean-tb run the rules
#   listed in ALL_RULES, SIM_PRJ_RULES, SIM_RULES, SIM_CLI_RULES, TB_RULES,
#   TB_CLI_RULES and CLEAN_TB_RULES; a project Makefile can extend or replace
#   them, e.g.
#   `SIM_PRJ_RULES += sim-ddr-init` runs the DDR initialization after the
#   simulation project is built.
#
# * Build directories: without parameters the project is built in _bld/prj,
#   the simulation project in _bld_sim/prj and the testbenches in
#   _bld_tb/<TB_TOP>. `make PARAM1=val1 PARAM2=val2` builds in
#   <PARAM1val1_PARAM2val2>/prj, <PARAM1val1_PARAM2val2>_SIM/prj and
#   <PARAM1val1_PARAM2val2>_TB/<TB_TOP>. Each project has its own MSS in the
#   mss directory next to it, with its log. `make CFG=file.cfg` takes the
#   parameters from the file and names the directory after it (as in
#   project-xilinx.mk). The parameters are exported to Libero
#   (get_env_param), the project directory as ADI_BUILD_DIR.
#
# * Path length: Libero generates core files below the project directory with
#   long names and silently skips the ones whose Windows path does not fit in
#   MAX_PATH. The build stops before Libero runs if the project directory
#   leaves less than MICROCHIP_GENERATED_PATH_LEN characters for them.
################################################################################

HDL_PROJECT_PATH := $(subst scripts/project-microchip.mk,,$(lastword $(MAKEFILE_LIST)))
HDL_LIBRARY_PATH := $(HDL_PROJECT_PATH)../library/

include $(HDL_PROJECT_PATH)../quiet.mk

LIBERO ?= libero

# --------------------------------------------------------------------------- #
# Build directory from the make parameters (as in project-xilinx.mk). The     #
# variables of the flow itself do not select a build directory.               #
# --------------------------------------------------------------------------- #
PARAMS_REPLACE_LIST := JESD LANE # list of words that should be removed from the parameter names
GEN_SED := '$(foreach name, $(PARAMS_REPLACE_LIST), s/$(name)//g;);s/_//g'
MAKE_PARAMS_EXCLUDE :=CFG VERBOSE LIBERO PFSOC_MSS PYTHON BUILD_TARGETS %_RULES SIM_% TB_% MICROCHIP_% DDR_INIT_% BFM_FILES MEM_FILES

ifdef CFG
    include $(CFG)
    export $(shell sed 's/=.*//' $(CFG) | tr '\n' ' ')
    PARAMS := $(shell cat $(CFG) | tr '\n' ' ')
    DIR_NAME := $(basename $(notdir $(CFG)))
endif

# The command line variables without a shell, which would run the values
# (e.g. SIM_RUN_CMD="run 1us; quit")
reverse = $(if $(1),$(call reverse,$(wordlist 2,$(words $(1)),$(1))) $(firstword $(1)))

ifeq ($(shell expr $(MAKELEVEL) % 2),0)
  CMD_VARIABLES := $(strip $(call reverse,$(-*-command-variables-*-)))
else
  CMD_VARIABLES := $(MAKEOVERRIDES)
endif

# Only NAME=value words: the rest of a value with spaces is not a parameter
BUILD_PARAMS := $(foreach v,$(CMD_VARIABLES),$(if $(findstring =,$(v)),$(if $(filter $(MAKE_PARAMS_EXCLUDE),$(firstword $(subst =, ,$(v)))),,$(v))))

ifneq ($(strip $(BUILD_PARAMS)), )
    PARAMS := $(strip $(PARAMS) $(BUILD_PARAMS))
    GEN_NAME := $(shell echo $(BUILD_PARAMS) | sed -e 's/[=]/_/g' | sed -e $(GEN_SED) | sed -e 's/[ .]/_/g')
    DIR_NAME := $(if $(strip $(DIR_NAME)),$(DIR_NAME)_$(GEN_NAME),$(GEN_NAME))
endif

BUILD_DIR := $(if $(strip $(DIR_NAME)),$(DIR_NAME),_bld)
SIM_BUILD_DIR := $(if $(strip $(DIR_NAME)),$(DIR_NAME)_SIM,_bld_sim)
TB_BUILD_DIR := $(if $(strip $(DIR_NAME)),$(DIR_NAME)_TB,_bld_tb)

# The logs of a build without parameters are in the project directory, the
# ones of a build with parameters in its build directory
log_dir = $(if $(strip $(DIR_NAME)),$(1)/,)

# The MSS log of the build directory $(1), named after its project
mss_log = $(call log_dir,$(1))$(if $(filter $(SIM_BUILD_DIR),$(1)),$(SIM_PRJ_NAME),$(PROJECT_NAME))_mss.log

PROJECT_DIR ?= $(BUILD_DIR)/prj
export ADI_BUILD_DIR := $(PROJECT_DIR)
PROJECT_PRJX ?= $(PROJECT_DIR)/$(PROJECT_NAME).prjx
BITSTREAM ?= $(PROJECT_DIR)/designer/system_top/system_top.ppd
FLASHPRO_JOB ?= $(PROJECT_DIR)/designer/system_top/export/system_top.job
PROJECT_LOG ?= $(call log_dir,$(BUILD_DIR))$(PROJECT_NAME)_libero.log
BUILD_INFO ?= $(PROJECT_DIR)/build_info.txt
BUILD_ZIP ?= $(dir $(FLASHPRO_JOB))$(PROJECT_NAME).zip

HSS_SCRIPT ?= $(HDL_PROJECT_PATH)scripts/adi_make_hss.sh
HSS_DIR ?= $(BUILD_DIR)/hss
HSS_LOG ?= $(call log_dir,$(BUILD_DIR))$(PROJECT_NAME)_hss.log
HSS_FLAGS ?=

DEFAULT_BUILD_TARGETS += $(PROJECT_PRJX)
ifeq ($(filter-out 0,$(strip $(ADI_SKIP_RUN))),)
DEFAULT_BUILD_TARGETS += $(BITSTREAM)
DEFAULT_BUILD_TARGETS += $(FLASHPRO_JOB)
endif

BUILD_TARGETS ?= $(DEFAULT_BUILD_TARGETS)

MSS_CONFIG ?=
MSS_NAME ?= mss_base
# The projects import the MSS from the mss directory next to them
MSS_CXZ := $(BUILD_DIR)/mss/$(MSS_NAME).cxz
SIM_MSS_CXZ := $(SIM_BUILD_DIR)/mss/$(MSS_NAME).cxz
PFSOC_MSS ?= pfsoc_mss
PYTHON ?= python3

# --------------------------------------------------------------------------- #
# Cygwin path conversion – Libero is a Windows-native application and cannot
# resolve Cygwin paths such as /home/user/…
# --------------------------------------------------------------------------- #
CYGPATH_AVAIL := $(shell command -v cygpath 2>/dev/null)

ifdef CYGPATH_AVAIL
  to_win_path = $(shell cygpath -m $(1))
else
  to_win_path = $(1)
endif

# The longest path Windows tools accept (MAX_PATH without the terminating NUL)
# and the longest path Libero generates below the project directory (the
# PFSOC_INIT_MONITOR core of the common mpfs_video_kit design).
MICROCHIP_MAX_PATH ?= 259
MICROCHIP_GENERATED_PATH_LEN ?= 141
PROJECT_DIR_PATH_MAX := $(shell expr $(MICROCHIP_MAX_PATH) - 1 - $(MICROCHIP_GENERATED_PATH_LEN))

# The length of the Windows path of the directory $(1)
path_len = $(shell printf '%s' '$(call to_win_path,$(abspath $(1)))' | wc -c)

# The temporary files of the tools stay in the build directory $(1): Cygwin's
# /etc/profile sets TMP and TEMP to /tmp, outside the repository, where
# parallel builds clash (e.g. the MSS import of Libero)
tool_tmp = mkdir -p $(abspath $(1))/tmp && TMP=$(abspath $(1))/tmp TEMP=$(abspath $(1))/tmp TMPDIR=$(abspath $(1))/tmp

# Stops the build if the project directory $(1) leaves no room for the
# generated files (Windows only)
ifdef CYGPATH_AVAIL
define check_path_len
if [ $(call path_len,$(1)) -gt $(PROJECT_DIR_PATH_MAX) ]; then \
	echo "$(RED)ERROR:$(NC) The project directory [$(HL)$(1)$(NC)] is too long:"; \
	echo "its path is $(call path_len,$(1)) characters, at most $(PROJECT_DIR_PATH_MAX) leave room for the generated files."; \
	echo "Use shorter parameters, a CFG file with a short name or a shorter checkout path."; \
	exit 2; \
fi
endef
else
check_path_len = true
endif

# Fails if the simulation log $(1) reports an error (the batch simulators
# also exit with an error code, this catches the rest)
define check_sim_log
if grep -Eq "\*\* (Fatal|Error)" $(1); then \
	echo "Simulation $(RED)FAILED$(NC)"; \
	echo "For details see $(HL)$(CURDIR)/$(1)$(NC)"; \
	exit 2; \
fi
endef


# --------------------------------------------------------------------------- #
# Dependencies                                                                #
# --------------------------------------------------------------------------- #
ifneq ($(strip $(DIR_NAME)), )
CLEAN_TARGET += $(BUILD_DIR)
else
CLEAN_TARGET += $(PROJECT_DIR)
CLEAN_TARGET += $(PROJECT_LOG)
CLEAN_TARGET += $(call mss_log,$(BUILD_DIR))
CLEAN_TARGET += $(HSS_DIR)
CLEAN_TARGET += $(HSS_LOG)
endif

CLEAN_ALL_TARGET += _bld
CLEAN_ALL_TARGET += _bld_sim
CLEAN_ALL_TARGET += _bld_tb
CLEAN_ALL_TARGET += *.log

PROJECT_CLEAN_TARGET += $(PROJECT_DIR)
PROJECT_CLEAN_TARGET += $(PROJECT_LOG)

M_DEPS += $(MSS_CONFIG)
M_DEPS += $(wildcard system_project.tcl)
M_DEPS += $(wildcard system_top*.v)
M_DEPS += $(wildcard system_constr*.sdc)
M_DEPS += $(HDL_PROJECT_PATH)scripts/adi_project_microchip.tcl
M_DEPS += $(HDL_PROJECT_PATH)scripts/adi_microchip_dev_select.tcl
M_DEPS += $(HDL_PROJECT_PATH)scripts/adi_pd.tcl
M_DEPS += $(HDL_PROJECT_PATH)../scripts/adi_env.tcl
M_DEPS += $(HDL_PROJECT_PATH)../library/scripts/adi_ip_microchip.tcl
M_DEPS += $(EXTERNAL_DEPS)

M_DEPS += $(foreach dep,$(LIB_DEPS),$(HDL_LIBRARY_PATH)$(dep)/.timestamp_microchip)

# --------------------------------------------------------------------------- #
# Phony targets                                                               #
# --------------------------------------------------------------------------- #
.PHONY: all project lib open info clean clean-all external_dependencies external_dependencies_cleanup FORCE
.PHONY: hss hss-job
.PHONY: sim sim-cli sim-prj sim-prj-build sim-ddr-init sim-run sim-run-cli open-sim clean-sim clean-sim-prj
.PHONY: tb tb-cli tb-run tb-run-cli clean-tb clean-tb-dir

DEFAULT_ALL_RULES := project
ifeq ($(filter-out 0,$(strip $(ADI_SKIP_RUN))),)
DEFAULT_ALL_RULES += $(BUILD_ZIP)
endif
ALL_RULES ?= $(DEFAULT_ALL_RULES)

all: external_dependencies $(ALL_RULES)

lib: $(foreach dep,$(LIB_DEPS),$(HDL_LIBRARY_PATH)$(dep)/.timestamp_microchip)

external_dependencies: external_dependencies_cleanup $(EXTERNAL_DEPS)

external_dependencies_cleanup:
	rm -f missing_external.log

$(EXTERNAL_DEPS):
	if [ ! -d $@ ]; then \
		echo $@ >> missing_external.log ; \
	fi

ifneq ($(strip $(MSS_CONFIG)),)
M_DEPS += $(MSS_CXZ)

# Each build directory generates its own MSS (project and simulation project)
%/mss/$(MSS_NAME).cxz: $(MSS_CONFIG)
	-rm -f $(call mss_log,$*)
	-rm -rf $*/mss
	mkdir -p $*/mss
	$(call build, \
		$(call tool_tmp,$*) $(PFSOC_MSS) -GENERATE -CONFIGURATION_FILE:$(call to_win_path,$(abspath $<)) -OUTPUT_DIR:$(call to_win_path,$(abspath $*/mss)), \
		$(call mss_log,$*), \
		$(HL)$(PROJECT_NAME)$(NC) MSS)
endif

# --------------------------------------------------------------------------- #
# Library stamps                                                              #
# --------------------------------------------------------------------------- #
$(HDL_LIBRARY_PATH)%/.timestamp_microchip: TARGET := microchip
FORCE:
$(HDL_LIBRARY_PATH)%/.timestamp_microchip: FORCE
	flock $(dir $@).lock sh -c " \
	$(MAKE) -C $(dir $@) $(TARGET)"; exit $$?

# --------------------------------------------------------------------------- #
# Project build                                                               #
# --------------------------------------------------------------------------- #
project: $(BUILD_TARGETS)

$(BUILD_TARGETS): $(M_DEPS)
	@$(call check_path_len,$(PROJECT_DIR))
	$(call skip_if_missing, \
		Project, \
		$(PROJECT_NAME), \
		true, \
	rm -rf $(PROJECT_CLEAN_TARGET) ; \
	mkdir -p $(dir $(PROJECT_DIR)) ; \
	$(call build, \
		$(call tool_tmp,$(BUILD_DIR)) $(LIBERO) \
			"SCRIPT:$(call to_win_path,$(abspath system_project.tcl))" \
			"LOGFILE:$(call to_win_path,$(abspath $(PROJECT_LOG)))", \
		$(PROJECT_LOG), \
		$(HL)$(PROJECT_NAME)$(NC) project)) ; \
	ERR=$$? ; \
	$(call write_build_info,$(BUILD_INFO),$$ERR) ; \
	exit $$ERR

# The job, the bitstream, the MSS XML and the build information in one zip
$(BUILD_ZIP): $(BUILD_TARGETS)
	rm -f $@
	zip -j -q $@ $(FLASHPRO_JOB) $(BITSTREAM) $(BUILD_INFO) \
		$(if $(strip $(MSS_CONFIG)),$(BUILD_DIR)/mss/$(MSS_NAME)_mss_cfg.xml)

# --------------------------------------------------------------------------- #
# HSS: built with the MSS configuration of the build directory; hss-job also  #
# exports the job of the project with it                                      #
# --------------------------------------------------------------------------- #
# $(1): extra options of adi_make_hss.sh
define hss_build
	rm -f $(HSS_LOG)
	$(call build, \
		$(call tool_tmp,$(BUILD_DIR)) $(HSS_SCRIPT) -b $(BUILD_DIR) -o $(HSS_DIR) $(1) $(HSS_FLAGS), \
		$(HSS_LOG), \
		$(HL)$(PROJECT_NAME)$(NC) HSS)
endef

hss: $(if $(strip $(MSS_CONFIG)),$(MSS_CXZ))
	$(call hss_build,)

hss-job: project
	$(call hss_build,-j)

# --------------------------------------------------------------------------- #
# Build information: parameters, sources and artifacts of a build             #
# --------------------------------------------------------------------------- #
# $(1): file, $(2): exit code of the build (also written for a failed build)
define write_build_info
	mkdir -p $(dir $(1)); \
	{ \
	echo "project:    $(PROJECT_NAME)"; \
	echo "result:     $$(if [ $(2) = 0 ]; then echo OK; else echo FAILED; fi)"; \
	echo "build dir:  $(BUILD_DIR)"; \
	echo "parameters: $(if $(strip $(PARAMS)),$(strip $(PARAMS)),none)"; \
	echo "date:       $$(date '+%F %T %z')"; \
	echo "hdl git:    $$(git rev-parse --abbrev-ref HEAD 2>/dev/null) $$(git rev-parse HEAD 2>/dev/null)$$(git -c core.fileMode=false diff --quiet HEAD 2>/dev/null || echo ' dirty')"; \
	echo "libero:     $$(command -v $(LIBERO) 2>/dev/null)"; \
	echo "artifacts:"; \
	for f in $(PROJECT_PRJX) $(BITSTREAM) $(FLASHPRO_JOB) $(PROJECT_LOG) $(if $(strip $(MSS_CONFIG)),$(MSS_CXZ)); do \
		if [ -e $$f ]; then echo "  $$f"; else echo "  $$f (missing)"; fi; \
	done; \
	j=$(basename $(FLASHPRO_JOB))_bad_timing.job; \
	if [ -e $$j ]; then echo "  $$j (timing not met)"; fi; \
	v=$(PROJECT_DIR)/designer/system_top/system_top_has_violations; \
	if [ -f $$v ]; then \
		echo "timing:"; \
		grep -E "coverage|multi_corner " $$v | sed 's/^_/  /'; \
	fi; \
	} > $(1)
endef

# --------------------------------------------------------------------------- #
# System simulation: the simulation project (SIM_PRJ_TCL) is built with       #
# Libero, which generates the Questa script run.do of its presynth            #
# simulation; sim and sim-cli run it with Questa directly.                    #
# --------------------------------------------------------------------------- #
SIM_PRJ_NAME ?= $(PROJECT_NAME)_sim
SIM_PRJ_TCL ?= system_project_sim.tcl
SIM_PRJ_DIR ?= $(SIM_BUILD_DIR)/prj
SIM_PRJ_PRJX ?= $(SIM_PRJ_DIR)/$(SIM_PRJ_NAME).prjx
SIM_PRJ_LOG ?= $(call log_dir,$(SIM_BUILD_DIR))$(SIM_PRJ_NAME)_libero.log
SIM_LOG ?= $(call log_dir,$(SIM_BUILD_DIR))$(SIM_PRJ_NAME).log

SIM_DIR := $(SIM_PRJ_DIR)/simulation
GEN_SIM_DO := $(SIM_DIR)/run.do
ADI_SIM_DO := $(SIM_DIR)/adi_sim.do
ADI_SIM_CLI_DO := $(SIM_DIR)/adi_sim_cli.do

# The run command of the simulation (empty keeps the one of run.do) and the
# wave files loaded in the GUI
SIM_RUN_CMD ?=
SIM_WAVE ?=
SIM_VSIM_FLAGS ?=

# The simulator Libero generates run.do for (QuestaSim ME: run.do loads its
# 64 bit PLI); the scripts of run.do read ACTEL_SW_DIR, which Libero also sets.
# The install of the libero in PATH: Designer/bin on Windows (Cygwin),
# Designer/bin64 on Linux. If vsim is not there, MICROCHIP_VSIM stays empty
# and the simulation fails; set MICROCHIP_VSIM to the vsim of Libero then.
LIBERO_ROOT = $(patsubst %/Designer/bin64/,%,$(patsubst %/Designer/bin/,%,$(dir $(shell command -v $(LIBERO) 2>/dev/null))))
ifneq ($(CYGPATH_AVAIL),)
MICROCHIP_VSIM ?= $(wildcard $(LIBERO_ROOT)/QuestaSim_Pro/win64/vsim.exe)
else
MICROCHIP_VSIM ?= $(wildcard $(LIBERO_ROOT)/QuestaSim_Pro/linux_x86_64/vsim)
endif
SIM_VSIM = ACTEL_SW_DIR="$(call to_win_path,$(LIBERO_ROOT)/Designer)" "$(MICROCHIP_VSIM)"

# SIM_RUN_FILES: the files the simulation reads at run time, named as the
# simulation expects them; by default the BFM scripts (run.do compiles them)
# and the memory files (e.g. the DDR init file) of verification/. make copies
# them into the simulation directory before every run, so a change of them
# runs only the simulation again, not the simulation project. A project
# Makefile can replace or extend any of the lists.
BFM_FILES ?= $(wildcard verification/*.bfm)
MEM_FILES ?= $(wildcard verification/*.mem)
SIM_RUN_FILES ?= $(BFM_FILES) $(MEM_FILES)

define sim_copy_files
$(if $(strip $(SIM_RUN_FILES)),cp -f $(SIM_RUN_FILES) $(SIM_DIR)/,true)
endef

DEFAULT_SIM_PRJ_DEPS += $(SIM_PRJ_TCL)
DEFAULT_SIM_PRJ_DEPS += $(wildcard system_*_sim.tcl)
# Not the files only the runs read (SIM_RUN_FILES, the SIM_WAVE of the GUI)
DEFAULT_SIM_PRJ_DEPS += $(filter-out $(SIM_RUN_FILES) $(SIM_WAVE),$(wildcard verification/*))
DEFAULT_SIM_PRJ_DEPS += $(filter-out $(MSS_CXZ),$(M_DEPS))
ifneq ($(strip $(MSS_CONFIG)),)
DEFAULT_SIM_PRJ_DEPS += $(SIM_MSS_CXZ)
endif
SIM_PRJ_DEPS ?= $(DEFAULT_SIM_PRJ_DEPS)

DEFAULT_SIM_PRJ_RULES := sim-prj-build
SIM_PRJ_RULES ?= $(DEFAULT_SIM_PRJ_RULES)
DEFAULT_SIM_RULES := sim-prj sim-run
SIM_RULES ?= $(DEFAULT_SIM_RULES)
DEFAULT_SIM_CLI_RULES := sim-prj sim-run-cli
SIM_CLI_RULES ?= $(DEFAULT_SIM_CLI_RULES)

# DDR initialization of the MSS DDR model from a user memory file (see
# sim-ddr-init in the header; "PolarFire SoC MSS Simulation User Guide"). The
# output is the DDR init file of verification/, which make copies into the
# simulation directory with the MEM_FILES before every run.
DDR_INIT_CONVERTER_URL := https://ww1.microchip.com/downloads/secure/aemdocuments/documents/fpga/socdesignfiles/pfsoc_mss_ddr_init_v2.zip
# By default the script anywhere in the repository (searched only when
# sim-ddr-init runs)
DDR_INIT_CONVERTER ?= $(firstword $(shell find $(abspath $(HDL_PROJECT_PATH)..) -name .git -prune -o -name pfsoc_mss_ddr_init_v2.py -type f -print 2>/dev/null))
# The MSS netlist with the DDR configuration: taken from the MSS component of
# the simulation build (the netlist of the simulation project is the same),
# so the simulation project is not needed
DDR_INIT_NETLIST ?= $(SIM_BUILD_DIR)/mss/$(MSS_NAME).v
DDR_INIT_USER_MEM ?=
DDR_INIT_OUTPUT ?= verification/PFSoC_MSS_DDR_INIT.mem

ifneq ($(strip $(MSS_CONFIG)),)
$(SIM_BUILD_DIR)/mss/$(MSS_NAME).v: $(SIM_MSS_CXZ)
	$(PYTHON) -c 'import sys, zipfile; open(sys.argv[3], "wb").write(zipfile.ZipFile(sys.argv[1]).read(sys.argv[2]))' $< $(notdir $@) $@
endif

ifneq ($(strip $(DIR_NAME)), )
CLEAN_SIM_TARGET += $(SIM_BUILD_DIR)
else
CLEAN_SIM_TARGET += $(SIM_PRJ_DIR)
CLEAN_SIM_TARGET += $(SIM_PRJ_LOG)
CLEAN_SIM_TARGET += $(SIM_LOG)
CLEAN_SIM_TARGET += $(call mss_log,$(SIM_BUILD_DIR))
endif

sim-prj: $(SIM_PRJ_RULES)

sim: $(SIM_RULES)

sim-cli: $(SIM_CLI_RULES)

sim-prj-build: $(SIM_PRJ_PRJX)

$(SIM_PRJ_PRJX): $(SIM_PRJ_DEPS)
	@$(call check_path_len,$(SIM_PRJ_DIR))
	$(call skip_if_missing, \
		Project, \
		$(SIM_PRJ_NAME), \
		true, \
	rm -rf $(SIM_PRJ_DIR) $(SIM_PRJ_LOG) ; \
	mkdir -p $(dir $(SIM_PRJ_DIR)) ; \
	$(call build, \
		$(call tool_tmp,$(SIM_BUILD_DIR)) ADI_BUILD_DIR=$(SIM_PRJ_DIR) $(LIBERO) \
			"SCRIPT:$(call to_win_path,$(abspath $(SIM_PRJ_TCL)))" \
			"LOGFILE:$(call to_win_path,$(abspath $(SIM_PRJ_LOG)))", \
		$(SIM_PRJ_LOG), \
		$(HL)$(SIM_PRJ_NAME)$(NC) project))

sim-ddr-init: $(DDR_INIT_NETLIST)
	@if [ ! -f "$(DDR_INIT_CONVERTER)" ]; then \
		echo "$(RED)ERROR:$(NC) The DDR init script pfsoc_mss_ddr_init_v2.py is not found$(if $(strip $(DDR_INIT_CONVERTER)), [$(HL)$(DDR_INIT_CONVERTER)$(NC)], in the repository)."; \
		echo "Download it (with a Microchip login) from"; \
		echo "  $(DDR_INIT_CONVERTER_URL)"; \
		echo "and unzip it into the repository, e.g. into [$(HL)$(abspath $(HDL_PROJECT_PATH)..)$(NC)],"; \
		echo "or pass its path in $(HL)DDR_INIT_CONVERTER$(NC)."; \
		exit 2; \
	fi
	@if [ -z "$(strip $(DDR_INIT_USER_MEM))" ]; then \
		echo "$(RED)ERROR:$(NC) $(HL)DDR_INIT_USER_MEM$(NC) (the user memory file) has to be set."; \
		exit 2; \
	fi
	# the regular expressions of the script warn in Python 3.12 and later
	$(PYTHON) -W ignore::SyntaxWarning "$(DDR_INIT_CONVERTER)" \
		-netlist_path "$(DDR_INIT_NETLIST)" \
		-user_mem_path "$(DDR_INIT_USER_MEM)" \
		-ddr_mem_path "$(DDR_INIT_OUTPUT)"
	# the script writes no newline at the end of the file
	@[ -z "$$(tail -c1 "$(DDR_INIT_OUTPUT)")" ] || echo >> "$(DDR_INIT_OUTPUT)"

# run.do up to its run command (the design loaded), without its quit on error,
# then the commands $(1) and the run command (SIM_RUN_CMD or the one of run.do)
define sim_do
if [ ! -f $(GEN_SIM_DO) ]; then \
	echo "$(RED)ERROR:$(NC) No [$(HL)$(GEN_SIM_DO)$(NC)]: the simulation project has no presynth simulation." >&2; \
	exit 2; \
fi; \
sed -n -e '/^[[:space:]]*run[[:space:]]/q' -e '/^[[:space:]]*on\(error\|break\)[[:space:]]/d' -e p $(GEN_SIM_DO); \
$(1) \
if [ -n "$(strip $(SIM_RUN_CMD))" ]; then \
	echo "$(SIM_RUN_CMD)"; \
else \
	grep -m1 '^[[:space:]]*run[[:space:]]' $(GEN_SIM_DO); \
fi
endef

# GUI: the wave files of SIM_WAVE are loaded before the run (both do files are
# regenerated every time, so that SIM_RUN_CMD and SIM_WAVE always take effect)
$(ADI_SIM_DO): $(SIM_PRJ_PRJX) FORCE
	@{ $(call sim_do,$(foreach w,$(SIM_WAVE),echo "do {$(call to_win_path,$(abspath $(w)))}";)); } > $@

# Batch mode: an error or a failed testbench ($error, $fatal) sets the exit
# code; onbreak and onerror work only in a do file. Rewritten only if its
# content changes (the simulator and its flags are in it too), so that an
# unchanged simulation does not run again.
$(ADI_SIM_CLI_DO): $(SIM_PRJ_PRJX) FORCE
	@{ \
		echo "# $(MICROCHIP_VSIM) -c $(SIM_VSIM_FLAGS)"; \
		echo "onbreak {quit -code 1 -force}"; \
		echo "onerror {quit -code 1 -force}"; \
		$(call sim_do,); \
		echo 'quit -code [expr {[coverage attribute -name TESTSTATUS -concise] >= 2}] -force'; \
	} > $@.tmp; \
	if cmp -s $@.tmp $@; then rm -f $@.tmp; else mv -f $@.tmp $@; fi

# Written after a passed batch simulation; sim-cli runs the simulation again
# only if any of its dependencies is newer: the simulation project (all the
# sources of the project, the testbench and the libraries), SIM_RUN_FILES,
# the do file or the makefiles
SIM_CLI_PASS := $(SIM_PRJ_DIR)/$(SIM_PRJ_NAME).pass

# The run rules depend on the other rules of their list: those run first
sim-run: $(ADI_SIM_DO) $(filter-out sim-run,$(SIM_RULES))
	-rm -f $(SIM_LOG)
	$(call sim_copy_files)
	$(call build, \
		(cd $(SIM_DIR) && $(call tool_tmp,$(SIM_BUILD_DIR)) $(SIM_VSIM) -gui $(SIM_VSIM_FLAGS) -do $(notdir $(ADI_SIM_DO))), \
		$(SIM_LOG), \
		$(HL)$(SIM_PRJ_NAME)$(NC) simulation)

sim-run-cli: $(SIM_CLI_PASS)
	@echo "$(HL)$(SIM_PRJ_NAME)$(NC) simulation passed [$(HL)$(SIM_LOG)$(NC)]"

$(SIM_CLI_PASS): $(ADI_SIM_CLI_DO) $(SIM_PRJ_PRJX) $(SIM_RUN_FILES) $(MAKEFILE_LIST) | $(filter-out sim-run-cli,$(SIM_CLI_RULES))
	-rm -f $@ $(SIM_LOG)
	$(call sim_copy_files)
	$(call build, \
		(cd $(SIM_DIR) && $(call tool_tmp,$(SIM_BUILD_DIR)) $(SIM_VSIM) -c $(SIM_VSIM_FLAGS) -do $(notdir $(ADI_SIM_CLI_DO))), \
		$(SIM_LOG), \
		$(HL)$(SIM_PRJ_NAME)$(NC) simulation)
	@$(call check_sim_log,$(SIM_LOG))
	touch $@

open-sim:
	@if [ ! -f $(SIM_PRJ_PRJX) ]; then \
		echo "$(RED)ERROR:$(NC) No Libero project [$(HL)$(SIM_PRJ_PRJX)$(NC)] found."; \
		exit 2; \
	fi
	$(LIBERO) $(SIM_PRJ_PRJX) &

clean-sim:
	$(call clean, \
		$(CLEAN_SIM_TARGET), \
		$(HL)$(SIM_PRJ_NAME)$(NC) project)

clean-sim-prj: clean-sim

# --------------------------------------------------------------------------- #
# Testbench without a project: TB_SCRIPT runs TB_TOP of TB_FILES in the       #
# testbench directory as `TB_SCRIPT --gui|--cli --top <top> [TB_OPTS] <files>`;#
# its exit code is the result. The tool specific settings belong to it.       #
# --------------------------------------------------------------------------- #
TB_SCRIPT ?= $(HDL_LIBRARY_PATH)common/tb/run_tb_microchip.sh
TB_OPTS ?=
# Further files of the testbench, which are not in TB_FILES (e.g. the files
# it includes or reads)
TB_DEPS ?=

TB_DIR = $(TB_BUILD_DIR)/$(TB_TOP)
TB_LOG = $(call log_dir,$(TB_BUILD_DIR))$(TB_TOP).log

# The command of the batch testbench (with the libero of PATH, whose
# simulator and libraries it runs with), rewritten only if it changes; the
# stamp is written after a passed run. tb-cli runs the testbench again only if
# any of TB_FILES, TB_DEPS, TB_SCRIPT, the command or the makefiles is newer.
TB_CLI_CMD = $(TB_BUILD_DIR)/$(TB_TOP).cmd
TB_CLI_PASS = $(TB_BUILD_DIR)/$(TB_TOP).pass

DEFAULT_TB_RULES := tb-run
TB_RULES ?= $(DEFAULT_TB_RULES)
DEFAULT_TB_CLI_RULES := tb-run-cli
TB_CLI_RULES ?= $(DEFAULT_TB_CLI_RULES)
DEFAULT_CLEAN_TB_RULES := clean-tb-dir
CLEAN_TB_RULES ?= $(DEFAULT_CLEAN_TB_RULES)

define check_tb
@if [ -z "$(strip $(TB_TOP))" ] || [ -z "$(strip $(TB_FILES))" ]; then \
	echo "$(RED)ERROR:$(NC) No testbench: the project has to set $(HL)TB_FILES$(NC) and $(HL)TB_TOP$(NC)."; \
	exit 2; \
fi
endef

# $(1): gui or cli
define run_tb
$(call check_tb)
-rm -rf $(TB_DIR) $(TB_LOG)
mkdir -p $(TB_DIR)
$(call build, \
	(cd $(TB_DIR) && $(call tool_tmp,$(TB_BUILD_DIR)) bash "$(abspath $(TB_SCRIPT))" --$(1) --top $(TB_TOP) $(TB_OPTS) $(abspath $(TB_FILES))), \
	$(TB_LOG), \
	$(HL)$(TB_TOP)$(NC) testbench)
endef

tb: $(TB_RULES)

tb-cli: $(TB_CLI_RULES)

tb-run: $(filter-out tb-run,$(TB_RULES))
	$(call run_tb,gui)

tb-run-cli: $(TB_CLI_PASS)
	@echo "$(HL)$(TB_TOP)$(NC) testbench passed [$(HL)$(TB_LOG)$(NC)]"

$(TB_CLI_CMD): FORCE
	$(call check_tb)
	@mkdir -p $(dir $@)
	@echo "$$(command -v $(LIBERO)) $(TB_SCRIPT) --cli --top $(TB_TOP) $(TB_OPTS) $(TB_FILES)" > $@.tmp; \
	if cmp -s $@.tmp $@; then rm -f $@.tmp; else mv -f $@.tmp $@; fi

$(TB_CLI_PASS): $(TB_CLI_CMD) $(TB_FILES) $(TB_DEPS) $(TB_SCRIPT) $(MAKEFILE_LIST) | $(filter-out tb-run-cli,$(TB_CLI_RULES))
	-rm -f $@
	$(call run_tb,cli)
	touch $@

clean-tb: $(CLEAN_TB_RULES)

clean-tb-dir:
	$(call clean, \
		$(TB_BUILD_DIR) $(if $(strip $(DIR_NAME)),,$(if $(strip $(TB_TOP)),$(TB_LOG))), \
		$(HL)$(PROJECT_NAME)$(NC) testbenches)

# --------------------------------------------------------------------------- #
# Utilities                                                                   #
# --------------------------------------------------------------------------- #
open:
	@if [ ! -f $(PROJECT_PRJX) ]; then \
		echo "$(RED)ERROR:$(NC) No Libero project [$(HL)$(PROJECT_PRJX)$(NC)] found."; \
		exit 2; \
	fi
	$(LIBERO) $(PROJECT_PRJX) &

info:
	@echo "parameters: $(if $(strip $(PARAMS)),$(strip $(PARAMS)),none)"
	@echo "project:    $(PROJECT_PRJX) (directory path $(call path_len,$(PROJECT_DIR)) of at most $(PROJECT_DIR_PATH_MAX) characters)"
	@echo "mss:        $(MSS_CXZ)"
	@echo "bitstream:  $(BITSTREAM)"
	@echo "job:        $(FLASHPRO_JOB)"
	@echo "log:        $(PROJECT_LOG)"
	@echo "build info: $(BUILD_INFO)"
	@echo "zip:        $(BUILD_ZIP)"
	@echo "hss:        $(HSS_DIR) (log $(HSS_LOG))"
	@echo "sim prj:   $(SIM_PRJ_PRJX) (directory path $(call path_len,$(SIM_PRJ_DIR)) of at most $(PROJECT_DIR_PATH_MAX) characters)"
	@echo "sim mss:    $(SIM_MSS_CXZ)"
	@echo "sim script: $(GEN_SIM_DO)"
	@echo "sim logs:   $(SIM_PRJ_LOG) $(SIM_LOG)"
	@echo "tb dir:     $(TB_BUILD_DIR)"
	@echo "tb script:  $(TB_SCRIPT)"
	@echo "rules:      all: $(ALL_RULES); sim-prj: $(SIM_PRJ_RULES); sim: $(SIM_RULES); sim-cli: $(SIM_CLI_RULES)"
	@echo "            tb: $(TB_RULES); tb-cli: $(TB_CLI_RULES); clean-tb: $(CLEAN_TB_RULES)"
	@if [ -f $(BUILD_INFO) ]; then echo; cat $(BUILD_INFO); fi

clean:
	$(call clean, \
		$(CLEAN_TARGET), \
		$(HL)$(PROJECT_NAME)$(NC) project)

clean-all:
	$(call clean, \
		$(CLEAN_ALL_TARGET), \
		$(HL)$(PROJECT_NAME)$(NC) all builds)
	@for lib in $(LIB_DEPS); do \
		$(MAKE) -C $(HDL_LIBRARY_PATH)$${lib} clean; \
	done
