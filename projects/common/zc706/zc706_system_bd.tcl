
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

set sys_ps7  [create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 sys_ps7]
set_property -dict [list CONFIG.preset {ZC706}] $sys_ps7
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
set_property -dict [list CONFIG.PCW_IRQ_F2P_MODE {REVERSE}] $sys_ps7

set axi_iic_main [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_main]
set_property -dict [list CONFIG.USE_BOARD_FLOW {true}] $axi_iic_main
set_property -dict [list CONFIG.IIC_BOARD_INTERFACE {Custom}] $axi_iic_main

set sys_concat_intc [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 sys_concat_intc]
set_property -dict [list CONFIG.NUM_PORTS {16}] $sys_concat_intc

#set axi_cpu_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_cpu_interconnect]
#set_property -dict [list CONFIG.NUM_MI {7}] $axi_cpu_interconnect
#set_property -dict [list CONFIG.STRATEGY {1}] $axi_cpu_interconnect

set sys_rstgen [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 sys_rstgen]
set_property -dict [list CONFIG.C_EXT_RST_WIDTH {1}] $sys_rstgen

# hdmi peripherals

set axi_hdmi_clkgen [create_bd_cell -type ip -vlnv analog.com:user:axi_clkgen:1.0 axi_hdmi_clkgen]
set axi_hdmi_core [create_bd_cell -type ip -vlnv analog.com:user:axi_hdmi_tx:1.0 axi_hdmi_core]

set axi_hdmi_dma [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.2 axi_hdmi_dma]
set_property -dict [list CONFIG.c_m_axis_mm2s_tdata_width {64}] $axi_hdmi_dma
set_property -dict [list CONFIG.c_use_mm2s_fsync {1}] $axi_hdmi_dma
set_property -dict [list CONFIG.c_include_s2mm {0}] $axi_hdmi_dma

#set axi_hdmi_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_hdmi_interconnect]
#set_property -dict [list CONFIG.NUM_MI {1}] $axi_hdmi_interconnect

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

ad_connect  sys_cpu_clk sys_ps7/FCLK_CLK0
ad_connect  sys_200m_clk sys_ps7/FCLK_CLK1
ad_connect  sys_cpu_reset sys_rstgen/peripheral_reset
ad_connect  sys_cpu_resetn sys_rstgen/peripheral_aresetn

ad_connect  sys_cpu_clk sys_rstgen/slowest_sync_clk
ad_connect  sys_rstgen/ext_reset_in sys_ps7/FCLK_RESET0_N

# interface connections

ad_connect  DDR sys_ps7/DDR
ad_connect  GPIO_I sys_ps7/GPIO_I
ad_connect  GPIO_O sys_ps7/GPIO_O
ad_connect  GPIO_T sys_ps7/GPIO_T
ad_connect  FIXED_IO sys_ps7/FIXED_IO
ad_connect  IIC_MAIN axi_iic_main/iic
ad_connect  sys_200m_clk axi_hdmi_clkgen/clk

#ad_connect  sys_cpu_clk sys_ps7/M_AXI_GP0_ACLK
#ad_connect  sys_cpu_clk axi_cpu_interconnect/ACLK 
#ad_connect  sys_cpu_resetn axi_cpu_interconnect/ARESETN 

#ad_connect  axi_cpu_interconnect/S00_AXI sys_ps7/M_AXI_GP0
#ad_connect  sys_cpu_clk axi_cpu_interconnect/S00_ACLK 
#ad_connect  sys_cpu_resetn axi_cpu_interconnect/S00_ARESETN 

#ad_connect  axi_cpu_interconnect/M00_AXI axi_iic_main/s_axi
#ad_connect  sys_cpu_clk axi_cpu_interconnect/M00_ACLK 
#ad_connect  sys_cpu_resetn axi_cpu_interconnect/M00_ARESETN 
#ad_connect  sys_cpu_clk axi_iic_main/s_axi_aclk
#ad_connect  sys_cpu_resetn axi_iic_main/s_axi_aresetn

