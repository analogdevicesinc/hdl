###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## ADC FIFO depth in samples per converter
set adc_fifo_samples_per_converter [expr $ad_project_params(RX_KS_PER_CHANNEL)*1024]
## DAC FIFO depth in samples per converter
set dac_fifo_samples_per_converter [expr $ad_project_params(TX_KS_PER_CHANNEL)*1024]

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/intel/dacfifo_qsys.tcl
source $ad_hdl_dir/projects/common/intel/adcfifo_qsys.tcl
source $ad_hdl_dir/projects/common/a5e/a5e_system_qsys.tcl

set jesd_mode $ad_project_params(JESD_MODE)

set jesd204_ref_clock [format {%.6f} $ad_project_params(REF_CLK_RATE)]
if {$jesd_mode == "64B66B"} {
  set syspll_freq [format {%.6f} [expr $ad_project_params(RX_LANE_RATE)*1000 / 32]]
} else {
  set syspll_freq [format {%.6f} [expr $ad_project_params(RX_LANE_RATE)*1000 / 20]]
}

# The Agilex 5 GTS transceivers need a stand-alone PHY core, and the plain Intel
# DAC FIFO (no PL DDR4 on this carrier).
set TRANSCEIVER_TYPE "E-Tile"
set dacfifo_has_ddr_arg 0

set HSCI_ENABLE 0
set ASYMMETRIC_A_B_MODE 0

# Lane polarity per PHY, one bit per lane. Both lanes of PHY A are inverted:
# Apollo reports a bad ILAS checksum on side A while side B is clean.
# set PHY_A_LANE_INVERT 0x3
# set PHY_B_LANE_INVERT 0x0
if [info exists ad_project_dir] {
  source ../../common/ad9084_ebz_qsys.tcl
} else {
  source ../common/ad9084_ebz_qsys.tcl
}

# GTS system PLL
#
# One instance per transceiver bank, each fed by that bank's own reference clock.
# A single PLL only ever brought up the bank whose refclk it was driven from,
# regardless of what UG 817660 section 4.4 says about reaching adjacent banks.

foreach pll {a b} {
  add_instance gts_pll_${pll} intel_systemclk_gts
  set_instance_parameter_value gts_pll_${pll} syspll_mod_0 {User Configuration}
  set_instance_parameter_value gts_pll_${pll} syspll_freq_mhz_0 $syspll_freq
  set_instance_parameter_value gts_pll_${pll} refclk_xcvr_freq_mhz_0 $jesd204_ref_clock

  add_interface gts_pll_${pll}_i_refclk_rdy conduit end
  add_interface gts_pll_${pll}_o_pll_lock   conduit end
  add_interface gts_pll_${pll}_refclk_xcvr  clock sink
  add_interface gts_pll_${pll}_o_syspll_c0  clock source

  set_interface_property gts_pll_${pll}_i_refclk_rdy EXPORT_OF gts_pll_${pll}.i_refclk_rdy
  set_interface_property gts_pll_${pll}_o_pll_lock   EXPORT_OF gts_pll_${pll}.o_pll_lock
  set_interface_property gts_pll_${pll}_refclk_xcvr  EXPORT_OF gts_pll_${pll}.refclk_xcvr
  set_interface_property gts_pll_${pll}_o_syspll_c0  EXPORT_OF gts_pll_${pll}.o_syspll_c0
}

# Internal 100 MHz clock exported, used by the GTS refclk reset state machine

add_instance sys_cpu_clk_bridge altera_clock_bridge
set_instance_parameter_value sys_cpu_clk_bridge {EXPLICIT_CLOCK_RATE} {100000000}
add_connection sys_clk.clk sys_cpu_clk_bridge.in_clk

add_interface sys_cpu_clk clock source
set_interface_property sys_cpu_clk EXPORT_OF sys_cpu_clk_bridge.out_clk

# Apollo spi

add_instance apollo_spi altera_avalon_spi
set_instance_parameter_value apollo_spi {clockPhase} {0}
set_instance_parameter_value apollo_spi {clockPolarity} {0}
set_instance_parameter_value apollo_spi {dataWidth} {8}
set_instance_parameter_value apollo_spi {masterSPI} {1}
set_instance_parameter_value apollo_spi {numberOfSlaves} {8}
set_instance_parameter_value apollo_spi {targetClockRate} {10000000.0}

add_connection sys_clk.clk_reset apollo_spi.reset
add_connection sys_clk.clk apollo_spi.clk
add_interface apollo_spi conduit end
set_interface_property apollo_spi EXPORT_OF apollo_spi.external

ad_cpu_interconnect 0x000EA000 apollo_spi.spi_control_port

ad_cpu_interrupt 18 apollo_spi.irq

# system ID

set_instance_parameter_value axi_sysid_0 {ROM_ADDR_BITS} {10}
set_instance_parameter_value rom_sys_0 {ROM_ADDR_BITS} {10}
set_instance_parameter_value rom_sys_0 {PATH_TO_FILE} "$mem_init_sys_file_path/mem_init_sys.txt"

set sys_cstring "$ad_project_params(JESD_MODE)\
RX:RATE=$ad_project_params(RX_LANE_RATE)\
M=$ad_project_params(RX_JESD_M)\
L=$ad_project_params(RX_JESD_L)\
S=$ad_project_params(RX_JESD_S)\
NP=$ad_project_params(RX_JESD_NP)\
LINKS=$ad_project_params(RX_NUM_LINKS)\
KS/CH=$ad_project_params(RX_KS_PER_CHANNEL)\
TX:RATE=$ad_project_params(TX_LANE_RATE)\
M=$ad_project_params(TX_JESD_M)\
L=$ad_project_params(TX_JESD_L)\
S=$ad_project_params(TX_JESD_S)\
NP=$ad_project_params(TX_JESD_NP)\
LINKS=$ad_project_params(TX_NUM_LINKS)\
KS/CH=$ad_project_params(TX_KS_PER_CHANNEL)\
REF_CLK=$ad_project_params(REF_CLK_RATE)\
DEV_CLK=$ad_project_params(DEVICE_CLK_RATE)"

sysid_gen_sys_init_file sys_cstring 10
