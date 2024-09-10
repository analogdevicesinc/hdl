###############################################################################
## Copyright (C) 2019-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# zcu102
# ad916x device

set_property IOSTANDARD LVDS [get_ports {tx_sync_p[0]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {tx_sync_p[0]}]
set_property PACKAGE_PIN AB4 [get_ports {tx_sync_p[0]}]
set_property PACKAGE_PIN AC4 [get_ports {tx_sync_n[0]}]
set_property IOSTANDARD LVDS [get_ports {tx_sync_n[0]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {tx_sync_n[0]}]
set_property IOSTANDARD LVDS [get_ports tx_sysref_p]
set_property DIFF_TERM_ADV TERM_100 [get_ports tx_sysref_p]
set_property PACKAGE_PIN Y4 [get_ports tx_sysref_p]
set_property PACKAGE_PIN Y3 [get_ports tx_sysref_n]
set_property IOSTANDARD LVDS [get_ports tx_sysref_n]
set_property DIFF_TERM_ADV TERM_100 [get_ports tx_sysref_n]


set_property IOSTANDARD LVDS [get_ports {tx_sync_p[1]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {tx_sync_p[1]}]
set_property PACKAGE_PIN V2 [get_ports {tx_sync_p[1]}]
set_property PACKAGE_PIN V1 [get_ports {tx_sync_n[1]}]
set_property IOSTANDARD LVDS [get_ports {tx_sync_n[1]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {tx_sync_n[1]}]

set_property -dict {PACKAGE_PIN AA1 IOSTANDARD LVCMOS18} [get_ports spi_csn_dac]
set_property -dict {PACKAGE_PIN AB3 IOSTANDARD LVCMOS18} [get_ports fmc_cs2]
set_property -dict {PACKAGE_PIN AA2 IOSTANDARD LVCMOS18} [get_ports spi_miso]
set_property -dict {PACKAGE_PIN Y1 IOSTANDARD LVCMOS18} [get_ports spi_mosi]
set_property -dict {PACKAGE_PIN Y2 IOSTANDARD LVCMOS18} [get_ports spi_clk]
set_property -dict {PACKAGE_PIN AC3 IOSTANDARD LVCMOS18} [get_ports spi_en]

set_property -dict {PACKAGE_PIN W2 IOSTANDARD LVCMOS18} [get_ports fmc_cs3]

# For AD9135-FMC-EBZ, AD9136-FMC-EBZ, AD9144-FMC-EBZ, AD9152-FMC-EBZ, AD9154-FMC-EBZ
set_property -dict {PACKAGE_PIN U5 IOSTANDARD LVCMOS18} [get_ports {dac_ctrl[0]}]
set_property -dict {PACKAGE_PIN U4 IOSTANDARD LVCMOS18} [get_ports {dac_ctrl[3]}]

# For AD9171-FMC-EBZ, AD9172-FMC-EBZ, AD9173-FMC-EBZ
set_property -dict {PACKAGE_PIN AC2 IOSTANDARD LVCMOS18} [get_ports {dac_ctrl[1]}]
set_property -dict {PACKAGE_PIN AC1 IOSTANDARD LVCMOS18} [get_ports {dac_ctrl[2]}]

# For AD916(1,2,3,4)-FMC-EBZ
set_property -dict {PACKAGE_PIN W1 IOSTANDARD LVCMOS18} [get_ports {dac_ctrl[4]}]

set_property -dict {PACKAGE_PIN G8} [get_ports tx_ref_clk_p]
set_property -dict {PACKAGE_PIN G7} [get_ports tx_ref_clk_n]

set_property -dict {PACKAGE_PIN F6} [get_ports {tx_data_p[2]}]
set_property -dict {PACKAGE_PIN F5} [get_ports {tx_data_n[2]}]
set_property -dict {PACKAGE_PIN G4} [get_ports {tx_data_p[0]}]
set_property -dict {PACKAGE_PIN G3} [get_ports {tx_data_n[0]}]
set_property -dict {PACKAGE_PIN H6} [get_ports {tx_data_p[1]}]
set_property -dict {PACKAGE_PIN H5} [get_ports {tx_data_n[1]}]
set_property -dict {PACKAGE_PIN K6} [get_ports {tx_data_p[3]}]
set_property -dict {PACKAGE_PIN K5} [get_ports {tx_data_n[3]}]

# PL PMOD 1 header
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33} [get_ports pmod_spi_clk]
set_property -dict {PACKAGE_PIN E20 IOSTANDARD LVCMOS33} [get_ports pmod_spi_csn]
set_property -dict {PACKAGE_PIN D22 IOSTANDARD LVCMOS33} [get_ports pmod_spi_mosi]
set_property -dict {PACKAGE_PIN E22 IOSTANDARD LVCMOS33} [get_ports pmod_spi_miso]
set_property -dict {PACKAGE_PIN F20 IOSTANDARD LVCMOS33} [get_ports {pmod_gpio[0]}]
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS33} [get_ports {pmod_gpio[1]}]
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS33} [get_ports {pmod_gpio[2]}]
set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33} [get_ports {pmod_gpio[3]}]

# clocks

# Max lane rate of 15.4 Gbps
create_clock -period 9.760 -name tx_ref_clk [get_ports tx_ref_clk_p]

# Assumption is that REFCLK and SYSREF have similar propagation delay,
# and the SYSREF is a source synchronous Center-Aligned signal to REFCLK
#set_input_delay -clock [get_clocks tx_ref_clk] #  [expr [get_property  PERIOD [get_clocks tx_ref_clk]] / 2] #  [get_ports {tx_sysref_*}]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property MARK_DEBUG true [get_nets <const0>]
set_property MARK_DEBUG true [get_nets fmc_cs3_OBUF]
set_property MARK_DEBUG true [get_nets spi_mosi_OBUF]
set_property MARK_DEBUG true [get_nets spi_clk_OBUF]
set_property MARK_DEBUG true [get_nets fmc_cs2_OBUF]
set_property MARK_DEBUG true [get_nets spi_miso_IBUF]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list i_system_wrapper/system_i/sys_ps8/inst/pl_clk0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 1 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list fmc_cs2_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 1 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list fmc_cs3_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list spi_clk_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list spi_miso_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list spi_mosi_OBUF]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_pl_clk0]
