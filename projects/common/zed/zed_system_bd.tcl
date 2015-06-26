
# create board design
# interface ports

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr
create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 fixed_io
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_fmc

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

# i2s

create_bd_port -dir O -type clk i2s_mclk
create_bd_intf_port -mode Master -vlnv analog.com:interface:i2s_rtl:1.0 i2s

# iic mux

create_bd_port -dir I -from 1 -to 0 iic_mux_scl_i
create_bd_port -dir O -from 1 -to 0 iic_mux_scl_o
create_bd_port -dir O iic_mux_scl_t
create_bd_port -dir I -from 1 -to 0 iic_mux_sda_i
create_bd_port -dir O -from 1 -to 0 iic_mux_sda_o
create_bd_port -dir O iic_mux_sda_t

create_bd_port -dir I otg_vbusoc

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
create_bd_port -dir I -type intr ps_intr_12
create_bd_port -dir I -type intr ps_intr_13

# instance: sys_ps7

set sys_ps7  [create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 sys_ps7]
set_property -dict [list CONFIG.PCW_IMPORT_BOARD_PRESET {ZedBoard}] $sys_ps7
set_property -dict [list CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_CLK1_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_RST1_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100.0}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {200.0}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_FABRIC_INTERRUPT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP0 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_IRQ_F2P_INTR {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO {64}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_DMA0 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_DMA1 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_DMA2 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_IRQ_F2P_MODE {REVERSE}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI0_SPI0_IO {EMIO}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI1_SPI1_IO {EMIO}] $sys_ps7

set axi_iic_main [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_main]
set_property -dict [list CONFIG.USE_BOARD_FLOW {true} ] $axi_iic_main
set_property -dict [list CONFIG.IIC_BOARD_INTERFACE {Custom}] $axi_iic_main

set sys_i2c_mixer [create_bd_cell -type ip -vlnv analog.com:user:util_i2c_mixer:1.0 sys_i2c_mixer]

set sys_concat_intc [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 sys_concat_intc]
set_property -dict [list CONFIG.NUM_PORTS {16}] $sys_concat_intc

set sys_rstgen [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 sys_rstgen]
set_property -dict [list CONFIG.C_EXT_RST_WIDTH {1}] $sys_rstgen

set sys_logic_inv [create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 sys_logic_inv]
set_property -dict [list CONFIG.C_SIZE {1}] $sys_logic_inv
set_property -dict [list CONFIG.C_OPERATION {not}] $sys_logic_inv

# hdmi peripherals

set axi_hdmi_clkgen [create_bd_cell -type ip -vlnv analog.com:user:axi_clkgen:1.0 axi_hdmi_clkgen]
set axi_hdmi_core [create_bd_cell -type ip -vlnv analog.com:user:axi_hdmi_tx:1.0 axi_hdmi_core]

set axi_hdmi_dma [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.2 axi_hdmi_dma]
set_property -dict [list CONFIG.c_m_axis_mm2s_tdata_width {64}] $axi_hdmi_dma
set_property -dict [list CONFIG.c_use_mm2s_fsync {1}] $axi_hdmi_dma
set_property -dict [list CONFIG.c_include_s2mm {0}] $axi_hdmi_dma

# audio peripherals

set sys_audio_clkgen [create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.1 sys_audio_clkgen]
set_property -dict [list CONFIG.PRIM_IN_FREQ {200.000}] $sys_audio_clkgen
set_property -dict [list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {12.288}] $sys_audio_clkgen
set_property -dict [list CONFIG.USE_LOCKED {false}] $sys_audio_clkgen
set_property -dict [list CONFIG.USE_RESET {true} CONFIG.RESET_TYPE {ACTIVE_LOW}] $sys_audio_clkgen

set axi_spdif_tx_core [create_bd_cell -type ip -vlnv analog.com:user:axi_spdif_tx:1.0 axi_spdif_tx_core]
set_property -dict [list CONFIG.C_DMA_TYPE {1}] $axi_spdif_tx_core
set_property -dict [list CONFIG.C_S_AXI_ADDR_WIDTH {16}] $axi_spdif_tx_core

