
# create board design
# interface ports

set DDR [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR]
set FIXED_IO [create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO]
set IIC_MAIN [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_MAIN]

set GPIO_I [create_bd_port -dir I -from 43 -to 0 GPIO_I]
set GPIO_O [create_bd_port -dir O -from 43 -to 0 GPIO_O]
set GPIO_T [create_bd_port -dir O -from 43 -to 0 GPIO_T]

# interface ports

set hdmi_out_clk    [create_bd_port -dir O hdmi_out_clk]
set hdmi_hsync      [create_bd_port -dir O hdmi_hsync]
set hdmi_vsync      [create_bd_port -dir O hdmi_vsync]
set hdmi_data_e     [create_bd_port -dir O hdmi_data_e]
set hdmi_data       [create_bd_port -dir O -from 23 -to 0 hdmi_data]
set hdmi_int        [create_bd_port -dir I hdmi_int]

set rx_ref_clk      [create_bd_port -dir I rx_ref_clk]
set rx_data_p       [create_bd_port -dir I -from 7 -to 0 rx_data_p]
set rx_data_n       [create_bd_port -dir I -from 7 -to 0 rx_data_n]
set rx_sync         [create_bd_port -dir O rx_sync]
set rx_sysref       [create_bd_port -dir O rx_sysref]

set mlo_clk         [create_bd_port -dir O mlo_clk]

set spi_csn_i       [create_bd_port -dir I -from 10 -to 0 spi_csn_i]
set spi_csn_o       [create_bd_port -dir O -from 10 -to 0 spi_csn_o]
set spi_clk_i       [create_bd_port -dir I spi_clk_i]
set spi_clk_o       [create_bd_port -dir O spi_clk_o]
set spi_sdo_i       [create_bd_port -dir I spi_sdo_i]
set spi_sdo_o       [create_bd_port -dir O spi_sdo_o]
set spi_sdi_i       [create_bd_port -dir I spi_sdi_i]

# instance: processing_system7_1

set processing_system7_1  [create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.3 processing_system7_1]
set_property -dict [list CONFIG.PCW_IMPORT_BOARD_PRESET {ZC706}] $processing_system7_1
set_property -dict [list CONFIG.PCW_EN_CLK1_PORT {1}] $processing_system7_1
set_property -dict [list CONFIG.PCW_EN_CLK2_PORT {1}] $processing_system7_1
set_property -dict [list CONFIG.PCW_EN_CLK3_PORT {1}] $processing_system7_1
set_property -dict [list CONFIG.PCW_EN_RST1_PORT {1}] $processing_system7_1
set_property -dict [list CONFIG.PCW_EN_RST2_PORT {1}] $processing_system7_1
set_property -dict [list CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100.0}] $processing_system7_1
set_property -dict [list CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {200.0}] $processing_system7_1
set_property -dict [list CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {200.0}] $processing_system7_1
set_property -dict [list CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {40}] $processing_system7_1
set_property -dict [list CONFIG.PCW_USE_FABRIC_INTERRUPT {1}] $processing_system7_1
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP0 {1}] $processing_system7_1
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP2 {1}] $processing_system7_1
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP3 {1}] $processing_system7_1
set_property -dict [list CONFIG.PCW_IRQ_F2P_INTR {1}] $processing_system7_1
set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1}] $processing_system7_1
set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO {44}] $processing_system7_1

set axi_iic_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_1]
set_property -dict [list CONFIG.USE_BOARD_FLOW {true} CONFIG.IIC_BOARD_INTERFACE {IIC_MAIN}] $axi_iic_1

set xlconcat_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:1.0 xlconcat_1]
set_property -dict [list CONFIG.NUM_PORTS {5}] $xlconcat_1

set axi_interconnect_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_1]
set_property -dict [list CONFIG.NUM_MI {12}] $axi_interconnect_1

# hdmi peripherals

set axi_hdmi_clkgen [create_bd_cell -type ip -vlnv analog.com:user:axi_clkgen:1.0 axi_hdmi_clkgen]
set axi_hdmi_core [create_bd_cell -type ip -vlnv analog.com:user:axi_hdmi_tx:1.0 axi_hdmi_core]

set axi_hdmi_dma [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.1 axi_hdmi_dma]
set_property -dict [list CONFIG.c_m_axis_mm2s_tdata_width {64}] $axi_hdmi_dma
set_property -dict [list CONFIG.c_use_mm2s_fsync {1}] $axi_hdmi_dma
set_property -dict [list CONFIG.c_include_s2mm {0}] $axi_hdmi_dma

set axi_hdmi_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_hdmi_interconnect]
set_property -dict [list CONFIG.NUM_MI {1}] $axi_hdmi_interconnect

# ultrasound

set axi_usdrx1_gt [create_bd_cell -type ip -vlnv analog.com:user:axi_jesd_gt:1.0 axi_usdrx1_gt]
set_property -dict [list CONFIG.PCORE_NUM_OF_LANES {8}] [get_bd_cells axi_usdrx1_gt]

set axi_usdrx1_jesd [create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:5.1 axi_usdrx1_jesd]
set_property -dict [list CONFIG.C_NODE_IS_TRANSMIT {0}] $axi_usdrx1_jesd
set_property -dict [list CONFIG.C_LANES {8}] $axi_usdrx1_jesd

set axi_ad9671_core_0 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9671:1.0 axi_ad9671_core_0]
set_property -dict [list CONFIG.PCORE_4L_2L_N {0}] [get_bd_cells axi_ad9671_core_0]

set axi_ad9671_core_1 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9671:1.0 axi_ad9671_core_1]
set_property -dict [list CONFIG.PCORE_4L_2L_N {0}] [get_bd_cells axi_ad9671_core_1]

