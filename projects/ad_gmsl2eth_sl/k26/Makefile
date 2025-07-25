####################################################################################
## Copyright (c) 2024-2025 Analog Devices, Inc.
### SPDX short identifier: BSD-1-Clause
## Auto-generated, do not modify!
####################################################################################

PROJECT_NAME := ad_gmsl2eth_sl_k26

M_DEPS += ../common/ad_gmsl2eth_sl_bd.tcl
M_DEPS += ../../scripts/adi_pd.tcl
M_DEPS += ../../common/zcu102/zcu102_system_constr.xdc
M_DEPS += ../../common/zcu102/zcu102_system_bd.tcl
M_DEPS += ../../../library/common/ad_iobuf.v

M_DEPS += ../../../library/corundum/scripts/corundum_k26_cfg.tcl
M_DEPS += ../../../library/corundum/scripts/corundum.tcl
  

EXTERNAL_DEPS += ../../../../corundum/fpga/common/syn/vivado/eth_xcvr_phy_10g_gty_wrapper.tcl
EXTERNAL_DEPS += ../../../../corundum/fpga/common/syn/vivado/rb_drp.tcl
EXTERNAL_DEPS += ../../../../corundum/fpga/common/syn/vivado/mqnic_rb_clk_info.tcl
EXTERNAL_DEPS += ../../../../corundum/fpga/common/syn/vivado/mqnic_ptp_clock.tcl
EXTERNAL_DEPS += ../../../../corundum/fpga/common/syn/vivado/mqnic_port.tcl
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/syn/vivado/ptp_clock_cdc.tcl
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/syn/vivado/ptp_td_leaf.tcl
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/syn/vivado/ptp_td_rel2tod.tcl
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/lib/axis/syn/vivado/sync_reset.tcl
EXTERNAL_DEPS += ../../../../corundum/fpga/lib/eth/lib/axis/syn/vivado/axis_async_fifo.tcl
EXTERNAL_DEPS += ../../../../corundum/fpga/common/syn/vivado/tdma_ber_ch.tcl

LIB_DEPS += axi_clkgen
LIB_DEPS += axi_sysid
LIB_DEPS += axi_pwm_gen
LIB_DEPS += corundum/corundum_core
LIB_DEPS += corundum/ethernet
LIB_DEPS += sysid_rom

export BOARD := K26
export CPU := Zynq

include ../../scripts/project-xilinx.mk
