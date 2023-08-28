# mxfe params
# -------------------------------------------------------------------

# RX parameters
set RX_NUM_OF_LINKS $ad_project_params(RX_NUM_LINKS)

# RX JESD parameter per link
set RX_JESD_M     $ad_project_params(RX_JESD_M)
set RX_JESD_L     $ad_project_params(RX_JESD_L)
set RX_JESD_S     $ad_project_params(RX_JESD_S)
set RX_JESD_NP    $ad_project_params(RX_JESD_NP)

set RX_TPL_DATA_PATH_WIDTH 4
if {$RX_JESD_NP==12} {
  set RX_TPL_DATA_PATH_WIDTH 6
}

set RX_NUM_OF_LANES      [expr $RX_JESD_L * $RX_NUM_OF_LINKS]
set RX_NUM_OF_CONVERTERS [expr $RX_JESD_M * $RX_NUM_OF_LINKS]
set RX_SAMPLES_PER_FRAME $RX_JESD_S
set RX_SAMPLE_WIDTH      $RX_JESD_NP
set RX_DMA_SAMPLE_WIDTH  16

set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 8*$RX_TPL_DATA_PATH_WIDTH / \
                                ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)]

# TX parameters
set TX_NUM_OF_LINKS $ad_project_params(TX_NUM_LINKS)

# TX JESD parameter per link
set TX_JESD_M     $ad_project_params(TX_JESD_M)
set TX_JESD_L     $ad_project_params(TX_JESD_L)
set TX_JESD_S     $ad_project_params(TX_JESD_S)
set TX_JESD_NP    $ad_project_params(TX_JESD_NP)

set TX_TPL_DATA_PATH_WIDTH 4
if {$TX_JESD_NP==12} {
  set TX_TPL_DATA_PATH_WIDTH 6
}

set TX_NUM_OF_LANES      [expr $TX_JESD_L * $TX_NUM_OF_LINKS]
set TX_NUM_OF_CONVERTERS [expr $TX_JESD_M * $TX_NUM_OF_LINKS]
set TX_SAMPLES_PER_FRAME $TX_JESD_S
set TX_SAMPLE_WIDTH      $TX_JESD_NP
set TX_DMA_SAMPLE_WIDTH  16

set TX_SAMPLES_PER_CHANNEL [expr $TX_NUM_OF_LANES * 8*$TX_TPL_DATA_PATH_WIDTH / \
                                ($TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH)]

# Lane Rate = I/Q Sample Rate x M x N' x (10 \ 8) \ L
set RX_LANE_RATE [expr $ad_project_params(RX_LANE_RATE)*1000]
set TX_LANE_RATE [expr $ad_project_params(TX_LANE_RATE)*1000]

# Lane Rate = I/Q Sample Rate x M x N' x (10 \ 8) \ L
set RX_LANE_RATE [expr $ad_project_params(RX_LANE_RATE)*1000]
set TX_LANE_RATE [expr $ad_project_params(TX_LANE_RATE)*1000]

set adc_fifo_name mxfe_adc_fifo
set adc_data_width [expr 8*$RX_TPL_DATA_PATH_WIDTH*$RX_NUM_OF_LANES*$RX_DMA_SAMPLE_WIDTH/$RX_SAMPLE_WIDTH]
set adc_dma_data_width $adc_data_width
set adc_fifo_address_width [expr int(ceil(log(($adc_fifo_samples_per_converter*$RX_NUM_OF_CONVERTERS) / ($adc_data_width/$RX_DMA_SAMPLE_WIDTH))/log(2)))]

set dac_fifo_name mxfe_dac_fifo
set dac_data_width [expr 8*$TX_TPL_DATA_PATH_WIDTH*$TX_NUM_OF_LANES*$TX_DMA_SAMPLE_WIDTH/$TX_SAMPLE_WIDTH]
set dac_dma_data_width $dac_data_width
set dac_fifo_address_width [expr int(ceil(log(($dac_fifo_samples_per_converter*$TX_NUM_OF_CONVERTERS) / ($dac_data_width/$TX_DMA_SAMPLE_WIDTH))/log(2)))]