set axi_ad9671_core_2 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9671:1.0 axi_ad9671_core_2]
set_property -dict [list CONFIG.PCORE_4L_2L_N {0}] [get_bd_cells axi_ad9671_core_2]

set axi_ad9671_core_3 [create_bd_cell -type ip -vlnv analog.com:user:axi_ad9671:1.0 axi_ad9671_core_3]
set_property -dict [list CONFIG.PCORE_4L_2L_N {0}] [get_bd_cells axi_ad9671_core_3]

set axi_usdrx1_dma [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_usdrx1_dma]
set_property -dict [list CONFIG.C_DMA_TYPE_SRC {2}] $axi_usdrx1_dma
set_property -dict [list CONFIG.C_DMA_TYPE_DEST {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.PCORE_ID {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.C_AXI_SLICE_SRC {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.C_AXI_SLICE_DEST {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.C_CLKS_ASYNC_DEST_REQ {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.C_SYNC_TRANSFER_START {1}] $axi_usdrx1_dma
set_property -dict [list CONFIG.C_DMA_LENGTH_WIDTH {24}] $axi_usdrx1_dma
set_property -dict [list CONFIG.C_2D_TRANSFER {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.C_CYCLIC {0}] $axi_usdrx1_dma
set_property -dict [list CONFIG.C_M_DEST_AXI_DATA_WIDTH {512}] $axi_usdrx1_dma

set axi_usdrx1_spi [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.1 axi_usdrx1_spi]
set_property -dict [list CONFIG.C_USE_STARTUP {0}] $axi_usdrx1_spi
set_property -dict [list CONFIG.C_NUM_SS_BITS {11}] $axi_usdrx1_spi
set_property -dict [list CONFIG.C_SCK_RATIO {8}] $axi_usdrx1_spi

set axi_usdrx1_gt_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_usdrx1_gt_interconnect]
set_property -dict [list CONFIG.NUM_MI {1}] $axi_usdrx1_gt_interconnect

set axi_usdrx1_dma_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_usdrx1_dma_interconnect]
set_property -dict [list CONFIG.NUM_MI {1}] $axi_usdrx1_dma_interconnect

set dma_concat_data [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:1.0 dma_concat_data]
set_property -dict [list CONFIG.NUM_PORTS {4}] $dma_concat_data
set_property -dict [list CONFIG.IN0_WIDTH {128}] $dma_concat_data
set_property -dict [list CONFIG.IN1_WIDTH {128}] $dma_concat_data
set_property -dict [list CONFIG.IN2_WIDTH {128}] $dma_concat_data
set_property -dict [list CONFIG.IN3_WIDTH {128}] $dma_concat_data

set dma_concat_sync [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:1.0 dma_concat_sync]
set_property -dict [list CONFIG.NUM_PORTS {4}] $dma_concat_sync
set_property -dict [list CONFIG.IN0_WIDTH {1}] $dma_concat_sync
set_property -dict [list CONFIG.IN1_WIDTH {1}] $dma_concat_sync
set_property -dict [list CONFIG.IN2_WIDTH {1}] $dma_concat_sync
set_property -dict [list CONFIG.IN3_WIDTH {1}] $dma_concat_sync

set dma_concat_wr [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:1.0 dma_concat_wr]
set_property -dict [list CONFIG.NUM_PORTS {4}] $dma_concat_wr
set_property -dict [list CONFIG.IN0_WIDTH {1}] $dma_concat_wr
set_property -dict [list CONFIG.IN1_WIDTH {1}] $dma_concat_wr
set_property -dict [list CONFIG.IN2_WIDTH {1}] $dma_concat_wr
set_property -dict [list CONFIG.IN3_WIDTH {1}] $dma_concat_wr

set dma_concat_sync_or [create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:1.0 dma_concat_sync_or]
set_property -dict [list CONFIG.C_SIZE {4}] $dma_concat_sync_or
set_property -dict [list CONFIG.C_OPERATION {or}] $dma_concat_sync_or

set dma_concat_wr_or [create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:1.0 dma_concat_wr_or]
set_property -dict [list CONFIG.C_SIZE {4}] $dma_concat_wr_or
set_property -dict [list CONFIG.C_OPERATION {or}] $dma_concat_wr_or

set gt_slice_data_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 gt_slice_data_0]
set_property -dict [list CONFIG.DIN_WIDTH {256}] $gt_slice_data_0
set_property -dict [list CONFIG.DIN_FROM {63}] $gt_slice_data_0
set_property -dict [list CONFIG.DIN_TO {0}] $gt_slice_data_0

set gt_slice_data_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 gt_slice_data_1]
set_property -dict [list CONFIG.DIN_WIDTH {256}] $gt_slice_data_1
set_property -dict [list CONFIG.DIN_FROM {127}] $gt_slice_data_1
set_property -dict [list CONFIG.DIN_TO {64}] $gt_slice_data_1

set gt_slice_data_2 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 gt_slice_data_2]
set_property -dict [list CONFIG.DIN_WIDTH {256}] $gt_slice_data_2
set_property -dict [list CONFIG.DIN_FROM {191}] $gt_slice_data_2
set_property -dict [list CONFIG.DIN_TO {128}] $gt_slice_data_2

set gt_slice_data_3 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 gt_slice_data_3]
set_property -dict [list CONFIG.DIN_WIDTH {256}] $gt_slice_data_3
set_property -dict [list CONFIG.DIN_FROM {255}] $gt_slice_data_3
set_property -dict [list CONFIG.DIN_TO {192}] $gt_slice_data_3

set ila_jesd_rx_mon [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:3.0 ila_jesd_rx_mon]
set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE0_WIDTH {662}] $ila_jesd_rx_mon
set_property -dict [list CONFIG.C_PROBE1_WIDTH {10}] $ila_jesd_rx_mon

# interface connections

