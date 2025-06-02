###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

proc create_hsci_phy { {ip_name advanced_io_wizard_0} {num_banks 1} } {

  ad_ip_instance advanced_io_wizard ${ip_name}
  set_property -dict [list \
    CONFIG.DIFF_IO_T {DIFF_TERM_ADV} \
    CONFIG.DIFFERENTIAL_IO_TERMINATION {TERM_100} \
    CONFIG.BUS_DIR {3} \
    CONFIG.MAX_BANKS ${num_banks} \
    CONFIG.BIDIR_MODE {0} \
    CONFIG.CLK_TO_DATA_ALIGN {3} \
    CONFIG.DATA_SPEED {1600.00} \
    CONFIG.INPUT_CLK_FREQ {200.000} \
    CONFIG.ENABLE_PLLOUT1 {0} \
    CONFIG.PLL0_PLLOUTCLK1 {200.000} \
    CONFIG.SIMPLE_RIU {0} \
    CONFIG.REDUCE_CONTROL_SIG_EN {1} \
    CONFIG.BIT_PERIOD {625} \
    CONFIG.PLL_CLK {34.12539203348543} \
    CONFIG.TX_IOB {74} \
    CONFIG.TX_PHY {80} \
    CONFIG.TX_WINDOW_VAL {471} \
    CONFIG.RX_WINDOW_VAL {509} \
    CONFIG.BUS0_IO_TYPE {DIFF} \
    CONFIG.BUS0_STROBE_NAME {clk_in} \
    CONFIG.BUS0_STROBE_IO_TYPE {DIFF} \
    CONFIG.BUS0_SIG_NAME {data_in} \
    CONFIG.BUS1_DIR {TX} \
    CONFIG.BUS1_IO_TYPE {DIFF} \
    CONFIG.BUS1_SIG_NAME {data_out} \
    CONFIG.BUS2_DIR {TX} \
    CONFIG.BUS2_IO_TYPE {DIFF} \
    CONFIG.BUS2_SIG_TYPE {Clk Fwd} \
    CONFIG.BUS2_SIG_NAME {clk_out} \
    CONFIG.BUS12_WRCLK_EN {0} \
    CONFIG.DIFF_IO_STD {LVDS15} \
    CONFIG.ENABLE_BLI {0} \
  ] [get_bd_cells ${ip_name}]
}
