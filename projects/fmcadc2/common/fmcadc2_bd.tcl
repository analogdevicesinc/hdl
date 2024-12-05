###############################################################################
## Copyright (C) 2014-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

#
# Parameter description:
#   RX_JESD_M : Number of converters per link
#   RX_JESD_L : Number of lanes per link
#   RX_JESD_S : Number of samples per frame
#   RX_JESD_NP : Number of bits per sample
#

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl
source $ad_hdl_dir/projects/common/xilinx/data_offload_bd.tcl

# JESD204B interface configuration parameters
set RX_NUM_OF_LANES  $ad_project_params(RX_JESD_L)
set RX_NUM_OF_CONVERTERS  $ad_project_params(RX_JESD_M)
set RX_SAMPLES_PER_FRAME  $ad_project_params(RX_JESD_S)
set RX_SAMPLE_WIDTH  $ad_project_params(RX_JESD_NP)

set adc_offload_name ad9625_data_offload
set adc_data_width [expr 32*$RX_NUM_OF_LANES]
set adc_dma_data_width 64

# adc peripherals

adi_tpl_jesd204_rx_create axi_ad9625_core $RX_NUM_OF_LANES \
                                          $RX_NUM_OF_CONVERTERS \
                                          $RX_SAMPLES_PER_FRAME \
                                          $RX_SAMPLE_WIDTH \

adi_axi_jesd204_rx_create axi_ad9625_jesd $RX_NUM_OF_LANES

ad_ip_instance axi_adxcvr axi_ad9625_xcvr
ad_ip_parameter axi_ad9625_xcvr CONFIG.NUM_OF_LANES $RX_NUM_OF_LANES
ad_ip_parameter axi_ad9625_xcvr CONFIG.QPLL_ENABLE 0
ad_ip_parameter axi_ad9625_xcvr CONFIG.TX_OR_RX_N 0
ad_ip_parameter axi_ad9625_xcvr CONFIG.LPM_OR_DFE_N 1
ad_ip_parameter axi_ad9625_xcvr CONFIG.SYS_CLK_SEL 0
ad_ip_parameter axi_ad9625_xcvr CONFIG.OUT_CLK_SEL 2

ad_ip_instance axi_dmac axi_ad9625_dma
ad_ip_parameter axi_ad9625_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad9625_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad9625_dma CONFIG.ID 0
ad_ip_parameter axi_ad9625_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9625_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9625_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad9625_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_ad9625_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9625_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad9625_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter axi_ad9625_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_ip_instance util_cpack2 util_ad9625_cpack [list \
  NUM_OF_CHANNELS $RX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $RX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $RX_SAMPLE_WIDTH \
]

ad_data_offload_create $adc_offload_name \
                       0 \
                       $adc_offload_type \
                       $adc_offload_size \
                       $adc_data_width \
                       $adc_dma_data_width \
                       $plddr_offload_axi_data_width

ad_ip_parameter $adc_offload_name/i_data_offload CONFIG.SYNC_EXT_ADD_INTERNAL_CDC 0
ad_connect $adc_offload_name/sync_ext GND

ad_ip_instance util_adxcvr util_fmcadc2_xcvr
ad_ip_parameter util_fmcadc2_xcvr CONFIG.QPLL_FBDIV 0x80 ;# N = 40
ad_ip_parameter util_fmcadc2_xcvr CONFIG.CPLL_FBDIV 1
ad_ip_parameter util_fmcadc2_xcvr CONFIG.TX_NUM_OF_LANES 0
ad_ip_parameter util_fmcadc2_xcvr CONFIG.RX_NUM_OF_LANES $RX_NUM_OF_LANES
ad_ip_parameter util_fmcadc2_xcvr CONFIG.RX_OUT_DIV 1
ad_ip_parameter util_fmcadc2_xcvr CONFIG.RX_CLK25_DIV 25
ad_ip_parameter util_fmcadc2_xcvr CONFIG.RX_DFE_LPM_CFG 0x0904
ad_ip_parameter util_fmcadc2_xcvr CONFIG.RX_CDR_CFG 0x03000023ff20400020 ;# DFE mode refclk +-200

# reference clocks & resets

create_bd_port -dir I rx_ref_clk_0
create_bd_port -dir O rx_core_clk