connect_bd_intf_net -intf_net processing_system7_1_ddr [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_1/DDR]
connect_bd_net -net processing_system7_1_GPIO_I [get_bd_ports GPIO_I] [get_bd_pins processing_system7_1/GPIO_I]
connect_bd_net -net processing_system7_1_GPIO_O [get_bd_ports GPIO_O] [get_bd_pins processing_system7_1/GPIO_O]
connect_bd_net -net processing_system7_1_GPIO_T [get_bd_ports GPIO_T] [get_bd_pins processing_system7_1/GPIO_T]
connect_bd_intf_net -intf_net processing_system7_1_fixed_io [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_1/FIXED_IO]
connect_bd_intf_net -intf_net axi_iic_1_iic [get_bd_intf_ports IIC_MAIN] [get_bd_intf_pins axi_iic_1/iic]

connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins processing_system7_1/FCLK_CLK0]
connect_bd_net -net processing_system7_1_fclk_clk1 [get_bd_pins processing_system7_1/FCLK_CLK1]
connect_bd_net -net processing_system7_1_fclk_clk2 [get_bd_pins processing_system7_1/FCLK_CLK2]
connect_bd_net -net processing_system7_1_fclk_clk3 [get_bd_pins processing_system7_1/FCLK_CLK3] [get_bd_ports mlo_clk]


connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins processing_system7_1/FCLK_RESET0_N]
connect_bd_net -net processing_system7_1_fclk_reset2_n [get_bd_pins processing_system7_1/FCLK_RESET2_N]

connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins processing_system7_1/M_AXI_GP0_ACLK]
connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins axi_interconnect_1/ACLK] [get_bd_pins processing_system7_1/FCLK_CLK0]
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_interconnect_1/ARESETN] [get_bd_pins processing_system7_1/FCLK_RESET0_N]

connect_bd_intf_net -intf_net axi_interconnect_1_s00_axi [get_bd_intf_pins axi_interconnect_1/S00_AXI] [get_bd_intf_pins processing_system7_1/M_AXI_GP0]
connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins axi_interconnect_1/S00_ACLK] [get_bd_pins processing_system7_1/FCLK_CLK0]
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_interconnect_1/S00_ARESETN] [get_bd_pins processing_system7_1/FCLK_RESET0_N]

connect_bd_intf_net -intf_net axi_interconnect_1_m00_axi [get_bd_intf_pins axi_interconnect_1/M00_AXI] [get_bd_intf_pins axi_iic_1/s_axi]
connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins axi_interconnect_1/M00_ACLK] [get_bd_pins processing_system7_1/FCLK_CLK0]
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_interconnect_1/M00_ARESETN] [get_bd_pins processing_system7_1/FCLK_RESET0_N]
connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins axi_iic_1/s_axi_aclk]
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_iic_1/s_axi_aresetn]
connect_bd_net -net xlconcat_din_0 [get_bd_pins xlconcat_1/In0] [get_bd_pins axi_iic_1/iic2intc_irpt]

connect_bd_net -net processing_system7_1_interrupt [get_bd_pins xlconcat_1/dout] [get_bd_pins processing_system7_1/IRQ_F2P]

# hdmi

connect_bd_net -net processing_system7_1_fclk_clk1   [get_bd_pins axi_hdmi_clkgen/clk]

connect_bd_intf_net -intf_net axi_interconnect_1_m01_axi [get_bd_intf_pins axi_interconnect_1/M01_AXI] [get_bd_intf_pins axi_hdmi_clkgen/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m02_axi [get_bd_intf_pins axi_interconnect_1/M02_AXI] [get_bd_intf_pins axi_hdmi_core/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m03_axi [get_bd_intf_pins axi_interconnect_1/M03_AXI] [get_bd_intf_pins axi_hdmi_dma/S_AXI_LITE]

connect_bd_intf_net -intf_net axi_hdmi_interconnect_s00_axi [get_bd_intf_pins axi_hdmi_interconnect/S00_AXI] [get_bd_intf_pins axi_hdmi_dma/M_AXI_MM2S]
connect_bd_intf_net -intf_net axi_hdmi_interconnect_m00_axi [get_bd_intf_pins axi_hdmi_interconnect/M00_AXI] [get_bd_intf_pins processing_system7_1/S_AXI_HP0]

connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins axi_interconnect_1/M01_ACLK]    [get_bd_pins processing_system7_1/FCLK_CLK0]
connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins axi_interconnect_1/M02_ACLK]    [get_bd_pins processing_system7_1/FCLK_CLK0]
connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins axi_interconnect_1/M03_ACLK]    [get_bd_pins processing_system7_1/FCLK_CLK0]
connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins axi_hdmi_interconnect/ACLK]     [get_bd_pins processing_system7_1/FCLK_CLK0]
connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins axi_hdmi_interconnect/S00_ACLK] [get_bd_pins processing_system7_1/FCLK_CLK0]
connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins axi_hdmi_interconnect/M00_ACLK] [get_bd_pins processing_system7_1/FCLK_CLK0]
connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins axi_hdmi_clkgen/s_axi_aclk]
connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins axi_hdmi_clkgen/drp_clk]
connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins axi_hdmi_core/s_axi_aclk]
connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins axi_hdmi_core/m_axis_mm2s_clk]
connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins axi_hdmi_dma/s_axi_lite_aclk]
connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins axi_hdmi_dma/m_axi_mm2s_aclk]
connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins axi_hdmi_dma/m_axis_mm2s_aclk]
connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins processing_system7_1/S_AXI_HP0_ACLK]

connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_interconnect_1/M01_ARESETN]     [get_bd_pins processing_system7_1/FCLK_RESET0_N]
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_interconnect_1/M02_ARESETN]     [get_bd_pins processing_system7_1/FCLK_RESET0_N]
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_interconnect_1/M03_ARESETN]     [get_bd_pins processing_system7_1/FCLK_RESET0_N]
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_hdmi_interconnect/ARESETN]      [get_bd_pins processing_system7_1/FCLK_RESET0_N]
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_hdmi_interconnect/S00_ARESETN]  [get_bd_pins processing_system7_1/FCLK_RESET0_N]
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_hdmi_interconnect/M00_ARESETN]  [get_bd_pins processing_system7_1/FCLK_RESET0_N]
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_hdmi_clkgen/s_axi_aresetn]
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_hdmi_core/s_axi_aresetn]
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_hdmi_dma/axi_resetn]

connect_bd_net -net axi_hdmi_tx_1_hdmi_clk      [get_bd_pins axi_hdmi_core/hdmi_clk]              [get_bd_pins axi_hdmi_clkgen/clk_0]
connect_bd_net -net axi_hdmi_tx_1_hdmi_out_clk  [get_bd_pins axi_hdmi_core/hdmi_out_clk]          [get_bd_ports hdmi_out_clk] 
connect_bd_net -net axi_hdmi_tx_1_hdmi_hsync    [get_bd_pins axi_hdmi_core/hdmi_24_hsync]         [get_bd_ports hdmi_hsync]   
connect_bd_net -net axi_hdmi_tx_1_hdmi_vsync    [get_bd_pins axi_hdmi_core/hdmi_24_vsync]         [get_bd_ports hdmi_vsync]   
connect_bd_net -net axi_hdmi_tx_1_hdmi_data_e   [get_bd_pins axi_hdmi_core/hdmi_24_data_e]        [get_bd_ports hdmi_data_e]  
connect_bd_net -net axi_hdmi_tx_1_hdmi_data     [get_bd_pins axi_hdmi_core/hdmi_24_data]          [get_bd_ports hdmi_data]    
connect_bd_net -net axi_hdmi_tx_1_mm2s_tvalid   [get_bd_pins axi_hdmi_core/m_axis_mm2s_tvalid]    [get_bd_pins axi_hdmi_dma/m_axis_mm2s_tvalid]
connect_bd_net -net axi_hdmi_tx_1_mm2s_tdata    [get_bd_pins axi_hdmi_core/m_axis_mm2s_tdata]     [get_bd_pins axi_hdmi_dma/m_axis_mm2s_tdata] 
connect_bd_net -net axi_hdmi_tx_1_mm2s_tkeep    [get_bd_pins axi_hdmi_core/m_axis_mm2s_tkeep]     [get_bd_pins axi_hdmi_dma/m_axis_mm2s_tkeep] 
connect_bd_net -net axi_hdmi_tx_1_mm2s_tlast    [get_bd_pins axi_hdmi_core/m_axis_mm2s_tlast]     [get_bd_pins axi_hdmi_dma/m_axis_mm2s_tlast] 
connect_bd_net -net axi_hdmi_tx_1_mm2s_tready   [get_bd_pins axi_hdmi_core/m_axis_mm2s_tready]    [get_bd_pins axi_hdmi_dma/m_axis_mm2s_tready]
connect_bd_net -net axi_hdmi_tx_1_mm2s_fsync    [get_bd_pins axi_hdmi_core/m_axis_mm2s_fsync]     [get_bd_pins axi_hdmi_dma/mm2s_fsync]        
connect_bd_net -net axi_hdmi_tx_1_mm2s_fsync    [get_bd_pins axi_hdmi_core/m_axis_mm2s_fsync_ret]

connect_bd_net -net xlconcat_din_1 [get_bd_pins xlconcat_1/In1] [get_bd_ports hdmi_int] 
connect_bd_net -net xlconcat_din_2 [get_bd_pins xlconcat_1/In2] [get_bd_pins axi_hdmi_dma/mm2s_introut] 

# Ultrasound