# Generic JESD
# ------------------------------------------------------------------------------
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
set_instance_parameter_value intel_jesd204c_f_0 DATA_PATH {rx_tx}
set_instance_parameter_value intel_jesd204c_f_0 CF {0}
set_instance_parameter_value intel_jesd204c_f_0 CS {0}
set_instance_parameter_value intel_jesd204c_f_0 E  {4}
set_instance_parameter_value intel_jesd204c_f_0 F  {4}
set_instance_parameter_value intel_jesd204c_f_0 L  {8}
set_instance_parameter_value intel_jesd204c_f_0 M  {8}
set_instance_parameter_value intel_jesd204c_f_0 N  {16}
set_instance_parameter_value intel_jesd204c_f_0 NP {16}
set_instance_parameter_value intel_jesd204c_f_0 S  {1}
set_instance_parameter_value intel_jesd204c_f_0 RX_GB_8DEEP {0}
set_instance_parameter_value intel_jesd204c_f_0 RX_GB_MLAB {0}
set_instance_parameter_value intel_jesd204c_f_0 RX_GB_PIPE {1}
set_instance_parameter_value intel_jesd204c_f_0 RX_GB_RD_DLY {1}
set_instance_parameter_value intel_jesd204c_f_0 RX_LEMC_OFFSET {0}
set_instance_parameter_value intel_jesd204c_f_0 RX_PIPELINE {0}
set_instance_parameter_value intel_jesd204c_f_0 RX_POL_EN {255}
set_instance_parameter_value intel_jesd204c_f_0 RX_POL_EN_ATTR {1}
set_instance_parameter_value intel_jesd204c_f_0 RX_POL_INV {255}
set_instance_parameter_value intel_jesd204c_f_0 RX_THRESH_EMB_ERR {8}
set_instance_parameter_value intel_jesd204c_f_0 RX_THRESH_SH_ERR {16}
set_instance_parameter_value intel_jesd204c_f_0 rcfg_enable {0}

add_instance systemclk_f_0 systemclk_f
set_instance_parameter_value systemclk_f_0 refclk_fgt_freq_mhz_0 {156.250000}
set_instance_parameter_value systemclk_f_0 refclk_fgt_freq_mhz_6 {324.403200}
set_instance_parameter_value systemclk_f_0 refclk_fgt_freq_mhz_txt_0 {100}
set_instance_parameter_value systemclk_f_0 refclk_fgt_freq_mhz_txt_6 {100}
set_instance_parameter_value systemclk_f_0 refclk_fgt_output_enable_6 {1}
set_instance_parameter_value systemclk_f_0 refclk_fgt_always_active_6 {1}
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

add_instance refclk_core altera_clock_bridge
set_instance_parameter_value refclk_core EXPLICIT_CLOCK_RATE {324403200.0}
set_instance_parameter_value refclk_core NUM_CLOCK_OUTPUTS {1}

add_instance txframe_clk altera_clock_bridge
set_instance_parameter_value txframe_clk EXPLICIT_CLOCK_RATE {245760000.0}
set_instance_parameter_value txframe_clk NUM_CLOCK_OUTPUTS {1}

add_instance txlink_clk altera_clock_bridge
set_instance_parameter_value txlink_clk EXPLICIT_CLOCK_RATE {245760000.0}
set_instance_parameter_value txlink_clk NUM_CLOCK_OUTPUTS {1}

add_instance rxframe_clk altera_clock_bridge
set_instance_parameter_value txframe_clk EXPLICIT_CLOCK_RATE {245760000.0}
set_instance_parameter_value txframe_clk NUM_CLOCK_OUTPUTS {1}

add_instance rxlink_clk altera_clock_bridge
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

add_instance jtag_reset altera_reset_bridge
set_instance_parameter_value jtag_reset ACTIVE_LOW_RESET {1}
set_instance_parameter_value jtag_reset NUM_RESET_OUTPUTS {1}
set_instance_parameter_value jtag_reset SYNCHRONOUS_EDGES {deassert}
set_instance_parameter_value jtag_reset SYNC_RESET {0}
set_instance_parameter_value jtag_reset USE_RESET_REQUEST {0}

add_instance jtag_rst_bridge altera_reset_bridge
set_instance_parameter_value jtag_rst_bridge ACTIVE_LOW_RESET {1}
set_instance_parameter_value jtag_rst_bridge NUM_RESET_OUTPUTS {1}
set_instance_parameter_value jtag_rst_bridge SYNCHRONOUS_EDGES {deassert}
set_instance_parameter_value jtag_rst_bridge SYNC_RESET {0}
set_instance_parameter_value jtag_rst_bridge USE_RESET_REQUEST {0}

add_instance ed_control j204c_f_edctl
set_instance_parameter_value ed_control DATA_PATH_2 {2}
set_instance_parameter_value ed_control E {4}
set_instance_parameter_value ed_control ED_SIM_PAT_TESTMODE {3}
set_instance_parameter_value ed_control FCLK_MULP {1}
set_instance_parameter_value ed_control SYSREF_MODE {1}

add_instance spi_0 altera_avalon_spi
set_instance_parameter_value spi_0 clockPhase {0}
set_instance_parameter_value spi_0 clockPolarity {0}
set_instance_parameter_value spi_0 dataWidth {24}
set_instance_parameter_value spi_0 disableAvalonFlowControl {0}
set_instance_parameter_value spi_0 insertDelayBetweenSlaveSelectAndSClk {0}
set_instance_parameter_value spi_0 insertSync {0}
set_instance_parameter_value spi_0 lsbOrderedFirst {0}
set_instance_parameter_value spi_0 masterSPI {1}
set_instance_parameter_value spi_0 numberOfSlaves {3}
set_instance_parameter_value spi_0 syncRegDepth {2}
set_instance_parameter_value spi_0 targetClockRate {20000000.0}
set_instance_parameter_value spi_0 targetSlaveSelectToSClkDelay {0.0}

