####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS += ../common/up_axi.v
M_DEPS += ../common/up_xfer_cntrl.v
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += axi_adc_trigger.v
M_DEPS += axi_adc_trigger_constr.xdc
M_DEPS += axi_adc_trigger_ip.tcl
M_DEPS += axi_adc_trigger_reg.v

M_VIVADO := vivado -mode batch -source

M_FLIST := *.cache
M_FLIST += *.data
M_FLIST += *.xpr
M_FLIST += *.log
M_FLIST += component.xml
M_FLIST += *.jou
M_FLIST +=  xgui
M_FLIST += *.ip_user_files
M_FLIST += *.srcs
M_FLIST += *.hw
M_FLIST += *.sim
M_FLIST += .Xil



.PHONY: all clean clean-all
all: axi_adc_trigger.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


axi_adc_trigger.xpr: $(M_DEPS)
	-rm -rf $(M_FLIST)
	$(M_VIVADO) axi_adc_trigger_ip.tcl  >> axi_adc_trigger_ip.log 2>&1

####################################################################################
####################################################################################
