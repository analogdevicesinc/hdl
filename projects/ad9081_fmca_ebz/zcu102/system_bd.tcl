###############################################################################
## Copyright (C) 2019-2024, 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## ADC FIFO depth in samples per converter
set adc_fifo_samples_per_converter [expr 64*1024]
## DAC FIFO depth in samples per converter
set dac_fifo_samples_per_converter [expr 64*1024]

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl

ad_mem_hp0_interconnect $sys_cpu_clk sys_ps8/S_AXI_HP0

source $ad_hdl_dir/projects/ad9081_fmca_ebz/common/ad9081_fmca_ebz_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 10
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 10

set SHARED_DEVCLK [ expr { [info exists ad_project_params(SHARED_DEVCLK)] \
                          ? $ad_project_params(SHARED_DEVCLK) : 0 } ]
set TDD_SUPPORT [ expr { [info exists ad_project_params(TDD_SUPPORT)] \
                          ? $ad_project_params(TDD_SUPPORT) : 0 } ]
set TDD_CHANNEL_CNT [ expr { [info exists ad_project_params(TDD_CHANNEL_CNT)] \
                          ? $ad_project_params(TDD_CHANNEL_CNT) : 0 } ]
set TDD_SYNC_WIDTH [ expr { [info exists ad_project_params(TDD_SYNC_WIDTH)] \
                          ? $ad_project_params(TDD_SYNC_WIDTH) : 0 } ]
set TDD_SYNC_INT [ expr { [info exists ad_project_params(TDD_SYNC_INT)] \
                          ? $ad_project_params(TDD_SYNC_INT) : 0 } ]
set TDD_SYNC_EXT [ expr { [info exists ad_project_params(TDD_SYNC_EXT)] \
                          ? $ad_project_params(TDD_SYNC_EXT) : 0 } ]
set TDD_SYNC_EXT_CDC [ expr { [info exists ad_project_params(TDD_SYNC_EXT_CDC)] \
                          ? $ad_project_params(TDD_SYNC_EXT_CDC) : 0 } ]

set sys_cstring "$ad_project_params(JESD_MODE)\
RX:RATE=$ad_project_params(RX_LANE_RATE)\
M=$ad_project_params(RX_JESD_M)\
L=$ad_project_params(RX_JESD_L)\
S=$ad_project_params(RX_JESD_S)\
NP=$ad_project_params(RX_JESD_NP)\
LINKS=$ad_project_params(RX_NUM_LINKS)\
TX:RATE=$ad_project_params(TX_LANE_RATE)\
M=$ad_project_params(TX_JESD_M)\
L=$ad_project_params(TX_JESD_L)\
S=$ad_project_params(TX_JESD_S)\
NP=$ad_project_params(TX_JESD_NP)\
LINKS=$ad_project_params(TX_NUM_LINKS)\
SHARED_DEVCLK=$SHARED_DEVCLK\
TDD:SUPPORT=$TDD_SUPPORT\
CHANNEL_CNT=$TDD_CHANNEL_CNT\
SYNC_WIDTH=$TDD_SYNC_WIDTH\
SYNC_INT=$TDD_SYNC_INT\
SYNC_EXT=$TDD_SYNC_EXT\
SYNC_EXT_CDC=$TDD_SYNC_EXT_CDC"

sysid_gen_sys_init_file $sys_cstring 10