add_instance pio_control altera_avalon_pio
set_instance_parameter_value pio_control bitClearingEdgeCapReg {0}
set_instance_parameter_value pio_control bitModifyingOutReg {0}
set_instance_parameter_value pio_control captureEdge {0}
set_instance_parameter_value pio_control direction {Output}
set_instance_parameter_value pio_control edgeType {RISING}
set_instance_parameter_value pio_control generateIRQ {0}
set_instance_parameter_value pio_control irqType {LEVEL}
set_instance_parameter_value pio_control resetValue {0.0}
set_instance_parameter_value pio_control simDoTestBenchWiring {0}
set_instance_parameter_value pio_control simDrivenValue {0.0}
set_instance_parameter_value pio_control width {32}

add_instance pio_status altera_avalon_pio
set_instance_parameter_value pio_status bitClearingEdgeCapReg {0}
set_instance_parameter_value pio_status bitModifyingOutReg {0}
set_instance_parameter_value pio_status captureEdge {0}
set_instance_parameter_value pio_status direction {Input}
set_instance_parameter_value pio_status edgeType {RISING}
set_instance_parameter_value pio_status generateIRQ {0}
set_instance_parameter_value pio_status irqType {LEVEL}
set_instance_parameter_value pio_status resetValue {0.0}
set_instance_parameter_value pio_status simDoTestBenchWiring {0}
set_instance_parameter_value pio_status simDrivenValue {0.0}
set_instance_parameter_value pio_status width {32}

add_instance jtag_avmm_bridge altera_jtag_avalon_master
set_instance_parameter_value jtag_avmm_bridge FAST_VER {0}
set_instance_parameter_value jtag_avmm_bridge FIFO_DEPTHS {2}
set_instance_parameter_value jtag_avmm_bridge PLI_PORT {50000}
set_instance_parameter_value jtag_avmm_bridge USE_PLI {0}

add_instance mm_bridge altera_avalon_mm_bridge
set_instance_parameter_value mm_bridge ADDRESS_UNITS {SYMBOLS}
set_instance_parameter_value mm_bridge ADDRESS_WIDTH {23}
set_instance_parameter_value mm_bridge DATA_WIDTH {32}
set_instance_parameter_value mm_bridge LINEWRAPBURSTS {0}
set_instance_parameter_value mm_bridge MAX_BURST_SIZE {1}
set_instance_parameter_value mm_bridge MAX_PENDING_RESPONSES {4}
set_instance_parameter_value mm_bridge MAX_PENDING_WRITES {0}
set_instance_parameter_value mm_bridge PIPELINE_COMMAND {1}
set_instance_parameter_value mm_bridge PIPELINE_RESPONSE {1}
set_instance_parameter_value mm_bridge SYMBOL_WIDTH {8}
set_instance_parameter_value mm_bridge SYNC_RESET {0}
set_instance_parameter_value mm_bridge USE_AUTO_ADDRESS_WIDTH {0}
set_instance_parameter_value mm_bridge USE_RESPONSE {0}
set_instance_parameter_value mm_bridge USE_WRITERESPONSE {0}

# system clock and reset

add_connection systemclk_f_0.out_refclk_fgt_6 intel_jesd204c_f_0.j204c_pll_refclk
add_connection systemclk_f_0.out_systempll_clk_0 intel_jesd204c_f_0.sysclk

add_connection core_pll.outclk0 ed_control.in_clk
add_connection core_pll.outclk1 ed_control.in_clk2x

add_connection ed_control.txlink_clk sysref_rst_n_bridge.clk
add_connection ed_control.txlink_clk txlink_clk.in_clk
add_connection ed_control.txlink_clk intel_jesd204c_f_0.j204c_txlink_clk
add_connection ed_control.rxlink_clk rxlink_clk.in_clk
add_connection ed_control.rxlink_clk intel_jesd204c_f_0.j204c_rxlink_clk
# Connect on the top
#add_connection ed_control.tx_phase intel_jesd204c_f_0.j204c_txfclk_ctrl
#add_connection ed_control.rx_phase intel_jesd204c_f_0.j204c_rxfclk_ctrl

