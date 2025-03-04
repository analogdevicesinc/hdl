####################################################################################
####################################################################################
## Copyright (c) 2018 - 2025 Analog Devices, Inc.
### SPDX short identifier: BSD-1-Clause
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := interfaces_ip.tcl
M_DEPS += ../../../scripts/adi_env.tcl
M_DEPS += ../../scripts/adi_ip_xilinx.tcl

M_VIVADO := vivado -mode batch -source

XML_FLIST := spi_engine.xml
XML_FLIST += spi_engine_rtl.xml
XML_FLIST += spi_engine_ctrl.xml
XML_FLIST += spi_engine_ctrl_rtl.xml
XML_FLIST += spi_engine_offload_ctrl.xml
XML_FLIST += spi_engine_offload_ctrl_rtl.xml
XML_FLIST += spi_engine_interconnect_ctrl.xml
XML_FLIST += spi_engine_interconnect_ctrl_rtl.xml

M_FLIST := *.log
M_FLIST += *.jou
M_FLIST += *.sv
M_FLIST += $(XML_FLIST)

.PHONY: all xilinx clean clean-all
all: xilinx

xilinx: $(XML_FLIST)

clean:clean-all

clean-all:
	rm -rf $(M_FLIST)

%.xml: $(M_DEPS)
	$(M_VIVADO) interfaces_ip.tcl >> interfaces_ip.log 2>&1

####################################################################################
####################################################################################
