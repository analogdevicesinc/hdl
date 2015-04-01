####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
## Wed Apr  1 16:22:09 2015
####################################################################################
####################################################################################

M_DEPS := util_rfifo_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += util_rfifo.v


C_VIVADO := vivado -mode batch -script


.PHONY: all
all: util_rfifo.xpr


.PHONY: clean
clean:
	$(C_VIVADO) $(CLEAN_SCRIPT)


util_rfifo.xpr: $(M_DEPS)
	$(C_VIVADO) $(CLEAN_SCRIPT)
	$(C_VIVADO) util_rfifo_ip.tcl

####################################################################################
####################################################################################
