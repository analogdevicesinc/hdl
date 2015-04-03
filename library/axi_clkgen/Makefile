####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
## Fri Apr  3 11:55:07 2015
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

C_VIVADO := vivado -mode batch -source

F_LIST := `find . -not -name '.' -not -name '*.tcl' -not -name '*.v' -not -name '*.xdc' -not -name '*.vhd' -not -name '*.prj' -not -name 'Makefile' -not -name '*.h' `


.PHONY: all
all: axi_clkgen.xpr


.PHONY: clean
clean:clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(F_LIST)


axi_clkgen.xpr: $(M_DEPS)
	rm -rf $(F_LIST)
	$(C_VIVADO) axi_clkgen_ip.tcl  >> axi_clkgen_ip.log 2>&1

####################################################################################
####################################################################################
