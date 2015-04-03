####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
## Fri Apr  3 11:55:07 2015
####################################################################################
####################################################################################

M_DEPS := util_cpack_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += util_cpack_mux.v
M_DEPS += util_cpack_dsf.v
M_DEPS += util_cpack.v
M_DEPS += util_cpack_constr.xdc

C_VIVADO := vivado -mode batch -source

F_LIST := `find . -not -name '.' -not -name '*.tcl' -not -name '*.v' -not -name '*.xdc' -not -name '*.vhd' -not -name '*.prj' -not -name 'Makefile' -not -name '*.h' `


.PHONY: all
all: util_cpack.xpr


.PHONY: clean
clean:clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(F_LIST)


util_cpack.xpr: $(M_DEPS)
	rm -rf $(F_LIST)
	$(C_VIVADO) util_cpack_ip.tcl  >> util_cpack_ip.log 2>&1

####################################################################################
####################################################################################