add_connection mgmt_clk.out_clk intel_jesd204c_f_0.j204c_tx_avs_clk
#add_connection mgmt_clk.out_clk intel_jesd204c_f_0.reconfig_xcvr_clk
add_connection mgmt_clk.out_clk intel_jesd204c_f_0.j204c_txlink_clk
add_connection mgmt_clk.out_clk intel_jesd204c_f_0.j204c_rx_avs_clk
add_connection mgmt_clk.out_clk reset_controller_0.clk
add_connection mgmt_clk.out_clk rst_seq_0.clk
add_connection mgmt_clk.out_clk rst_seq_1.clk
add_connection mgmt_clk.out_clk ed_control.mgmt_clk
add_connection mgmt_clk.out_clk edctl_reset_bridge.clk
add_connection mgmt_clk.out_clk mgmt_reset_bridge.clk
add_connection mgmt_clk.out_clk spi_0.clk
add_connection mgmt_clk.out_clk pio_control.clk
add_connection mgmt_clk.out_clk pio_status.clk
add_connection mgmt_clk.out_clk mm_bridge.clk
add_connection mgmt_clk.out_clk jtag_rst_bridge.clk
add_connection mgmt_clk.out_clk jtag_avmm_bridge.clk

add_connection txframe_clk.out_clk intel_jesd204c_f_0.j204c_txframe_clk
add_connection rxframe_clk.out_clk intel_jesd204c_f_0.j204c_rxframe_clk

add_connection refclk_core.out_clk core_pll.refclk
add_connection refclk_core.out_clk rst_seq0_out0_bridge.clk

add_connection rst_seq_0.reset_out0 intel_jesd204c_f_0.j204c_tx_avs_rst_n
add_connection rst_seq_0.reset_out0 intel_jesd204c_f_0.j204c_rx_avs_rst_n
add_connection rst_seq_0.reset_out0 rst_seq0_out0_bridge.in_reset
add_connection rst_seq_0.reset_out1 sysref_rst_n_bridge.in_reset

add_connection rst_seq0_out0_bridge.out_reset core_pll.reset

add_connection sysref_rst_n_bridge.out_reset ed_control.sysref_rst_n

add_connection fpga_m.master_reset reset_controller_0.reset_in0

add_connection reset_controller_0.reset_out rst_seq_0.reset_in0
add_connection reset_controller_0.reset_out rst_seq_1.reset_in0
#add_connection reset_controller_0.reset_out intel_jesd204c_f_0.reconfig_xcvr_reset
add_connection reset_controller_0.reset_out spi_0.reset
add_connection reset_controller_0.reset_out pio_control.reset
add_connection reset_controller_0.reset_out pio_status.reset

add_connection jtag_avmm_bridge.master spi_0.spi_control_port
add_connection jtag_avmm_bridge.master pio_control.s1
add_connection jtag_avmm_bridge.master pio_status.s1
add_connection jtag_avmm_bridge.master mm_bridge.s0
add_connection jtag_avmm_bridge.master rst_seq_0.av_csr
add_connection jtag_avmm_bridge.master rst_seq_1.av_csr
add_connection jtag_avmm_bridge.master ed_control.j204c_f_ed_ctrl_avs
#add_connection jtag_avmm_bridge.master intel_jesd204c_f_0.reconfig_xcvr
add_connection jtag_avmm_bridge.master_reset jtag_rst_bridge.in_reset

add_connection jtag_reset.out_reset mm_bridge.reset
add_connection jtag_reset.out_reset jtag_avmm_bridge.clk_reset

add_connection mm_bridge.m0 intel_jesd204c_f_0.j204c_tx_avs
add_connection mm_bridge.m0 intel_jesd204c_f_0.j204c_rx_avs

add_connection edctl_reset_bridge.out_reset rst_seq_0.csr_reset
add_connection edctl_reset_bridge.out_reset rst_seq_1.csr_reset
add_connection edctl_reset_bridge.out_reset ed_control.edctl_rst_n

add_connection mgmt_reset_bridge.out_reset reset_controller_0.reset_in0

add_connection intel_jesd204c_f_0.j204c_rx_alldev_lane_align intel_jesd204c_f_0.j204c_rx_dev_lane_align

## Exported signals

