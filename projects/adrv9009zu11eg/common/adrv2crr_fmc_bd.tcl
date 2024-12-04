###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

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
ad_ip_parameter axi_fan_control_0 CONFIG.INTERNAL_SYSMONE 1

ad_ip_instance xlconstant const_gnd_0
ad_ip_parameter const_gnd_0 CONFIG.CONST_WIDTH {10}
ad_ip_parameter const_gnd_0 CONFIG.CONST_VAL {0}

ad_connect axi_fan_tacho_i axi_fan_control_0/tacho
ad_connect axi_fan_pwm_o axi_fan_control_0/pwm
ad_connect const_gnd_0/dout axi_fan_control_0/temp_in

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




##################################################################################################
##################################################################################################
################################# SFP Corundum additions #########################################
##################################################################################################
##################################################################################################

# Corundum NIC
create_bd_port -dir I sfp_rx_p
create_bd_port -dir I sfp_rx_n
create_bd_port -dir O sfp_tx_p
create_bd_port -dir O sfp_tx_n
create_bd_port -dir I sfp_mgt_refclk_p
create_bd_port -dir I sfp_mgt_refclk_n

create_bd_port -dir O sfp_tx_disable
create_bd_port -dir I sfp_tx_fault
create_bd_port -dir I sfp_rx_los
create_bd_port -dir I sfp_mod_abs

create_bd_port -dir O -from 1 -to 0 sfp_led
create_bd_port -dir O -from 1 -to 0 led

# Corundum NIC

ad_ip_instance corundum corundum

# collect build information
set build_date [clock seconds]
set git_hash 00000000
catch {
  set git_hash [exec git rev-parse --short=8 HEAD]
}
set tag_ver 0.0.0

# FW and board IDs
set fpga_id [expr 0x4738093]
set fw_id [expr 0x00000000]
set fw_ver $tag_ver
set board_vendor_id [expr 0x10ee]
set board_device_id [expr 0x9066]
set board_ver 1.0
set release_info [expr 0x00000000]

# General variables
set IRQ_SIZE 8
set PORTS_PER_IF "1"
set TX_QUEUE_INDEX_WIDTH "5"
set RX_QUEUE_INDEX_WIDTH "5"
set CQN_WIDTH [expr max($TX_QUEUE_INDEX_WIDTH, $RX_QUEUE_INDEX_WIDTH) + 1]
set TX_QUEUE_PIPELINE [expr 3 + max($TX_QUEUE_INDEX_WIDTH - 12, 0)]
set RX_QUEUE_PIPELINE [expr 3 + max($RX_QUEUE_INDEX_WIDTH - 12, 0)]
set TX_DESC_TABLE_SIZE "32"
set RX_DESC_TABLE_SIZE "32"
set TX_RAM_SIZE "32768"
set RX_RAM_SIZE "32768"

# FW ID block
ad_ip_parameter corundum CONFIG.FPGA_ID [format "32'h%08x" $fpga_id]
ad_ip_parameter corundum CONFIG.FW_ID [format "32'h%08x" $fw_id]
ad_ip_parameter corundum CONFIG.FW_VER [format "32'h%02x%02x%02x%02x" {*}[split $fw_ver .-] 0 0 0 0]
ad_ip_parameter corundum CONFIG.BOARD_ID [format "32'h%04x%04x" $board_vendor_id $board_device_id]
ad_ip_parameter corundum CONFIG.BOARD_VER [format "32'h%02x%02x%02x%02x" {*}[split $board_ver .-] 0 0 0 0]
ad_ip_parameter corundum CONFIG.BUILD_DATE  "32'd${build_date}"
ad_ip_parameter corundum CONFIG.GIT_HASH  "32'h${git_hash}"
ad_ip_parameter corundum CONFIG.RELEASE_INFO  [format "32'h%08x" $release_info]

# Board configuration
ad_ip_parameter corundum CONFIG.TDMA_BER_ENABLE "0"

# Structural configuration
ad_ip_parameter corundum CONFIG.IF_COUNT "1"
ad_ip_parameter corundum CONFIG.PORTS_PER_IF $PORTS_PER_IF
ad_ip_parameter corundum CONFIG.SCHED_PER_IF $PORTS_PER_IF
ad_ip_parameter corundum CONFIG.PORT_MASK "0"

