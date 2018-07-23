
# create board design
# interface ports

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr
create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 fixed_io
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_main

create_bd_port -dir O spi0_csn_2_o
create_bd_port -dir O spi0_csn_1_o
create_bd_port -dir O spi0_csn_0_o
create_bd_port -dir I spi0_csn_i
create_bd_port -dir I spi0_clk_i
create_bd_port -dir O spi0_clk_o
create_bd_port -dir I spi0_sdo_i
create_bd_port -dir O spi0_sdo_o
create_bd_port -dir I spi0_sdi_i

create_bd_port -dir O spi1_csn_2_o
create_bd_port -dir O spi1_csn_1_o
create_bd_port -dir O spi1_csn_0_o
create_bd_port -dir I spi1_csn_i
create_bd_port -dir I spi1_clk_i
create_bd_port -dir O spi1_clk_o
create_bd_port -dir I spi1_sdo_i
create_bd_port -dir O spi1_sdo_o
create_bd_port -dir I spi1_sdi_i

create_bd_port -dir I -from 63 -to 0 gpio_i
create_bd_port -dir O -from 63 -to 0 gpio_o
create_bd_port -dir O -from 63 -to 0 gpio_t

# hdmi interface

create_bd_port -dir O hdmi_out_clk
create_bd_port -dir O hdmi_hsync
create_bd_port -dir O hdmi_vsync
create_bd_port -dir O hdmi_data_e
create_bd_port -dir O -from 15 -to 0 hdmi_data

# spdif audio

create_bd_port -dir O spdif

# interrupts

create_bd_port -dir I -type intr ps_intr_00
create_bd_port -dir I -type intr ps_intr_01
create_bd_port -dir I -type intr ps_intr_02
create_bd_port -dir I -type intr ps_intr_03
create_bd_port -dir I -type intr ps_intr_04
create_bd_port -dir I -type intr ps_intr_05
create_bd_port -dir I -type intr ps_intr_06
create_bd_port -dir I -type intr ps_intr_07
create_bd_port -dir I -type intr ps_intr_08
create_bd_port -dir I -type intr ps_intr_09
create_bd_port -dir I -type intr ps_intr_10
create_bd_port -dir I -type intr ps_intr_11
create_bd_port -dir I -type intr ps_intr_12
create_bd_port -dir I -type intr ps_intr_13

# instance: sys_ps7

ad_ip_instance processing_system7 sys_ps7
ad_ip_parameter sys_ps7 CONFIG.PCW_IMPORT_BOARD_PRESET ZC702
ad_ip_parameter sys_ps7 CONFIG.PCW_TTC0_PERIPHERAL_ENABLE 0
ad_ip_parameter sys_ps7 CONFIG.PCW_EN_CLK1_PORT 1
ad_ip_parameter sys_ps7 CONFIG.PCW_EN_RST1_PORT 1
ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ 100.0
ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ 200.0
ad_ip_parameter sys_ps7 CONFIG.PCW_USE_FABRIC_INTERRUPT 1
ad_ip_parameter sys_ps7 CONFIG.PCW_USE_S_AXI_HP0 1
ad_ip_parameter sys_ps7 CONFIG.PCW_IRQ_F2P_INTR 1
ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_EMIO_GPIO_IO 64
ad_ip_parameter sys_ps7 CONFIG.PCW_USE_DMA0 1
ad_ip_parameter sys_ps7 CONFIG.PCW_SPI0_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_SPI0_SPI0_IO EMIO
ad_ip_parameter sys_ps7 CONFIG.PCW_SPI1_PERIPHERAL_ENABLE 1
ad_ip_parameter sys_ps7 CONFIG.PCW_SPI1_SPI1_IO EMIO

ad_ip_instance axi_iic axi_iic_main
ad_ip_parameter axi_iic_main CONFIG.USE_BOARD_FLOW true
ad_ip_parameter axi_iic_main CONFIG.IIC_BOARD_INTERFACE IIC_MAIN

ad_ip_instance xlconcat sys_concat_intc
ad_ip_parameter sys_concat_intc CONFIG.NUM_PORTS 16

