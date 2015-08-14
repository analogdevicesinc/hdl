####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := axi_ad6676_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += ../common/ad_rst.v
M_DEPS += ../common/ad_pnmon.v
M_DEPS += ../common/up_axi.v
M_DEPS += ../common/up_xfer_cntrl.v
M_DEPS += ../common/up_xfer_status.v
M_DEPS += ../common/up_clock_mon.v
M_DEPS += ../common/up_adc_common.v
M_DEPS += ../common/up_adc_channel.v
M_DEPS += axi_ad6676_pnmon.v
M_DEPS += axi_ad6676_channel.v
M_DEPS += axi_ad6676_if.v
M_DEPS += axi_ad6676_constr.xdc
M_DEPS += axi_ad6676.v

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
all: axi_ad6676.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


axi_ad6676.xpr: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) axi_ad6676_ip.tcl  >> axi_ad6676_ip.log 2>&1

####################################################################################
####################################################################################
