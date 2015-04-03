####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
## Fri Apr  3 11:55:07 2015
####################################################################################
####################################################################################

M_DEPS := axi_ad9122_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += ../common/ad_mul.v
M_DEPS += ../common/ad_dds_sine.v
M_DEPS += ../common/ad_dds_1.v
M_DEPS += ../common/ad_dds.v
M_DEPS += ../common/ad_rst.v
M_DEPS += ../common/ad_mmcm_drp.v
M_DEPS += ../common/ad_serdes_out.v
M_DEPS += ../common/ad_serdes_clk.v
M_DEPS += ../common/up_axi.v
M_DEPS += ../common/up_xfer_cntrl.v
M_DEPS += ../common/up_xfer_status.v
M_DEPS += ../common/up_clock_mon.v
M_DEPS += ../common/up_drp_cntrl.v
M_DEPS += ../common/up_dac_common.v
M_DEPS += ../common/up_dac_channel.v
M_DEPS += axi_ad9122_channel.v
M_DEPS += axi_ad9122_core.v
M_DEPS += axi_ad9122_if.v
M_DEPS += axi_ad9122_constr.xdc
M_DEPS += axi_ad9122.v

C_VIVADO := vivado -mode batch -source

F_LIST := `find . -not -name '.' -not -name '*.tcl' -not -name '*.v' -not -name '*.xdc' -not -name '*.vhd' -not -name '*.prj' -not -name 'Makefile' -not -name '*.h' `


.PHONY: all
all: axi_ad9122.xpr


.PHONY: clean
clean:clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(F_LIST)


axi_ad9122.xpr: $(M_DEPS)
	rm -rf $(F_LIST)
	$(C_VIVADO) axi_ad9122_ip.tcl  >> axi_ad9122_ip.log 2>&1

####################################################################################
####################################################################################
