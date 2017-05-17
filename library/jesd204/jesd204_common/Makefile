####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS += ../../scripts/adi_env.tcl
M_DEPS += ../../scripts/adi_ip.tcl
M_DEPS += eof.v
M_DEPS += jesd204_common_ip.tcl
M_DEPS += lmfc.v
M_DEPS += pipeline_stage.v
M_DEPS += scrambler.v

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
all: jesd204_common.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


jesd204_common.xpr: $(M_DEPS)
	-rm -rf $(M_FLIST)
	$(M_VIVADO) jesd204_common_ip.tcl  >> jesd204_common_ip.log 2>&1

####################################################################################
####################################################################################
