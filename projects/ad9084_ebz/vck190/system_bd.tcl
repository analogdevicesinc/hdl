###############################################################################
## Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
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
set adc_fifo_samples_per_converter [expr $ad_project_params(RX_KS_PER_CHANNEL)*1024]
## DAC FIFO depth in samples per converter
set dac_fifo_samples_per_converter [expr $ad_project_params(TX_KS_PER_CHANNEL)*1024]

set ASYMMETRIC_A_B_MODE [ expr { [info exists ad_project_params(ASYMMETRIC_A_B_MODE)] \
                          ? $ad_project_params(ASYMMETRIC_A_B_MODE) : 0 } ]

if {$ASYMMETRIC_A_B_MODE == 1} {
  ## ADC B Side FIFO depth in samples per converter
  set adc_b_fifo_samples_per_converter [expr $ad_project_params(RX_B_KS_PER_CHANNEL)*1024]
  ## DAC B Side FIFO depth in samples per converter
  set dac_b_fifo_samples_per_converter [expr $ad_project_params(TX_B_KS_PER_CHANNEL)*1024]
}

set SIDE_B_ONLY [ expr { [info exists ad_project_params(SIDE_B_ONLY)] \
                          ? $ad_project_params(SIDE_B_ONLY) : 0 } ]

source $ad_hdl_dir/projects/common/vck190/vck190_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl

if {!$SIDE_B_ONLY} {
  adi_project_files ad9084_ebz_vck190 [list \
    "system_top.v" \
  ]
} else {
  adi_project_files ad9084_ebz_vck190 [list \
    "system_top_side_b_only.v" \
  ]
}

set ADI_PHY_SEL 0
set MAX_NUMBER_OF_QUADS 3
set TRANSCEIVER_TYPE GTY
set EXTERNAL_LINK_CLK 0
set HSCI_BANKS 2
set HSCI_ENABLE [ expr { [info exists ad_project_params(HSCI_ENABLE)] \
                          ? $ad_project_params(HSCI_ENABLE) : 1 } ]

# External data offload storage: one 1 GB slot per offload in the upper half
# of the LPDDR4, which Linux keeps out of the CMA pool
set do_axi_data_width 512
set do_ext_mem_size [expr 1024*1024*1024]
set do_ext_mem_base 0x50100000000

source $ad_hdl_dir/projects/ad9084_ebz/common/ad9084_ebz_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

set link_eff [expr {$JESD_MODE == "8B10B" ? 0.8 : 64.0/66}]
set rx_mbps [expr int(ceil($ad_project_params(RX_LANE_RATE) * 1000 * $RX_NUM_OF_LANES * $link_eff / 8))]
set tx_mbps [expr int(ceil($ad_project_params(TX_LANE_RATE) * 1000 * $TX_NUM_OF_LANES * $link_eff / 8))]

# {offload slot MC read_bw write_bw}: the capture or playback direction gets
# the link rate, the DMA side of the offload only a token reservation; each
# offload shares the MC port of the DMA running the opposite direction
set ext_offloads {}
if {$adc_do_mem_type != 0} {
  lappend ext_offloads [list $adc_data_offload_name 0 MC_2 1000 $rx_mbps]
}
if {$dac_do_mem_type != 0} {
  lappend ext_offloads [list $dac_data_offload_name 1 MC_1 $tx_mbps 1000]
}
if {$ASYMMETRIC_A_B_MODE} {
  set rx_b_mbps [expr int(ceil($ad_project_params(RX_B_LANE_RATE) * 1000 * $RX_B_NUM_OF_LANES * $link_eff / 8))]
  set tx_b_mbps [expr int(ceil($ad_project_params(TX_B_LANE_RATE) * 1000 * $TX_B_NUM_OF_LANES * $link_eff / 8))]
  if {$adc_do_mem_type != 0} {
    lappend ext_offloads [list $adc_b_data_offload_name 2 MC_0 1000 $rx_b_mbps]
  }
  if {$dac_do_mem_type != 0} {
    lappend ext_offloads [list $dac_b_data_offload_name 3 MC_3 $tx_b_mbps 1000]
  }
}

foreach ext_offload $ext_offloads {
  lassign $ext_offload do_name slot p_mc p_rd_bw p_wr_bw

  set base [expr $do_ext_mem_base + $slot * $do_ext_mem_size]
  ad_ip_parameter $do_name/storage_unit CONFIG.DDR_BASE_ADDDRESS [format "0x%016X" $base]

  # The PLM calibrates the DDRMC before the PL is released
  ad_connect VCC $do_name/i_data_offload/ddr_calib_done

  # A top level net cannot be connected to a pin inside the hierarchy
  ad_connect [get_bd_pins -of_objects $sys_dma_clk -filter {DIR == O}] \
    $do_name/storage_unit/m_axi_aclk
  ad_connect [get_bd_pins -of_objects $sys_dma_resetn -filter {DIR == O}] \
    $do_name/storage_unit/m_axi_aresetn
  ad_mem_hp3_interconnect $sys_dma_clk $do_name/storage_unit/MAXI_0
  # The NoC sees the hierarchy pin, not the storage unit's own
  ad_mem_noc_connection $do_name/MAXI_0 $p_mc \
    [expr min(15000, $p_rd_bw)] [expr min(15000, $p_wr_bw)]
}

ad_ip_parameter axi_apollo_rx_jesd/rx CONFIG.NUM_INPUT_PIPELINE 2
ad_ip_parameter axi_apollo_tx_jesd/tx CONFIG.NUM_OUTPUT_PIPELINE 1

if {$ASYMMETRIC_A_B_MODE == 1} {
  ad_ip_parameter axi_apollo_rx_b_jesd/rx CONFIG.NUM_INPUT_PIPELINE 2
  ad_ip_parameter axi_apollo_tx_b_jesd/tx CONFIG.NUM_OUTPUT_PIPELINE 1
}

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

# Second SPI controller
create_bd_port -dir O -from 7 -to 0 apollo_spi_csn_o
create_bd_port -dir I -from 7 -to 0 apollo_spi_csn_i
create_bd_port -dir I apollo_spi_clk_i
create_bd_port -dir O apollo_spi_clk_o
create_bd_port -dir I apollo_spi_sdo_i
create_bd_port -dir O apollo_spi_sdo_o
create_bd_port -dir I apollo_spi_sdi_i

ad_ip_instance axi_quad_spi axi_spi_2
ad_ip_parameter axi_spi_2 CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_2 CONFIG.C_NUM_SS_BITS 8
ad_ip_parameter axi_spi_2 CONFIG.C_SCK_RATIO 16
ad_ip_parameter axi_spi_2 CONFIG.Multiples16 1

ad_connect apollo_spi_csn_i axi_spi_2/ss_i
ad_connect apollo_spi_csn_o axi_spi_2/ss_o
ad_connect apollo_spi_clk_i axi_spi_2/sck_i
ad_connect apollo_spi_clk_o axi_spi_2/sck_o
ad_connect apollo_spi_sdo_i axi_spi_2/io0_i
ad_connect apollo_spi_sdo_o axi_spi_2/io0_o
ad_connect apollo_spi_sdi_i axi_spi_2/io1_i

ad_connect $sys_cpu_clk axi_spi_2/ext_spi_clk

ad_cpu_interrupt ps-9 mb-16 axi_spi_2/ip2intc_irpt

ad_cpu_interconnect 0x44A80000 axi_spi_2

if {$HSCI_ENABLE} {
  set_property range 256K [get_bd_addr_segs {sys_cips/M_AXI_FPD/SEG_data_axi_hsci_0}]
}
