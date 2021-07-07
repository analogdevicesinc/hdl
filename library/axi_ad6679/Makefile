####################################################################################
## Copyright 2018 (c) Analog Devices, Inc.
## Copyright 2019 - 2020 (c) Elvis Dowson.
####################################################################################

LIBRARY_NAME := axi_ad6679

GENERIC_DEPS += ../common/ad_datafmt.v
GENERIC_DEPS += ../common/ad_pnmon.v
GENERIC_DEPS += ../common/ad_rst.v
GENERIC_DEPS += ../common/up_adc_channel.v
GENERIC_DEPS += ../common/up_adc_common.v
GENERIC_DEPS += ../common/up_axi.v
GENERIC_DEPS += ../common/up_clock_mon.v
GENERIC_DEPS += ../common/up_delay_cntrl.v
GENERIC_DEPS += ../common/up_xfer_cntrl.v
GENERIC_DEPS += ../common/up_xfer_status.v
GENERIC_DEPS += axi_ad6679.v
GENERIC_DEPS += axi_ad6679_channel.v
GENERIC_DEPS += axi_ad6679_if.v
GENERIC_DEPS += axi_ad6679_pnmon.v

XILINX_DEPS += ../xilinx/common/ad_mmcm_drp.v
XILINX_DEPS += ../xilinx/common/ad_rst_constr.xdc
XILINX_DEPS += ../xilinx/common/ad_serdes_clk.v
XILINX_DEPS += ../xilinx/common/ad_serdes_in.v
XILINX_DEPS += ../xilinx/common/up_clock_mon_constr.xdc
XILINX_DEPS += ../xilinx/common/up_xfer_cntrl_constr.xdc
XILINX_DEPS += ../xilinx/common/up_xfer_status_constr.xdc
XILINX_DEPS += axi_ad6679_constr.xdc
XILINX_DEPS += axi_ad6679_ip.tcl

INTEL_DEPS += ../intel/common/up_clock_mon_constr.sdc
INTEL_DEPS += ../intel/common/up_rst_constr.sdc
INTEL_DEPS += ../intel/common/up_xfer_cntrl_constr.sdc
INTEL_DEPS += ../intel/common/up_xfer_status_constr.sdc
INTEL_DEPS += axi_ad6679_constr.sdc
INTEL_DEPS += axi_ad6679_hw.tcl

include ../scripts/library.mk
