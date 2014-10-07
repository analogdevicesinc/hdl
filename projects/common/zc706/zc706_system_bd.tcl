
# create board design
# interface ports

set DDR [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR]
set FIXED_IO [create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO]
set IIC_MAIN [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_MAIN]

set GPIO_I [create_bd_port -dir I -from 31 -to 0 GPIO_I]
set GPIO_O [create_bd_port -dir O -from 31 -to 0 GPIO_O]
set GPIO_T [create_bd_port -dir O -from 31 -to 0 GPIO_T]

# hdmi interface

set hdmi_out_clk    [create_bd_port -dir O hdmi_out_clk]
set hdmi_hsync      [create_bd_port -dir O hdmi_hsync]
set hdmi_vsync      [create_bd_port -dir O hdmi_vsync]
set hdmi_data_e     [create_bd_port -dir O hdmi_data_e]
set hdmi_data       [create_bd_port -dir O -from 23 -to 0 hdmi_data]

# spdif audio

set spdif           [create_bd_port -dir O spdif]

# instance: sys_ps7

set sys_ps7  [create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.3 sys_ps7]
set_property -dict [list CONFIG.PCW_IMPORT_BOARD_PRESET {ZC706}] $sys_ps7
set_property -dict [list CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_CLK1_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_EN_RST1_PORT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100.0}] $sys_ps7
set_property -dict [list CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {200.0}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_FABRIC_INTERRUPT {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP0 {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_IRQ_F2P_INTR {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO {32}] $sys_ps7
set_property -dict [list CONFIG.PCW_USE_DMA0 {1}] $sys_ps7

set axi_iic_main [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_main]
set_property -dict [list CONFIG.USE_BOARD_FLOW {true} CONFIG.IIC_BOARD_INTERFACE {IIC_MAIN}] $axi_iic_main

set sys_concat_intc [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:1.0 sys_concat_intc]
set_property -dict [list CONFIG.NUM_PORTS {5}] $sys_concat_intc

set axi_cpu_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_cpu_interconnect]
set_property -dict [list CONFIG.NUM_MI {7}] $axi_cpu_interconnect
set_property -dict [list CONFIG.STRATEGY {1}] $axi_cpu_interconnect

set sys_rstgen [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 sys_rstgen]
set_property -dict [list CONFIG.C_EXT_RST_WIDTH {1}] $sys_rstgen

# hdmi peripherals

set axi_hdmi_clkgen [create_bd_cell -type ip -vlnv analog.com:user:axi_clkgen:1.0 axi_hdmi_clkgen]
set axi_hdmi_core [create_bd_cell -type ip -vlnv analog.com:user:axi_hdmi_tx:1.0 axi_hdmi_core]

set axi_hdmi_dma [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.1 axi_hdmi_dma]
set_property -dict [list CONFIG.c_m_axis_mm2s_tdata_width {64}] $axi_hdmi_dma
set_property -dict [list CONFIG.c_use_mm2s_fsync {1}] $axi_hdmi_dma
set_property -dict [list CONFIG.c_include_s2mm {0}] $axi_hdmi_dma

set axi_hdmi_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_hdmi_interconnect]
set_property -dict [list CONFIG.NUM_MI {1}] $axi_hdmi_interconnect

# audio peripherals

set sys_audio_clkgen [create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.1 sys_audio_clkgen]
set_property -dict [list CONFIG.PRIM_IN_FREQ {200.000}] $sys_audio_clkgen
set_property -dict [list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {12.288}] $sys_audio_clkgen
set_property -dict [list CONFIG.USE_LOCKED {false}] $sys_audio_clkgen
set_property -dict [list CONFIG.USE_RESET {true} CONFIG.RESET_TYPE {ACTIVE_LOW}] $sys_audio_clkgen

set axi_spdif_tx_core [create_bd_cell -type ip -vlnv analog.com:user:axi_spdif_tx:1.0 axi_spdif_tx_core]
set_property -dict [list CONFIG.C_DMA_TYPE {1}] $axi_spdif_tx_core
set_property -dict [list CONFIG.C_S_AXI_ADDR_WIDTH {16}] $axi_spdif_tx_core

# system reset/clock definitions

set sys_100m_clk_source [get_bd_pins sys_ps7/FCLK_CLK0]
set sys_200m_clk_source [get_bd_pins sys_ps7/FCLK_CLK1]

connect_bd_net -net sys_100m_clk $sys_100m_clk_source
connect_bd_net -net sys_200m_clk $sys_200m_clk_source

connect_bd_net -net sys_100m_clk [get_bd_pins sys_rstgen/slowest_sync_clk]
connect_bd_net -net sys_aux_reset [get_bd_pins sys_rstgen/ext_reset_in] [get_bd_pins sys_ps7/FCLK_RESET0_N]

set sys_100m_resetn_source [get_bd_pins sys_rstgen/peripheral_aresetn]
set sys_200m_resetn_source [get_bd_pins sys_rstgen/interconnect_aresetn]
connect_bd_net -net sys_100m_resetn $sys_100m_resetn_source
connect_bd_net -net sys_200m_resetn $sys_200m_resetn_source

# interface connections

connect_bd_intf_net -intf_net sys_ps7_ddr [get_bd_intf_ports DDR] [get_bd_intf_pins sys_ps7/DDR]
connect_bd_net -net sys_ps7_GPIO_I [get_bd_ports GPIO_I] [get_bd_pins sys_ps7/GPIO_I]
connect_bd_net -net sys_ps7_GPIO_O [get_bd_ports GPIO_O] [get_bd_pins sys_ps7/GPIO_O]
connect_bd_net -net sys_ps7_GPIO_T [get_bd_ports GPIO_T] [get_bd_pins sys_ps7/GPIO_T]
connect_bd_intf_net -intf_net sys_ps7_fixed_io [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins sys_ps7/FIXED_IO]
connect_bd_intf_net -intf_net axi_iic_main_iic [get_bd_intf_ports IIC_MAIN] [get_bd_intf_pins axi_iic_main/iic]

connect_bd_net -net sys_100m_clk [get_bd_pins sys_ps7/M_AXI_GP0_ACLK]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/ARESETN] $sys_100m_resetn_source

