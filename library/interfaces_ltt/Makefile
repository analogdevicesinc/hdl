####################################################################################
####################################################################################
## Copyright (c) 2024 - 2026 Analog Devices, Inc.
### SPDX short identifier: BSD-1-Clause
####################################################################################
####################################################################################
HDL_LIBRARY_PATH := ../

include ../../quiet.mk
include ../scripts/lattice_tool_set.mk

L_DEPS := interfaces_ltt.tcl
L_DEPS += ../../scripts/adi_env.tcl
L_DEPS += ../scripts/adi_ip_lattice.tcl

LTT_INTERFACE_FILES := analog.com/ADI/fifo_rd/1.0/fifo_rd.xml
LTT_INTERFACE_FILES += analog.com/ADI/fifo_rd/1.0/fifo_rd_rtl.xml
LTT_INTERFACE_FILES += analog.com/ADI/fifo_wr/1.0/fifo_wr.xml
LTT_INTERFACE_FILES += analog.com/ADI/fifo_wr/1.0/fifo_wr_rtl.xml
LTT_INTERFACE_FILES += analog.com/ADI/spi_master/1.0/spi_master.xml
LTT_INTERFACE_FILES += analog.com/ADI/spi_master/1.0/spi_master_rtl.xml
LTT_INTERFACE_FILES += analog.com/ADI/spi_engine_ctrl/1.0/spi_engine_ctrl.xml
LTT_INTERFACE_FILES += analog.com/ADI/spi_engine_ctrl/1.0/spi_engine_ctrl_rtl.xml
LTT_INTERFACE_FILES += analog.com/ADI/spi_engine_offload_ctrl/1.0/spi_engine_offload_ctrl.xml
LTT_INTERFACE_FILES += analog.com/ADI/spi_engine_offload_ctrl/1.0/spi_engine_offload_ctrl_rtl.xml
LTT_INTERFACE_FILES += analog.com/ADI/if_framelock/1.0/if_framelock.xml
LTT_INTERFACE_FILES += analog.com/ADI/if_framelock/1.0/if_framelock_rtl.xml
LTT_INTERFACE_FILES += analog.com/ADI/spi_engine_interconnect_ctrl/1.0/spi_engine_interconnect_ctrl.xml
LTT_INTERFACE_FILES += analog.com/ADI/spi_engine_interconnect_ctrl/1.0/spi_engine_interconnect_ctrl_rtl.xml

LTT_INTERFACE_DIRS := analog.com/ADI/fifo_rd
LTT_INTERFACE_DIRS += analog.com/ADI/fifo_wr
LTT_INTERFACE_DIRS += analog.com/ADI/spi_master
LTT_INTERFACE_DIRS += analog.com/ADI/spi_engine_ctrl
LTT_INTERFACE_DIRS += analog.com/ADI/spi_engine_offload_ctrl
LTT_INTERFACE_DIRS += analog.com/ADI/if_framelock
LTT_INTERFACE_DIRS += analog.com/ADI/spi_engine_interconnect_ctrl

CLEAN_TARGETS += $(LTT_INTERFACE_DIRS)

LTT_INTERFACES := $(addprefix ltt/,$(LTT_INTERFACE_FILES))

ifeq ($(LATTICE_DEFAULT_PATHS),1)
LTT_INTERFACES += $(addprefix $(LATTICE_DEFAULT_INTERFACE_PATH)/,$(LTT_INTERFACE_FILES))
CLEAN_TARGETS += $(addprefix $(LATTICE_DEFAULT_INTERFACE_PATH)/,$(LTT_INTERFACE_DIRS))
endif

CLEAN_TARGETS += .lock
CLEAN_TARGETS += $(wildcard ./*/)
CLEAN_TARGETS += interfaces_ltt.log

.PHONY: all lattice clean clean-all

all: $(LTT_INTERFACES)

clean: clean-all

clean-all:
	$(call clean, \
		$(CLEAN_TARGETS), \
		interfaces definitions)

$(LTT_INTERFACES): $(L_DEPS)
	-rm -fr $(CLEAN_TARGETS)
	$(call build, \
		$(LATTICE_IP_TOOL) interfaces_ltt.tcl, \
		interfaces_ltt.log, \
		interfaces definitions)