set axi_i2s_adi [create_bd_cell -type ip -vlnv analog.com:user:axi_i2s_adi:1.0 axi_i2s_adi]
set_property -dict [list CONFIG.C_DMA_TYPE {1}] $axi_i2s_adi
set_property -dict [list CONFIG.C_S_AXI_ADDR_WIDTH {16}] $axi_i2s_adi

# iic (fmc)

set axi_iic_fmc [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_fmc]

# system reset/clock definitions

ad_connect  sys_cpu_clk sys_ps7/FCLK_CLK0
ad_connect  sys_200m_clk sys_ps7/FCLK_CLK1
ad_connect  sys_cpu_reset sys_rstgen/peripheral_reset
ad_connect  sys_cpu_resetn sys_rstgen/peripheral_aresetn
ad_connect  sys_cpu_clk sys_rstgen/slowest_sync_clk
ad_connect  sys_rstgen/ext_reset_in sys_ps7/FCLK_RESET0_N

# interface connections

ad_connect  ddr       sys_ps7/DDR
ad_connect  gpio_i    sys_ps7/GPIO_I
ad_connect  gpio_o    sys_ps7/GPIO_O
ad_connect  gpio_t    sys_ps7/GPIO_T
ad_connect  fixed_io  sys_ps7/FIXED_IO
ad_connect  iic_fmc   axi_iic_fmc/iic
ad_connect  sys_200m_clk axi_hdmi_clkgen/clk

ad_connect  axi_iic_main/IIC sys_i2c_mixer/upstream

ad_connect  iic_mux_scl_i   sys_i2c_mixer/downstream_scl_i
ad_connect  iic_mux_scl_o   sys_i2c_mixer/downstream_scl_o
ad_connect  iic_mux_scl_t   sys_i2c_mixer/downstream_scl_t
ad_connect  iic_mux_sda_i   sys_i2c_mixer/downstream_sda_i
ad_connect  iic_mux_sda_o   sys_i2c_mixer/downstream_sda_o
ad_connect  iic_mux_sda_t   sys_i2c_mixer/downstream_sda_t

ad_connect  sys_logic_inv/Res sys_ps7/USB0_VBUS_PWRFAULT
ad_connect  otg_vbusoc  sys_logic_inv/Op1

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

ad_connect  sys_cpu_clk   axi_hdmi_core/m_axis_mm2s_clk
ad_connect  sys_cpu_clk   axi_hdmi_dma/s_axi_lite_aclk
ad_connect  sys_cpu_clk   axi_hdmi_dma/m_axi_mm2s_aclk
ad_connect  sys_cpu_clk   axi_hdmi_dma/m_axis_mm2s_aclk

ad_connect  axi_hdmi_core/hdmi_clk             axi_hdmi_clkgen/clk_0
ad_connect  axi_hdmi_core/hdmi_out_clk         hdmi_out_clk
ad_connect  axi_hdmi_core/hdmi_16_hsync        hdmi_hsync
ad_connect  axi_hdmi_core/hdmi_16_vsync        hdmi_vsync
ad_connect  axi_hdmi_core/hdmi_16_data_e       hdmi_data_e
ad_connect  axi_hdmi_core/hdmi_16_data         hdmi_data
ad_connect  axi_hdmi_core/M_AXIS_MM2S          axi_hdmi_dma/m_axis_mm2s
ad_connect  axi_hdmi_core/m_axis_mm2s_fsync    axi_hdmi_dma/mm2s_fsync
ad_connect  axi_hdmi_core/m_axis_mm2s_fsync    axi_hdmi_core/m_axis_mm2s_fsync_ret

# spdif audio

ad_connect  sys_cpu_clk   axi_spdif_tx_core/DMA_REQ_ACLK
ad_connect  sys_cpu_clk   sys_ps7/DMA0_ACLK

