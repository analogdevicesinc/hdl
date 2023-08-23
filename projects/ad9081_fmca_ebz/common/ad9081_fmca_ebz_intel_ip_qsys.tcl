# LINK = 1,
# L = 8,
# M = 8,
# F = 4,
# E = 4,
# S = 1,
# N = 16,
# NP = 16,
# CS = 0,
# TL_EN = 1,
# CF = 0,
# HD = 0,
# FCLK_MULP = 1,
# SUBCLASSV = 0,
# WIDTH_MULP = 2,
# TOTAL_SAMPLE = M*S*WIDTH_MULP,
# TOTAL_CS = (CS==0)? 1: (TOTAL_SAMPLE*CS),
# SH_CONFIG = 0,
# SL_CMD = 0,
# ED_CMD_RMP_EN = 1,
# CMD_WIDTH = 48,
# ED_SIM_PAT_TESTMODE = 3

add_instance intel_jesd204c_f_0 intel_jesd204c_f
set_instance_parameter_value intel_jesd204c_f_0 CF {0}
set_instance_parameter_value intel_jesd204c_f_0 CS {0}
set_instance_parameter_value intel_jesd204c_f_0 E  {4}
set_instance_parameter_value intel_jesd204c_f_0 F  {4}
set_instance_parameter_value intel_jesd204c_f_0 L  {8}
set_instance_parameter_value intel_jesd204c_f_0 M  {8}
set_instance_parameter_value intel_jesd204c_f_0 N  {16}
set_instance_parameter_value intel_jesd204c_f_0 NP {16}

