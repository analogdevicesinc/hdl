####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := axi_generic_adc_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += ../common/ad_rst.v
M_DEPS += ../common/up_axi.v
M_DEPS += ../common/up_delay_cntrl.v
M_DEPS += ../common/up_xfer_cntrl.v
M_DEPS += ../common/up_xfer_status.v
M_DEPS += ../common/up_clock_mon.v
M_DEPS += ../common/up_adc_channel.v
M_DEPS += ../common/up_adc_common.v
M_DEPS += axi_generic_adc.v

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
all: axi_generic_adc.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


axi_generic_adc.xpr: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) axi_generic_adc_ip.tcl  >> axi_generic_adc_ip.log 2>&1

####################################################################################
####################################################################################