# Clock configuration
ad_ip_parameter corundum CONFIG.CLK_PERIOD_NS_NUM "4"
ad_ip_parameter corundum CONFIG.CLK_PERIOD_NS_DENOM "1"

# PTP configuration
ad_ip_parameter corundum CONFIG.PTP_CLOCK_PIPELINE "0"
ad_ip_parameter corundum CONFIG.PTP_CLOCK_CDC_PIPELINE "0"
ad_ip_parameter corundum CONFIG.PTP_PORT_CDC_PIPELINE "0"
ad_ip_parameter corundum CONFIG.PTP_PEROUT_ENABLE "1"
ad_ip_parameter corundum CONFIG.PTP_PEROUT_COUNT "1"

# Queue manager configuration
ad_ip_parameter corundum CONFIG.EVENT_QUEUE_OP_TABLE_SIZE "32"
ad_ip_parameter corundum CONFIG.TX_QUEUE_OP_TABLE_SIZE "32"
ad_ip_parameter corundum CONFIG.RX_QUEUE_OP_TABLE_SIZE "32"
ad_ip_parameter corundum CONFIG.CQ_OP_TABLE_SIZE "32"
ad_ip_parameter corundum CONFIG.EQN_WIDTH "2"
ad_ip_parameter corundum CONFIG.TX_QUEUE_INDEX_WIDTH $TX_QUEUE_INDEX_WIDTH
ad_ip_parameter corundum CONFIG.RX_QUEUE_INDEX_WIDTH $RX_QUEUE_INDEX_WIDTH
ad_ip_parameter corundum CONFIG.CQN_WIDTH $CQN_WIDTH
ad_ip_parameter corundum CONFIG.EQ_PIPELINE "3"
ad_ip_parameter corundum CONFIG.TX_QUEUE_PIPELINE $TX_QUEUE_PIPELINE
ad_ip_parameter corundum CONFIG.RX_QUEUE_PIPELINE $RX_QUEUE_PIPELINE
ad_ip_parameter corundum CONFIG.CQ_PIPELINE [expr 3 + max($CQN_WIDTH - 12, 0)]

# TX and RX engine configuration
ad_ip_parameter corundum CONFIG.TX_DESC_TABLE_SIZE $TX_DESC_TABLE_SIZE
ad_ip_parameter corundum CONFIG.RX_DESC_TABLE_SIZE $RX_DESC_TABLE_SIZE
ad_ip_parameter corundum CONFIG.RX_INDIR_TBL_ADDR_WIDTH [expr min($RX_QUEUE_INDEX_WIDTH, 8)]

# Scheduler configuration
ad_ip_parameter corundum CONFIG.TX_SCHEDULER_OP_TABLE_SIZE $TX_DESC_TABLE_SIZE
ad_ip_parameter corundum CONFIG.TX_SCHEDULER_PIPELINE $TX_QUEUE_PIPELINE
ad_ip_parameter corundum CONFIG.TDMA_INDEX_WIDTH "6"

# Interface configuration
ad_ip_parameter corundum CONFIG.PTP_TS_ENABLE "1"
ad_ip_parameter corundum CONFIG.TX_CPL_FIFO_DEPTH "32"
ad_ip_parameter corundum CONFIG.TX_CHECKSUM_ENABLE "1"
ad_ip_parameter corundum CONFIG.RX_HASH_ENABLE "1"
ad_ip_parameter corundum CONFIG.RX_CHECKSUM_ENABLE "1"
ad_ip_parameter corundum CONFIG.TX_FIFO_DEPTH "32768"
ad_ip_parameter corundum CONFIG.RX_FIFO_DEPTH "32768"
ad_ip_parameter corundum CONFIG.MAX_TX_SIZE "9214"
ad_ip_parameter corundum CONFIG.MAX_RX_SIZE "9214"
ad_ip_parameter corundum CONFIG.TX_RAM_SIZE $TX_RAM_SIZE
ad_ip_parameter corundum CONFIG.RX_RAM_SIZE $RX_RAM_SIZE

