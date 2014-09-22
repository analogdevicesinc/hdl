
# usdrx1

set spi_csn_i       [create_bd_port -dir I -from 4 -to 0 spi_csn_i]
set spi_csn_o       [create_bd_port -dir O -from 4 -to 0 spi_csn_o]
set spi_clk_i       [create_bd_port -dir I spi_clk_i]
set spi_clk_o       [create_bd_port -dir O spi_clk_o]
set spi_sdo_i       [create_bd_port -dir I spi_sdo_i]
set spi_sdo_o       [create_bd_port -dir O spi_sdo_o]
set spi_sdi_i       [create_bd_port -dir I spi_sdi_i]

set rx_ref_clk      [create_bd_port -dir I rx_ref_clk]
set rx_sync         [create_bd_port -dir O rx_sync]
set rx_sysref       [create_bd_port -dir O rx_sysref]
set rx_data_p       [create_bd_port -dir I -from 7 -to 0 rx_data_p]
set rx_data_n       [create_bd_port -dir I -from 7 -to 0 rx_data_n]

set gt_rx_data      [create_bd_port -dir O -from 255 -to 0 gt_rx_data]
set gt_rx_data_0    [create_bd_port -dir I -from 63 -to 0 gt_rx_data_0]
set gt_rx_data_1    [create_bd_port -dir I -from 63 -to 0 gt_rx_data_1]
set gt_rx_data_2    [create_bd_port -dir I -from 63 -to 0 gt_rx_data_2]
set gt_rx_data_3    [create_bd_port -dir I -from 63 -to 0 gt_rx_data_3]
set adc_data_0      [create_bd_port -dir O -from 127 -to 0 adc_data_0]
set adc_data_1      [create_bd_port -dir O -from 127 -to 0 adc_data_1]
set adc_data_2      [create_bd_port -dir O -from 127 -to 0 adc_data_2]
set adc_data_3      [create_bd_port -dir O -from 127 -to 0 adc_data_3]
set adc_valid_0     [create_bd_port -dir O -from 7 -to 0 adc_valid_0]
set adc_valid_1     [create_bd_port -dir O -from 7 -to 0 adc_valid_1]
set adc_valid_2     [create_bd_port -dir O -from 7 -to 0 adc_valid_2]
set adc_valid_3     [create_bd_port -dir O -from 7 -to 0 adc_valid_3]
set adc_enable_0    [create_bd_port -dir O -from 7 -to 0 adc_enable_0]
set adc_enable_1    [create_bd_port -dir O -from 7 -to 0 adc_enable_1]
set adc_enable_2    [create_bd_port -dir O -from 7 -to 0 adc_enable_2]
set adc_enable_3    [create_bd_port -dir O -from 7 -to 0 adc_enable_3]
set adc_dovf_0      [create_bd_port -dir I adc_dovf_0]
set adc_dovf_1      [create_bd_port -dir I adc_dovf_1]
set adc_dovf_2      [create_bd_port -dir I adc_dovf_2]
set adc_dovf_3      [create_bd_port -dir I adc_dovf_3]
set adc_data       [create_bd_port -dir I -from 511 -to 0 adc_data]
set adc_wr_en       [create_bd_port -dir I adc_wr_en]
set adc_dovf        [create_bd_port -dir O adc_dovf]

# adc peripherals

set axi_ad9671_core_0 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9671:1.0 axi_ad9671_core_0]
set_property -dict [list CONFIG.PCORE_4L_2L_N {0}] [get_bd_cells axi_ad9671_core_0]

set axi_ad9671_core_1 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9671:1.0 axi_ad9671_core_1]
set_property -dict [list CONFIG.PCORE_4L_2L_N {0}] [get_bd_cells axi_ad9671_core_1]

set axi_ad9671_core_2 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9671:1.0 axi_ad9671_core_2]
set_property -dict [list CONFIG.PCORE_4L_2L_N {0}] [get_bd_cells axi_ad9671_core_2]