add_interface mgmt_clk                   clock     sink
add_interface mgmt_reset                 reset     sink
add_interface txframe_clk                clock     sink
add_interface rxframe_clk                clock     sink
add_interface refclk_core                clock     sink
add_interface j204c_tx_rst_n             reset     sink
add_interface j204c_rx_rst_n             reset     sink
add_interface edctl_rst                  reset     sink
add_interface jtag_reset_clk             clock     sink
add_interface jtag_reset_in_reset        reset     sink
add_interface jtag_rst_bridge_out_reset  reset     sink
add_interface txlink_clk                 clock     sink
add_interface rxlink_clk                 clock     sink
add_interface ed_control_txframe_clk     clock     sink
add_interface ed_control_rxframe_clk     clock     sink
add_interface ed_control_rx_phase        clock     sink
add_interface ed_control_in_sysref       conduit   sink
add_interface spi_0_irq                  interrupt sender
add_interface spi_0_external             conduit   end
add_interface pio_control_external       conduit   end
add_interface pio_status_external        conduit   end
add_interface ed_control_rx_phase        clock     source
add_interface ed_control_tx_phase        clock     source
add_interface j204c_rxfclk_ctrl          conduit   end
add_interface j204c_txfclk_ctrl          conduit   end
# const HIGH
add_interface j204c_rxlclk_ctrl          conduit   end
add_interface j204c_txlclk_ctrl          conduit   end
#
add_interface j204c_tx_cmd_data          avalon    sink
add_interface j204c_rx_cmd_data          avalon    source
add_interface ed_control_rst_sts_detected0_rst_sts_set_i conduit sink
add_interface ed_control_tst_err0_tst_error_i            conduit sink
add_interface ed_control_rst_sts0_rst_status_i           conduit sink
add_interface j204c_rx_avst_control      conduit sink
add_interface j204c_tx_avst_control      conduit sink
# AD9081 SYSREF
add_interface j204c_rx_sysref            conduit sink
add_interface j204c_tx_sysref            conduit sink
# To JESD204C ports
add_interface j204c_rx_serial_data_p     conduit sink
add_interface j204c_rx_serial_data_n     conduit sink
add_interface j204c_rx_serial_data_p     conduit sink
add_interface j204c_tx_serial_data_n     conduit sink
#
add_interface rst_seq_0_reset1_dsrt_qual conduit sink
add_interface rst_seq_0_reset2_dsrt_qual conduit sink
add_interface rst_seq_1_reset0_dsrt_qual conduit sink
add_interface rst_seq_1_reset1_dsrt_qual conduit sink
add_interface systemclk_f_0_refclk_fgt   conduit sink
add_interface j204c_rx_int               conduit sink
add_interface j204c_tx_int               conduit sink

set_interface_property mgmt_clk                   EXPORT_OF mgmt_clk.in_clk
set_interface_property mgmt_reset                 EXPORT_OF mgmt_reset_bridge.in_reset
set_interface_property refclk_core                EXPORT_OF refclk_core.in_clk
set_interface_property txframe_clk                EXPORT_OF txframe_clk.in_clk
set_interface_property txlink_clk                 EXPORT_OF txlink_clk.out_clk
set_interface_property rxframe_clk                EXPORT_OF rxframe_clk.in_clk
set_interface_property rxlink_clk                 EXPORT_OF rxlink_clk.out_clk
set_interface_property j204c_tx_rst_n             EXPORT_OF intel_jesd204c_f_0.j204c_tx_rst_n
set_interface_property j204c_rx_rst_n             EXPORT_OF intel_jesd204c_f_0.j204c_rx_rst_n
set_interface_property ed_control_txframe_clk     EXPORT_OF ed_control.txframe_clk
set_interface_property ed_control_rxframe_clk     EXPORT_OF ed_control.rxframe_clk
set_interface_property edctl_rst                  EXPORT_OF edctl_reset_bridge.in_reset
set_interface_property spi_0_irq                  EXPORT_OF spi_0.irq
set_interface_property spi_0_external             EXPORT_OF spi_0.external
set_interface_property pio_control_external       EXPORT_OF pio_control.external_connection
set_interface_property pio_status_external        EXPORT_OF pio_status.external_connection
set_interface_property jtag_reset_clk             EXPORT_OF jtag_reset.clk
set_interface_property jtag_reset_in_reset        EXPORT_OF jtag_reset.in_reset
set_interface_property jtag_rst_bridge_out_reset  EXPORT_OF jtag_rst_bridge.out_reset
set_interface_property ed_control_rx_phase        EXPORT_OF ed_control.rx_phase
set_interface_property ed_control_tx_phase        EXPORT_OF ed_control.tx_phase
set_interface_property j204c_rxfclk_ctrl          EXPORT_OF intel_jesd204c_f_0.j204c_rxfclk_ctrl
set_interface_property j204c_txfclk_ctrl          EXPORT_OF intel_jesd204c_f_0.j204c_txfclk_ctrl
set_interface_property j204c_rxlclk_ctrl          EXPORT_OF intel_jesd204c_f_0.j204c_rxlclk_ctrl
set_interface_property j204c_txlclk_ctrl          EXPORT_OF intel_jesd204c_f_0.j204c_txlclk_ctrl
set_interface_property ed_control_in_sysref       EXPORT_OF ed_control.in_sysref
set_interface_property ed_control_rst_sts_detected0_rst_sts_set_i EXPORT_OF ed_control.rst_sts_detected0_rst_sts_set_i
set_interface_property ed_control_tst_err0_tst_error_i            EXPORT_OF ed_control.tst_err0_tst_error_i
set_interface_property ed_control_rst_sts0_rst_status_i           EXPORT_OF ed_control.rst_sts0_rst_status_i
set_interface_property j204c_rx_avst_control      EXPORT_OF intel_jesd204c_f_0.j204c_rx_avst_control
set_interface_property j204c_tx_avst_control      EXPORT_OF intel_jesd204c_f_0.j204c_tx_avst_control
set_interface_property j204c_rx_sysref            EXPORT_OF intel_jesd204c_f_0.j204c_rx_sysref
set_interface_property j204c_tx_sysref            EXPORT_OF intel_jesd204c_f_0.j204c_tx_sysref
set_interface_property j204c_rx_serial_data_p     EXPORT_OF intel_jesd204c_f_0.rx_serial_data
set_interface_property j204c_rx_serial_data_n     EXPORT_OF intel_jesd204c_f_0.rx_serial_data_n
set_interface_property j204c_rx_serial_data_p     EXPORT_OF intel_jesd204c_f_0.rx_serial_data
set_interface_property j204c_tx_serial_data_n     EXPORT_OF intel_jesd204c_f_0.tx_serial_data_n
set_interface_property rst_seq_0_reset1_dsrt_qual EXPORT_OF rst_seq_0.reset1_dsrt_qual
set_interface_property rst_seq_0_reset2_dsrt_qual EXPORT_OF rst_seq_0.reset2_dsrt_qual
set_interface_property rst_seq_1_reset0_dsrt_qual EXPORT_OF rst_seq_1.reset0_dsrt_qual
set_interface_property rst_seq_1_reset1_dsrt_qual EXPORT_OF rst_seq_1.reset1_dsrt_qual
set_interface_property systemclk_f_0_refclk_fgt   EXPORT_OF systemclk_f_0.refclk_fgt
set_interface_property j204c_rx_int               EXPORT_OF intel_jesd204c_f_0.j204c_rx_int
set_interface_property j204c_tx_int               EXPORT_OF intel_jesd204c_f_0.j204c_tx_int

