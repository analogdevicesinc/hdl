####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := util_adc_pack_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += util_adc_pack.v

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
all: util_adc_pack.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


util_adc_pack.xpr: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) util_adc_pack_ip.tcl  >> util_adc_pack_ip.log 2>&1

####################################################################################
####################################################################################