# hdmi


#ad_connect  axi_cpu_interconnect/M01_AXI axi_hdmi_clkgen/s_axi
#ad_connect  axi_cpu_interconnect/M02_AXI axi_hdmi_core/s_axi
#ad_connect  axi_cpu_interconnect/M03_AXI axi_hdmi_dma/S_AXI_LITE
#ad_connect  axi_hdmi_interconnect/S00_AXI axi_hdmi_dma/M_AXI_MM2S
#ad_connect  axi_hdmi_interconnect/M00_AXI sys_ps7/S_AXI_HP0
#ad_connect  sys_cpu_clk axi_cpu_interconnect/M01_ACLK 
#ad_connect  sys_cpu_clk axi_cpu_interconnect/M02_ACLK 
#ad_connect  sys_cpu_clk axi_cpu_interconnect/M03_ACLK 
#ad_connect  sys_cpu_clk axi_hdmi_interconnect/ACLK 
#ad_connect  sys_cpu_clk axi_hdmi_interconnect/S00_ACLK 
#ad_connect  sys_cpu_clk axi_hdmi_interconnect/M00_ACLK 
#ad_connect  sys_cpu_clk axi_hdmi_clkgen/s_axi_aclk
#ad_connect  sys_cpu_clk axi_hdmi_core/s_axi_aclk
#ad_connect  sys_cpu_clk axi_hdmi_dma/s_axi_lite_aclk
#ad_connect  sys_cpu_clk axi_hdmi_dma/m_axi_mm2s_aclk
#ad_connect  sys_cpu_clk sys_ps7/S_AXI_HP0_ACLK
#ad_connect  sys_cpu_resetn axi_cpu_interconnect/M01_ARESETN 
#ad_connect  sys_cpu_resetn axi_cpu_interconnect/M02_ARESETN 
#ad_connect  sys_cpu_resetn axi_cpu_interconnect/M03_ARESETN 
#ad_connect  sys_cpu_resetn axi_hdmi_interconnect/ARESETN 
#ad_connect  sys_cpu_resetn axi_hdmi_interconnect/S00_ARESETN 
#ad_connect  sys_cpu_resetn axi_hdmi_interconnect/M00_ARESETN 
#ad_connect  sys_cpu_resetn axi_hdmi_clkgen/s_axi_aresetn
#ad_connect  sys_cpu_resetn axi_hdmi_core/s_axi_aresetn
#ad_connect  sys_cpu_resetn axi_hdmi_dma/axi_resetn

ad_connect  sys_cpu_clk axi_hdmi_clkgen/drp_clk
ad_connect  sys_cpu_clk axi_hdmi_core/m_axis_mm2s_clk
ad_connect  sys_cpu_clk axi_hdmi_dma/m_axis_mm2s_aclk
ad_connect  axi_hdmi_core/hdmi_clk axi_hdmi_clkgen/clk_0
ad_connect  axi_hdmi_core/hdmi_out_clk hdmi_out_clk
ad_connect  axi_hdmi_core/hdmi_24_hsync hdmi_hsync
ad_connect  axi_hdmi_core/hdmi_24_vsync hdmi_vsync
ad_connect  axi_hdmi_core/hdmi_24_data_e hdmi_data_e
ad_connect  axi_hdmi_core/hdmi_24_data hdmi_data
ad_connect  axi_hdmi_core/m_axis_mm2s_tvalid axi_hdmi_dma/m_axis_mm2s_tvalid
ad_connect  axi_hdmi_core/m_axis_mm2s_tdata axi_hdmi_dma/m_axis_mm2s_tdata
ad_connect  axi_hdmi_core/m_axis_mm2s_tkeep axi_hdmi_dma/m_axis_mm2s_tkeep
ad_connect  axi_hdmi_core/m_axis_mm2s_tlast axi_hdmi_dma/m_axis_mm2s_tlast
ad_connect  axi_hdmi_core/m_axis_mm2s_tready axi_hdmi_dma/m_axis_mm2s_tready
ad_connect  axi_hdmi_core/m_axis_mm2s_fsync axi_hdmi_dma/mm2s_fsync
ad_connect  axi_hdmi_core/m_axis_mm2s_fsync axi_hdmi_core/m_axis_mm2s_fsync_ret

