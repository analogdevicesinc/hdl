###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# RX parameters for each converter
set RX_NUM_OF_LANES 16     ; # L
set RX_NUM_OF_CONVERTERS 1 ; # M
set RX_SAMPLES_PER_FRAME 16 ; # S
set RX_SAMPLE_WIDTH 16     ; # N/NP

set RX_SAMPLES_PER_CHANNEL 32 ; # L * 32 / (M * N)

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

set adc_fifo_name axi_ad9213_fifo
set adc_data_width 512
set adc_dma_data_width 512

create_bd_port -dir I glbl_clk_0

create_bd_port -dir O -from 1 -to 0 hmc7044_adf4371_csn_o
create_bd_port -dir I -from 1 -to 0 hmc7044_adf4371_csn_i
create_bd_port -dir I               hmc7044_adf4371_clk_i
create_bd_port -dir O               hmc7044_adf4371_clk_o
create_bd_port -dir I               hmc7044_adf4371_sdo_i
create_bd_port -dir O               hmc7044_adf4371_sdo_o
create_bd_port -dir I               hmc7044_adf4371_sdi_i

create_bd_port -dir O               ad4080_csn_o
create_bd_port -dir I               ad4080_csn_i
create_bd_port -dir I               ad4080_clk_i
create_bd_port -dir O               ad4080_clk_o
create_bd_port -dir O               ad4080_sdo_o
create_bd_port -dir I               ad4080_sdi_i

create_bd_port -dir O               adl5580_csn_o
create_bd_port -dir I               adl5580_csn_i
create_bd_port -dir I               adl5580_clk_i
create_bd_port -dir O               adl5580_clk_o
create_bd_port -dir I               adl5580_sdo_i
create_bd_port -dir O               adl5580_sdo_o
create_bd_port -dir I               adl5580_sdi_i

create_bd_port -dir O               ltc2664_csn_o
create_bd_port -dir I               ltc2664_csn_i
create_bd_port -dir I               ltc2664_clk_i
create_bd_port -dir O               ltc2664_clk_o
create_bd_port -dir O               ltc2664_sdo_o
create_bd_port -dir I               ltc2664_sdi_i

# ad4080 interface

create_bd_port -dir I dco_p
create_bd_port -dir I dco_n
create_bd_port -dir I da_p
create_bd_port -dir I da_n
create_bd_port -dir I db_p
create_bd_port -dir I db_n
create_bd_port -dir I sync_n
create_bd_port -dir I cnv_in_p
create_bd_port -dir I cnv_in_n
create_bd_port -dir I filter_data_ready_n
create_bd_port -dir O sys_cpu_out_clk

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

ad_adcfifo_create $adc_fifo_name $adc_data_width $adc_dma_data_width $adc_fifo_address_width

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

# axi_ad408x

ad_ip_instance axi_ad408x axi_ad4080_adc
ad_ip_parameter axi_ad4080_adc CONFIG.NUM_OF_CHANNELS 1
ad_ip_parameter axi_ad4080_adc CONFIG.HAS_DELAY_CTRL 1
ad_ip_parameter axi_ad4080_adc CONFIG.DELAY_CTRL_NUM_LANES 2

# dma for rx1

ad_ip_instance axi_dmac axi_ad4080_dma
ad_ip_parameter axi_ad4080_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad4080_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad4080_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad4080_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad4080_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad4080_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad4080_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad4080_dma CONFIG.DMA_DATA_WIDTH_SRC 32

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

ad_connect  glbl_clk_0 axi_ad9213_fifo/adc_clk

# dma clock domain
ad_connect  $sys_dma_clk axi_ad9213_fifo/dma_clk
ad_connect  $sys_dma_clk axi_ad9213_dma/s_axis_aclk

# connect resets
ad_connect  glbl_clk_0_rstgen/peripheral_reset axi_ad9213_fifo/adc_rst
ad_connect  $sys_cpu_resetn axi_ad9213_dma/m_dest_axi_aresetn

