####################################################################################
## Copyright (c) 2023 Analog Devices, Inc.
### SPDX short identifier: BSD-1-Clause
## Auto-generated, do not modify!
####################################################################################

PROJECT_NAME := gmsl_k26
corundum_dir_common = ../../../../corundum/fpga/common
corundum_dir_mod = ../../../../corundum/fpga/lib
corundum_dir_kr260 = ../../../../corundum/fpga/mqnic/KR260/fpga
#corundum_dir_zcu102 = ../../../../corundum/fpga/mqnic/ZCU102/fpga

M_DEPS += ../common/gmsl_bd.tcl
M_DEPS += ../corundum/corundum_bd.tcl 
M_DEPS += ../../scripts/adi_pd.tcl
M_DEPS += ../../common/zcu102/zcu102_system_constr.xdc
M_DEPS += ../../common/zcu102/zcu102_system_bd.tcl
M_DEPS += ../../../library/common/ad_iobuf.v

M_DEPS += $(corundum_dir_kr260)/fpga.xdc
M_DEPS += $(corundum_dir_mod)/eth/lib/axis/syn/vivado/axis_async_fifo.tcl
M_DEPS += $(corundum_dir_common)/syn/vivado/mqnic_port.tcl
M_DEPS += $(corundum_dir_common)/syn/vivado/mqnic_ptp_clock.tcl
M_DEPS += $(corundum_dir_common)/syn/vivado/mqnic_rb_clk_info.tcl
M_DEPS += $(corundum_dir_mod)/eth/syn/vivado/ptp_clock_cdc.tcl
M_DEPS += $(corundum_dir_common)/syn/vivado/rb_drp.tcl
M_DEPS += $(corundum_dir_mod)/eth/lib/axis/syn/vivado/sync_reset.tcl
M_DEPS += $(corundum_dir_common)/syn/vivado/tdma_ber_ch.tcl
M_DEPS += $(corundum_dir_mod)/eth/lib/axis/syn/vivado/sync_reset.tcl
M_DEPS += $(corundum_dir_common)/syn/vivado/eth_xcvr_phy_10g_gty_wrapper.tcl
M_DEPS += $(corundum_dir_mod)/eth/lib/axis/rtl/sync_reset.v

LIB_DEPS += axi_dmac
LIB_DEPS += axi_clkgen
LIB_DEPS += axi_sysid
LIB_DEPS += corundum/nic_core
LIB_DEPS += corundum/nic_phy
LIB_DEPS += sysid_rom

include ../../scripts/project-xilinx.mk