ad_ip_instance proc_sys_reset sys_rstgen
ad_ip_parameter sys_rstgen CONFIG.C_EXT_RST_WIDTH 1

# hdmi peripherals

ad_ip_instance axi_clkgen axi_hdmi_clkgen
ad_ip_instance axi_hdmi_tx axi_hdmi_core
ad_ip_parameter axi_hdmi_core CONFIG.INTERFACE 16_BIT

ad_ip_instance axi_vdma axi_hdmi_dma
ad_ip_parameter axi_hdmi_dma CONFIG.c_m_axis_mm2s_tdata_width 64
ad_ip_parameter axi_hdmi_dma CONFIG.c_use_mm2s_fsync 1
ad_ip_parameter axi_hdmi_dma CONFIG.c_include_s2mm 0

# audio peripherals

ad_ip_instance clk_wiz sys_audio_clkgen
ad_ip_parameter sys_audio_clkgen CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 12.288
ad_ip_parameter sys_audio_clkgen CONFIG.USE_LOCKED false
ad_ip_parameter sys_audio_clkgen CONFIG.USE_RESET true
ad_ip_parameter sys_audio_clkgen CONFIG.USE_PHASE_ALIGNMENT false
ad_ip_parameter sys_audio_clkgen CONFIG.RESET_TYPE ACTIVE_LOW
ad_ip_parameter sys_audio_clkgen CONFIG.PRIM_SOURCE No_buffer

ad_ip_instance axi_spdif_tx axi_spdif_tx_core
ad_ip_parameter axi_spdif_tx_core CONFIG.DMA_TYPE 1
ad_ip_parameter axi_spdif_tx_core CONFIG.S_AXI_ADDRESS_WIDTH 16

# system reset/clock definitions

ad_connect  sys_cpu_clk sys_ps7/FCLK_CLK0
ad_connect  sys_200m_clk sys_ps7/FCLK_CLK1
ad_connect  sys_cpu_reset sys_rstgen/peripheral_reset
ad_connect  sys_cpu_resetn sys_rstgen/peripheral_aresetn
ad_connect  sys_cpu_clk sys_rstgen/slowest_sync_clk
ad_connect  sys_rstgen/ext_reset_in sys_ps7/FCLK_RESET0_N

# interface connections

ad_connect  ddr sys_ps7/DDR
ad_connect  gpio_i sys_ps7/GPIO_I
ad_connect  gpio_o sys_ps7/GPIO_O
ad_connect  gpio_t sys_ps7/GPIO_T
ad_connect  fixed_io sys_ps7/FIXED_IO
ad_connect  iic_main axi_iic_main/iic
ad_connect  sys_200m_clk axi_hdmi_clkgen/clk

# spi connections

ad_connect  spi0_csn_2_o sys_ps7/SPI0_SS2_O
ad_connect  spi0_csn_1_o sys_ps7/SPI0_SS1_O
ad_connect  spi0_csn_0_o sys_ps7/SPI0_SS_O
ad_connect  spi0_csn_i sys_ps7/SPI0_SS_I
ad_connect  spi0_clk_i sys_ps7/SPI0_SCLK_I
ad_connect  spi0_clk_o sys_ps7/SPI0_SCLK_O
ad_connect  spi0_sdo_i sys_ps7/SPI0_MOSI_I
ad_connect  spi0_sdo_o sys_ps7/SPI0_MOSI_O
ad_connect  spi0_sdi_i sys_ps7/SPI0_MISO_I

ad_connect  spi1_csn_2_o sys_ps7/SPI1_SS2_O
ad_connect  spi1_csn_1_o sys_ps7/SPI1_SS1_O
ad_connect  spi1_csn_0_o sys_ps7/SPI1_SS_O
ad_connect  spi1_csn_i sys_ps7/SPI1_SS_I
ad_connect  spi1_clk_i sys_ps7/SPI1_SCLK_I
ad_connect  spi1_clk_o sys_ps7/SPI1_SCLK_O
ad_connect  spi1_sdo_i sys_ps7/SPI1_MOSI_I
ad_connect  spi1_sdo_o sys_ps7/SPI1_MOSI_O
ad_connect  spi1_sdi_i sys_ps7/SPI1_MISO_I