set_connection_parameter_value jtag_avmm_bridge.master/mm_bridge.s0 baseAddress {0x0000}
set_connection_parameter_value jtag_avmm_bridge.master/pio_control.s1 baseAddress {0x01020020}
set_connection_parameter_value jtag_avmm_bridge.master/pio_status.s1 baseAddress {0x01020040}
set_connection_parameter_value jtag_avmm_bridge.master/rst_seq_0.av_csr baseAddress {0x01020100}
set_connection_parameter_value jtag_avmm_bridge.master/rst_seq_1.av_csr baseAddress {0x01020200}
set_connection_parameter_value jtag_avmm_bridge.master/spi_0.spi_control_port baseAddress {0x01020000}
set_connection_parameter_value mm_bridge.m0/intel_jesd204c_f_0.j204c_tx_avs baseAddress {0x000c0000}
set_connection_parameter_value jtag_avmm_bridge.master/ed_control.j204c_f_ed_ctrl_avs baseAddress {0x01020400}
#set_connection_parameter_value jtag_avmm_bridge.master/intel_jesd204c_f_0.reconfig_xcvr baseAddress {0x02000000}

# Mxfe specific
# ------------------------------------------------------------------------------

add_instance mxfe_rx_tpl ad_ip_jesd204_tpl_adc
set_instance_parameter_value mxfe_rx_tpl {ID} {0}
set_instance_parameter_value mxfe_rx_tpl {NUM_CHANNELS} $RX_NUM_OF_CONVERTERS
set_instance_parameter_value mxfe_rx_tpl {NUM_LANES} $RX_NUM_OF_LANES
set_instance_parameter_value mxfe_rx_tpl {BITS_PER_SAMPLE} $RX_SAMPLE_WIDTH
set_instance_parameter_value mxfe_rx_tpl {CONVERTER_RESOLUTION} $RX_SAMPLE_WIDTH
set_instance_parameter_value mxfe_rx_tpl {TWOS_COMPLEMENT} {1}
set_instance_parameter_value mxfe_rx_tpl {OCTETS_PER_BEAT} $RX_TPL_DATA_PATH_WIDTH
set_instance_parameter_value mxfe_rx_tpl {DMA_BITS_PER_SAMPLE} $RX_DMA_SAMPLE_WIDTH

add_instance mxfe_tx_tpl ad_ip_jesd204_tpl_dac
set_instance_parameter_value mxfe_tx_tpl {ID} {0}
set_instance_parameter_value mxfe_tx_tpl {NUM_CHANNELS} $TX_NUM_OF_CONVERTERS
set_instance_parameter_value mxfe_tx_tpl {NUM_LANES} $TX_NUM_OF_LANES
set_instance_parameter_value mxfe_tx_tpl {BITS_PER_SAMPLE} $TX_SAMPLE_WIDTH
set_instance_parameter_value mxfe_tx_tpl {CONVERTER_RESOLUTION} $TX_SAMPLE_WIDTH
set_instance_parameter_value mxfe_tx_tpl {OCTETS_PER_BEAT} $TX_TPL_DATA_PATH_WIDTH
set_instance_parameter_value mxfe_tx_tpl {DMA_BITS_PER_SAMPLE} $TX_DMA_SAMPLE_WIDTH

