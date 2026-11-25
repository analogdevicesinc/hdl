###############################################################################
## Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl

# DMA clock: the four DMAs share one 64-bit HP1 port and need 1000 MB/s.
# 100 MHz is too slow and 166/200 MHz fail timing; the PS gives
# 1000/7 = 142.857 MHz (1143 MB/s, 14% margin).
ad_ip_parameter sys_ps7 CONFIG.PCW_EN_CLK2_PORT 1
ad_ip_parameter sys_ps7 CONFIG.PCW_EN_RST2_PORT 1
ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ 142.8

ad_ip_instance proc_sys_reset sys_143m_rstgen
ad_ip_parameter sys_143m_rstgen CONFIG.C_EXT_RST_WIDTH 1

ad_connect sys_143m_clk    sys_ps7/FCLK_CLK2
ad_connect sys_143m_reset  sys_143m_rstgen/peripheral_reset
ad_connect sys_143m_resetn sys_143m_rstgen/peripheral_aresetn
ad_connect sys_143m_clk    sys_143m_rstgen/slowest_sync_clk
ad_connect sys_143m_rstgen/ext_reset_in sys_ps7/FCLK_RESET2_N

# sys_iodelay_clk stays on sys_200m_clk (IDELAYCTRL needs 200 MHz)
set sys_dma_clk    [get_bd_nets sys_143m_clk]
set sys_dma_reset  [get_bd_nets sys_143m_reset]
set sys_dma_resetn [get_bd_nets sys_143m_resetn]

source ../common/quad_ada4356_fmc_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

# build variant, shown by 'dmesg | grep sysid'
set sys_cstring "TDD_SUPPORT=$TDD_SUPPORT"

sysid_gen_sys_init_file $sys_cstring

# closes the DMA -> HP1 arbiter path on the 7 ns clock
set_property strategy Flow_RunPostRoutePhysOpt [get_runs impl_1]