set axi_ad9671_core_3 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9671:1.0 axi_ad9671_core_3]
set_property -dict [list CONFIG.PCORE_4L_2L_N {0}] [get_bd_cells axi_ad9671_core_3]

set axi_usdrx1_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:5.1 axi_usdrx1_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_usdrx1_jesd
set_property -dict [list CONFIG.C_LANES {8}] $axi_usdrx1_jesd

set axi_usdrx1_gt [create_bd_cell -type ip -vlnv analog.com:user:axi_jesd_gt:1.0 axi_usdrx1_gt]
set_property -dict [list CONFIG.PCORE_NUM_OF_LANES {8}] [get_bd_cells axi_usdrx1_gt]
set_property -dict [list CONFIG.PCORE_CPLL_FBDIV {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.PCORE_RX_OUT_DIV {1}] $axi_usdrx1_gt
set_property -dict [list CONFIG.PCORE_TX_OUT_DIV {1}] $axi_usdrx1_gt
set_property -dict [list CONFIG.PCORE_RX_CLK25_DIV {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.PCORE_TX_CLK25_DIV {4}] $axi_usdrx1_gt
set_property -dict [list CONFIG.PCORE_PMA_RSV {0x00018480}] $axi_usdrx1_gt
set_property -dict [list CONFIG.PCORE_RX_CDR_CFG {0x03000023ff20400020}] $axi_usdrx1_gt

set axi_usdrx1_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_usdrx1_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_usdrx1_dma
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.PCORE_ID {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {1}] $axi_usdrx1_dma
set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {1}] $axi_usdrx1_dma
set_property -dict [list CONFIG.C_DMA_LENGTH_WIDTH {24}] $axi_usdrx1_dma
set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_SRC {512}] $axi_usdrx1_dma
set_property -dict [list CONFIG.C_DMA_DATA_WIDTH_DEST {512}] $axi_usdrx1_dma

set axi_usdrx1_gt_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_usdrx1_gt_interconnect]
set_property -dict [list CONFIG.NUM_MI {1}] $axi_usdrx1_gt_interconnect

set axi_usdrx1_dma_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_usdrx1_dma_interconnect]
set_property -dict [list CONFIG.NUM_MI {1}] $axi_usdrx1_dma_interconnect

# gpio and spi

set axi_usdrx1_spi [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.1 axi_usdrx1_spi]
set_property -dict [list CONFIG.C_USE_STARTUP {0}] $axi_usdrx1_spi
set_property -dict [list CONFIG.C_NUM_SS_BITS {5}] $axi_usdrx1_spi
set_property -dict [list CONFIG.C_SCK_RATIO {8}] $axi_usdrx1_spi

# additions to default configuration

set_property -dict [list CONFIG.NUM_MI {15}] $axi_cpu_interconnect
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP2 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP3 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_CLK2_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_CLK3_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_RST2_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {200.0}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {40}] $sys_ps7
set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO {59}] $sys_ps7

set_property LEFT 43 [get_bd_ports GPIO_I]
set_property LEFT 43 [get_bd_ports GPIO_O]
set_property LEFT 43 [get_bd_ports GPIO_T]

# connections (spi and gpio)

connect_bd_net -net axi_spi_1_csn_i [get_bd_ports spi_csn_i]  [get_bd_pins axi_usdrx1_spi/ss_i]
connect_bd_net -net axi_spi_1_csn_o [get_bd_ports spi_csn_o]  [get_bd_pins axi_usdrx1_spi/ss_o]
connect_bd_net -net axi_spi_1_clk_i [get_bd_ports spi_clk_i]  [get_bd_pins axi_usdrx1_spi/sck_i]
connect_bd_net -net axi_spi_1_clk_o [get_bd_ports spi_clk_o]  [get_bd_pins axi_usdrx1_spi/sck_o]
connect_bd_net -net axi_spi_1_sdo_i [get_bd_ports spi_sdo_i]  [get_bd_pins axi_usdrx1_spi/io0_i]
connect_bd_net -net axi_spi_1_sdo_o [get_bd_ports spi_sdo_o]  [get_bd_pins axi_usdrx1_spi/io0_o]
connect_bd_net -net axi_spi_1_sdi_i [get_bd_ports spi_sdi_i]  [get_bd_pins axi_usdrx1_spi/io1_i]

