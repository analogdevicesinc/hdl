####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
## Wed Apr  1 16:22:09 2015
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
M_DEPS += axi_hdmi_rx_core.v


C_VIVADO := vivado -mode batch -script


.PHONY: all
all: axi_hdmi_rx.xpr


.PHONY: clean
clean:
	$(C_VIVADO) $(CLEAN_SCRIPT)


axi_hdmi_rx.xpr: $(M_DEPS)
	$(C_VIVADO) $(CLEAN_SCRIPT)
	$(C_VIVADO) axi_hdmi_rx_ip.tcl

####################################################################################
####################################################################################
