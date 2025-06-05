###############################################################################
## Copyright (C) 2022-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# RX parameters for each converter
set RX_NUM_OF_LANES 16     ; # L
set RX_NUM_OF_CONVERTERS 1 ; # M
set RX_SAMPLES_PER_FRAME 16 ; # S
set RX_SAMPLE_WIDTH 16     ; # N/NP

set RX_SAMPLES_PER_CHANNEL 32 ; # L * 32 / (M * N)

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl
source $ad_hdl_dir/projects/common/xilinx/data_offload_bd.tcl

set adc_offload_name ad9213_data_offload
set adc_data_width 512
set adc_dma_data_width 512

create_bd_port -dir I glbl_clk_0

create_bd_port -dir O -from 1 -to 0 hmc7044_csn_o
create_bd_port -dir I -from 1 -to 0 hmc7044_csn_i
create_bd_port -dir I hmc7044_clk_i
create_bd_port -dir O hmc7044_clk_o
create_bd_port -dir I hmc7044_sdo_i
create_bd_port -dir O hmc7044_sdo_o
create_bd_port -dir I hmc7044_sdi_i

# adc peripherals

ad_ip_instance util_adxcvr util_adc_xcvr
ad_ip_parameter util_adc_xcvr CONFIG.CPLL_FBDIV_4_5 5
ad_ip_parameter util_adc_xcvr CONFIG.TX_NUM_OF_LANES 0
ad_ip_parameter util_adc_xcvr CONFIG.RX_NUM_OF_LANES 16
ad_ip_parameter util_adc_xcvr CONFIG.RX_LANE_INVERT 390
ad_ip_parameter util_adc_xcvr CONFIG.RX_OUT_DIV 1

ad_ip_instance axi_adxcvr axi_ad9213_xcvr
ad_ip_parameter axi_ad9213_xcvr CONFIG.ID 0
ad_ip_parameter axi_ad9213_xcvr CONFIG.NUM_OF_LANES 16
ad_ip_parameter axi_ad9213_xcvr CONFIG.TX_OR_RX_N 0
ad_ip_parameter axi_ad9213_xcvr CONFIG.QPLL_ENABLE 1
ad_ip_parameter axi_ad9213_xcvr CONFIG.LPM_OR_DFE_N 1
ad_ip_parameter axi_ad9213_xcvr CONFIG.SYS_CLK_SEL 0x3

adi_axi_jesd204_rx_create axi_ad9213_jesd 16
ad_ip_parameter axi_ad9213_jesd/rx CONFIG.SYSREF_IOB false
ad_ip_parameter axi_ad9213_jesd/rx CONFIG.NUM_INPUT_PIPELINE 2

adi_tpl_jesd204_rx_create rx_ad9213_tpl_core $RX_NUM_OF_LANES \
                                             $RX_NUM_OF_CONVERTERS \
                                             $RX_SAMPLES_PER_FRAME \
                                             $RX_SAMPLE_WIDTH

ad_data_offload_create $adc_offload_name \
                       0 \
                       $adc_offload_type \
                       $adc_offload_size \
                       $adc_data_width \
                       $adc_dma_data_width

ad_ip_parameter $adc_offload_name/i_data_offload CONFIG.SYNC_EXT_ADD_INTERNAL_CDC 0
ad_connect $adc_offload_name/sync_ext GND

ad_ip_instance axi_dmac axi_ad9213_dma
ad_ip_parameter axi_ad9213_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad9213_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad9213_dma CONFIG.ID 0
ad_ip_parameter axi_ad9213_dma CONFIG.AXI_SLICE_SRC 1
ad_ip_parameter axi_ad9213_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad9213_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad9213_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_ad9213_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9213_dma CONFIG.MAX_BYTES_PER_BURST 4096
ad_ip_parameter axi_ad9213_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad9213_dma CONFIG.DMA_DATA_WIDTH_SRC $adc_dma_data_width
ad_ip_parameter axi_ad9213_dma CONFIG.DMA_DATA_WIDTH_DEST $adc_dma_data_width

# reference clocks & resets

create_bd_port -dir I rx_ref_clk_0
create_bd_port -dir I rx_ref_clk_1

ad_xcvrpll  rx_ref_clk_0 util_adc_xcvr/qpll_ref_clk_0
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/qpll_ref_clk_4
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/qpll_ref_clk_8
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/qpll_ref_clk_12

ad_xcvrpll  rx_ref_clk_0 util_adc_xcvr/cpll_ref_clk_0
ad_xcvrpll  rx_ref_clk_0 util_adc_xcvr/cpll_ref_clk_1
ad_xcvrpll  rx_ref_clk_0 util_adc_xcvr/cpll_ref_clk_2
ad_xcvrpll  rx_ref_clk_0 util_adc_xcvr/cpll_ref_clk_3
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_4
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_5
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_6
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_7
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_8
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_9
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_10
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_11
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_12
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_13
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_14
ad_xcvrpll  rx_ref_clk_1 util_adc_xcvr/cpll_ref_clk_15