connect_bd_net -net sys_100m_clk [get_bd_pins axi_usdrx1_spi/ext_spi_clk] 
connect_bd_net -net axi_spi_1_irq [get_bd_pins axi_usdrx1_spi/ip2intc_irpt] [get_bd_pins sys_concat_intc/In3] 

# connections (gt)

connect_bd_net -net axi_usdrx1_gt_ref_clk_c         [get_bd_pins axi_usdrx1_gt/ref_clk_c]           [get_bd_ports rx_ref_clk]   
connect_bd_net -net axi_usdrx1_gt_rx_data_p         [get_bd_pins axi_usdrx1_gt/rx_data_p]           [get_bd_ports rx_data_p]   
connect_bd_net -net axi_usdrx1_gt_rx_data_n         [get_bd_pins axi_usdrx1_gt/rx_data_n]           [get_bd_ports rx_data_n]   
connect_bd_net -net axi_usdrx1_gt_rx_sync           [get_bd_pins axi_usdrx1_gt/rx_sync]             [get_bd_ports rx_sync]  
connect_bd_net -net axi_usdrx1_gt_rx_sysref         [get_bd_pins axi_usdrx1_gt/rx_sysref]           [get_bd_ports rx_sysref]   

# connections (adc)

connect_bd_net -net axi_usdrx1_gt_rx_clk  [get_bd_pins axi_usdrx1_gt/rx_clk_g]
connect_bd_net -net axi_usdrx1_gt_rx_clk  [get_bd_pins axi_usdrx1_gt/rx_clk]
connect_bd_net -net axi_usdrx1_gt_rx_clk  [get_bd_pins axi_ad9671_core_0/rx_clk]          
connect_bd_net -net axi_usdrx1_gt_rx_clk  [get_bd_pins axi_ad9671_core_1/rx_clk]          
connect_bd_net -net axi_usdrx1_gt_rx_clk  [get_bd_pins axi_ad9671_core_2/rx_clk]          
connect_bd_net -net axi_usdrx1_gt_rx_clk  [get_bd_pins axi_ad9671_core_3/rx_clk]          
connect_bd_net -net axi_usdrx1_gt_rx_clk  [get_bd_pins axi_usdrx1_jesd/rx_core_clk]

