####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
## Fri Apr  3 11:55:07 2015
####################################################################################
####################################################################################

M_DEPS := axi_hdmi_tx_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += ../common/ad_mem.v
M_DEPS += ../common/ad_rst.v
M_DEPS += ../common/ad_csc_1_mul.v
M_DEPS += ../common/ad_csc_1_add.v
M_DEPS += ../common/ad_csc_1.v
M_DEPS += ../common/ad_csc_RGB2CrYCb.v
M_DEPS += ../common/ad_ss_444to422.v
M_DEPS += ../common/up_axi.v
M_DEPS += ../common/up_xfer_cntrl.v
M_DEPS += ../common/up_xfer_status.v
M_DEPS += ../common/up_clock_mon.v
M_DEPS += ../common/up_hdmi_tx.v
M_DEPS += axi_hdmi_tx_vdma.v
M_DEPS += axi_hdmi_tx_es.v
M_DEPS += axi_hdmi_tx_core.v
M_DEPS += axi_hdmi_tx.v
M_DEPS += axi_hdmi_tx_constr.xdc

C_VIVADO := vivado -mode batch -source

F_LIST := `find . -not -name '.' -not -name '*.tcl' -not -name '*.v' -not -name '*.xdc' -not -name '*.vhd' -not -name '*.prj' -not -name 'Makefile' -not -name '*.h' `


.PHONY: all
all: axi_hdmi_tx.xpr


.PHONY: clean
clean:clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(F_LIST)


axi_hdmi_tx.xpr: $(M_DEPS)
	rm -rf $(F_LIST)
	$(C_VIVADO) axi_hdmi_tx_ip.tcl  >> axi_hdmi_tx_ip.log 2>&1

####################################################################################
####################################################################################
