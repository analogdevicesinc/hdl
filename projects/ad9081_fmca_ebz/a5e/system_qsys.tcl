###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## ADC FIFO depth in samples per converter
set adc_fifo_samples_per_converter [expr $ad_project_params(RX_KS_PER_CHANNEL)*1024]
## DAC FIFO depth in samples per converter
set dac_fifo_samples_per_converter [expr $ad_project_params(TX_KS_PER_CHANNEL)*1024]



source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/intel/dacfifo_qsys.tcl
source $ad_hdl_dir/projects/common/intel/adcfifo_qsys.tcl

set JESD_MODE     $ad_project_params(JESD_MODE)
set RX_JESD_M     $ad_project_params(RX_JESD_M)
set RX_JESD_L     $ad_project_params(RX_JESD_L)
set RX_JESD_S     $ad_project_params(RX_JESD_S)
set RX_JESD_NP    $ad_project_params(RX_JESD_NP)
set TX_JESD_M     $ad_project_params(TX_JESD_M)
set TX_JESD_L     $ad_project_params(TX_JESD_L)
set TX_JESD_S     $ad_project_params(TX_JESD_S)
set TX_JESD_NP    $ad_project_params(TX_JESD_NP)
set REF_CLK_RATE  $ad_project_params(REF_CLK_RATE)
set RX_LANE_RATE  [expr $ad_project_params(RX_LANE_RATE)*1000]
set TX_LANE_RATE  [expr $ad_project_params(TX_LANE_RATE)*1000]

set MAX_NUM_OF_LANES $RX_JESD_L
if {$MAX_NUM_OF_LANES < $TX_JESD_L} {
  set MAX_NUM_OF_LANES $TX_JESD_L
}

source $ad_hdl_dir/projects/common/a5e/a5e_system_qsys.tcl

set jesd_mode $ad_project_params(JESD_MODE)

set jesd204_ref_clock [format {%.6f} $ad_project_params(REF_CLK_RATE)]
if {$jesd_mode == "64B66B"} {
  set syspll_freq [format {%.6f} [expr $ad_project_params(RX_LANE_RATE)*1000 / 32]]
} else {
  set syspll_freq [format {%.6f} [expr $ad_project_params(RX_LANE_RATE)*1000 / 20]]
}

set TRANSCEIVER_TYPE "E-Tile"
if [info exists ad_project_dir] {
  source ../../common/ad9081_fmca_ebz_qsys.tcl
} else {
  source ../common/ad9081_fmca_ebz_qsys.tcl
}

# GTS PLL
add_instance gts_pll intel_systemclk_gts
set_instance_parameter_value gts_pll syspll_mod_0 {User Configuration}
set_instance_parameter_value gts_pll syspll_freq_mhz_0 $syspll_freq
set_instance_parameter_value gts_pll refclk_xcvr_freq_mhz_0 $jesd204_ref_clock

add_interface i_refclk_rdy conduit end
add_interface o_pll_lock   conduit end
add_interface refclk_xcvr  clock sink
add_interface o_syspll_c0  clock source

set_interface_property i_refclk_rdy EXPORT_OF gts_pll.i_refclk_rdy
set_interface_property o_pll_lock   EXPORT_OF gts_pll.o_pll_lock
set_interface_property refclk_xcvr  EXPORT_OF gts_pll.refclk_xcvr
set_interface_property o_syspll_c0  EXPORT_OF gts_pll.o_syspll_c0

#system ID
set_instance_parameter_value axi_sysid_0 {ROM_ADDR_BITS} {9}
set_instance_parameter_value rom_sys_0 {PATH_TO_FILE} "$mem_init_sys_file_path/mem_init_sys.txt"
set_instance_parameter_value rom_sys_0 {ROM_ADDR_BITS} {9}

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

sysid_gen_sys_init_file sys_cstring
