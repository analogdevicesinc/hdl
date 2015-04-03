####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
## Fri Apr  3 11:55:07 2015
####################################################################################
####################################################################################

M_DEPS := util_gmii_to_rgmii_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += mdc_mdio.v
M_DEPS += util_gmii_to_rgmii.v

C_VIVADO := vivado -mode batch -source

F_LIST := `find . -not -name '.' -not -name '*.tcl' -not -name '*.v' -not -name '*.xdc' -not -name '*.vhd' -not -name '*.prj' -not -name 'Makefile' -not -name '*.h' `


.PHONY: all
all: util_gmii_to_rgmii.xpr


.PHONY: clean
clean:clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(F_LIST)


util_gmii_to_rgmii.xpr: $(M_DEPS)
	rm -rf $(F_LIST)
	$(C_VIVADO) util_gmii_to_rgmii_ip.tcl  >> util_gmii_to_rgmii_ip.log 2>&1

####################################################################################
####################################################################################
