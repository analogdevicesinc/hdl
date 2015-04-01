####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
## Wed Apr  1 16:22:09 2015
####################################################################################
####################################################################################

M_DEPS := util_pmod_fmeter_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += ../common/ad_rst.v
M_DEPS += ../common/up_xfer_status.v
M_DEPS += ../common/up_axi.v
M_DEPS += ../common/up_pmod.v
M_DEPS += util_pmod_fmeter.v
M_DEPS += util_pmod_fmeter_core.v


C_VIVADO := vivado -mode batch -script


.PHONY: all
all: util_pmod_fmeter.xpr


.PHONY: clean
clean:
	$(C_VIVADO) $(CLEAN_SCRIPT)


util_pmod_fmeter.xpr: $(M_DEPS)
	$(C_VIVADO) $(CLEAN_SCRIPT)
	$(C_VIVADO) util_pmod_fmeter_ip.tcl

####################################################################################
####################################################################################