ad_xcvrpll  rx_ref_clk_0 util_fmcadc2_xcvr/qpll_ref_clk_*
ad_xcvrpll  rx_ref_clk_0 util_fmcadc2_xcvr/cpll_ref_clk_*
ad_xcvrpll  axi_ad9625_xcvr/up_pll_rst util_fmcadc2_xcvr/up_qpll_rst_*
ad_xcvrpll  axi_ad9625_xcvr/up_pll_rst util_fmcadc2_xcvr/up_cpll_rst_*
ad_connect  $sys_cpu_resetn util_fmcadc2_xcvr/up_rstn
ad_connect  $sys_cpu_clk util_fmcadc2_xcvr/up_clk

# connections (adc)

ad_xcvrcon  util_fmcadc2_xcvr axi_ad9625_xcvr axi_ad9625_jesd
ad_connect  util_fmcadc2_xcvr/rx_out_clk_0 axi_ad9625_core/link_clk
ad_connect  rx_core_clk util_fmcadc2_xcvr/rx_out_clk_0
ad_connect  axi_ad9625_jesd/rx_data_tdata axi_ad9625_core/link_data
ad_connect  axi_ad9625_jesd/rx_sof axi_ad9625_core/link_sof
ad_connect  axi_ad9625_jesd/rx_data_tvalid axi_ad9625_core/link_valid

ad_connect  $sys_cpu_clk $adc_offload_name/m_axis_aclk
ad_connect  $sys_cpu_clk axi_ad9625_dma/s_axis_aclk

ad_connect  axi_ad9625_jesd_rstgen/peripheral_reset cpack_reset_logic/op1
ad_connect  rx_do_rstout_logic/res cpack_reset_logic/op2
ad_connect  cpack_reset_logic/res util_ad9625_cpack/reset
ad_connect  $sys_cpu_resetn $adc_offload_name/m_axis_aresetn
ad_connect  $sys_cpu_resetn axi_ad9625_dma/m_dest_axi_aresetn

ad_connect  axi_ad9625_core/link_clk $adc_offload_name/s_axis_aclk
ad_connect  axi_ad9625_jesd_rstgen/peripheral_aresetn $adc_offload_name/s_axis_aresetn
ad_connect  axi_ad9625_core/adc_valid_0 util_ad9625_cpack/fifo_wr_en
ad_connect  axi_ad9625_core/adc_enable_0 util_ad9625_cpack/enable_0
ad_connect  axi_ad9625_core/adc_data_0 util_ad9625_cpack/fifo_wr_data_0
ad_connect  axi_ad9625_core/adc_dovf util_ad9625_cpack/fifo_wr_overflow

ad_connect  util_ad9625_cpack/packed_fifo_wr_data $adc_offload_name/s_axis_tdata
ad_connect  util_ad9625_cpack/packed_fifo_wr_en $adc_offload_name/s_axis_tvalid
ad_connect  $adc_offload_name/s_axis_tlast GND
ad_connect  $adc_offload_name/s_axis_tkeep VCC
ad_connect  $adc_offload_name/s_axis_tready rx_do_rstout_logic/op1

ad_connect  $adc_offload_name/m_axis axi_ad9625_dma/s_axis
ad_connect  $adc_offload_name/init_req axi_ad9625_dma/s_axis_xfer_req

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 axi_ad9625_xcvr
ad_cpu_interconnect 0x44A10000 axi_ad9625_core
ad_cpu_interconnect 0x44AA0000 axi_ad9625_jesd
ad_cpu_interconnect 0x7c420000 axi_ad9625_dma
ad_cpu_interconnect 0x7c430000 $adc_offload_name

# gt uses hp3, and 100MHz clock for both DRP and AXI4

ad_mem_hp3_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect $sys_cpu_clk axi_ad9625_xcvr/m_axi

# interconnect (mem/adc)

ad_mem_hp2_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_cpu_clk axi_ad9625_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-12 mb-13 axi_ad9625_jesd/irq
ad_cpu_interrupt ps-13 mb-12 axi_ad9625_dma/irq

# Create dummy outputs for unused Rx lanes
for {set i $RX_NUM_OF_LANES} {$i < 8} {incr i} {
    create_bd_port -dir I rx_data_${i}_n
    create_bd_port -dir I rx_data_${i}_p
}
