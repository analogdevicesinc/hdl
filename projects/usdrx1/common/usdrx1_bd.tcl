
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

ad_ip_instance axi_ad9671 axi_ad9671_core_0
ad_ip_parameter axi_ad9671_core_0 CONFIG.QUAD_OR_DUAL_N 0
ad_ip_parameter axi_ad9671_core_0 CONFIG.ID 0

ad_ip_instance axi_ad9671 axi_ad9671_core_1
ad_ip_parameter axi_ad9671_core_1 CONFIG.QUAD_OR_DUAL_N 0
ad_ip_parameter axi_ad9671_core_1 CONFIG.ID 1

ad_ip_instance axi_ad9671 axi_ad9671_core_2
ad_ip_parameter axi_ad9671_core_2 CONFIG.QUAD_OR_DUAL_N 0
ad_ip_parameter axi_ad9671_core_2 CONFIG.ID 2

ad_ip_instance axi_ad9671 axi_ad9671_core_3
ad_ip_parameter axi_ad9671_core_3 CONFIG.QUAD_OR_DUAL_N 0
ad_ip_parameter axi_ad9671_core_3 CONFIG.ID 3

ad_ip_instance jesd204 axi_usdrx1_jesd
ad_ip_parameter axi_usdrx1_jesd CONFIG.C_NODE_IS_TRANSMIT 0
ad_ip_parameter axi_usdrx1_jesd CONFIG.C_LANES 8
ad_ip_parameter axi_usdrx1_jesd CONFIG.GT_Line_Rate 3.2
ad_ip_parameter axi_usdrx1_jesd CONFIG.GT_REFCLK_FREQ 80.000

ad_ip_instance axi_adxcvr axi_usdrx1_xcvr
ad_ip_parameter axi_usdrx1_xcvr CONFIG.NUM_OF_LANES 8
ad_ip_parameter axi_usdrx1_xcvr CONFIG.QPLL_ENABLE 0
ad_ip_parameter axi_usdrx1_xcvr CONFIG.TX_OR_RX_N 0

ad_ip_instance util_adxcvr util_usdrx1_xcvr
ad_ip_parameter util_usdrx1_xcvr CONFIG.RX_NUM_OF_LANES 8
ad_ip_parameter util_usdrx1_xcvr CONFIG.TX_NUM_OF_LANES 0
ad_ip_parameter util_usdrx1_xcvr CONFIG.CPLL_FBDIV 4
ad_ip_parameter util_usdrx1_xcvr CONFIG.RX_CLK25_DIV 3
ad_ip_parameter util_usdrx1_xcvr CONFIG.RX_DFE_LPM_CFG 0x0954
ad_ip_parameter util_usdrx1_xcvr CONFIG.RX_PMA_CFG 0x00018480
ad_ip_parameter util_usdrx1_xcvr CONFIG.RX_CDR_CFG 0x03000023FF20400020

ad_ip_instance axi_dmac axi_usdrx1_dma
ad_ip_parameter axi_usdrx1_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_usdrx1_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_usdrx1_dma CONFIG.ID 0
ad_ip_parameter axi_usdrx1_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_usdrx1_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_usdrx1_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_usdrx1_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_usdrx1_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_usdrx1_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_usdrx1_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter axi_usdrx1_dma CONFIG.DMA_DATA_WIDTH_DEST 64
ad_ip_parameter axi_usdrx1_dma CONFIG.FIFO_SIZE 8

ad_ip_instance axi_quad_spi axi_usdrx1_spi
ad_ip_parameter axi_usdrx1_spi CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_usdrx1_spi CONFIG.C_NUM_SS_BITS 5
ad_ip_parameter axi_usdrx1_spi CONFIG.C_SCK_RATIO 8

ad_ip_instance xlslice data_slice_0
ad_ip_parameter data_slice_0 CONFIG.DIN_WIDTH 256
ad_ip_parameter data_slice_0 CONFIG.DIN_TO 0
ad_ip_parameter data_slice_0 CONFIG.DIN_FROM 63
ad_ip_parameter data_slice_0 CONFIG.DOUT_WIDTH 64

ad_ip_instance xlslice data_slice_1
ad_ip_parameter data_slice_1 CONFIG.DIN_WIDTH 256
ad_ip_parameter data_slice_1 CONFIG.DIN_TO 64
ad_ip_parameter data_slice_1 CONFIG.DIN_FROM 127
ad_ip_parameter data_slice_1 CONFIG.DOUT_WIDTH 64

ad_ip_instance xlslice data_slice_2
ad_ip_parameter data_slice_2 CONFIG.DIN_WIDTH 256
ad_ip_parameter data_slice_2 CONFIG.DIN_TO 128
ad_ip_parameter data_slice_2 CONFIG.DIN_FROM 191
ad_ip_parameter data_slice_2 CONFIG.DOUT_WIDTH 64

ad_ip_instance xlslice data_slice_3
ad_ip_parameter data_slice_3 CONFIG.DIN_WIDTH 256
ad_ip_parameter data_slice_3 CONFIG.DIN_TO 192
ad_ip_parameter data_slice_3 CONFIG.DIN_FROM 255
ad_ip_parameter data_slice_3 CONFIG.DOUT_WIDTH 64

ad_ip_instance xlconcat adc_data_concat
ad_ip_parameter adc_data_concat CONFIG.NUM_PORTS 4

ad_ip_instance xlconcat adc_valid_concat
ad_ip_parameter adc_valid_concat CONFIG.NUM_PORTS 4

ad_ip_instance util_reduced_logic adc_valid_reduced_or
ad_ip_parameter adc_valid_reduced_or CONFIG.C_SIZE 32
ad_ip_parameter adc_valid_reduced_or CONFIG.C_OPERATION or

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

ad_ip_instance ila ila_ad9671
ad_ip_parameter ila_ad9671 CONFIG.C_MONITOR_TYPE Native
ad_ip_parameter ila_ad9671 CONFIG.C_NUM_OF_PROBES 9
ad_ip_parameter ila_ad9671 CONFIG.C_PROBE0_WIDTH 128
ad_ip_parameter ila_ad9671 CONFIG.C_PROBE1_WIDTH 8
ad_ip_parameter ila_ad9671 CONFIG.C_PROBE2_WIDTH 128
ad_ip_parameter ila_ad9671 CONFIG.C_PROBE3_WIDTH 8
ad_ip_parameter ila_ad9671 CONFIG.C_PROBE4_WIDTH 128
ad_ip_parameter ila_ad9671 CONFIG.C_PROBE5_WIDTH 8
ad_ip_parameter ila_ad9671 CONFIG.C_PROBE6_WIDTH 128
ad_ip_parameter ila_ad9671 CONFIG.C_PROBE7_WIDTH 8
ad_ip_parameter ila_ad9671 CONFIG.C_PROBE8_WIDTH 1
ad_ip_parameter ila_ad9671 CONFIG.C_EN_STRG_QUAL 1

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
