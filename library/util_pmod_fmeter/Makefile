####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := util_pmod_fmeter_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += ../common/ad_rst.v
M_DEPS += ../common/up_xfer_status.v
M_DEPS += ../common/up_axi.v
M_DEPS += ../common/up_pmod.v
M_DEPS += util_pmod_fmeter.v
M_DEPS += util_pmod_fmeter_core.v

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
all: util_pmod_fmeter.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


util_pmod_fmeter.xpr: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) util_pmod_fmeter_ip.tcl  >> util_pmod_fmeter_ip.log 2>&1

####################################################################################
####################################################################################
