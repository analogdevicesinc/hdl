####################################################################################
####################################################################################
## Copyright (c) 2018 - 2024 Analog Devices, Inc.
### SPDX short identifier: BSD-1-Clause
####################################################################################
####################################################################################

ifeq ($(OS), Windows_NT)
	PROPEL_BUILDER := propelbld
else
	PROPEL_BUILDER := propelbldwrap
endif

L_DEPS := interfaces_ltt.tcl
L_DEPS += ../../../scripts/adi_env.tcl
L_DEPS += ../../scripts/adi_ip_lattice.tcl

LTT_INTERFACES := analog.com/ADI/spi_master/1.0/spi_master.xml
LTT_INTERFACES += analog.com/ADI/spi_master/1.0/spi_master_rtl.xml
LTT_INTERFACES += analog.com/ADI/spi_engine_ctrl/1.0/spi_engine_ctrl.xml
LTT_INTERFACES += analog.com/ADI/spi_engine_ctrl/1.0/spi_engine_ctrl_rtl.xml
LTT_INTERFACES += analog.com/ADI/spi_engine_offload_ctrl/1.0/spi_engine_offload_ctrl.xml
LTT_INTERFACES += analog.com/ADI/spi_engine_offload_ctrl/1.0/spi_engine_offload_ctrl_rtl.xml

CLEAN_TARGETS += $(wildcard */)
CLEAN_TARGETS += interfaces_ltt.log

.PHONY: all lattice clean clean-all
all: lattice

lattice: $(LTT_INTERFACES)

clean: clean-all

clean-all:
	rm -rf $(CLEAN_TARGETS)

%.xml: $(L_DEPS)
	$(PROPEL_BUILDER) interfaces_ltt.tcl >> interfaces_ltt.log 2>&1

####################################################################################
####################################################################################