connect_bd_net -net axi_usdrx1_gt_rx_rst            [get_bd_pins axi_usdrx1_gt/rx_rst]              [get_bd_pins axi_usdrx1_jesd/rx_reset]
connect_bd_net -net axi_usdrx1_gt_rx_sysref         [get_bd_pins axi_usdrx1_jesd/rx_sysref]
connect_bd_net -net axi_usdrx1_gt_rx_gt_charisk     [get_bd_pins axi_usdrx1_gt/rx_gt_charisk]       [get_bd_pins axi_usdrx1_jesd/gt_rxcharisk_in]
connect_bd_net -net axi_usdrx1_gt_rx_gt_disperr     [get_bd_pins axi_usdrx1_gt/rx_gt_disperr]       [get_bd_pins axi_usdrx1_jesd/gt_rxdisperr_in]
connect_bd_net -net axi_usdrx1_gt_rx_gt_notintable  [get_bd_pins axi_usdrx1_gt/rx_gt_notintable]    [get_bd_pins axi_usdrx1_jesd/gt_rxnotintable_in]
connect_bd_net -net axi_usdrx1_gt_rx_gt_data        [get_bd_pins axi_usdrx1_gt/rx_gt_data]          [get_bd_pins axi_usdrx1_jesd/gt_rxdata_in]
connect_bd_net -net axi_usdrx1_gt_rx_rst_done       [get_bd_pins axi_usdrx1_gt/rx_rst_done]         [get_bd_pins axi_usdrx1_jesd/rx_reset_done]
connect_bd_net -net axi_usdrx1_gt_rx_ip_comma_align [get_bd_pins axi_usdrx1_gt/rx_ip_comma_align]   [get_bd_pins axi_usdrx1_jesd/rxencommaalign_out]
connect_bd_net -net axi_usdrx1_gt_rx_ip_sync        [get_bd_pins axi_usdrx1_gt/rx_ip_sync]          [get_bd_pins axi_usdrx1_jesd/rx_sync]
connect_bd_net -net axi_usdrx1_gt_rx_ip_sof         [get_bd_pins axi_usdrx1_gt/rx_ip_sof]           [get_bd_pins axi_usdrx1_jesd/rx_start_of_frame]
connect_bd_net -net axi_usdrx1_gt_rx_ip_data        [get_bd_pins axi_usdrx1_gt/rx_ip_data]          [get_bd_pins axi_usdrx1_jesd/rx_tdata]
connect_bd_net -net axi_usdrx1_gt_rx_data           [get_bd_pins axi_usdrx1_gt/rx_data]             [get_bd_ports gt_rx_data]
connect_bd_net -net axi_usdrx1_gt_rx_data_0         [get_bd_pins axi_ad9671_core_0/rx_data]         [get_bd_ports gt_rx_data_0]
connect_bd_net -net axi_usdrx1_gt_rx_data_1         [get_bd_pins axi_ad9671_core_1/rx_data]         [get_bd_ports gt_rx_data_1]
connect_bd_net -net axi_usdrx1_gt_rx_data_2         [get_bd_pins axi_ad9671_core_2/rx_data]         [get_bd_ports gt_rx_data_2]
connect_bd_net -net axi_usdrx1_gt_rx_data_3         [get_bd_pins axi_ad9671_core_3/rx_data]         [get_bd_ports gt_rx_data_3]
connect_bd_net -net axi_ad9671_core_adc_clk         [get_bd_pins axi_ad9671_core_0/adc_clk]         [get_bd_pins axi_usdrx1_dma/fifo_wr_clk]
connect_bd_net -net axi_ad9671_core_adc_data_0      [get_bd_pins axi_ad9671_core_0/adc_data]        [get_bd_ports adc_data_0]
connect_bd_net -net axi_ad9671_core_adc_data_1      [get_bd_pins axi_ad9671_core_1/adc_data]        [get_bd_ports adc_data_1]
connect_bd_net -net axi_ad9671_core_adc_data_2      [get_bd_pins axi_ad9671_core_2/adc_data]        [get_bd_ports adc_data_2]
connect_bd_net -net axi_ad9671_core_adc_data_3      [get_bd_pins axi_ad9671_core_3/adc_data]        [get_bd_ports adc_data_3]
connect_bd_net -net axi_ad9671_core_adc_valid_0     [get_bd_pins axi_ad9671_core_0/adc_valid]       [get_bd_ports adc_valid_0]
connect_bd_net -net axi_ad9671_core_adc_valid_1     [get_bd_pins axi_ad9671_core_1/adc_valid]       [get_bd_ports adc_valid_1]
connect_bd_net -net axi_ad9671_core_adc_valid_2     [get_bd_pins axi_ad9671_core_2/adc_valid]       [get_bd_ports adc_valid_2]
connect_bd_net -net axi_ad9671_core_adc_valid_3     [get_bd_pins axi_ad9671_core_3/adc_valid]       [get_bd_ports adc_valid_3]
connect_bd_net -net axi_ad9671_core_adc_enable_0    [get_bd_pins axi_ad9671_core_0/adc_enable]      [get_bd_ports adc_enable_0]
connect_bd_net -net axi_ad9671_core_adc_enable_1    [get_bd_pins axi_ad9671_core_1/adc_enable]      [get_bd_ports adc_enable_1]
connect_bd_net -net axi_ad9671_core_adc_enable_2    [get_bd_pins axi_ad9671_core_2/adc_enable]      [get_bd_ports adc_enable_2]
connect_bd_net -net axi_ad9671_core_adc_enable_3    [get_bd_pins axi_ad9671_core_3/adc_enable]      [get_bd_ports adc_enable_3]
connect_bd_net -net axi_ad9671_core_adc_dovf_0      [get_bd_pins axi_ad9671_core_0/adc_dovf]        [get_bd_ports adc_dovf_0]
connect_bd_net -net axi_ad9671_core_adc_dovf_1      [get_bd_pins axi_ad9671_core_1/adc_dovf]        [get_bd_ports adc_dovf_1]
connect_bd_net -net axi_ad9671_core_adc_dovf_2      [get_bd_pins axi_ad9671_core_2/adc_dovf]        [get_bd_ports adc_dovf_2]
connect_bd_net -net axi_ad9671_core_adc_dovf_3      [get_bd_pins axi_ad9671_core_3/adc_dovf]        [get_bd_ports adc_dovf_3]
connect_bd_net -net axi_ad9671_dma_wr_en            [get_bd_pins axi_usdrx1_dma/fifo_wr_en]         [get_bd_ports adc_wr_en]
connect_bd_net -net axi_ad9671_dma_adc_data         [get_bd_pins axi_usdrx1_dma/fifo_wr_din]        [get_bd_ports adc_data]
connect_bd_net -net axi_ad9671_dma_adc_dovf         [get_bd_pins axi_usdrx1_dma/fifo_wr_overflow]   [get_bd_ports adc_dovf]
connect_bd_net -net axi_usdrx1_dma_irq              [get_bd_pins axi_usdrx1_dma/irq]                [get_bd_pins sys_concat_intc/In2] 

