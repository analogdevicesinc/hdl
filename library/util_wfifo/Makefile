####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := util_wfifo_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += ../common/ad_axis_inf_rx.v
M_DEPS += util_wfifo_constr.xdc
M_DEPS += util_wfifo.v

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
all: util_wfifo.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


util_wfifo.xpr: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) util_wfifo_ip.tcl  >> util_wfifo_ip.log 2>&1

####################################################################################
####################################################################################
