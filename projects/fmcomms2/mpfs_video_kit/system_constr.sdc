###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## SPDX short identifier: ADIBSD
###############################################################################

# Project-specific timing constraints for fmcomms2 on MPFS Video Kit.
# The fabric PLL and MSS clocks come from the derived constraints.

# AD9361 data clock, same period as the Xilinx (zed) project

create_clock -name {rx_clk} -period 4 [get_ports {RX_CLK_P}]

# util_clkdiv outputs (sel 0 = 2R2T, sel 1 = 1R1T)

create_generated_clock -name {divclk_sel_0} -divide_by 4 \
  -source [get_pins {i_system_lb/util_ad9361_divclk_0_inst_0/i_original/i_clk_divide_sel_0/A}] \
  [get_pins {i_system_lb/util_ad9361_divclk_0_inst_0/i_original/i_clk_divide_sel_0/Y_DIV}]
create_generated_clock -name {divclk_sel_1} -divide_by 2 \
  -source [get_pins {i_system_lb/util_ad9361_divclk_0_inst_0/i_original/i_clk_divide_sel_1/A}] \
  [get_pins {i_system_lb/util_ad9361_divclk_0_inst_0/i_original/i_clk_divide_sel_1/Y_DIV}]

# clock domain crossings are handled by the IP cores (as in the Microchip
# reference design)

set_clock_groups -asynchronous \
  -group [get_clocks {REF_CLK_PAD_P \
    i_system_lb/mpfs_fabric_ccc_inst_0/mpfs_fabric_ccc_0/pll_inst_0/OUT0 \
    i_system_lb/mpfs_fabric_ccc_inst_0/mpfs_fabric_ccc_0/pll_inst_0/OUT1}] \
  -group [get_clocks {divclk_sel_0 divclk_sel_1}] \
  -group [get_clocks {rx_clk}]

# util_cdc synchronizers (as util_cdc_constr / axi_dmac_constr): the first
# stage of sync_bits and the hold to output register of sync_data cross
# clock domains by design

set_false_path -to [get_cells {*cdc_sync_stage1*}]
set_false_path -from [get_cells {*cdc_hold*}] -to [get_cells {*out_data*}]

# only one divider output drives the clock mux at a time

set_clock_groups -logically_exclusive \
  -group [get_clocks {divclk_sel_0}] \
  -group [get_clocks {divclk_sel_1}]
