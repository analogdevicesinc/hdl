####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
## Wed Apr  1 16:22:09 2015
####################################################################################
####################################################################################

M_DEPS := axi_hdmi_tx_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += ../common/ad_mem.v
M_DEPS += ../common/ad_rst.v
M_DEPS += ../common/ad_csc_1_mul.v
M_DEPS += ../common/ad_csc_1_add.v
M_DEPS += ../common/ad_csc_1.v
M_DEPS += ../common/ad_csc_RGB2CrYCb.v
M_DEPS += ../common/ad_ss_444to422.v
M_DEPS += ../common/up_axi.v
M_DEPS += ../common/up_xfer_cntrl.v
M_DEPS += ../common/up_xfer_status.v
M_DEPS += ../common/up_clock_mon.v
M_DEPS += ../common/up_hdmi_tx.v
M_DEPS += axi_hdmi_tx_vdma.v
M_DEPS += axi_hdmi_tx_core.v
M_DEPS += axi_hdmi_tx.v
M_DEPS += axi_hdmi_tx_constr.xdc


C_VIVADO := vivado -mode batch -script


.PHONY: all
all: axi_hdmi_tx.xpr


.PHONY: clean
clean:
	$(C_VIVADO) $(CLEAN_SCRIPT)


axi_hdmi_tx.xpr: $(M_DEPS)
	$(C_VIVADO) $(CLEAN_SCRIPT)
	$(C_VIVADO) axi_hdmi_tx_ip.tcl

####################################################################################
####################################################################################