# Application block configuration
ad_ip_parameter corundum CONFIG.APP_ID "32'h00000000"
ad_ip_parameter corundum CONFIG.APP_ENABLE "0"
ad_ip_parameter corundum CONFIG.APP_CTRL_ENABLE "1"
ad_ip_parameter corundum CONFIG.APP_DMA_ENABLE "1"
ad_ip_parameter corundum CONFIG.APP_AXIS_DIRECT_ENABLE "1"
ad_ip_parameter corundum CONFIG.APP_AXIS_SYNC_ENABLE "1"
ad_ip_parameter corundum CONFIG.APP_AXIS_IF_ENABLE "1"
ad_ip_parameter corundum CONFIG.APP_STAT_ENABLE "1"

# AXI DMA interface configuration
ad_ip_parameter corundum CONFIG.AXI_DATA_WIDTH [get_property CONFIG.PSU__SAXIGP0__DATA_WIDTH [get_bd_cells sys_ps8]]
ad_ip_parameter corundum CONFIG.AXI_ADDR_WIDTH 64
ad_ip_parameter corundum CONFIG.AXI_ID_WIDTH 6

# DMA interface configuration
ad_ip_parameter corundum CONFIG.DMA_IMM_ENABLE "0"
ad_ip_parameter corundum CONFIG.DMA_IMM_WIDTH "32"
ad_ip_parameter corundum CONFIG.DMA_LEN_WIDTH "16"
ad_ip_parameter corundum CONFIG.DMA_TAG_WIDTH "16"
ad_ip_parameter corundum CONFIG.RAM_ADDR_WIDTH [expr int(ceil(log(max($TX_RAM_SIZE, $RX_RAM_SIZE))/log(2)))]
ad_ip_parameter corundum CONFIG.RAM_PIPELINE "2"
ad_ip_parameter corundum CONFIG.AXI_DMA_MAX_BURST_LEN 16

# AXI lite interface configuration (control)
ad_ip_parameter corundum CONFIG.AXIL_CTRL_DATA_WIDTH 32
ad_ip_parameter corundum CONFIG.AXIL_CTRL_ADDR_WIDTH 24

# AXI lite interface configuration (application control)
ad_ip_parameter corundum CONFIG.AXIL_APP_CTRL_DATA_WIDTH 32
ad_ip_parameter corundum CONFIG.AXIL_APP_CTRL_ADDR_WIDTH 24

# Interrupt configuration
ad_ip_parameter corundum CONFIG.IRQ_COUNT $IRQ_SIZE
ad_ip_parameter corundum CONFIG.IRQ_STRETCH "10"

# Ethernet interface configuration
ad_ip_parameter corundum CONFIG.AXIS_ETH_TX_PIPELINE "0"
ad_ip_parameter corundum CONFIG.AXIS_ETH_TX_FIFO_PIPELINE "2"
ad_ip_parameter corundum CONFIG.AXIS_ETH_TX_TS_PIPELINE "0"
ad_ip_parameter corundum CONFIG.AXIS_ETH_RX_PIPELINE "0"
ad_ip_parameter corundum CONFIG.AXIS_ETH_RX_FIFO_PIPELINE "2"

# Statistics counter subsystem
ad_ip_parameter corundum CONFIG.STAT_ENABLE "1"
ad_ip_parameter corundum CONFIG.STAT_DMA_ENABLE "1"
ad_ip_parameter corundum CONFIG.STAT_AXI_ENABLE "1"
ad_ip_parameter corundum CONFIG.STAT_INC_WIDTH "24"
ad_ip_parameter corundum CONFIG.STAT_ID_WIDTH "12"

ad_connect led     corundum/led
ad_connect sfp_led corundum/sfp_led

set_property verilog_define {APP_CUSTOM_PORTS_ENABLE APP_CUSTOM_PARAMS_ENABLE} [get_filesets sources_1]

ad_connect corundum/clk sys_dma_clk
ad_connect corundum/rst sys_dma_rstgen/peripheral_reset

ad_connect corundum/sfp_rx_p sfp_rx_p
ad_connect corundum/sfp_rx_n sfp_rx_n
ad_connect corundum/sfp_tx_p sfp_tx_p
ad_connect corundum/sfp_tx_n sfp_tx_n
ad_connect corundum/sfp_mgt_refclk_p sfp_mgt_refclk_p
ad_connect corundum/sfp_mgt_refclk_n sfp_mgt_refclk_n

