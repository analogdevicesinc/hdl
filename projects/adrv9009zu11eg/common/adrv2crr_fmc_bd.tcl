
create_bd_port -dir O -type clk i2s_mclk
create_bd_intf_port -mode Master -vlnv analog.com:interface:i2s_rtl:1.0 i2s

create_bd_port -dir I axi_fan_tacho_i
create_bd_port -dir O axi_fan_pwm_o

# i2s ip

ad_ip_instance axi_i2s_adi axi_i2s_adi
ad_ip_parameter axi_i2s_adi CONFIG.DMA_TYPE 0
ad_ip_parameter axi_i2s_adi CONFIG.S_AXI_ADDRESS_WIDTH 32

# dma

ad_ip_instance axi_dmac i2s_tx_dma
ad_ip_parameter i2s_tx_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter i2s_tx_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter i2s_tx_dma CONFIG.CYCLIC 1
ad_ip_parameter i2s_tx_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter i2s_tx_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter i2s_tx_dma CONFIG.ASYNC_CLK_DEST_REQ 0
ad_ip_parameter i2s_tx_dma CONFIG.ASYNC_CLK_SRC_DEST 0
ad_ip_parameter i2s_tx_dma CONFIG.ASYNC_CLK_REQ_SRC 0
ad_ip_parameter i2s_tx_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter i2s_tx_dma CONFIG.DMA_DATA_WIDTH_DEST 32
ad_ip_parameter i2s_tx_dma CONFIG.DMA_DATA_WIDTH_SRC 64

ad_ip_instance axi_dmac i2s_rx_dma
ad_ip_parameter i2s_rx_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter i2s_rx_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter i2s_rx_dma CONFIG.CYCLIC 1
ad_ip_parameter i2s_rx_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter i2s_rx_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter i2s_rx_dma CONFIG.ASYNC_CLK_DEST_REQ 0
ad_ip_parameter i2s_rx_dma CONFIG.ASYNC_CLK_SRC_DEST 0
ad_ip_parameter i2s_rx_dma CONFIG.ASYNC_CLK_REQ_SRC 0
ad_ip_parameter i2s_rx_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter i2s_rx_dma CONFIG.DMA_DATA_WIDTH_DEST 64
ad_ip_parameter i2s_rx_dma CONFIG.DMA_DATA_WIDTH_SRC 32

# i2s connections

ad_connect sys_cpu_clk axi_i2s_adi/s_axi_aclk
ad_connect sys_cpu_clk axi_i2s_adi/s_axis_aclk
ad_connect sys_cpu_clk axi_i2s_adi/m_axis_aclk
ad_connect sys_cpu_resetn axi_i2s_adi/s_axi_aresetn
ad_connect sys_cpu_resetn axi_i2s_adi/s_axis_aresetn
ad_connect i2s_tx_dma/m_axis axi_i2s_adi/s_axis

# not connecting tlast

ad_connect i2s_rx_dma/s_axis_data axi_i2s_adi/m_axis_tdata
ad_connect i2s_rx_dma/s_axis_valid axi_i2s_adi/m_axis_tvalid
ad_connect i2s_rx_dma/s_axis_ready axi_i2s_adi/m_axis_tready
ad_connect i2s axi_i2s_adi/I2S
ad_connect i2s_m_clk axi_i2s_adi/data_clk_i
ad_connect i2s_m_clk i2s_mclk

ad_connect sys_cpu_clk i2s_tx_dma/s_axi_aclk
ad_connect sys_cpu_clk i2s_tx_dma/m_src_axi_aclk
ad_connect sys_cpu_clk i2s_tx_dma/m_axis_aclk
ad_connect sys_cpu_resetn i2s_tx_dma/s_axi_aresetn
ad_connect sys_cpu_resetn i2s_tx_dma/m_src_axi_aresetn

ad_connect sys_cpu_clk i2s_rx_dma/s_axi_aclk
ad_connect sys_cpu_clk i2s_rx_dma/m_dest_axi_aclk
ad_connect sys_cpu_clk i2s_rx_dma/s_axis_aclk
ad_connect sys_cpu_resetn i2s_rx_dma/s_axi_aresetn
ad_connect sys_cpu_resetn i2s_rx_dma/m_dest_axi_aresetn

# fan control

ad_ip_instance axi_fan_control axi_fan_control_0
ad_ip_parameter axi_fan_control_0 CONFIG.ID 1
ad_ip_parameter axi_fan_control_0 CONFIG.PWM_FREQUENCY_HZ 1000

ad_connect axi_fan_tacho_i axi_fan_control_0/tacho
ad_connect axi_fan_pwm_o axi_fan_control_0/pwm

# interconnect

ad_cpu_interconnect 0x40000000 axi_fan_control_0
ad_cpu_interconnect 0x41000000 i2s_rx_dma
ad_cpu_interconnect 0x41001000 i2s_tx_dma
ad_cpu_interconnect 0x42000000 axi_i2s_adi

ad_mem_hp0_interconnect sys_cpu_clk i2s_tx_dma/m_src_axi
ad_mem_hp0_interconnect sys_cpu_clk i2s_rx_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-6 mb-6 i2s_tx_dma/irq
ad_cpu_interrupt ps-7 mb-7 i2s_rx_dma/irq
ad_cpu_interrupt ps-14 mb-14 axi_fan_control_0/irq
