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

XML_FLIST := if_ctrl_reg.xml
XML_FLIST += if_ctrl_reg_rtl.xml
XML_FLIST += if_ptp.xml
XML_FLIST += if_ptp_rtl.xml
XML_FLIST += if_flow_control_tx.xml
XML_FLIST += if_flow_control_tx_rtl.xml
XML_FLIST += if_flow_control_rx.xml
XML_FLIST += if_flow_control_rx_rtl.xml
XML_FLIST += if_ethernet_ptp.xml
XML_FLIST += if_ethernet_ptp_rtl.xml
XML_FLIST += if_axis_tx_ptp.xml
XML_FLIST += if_axis_tx_ptp_rtl.xml
XML_FLIST += if_jtag.xml
XML_FLIST += if_jtag_rtl.xml
XML_FLIST += if_gpio.xml
XML_FLIST += if_gpio_rtl.xml
XML_FLIST += if_qspi.xml
XML_FLIST += if_qspi_rtl.xml
XML_FLIST += if_qsfp.xml
XML_FLIST += if_qsfp_rtl.xml
XML_FLIST += if_sfp.xml
XML_FLIST += if_sfp_rtl.xml
XML_FLIST += if_i2c.xml
XML_FLIST += if_i2c_rtl.xml
XML_FLIST += if_axis_dma_desc.xml
XML_FLIST += if_axis_dma_desc_rtl.xml
XML_FLIST += if_axis_dma_desc_status.xml
XML_FLIST += if_axis_dma_desc_status_rtl.xml
XML_FLIST += if_dma_ram.xml
XML_FLIST += if_dma_ram_rtl.xml
XML_FLIST += if_axis_stat.xml
XML_FLIST += if_axis_stat_rtl.xml

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