connect_bd_intf_net -intf_net axi_interconnect_1_m04_axi [get_bd_intf_pins axi_interconnect_1/M04_AXI] [get_bd_intf_pins axi_usdrx1_gt/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m05_axi [get_bd_intf_pins axi_interconnect_1/M05_AXI] [get_bd_intf_pins axi_usdrx1_jesd/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m06_axi [get_bd_intf_pins axi_interconnect_1/M06_AXI] [get_bd_intf_pins axi_ad9671_core_0/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m07_axi [get_bd_intf_pins axi_interconnect_1/M07_AXI] [get_bd_intf_pins axi_ad9671_core_1/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m08_axi [get_bd_intf_pins axi_interconnect_1/M08_AXI] [get_bd_intf_pins axi_ad9671_core_2/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m09_axi [get_bd_intf_pins axi_interconnect_1/M09_AXI] [get_bd_intf_pins axi_ad9671_core_3/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m10_axi [get_bd_intf_pins axi_interconnect_1/M10_AXI] [get_bd_intf_pins axi_usdrx1_dma/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_1_m11_axi [get_bd_intf_pins axi_interconnect_1/M11_AXI] [get_bd_intf_pins axi_usdrx1_spi/axi_lite]

connect_bd_intf_net -intf_net axi_usdrx1_gt_interconnect_s00_axi  [get_bd_intf_pins axi_usdrx1_gt_interconnect/S00_AXI]   [get_bd_intf_pins axi_usdrx1_gt/m_axi]
connect_bd_intf_net -intf_net axi_usdrx1_gt_interconnect_m00_axi  [get_bd_intf_pins axi_usdrx1_gt_interconnect/M00_AXI]   [get_bd_intf_pins processing_system7_1/S_AXI_HP2]
connect_bd_intf_net -intf_net axi_usdrx1_dma_interconnect_s00_axi [get_bd_intf_pins axi_usdrx1_dma_interconnect/S00_AXI]  [get_bd_intf_pins axi_usdrx1_dma/m_dest_axi] 
connect_bd_intf_net -intf_net axi_usdrx1_dma_interconnect_m00_axi [get_bd_intf_pins axi_usdrx1_dma_interconnect/M00_AXI]  [get_bd_intf_pins processing_system7_1/S_AXI_HP3]

connect_bd_net -net processing_system7_1_fclk_clk0  [get_bd_pins axi_interconnect_1/M04_ACLK] [get_bd_pins processing_system7_1/FCLK_CLK0]
connect_bd_net -net processing_system7_1_fclk_clk0  [get_bd_pins axi_interconnect_1/M05_ACLK] [get_bd_pins processing_system7_1/FCLK_CLK0]
connect_bd_net -net processing_system7_1_fclk_clk0  [get_bd_pins axi_interconnect_1/M06_ACLK] [get_bd_pins processing_system7_1/FCLK_CLK0]
connect_bd_net -net processing_system7_1_fclk_clk0  [get_bd_pins axi_interconnect_1/M07_ACLK] [get_bd_pins processing_system7_1/FCLK_CLK0]
connect_bd_net -net processing_system7_1_fclk_clk0  [get_bd_pins axi_interconnect_1/M08_ACLK] [get_bd_pins processing_system7_1/FCLK_CLK0]
connect_bd_net -net processing_system7_1_fclk_clk0  [get_bd_pins axi_interconnect_1/M09_ACLK] [get_bd_pins processing_system7_1/FCLK_CLK0]
connect_bd_net -net processing_system7_1_fclk_clk0  [get_bd_pins axi_interconnect_1/M10_ACLK] [get_bd_pins processing_system7_1/FCLK_CLK0]
connect_bd_net -net processing_system7_1_fclk_clk0  [get_bd_pins axi_interconnect_1/M11_ACLK] [get_bd_pins processing_system7_1/FCLK_CLK0]
connect_bd_net -net processing_system7_1_fclk_clk0  [get_bd_pins axi_usdrx1_gt_interconnect/ACLK]     [get_bd_pins processing_system7_1/FCLK_CLK0]
connect_bd_net -net processing_system7_1_fclk_clk0  [get_bd_pins axi_usdrx1_gt_interconnect/S00_ACLK] [get_bd_pins processing_system7_1/FCLK_CLK0]
connect_bd_net -net processing_system7_1_fclk_clk0  [get_bd_pins axi_usdrx1_gt_interconnect/M00_ACLK] [get_bd_pins processing_system7_1/FCLK_CLK0]
connect_bd_net -net processing_system7_1_fclk_clk0  [get_bd_pins processing_system7_1/S_AXI_HP2_ACLK]
connect_bd_net -net processing_system7_1_fclk_clk0  [get_bd_pins axi_usdrx1_gt/s_axi_aclk] 
connect_bd_net -net processing_system7_1_fclk_clk0  [get_bd_pins axi_usdrx1_gt/m_axi_aclk]
connect_bd_net -net processing_system7_1_fclk_clk0  [get_bd_pins axi_usdrx1_gt/drp_clk]
connect_bd_net -net processing_system7_1_fclk_clk0  [get_bd_pins axi_usdrx1_jesd/s_axi_aclk] 
connect_bd_net -net processing_system7_1_fclk_clk0  [get_bd_pins axi_ad9671_core_0/s_axi_aclk] 
connect_bd_net -net processing_system7_1_fclk_clk0  [get_bd_pins axi_ad9671_core_1/s_axi_aclk] 
connect_bd_net -net processing_system7_1_fclk_clk0  [get_bd_pins axi_ad9671_core_2/s_axi_aclk] 
connect_bd_net -net processing_system7_1_fclk_clk0  [get_bd_pins axi_ad9671_core_3/s_axi_aclk] 
connect_bd_net -net processing_system7_1_fclk_clk0  [get_bd_pins axi_usdrx1_dma/s_axi_aclk] 
connect_bd_net -net processing_system7_1_fclk_clk0  [get_bd_pins axi_usdrx1_spi/s_axi_aclk] 
connect_bd_net -net processing_system7_1_fclk_clk0  [get_bd_pins axi_usdrx1_spi/ext_spi_clk] 

connect_bd_net -net processing_system7_1_fclk_clk2  [get_bd_pins axi_usdrx1_dma_interconnect/ACLK]     [get_bd_pins processing_system7_1/FCLK_CLK2]
connect_bd_net -net processing_system7_1_fclk_clk2  [get_bd_pins axi_usdrx1_dma_interconnect/S00_ACLK] [get_bd_pins processing_system7_1/FCLK_CLK2]
connect_bd_net -net processing_system7_1_fclk_clk2  [get_bd_pins axi_usdrx1_dma_interconnect/M00_ACLK] [get_bd_pins processing_system7_1/FCLK_CLK2]
connect_bd_net -net processing_system7_1_fclk_clk2  [get_bd_pins processing_system7_1/S_AXI_HP3_ACLK]
connect_bd_net -net processing_system7_1_fclk_clk2  [get_bd_pins axi_usdrx1_dma/m_dest_axi_aclk]

connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_interconnect_1/M04_ARESETN] [get_bd_pins processing_system7_1/FCLK_RESET0_N]
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_interconnect_1/M05_ARESETN] [get_bd_pins processing_system7_1/FCLK_RESET0_N]
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_interconnect_1/M06_ARESETN] [get_bd_pins processing_system7_1/FCLK_RESET0_N]
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_interconnect_1/M07_ARESETN] [get_bd_pins processing_system7_1/FCLK_RESET0_N]
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_interconnect_1/M08_ARESETN] [get_bd_pins processing_system7_1/FCLK_RESET0_N]
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_interconnect_1/M09_ARESETN] [get_bd_pins processing_system7_1/FCLK_RESET0_N]
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_interconnect_1/M10_ARESETN] [get_bd_pins processing_system7_1/FCLK_RESET0_N]
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_interconnect_1/M11_ARESETN] [get_bd_pins processing_system7_1/FCLK_RESET0_N]
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_usdrx1_gt_interconnect/ARESETN]     [get_bd_pins processing_system7_1/FCLK_RESET0_N]
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_usdrx1_gt_interconnect/S00_ARESETN] [get_bd_pins processing_system7_1/FCLK_RESET0_N]
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_usdrx1_gt_interconnect/M00_ARESETN] [get_bd_pins processing_system7_1/FCLK_RESET0_N]
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_usdrx1_gt/s_axi_aresetn] 
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_usdrx1_gt/m_axi_aresetn] 
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_usdrx1_jesd/s_axi_aresetn] 
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_ad9671_core_0/s_axi_aresetn] 
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_ad9671_core_1/s_axi_aresetn] 
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_ad9671_core_2/s_axi_aresetn] 
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_ad9671_core_3/s_axi_aresetn] 
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_usdrx1_dma/s_axi_aresetn] 
connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins axi_usdrx1_spi/s_axi_aresetn] 

