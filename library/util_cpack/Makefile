####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
## Wed Apr  1 16:22:09 2015
####################################################################################
####################################################################################

M_DEPS := util_cpack_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += util_cpack_mux.v
M_DEPS += util_cpack_dsf.v
M_DEPS += util_cpack.v
M_DEPS += util_cpack_constr.xdc


C_VIVADO := vivado -mode batch -script


.PHONY: all
all: util_cpack.xpr


.PHONY: clean
clean:
	$(C_VIVADO) $(CLEAN_SCRIPT)


util_cpack.xpr: $(M_DEPS)
	$(C_VIVADO) $(CLEAN_SCRIPT)
	$(C_VIVADO) util_cpack_ip.tcl

####################################################################################
####################################################################################
