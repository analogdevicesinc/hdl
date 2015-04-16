####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := axi_ad9680_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += ../common/ad_rst.v
M_DEPS += ../common/ad_pnmon.v
M_DEPS += ../common/ad_datafmt.v
M_DEPS += ../common/up_axi.v
M_DEPS += ../common/up_xfer_cntrl.v
M_DEPS += ../common/up_xfer_status.v
M_DEPS += ../common/up_clock_mon.v
M_DEPS += ../common/up_drp_cntrl.v
M_DEPS += ../common/up_delay_cntrl.v
M_DEPS += ../common/up_adc_common.v
M_DEPS += ../common/up_adc_channel.v
M_DEPS += axi_ad9680_pnmon.v
M_DEPS += axi_ad9680_channel.v
M_DEPS += axi_ad9680_if.v
M_DEPS += axi_ad9680.v
M_DEPS += axi_ad9680_constr.xdc

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
all: axi_ad9680.xpr


.PHONY: clean
clean:clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(M_FLIST)


axi_ad9680.xpr: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) axi_ad9680_ip.tcl  >> axi_ad9680_ip.log 2>&1

####################################################################################
####################################################################################