connect_bd_net -net processing_system7_1_fclk_reset2_n [get_bd_pins axi_usdrx1_dma_interconnect/ARESETN]      [get_bd_pins processing_system7_1/FCLK_RESET2_N]
connect_bd_net -net processing_system7_1_fclk_reset2_n [get_bd_pins axi_usdrx1_dma_interconnect/S00_ARESETN]  [get_bd_pins processing_system7_1/FCLK_RESET2_N]
connect_bd_net -net processing_system7_1_fclk_reset2_n [get_bd_pins axi_usdrx1_dma_interconnect/M00_ARESETN]  [get_bd_pins processing_system7_1/FCLK_RESET2_N]
connect_bd_net -net processing_system7_1_fclk_reset2_n [get_bd_pins axi_usdrx1_dma/m_dest_axi_aresetn] 

connect_bd_net -net xlconcat_din_3 [get_bd_pins xlconcat_1/In3] [get_bd_pins axi_usdrx1_dma/irq] 
connect_bd_net -net xlconcat_din_4 [get_bd_pins xlconcat_1/In4] [get_bd_pins axi_usdrx1_spi/ip2intc_irpt]

connect_bd_net -net axi_ad9671_core_adc_clk         [get_bd_pins axi_ad9671_core_0/adc_clk]         [get_bd_pins axi_usdrx1_dma/fifo_wr_clk]
connect_bd_net -net axi_ad9671_core_0_adc_dwr       [get_bd_pins axi_ad9671_core_0/adc_dwr]         [get_bd_pins dma_concat_wr/In0]
connect_bd_net -net axi_ad9671_core_1_adc_dwr       [get_bd_pins axi_ad9671_core_1/adc_dwr]         [get_bd_pins dma_concat_wr/In1]
connect_bd_net -net axi_ad9671_core_2_adc_dwr       [get_bd_pins axi_ad9671_core_2/adc_dwr]         [get_bd_pins dma_concat_wr/In2]
connect_bd_net -net axi_ad9671_core_3_adc_dwr       [get_bd_pins axi_ad9671_core_3/adc_dwr]         [get_bd_pins dma_concat_wr/In3]
connect_bd_net -net axi_ad9671_core_0_adc_dsync     [get_bd_pins axi_ad9671_core_0/adc_dsync]       [get_bd_pins dma_concat_sync/In0]
connect_bd_net -net axi_ad9671_core_1_adc_dsync     [get_bd_pins axi_ad9671_core_1/adc_dsync]       [get_bd_pins dma_concat_sync/In1]
connect_bd_net -net axi_ad9671_core_2_adc_dsync     [get_bd_pins axi_ad9671_core_2/adc_dsync]       [get_bd_pins dma_concat_sync/In2]
connect_bd_net -net axi_ad9671_core_3_adc_dsync     [get_bd_pins axi_ad9671_core_3/adc_dsync]       [get_bd_pins dma_concat_sync/In3]
connect_bd_net -net axi_ad9671_core_0_adc_ddata     [get_bd_pins axi_ad9671_core_0/adc_ddata]       [get_bd_pins dma_concat_data/In0]
connect_bd_net -net axi_ad9671_core_1_adc_ddata     [get_bd_pins axi_ad9671_core_1/adc_ddata]       [get_bd_pins dma_concat_data/In1]
connect_bd_net -net axi_ad9671_core_2_adc_ddata     [get_bd_pins axi_ad9671_core_2/adc_ddata]       [get_bd_pins dma_concat_data/In2]
connect_bd_net -net axi_ad9671_core_3_adc_ddata     [get_bd_pins axi_ad9671_core_3/adc_ddata]       [get_bd_pins dma_concat_data/In3]
connect_bd_net -net dma_concat_wr_dout              [get_bd_pins dma_concat_wr/dout]                [get_bd_pins dma_concat_wr_or/Op1]
connect_bd_net -net dma_concat_sync_dout            [get_bd_pins dma_concat_sync/dout]              [get_bd_pins dma_concat_sync_or/Op1]
connect_bd_net -net dma_concat_wr_or_res            [get_bd_pins dma_concat_wr_or/Res]              [get_bd_pins axi_usdrx1_dma/fifo_wr_en]
connect_bd_net -net dma_concat_sync_or_res          [get_bd_pins dma_concat_sync_or/Res]            [get_bd_pins axi_usdrx1_dma/fifo_wr_sync]
connect_bd_net -net dma_concat_wr_adc_ddata         [get_bd_pins dma_concat_data/dout]              [get_bd_pins axi_usdrx1_dma/fifo_wr_din]
connect_bd_net -net axi_ad9671_adc_dovf             [get_bd_pins axi_usdrx1_dma/fifo_wr_overflow]
connect_bd_net -net axi_ad9671_adc_dovf             [get_bd_pins axi_ad9671_core_0/adc_dovf]
connect_bd_net -net axi_ad9671_adc_dovf             [get_bd_pins axi_ad9671_core_1/adc_dovf]
connect_bd_net -net axi_ad9671_adc_dovf             [get_bd_pins axi_ad9671_core_2/adc_dovf]
connect_bd_net -net axi_ad9671_adc_dovf             [get_bd_pins axi_ad9671_core_3/adc_dovf]