connect_bd_intf_net -intf_net axi_cpu_interconnect_s00_axi [get_bd_intf_pins axi_cpu_interconnect/S00_AXI] [get_bd_intf_pins sys_ps7/M_AXI_GP0]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/S00_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/S00_ARESETN] $sys_100m_resetn_source

connect_bd_intf_net -intf_net axi_cpu_interconnect_m00_axi [get_bd_intf_pins axi_cpu_interconnect/M00_AXI] [get_bd_intf_pins axi_iic_main/s_axi]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M00_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M00_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_iic_main/s_axi_aclk]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_iic_main/s_axi_aresetn]
connect_bd_net -net sys_concat_intc_din_1 [get_bd_pins sys_concat_intc/In1] [get_bd_pins axi_iic_main/iic2intc_irpt]

connect_bd_net -net sys_ps7_interrupt [get_bd_pins sys_concat_intc/dout] [get_bd_pins sys_ps7/IRQ_F2P]

# hdmi

connect_bd_net -net sys_200m_clk   [get_bd_pins axi_hdmi_clkgen/clk]

connect_bd_intf_net -intf_net axi_cpu_interconnect_m01_axi [get_bd_intf_pins axi_cpu_interconnect/M01_AXI] [get_bd_intf_pins axi_hdmi_clkgen/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m02_axi [get_bd_intf_pins axi_cpu_interconnect/M02_AXI] [get_bd_intf_pins axi_hdmi_core/s_axi]
connect_bd_intf_net -intf_net axi_cpu_interconnect_m03_axi [get_bd_intf_pins axi_cpu_interconnect/M03_AXI] [get_bd_intf_pins axi_hdmi_dma/S_AXI_LITE]

connect_bd_intf_net -intf_net axi_hdmi_interconnect_s00_axi [get_bd_intf_pins axi_hdmi_interconnect/S00_AXI] [get_bd_intf_pins axi_hdmi_dma/M_AXI_MM2S]
connect_bd_intf_net -intf_net axi_hdmi_interconnect_m00_axi [get_bd_intf_pins axi_hdmi_interconnect/M00_AXI] [get_bd_intf_pins sys_ps7/S_AXI_HP0]

connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M01_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M02_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M03_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_hdmi_interconnect/ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_hdmi_interconnect/S00_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_hdmi_interconnect/M00_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_hdmi_clkgen/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_hdmi_clkgen/drp_clk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_hdmi_core/s_axi_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_hdmi_core/m_axis_mm2s_clk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_hdmi_dma/s_axi_lite_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_hdmi_dma/m_axi_mm2s_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_hdmi_dma/m_axis_mm2s_aclk]
connect_bd_net -net sys_100m_clk [get_bd_pins sys_ps7/S_AXI_HP0_ACLK]

connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M01_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M02_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M03_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_hdmi_interconnect/ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_hdmi_interconnect/S00_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_hdmi_interconnect/M00_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_hdmi_clkgen/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_hdmi_core/s_axi_aresetn]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_hdmi_dma/axi_resetn]

connect_bd_net -net axi_hdmi_tx_core_hdmi_clk      [get_bd_pins axi_hdmi_core/hdmi_clk]              [get_bd_pins axi_hdmi_clkgen/clk_0]
connect_bd_net -net axi_hdmi_tx_core_hdmi_out_clk  [get_bd_pins axi_hdmi_core/hdmi_out_clk]          [get_bd_ports hdmi_out_clk]
connect_bd_net -net axi_hdmi_tx_core_hdmi_hsync    [get_bd_pins axi_hdmi_core/hdmi_24_hsync]         [get_bd_ports hdmi_hsync]
connect_bd_net -net axi_hdmi_tx_core_hdmi_vsync    [get_bd_pins axi_hdmi_core/hdmi_24_vsync]         [get_bd_ports hdmi_vsync]
connect_bd_net -net axi_hdmi_tx_core_hdmi_data_e   [get_bd_pins axi_hdmi_core/hdmi_24_data_e]        [get_bd_ports hdmi_data_e]
connect_bd_net -net axi_hdmi_tx_core_hdmi_data     [get_bd_pins axi_hdmi_core/hdmi_24_data]          [get_bd_ports hdmi_data]
connect_bd_net -net axi_hdmi_tx_core_mm2s_tvalid   [get_bd_pins axi_hdmi_core/m_axis_mm2s_tvalid]    [get_bd_pins axi_hdmi_dma/m_axis_mm2s_tvalid]
connect_bd_net -net axi_hdmi_tx_core_mm2s_tdata    [get_bd_pins axi_hdmi_core/m_axis_mm2s_tdata]     [get_bd_pins axi_hdmi_dma/m_axis_mm2s_tdata]
connect_bd_net -net axi_hdmi_tx_core_mm2s_tkeep    [get_bd_pins axi_hdmi_core/m_axis_mm2s_tkeep]     [get_bd_pins axi_hdmi_dma/m_axis_mm2s_tkeep]
connect_bd_net -net axi_hdmi_tx_core_mm2s_tlast    [get_bd_pins axi_hdmi_core/m_axis_mm2s_tlast]     [get_bd_pins axi_hdmi_dma/m_axis_mm2s_tlast]
connect_bd_net -net axi_hdmi_tx_core_mm2s_tready   [get_bd_pins axi_hdmi_core/m_axis_mm2s_tready]    [get_bd_pins axi_hdmi_dma/m_axis_mm2s_tready]
connect_bd_net -net axi_hdmi_tx_core_mm2s_fsync    [get_bd_pins axi_hdmi_core/m_axis_mm2s_fsync]     [get_bd_pins axi_hdmi_dma/mm2s_fsync]
connect_bd_net -net axi_hdmi_tx_core_mm2s_fsync    [get_bd_pins axi_hdmi_core/m_axis_mm2s_fsync_ret]

