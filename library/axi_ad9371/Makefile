####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS += ../common/ad_axi_ip_constr.xdc
M_DEPS += ../common/ad_datafmt.v
M_DEPS += ../common/ad_dcfilter.v
M_DEPS += ../common/ad_dds.v
M_DEPS += ../common/ad_dds_1.v
M_DEPS += ../common/ad_dds_sine.v
M_DEPS += ../common/ad_iqcor.v
M_DEPS += ../common/ad_rst.v
M_DEPS += ../common/ad_xcvr_rx_if.v
M_DEPS += ../common/up_adc_channel.v
M_DEPS += ../common/up_adc_common.v
M_DEPS += ../common/up_axi.v
M_DEPS += ../common/up_clock_mon.v
M_DEPS += ../common/up_dac_channel.v
M_DEPS += ../common/up_dac_common.v
M_DEPS += ../common/up_xfer_cntrl.v
M_DEPS += ../common/up_xfer_status.v
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += ../xilinx/common/ad_mul.v
M_DEPS += axi_ad9371.v
M_DEPS += axi_ad9371_if.v
M_DEPS += axi_ad9371_ip.tcl
M_DEPS += axi_ad9371_rx.v
M_DEPS += axi_ad9371_rx_channel.v
M_DEPS += axi_ad9371_rx_os.v
M_DEPS += axi_ad9371_tx.v
M_DEPS += axi_ad9371_tx_channel.v

M_VIVADO := vivado -mode batch -source

M_FLIST := *.cache
M_FLIST += *.data
M_FLIST += *.xpr
M_FLIST += *.log
M_FLIST += component.xml
M_FLIST += *.jou
M_FLIST +=  xgui
M_FLIST += *.ip_user_files
M_FLIST += *.srcs
M_FLIST += *.hw
M_FLIST += *.sim
M_FLIST += .Xil



.PHONY: all clean clean-all
all: axi_ad9371.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


axi_ad9371.xpr: $(M_DEPS)
	-rm -rf $(M_FLIST)
	$(M_VIVADO) axi_ad9371_ip.tcl  >> axi_ad9371_ip.log 2>&1

####################################################################################
####################################################################################
