###############################################################################
## Copyright (C) 2024-2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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

sysid_gen_sys_init_file $sys_cstring 10

source ../common/adrv904x_bd.tcl

ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {300}

set_property -dict [list \
  CONFIG.RXCDR_CFG2 {0x0256} \
  CONFIG.RXCDR_CFG2_GEN2 {0x256} \
] [get_bd_cells util_adrv904x_xcvr]

if {[info exists ::env(PROBE_RX)] && $::env(PROBE_RX) == 1} {
  add_files -norecurse -fileset sources_1 $ad_hdl_dir/projects/adrv904x/common/rx_capture.v
  update_compile_order -fileset sources_1
  create_bd_cell -type module -reference rx_capture rx_capture_0
  ad_ip_instance xlconcat probe_rx_hdr [list \
    NUM_PORTS 4 \
    IN0_WIDTH 2 \
    IN1_WIDTH 2 \
    IN2_WIDTH 2 \
    IN3_WIDTH 2 \
  ]
  ad_ip_instance xlconcat probe_rx_bs [list NUM_PORTS 4]
  ad_connect util_adrv904x_xcvr/rx_header_1     probe_rx_hdr/In0
  ad_connect util_adrv904x_xcvr/rx_header_0     probe_rx_hdr/In1
  ad_connect util_adrv904x_xcvr/rx_header_3     probe_rx_hdr/In2
  ad_connect util_adrv904x_xcvr/rx_header_2     probe_rx_hdr/In3
  ad_connect util_adrv904x_xcvr/rx_block_sync_1 probe_rx_bs/In0
  ad_connect util_adrv904x_xcvr/rx_block_sync_0 probe_rx_bs/In1
  ad_connect util_adrv904x_xcvr/rx_block_sync_3 probe_rx_bs/In2
  ad_connect util_adrv904x_xcvr/rx_block_sync_2 probe_rx_bs/In3
  ad_connect util_adrv904x_xcvr/rx_out_clk_div2_0 rx_capture_0/rx_clk
  ad_connect util_adrv904x_xcvr/rx_data_1         rx_capture_0/rx_data
  ad_connect probe_rx_hdr/dout                    rx_capture_0/rx_header
  ad_connect probe_rx_bs/dout                     rx_capture_0/rx_block_sync
  ad_connect sys_cpu_clk                          rx_capture_0/up_clk
  ad_ip_instance axi_gpio probe_rx_gpio [list \
    C_IS_DUAL 1 \
    C_ALL_OUTPUTS 1 \
    C_ALL_INPUTS_2 1 \
    C_GPIO_WIDTH 32 \
    C_GPIO2_WIDTH 32 \
  ]
  ad_connect probe_rx_gpio/gpio_io_o   rx_capture_0/up_ctrl
  ad_connect rx_capture_0/up_rdata     probe_rx_gpio/gpio2_io_i
  ad_cpu_interconnect 0x44B00000 probe_rx_gpio
}
