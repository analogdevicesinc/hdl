####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
## Fri Apr  3 11:55:07 2015
####################################################################################
####################################################################################

M_DEPS := util_upack_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += util_upack_dmx.v
M_DEPS += util_upack_dsf.v
M_DEPS += util_upack.v
M_DEPS += util_upack_constr.xdc

C_VIVADO := vivado -mode batch -source

F_LIST := `find . -not -name '.' -not -name '*.tcl' -not -name '*.v' -not -name '*.xdc' -not -name '*.vhd' -not -name '*.prj' -not -name 'Makefile' -not -name '*.h' `


.PHONY: all
all: util_upack.xpr


.PHONY: clean
clean:clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(F_LIST)


util_upack.xpr: $(M_DEPS)
	rm -rf $(F_LIST)
	$(C_VIVADO) util_upack_ip.tcl  >> util_upack_ip.log 2>&1

####################################################################################
####################################################################################
