
# usdrx1

create_bd_port -dir I -from 4 -to 0 spi_csn_i
create_bd_port -dir O -from 4 -to 0 spi_csn_o
create_bd_port -dir I spi_clk_i
create_bd_port -dir O spi_clk_o
create_bd_port -dir I spi_sdo_i
create_bd_port -dir O spi_sdo_o
create_bd_port -dir I spi_sdi_i
create_bd_port -dir O rx_core_clk

# adc peripherals

set axi_ad9671_core_0 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9671:1.0 axi_ad9671_core_0]
set_property -dict [list CONFIG.QUAD_OR_DUAL_N {0}] $axi_ad9671_core_0
set_property -dict [list CONFIG.ID {0}] $axi_ad9671_core_0

set axi_ad9671_core_1 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9671:1.0 axi_ad9671_core_1]
set_property -dict [list CONFIG.QUAD_OR_DUAL_N {0}] $axi_ad9671_core_1
set_property -dict [list CONFIG.ID {1}] $axi_ad9671_core_1

set axi_ad9671_core_2 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9671:1.0 axi_ad9671_core_2]
set_property -dict [list CONFIG.QUAD_OR_DUAL_N {0}] $axi_ad9671_core_2
set_property -dict [list CONFIG.ID {2}] $axi_ad9671_core_2

set axi_ad9671_core_3 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9671:1.0 axi_ad9671_core_3]
set_property -dict [list CONFIG.QUAD_OR_DUAL_N {0}] $axi_ad9671_core_3
set_property -dict [list CONFIG.ID {3}] $axi_ad9671_core_3

set axi_usdrx1_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:7.0 axi_usdrx1_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_usdrx1_jesd
set_property -dict [list CONFIG.C_LANES {8}] $axi_usdrx1_jesd
set_property -dict [list CONFIG.GT_Line_Rate {3.2}  ] $axi_usdrx1_jesd
set_property -dict [list CONFIG.GT_REFCLK_FREQ {80.000} ]  $axi_usdrx1_jesd

set axi_usdrx1_xcvr [create_bd_cell -type ip -vlnv analog.com:user:axi_adxcvr:1.0 axi_usdrx1_xcvr]
set_property -dict [list CONFIG.NUM_OF_LANES {8}] $axi_usdrx1_xcvr
set_property -dict [list CONFIG.QPLL_ENABLE {0}] $axi_usdrx1_xcvr
set_property -dict [list CONFIG.TX_OR_RX_N {0}] $axi_usdrx1_xcvr

set util_usdrx1_xcvr [create_bd_cell -type ip -vlnv analog.com:user:util_adxcvr:1.0 util_usdrx1_xcvr]
set_property -dict [list CONFIG.RX_NUM_OF_LANES {8}] $util_usdrx1_xcvr
set_property -dict [list CONFIG.TX_NUM_OF_LANES {0}] $util_usdrx1_xcvr
set_property -dict [list CONFIG.CPLL_FBDIV {4}] $util_usdrx1_xcvr
set_property -dict [list CONFIG.RX_CLK25_DIV {3}] $util_usdrx1_xcvr
set_property -dict [list CONFIG.RX_DFE_LPM_CFG {0x0954}] $util_usdrx1_xcvr
set_property -dict [list CONFIG.RX_PMA_CFG {0x00018480}] $util_usdrx1_xcvr
set_property -dict [list CONFIG.RX_CDR_CFG {0x03000023FF20400020}] $util_usdrx1_xcvr


set axi_usdrx1_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_usdrx1_dma]
set_property -dict [list CONFIG.DMA_TYPE_SRC {1}] $axi_usdrx1_dma
set_property -dict [list CONFIG.DMA_TYPE_DEST {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.ID {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.AXI_SLICE_SRC {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.AXI_SLICE_DEST {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.SYNC_TRANSFER_START {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.DMA_LENGTH_WIDTH {24}] $axi_usdrx1_dma
set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.CYCLIC {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {64}] $axi_usdrx1_dma
set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {64}] $axi_usdrx1_dma
set_property -dict [list CONFIG.FIFO_SIZE {8}] $axi_usdrx1_dma

set axi_usdrx1_spi [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_usdrx1_spi]
set_property -dict [list CONFIG.C_USE_STARTUP {0}] $axi_usdrx1_spi
set_property -dict [list CONFIG.C_NUM_SS_BITS {5}] $axi_usdrx1_spi
set_property -dict [list CONFIG.C_SCK_RATIO {8}] $axi_usdrx1_spi

set data_slice_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 data_slice_0]
set_property -dict [list CONFIG.DIN_WIDTH {256}] $data_slice_0
set_property -dict [list CONFIG.DIN_TO {0}] $data_slice_0
set_property -dict [list CONFIG.DIN_FROM {63}] $data_slice_0
set_property -dict [list CONFIG.DOUT_WIDTH {64}] $data_slice_0

set data_slice_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 data_slice_1]
set_property -dict [list CONFIG.DIN_WIDTH {256}] $data_slice_1
set_property -dict [list CONFIG.DIN_TO {64}] $data_slice_1
set_property -dict [list CONFIG.DIN_FROM {127}] $data_slice_1
set_property -dict [list CONFIG.DOUT_WIDTH {64}] $data_slice_1

set data_slice_2 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 data_slice_2]
set_property -dict [list CONFIG.DIN_WIDTH {256}] $data_slice_2
set_property -dict [list CONFIG.DIN_TO {128}] $data_slice_2
set_property -dict [list CONFIG.DIN_FROM {191}] $data_slice_2
set_property -dict [list CONFIG.DOUT_WIDTH {64}] $data_slice_2

set data_slice_3 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 data_slice_3]
set_property -dict [list CONFIG.DIN_WIDTH {256}] $data_slice_3
set_property -dict [list CONFIG.DIN_TO {192}] $data_slice_3
set_property -dict [list CONFIG.DIN_FROM {255}] $data_slice_3
set_property -dict [list CONFIG.DOUT_WIDTH {64}] $data_slice_3

