####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := axi_ad9144_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += ../common/ad_mul.v
M_DEPS += ../common/ad_dds_sine.v
M_DEPS += ../common/ad_dds_1.v
M_DEPS += ../common/ad_dds.v
M_DEPS += ../common/ad_rst.v
M_DEPS += ../common/up_axi.v
M_DEPS += ../common/up_xfer_cntrl.v
M_DEPS += ../common/up_xfer_status.v
M_DEPS += ../common/up_clock_mon.v
M_DEPS += ../common/up_drp_cntrl.v
M_DEPS += ../common/up_dac_common.v
M_DEPS += ../common/up_dac_channel.v
M_DEPS += axi_ad9144_channel.v
M_DEPS += axi_ad9144_core.v
M_DEPS += axi_ad9144_if.v
M_DEPS += axi_ad9144.v
M_DEPS += axi_ad9144_constr.xdc

M_VIVADO := vivado -mode batch -source

M_FLIST := `find . -not -name '.'
M_FLIST += -not -name '*.tcl'
M_FLIST += -not -name '*.v'
M_FLIST += -not -name '*.xdc'
M_FLIST += -not -name '*.vhd'
M_FLIST += -not -name '*.prj'
M_FLIST += -not -name '*.xml'
M_FLIST += -not -name 'Makefile'
M_FLIST += -not -name '*.h' `M_FLIST += component.xml 


.PHONY: all
all: axi_ad9144.xpr


.PHONY: clean
clean:clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(M_FLIST)


axi_ad9144.xpr: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) axi_ad9144_ip.tcl  >> axi_ad9144_ip.log 2>&1

####################################################################################
####################################################################################
