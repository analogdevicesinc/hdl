####################################################################################
## Copyright (c) 2018 - 2021 Analog Devices, Inc.
## SPDX short identifier: BSD-1-Clause
####################################################################################

ifdef MAKE_TERMOUT
  ESC:=$(shell printf '\033')
  GREEN:=$(ESC)[1;32m
  RED:=$(ESC)[1;31m
  HL:=$(ESC)[0;33m
  NC:=$(ESC)[0m
else
  GREEN:=
  RED:=
  HL:=
  NC:=
endif

ifneq ($(VERBOSE),1)
  MAKEFLAGS += --quiet

  # skip_if_missing - Skip if file condition matches:
  # * if missing_external.log exists
  # $(1): Type
  # $(2): Type name
  # $(3): Command to execute if skipping the lib
  # $(4): Command to execute if not skipping the lib
  define skip_if_missing
	if [ -f missing_external.log ]; then \
		echo "$(1) $(HL)$(strip $(2)) SKIPPED$(NC)" due to missing external dependencies; \
		echo "For the list of expected files see $(HL)$(CURDIR)/missing_external.log$(NC)"; \
		($(3)) ; \
	else \
		($(4)) ; \
	fi
  endef

  # build - Run a build command
  # $(1): Command to execute
  # $(2): Logfile name
  # $(3): Textual description of the task
  define build
	(echo $(if $(filter -j%,$(MAKEFLAGS)),,-n) "Building $(strip $(3)) [$(HL)$(CURDIR)/$(strip $(2))$(NC)] ..." ; \
	$(strip $(1)) >> $(strip $(2)) 2>&1 ; \
	(ERR=$$?; if [ $$ERR = 0 ]; then \
		echo "$(if $(filter -j%,$(MAKEFLAGS)),Build $(strip $(3)) [$(HL)$(CURDIR)/$(strip $(2))$(NC)]) $(GREEN)OK$(NC)"; \
	else \
		echo "$(if $(filter -j%,$(MAKEFLAGS)),Build $(strip $(3)) [$(HL)$(CURDIR)/$(strip $(2))$(NC)]) $(RED)FAILED$(NC)"; \
		echo "For details see $(HL)$(CURDIR)/$(strip $(2))$(NC)"; \
		echo ""; \
	fi ; exit $$ERR))
  endef

  # clean - Run a clean command
  # $(1): Files to remove
  # $(2): Textural description of the task
  define clean
	@echo "Cleaning $(strip $(2)) ..."
	-rm -rf $(strip $(1))
  endef
else
  define build
	$(strip $(1)) >> $(strip $(2)) 2>&1
  endef

  define clean
	-rm -rf $(strip $(1))
  endef
endif
