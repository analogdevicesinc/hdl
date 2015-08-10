####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
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
M_DEPS += ../common/up_gt.v
M_DEPS += axi_jesd_gt.v
M_DEPS += axi_jesd_gt_constr.xdc

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
all: axi_jesd_gt.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


axi_jesd_gt.xpr: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) axi_jesd_gt_ip.tcl  >> axi_jesd_gt_ip.log 2>&1

####################################################################################
####################################################################################
