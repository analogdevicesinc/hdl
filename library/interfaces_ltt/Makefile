####################################################################################
####################################################################################
## Copyright (c) 2024 - 2025 Analog Devices, Inc.
### SPDX short identifier: BSD-1-Clause
####################################################################################
####################################################################################
HDL_LIBRARY_PATH := ../

include ../../quiet.mk
include ../scripts/lattice_tool_set.mk

L_DEPS := interfaces_ltt.tcl
L_DEPS += ../../scripts/adi_env.tcl
L_DEPS += ../scripts/adi_ip_lattice.tcl

LTT_INTERFACES := analog.com/ADI/fifo_rd/1.0/fifo_rd.xml
LTT_INTERFACES += analog.com/ADI/fifo_rd/1.0/fifo_rd_rtl.xml
LTT_INTERFACES += analog.com/ADI/fifo_wr/1.0/fifo_wr.xml
LTT_INTERFACES += analog.com/ADI/fifo_wr/1.0/fifo_wr_rtl.xml
LTT_INTERFACES += analog.com/ADI/spi_master/1.0/spi_master.xml
LTT_INTERFACES += analog.com/ADI/spi_master/1.0/spi_master_rtl.xml
LTT_INTERFACES += analog.com/ADI/spi_engine_ctrl/1.0/spi_engine_ctrl.xml
LTT_INTERFACES += analog.com/ADI/spi_engine_ctrl/1.0/spi_engine_ctrl_rtl.xml
LTT_INTERFACES += analog.com/ADI/spi_engine_offload_ctrl/1.0/spi_engine_offload_ctrl.xml
LTT_INTERFACES += analog.com/ADI/spi_engine_offload_ctrl/1.0/spi_engine_offload_ctrl_rtl.xml
LTT_INTERFACES += analog.com/ADI/if_framelock/1.0/if_framelock.xml
LTT_INTERFACES += analog.com/ADI/if_framelock/1.0/if_framelock_rtl.xml

CLEAN_TARGETS += analog.com/ADI/fifo_rd
CLEAN_TARGETS += analog.com/ADI/fifo_wr
CLEAN_TARGETS += analog.com/ADI/spi_master
CLEAN_TARGETS += analog.com/ADI/spi_engine_ctrl
CLEAN_TARGETS += analog.com/ADI/spi_engine_offload_ctrl
CLEAN_TARGETS += analog.com/ADI/if_framelock

ifeq ($(LATTICE_DEFAULT_PATHS),1)
LTT_INTERFACES := $(LTT_INTERFACES) $(foreach dep,$(LTT_INTERFACES),$(LATTICE_DEFAULT_INTERFACE_PATH)/$(dep))
CLEAN_TARGETS := $(CLEAN_TARGETS) $(foreach dep,$(CLEAN_TARGETS),$(LATTICE_DEFAULT_INTERFACE_PATH)/$(dep))
endif

CLEAN_TARGETS += $(wildcard ./*/)
CLEAN_TARGETS += interfaces_ltt.log

.PHONY: all lattice clean clean-all

all: $(LTT_INTERFACES)

clean: clean-all

clean-all:
	$(call clean, \
		$(CLEAN_TARGETS) .lock, \
		$(HL)ADI$(NC) interfaces for lattice)

$(LTT_INTERFACES): $(L_DEPS)
	$(call build, \
		$(LATTICE_IP_TOOL) interfaces_ltt.tcl, \
		interfaces_ltt.log, \
		$(HL)ADI$(NC) interfaces for lattice)