# pack(s) & unpack(s)

add_instance mxfe_tx_upack util_upack2
set_instance_parameter_value mxfe_tx_upack {NUM_OF_CHANNELS} $TX_NUM_OF_CONVERTERS
set_instance_parameter_value mxfe_tx_upack {SAMPLES_PER_CHANNEL} $TX_SAMPLES_PER_CHANNEL
set_instance_parameter_value mxfe_tx_upack {SAMPLE_DATA_WIDTH} $TX_DMA_SAMPLE_WIDTH
set_instance_parameter_value mxfe_tx_upack {INTERFACE_TYPE} {1}

add_instance mxfe_rx_cpack util_cpack2
set_instance_parameter_value mxfe_rx_cpack {NUM_OF_CHANNELS} $RX_NUM_OF_CONVERTERS
set_instance_parameter_value mxfe_rx_cpack {SAMPLES_PER_CHANNEL} $RX_SAMPLES_PER_CHANNEL
set_instance_parameter_value mxfe_rx_cpack {SAMPLE_DATA_WIDTH} $RX_DMA_SAMPLE_WIDTH

# RX and TX data offload buffers

ad_adcfifo_create $adc_fifo_name $adc_data_width $adc_dma_data_width $adc_fifo_address_width
ad_dacfifo_create $dac_fifo_name $dac_data_width $dac_dma_data_width $dac_fifo_address_width

# RX and TX DMA instance and connections

add_instance mxfe_tx_dma axi_dmac
set_instance_parameter_value mxfe_tx_dma {ID} {0}
set_instance_parameter_value mxfe_tx_dma {DMA_DATA_WIDTH_SRC} {128}
set_instance_parameter_value mxfe_tx_dma {DMA_DATA_WIDTH_DEST} $dac_dma_data_width
set_instance_parameter_value mxfe_tx_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value mxfe_tx_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value mxfe_tx_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value mxfe_tx_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value mxfe_tx_dma {SYNC_TRANSFER_START} {0}
set_instance_parameter_value mxfe_tx_dma {CYCLIC} {1}
set_instance_parameter_value mxfe_tx_dma {DMA_TYPE_DEST} {1}
set_instance_parameter_value mxfe_tx_dma {DMA_TYPE_SRC} {0}
set_instance_parameter_value mxfe_tx_dma {FIFO_SIZE} {16}
set_instance_parameter_value mxfe_tx_dma {HAS_AXIS_TLAST} {1}
set_instance_parameter_value mxfe_tx_dma {DMA_AXI_PROTOCOL_SRC} {0}
set_instance_parameter_value mxfe_tx_dma {MAX_BYTES_PER_BURST} {4096}

add_instance mxfe_rx_dma axi_dmac
set_instance_parameter_value mxfe_rx_dma {ID} {0}
set_instance_parameter_value mxfe_rx_dma {DMA_DATA_WIDTH_SRC} $adc_dma_data_width
set_instance_parameter_value mxfe_rx_dma {DMA_DATA_WIDTH_DEST} {128}
set_instance_parameter_value mxfe_rx_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value mxfe_rx_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value mxfe_rx_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value mxfe_rx_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value mxfe_rx_dma {SYNC_TRANSFER_START} {0}
set_instance_parameter_value mxfe_rx_dma {CYCLIC} {0}
set_instance_parameter_value mxfe_rx_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value mxfe_rx_dma {DMA_TYPE_SRC} {1}
set_instance_parameter_value mxfe_rx_dma {FIFO_SIZE} {16}
set_instance_parameter_value mxfe_rx_dma {DMA_AXI_PROTOCOL_DEST} {0}
set_instance_parameter_value mxfe_rx_dma {MAX_BYTES_PER_BURST} {4096}

# mxfe gpio

add_instance mxfe_gpio altera_avalon_pio
set_instance_parameter_value mxfe_gpio {direction} {Input}
set_instance_parameter_value mxfe_gpio {generateIRQ} {1}
set_instance_parameter_value mxfe_gpio {width} {15}
add_connection sys_clk.clk mxfe_gpio.clk
add_connection sys_clk.clk_reset mxfe_gpio.reset
add_interface mxfe_gpio conduit end
set_interface_property mxfe_gpio EXPORT_OF mxfe_gpio.external_connection

#
## clocks and resets
#

# system clock and reset

add_connection sys_clk.clk mxfe_rx_tpl.s_axi_clock
add_connection sys_clk.clk mxfe_rx_dma.s_axi_clock
add_connection sys_clk.clk mxfe_tx_tpl.s_axi_clock
add_connection sys_clk.clk mxfe_tx_dma.s_axi_clock