# interconnect (cpu)

connect_bd_intf_net -intf_net axi_cpu_interconnect_m07_axi [get_bd_intf_pins axi_cpu_interconnect/M07_AXI] [get_bd_intf_pins axi_usdrx1_gt/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m08_axi [get_bd_intf_pins axi_cpu_interconnect/M08_AXI] [get_bd_intf_pins axi_usdrx1_jesd/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m09_axi [get_bd_intf_pins axi_cpu_interconnect/M09_AXI] [get_bd_intf_pins axi_ad9671_core_0/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m10_axi [get_bd_intf_pins axi_cpu_interconnect/M10_AXI] [get_bd_intf_pins axi_ad9671_core_1/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m11_axi [get_bd_intf_pins axi_cpu_interconnect/M11_AXI] [get_bd_intf_pins axi_ad9671_core_2/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m12_axi [get_bd_intf_pins axi_cpu_interconnect/M12_AXI] [get_bd_intf_pins axi_ad9671_core_3/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m13_axi [get_bd_intf_pins axi_cpu_interconnect/M13_AXI] [get_bd_intf_pins axi_usdrx1_dma/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m14_axi [get_bd_intf_pins axi_cpu_interconnect/M14_AXI] [get_bd_intf_pins axi_usdrx1_spi/axi_lite]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M07_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M08_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M09_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M10_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M11_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M12_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M13_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M14_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_usdrx1_gt/s_axi_aclk] 
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9671_core_0/s_axi_aclk] 
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9671_core_1/s_axi_aclk] 
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9671_core_2/s_axi_aclk] 
connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9671_core_3/s_axi_aclk] 
connect_bd_net -net sys_100m_clk [get_bd_pins axi_usdrx1_jesd/s_axi_aclk] 
connect_bd_net -net sys_100m_clk [get_bd_pins axi_usdrx1_dma/s_axi_aclk] 
connect_bd_net -net sys_100m_clk [get_bd_pins axi_usdrx1_spi/s_axi_aclk] 
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M07_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M08_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M09_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M10_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M11_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M12_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M13_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M14_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_usdrx1_gt/s_axi_aresetn] 
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9671_core_0/s_axi_aresetn] 
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9671_core_1/s_axi_aresetn] 
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9671_core_2/s_axi_aresetn] 
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9671_core_3/s_axi_aresetn] 
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_usdrx1_jesd/s_axi_aresetn] 
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_usdrx1_dma/s_axi_aresetn] 
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_usdrx1_spi/s_axi_aresetn] 