connect_bd_net -net sys_concat_intc_din_0 [get_bd_pins sys_concat_intc/In0] [get_bd_pins axi_hdmi_dma/mm2s_introut]

# spdif audio

connect_bd_intf_net -intf_net axi_cpu_interconnect_m04_axi [get_bd_intf_pins axi_cpu_interconnect/M04_AXI] [get_bd_intf_pins axi_spdif_tx_core/s_axi]
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M04_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_spdif_tx_core/S_AXI_ACLK]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M04_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_spdif_tx_core/S_AXI_ARESETN]

connect_bd_net -net sys_100m_clk [get_bd_pins axi_spdif_tx_core/DMA_REQ_ACLK]
connect_bd_net -net sys_100m_clk [get_bd_pins sys_ps7/DMA0_ACLK]
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_spdif_tx_core/DMA_REQ_RSTN]
connect_bd_intf_net -intf_net axi_spdif_dma_req_tx [get_bd_intf_pins sys_ps7/DMA0_REQ] [get_bd_intf_pins axi_spdif_tx_core/DMA_REQ]
connect_bd_intf_net -intf_net axi_spdif_dma_ack_tx [get_bd_intf_pins sys_ps7/DMA0_ACK] [get_bd_intf_pins axi_spdif_tx_core/DMA_ACK]

connect_bd_net -net sys_200m_clk [get_bd_pins sys_audio_clkgen/clk_in1]
connect_bd_net -net sys_100m_resetn [get_bd_pins sys_audio_clkgen/resetn] $sys_100m_resetn_source
connect_bd_net -net sys_audio_clkgen_clk [get_bd_pins sys_audio_clkgen/clk_out1] [get_bd_pins axi_spdif_tx_core/spdif_data_clk]
connect_bd_net -net spdif_s [get_bd_ports spdif] [get_bd_pins axi_spdif_tx_core/spdif_tx_o]

# match up interconnects

connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M05_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M05_ARESETN] $sys_100m_resetn_source
connect_bd_net -net sys_100m_clk [get_bd_pins axi_cpu_interconnect/M06_ACLK] $sys_100m_clk_source
connect_bd_net -net sys_100m_resetn [get_bd_pins axi_cpu_interconnect/M06_ARESETN] $sys_100m_resetn_source

# address map

set sys_zynq 1
set sys_mem_size 0x40000000
set sys_addr_cntrl_space [get_bd_addr_spaces sys_ps7/Data]

create_bd_addr_seg -range 0x00010000 -offset 0x41600000 $sys_addr_cntrl_space [get_bd_addr_segs axi_iic_main/s_axi/Reg]             SEG_data_iic_main
create_bd_addr_seg -range 0x00010000 -offset 0x79000000 $sys_addr_cntrl_space [get_bd_addr_segs axi_hdmi_clkgen/s_axi/axi_lite]     SEG_data_hdmi_clkgen
create_bd_addr_seg -range 0x00010000 -offset 0x43000000 $sys_addr_cntrl_space [get_bd_addr_segs axi_hdmi_dma/S_AXI_LITE/Reg]        SEG_data_hdmi_dma
create_bd_addr_seg -range 0x00010000 -offset 0x70e00000 $sys_addr_cntrl_space [get_bd_addr_segs axi_hdmi_core/s_axi/axi_lite]       SEG_data_hdmi_core
create_bd_addr_seg -range 0x00010000 -offset 0x75c00000 $sys_addr_cntrl_space [get_bd_addr_segs axi_spdif_tx_core/S_AXI/reg0]       SEG_data_spdif_core

create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_hdmi_dma/Data_MM2S]     [get_bd_addr_segs sys_ps7/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_sys_ps7_hp0_ddr_lowocm