# hdmi

ad_connect  sys_cpu_clk axi_hdmi_core/vdma_clk
ad_connect  sys_cpu_clk axi_hdmi_dma/m_axis_mm2s_aclk
ad_connect  axi_hdmi_core/hdmi_clk axi_hdmi_clkgen/clk_0
ad_connect  axi_hdmi_core/hdmi_out_clk hdmi_out_clk
ad_connect  axi_hdmi_core/hdmi_16_hsync hdmi_hsync
ad_connect  axi_hdmi_core/hdmi_16_vsync hdmi_vsync
ad_connect  axi_hdmi_core/hdmi_16_data_e hdmi_data_e
ad_connect  axi_hdmi_core/hdmi_16_data hdmi_data
ad_connect  axi_hdmi_core/vdma_valid axi_hdmi_dma/m_axis_mm2s_tvalid
ad_connect  axi_hdmi_core/vdma_data axi_hdmi_dma/m_axis_mm2s_tdata
ad_connect  axi_hdmi_core/vdma_ready axi_hdmi_dma/m_axis_mm2s_tready
ad_connect  axi_hdmi_core/vdma_fs axi_hdmi_dma/mm2s_fsync
ad_connect  axi_hdmi_core/vdma_fs axi_hdmi_core/vdma_fs_ret

# spdif audio

ad_connect  sys_cpu_clk axi_spdif_tx_core/DMA_REQ_ACLK
ad_connect  sys_cpu_clk sys_ps7/DMA0_ACLK
ad_connect  sys_cpu_resetn axi_spdif_tx_core/DMA_REQ_RSTN
ad_connect  sys_ps7/DMA0_REQ axi_spdif_tx_core/DMA_REQ
ad_connect  sys_ps7/DMA0_ACK axi_spdif_tx_core/DMA_ACK
ad_connect  sys_200m_clk sys_audio_clkgen/clk_in1
ad_connect  sys_cpu_resetn sys_audio_clkgen/resetn
ad_connect  sys_audio_clkgen/clk_out1 axi_spdif_tx_core/spdif_data_clk
ad_connect  spdif axi_spdif_tx_core/spdif_tx_o

# match up interconnects

ad_connect  sys_concat_intc/dout sys_ps7/IRQ_F2P
ad_connect  sys_concat_intc/In15 axi_hdmi_dma/mm2s_introut
ad_connect  sys_concat_intc/In14 axi_iic_main/iic2intc_irpt
ad_connect  sys_concat_intc/In13 ps_intr_13
ad_connect  sys_concat_intc/In12 ps_intr_12
ad_connect  sys_concat_intc/In11 ps_intr_11
ad_connect  sys_concat_intc/In10 ps_intr_10
ad_connect  sys_concat_intc/In9 ps_intr_09
ad_connect  sys_concat_intc/In8 ps_intr_08
ad_connect  sys_concat_intc/In7 ps_intr_07
ad_connect  sys_concat_intc/In6 ps_intr_06
ad_connect  sys_concat_intc/In5 ps_intr_05
ad_connect  sys_concat_intc/In4 ps_intr_04
ad_connect  sys_concat_intc/In3 ps_intr_03
ad_connect  sys_concat_intc/In2 ps_intr_02
ad_connect  sys_concat_intc/In1 ps_intr_01
ad_connect  sys_concat_intc/In0 ps_intr_00

# address map

ad_cpu_interconnect 0x41600000 axi_iic_main
ad_cpu_interconnect 0x79000000 axi_hdmi_clkgen
ad_cpu_interconnect 0x43000000 axi_hdmi_dma
ad_cpu_interconnect 0x70e00000 axi_hdmi_core
ad_cpu_interconnect 0x75c00000 axi_spdif_tx_core
ad_mem_hp0_interconnect sys_cpu_clk sys_ps7/S_AXI_HP0
ad_mem_hp0_interconnect sys_cpu_clk axi_hdmi_dma/M_AXI_MM2S
