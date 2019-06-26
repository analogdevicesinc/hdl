####################################################################################
####################################################################################
## Copyright 2018(c) Analog Devices, Inc.
####################################################################################
####################################################################################

# Assumes this file is in <HDL>/testbenches/scripts/project-sim.mk 
ADI_HDL_DIR := $(subst /testbenches/scripts/project-sim.mk,,$(abspath $(lastword $(MAKEFILE_LIST))))
HDL_LIBRARY_PATH := $(ADI_HDL_DIR)/library/
include $(ADI_HDL_DIR)/quiet.mk

ENV_DEPS += $(foreach dep,$(LIB_DEPS),$(HDL_LIBRARY_PATH)$(dep)/component.xml)

# simulate - Run a sim command and look in logfile for errors; creates JUnit XML
# $(1): Command to execute
# $(2): Logfile name
# $(3): Textual description of the task
# $(4): configuration name
# $(5): test  name
define simulate
@echo -n "$(strip $(3)) [$(HL)$(CURDIR)/$(strip $(2))$(NC)] ..."
START=$$(date +%s); \
$(strip $(1)) >> $(strip $(2)) 2>&1; \
(ERR=$$?; \
END=$$(date +%s); \
DIFF=$$(( $$END - $$START )); \
ERRS=`grep -v ^# $(2) | grep -w -i -e error -e fatal -e fatal_error -C 10`; \
if [[ $$ERRS > 0 ]] ; then ERR=1; fi;\
JF='results/$(strip $(4))_$(strip $(5)).xml'; \
echo \<testsuite\> > $$JF; \
echo \<testcase classname=\"$(strip $(4))\" name=\"$(strip $(5))\" time=\"$$DIFF\" \> >> $$JF; \
if [ $$ERR = 0 ]; then \
	echo " $(GREEN)OK$(NC)"; \
else \
	echo " $(RED)FAILED$(NC)"; \
	echo "For details see $(HL)$(CURDIR)/$(strip $(2))$(NC)"; \
	echo ""; \
	echo \<failure\> >> $$JF; \
	echo "$$ERRS" >>  $$JF; \
	echo \<\/failure\> >> $$JF; \
fi; \
echo \<\/testcase\> >> $$JF; \
echo \<\/testsuite\> >> $$JF; \
exit $$ERR)
endef

# For Cygwin, Vivado must be called from the Windows environment
ifeq ($(OS), Windows_NT)
CMD_PRE = cmd /C "
CMD_POST = "
RUN_SIM_PATH = $(shell cygpath -w $(ADI_HDL_DIR)/testbenches/scripts/run_sim.tcl) 
else
CMD_PRE =
CMD_POST =
RUN_SIM_PATH = $(ADI_HDL_DIR)/testbenches/scripts/run_sim.tcl
endif

# This rule template will build the environment
# $(1): configuration name
define build
$(addprefix runs/,$(1)/system_project.log) : library $(addprefix cfgs/,$(1).tcl) $(ENV_DEPS)
	-rm -rf $(addprefix runs/,$(1))
	mkdir -p runs
	mkdir -p $(addprefix runs/,$(1))
	mkdir -p results
	-$$(call simulate, \
		$(CMD_PRE) $(M_VIVADO_BATCH) system_project.tcl -tclargs $(1).tcl $(CMD_POST), \
		$$@, \
		Building $(HL)$(strip $(1))$(NC) env, \
		$(1), \
		BuildEnv)
endef

# This rule template will run the simulation
# $(1): configuration name
# $(2): test name
define sim
$(1) += $(addprefix runs/,$(addprefix $(1)/,$(2).log))
$(addprefix runs/,$(addprefix $(1)/,$(2).log)): $(addprefix runs/,$(1)/system_project.log) $(addprefix tests/,$(2).sv) $(SV_DEPS)
	-$$(call simulate, \
		$(CMD_PRE) $(M_VIVADO) $(RUN_SIM_PATH) -tclargs $(1) $(2) $(MODE) $(CMD_POST), \
		$$@, \
		Running $(HL)$(strip $(2))$(NC) test on $(HL)$(strip $(1))$(NC) env, \
		$(1), \
		$(2))
endef

# Run an arbitrary test on an arbitrary configuration by taking
# the values from the command line and overwriting the target goal
ifneq ($(CFG),)
ifneq ($(TST),)
TESTS += $(CFG):$(TST)
.DEFAULT_GOAL := runs/$(CFG)/$(TST).log
endif
endif

MODE ?= "batch"

M_VIVADO := vivado -nolog -nojournal -mode ${MODE} -source
M_VIVADO_BATCH := vivado -nolog -nojournal -mode batch -source

BUILD_CFGS =
# Extract the list of configurations
$(foreach cfg_test, $(TESTS),\
	$(eval cfg = $(word 1,$(subst :, ,$(cfg_test)))) \
	$(eval BUILD_CFGS += $(cfg))\
)
# Make list unique
BUILD_CFGS := $(sort $(BUILD_CFGS))

.PHONY: all library clean $(BUILD_CFGS)

all: $(BUILD_CFGS) 

clean:
	-rm -rf runs
	-rm -rf results

library:
	@for lib in $(LIB_DEPS); do \
		$(MAKE) -C $(HDL_LIBRARY_PATH)$${lib} xilinx || exit $$?; \
	done

# Create here the targets which build the test env
$(foreach cfg, $(BUILD_CFGS), $(eval $(call build, $(cfg))))

# Create here the targets which run the actual simulations
# TESTS format:  <configuration>:<test name>
$(foreach cfg_test, $(TESTS),\
	$(eval cfg = $(word 1,$(subst :, ,$(cfg_test)))) \
	$(eval test = $(word 2,$(subst :, ,$(cfg_test)))) \
	$(eval $(call sim, $(cfg), $(test))) \
)

# Group sim targets based on env config so we can run easily all test 
# from one configuration 
# e.g "make cfg1"  will run all tests associated to that configuration
$(foreach cfg, $(BUILD_CFGS),\
	$(eval $(cfg): $($(cfg))) \
)