# interconnect (gt es)

connect_bd_intf_net -intf_net axi_usdrx1_gt_interconnect_s00_axi [get_bd_intf_pins axi_usdrx1_gt_interconnect/S00_AXI] [get_bd_intf_pins axi_usdrx1_gt/m_axi]
connect_bd_intf_net -intf_net axi_usdrx1_gt_interconnect_m00_axi [get_bd_intf_pins axi_usdrx1_gt_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP3]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_usdrx1_gt_interconnect/ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_usdrx1_gt_interconnect/S00_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_usdrx1_gt_interconnect/M00_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins sys_ps7/S_AXI_HP3_ACLK]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_usdrx1_gt/m_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_usdrx1_gt/drp_clk]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_usdrx1_gt_interconnect/ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_usdrx1_gt_interconnect/S00_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_usdrx1_gt_interconnect/M00_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_usdrx1_gt/m_axi_aresetn]

# interconnect (dma)

set sys_fmc_dma_clk_source [get_bd_pins sys_ps7/FCLK_CLK2]
set sys_fmc_dma_resetn_source [get_bd_pins sys_ps7/FCLK_RESET2_N]

connect_bd_net -net sys_fmc_dma_clk $sys_fmc_dma_clk_source
connect_bd_net -net sys_fmc_dma_resetn $sys_fmc_dma_resetn_source

connect_bd_intf_net -intf_net axi_usdrx1_dma_interconnect_m00_axi [get_bd_intf_pins axi_usdrx1_dma_interconnect/M00_AXI]  [get_bd_intf_pins sys_ps7/S_AXI_HP2]
connect_bd_intf_net -intf_net axi_usdrx1_dma_interconnect_s00_axi [get_bd_intf_pins axi_usdrx1_dma_interconnect/S00_AXI]  [get_bd_intf_pins axi_usdrx1_dma/m_dest_axi] 
connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_usdrx1_dma_interconnect/ACLK] $sys_fmc_dma_clk_source
connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_usdrx1_dma_interconnect/S00_ACLK] $sys_fmc_dma_clk_source
connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_usdrx1_dma_interconnect/M00_ACLK] $sys_fmc_dma_clk_source
connect_bd_net -net sys_fmc_dma_clk [get_bd_pins sys_ps7/S_AXI_HP2_ACLK]
connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_usdrx1_dma/m_dest_axi_aclk]
connect_bd_net -net sys_fmc_dma_resetn [get_bd_pins axi_usdrx1_dma_interconnect/ARESETN] $sys_fmc_dma_resetn_source
connect_bd_net -net sys_fmc_dma_resetn [get_bd_pins axi_usdrx1_dma_interconnect/S00_ARESETN] $sys_fmc_dma_resetn_source
connect_bd_net -net sys_fmc_dma_resetn [get_bd_pins axi_usdrx1_dma_interconnect/M00_ARESETN] $sys_fmc_dma_resetn_source
connect_bd_net -net sys_fmc_dma_resetn [get_bd_pins axi_usdrx1_dma/m_dest_axi_aresetn] 

# ila

set ila_jesd_rx_mon [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:3.0 ila_jesd_rx_mon]
set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE0_WIDTH {662}] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE1_WIDTH {10}] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_jesd_rx_mon