set adc_data_concat [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 adc_data_concat]
set_property -dict [list CONFIG.NUM_PORTS {4}] $adc_data_concat

set adc_valid_concat [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 adc_valid_concat]
set_property -dict [list CONFIG.NUM_PORTS {4}] $adc_valid_concat

set adc_valid_reduced_or [create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 adc_valid_reduced_or]
set_property -dict [list CONFIG.C_SIZE {32}] $adc_valid_reduced_or
set_property -dict [list CONFIG.C_OPERATION {or} ] $adc_valid_reduced_or

# connections (spi)

ad_connect  spi_csn_i   axi_usdrx1_spi/ss_i
ad_connect  spi_csn_o   axi_usdrx1_spi/ss_o
ad_connect  spi_clk_i   axi_usdrx1_spi/sck_i
ad_connect  spi_clk_o   axi_usdrx1_spi/sck_o
ad_connect  spi_sdo_i   axi_usdrx1_spi/io0_i
ad_connect  spi_sdo_o   axi_usdrx1_spi/io0_o
ad_connect  spi_sdi_i   axi_usdrx1_spi/io1_i
ad_connect  sys_cpu_clk axi_usdrx1_spi/ext_spi_clk

ad_connect  sys_cpu_resetn util_usdrx1_xcvr/up_rstn
ad_connect  sys_cpu_clk util_usdrx1_xcvr/up_clk

# connections (adc)

create_bd_port -dir I rx_ref_clk_0

ad_xcvrpll  rx_ref_clk_0 util_usdrx1_xcvr/cpll_ref_clk_*
ad_xcvrpll  rx_ref_clk_0 util_usdrx1_xcvr/qpll_ref_clk_*
ad_xcvrpll  axi_usdrx1_xcvr/up_pll_rst util_usdrx1_xcvr/up_cpll_rst_*
ad_xcvrpll  axi_usdrx1_xcvr/up_pll_rst util_usdrx1_xcvr/up_qpll_rst_*

ad_xcvrcon  util_usdrx1_xcvr axi_usdrx1_xcvr axi_usdrx1_jesd
ad_connect  util_usdrx1_xcvr/rx_out_clk_0 axi_ad9671_core_0/rx_clk
ad_connect  util_usdrx1_xcvr/rx_out_clk_0 axi_ad9671_core_1/rx_clk
ad_connect  util_usdrx1_xcvr/rx_out_clk_0 axi_ad9671_core_2/rx_clk
ad_connect  util_usdrx1_xcvr/rx_out_clk_0 axi_ad9671_core_3/rx_clk
ad_connect  util_usdrx1_xcvr/rx_out_clk_0 rx_core_clk
ad_connect  axi_usdrx1_jesd/rx_start_of_frame axi_ad9671_core_0/rx_sof
ad_connect  axi_usdrx1_jesd/rx_start_of_frame axi_ad9671_core_1/rx_sof
ad_connect  axi_usdrx1_jesd/rx_start_of_frame axi_ad9671_core_2/rx_sof
ad_connect  axi_usdrx1_jesd/rx_start_of_frame axi_ad9671_core_3/rx_sof

ad_connect  axi_usdrx1_jesd/rx_tdata data_slice_0/Din
ad_connect  axi_usdrx1_jesd/rx_tdata data_slice_1/Din
ad_connect  axi_usdrx1_jesd/rx_tdata data_slice_2/Din
ad_connect  axi_usdrx1_jesd/rx_tdata data_slice_3/Din

ad_connect  data_slice_0/Dout axi_ad9671_core_0/rx_data
ad_connect  data_slice_1/Dout axi_ad9671_core_1/rx_data
ad_connect  data_slice_2/Dout axi_ad9671_core_2/rx_data
ad_connect  data_slice_3/Dout axi_ad9671_core_3/rx_data

