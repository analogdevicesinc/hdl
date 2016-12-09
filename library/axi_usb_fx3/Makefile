####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS += ../common/up_axi.v
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += axi_usb_fx3.v
M_DEPS += axi_usb_fx3_core.v
M_DEPS += axi_usb_fx3_if.v
M_DEPS += axi_usb_fx3_ip.tcl
M_DEPS += axi_usb_fx3_reg.v

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
all: axi_usb_fx3.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


axi_usb_fx3.xpr: $(M_DEPS)
	-rm -rf $(M_FLIST)
	$(M_VIVADO) axi_usb_fx3_ip.tcl  >> axi_usb_fx3_ip.log 2>&1

####################################################################################
####################################################################################
