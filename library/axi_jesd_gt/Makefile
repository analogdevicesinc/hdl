####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
## Wed Apr  1 16:22:09 2015
####################################################################################
####################################################################################

M_DEPS := axi_jesd_gt_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += ../common/ad_gt_common_1.v
M_DEPS += ../common/ad_gt_channel_1.v
M_DEPS += ../common/ad_gt_es.v
M_DEPS += ../common/ad_jesd_align.v
M_DEPS += ../common/ad_rst.v
M_DEPS += ../common/up_axi.v
M_DEPS += ../common/up_xfer_cntrl.v
M_DEPS += ../common/up_xfer_status.v
M_DEPS += ../common/up_drp_cntrl.v
M_DEPS += ../common/up_gt.v
M_DEPS += axi_jesd_gt.v
M_DEPS += axi_jesd_gt_constr.xdc


C_VIVADO := vivado -mode batch -script


.PHONY: all
all: axi_jesd_gt.xpr


.PHONY: clean
clean:
	$(C_VIVADO) $(CLEAN_SCRIPT)


axi_jesd_gt.xpr: $(M_DEPS)
	$(C_VIVADO) $(CLEAN_SCRIPT)
	$(C_VIVADO) axi_jesd_gt_ip.tcl

####################################################################################
####################################################################################