ad_xcvrpll  axi_ad9213_xcvr/up_pll_rst util_adc_xcvr/up_qpll_rst_*
ad_xcvrpll  axi_ad9213_xcvr/up_pll_rst util_adc_xcvr/up_cpll_rst_*

ad_connect  $sys_cpu_resetn util_adc_xcvr/up_rstn
ad_connect  $sys_cpu_clk util_adc_xcvr/up_clk

# connections (adc)

ad_xcvrcon util_adc_xcvr axi_ad9213_xcvr axi_ad9213_jesd {4 0 2 1 3 8 9 7 6 11 10 15 12 14 13 5} glbl_clk_0

## use global clock as device clock instead of rx_out_clk
delete_bd_objs [get_bd_nets util_adc_xcvr_rx_out_clk_0]

# connect clocks
# device clock domain
ad_connect  glbl_clk_0 rx_ad9213_tpl_core/link_clk
ad_connect  glbl_clk_0 $adc_offload_name/s_axis_aclk

# dma clock domain
ad_connect  $sys_cpu_clk $adc_offload_name/m_axis_aclk
ad_connect  $sys_cpu_clk axi_ad9213_dma/s_axis_aclk

# connect resets
ad_connect  glbl_clk_0_rstgen/peripheral_aresetn $adc_offload_name/s_axis_aresetn
ad_connect  $sys_cpu_resetn $adc_offload_name/m_axis_aresetn
ad_connect  $sys_cpu_resetn axi_ad9213_dma/m_dest_axi_aresetn

# connect dataflow
ad_connect  axi_ad9213_jesd/rx_sof rx_ad9213_tpl_core/link_sof
ad_connect  axi_ad9213_jesd/rx_data_tdata rx_ad9213_tpl_core/link_data
ad_connect  axi_ad9213_jesd/rx_data_tvalid rx_ad9213_tpl_core/link_valid

ad_connect  rx_ad9213_tpl_core/adc_valid_0 $adc_offload_name/s_axis_tvalid
ad_connect  rx_ad9213_tpl_core/adc_data_0 $adc_offload_name/s_axis_tdata
ad_connect  rx_ad9213_tpl_core/adc_dovf GND

ad_connect  $adc_offload_name/s_axis_tlast GND
ad_connect  $adc_offload_name/s_axis_tkeep VCC

ad_connect  $adc_offload_name/m_axis axi_ad9213_dma/s_axis
ad_connect  $adc_offload_name/init_req axi_ad9213_dma/s_axis_xfer_req

ad_ip_instance axi_quad_spi hmc7044_spi
ad_ip_parameter hmc7044_spi CONFIG.C_USE_STARTUP 0
ad_ip_parameter hmc7044_spi CONFIG.C_NUM_SS_BITS 2
ad_ip_parameter hmc7044_spi CONFIG.C_SCK_RATIO 8

ad_connect hmc7044_csn_i hmc7044_spi/ss_i
ad_connect hmc7044_csn_o hmc7044_spi/ss_o
ad_connect hmc7044_clk_i hmc7044_spi/sck_i
ad_connect hmc7044_clk_o hmc7044_spi/sck_o
ad_connect hmc7044_sdo_i hmc7044_spi/io0_i
ad_connect hmc7044_sdo_o hmc7044_spi/io0_o
ad_connect hmc7044_sdi_i hmc7044_spi/io1_i

ad_connect $sys_cpu_clk hmc7044_spi/ext_spi_clk

# interconnect (cpu)
ad_cpu_interconnect 0x44a60000 axi_ad9213_xcvr
ad_cpu_interconnect 0x44a10000 rx_ad9213_tpl_core
ad_cpu_interconnect 0x44a90000 axi_ad9213_jesd
ad_cpu_interconnect 0x44a71000 hmc7044_spi
ad_cpu_interconnect 0x7c420000 axi_ad9213_dma
ad_cpu_interconnect 0x7c430000 $adc_offload_name

# interconnect (gt/adc)
ad_mem_hp0_interconnect $sys_cpu_clk axi_ad9213_xcvr/m_axi
ad_mem_hp0_interconnect $sys_cpu_clk axi_ad9213_dma/m_dest_axi

# interrupts
ad_cpu_interrupt ps-17 mb-7 hmc7044_spi/ip2intc_irpt
ad_cpu_interrupt ps-12 mb-12 axi_ad9213_dma/irq
ad_cpu_interrupt ps-11 mb-13 axi_ad9213_jesd/irq
