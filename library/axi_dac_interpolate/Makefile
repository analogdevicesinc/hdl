####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS += ../common/ad_rst.v
M_DEPS += ../common/up_axi.v
M_DEPS += ../common/up_xfer_cntrl.v
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += axi_dac_interpolate.v
M_DEPS += axi_dac_interpolate_constr.xdc
M_DEPS += axi_dac_interpolate_ip.tcl
M_DEPS += axi_dac_interpolate_reg.v
M_DEPS += cic_interp.v
M_DEPS += fir_interp.v

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
all: axi_dac_interpolate.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


axi_dac_interpolate.xpr: $(M_DEPS)
	-rm -rf $(M_FLIST)
	$(M_VIVADO) axi_dac_interpolate_ip.tcl  >> axi_dac_interpolate_ip.log 2>&1

####################################################################################
####################################################################################