connect_bd_net -net axi_usdrx1_gt_rx_rst            [get_bd_pins axi_usdrx1_gt/rx_rst]              [get_bd_pins axi_usdrx1_jesd/rx_reset]
connect_bd_net -net axi_usdrx1_gt_rx_clk            [get_bd_pins axi_usdrx1_gt/rx_clk]              [get_bd_pins axi_usdrx1_jesd/rx_core_clk]
connect_bd_net -net axi_usdrx1_gt_rx_sysref         [get_bd_pins axi_usdrx1_gt/rx_sysref]           [get_bd_pins axi_usdrx1_jesd/rx_sysref]
connect_bd_net -net axi_usdrx1_gt_rx_gt_charisk     [get_bd_pins axi_usdrx1_gt/rx_gt_charisk]       [get_bd_pins axi_usdrx1_jesd/gt_rxcharisk_in]
connect_bd_net -net axi_usdrx1_gt_rx_gt_disperr     [get_bd_pins axi_usdrx1_gt/rx_gt_disperr]       [get_bd_pins axi_usdrx1_jesd/gt_rxdisperr_in]
connect_bd_net -net axi_usdrx1_gt_rx_gt_notintable  [get_bd_pins axi_usdrx1_gt/rx_gt_notintable]    [get_bd_pins axi_usdrx1_jesd/gt_rxnotintable_in]
connect_bd_net -net axi_usdrx1_gt_rx_gt_data        [get_bd_pins axi_usdrx1_gt/rx_gt_data]          [get_bd_pins axi_usdrx1_jesd/gt_rxdata_in]
connect_bd_net -net axi_usdrx1_gt_rx_rst_done       [get_bd_pins axi_usdrx1_gt/rx_rst_done]         [get_bd_pins axi_usdrx1_jesd/rx_reset_done]
connect_bd_net -net axi_usdrx1_gt_rx_ip_comma_align [get_bd_pins axi_usdrx1_gt/rx_ip_comma_align]   [get_bd_pins axi_usdrx1_jesd/rxencommaalign_out]
connect_bd_net -net axi_usdrx1_gt_rx_ip_sync        [get_bd_pins axi_usdrx1_gt/rx_ip_sync]          [get_bd_pins axi_usdrx1_jesd/rx_sync]
connect_bd_net -net axi_usdrx1_gt_rx_ip_sof         [get_bd_pins axi_usdrx1_gt/rx_ip_sof]           [get_bd_pins axi_usdrx1_jesd/rx_start_of_frame]
connect_bd_net -net axi_usdrx1_gt_rx_ip_data        [get_bd_pins axi_usdrx1_gt/rx_ip_data]          [get_bd_pins axi_usdrx1_jesd/rx_tdata]
connect_bd_net -net axi_usdrx1_gt_rx_clk            [get_bd_pins axi_ad9671_core_0/rx_clk]          
connect_bd_net -net axi_usdrx1_gt_rx_clk            [get_bd_pins axi_ad9671_core_1/rx_clk]          
connect_bd_net -net axi_usdrx1_gt_rx_clk            [get_bd_pins axi_ad9671_core_2/rx_clk]          
connect_bd_net -net axi_usdrx1_gt_rx_clk            [get_bd_pins axi_ad9671_core_3/rx_clk]          

connect_bd_net -net axi_usdrx1_gt_rx_data           [get_bd_pins axi_usdrx1_gt/rx_data]
connect_bd_net -net axi_usdrx1_gt_rx_data           [get_bd_pins gt_slice_data_0/Din]
connect_bd_net -net axi_usdrx1_gt_rx_data           [get_bd_pins gt_slice_data_1/Din]
connect_bd_net -net axi_usdrx1_gt_rx_data           [get_bd_pins gt_slice_data_2/Din]
connect_bd_net -net axi_usdrx1_gt_rx_data           [get_bd_pins gt_slice_data_3/Din]
connect_bd_net -net gt_slice_data_0_dout            [get_bd_pins axi_ad9671_core_0/rx_data]         [get_bd_pins gt_slice_data_0/Dout]
connect_bd_net -net gt_slice_data_1_dout            [get_bd_pins axi_ad9671_core_1/rx_data]         [get_bd_pins gt_slice_data_1/Dout]
connect_bd_net -net gt_slice_data_2_dout            [get_bd_pins axi_ad9671_core_2/rx_data]         [get_bd_pins gt_slice_data_2/Dout]
connect_bd_net -net gt_slice_data_3_dout            [get_bd_pins axi_ad9671_core_3/rx_data]         [get_bd_pins gt_slice_data_3/Dout]

connect_bd_net -net axi_usdrx1_gt_ref_clk_q         [get_bd_pins axi_usdrx1_gt/ref_clk_q]           [get_bd_ports rx_ref_clk]   
connect_bd_net -net axi_usdrx1_gt_rx_data_p         [get_bd_pins axi_usdrx1_gt/rx_data_p]           [get_bd_ports rx_data_p]   
connect_bd_net -net axi_usdrx1_gt_rx_data_n         [get_bd_pins axi_usdrx1_gt/rx_data_n]           [get_bd_ports rx_data_n]   
connect_bd_net -net axi_usdrx1_gt_rx_sync           [get_bd_pins axi_usdrx1_gt/rx_sync]             [get_bd_ports rx_sync]  
connect_bd_net -net axi_usdrx1_gt_rx_sysref         [get_bd_ports rx_sysref]   

