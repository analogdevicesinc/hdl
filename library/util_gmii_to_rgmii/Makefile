####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := util_gmii_to_rgmii_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += mdc_mdio.v
M_DEPS += util_gmii_to_rgmii_constr.xdc
M_DEPS += util_gmii_to_rgmii.v

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
all: util_gmii_to_rgmii.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


util_gmii_to_rgmii.xpr: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) util_gmii_to_rgmii_ip.tcl  >> util_gmii_to_rgmii_ip.log 2>&1

####################################################################################
####################################################################################