# spdif audio

#ad_connect  axi_cpu_interconnect/M04_AXI axi_spdif_tx_core/s_axi
#ad_connect  sys_cpu_clk axi_cpu_interconnect/M04_ACLK 
#ad_connect  sys_cpu_clk axi_spdif_tx_core/S_AXI_ACLK
#ad_connect  sys_cpu_resetn axi_cpu_interconnect/M04_ARESETN 
#ad_connect  sys_cpu_resetn axi_spdif_tx_core/S_AXI_ARESETN
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

#ad_connect  sys_cpu_clk axi_cpu_interconnect/M05_ACLK 
#ad_connect  sys_cpu_resetn axi_cpu_interconnect/M05_ARESETN 
#ad_connect  sys_cpu_clk axi_cpu_interconnect/M06_ACLK 
#ad_connect  sys_cpu_resetn axi_cpu_interconnect/M06_ARESETN 

# interrupts

ad_connect  sys_concat_intc/dout sys_ps7/IRQ_F2P
ad_connect  sys_concat_intc/In15 axi_hdmi_dma/mm2s_introut
ad_connect  sys_concat_intc/In14 axi_iic_main/iic2intc_irpt

for {set intc_index 0} {$intc_index < 14} {incr intc_index} {
  set ps_intr_${intc_index} [create_bd_port -dir I ps_intr_${intc_index}]
  ad_connect  sys_concat_intc/In${intc_index}  ps_intr_${intc_index}
}

# address map

#set sys_mem_size 0x40000000

ad_cpu_interconnect 0x41600000 axi_iic_main
ad_cpu_interconnect 0x79000000 axi_hdmi_clkgen
ad_cpu_interconnect 0x43000000 axi_hdmi_dma
ad_cpu_interconnect 0x70e00000 axi_hdmi_core
ad_cpu_interconnect 0x75c00000 axi_spdif_tx_core
ad_mem_hp0_interconnect sys_cpu_clk sys_ps7/S_AXI_HP0
ad_mem_hp0_interconnect sys_cpu_clk axi_hdmi_dma/M_AXI_MM2S

#create_bd_addr_seg -range 0x00010000 -offset 0x41600000 $sys_addr_cntrl_space [get_bd_addr_segs axi_iic_main/s_axi/Reg]             SEG_data_iic_main
#create_bd_addr_seg -range 0x00010000 -offset 0x79000000 $sys_addr_cntrl_space [get_bd_addr_segs axi_hdmi_clkgen/s_axi/axi_lite]     SEG_data_hdmi_clkgen
#create_bd_addr_seg -range 0x00010000 -offset 0x43000000 $sys_addr_cntrl_space [get_bd_addr_segs axi_hdmi_dma/S_AXI_LITE/Reg]        SEG_data_hdmi_dma
#create_bd_addr_seg -range 0x00010000 -offset 0x70e00000 $sys_addr_cntrl_space [get_bd_addr_segs axi_hdmi_core/s_axi/axi_lite]       SEG_data_hdmi_core
#create_bd_addr_seg -range 0x00010000 -offset 0x75c00000 $sys_addr_cntrl_space [get_bd_addr_segs axi_spdif_tx_core/S_AXI/reg0]       SEG_data_spdif_core

#create_bd_addr_seg -range $sys_mem_size -offset 0x00000000 [get_bd_addr_spaces axi_hdmi_dma/Data_MM2S]     [get_bd_addr_segs sys_ps7/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_sys_ps7_hp0_ddr_lowocm

