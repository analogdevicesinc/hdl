####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
## Wed Apr  1 16:22:09 2015
####################################################################################
####################################################################################

M_DEPS := axi_ad9625_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += ../common/ad_rst.v
M_DEPS += ../common/ad_mem.v
M_DEPS += ../common/ad_pnmon.v
M_DEPS += ../common/ad_datafmt.v
M_DEPS += ../common/up_axi.v
M_DEPS += ../common/up_xfer_cntrl.v
M_DEPS += ../common/up_xfer_status.v
M_DEPS += ../common/up_clock_mon.v
M_DEPS += ../common/up_drp_cntrl.v
M_DEPS += ../common/up_delay_cntrl.v
M_DEPS += ../common/up_adc_common.v
M_DEPS += ../common/up_adc_channel.v
M_DEPS += axi_ad9625_pnmon.v
M_DEPS += axi_ad9625_channel.v
M_DEPS += axi_ad9625_if.v
M_DEPS += axi_ad9625.v
M_DEPS += axi_ad9625_constr.xdc


C_VIVADO := vivado -mode batch -script


.PHONY: all
all: axi_ad9625.xpr


.PHONY: clean
clean:
	$(C_VIVADO) $(CLEAN_SCRIPT)


axi_ad9625.xpr: $(M_DEPS)
	$(C_VIVADO) $(CLEAN_SCRIPT)
	$(C_VIVADO) axi_ad9625_ip.tcl

####################################################################################
####################################################################################
