####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := axi_clkgen_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += ../common/ad_rst.v
M_DEPS += ../common/ad_mmcm_drp.v
M_DEPS += ../common/up_axi.v
M_DEPS += ../common/up_clkgen.v
M_DEPS += axi_clkgen_constr.xdc
M_DEPS += axi_clkgen.v

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
all: axi_clkgen.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


axi_clkgen.xpr: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) axi_clkgen_ip.tcl  >> axi_clkgen_ip.log 2>&1

####################################################################################
####################################################################################
