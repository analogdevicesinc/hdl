####################################################################################
####################################################################################
## Copyright (C) 2024 Analog Devices, Inc.
### SPDX short identifier: BSD-1-Clause
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := interfaces_ip.tcl
M_DEPS += ../../../scripts/adi_env.tcl
M_DEPS += ../../scripts/adi_ip_xilinx.tcl

M_VIVADO := vivado -mode batch -source

XML_FLIST := i3c_controller.xml
XML_FLIST += i3c_controller_rtl.xml
XML_FLIST += i3c_controller_cmdp.xml
XML_FLIST += i3c_controller_cmdp_rtl.xml
XML_FLIST += i3c_controller_rmap.xml
XML_FLIST += i3c_controller_rmap_rtl.xml
XML_FLIST += i3c_controller_sdio.xml
XML_FLIST += i3c_controller_sdio_rtl.xml

M_FLIST := *.log
M_FLIST += *.jou
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
