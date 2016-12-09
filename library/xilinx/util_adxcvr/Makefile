####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS += ../../scripts/adi_env.tcl
M_DEPS += ../../scripts/adi_ip.tcl
M_DEPS += util_adxcvr.v
M_DEPS += util_adxcvr_constr.xdc
M_DEPS += util_adxcvr_ip.tcl
M_DEPS += util_adxcvr_xch.v
M_DEPS += util_adxcvr_xcm.v

M_DEPS += ../../interfaces/if_xcvr_ch.xml
M_DEPS += ../../interfaces/if_xcvr_ch_rtl.xml
M_DEPS += ../../interfaces/if_xcvr_cm.xml
M_DEPS += ../../interfaces/if_xcvr_cm_rtl.xml

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



.PHONY: all dep clean clean-all
all: dep util_adxcvr.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


util_adxcvr.xpr: $(M_DEPS)
	-rm -rf $(M_FLIST)
	$(M_VIVADO) util_adxcvr_ip.tcl  >> util_adxcvr_ip.log 2>&1

dep:
	make -C ../../interfaces
####################################################################################
####################################################################################
