####################################################################################
## Copyright 2018(c) Analog Devices, Inc.
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

  # build - Run a build command
  # $(1): Command to execute
  # $(2): Logfile name
  # $(3): Textual description of the task
  define build
	@echo -n "Building $(strip $(3)) [$(HL)$(CURDIR)/$(strip $(2))$(NC)] ..."
	$(strip $(1)) >> $(strip $(2)) 2>&1; \
	(ERR=$$?; if [ $$ERR = 0 ]; then \
		echo " $(GREEN)OK$(NC)"; \
	else \
		echo " $(RED)FAILED$(NC)"; \
		echo "For details see $(HL)$(CURDIR)/$(strip $(2))$(NC)"; \
		echo ""; \
	fi; exit $$ERR)
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