add_connection sys_clk.clk_reset mxfe_rx_tpl.s_axi_reset
add_connection sys_clk.clk_reset mxfe_rx_dma.s_axi_reset
add_connection sys_clk.clk_reset mxfe_tx_tpl.s_axi_reset
add_connection sys_clk.clk_reset mxfe_tx_dma.s_axi_reset

add_connection mgmt_clk.out_clk mxfe_tx_tpl.link_clk
add_connection mgmt_clk.out_clk mxfe_tx_upack.clk
add_connection mgmt_clk.out_clk $dac_fifo_name.if_dac_clk

add_connection sysref_rst_n_bridge.out_reset mxfe_rx_cpack.reset
add_connection sysref_rst_n_bridge.out_reset $adc_fifo_name.if_adc_rst
add_connection sysref_rst_n_bridge.out_reset mxfe_tx_upack.reset
add_connection sysref_rst_n_bridge.out_reset $dac_fifo_name.if_dac_rst

add_connection ed_control.rxlink_clk mxfe_rx_cpack.clk
add_connection ed_control.rxlink_clk mxfe_rx_tpl.link_clk
add_connection ed_control.rxlink_clk $adc_fifo_name.if_adc_clk

add_connection intel_jesd204c_f_0.j204c_rx_avst mxfe_rx_tpl.link_data
add_connection mxfe_tx_tpl.link_data intel_jesd204c_f_0.j204c_tx_avst

# dma clock and reset

add_connection sys_dma_clk.clk $adc_fifo_name.if_dma_clk
add_connection sys_dma_clk.clk mxfe_rx_dma.if_s_axis_aclk
add_connection sys_dma_clk.clk mxfe_rx_dma.m_dest_axi_clock

add_connection sys_dma_clk.clk_reset mxfe_rx_dma.m_dest_axi_reset

add_connection sys_dma_clk.clk $dac_fifo_name.if_dma_clk
add_connection sys_dma_clk.clk mxfe_tx_dma.if_m_axis_aclk
add_connection sys_dma_clk.clk mxfe_tx_dma.m_src_axi_clock

add_connection sys_dma_clk.clk_reset mxfe_tx_dma.m_src_axi_reset
add_connection sys_dma_clk.clk_reset $dac_fifo_name.if_dma_rst

# RX cpack to offload
add_connection mxfe_rx_cpack.if_packed_fifo_wr_en $adc_fifo_name.if_adc_wr
add_connection mxfe_rx_cpack.if_packed_fifo_wr_data $adc_fifo_name.if_adc_wdata
add_connection mxfe_rx_tpl.if_adc_dovf $adc_fifo_name.if_adc_wovf
# RX offload to dma
add_connection $adc_fifo_name.if_dma_xfer_req mxfe_rx_dma.if_s_axis_xfer_req
add_connection $adc_fifo_name.m_axis mxfe_rx_dma.s_axis
# RX dma to HPS
ad_dma_interconnect mxfe_rx_dma.m_dest_axi
# RX tpl to cpack
for {set i 0} {$i < $RX_NUM_OF_CONVERTERS} {incr i} {
  add_connection mxfe_rx_tpl.adc_ch_$i mxfe_rx_cpack.adc_ch_$i
}
# TX upack to offload
add_connection mxfe_tx_upack.if_packed_fifo_rd_en $dac_fifo_name.if_dac_valid
add_connection $dac_fifo_name.if_dac_data mxfe_tx_upack.if_packed_fifo_rd_data
add_connection $dac_fifo_name.if_dac_dunf mxfe_tx_tpl.if_dac_dunf
# TX offload to dma
add_connection mxfe_tx_dma.if_m_axis_xfer_req $dac_fifo_name.if_dma_xfer_req
add_connection mxfe_tx_dma.m_axis $dac_fifo_name.s_axis
# TX dma to HPS
ad_dma_interconnect mxfe_tx_dma.m_src_axi
# TX tpl to pack
for {set i 0} {$i < $TX_NUM_OF_CONVERTERS} {incr i} {
  add_connection mxfe_tx_upack.dac_ch_$i mxfe_tx_tpl.dac_ch_$i
}

add_interface mxfe_rx_tpl_if_link_sof    conduit sink

set_interface_property mxfe_rx_tpl_if_link_sof    EXPORT_OF mxfe_rx_tpl.if_link_sof

ad_cpu_interconnect 0x000D2000 mxfe_rx_tpl.s_axi
ad_cpu_interconnect 0x000D4000 mxfe_tx_tpl.s_axi
ad_cpu_interconnect 0x000E0000 mxfe_gpio.s1

#
## interrupts
#

ad_cpu_interrupt 11  mxfe_rx_dma.interrupt_sender
ad_cpu_interrupt 12  mxfe_tx_dma.interrupt_sender
ad_cpu_interrupt 15  mxfe_gpio.irq
