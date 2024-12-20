###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# source base VCU118 design
source ../../../../hdl/projects/common/vcu118/vcu118_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

ad_ip_parameter axi_ddr_cntrl CONFIG.C0_CLOCK_BOARD_INTERFACE default_250mhz_clk1
ad_ip_parameter axi_ddr_cntrl CONFIG.C0_DDR4_BOARD_INTERFACE ddr4_sdram_c1_062

ad_ip_parameter axi_dp_interconnect CONFIG.NUM_CLKS 3
ad_connect axi_dp_interconnect/aclk2 sys_250m_clk

ad_ip_instance clk_wiz clk_wiz_125mhz

ad_connect clk_wiz_125mhz/clk_in1 sys_250m_clk
ad_connect clk_wiz_125mhz/reset sys_250m_reset

ad_ip_instance proc_sys_reset sys_125m_rstgen

ad_connect sys_125m_rstgen/slowest_sync_clk clk_wiz_125mhz/clk_out1
ad_connect sys_125m_rstgen/ext_reset_in axi_ddr_cntrl/c0_ddr4_ui_clk_sync_rst

delete_bd_objs [get_bd_intf_ports iic_main] [get_bd_cells axi_iic_main]
ad_connect sys_concat_intc/In9 GND

source $ad_hdl_dir/library/corundum/scripts/corundum_vcu118_cfg.tcl
source $ad_hdl_dir/library/corundum/scripts/corundum.tcl
