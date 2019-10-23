
# unused

ad_connect  sys_ps7/ENET1_GMII_RX_CLK GND
ad_connect  sys_ps7/ENET1_GMII_TX_CLK GND

# GPS-UART

set_property CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UART0_UART0_IO {MIO 14 .. 15} [get_bd_cells sys_ps7]
set_property CONFIG.PCW_USE_DMA0 1 [get_bd_cells sys_ps7]
set_property CONFIG.PCW_USE_DMA1 1 [get_bd_cells sys_ps7]

# enable PPS receiver

ad_ip_parameter axi_ad9361 CONFIG.PPS_RECEIVER_ENABLE 1

# i2s

create_bd_port -dir O -type clk i2s_mclk
create_bd_intf_port -mode Master -vlnv analog.com:interface:i2s_rtl:1.0 i2s

ad_ip_instance clk_wiz sys_audio_clkgen
ad_ip_parameter sys_audio_clkgen CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 12.288
ad_ip_parameter sys_audio_clkgen CONFIG.USE_LOCKED false
ad_ip_parameter sys_audio_clkgen CONFIG.USE_RESET true
ad_ip_parameter sys_audio_clkgen CONFIG.RESET_TYPE ACTIVE_LOW
ad_ip_parameter sys_audio_clkgen CONFIG.USE_PHASE_ALIGNMENT false
ad_ip_parameter sys_audio_clkgen CONFIG.PRIM_SOURCE No_buffer

ad_ip_instance axi_i2s_adi axi_i2s_adi
ad_ip_parameter axi_i2s_adi CONFIG.DMA_TYPE 1
ad_ip_parameter axi_i2s_adi CONFIG.S_AXI_ADDRESS_WIDTH 16

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

