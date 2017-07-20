
# unused

ad_connect  sys_ps7/ENET1_GMII_RX_CLK GND
ad_connect  sys_ps7/ENET1_GMII_TX_CLK GND

# GPS-UART

set_property CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UART0_UART0_IO {MIO 14 .. 15} [get_bd_cells sys_ps7]
set_property CONFIG.PCW_USE_DMA0 1 [get_bd_cells sys_ps7]
set_property CONFIG.PCW_USE_DMA1 1 [get_bd_cells sys_ps7]

# i2s

create_bd_port -dir O -type clk i2s_mclk
create_bd_intf_port -mode Master -vlnv analog.com:interface:i2s_rtl:1.0 i2s

set sys_audio_clkgen [create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.3 sys_audio_clkgen]
set_property -dict [list CONFIG.PRIM_IN_FREQ {200.000}] $sys_audio_clkgen
set_property -dict [list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {12.288}] $sys_audio_clkgen
set_property -dict [list CONFIG.USE_LOCKED {false}] $sys_audio_clkgen
set_property -dict [list CONFIG.USE_RESET {true} CONFIG.RESET_TYPE {ACTIVE_LOW}] $sys_audio_clkgen

set axi_i2s_adi [create_bd_cell -type ip -vlnv analog.com:user:axi_i2s_adi:1.0 axi_i2s_adi]
set_property -dict [list CONFIG.DMA_TYPE {1}] $axi_i2s_adi
set_property -dict [list CONFIG.S_AXI_ADDRESS_WIDTH {16}] $axi_i2s_adi

ad_connect  sys_200m_clk sys_audio_clkgen/clk_in1
ad_connect  sys_cpu_resetn sys_audio_clkgen/resetn
ad_connect  sys_cpu_clk axi_i2s_adi/DMA_REQ_RX_ACLK
ad_connect  sys_cpu_clk axi_i2s_adi/DMA_REQ_TX_ACLK
ad_connect  sys_cpu_clk sys_ps7/DMA0_ACLK
ad_connect  sys_cpu_clk sys_ps7/DMA1_ACLK
ad_connect  sys_cpu_resetn axi_i2s_adi/DMA_REQ_RX_RSTN
ad_connect  sys_cpu_resetn axi_i2s_adi/DMA_REQ_TX_RSTN
ad_connect  sys_ps7/DMA0_REQ axi_i2s_adi/DMA_REQ_TX
ad_connect  sys_ps7/DMA0_ACK axi_i2s_adi/DMA_ACK_TX
ad_connect  sys_ps7/DMA1_REQ axi_i2s_adi/DMA_REQ_RX
ad_connect  sys_ps7/DMA1_ACK axi_i2s_adi/DMA_ACK_RX
ad_connect  sys_audio_clkgen/clk_out1 i2s_mclk
ad_connect  sys_audio_clkgen/clk_out1 axi_i2s_adi/DATA_CLK_I
ad_connect  i2s axi_i2s_adi/I2S

ad_cpu_interconnect 0x77600000 axi_i2s_adi

