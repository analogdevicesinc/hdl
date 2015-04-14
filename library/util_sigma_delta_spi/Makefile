####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := util_sigma_delta_spi_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += util_sigma_delta_spi.v

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
all: util_sigma_delta_spi.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


util_sigma_delta_spi.xpr: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) util_sigma_delta_spi_ip.tcl  >> util_sigma_delta_spi_ip.log 2>&1

####################################################################################
####################################################################################