ad_connect  sys_ps7/DMA0_REQ  axi_spdif_tx_core/DMA_REQ
ad_connect  sys_ps7/DMA0_ACK  axi_spdif_tx_core/DMA_ACK
ad_connect  sys_cpu_resetn    axi_spdif_tx_core/DMA_REQ_RSTN
ad_connect  sys_200m_clk      sys_audio_clkgen/clk_in1
ad_connect  sys_cpu_resetn    sys_audio_clkgen/resetn
ad_connect  sys_audio_clkgen/clk_out1 axi_spdif_tx_core/spdif_data_clk
ad_connect  spdif             axi_spdif_tx_core/spdif_tx_o

# i2s audio

ad_connect  sys_cpu_clk axi_i2s_adi/DMA_REQ_RX_ACLK
ad_connect  sys_cpu_clk axi_i2s_adi/DMA_REQ_TX_ACLK
ad_connect  sys_cpu_clk sys_ps7/DMA1_ACLK
ad_connect  sys_cpu_clk sys_ps7/DMA2_ACLK

ad_connect  sys_audio_clkgen/clk_out1   i2s_mclk
ad_connect  sys_audio_clkgen/clk_out1   axi_i2s_adi/DATA_CLK_I

ad_connect  i2s axi_i2s_adi/I2S

ad_connect  sys_ps7/DMA1_REQ   axi_i2s_adi/DMA_REQ_TX
ad_connect  sys_ps7/DMA1_ACK   axi_i2s_adi/DMA_ACK_TX
ad_connect  sys_cpu_resetn     axi_i2s_adi/DMA_REQ_TX_RSTN
ad_connect  sys_ps7/DMA2_REQ   axi_i2s_adi/DMA_REQ_RX
ad_connect  sys_ps7/DMA2_ACK   axi_i2s_adi/DMA_ACK_RX
ad_connect  sys_cpu_resetn     axi_i2s_adi/DMA_REQ_RX_RSTN

# interrupts

ad_connect  sys_concat_intc/dout  sys_ps7/IRQ_F2P
ad_connect  sys_concat_intc/In15  axi_hdmi_dma/mm2s_introut
ad_connect  sys_concat_intc/In14  axi_iic_main/iic2intc_irpt
ad_connect  sys_concat_intc/In13  ps_intr_13
ad_connect  sys_concat_intc/In12  ps_intr_12
ad_connect  sys_concat_intc/In11  axi_iic_fmc/iic2intc_irpt
ad_connect  sys_concat_intc/In10  ps_intr_10
ad_connect  sys_concat_intc/In9   ps_intr_09
ad_connect  sys_concat_intc/In8   ps_intr_08
ad_connect  sys_concat_intc/In7   ps_intr_07
ad_connect  sys_concat_intc/In6   ps_intr_06
ad_connect  sys_concat_intc/In5   ps_intr_05
ad_connect  sys_concat_intc/In4   ps_intr_04
ad_connect  sys_concat_intc/In3   ps_intr_03
ad_connect  sys_concat_intc/In2   ps_intr_02
ad_connect  sys_concat_intc/In1   ps_intr_01
ad_connect  sys_concat_intc/In0   ps_intr_00

# interconnects and address mapping

ad_cpu_interconnect 0x41600000 axi_iic_main
ad_cpu_interconnect 0x79000000 axi_hdmi_clkgen
ad_cpu_interconnect 0x43000000 axi_hdmi_dma
ad_cpu_interconnect 0x70e00000 axi_hdmi_core
ad_cpu_interconnect 0x75c00000 axi_spdif_tx_core
ad_cpu_interconnect 0x77600000 axi_i2s_adi
ad_cpu_interconnect 0x41620000 axi_iic_fmc
ad_mem_hp0_interconnect sys_cpu_clk sys_ps7/S_AXI_HP0
ad_mem_hp0_interconnect sys_cpu_clk axi_hdmi_dma/M_AXI_MM2S