add_instance systemclk_f_0 systemclk_f
set_instance_parameter_value systemclk_f_0 refclk_fgt_freq_mhz_0 {156.250000}
set_instance_parameter_value systemclk_f_0 refclk_fgt_freq_mhz_6 {324.403200}
set_instance_parameter_value systemclk_f_0 refclk_fgt_freq_mhz_txt_0 {100}
set_instance_parameter_value systemclk_f_0 refclk_fgt_freq_mhz_txt_6 {100}
set_instance_parameter_value systemclk_f_0 refclk_fgt_output_enable_6 {1}
set_instance_parameter_value systemclk_f_0 syspll_freq_mhz_0 {506.880000}
set_instance_parameter_value systemclk_f_0 syspll_freq_mhz_1 {805.6640625}
set_instance_parameter_value systemclk_f_0 syspll_freq_mhz_2 {805.6640625}
set_instance_parameter_value systemclk_f_0 syspll_mod_0 {User Configuration}
set_instance_parameter_value systemclk_f_0 syspll_refclk_src_0 {RefClk #6}
set_instance_parameter_value systemclk_f_0 syspll_refclk_src_1 {RefClk #0}
set_instance_parameter_value systemclk_f_0 syspll_refclk_src_2 {RefClk #0}

# Clock bridges
# A bridge is required only when a clock from an exported source is connected
# internally to more than one source.

add_instance mgmt_clk altera_clock_bridge
set_instance_parameter_value mgmt_clk EXPLICIT_CLOCK_RATE {100000000.0}
set_instance_parameter_value mgmt_clk NUM_CLOCK_OUTPUTS {1}

add_instance txframe_clk altera_clock_bridge
set_instance_parameter_value txframe_clk EXPLICIT_CLOCK_RATE {245760000.0}
set_instance_parameter_value txframe_clk NUM_CLOCK_OUTPUTS {1}

add_instance refclk_core altera_clock_bridge
set_instance_parameter_value refclk_core EXPLICIT_CLOCK_RATE {324403200.0}
set_instance_parameter_value refclk_core NUM_CLOCK_OUTPUTS {1}

add_instance txlink_clk altera_clock_bridge
set_instance_parameter_value txlink_clk EXPLICIT_CLOCK_RATE {245760000.0}
set_instance_parameter_value txlink_clk NUM_CLOCK_OUTPUTS {1}

add_instance core_pll altera_iopll
set_instance_parameter_value core_pll gui_number_of_clocks {2}
set_instance_parameter_value core_pll gui_divide_factor_c0 {6}
set_instance_parameter_value core_pll gui_divide_factor_c1 {6}
set_instance_parameter_value core_pll gui_duty_cycle0 {50.0}
set_instance_parameter_value core_pll gui_duty_cycle1 {50.0}
set_instance_parameter_value core_pll gui_fixed_vco_frequency {600.0}
set_instance_parameter_value core_pll gui_fixed_vco_frequency_ps {1667.0}
set_instance_parameter_value core_pll gui_fractional_cout {32}
set_instance_parameter_value core_pll gui_output_clock_frequency0 {245.76}
set_instance_parameter_value core_pll gui_output_clock_frequency1 {491.52}
set_instance_parameter_value core_pll gui_output_clock_frequency_ps0 {10000.0}
set_instance_parameter_value core_pll gui_output_clock_frequency_ps1 {10000.0}
set_instance_parameter_value core_pll gui_refclk1_frequency {100.0}
set_instance_parameter_value core_pll gui_reference_clock_frequency {324.4032}
set_instance_parameter_value core_pll gui_reference_clock_frequency_ps {10000.0}
set_instance_parameter_value core_pll gui_vco_frequency {600.0}

add_instance rst_seq_0 altera_reset_sequencer
set_instance_parameter_value rst_seq_0 ENABLE_CSR {1}
set_instance_parameter_value rst_seq_0 ENABLE_RESET_REQUEST_INPUT {0}
set_instance_parameter_value rst_seq_0 LIST_ASRT_DELAY {0 0 0 0 0 0 0 0 0 0}
set_instance_parameter_value rst_seq_0 LIST_ASRT_SEQ {0 1 2 3 4 5 6 7 8 9}
set_instance_parameter_value rst_seq_0 LIST_DSRT_DELAY {2 2 2 100 2 100 0 0 0 0}
set_instance_parameter_value rst_seq_0 LIST_DSRT_SEQ {0 1 2 3 4 5 6 7 8 9}
set_instance_parameter_value rst_seq_0 MIN_ASRT_TIME {20}
set_instance_parameter_value rst_seq_0 NUM_INPUTS {1}
set_instance_parameter_value rst_seq_0 NUM_OUTPUTS {4}
set_instance_parameter_value rst_seq_0 USE_DSRT_QUAL {0 1 1 0 0 0 0 0 0 0}

add_instance rst_seq_1 altera_reset_sequencer
set_instance_parameter_value rst_seq_1 ENABLE_CSR {1}
set_instance_parameter_value rst_seq_1 ENABLE_RESET_REQUEST_INPUT {0}
set_instance_parameter_value rst_seq_1 LIST_ASRT_DELAY {0 0 0 0 0 0 0 0 0 0}
set_instance_parameter_value rst_seq_1 LIST_ASRT_SEQ {0 1 2 3 4 5 6 7 8 9}
set_instance_parameter_value rst_seq_1 LIST_DSRT_DELAY {2 2 100 2 100 0 0 0 0 0}
set_instance_parameter_value rst_seq_1 LIST_DSRT_SEQ {0 1 2 3 4 5 6 7 8 9}
set_instance_parameter_value rst_seq_1 MIN_ASRT_TIME {20}
set_instance_parameter_value rst_seq_1 NUM_INPUTS {1}
set_instance_parameter_value rst_seq_1 NUM_OUTPUTS {3}
set_instance_parameter_value rst_seq_1 USE_DSRT_QUAL {1 1 0 1 0 0 0 0 0 0}

add_instance reset_controller_0 altera_reset_controller
set_instance_parameter_value reset_controller_0 MIN_RST_ASSERTION_TIME {3}
set_instance_parameter_value reset_controller_0 NUM_RESET_INPUTS {1}
set_instance_parameter_value reset_controller_0 OUTPUT_RESET_SYNC_EDGES {deassert}
set_instance_parameter_value reset_controller_0 RESET_REQUEST_PRESENT {0}
set_instance_parameter_value reset_controller_0 RESET_REQ_EARLY_DSRT_TIME {1}
set_instance_parameter_value reset_controller_0 RESET_REQ_WAIT_TIME {1}
set_instance_parameter_value reset_controller_0 SYNC_DEPTH {3}

add_instance rst_seq0_out0_bridge altera_reset_bridge
set_instance_parameter_value rst_seq0_out0_bridge ACTIVE_LOW_RESET {0}
set_instance_parameter_value rst_seq0_out0_bridge NUM_RESET_OUTPUTS {1}
set_instance_parameter_value rst_seq0_out0_bridge SYNCHRONOUS_EDGES {deassert}
set_instance_parameter_value rst_seq0_out0_bridge SYNC_RESET {0}
set_instance_parameter_value rst_seq0_out0_bridge USE_RESET_REQUEST {0}

add_instance sysref_rst_n_bridge altera_reset_bridge
set_instance_parameter_value sysref_rst_n_bridge ACTIVE_LOW_RESET {1}
set_instance_parameter_value sysref_rst_n_bridge NUM_RESET_OUTPUTS {1}
set_instance_parameter_value sysref_rst_n_bridge SYNCHRONOUS_EDGES {deassert}
set_instance_parameter_value sysref_rst_n_bridge SYNC_RESET {0}
set_instance_parameter_value sysref_rst_n_bridge USE_RESET_REQUEST {0}

add_instance edctl_reset_bridge altera_reset_bridge
set_instance_parameter_value edctl_reset_bridge ACTIVE_LOW_RESET {1}
set_instance_parameter_value edctl_reset_bridge NUM_RESET_OUTPUTS {1}
set_instance_parameter_value edctl_reset_bridge SYNCHRONOUS_EDGES {deassert}
set_instance_parameter_value edctl_reset_bridge SYNC_RESET {0}
set_instance_parameter_value edctl_reset_bridge USE_RESET_REQUEST {0}

add_instance mgmt_reset_bridge altera_reset_bridge
set_instance_parameter_value mgmt_reset_bridge ACTIVE_LOW_RESET {1}
set_instance_parameter_value mgmt_reset_bridge NUM_RESET_OUTPUTS {1}
set_instance_parameter_value mgmt_reset_bridge SYNCHRONOUS_EDGES {deassert}
set_instance_parameter_value mgmt_reset_bridge SYNC_RESET {0}
set_instance_parameter_value mgmt_reset_bridge USE_RESET_REQUEST {0}

add_instance ed_control j204c_f_edctl
set_instance_parameter_value ed_control DATA_PATH_2 {1}
set_instance_parameter_value ed_control E {4}
set_instance_parameter_value ed_control ED_SIM_PAT_TESTMODE {3}
set_instance_parameter_value ed_control FCLK_MULP {1}
set_instance_parameter_value ed_control SYSREF_MODE {1}

# system clock and reset

add_connection systemclk_f_0.out_refclk_fgt_6 intel_jesd204c_f_0.j204c_pll_refclk
add_connection systemclk_f_0.out_systempll_clk_0 intel_jesd204c_f_0.sysclk

add_connection core_pll.outclk0 ed_control.in_clk
add_connection core_pll.outclk1 ed_control.in_clk2x
add_connection ed_control.txlink_clk txlink_clk.in_clk
add_connection ed_control.txlink_clk sysref_rst_n_bridge.clk
add_connection mgmt_clk.out_clk intel_jesd204c_f_0.j204c_tx_avs_clk
add_connection mgmt_clk.out_clk intel_jesd204c_f_0.reconfig_xcvr_clk
add_connection mgmt_clk.out_clk intel_jesd204c_f_0.j204c_txlink_clk
add_connection mgmt_clk.out_clk reset_controller_0.clk
add_connection mgmt_clk.out_clk rst_seq_0.clk
add_connection mgmt_clk.out_clk rst_seq_1.clk
add_connection mgmt_clk.out_clk ed_control.mgmt_clk
add_connection mgmt_clk.out_clk edctl_reset_bridge.clk
add_connection mgmt_clk.out_clk mgmt_reset_bridge.clk
add_connection txframe_clk.out_clk intel_jesd204c_f_0.j204c_txframe_clk
add_connection refclk_core.out_clk core_pll.refclk
add_connection refclk_core.out_clk rst_seq0_out0_bridge.clk

add_connection rst_seq_0.reset_out0 intel_jesd204c_f_0.j204c_tx_avs_rst_n
add_connection rst_seq_0.reset_out0 rst_seq0_out0_bridge.in_reset
add_connection rst_seq_0.reset_out1 sysref_rst_n_bridge.in_reset
add_connection rst_seq0_out0_bridge.out_reset core_pll.reset
add_connection sysref_rst_n_bridge.out_reset ed_control.sysref_rst_n

add_connection fpga_m.master_reset reset_controller_0.reset_in0

add_connection reset_controller_0.reset_out rst_seq_0.reset_in0
add_connection reset_controller_0.reset_out rst_seq_1.reset_in0
add_connection reset_controller_0.reset_out intel_jesd204c_f_0.reconfig_xcvr_reset

add_connection edctl_reset_bridge.out_reset rst_seq_0.csr_reset
add_connection edctl_reset_bridge.out_reset rst_seq_1.csr_reset
add_connection edctl_reset_bridge.out_reset ed_control.edctl_rst_n

add_connection mgmt_reset_bridge.out_reset reset_controller_0.reset_in0

## Exported signals

add_interface mgmt_clk                   clock     sink
add_interface mgmt_reset                 reset     sink
add_interface txframe_clk                clock     sink
add_interface refclk_core                clock     sink
add_interface j204c_tx_rst_n             reset     sink
add_interface edctl_rst                  reset     sink
add_interface txlink_clk                 clock     sink
add_interface ed_control_txframe_clk     clock     sink
add_interface ed_control_tx_phase        clock     sink
add_interface ed_control_rxframe_clk     clock     sink
add_interface ed_control_rx_phase        clock     sink

set_interface_property mgmt_clk                EXPORT_OF mgmt_clk.in_clk
set_interface_property mgmt_reset              EXPORT_OF mgmt_reset_bridge.in_reset
set_interface_property txframe_clk             EXPORT_OF txframe_clk.in_clk
set_interface_property refclk_core             EXPORT_OF refclk_core.in_clk
set_interface_property txlink_clk              EXPORT_OF txlink_clk.out_clk
set_interface_property j204c_tx_rst_n          EXPORT_OF intel_jesd204c_f_0.j204c_tx_rst_n
set_interface_property ed_control_txframe_clk  EXPORT_OF ed_control.txframe_clk
set_interface_property ed_control_tx_phase     EXPORT_OF ed_control.tx_phase
set_interface_property ed_control_rxframe_clk  EXPORT_OF ed_control.rxframe_clk
set_interface_property ed_control_rx_phase     EXPORT_OF ed_control.rx_phase
set_interface_property edctl_rst               EXPORT_OF edctl_reset_bridge.in_reset

