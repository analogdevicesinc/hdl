###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## ADC FIFO depth in samples per converter
set adc_fifo_samples_per_converter [expr 32*1024]
## DAC FIFO depth in samples per converter
set dac_fifo_samples_per_converter [expr 32*1024]

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 10
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 10

set sys_cstring "JESD_MODE=$ad_project_params(JESD_MODE)\
ORX_ENABLE=$ad_project_params(ORX_ENABLE)\
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
ORX:RATE=$ad_project_params(RX_LANE_RATE)\
M=$ad_project_params(RX_OS_JESD_M)\
L=$ad_project_params(RX_OS_JESD_L)\
S=$ad_project_params(RX_OS_JESD_S)\
NP=$ad_project_params(RX_OS_JESD_NP)\
LINKS=$ad_project_params(RX_OS_NUM_LINKS)"

sysid_gen_sys_init_file

source ../common/adrv904x_bd.tcl
