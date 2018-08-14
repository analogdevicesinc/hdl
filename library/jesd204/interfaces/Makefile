####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := interfaces_ip.tcl
M_DEPS += ../../scripts/adi_env.tcl
M_DEPS += ../../scripts/adi_ip_xilinx.tcl

M_VIVADO := vivado -mode batch -source

XML_FLIST := jesd204_tx_cfg.xml
XML_FLIST += jesd204_tx_cfg_rtl.xml
XML_FLIST += jesd204_tx_ilas_config.xml
XML_FLIST += jesd204_tx_ilas_config_rtl.xml
XML_FLIST += jesd204_tx_status.xml
XML_FLIST += jesd204_tx_status_rtl.xml
XML_FLIST += jesd204_tx_event.xml
XML_FLIST += jesd204_tx_event_rtl.xml
XML_FLIST += jesd204_tx_ctrl.xml
XML_FLIST += jesd204_tx_ctrl_rtl.xml
XML_FLIST += jesd204_rx_cfg.xml
XML_FLIST += jesd204_rx_cfg_rtl.xml
XML_FLIST += jesd204_rx_status.xml
XML_FLIST += jesd204_rx_status_rtl.xml
XML_FLIST += jesd204_rx_ilas_config.xml
XML_FLIST += jesd204_rx_ilas_config_rtl.xml
XML_FLIST += jesd204_rx_event.xml
XML_FLIST += jesd204_rx_event_rtl.xml

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