ad_connect corundum/sfp_tx_disable sfp_tx_disable
ad_connect corundum/sfp_mod_abs sfp_mod_abs
ad_connect corundum/sfp_rx_los sfp_rx_los
ad_connect corundum/sfp_tx_fault sfp_tx_fault

set fifo_num_bytes 4
set fifo_tdest_width 4
set fifo_tuser_width 2

set axi_clk_freq [get_property CONFIG.FREQ_HZ [get_bd_pins sys_ps8/pl_clk1]]
set_property CONFIG.FREQ_HZ $axi_clk_freq [get_bd_intf_pins corundum/m_axi_dma]
set_property CONFIG.FREQ_HZ $axi_clk_freq [get_bd_intf_pins corundum/s_axil_app_ctrl]
set_property CONFIG.FREQ_HZ $axi_clk_freq [get_bd_intf_pins corundum/s_axil_ctrl]

ad_ip_instance axi_interconnect smartconnect_corundum
ad_ip_parameter smartconnect_corundum CONFIG.NUM_MI 2
ad_ip_parameter smartconnect_corundum CONFIG.NUM_SI 1

ad_connect  sys_250m_interconnect_resetn sys_dma_rstgen/interconnect_aresetn
set  sys_dma_interconnect_resetn     [get_bd_nets sys_250m_interconnect_resetn]

ad_connect smartconnect_corundum/ARESETN $sys_dma_interconnect_resetn
ad_connect smartconnect_corundum/S00_ARESETN $sys_dma_interconnect_resetn
ad_connect smartconnect_corundum/M00_ARESETN $sys_dma_interconnect_resetn
ad_connect smartconnect_corundum/M01_ARESETN $sys_dma_interconnect_resetn





ad_connect smartconnect_corundum/ACLK sys_dma_clk
ad_connect smartconnect_corundum/S00_ACLK sys_dma_clk
ad_connect smartconnect_corundum/M00_ACLK sys_dma_clk
ad_connect smartconnect_corundum/M01_ACLK sys_dma_clk

ad_connect smartconnect_corundum/M00_AXI corundum/s_axil_ctrl
ad_connect smartconnect_corundum/M01_AXI corundum/s_axil_app_ctrl

ad_ip_parameter sys_ps8 CONFIG.PSU__USE__M_AXI_GP0 1
ad_ip_parameter sys_ps8 CONFIG.PSU__MAXIGP0__DATA_WIDTH 32
ad_connect smartconnect_corundum/S00_AXI sys_ps8/M_AXI_HPM0_FPD
ad_connect sys_ps8/maxihpm0_fpd_aclk sys_dma_clk

assign_bd_address -offset 0xA000_0000 [get_bd_addr_segs \
  corundum/s_axil_ctrl/Reg
] -target_address_space sys_ps8/Data
assign_bd_address -offset 0xA800_0000 [get_bd_addr_segs \
  corundum/s_axil_app_ctrl/Reg
] -target_address_space sys_ps8/Data

ad_ip_instance util_reduced_logic util_reduced_logic_0
ad_ip_parameter util_reduced_logic_0 CONFIG.C_OPERATION {or}
ad_ip_parameter util_reduced_logic_0 CONFIG.C_SIZE $IRQ_SIZE

ad_connect util_reduced_logic_0/Op1 corundum/core_irq

ad_cpu_interrupt ps-4 mb-4 util_reduced_logic_0/Res

ad_mem_hpc0_interconnect sys_dma_clk sys_ps8/S_AXI_HPC0_FPD
ad_mem_hpc0_interconnect sys_dma_clk corundum/m_axi_dma

assign_bd_address [get_bd_addr_segs { \
  sys_ps8/SAXIGP0/HPC0_LPS_OCM \
  sys_ps8/SAXIGP0/HPC0_QSPI \
  sys_ps8/SAXIGP0/HPC0_DDR_LOW \
  sys_ps8/SAXIGP0/HPC0_DDR_HIGH \
}]



create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_port

ad_ip_instance axi_iic axi_iic
ad_connect iic_port axi_iic/iic

ad_cpu_interconnect 0x43000000 axi_iic

ad_cpu_interrupt ps-5  mb-14  axi_iic/iic2intc_irpt