# connect dataflow
ad_connect  axi_ad9213_jesd/rx_sof rx_ad9213_tpl_core/link_sof
ad_connect  axi_ad9213_jesd/rx_data_tdata rx_ad9213_tpl_core/link_data
ad_connect  axi_ad9213_jesd/rx_data_tvalid rx_ad9213_tpl_core/link_valid

ad_connect rx_ad9213_tpl_core/adc_valid_0 axi_ad9213_fifo/adc_wr
ad_connect rx_ad9213_tpl_core/adc_data_0 axi_ad9213_fifo/adc_wdata

ad_connect rx_ad9213_tpl_core/adc_dovf axi_ad9213_fifo/adc_wovf

ad_connect  axi_ad9213_fifo/dma_wr axi_ad9213_dma/s_axis_valid
ad_connect  axi_ad9213_fifo/dma_wdata axi_ad9213_dma/s_axis_data
ad_connect  axi_ad9213_fifo/dma_wready axi_ad9213_dma/s_axis_ready
ad_connect  axi_ad9213_fifo/dma_xfer_req axi_ad9213_dma/s_axis_xfer_req

ad_ip_instance axi_quad_spi hmc7044_spi
ad_ip_parameter hmc7044_spi CONFIG.C_USE_STARTUP 0
ad_ip_parameter hmc7044_spi CONFIG.C_NUM_SS_BITS 2
ad_ip_parameter hmc7044_spi CONFIG.C_SCK_RATIO 8

ad_connect hmc7044_adf4371_csn_i hmc7044_spi/ss_i
ad_connect hmc7044_adf4371_csn_o hmc7044_spi/ss_o
ad_connect hmc7044_adf4371_clk_i hmc7044_spi/sck_i
ad_connect hmc7044_adf4371_clk_o hmc7044_spi/sck_o
ad_connect hmc7044_adf4371_sdo_i hmc7044_spi/io0_i
ad_connect hmc7044_adf4371_sdo_o hmc7044_spi/io0_o
ad_connect hmc7044_adf4371_sdi_i hmc7044_spi/io1_i

ad_connect $sys_cpu_clk hmc7044_spi/ext_spi_clk

ad_ip_instance axi_quad_spi ad4080_spi
ad_ip_parameter ad4080_spi CONFIG.C_USE_STARTUP 0
ad_ip_parameter ad4080_spi CONFIG.C_NUM_SS_BITS 1
ad_ip_parameter ad4080_spi CONFIG.C_SCK_RATIO 8

ad_connect ad4080_csn_i ad4080_spi/ss_i
ad_connect ad4080_csn_o ad4080_spi/ss_o
ad_connect ad4080_clk_i ad4080_spi/sck_i
ad_connect ad4080_clk_o ad4080_spi/sck_o
ad_connect ad4080_sdo_o ad4080_spi/io0_o
ad_connect ad4080_sdi_i ad4080_spi/io1_i

ad_connect $sys_cpu_clk ad4080_spi/ext_spi_clk

ad_ip_instance axi_quad_spi adl5580_spi
ad_ip_parameter adl5580_spi CONFIG.C_USE_STARTUP 0
ad_ip_parameter adl5580_spi CONFIG.C_NUM_SS_BITS 1
ad_ip_parameter adl5580_spi CONFIG.C_SCK_RATIO 8

ad_connect adl5580_csn_i adl5580_spi/ss_i
ad_connect adl5580_csn_o adl5580_spi/ss_o
ad_connect adl5580_clk_i adl5580_spi/sck_i
ad_connect adl5580_clk_o adl5580_spi/sck_o
ad_connect adl5580_sdo_i adl5580_spi/io0_i
ad_connect adl5580_sdo_o adl5580_spi/io0_o
ad_connect adl5580_sdi_i adl5580_spi/io1_i

ad_connect $sys_cpu_clk adl5580_spi/ext_spi_clk

