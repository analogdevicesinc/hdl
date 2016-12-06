
create_bd_port -dir I usb_fx3_uart_tx
create_bd_port -dir O usb_fx3_uart_rx

create_bd_port -dir I dma_rdy
create_bd_port -dir I dma_wmk
create_bd_port -dir I -from 3 -to 0 fifo_rdy
create_bd_port -dir O pclk
create_bd_port -dir IO -from 31 -to 0 data
create_bd_port -dir O -from 1 -to 0 addr
create_bd_port -dir O slcs_n
create_bd_port -dir O slrd_n
create_bd_port -dir O sloe_n
create_bd_port -dir O slwr_n
create_bd_port -dir O pktend_n
create_bd_port -dir O epswitch_n

set axi_uart [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uart]
set_property -dict [list CONFIG.C_BAUDRATE {115200}] $axi_uart

set axi_usb_fx3 [create_bd_cell -type ip -vlnv analog.com:user:axi_usb_fx3:1.0 axi_usb_fx3]

set axi_usb_fx3_dma [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_usb_fx3_dma]
set_property -dict [list CONFIG.c_sg_include_stscntrl_strm {0}] $axi_usb_fx3_dma
set_property -dict [list CONFIG.c_mm2s_burst_size {256}] $axi_usb_fx3_dma
set_property -dict [list CONFIG.c_s2mm_burst_size {256}] $axi_usb_fx3_dma
set_property -dict [list CONFIG.c_sg_length_width {16}] $axi_usb_fx3_dma

set usb_fx3_rx_axis_fifo [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:1.1 usb_fx3_rx_axis_fifo ]

set intr_monitor [ create_bd_cell -type ip -vlnv analog.com:user:axi_intr_monitor:1.0 intr_monitor ]

ad_connect axi_usb_fx3/s_axis axi_usb_fx3_dma/M_AXIS_MM2S

ad_connect sys_cpu_clk usb_fx3_rx_axis_fifo/s_axis_aclk
ad_connect sys_cpu_resetn usb_fx3_rx_axis_fifo/s_axis_aresetn

ad_connect axi_usb_fx3/m_axis usb_fx3_rx_axis_fifo/S_AXIS
ad_connect axi_usb_fx3_dma/S_AXIS_S2MM usb_fx3_rx_axis_fifo/M_AXIS

ad_connect axi_uart/rx usb_fx3_uart_tx
ad_connect axi_uart/tx usb_fx3_uart_rx

ad_connect sys_cpu_clk axi_usb_fx3/s_axi_aclk
ad_connect sys_cpu_resetn axi_usb_fx3/s_axi_aresetn

ad_connect axi_usb_fx3/dma_rdy dma_rdy
ad_connect axi_usb_fx3/dma_wmk dma_wmk
ad_connect axi_usb_fx3/fifo_rdy fifo_rdy
ad_connect axi_usb_fx3/pclk pclk
ad_connect axi_usb_fx3/data data
ad_connect axi_usb_fx3/addr addr
ad_connect axi_usb_fx3/slcs_n slcs_n
ad_connect axi_usb_fx3/slrd_n slrd_n
ad_connect axi_usb_fx3/sloe_n sloe_n
ad_connect axi_usb_fx3/slwr_n slwr_n
ad_connect axi_usb_fx3/pktend_n pktend_n
ad_connect axi_usb_fx3/epswitch_n epswitch_n

ad_cpu_interrupt ps-13 mb-12 axi_usb_fx3/irq
ad_cpu_interrupt ps-12 mb-13 axi_usb_fx3_dma/mm2s_introut
ad_cpu_interrupt ps-11 mb-14 axi_usb_fx3_dma/s2mm_introut
ad_cpu_interrupt ps-10 mb-15 axi_uart/interrupt
ad_cpu_interrupt ps-9 mb-16 intr_monitor/irq

ad_cpu_interconnect 0x50000000 axi_usb_fx3
ad_cpu_interconnect 0x40400000 axi_usb_fx3_dma
ad_cpu_interconnect 0x40600000 axi_uart
ad_cpu_interconnect 0x43c00000 intr_monitor

ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk axi_usb_fx3_dma/M_AXI_SG
ad_mem_hp1_interconnect sys_cpu_clk axi_usb_fx3_dma/M_AXI_MM2S
ad_mem_hp1_interconnect sys_cpu_clk axi_usb_fx3_dma/M_AXI_S2MM

# test

set ila [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.1 ila]

set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila
set_property -dict [list CONFIG.C_NUM_OF_PROBES {11}] $ila
set_property -dict [list CONFIG.C_PROBE10_WIDTH {4}] $ila
set_property -dict [list CONFIG.C_PROBE3_WIDTH {2}] $ila
set_property -dict [list CONFIG.C_PROBE2_WIDTH {15}] $ila
set_property -dict [list CONFIG.C_PROBE1_WIDTH {74}] $ila
set_property -dict [list CONFIG.C_PROBE0_WIDTH {75}] $ila
set_property -dict [list CONFIG.C_DATA_DEPTH {65536}] $ila
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila
set_property -dict [list CONFIG.C_PROBE2_MU_CNT {2}] $ila
set_property -dict [list CONFIG.C_PROBE1_MU_CNT {2}] $ila
set_property -dict [list CONFIG.C_PROBE0_MU_CNT {2}] $ila
set_property -dict [list CONFIG.ALL_PROBE_SAME_MU_CNT {2}] $ila
set_property -dict [list CONFIG.C_ENABLE_ILA_AXI_MON {false}] $ila

ad_connect ila/clk axi_usb_fx3/pclk
ad_connect ila/probe0 axi_usb_fx3/debug_fx32dma
ad_connect ila/probe1 axi_usb_fx3/debug_dma2fx3
ad_connect ila/probe2 axi_usb_fx3/debug_status
ad_connect ila/probe3 axi_usb_fx3/addr
ad_connect ila/probe4 axi_usb_fx3/epswitch_n
ad_connect ila/probe5 axi_usb_fx3/slcs_n
ad_connect ila/probe6 axi_usb_fx3/slrd_n
ad_connect ila/probe7 axi_usb_fx3/sloe_n
ad_connect ila/probe8 axi_usb_fx3/slwr_n
ad_connect ila/probe9 axi_usb_fx3/pktend_n
ad_connect ila/probe10 fifo_rdy