connect_bd_net -net axi_usdrx1_gt_rx_mon_data       [get_bd_pins axi_usdrx1_gt/rx_mon_data]
connect_bd_net -net axi_usdrx1_gt_rx_mon_trigger    [get_bd_pins axi_usdrx1_gt/rx_mon_trigger]
connect_bd_net -net axi_usdrx1_gt_rx_clk            [get_bd_pins ila_jesd_rx_mon/CLK]
connect_bd_net -net axi_usdrx1_gt_rx_mon_data       [get_bd_pins ila_jesd_rx_mon/PROBE0]
connect_bd_net -net axi_usdrx1_gt_rx_mon_trigger    [get_bd_pins ila_jesd_rx_mon/PROBE1]

set ila_ad9671 [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:3.0 ila_ad9671]
set_property -dict [list CONFIG.C_NUM_OF_PROBES {8}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE0_WIDTH {128}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE1_WIDTH {8}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE2_WIDTH {128}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE3_WIDTH {8}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE4_WIDTH {128}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE5_WIDTH {8}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE6_WIDTH {128}] $ila_ad9671
set_property -dict [list CONFIG.C_PROBE7_WIDTH {8}] $ila_ad9671
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_ad9671

connect_bd_net -net axi_ad9671_core_adc_clk        [get_bd_pins ila_ad9671/CLK]
connect_bd_net -net axi_ad9671_core_adc_data_0     [get_bd_pins ila_ad9671/PROBE0]
connect_bd_net -net axi_ad9671_core_adc_valid_0    [get_bd_pins ila_ad9671/PROBE1]
connect_bd_net -net axi_ad9671_core_adc_data_1     [get_bd_pins ila_ad9671/PROBE2]
connect_bd_net -net axi_ad9671_core_adc_valid_1    [get_bd_pins ila_ad9671/PROBE3]
connect_bd_net -net axi_ad9671_core_adc_data_2     [get_bd_pins ila_ad9671/PROBE4]
connect_bd_net -net axi_ad9671_core_adc_valid_2    [get_bd_pins ila_ad9671/PROBE5]
connect_bd_net -net axi_ad9671_core_adc_data_3     [get_bd_pins ila_ad9671/PROBE6]
connect_bd_net -net axi_ad9671_core_adc_valid_3    [get_bd_pins ila_ad9671/PROBE7]
# address map

create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9671_core_0/s_axi/axi_lite]   SEG_data_ad9671_core_0
create_bd_addr_seg -range 0x00010000 -offset 0x44A10000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9671_core_1/s_axi/axi_lite]   SEG_data_ad9671_core_1
create_bd_addr_seg -range 0x00010000 -offset 0x44A20000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9671_core_2/s_axi/axi_lite]   SEG_data_ad9671_core_2
create_bd_addr_seg -range 0x00010000 -offset 0x44A30000 $sys_addr_cntrl_space [get_bd_addr_segs axi_ad9671_core_3/s_axi/axi_lite]   SEG_data_ad9671_core_3

create_bd_addr_seg -range 0x00010000 -offset 0x44A60000 $sys_addr_cntrl_space [get_bd_addr_segs axi_usdrx1_gt/s_axi/axi_lite]       SEG_data_usdrx1_gt
create_bd_addr_seg -range 0x00001000 -offset 0x44A91000 $sys_addr_cntrl_space [get_bd_addr_segs axi_usdrx1_jesd/s_axi/Reg]          SEG_data_usdrx1_jesd
create_bd_addr_seg -range 0x00010000 -offset 0x7c400000 $sys_addr_cntrl_space [get_bd_addr_segs axi_usdrx1_dma/s_axi/axi_lite]      SEG_data_usdrx1_dma
create_bd_addr_seg -range 0x00010000 -offset 0x7c420000 $sys_addr_cntrl_space [get_bd_addr_segs axi_usdrx1_spi/axi_lite/Reg]        SEG_data_usdrx1_spi

create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_usdrx1_dma/m_dest_axi]  [get_bd_addr_segs sys_ps7/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_sys_ps7_hp2_ddr_lowocm
create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_usdrx1_gt/m_axi]        [get_bd_addr_segs sys_ps7/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_sys_ps7_hp3_ddr_lowocm