connect_bd_net -net axi_spi_1_csn_i                 [get_bd_ports spi_csn_i]                        [get_bd_pins axi_usdrx1_spi/ss_i]
connect_bd_net -net axi_spi_1_csn_o                 [get_bd_ports spi_csn_o]                        [get_bd_pins axi_usdrx1_spi/ss_o]
connect_bd_net -net axi_spi_1_clk_i                 [get_bd_ports spi_clk_i]                        [get_bd_pins axi_usdrx1_spi/sck_i]
connect_bd_net -net axi_spi_1_clk_o                 [get_bd_ports spi_clk_o]                        [get_bd_pins axi_usdrx1_spi/sck_o]
connect_bd_net -net axi_spi_1_sdo_i                 [get_bd_ports spi_sdo_i]                        [get_bd_pins axi_usdrx1_spi/io0_i]
connect_bd_net -net axi_spi_1_sdo_o                 [get_bd_ports spi_sdo_o]                        [get_bd_pins axi_usdrx1_spi/io0_o]
connect_bd_net -net axi_spi_1_sdi_i                 [get_bd_ports spi_sdi_i]                        [get_bd_pins axi_usdrx1_spi/io1_i]

# ila

connect_bd_net -net axi_usdrx1_gt_rx_clk            [get_bd_pins ila_jesd_rx_mon/CLK]
connect_bd_net -net axi_usdrx1_gt_rx_mon_data       [get_bd_pins axi_usdrx1_gt/rx_mon_data]         [get_bd_pins ila_jesd_rx_mon/PROBE0]
connect_bd_net -net axi_usdrx1_gt_rx_mon_trigger    [get_bd_pins axi_usdrx1_gt/rx_mon_trigger]      [get_bd_pins ila_jesd_rx_mon/PROBE1]

# address map

create_bd_addr_seg -range 0x00010000 -offset 0x40800000 [get_bd_addr_spaces processing_system7_1/Data]  [get_bd_addr_segs axi_iic_1/s_axi/Reg]                SEG_data_iic_1

create_bd_addr_seg -range 0x00010000 -offset 0x44a20000 [get_bd_addr_spaces processing_system7_1/Data]  [get_bd_addr_segs axi_hdmi_clkgen/s_axi/axi_lite]     SEG_data_hdmi_clkgen
create_bd_addr_seg -range 0x00010000 -offset 0x44a80000 [get_bd_addr_spaces processing_system7_1/Data]  [get_bd_addr_segs axi_hdmi_dma/S_AXI_LITE/Reg]        SEG_data_hdmi_dma
create_bd_addr_seg -range 0x00010000 -offset 0x44a50000 [get_bd_addr_spaces processing_system7_1/Data]  [get_bd_addr_segs axi_hdmi_core/s_axi/axi_lite]       SEG_data_hdmi_core

create_bd_addr_seg -range 0x00010000 -offset 0x43c70000 [get_bd_addr_spaces processing_system7_1/Data]  [get_bd_addr_segs axi_usdrx1_gt/s_axi/axi_lite]       SEG_data_usdrx1_gt
create_bd_addr_seg -range 0x00001000 -offset 0x43c80000 [get_bd_addr_spaces processing_system7_1/Data]  [get_bd_addr_segs axi_usdrx1_jesd/s_axi/Reg]          SEG_data_usdrx1_jesd
create_bd_addr_seg -range 0x00010000 -offset 0x43c00000 [get_bd_addr_spaces processing_system7_1/Data]  [get_bd_addr_segs axi_ad9671_core_0/s_axi/axi_lite]   SEG_data_ad9671_core_0
create_bd_addr_seg -range 0x00010000 -offset 0x43c10000 [get_bd_addr_spaces processing_system7_1/Data]  [get_bd_addr_segs axi_ad9671_core_1/s_axi/axi_lite]   SEG_data_ad9671_core_1
create_bd_addr_seg -range 0x00010000 -offset 0x43c20000 [get_bd_addr_spaces processing_system7_1/Data]  [get_bd_addr_segs axi_ad9671_core_2/s_axi/axi_lite]   SEG_data_ad9671_core_2
create_bd_addr_seg -range 0x00010000 -offset 0x43c30000 [get_bd_addr_spaces processing_system7_1/Data]  [get_bd_addr_segs axi_ad9671_core_3/s_axi/axi_lite]   SEG_data_ad9671_core_3
create_bd_addr_seg -range 0x00010000 -offset 0x43c40000 [get_bd_addr_spaces processing_system7_1/Data]  [get_bd_addr_segs axi_usdrx1_dma/s_axi/axi_lite]      SEG_data_usdrx1_dma
create_bd_addr_seg -range 0x00010000 -offset 0x41e00000 [get_bd_addr_spaces processing_system7_1/Data]  [get_bd_addr_segs axi_usdrx1_spi/axi_lite/Reg]        SEG_data_usdrx1_spi

create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces axi_hdmi_dma/Data_MM2S]     [get_bd_addr_segs processing_system7_1/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_1_HP0_DDR_LOWOCM
create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces axi_usdrx1_dma/m_dest_axi]  [get_bd_addr_segs processing_system7_1/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_processing_system7_1_HP3_DDR_LOWOCM
create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces axi_usdrx1_gt/m_axi]        [get_bd_addr_segs processing_system7_1/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_1_HP2_DDR_LOWOCM