ad_connect util_usdrx1_xcvr/rx_out_clk_0    usdrx1_fifo/adc_clk
ad_connect adc_data_concat/In0 axi_ad9671_core_0/adc_data
ad_connect adc_data_concat/In1 axi_ad9671_core_1/adc_data
ad_connect adc_data_concat/In2 axi_ad9671_core_2/adc_data
ad_connect adc_data_concat/In3 axi_ad9671_core_3/adc_data
ad_connect adc_valid_concat/In0 axi_ad9671_core_0/adc_valid
ad_connect adc_valid_concat/In1 axi_ad9671_core_1/adc_valid
ad_connect adc_valid_concat/In2 axi_ad9671_core_2/adc_valid
ad_connect adc_valid_concat/In3 axi_ad9671_core_3/adc_valid
ad_connect adc_valid_concat/dout adc_valid_reduced_or/Op1

ad_connect usdrx1_fifo/adc_wovf             axi_ad9671_core_0/adc_dovf
ad_connect usdrx1_fifo/adc_wovf             axi_ad9671_core_1/adc_dovf
ad_connect usdrx1_fifo/adc_wovf             axi_ad9671_core_2/adc_dovf
ad_connect usdrx1_fifo/adc_wovf             axi_ad9671_core_3/adc_dovf
ad_connect adc_valid_reduced_or/Res         usdrx1_fifo/adc_wr
ad_connect adc_data_concat/dout             usdrx1_fifo/adc_wdata
ad_connect axi_ad9671_adc_raddr             axi_ad9671_core_0/adc_raddr_out
ad_connect axi_ad9671_adc_raddr             axi_ad9671_core_1/adc_raddr_in
ad_connect axi_ad9671_adc_raddr             axi_ad9671_core_2/adc_raddr_in
ad_connect axi_ad9671_adc_raddr             axi_ad9671_core_3/adc_raddr_in
ad_connect axi_ad9671_adc_sync              axi_ad9671_core_0/adc_sync_out
ad_connect axi_ad9671_adc_sync              axi_ad9671_core_1/adc_sync_in
ad_connect axi_ad9671_adc_sync              axi_ad9671_core_2/adc_sync_in
ad_connect axi_ad9671_adc_sync              axi_ad9671_core_3/adc_sync_in

ad_connect axi_usdrx1_jesd_rstgen/peripheral_reset   usdrx1_fifo/adc_rst

ad_connect usdrx1_fifo/dma_wdata            axi_usdrx1_dma/s_axis_data
ad_connect usdrx1_fifo/dma_wr               axi_usdrx1_dma/s_axis_valid
ad_connect usdrx1_fifo/dma_wready           axi_usdrx1_dma/s_axis_ready
ad_connect usdrx1_fifo/dma_xfer_req         axi_usdrx1_dma/s_axis_xfer_req
ad_connect sys_200m_clk                     axi_usdrx1_dma/s_axis_aclk
ad_connect sys_200m_clk                     usdrx1_fifo/dma_clk

# address map

ad_cpu_interconnect  0x44A00000 axi_ad9671_core_0
ad_cpu_interconnect  0x44A10000 axi_ad9671_core_1
ad_cpu_interconnect  0x44A20000 axi_ad9671_core_2
ad_cpu_interconnect  0x44A30000 axi_ad9671_core_3

ad_cpu_interconnect  0x44A60000 axi_usdrx1_xcvr
ad_cpu_interconnect  0x44A91000 axi_usdrx1_jesd
ad_cpu_interconnect  0x7c400000 axi_usdrx1_dma
ad_cpu_interconnect  0x7c420000 axi_usdrx1_spi

ad_mem_hp2_interconnect sys_200m_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_200m_clk axi_usdrx1_dma/m_dest_axi
ad_connect sys_cpu_resetn axi_usdrx1_dma/m_dest_axi_aresetn

ad_mem_hp3_interconnect sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_cpu_clk axi_usdrx1_xcvr/m_axi

#interrupts

ad_cpu_interrupt ps-12 mb-12 axi_usdrx1_spi/ip2intc_irpt
ad_cpu_interrupt ps-13 mb-13 axi_usdrx1_dma/irq

# ila

set ila_ad9671 [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.1 ila_ad9671]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_ad9671
set_property -dict [list CONFIG.C_NUM_OF_PROBES {9}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE0_WIDTH {128}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE1_WIDTH {8}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE2_WIDTH {128}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE3_WIDTH {8}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE4_WIDTH {128}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE5_WIDTH {8}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE6_WIDTH {128}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE7_WIDTH {8}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE8_WIDTH {1}] $ila_ad9671
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_ad9671

ad_connect axi_ad9671_core_0/adc_clk  ila_ad9671/CLK
ad_connect axi_ad9671_core_0/adc_data   ila_ad9671/PROBE0
ad_connect axi_ad9671_core_0/adc_valid  ila_ad9671/PROBE1
ad_connect axi_ad9671_core_1/adc_data   ila_ad9671/PROBE2
ad_connect axi_ad9671_core_1/adc_valid  ila_ad9671/PROBE3
ad_connect axi_ad9671_core_2/adc_data   ila_ad9671/PROBE4
ad_connect axi_ad9671_core_2/adc_valid  ila_ad9671/PROBE5
ad_connect axi_ad9671_core_3/adc_data   ila_ad9671/PROBE6
ad_connect axi_ad9671_core_3/adc_valid  ila_ad9671/PROBE7
ad_connect usdrx1_fifo/adc_wovf         ila_ad9671/PROBE8
