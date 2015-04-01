####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
## Wed Apr  1 16:22:09 2015
####################################################################################
####################################################################################

M_DEPS := axi_clkgen_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += ../common/ad_rst.v
M_DEPS += ../common/ad_mmcm_drp.v
M_DEPS += ../common/up_axi.v
M_DEPS += ../common/up_drp_cntrl.v
M_DEPS += ../common/up_clkgen.v
M_DEPS += axi_clkgen.v


C_VIVADO := vivado -mode batch -script


.PHONY: all
all: axi_clkgen.xpr


.PHONY: clean
clean:
	$(C_VIVADO) $(CLEAN_SCRIPT)


axi_clkgen.xpr: $(M_DEPS)
	$(C_VIVADO) $(CLEAN_SCRIPT)
	$(C_VIVADO) axi_clkgen_ip.tcl

####################################################################################
####################################################################################