ad_ip_instance axi_quad_spi ltc2664_spi
ad_ip_parameter ltc2664_spi CONFIG.C_USE_STARTUP 0
ad_ip_parameter ltc2664_spi CONFIG.C_NUM_SS_BITS 1
ad_ip_parameter ltc2664_spi CONFIG.C_SCK_RATIO 8

ad_connect ltc2664_csn_i ltc2664_spi/ss_i
ad_connect ltc2664_csn_o ltc2664_spi/ss_o
ad_connect ltc2664_clk_i ltc2664_spi/sck_i
ad_connect ltc2664_clk_o ltc2664_spi/sck_o
ad_connect ltc2664_sdo_o ltc2664_spi/io0_o
ad_connect ltc2664_sdi_i ltc2664_spi/io1_i

ad_connect $sys_cpu_clk ltc2664_spi/ext_spi_clk

# connect interface to axi_ad4080_adc

ad_connect dco_p                axi_ad4080_adc/dclk_in_p
ad_connect dco_n                axi_ad4080_adc/dclk_in_n
ad_connect da_p                 axi_ad4080_adc/data_a_in_p
ad_connect da_n                 axi_ad4080_adc/data_a_in_n
ad_connect db_p                 axi_ad4080_adc/data_b_in_p
ad_connect db_n                 axi_ad4080_adc/data_b_in_n
ad_connect sync_n               axi_ad4080_adc/sync_n
ad_connect cnv_in_p             axi_ad4080_adc/cnv_in_p
ad_connect cnv_in_n             axi_ad4080_adc/cnv_in_n
ad_connect filter_data_ready_n  axi_ad4080_adc/filter_data_ready_n
ad_connect $sys_iodelay_clk     axi_ad4080_adc/delay_clk

# connect datapath

ad_connect axi_ad4080_adc/adc_data  axi_ad4080_dma/fifo_wr_din
ad_connect axi_ad4080_adc/adc_valid axi_ad4080_dma/fifo_wr_en

# system runs on phy's received clock

ad_connect axi_ad4080_adc/adc_clk axi_ad4080_dma/fifo_wr_clk
ad_connect $sys_cpu_clk sys_cpu_out_clk

ad_connect $sys_cpu_resetn axi_ad4080_dma/m_dest_axi_aresetn

# interconnect (cpu)
ad_cpu_interconnect 0x44A60000 axi_ad9213_xcvr
ad_cpu_interconnect 0x44A10000 rx_ad9213_tpl_core
ad_cpu_interconnect 0x44A90000 axi_ad9213_jesd
ad_cpu_interconnect 0x44A71000 hmc7044_spi
ad_cpu_interconnect 0x44A72000 ad4080_spi
ad_cpu_interconnect 0x44A73000 adl5580_spi
ad_cpu_interconnect 0x44A74000 ltc2664_spi
ad_cpu_interconnect 0x44A00000 axi_ad4080_adc
ad_cpu_interconnect 0x44A30000 axi_ad4080_dma
ad_cpu_interconnect 0x44B00000 axi_ad9213_dma

# interconnect (gt/adc)
ad_mem_hp0_interconnect $sys_cpu_clk axi_ad9213_xcvr/m_axi
ad_mem_hp0_interconnect $sys_cpu_clk axi_ad9213_dma/m_dest_axi
ad_mem_hp0_interconnect $sys_cpu_clk axi_ad4080_dma/m_dest_axi

# interrupts
ad_cpu_interrupt ps-17 mb-7 hmc7044_spi/ip2intc_irpt
ad_cpu_interrupt ps-16 mb-8 ad4080_spi/ip2intc_irpt
ad_cpu_interrupt ps-15 mb-9 adl5580_spi/ip2intc_irpt
ad_cpu_interrupt ps-14 mb-10 axi_ad4080_dma/irq
ad_cpu_interrupt ps-12 mb-12 axi_ad9213_dma/irq
ad_cpu_interrupt ps-11 mb-13 axi_ad9213_jesd/irq
ad_cpu_interrupt ps-10 mb-14 ltc2664_spi/ip2intc_irpt
