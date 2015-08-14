####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := axi_hdmi_rx_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += ../common/ad_rst.v
M_DEPS += ../common/ad_csc_1.v
M_DEPS += ../common/ad_csc_1_mul.v
M_DEPS += ../common/ad_csc_1_add.v
M_DEPS += ../common/ad_ss_422to444.v
M_DEPS += ../common/ad_csc_CrYCb2RGB.v
M_DEPS += ../common/up_axi.v
M_DEPS += ../common/up_clock_mon.v
M_DEPS += ../common/up_xfer_status.v
M_DEPS += ../common/up_xfer_cntrl.v
M_DEPS += ../common/up_hdmi_rx.v
M_DEPS += axi_hdmi_rx.v
M_DEPS += axi_hdmi_rx_es.v
M_DEPS += axi_hdmi_rx_tpm.v
M_DEPS += axi_hdmi_rx_constr.xdc
M_DEPS += axi_hdmi_rx_core.v

M_VIVADO := vivado -mode batch -source

M_FLIST := *.cache
M_FLIST += *.data
M_FLIST += *.xpr
M_FLIST += *.log
M_FLIST += component.xml
M_FLIST += *.jou
M_FLIST +=  xgui
M_FLIST += .Xil



.PHONY: all clean clean-all
all: axi_hdmi_rx.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


axi_hdmi_rx.xpr: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) axi_hdmi_rx_ip.tcl  >> axi_hdmi_rx_ip.log 2>&1

####################################################################################
####################################################################################
