###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl

# Dedicated 142.86 MHz clock for the DMA-to-HP1 path.
#
# Four DMAs share one 64-bit HP1 port. At sys_cpu_clk (100 MHz) that port tops
# out at 800 MB/s against a 4 ch x 125 MSPS x 2 B = 1000 MB/s demand, so samples
# are silently dropped mid-buffer.
#
# FCLK_CLK1 (200 MHz) and then FCLK_CLK2 at 166.67 MHz both fixed the bandwidth
# but failed timing: the DMA-to-crossbar AW arbiter path needs a fixed 6.166 ns
# on this -1 part with four masters gathering into one arbiter, so slack is
# (period - 6.166) and only a period >= 7 ns clears it with real margin.
#
# 142.8 is requested but the PS divides the 1000 MHz IO PLL by an integer, so
# the achieved value is 1000/7 = 142.857 MHz (7.000 ns). That is 1143 MB/s,
# only 14% over demand -- do not add channels or raise the sample rate without
# first splitting the DMAs across HP1/HP2.
ad_ip_parameter sys_ps7 CONFIG.PCW_EN_CLK2_PORT 1
ad_ip_parameter sys_ps7 CONFIG.PCW_EN_RST2_PORT 1
ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ 142.8

ad_ip_instance proc_sys_reset sys_166m_rstgen
ad_ip_parameter sys_166m_rstgen CONFIG.C_EXT_RST_WIDTH 1

ad_connect sys_166m_clk    sys_ps7/FCLK_CLK2
ad_connect sys_166m_reset  sys_166m_rstgen/peripheral_reset
ad_connect sys_166m_resetn sys_166m_rstgen/peripheral_aresetn
ad_connect sys_166m_clk    sys_166m_rstgen/slowest_sync_clk
ad_connect sys_166m_rstgen/ext_reset_in sys_ps7/FCLK_RESET2_N

# Re-point only the DMA clock. sys_iodelay_clk stays on sys_200m_clk because
# IDELAYCTRL requires exactly 200 MHz.
set sys_dma_clk    [get_bd_nets sys_166m_clk]
set sys_dma_reset  [get_bd_nets sys_166m_reset]
set sys_dma_resetn [get_bd_nets sys_166m_resetn]

source ../common/quad_ada4356_fmc_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file ""
