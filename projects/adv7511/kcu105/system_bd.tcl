
source $ad_hdl_dir/projects/common/kcu105/kcu105_system_bd.tcl

# video

create_bd_port -dir O hdmi_out_clk
create_bd_port -dir O hdmi_hsync
create_bd_port -dir O hdmi_vsync
create_bd_port -dir O hdmi_data_e
create_bd_port -dir O -from 15 -to 0 hdmi_data

# spdif audio

create_bd_port -dir O spdif

# interrupts

create_bd_port -dir O axi_hdmi_dma_intr
create_bd_port -dir O axi_spdif_tx_dma_intr

# hdmi peripherals

set axi_hdmi_clkgen [create_bd_cell -type ip -vlnv analog.com:user:axi_clkgen:1.0 axi_hdmi_clkgen]
set axi_hdmi_core [create_bd_cell -type ip -vlnv analog.com:user:axi_hdmi_tx:1.0 axi_hdmi_core]
set_property -dict [list CONFIG.PCORE_DEVICE_TYPE {1}] $axi_hdmi_core

set axi_hdmi_dma [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.2 axi_hdmi_dma]
set_property -dict [list CONFIG.c_m_axis_mm2s_tdata_width {64}] $axi_hdmi_dma
set_property -dict [list CONFIG.c_use_mm2s_fsync {1}] $axi_hdmi_dma
set_property -dict [list CONFIG.c_include_s2mm {0}] $axi_hdmi_dma

# audio peripherals

set sys_audio_clkgen [create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.1 sys_audio_clkgen]
set_property -dict [list CONFIG.PRIM_IN_FREQ {200.000}] $sys_audio_clkgen
set_property -dict [list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {12.288}] $sys_audio_clkgen

set axi_spdif_tx_core [create_bd_cell -type ip -vlnv analog.com:user:axi_spdif_tx:1.0 axi_spdif_tx_core]
set_property -dict [list CONFIG.C_DMA_TYPE {0}] $axi_spdif_tx_core
set_property -dict [list CONFIG.C_S_AXI_ADDR_WIDTH {16}] $axi_spdif_tx_core

set axi_spdif_tx_dma [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_spdif_tx_dma]
set_property -dict [list CONFIG.c_include_s2mm {0}] $axi_spdif_tx_dma
set_property -dict [list CONFIG.c_sg_include_stscntrl_strm {0}] $axi_spdif_tx_dma

# hdmi

ad_connect  sys_200m_clk axi_hdmi_clkgen/clk
ad_connect  sys_cpu_clk axi_hdmi_clkgen/drp_clk
ad_connect  sys_cpu_clk axi_hdmi_core/m_axis_mm2s_clk
ad_connect  sys_cpu_clk axi_hdmi_dma/m_axis_mm2s_aclk
ad_connect  axi_hdmi_core/hdmi_clk axi_hdmi_clkgen/clk_0
ad_connect  axi_hdmi_core/hdmi_out_clk hdmi_out_clk
ad_connect  axi_hdmi_core/hdmi_16_hsync hdmi_hsync
ad_connect  axi_hdmi_core/hdmi_16_vsync hdmi_vsync
ad_connect  axi_hdmi_core/hdmi_16_data_e hdmi_data_e
ad_connect  axi_hdmi_core/hdmi_16_data hdmi_data
ad_connect  axi_hdmi_core/m_axis_mm2s_tvalid axi_hdmi_dma/m_axis_mm2s_tvalid
ad_connect  axi_hdmi_core/m_axis_mm2s_tdata axi_hdmi_dma/m_axis_mm2s_tdata
ad_connect  axi_hdmi_core/m_axis_mm2s_tkeep axi_hdmi_dma/m_axis_mm2s_tkeep
ad_connect  axi_hdmi_core/m_axis_mm2s_tlast axi_hdmi_dma/m_axis_mm2s_tlast
ad_connect  axi_hdmi_core/m_axis_mm2s_tready axi_hdmi_dma/m_axis_mm2s_tready
ad_connect  axi_hdmi_core/m_axis_mm2s_fsync axi_hdmi_dma/mm2s_fsync
ad_connect  axi_hdmi_core/m_axis_mm2s_fsync axi_hdmi_core/m_axis_mm2s_fsync_ret
ad_connect  axi_hdmi_dma/mm2s_introut axi_hdmi_dma_intr

# spdif audio

ad_connect  axi_spdif_tx_core/S_AXIS_TVALID axi_spdif_tx_dma/m_axis_mm2s_tvalid
ad_connect  axi_spdif_tx_core/S_AXIS_TDATA axi_spdif_tx_dma/m_axis_mm2s_tdata
ad_connect  axi_spdif_tx_core/S_AXIS_TLAST axi_spdif_tx_dma/m_axis_mm2s_tlast
ad_connect  axi_spdif_tx_core/S_AXIS_TREADY axi_spdif_tx_dma/m_axis_mm2s_tready
ad_connect  sys_200m_clk sys_audio_clkgen/clk_in1
ad_connect  sys_audio_clkgen/clk_out1 axi_spdif_tx_core/spdif_data_clk
ad_connect  sys_cpu_clk axi_spdif_tx_core/S_AXIS_ACLK
ad_connect  sys_cpu_resetn axi_spdif_tx_core/S_AXIS_ARESETN
ad_connect  spdif axi_spdif_tx_core/spdif_tx_o
ad_connect  axi_spdif_tx_dma/mm2s_introut axi_spdif_tx_dma_intr

# processor interconnects

ad_cpu_interconnect 0x79000000 axi_hdmi_clkgen
ad_cpu_interconnect 0x70e00000 axi_hdmi_core
ad_cpu_interconnect 0x43000000 axi_hdmi_dma
ad_cpu_interconnect 0x75c00000 axi_spdif_tx_core
ad_cpu_interconnect 0x41E00000 axi_spdif_tx_dma

# memory interconnects

ad_mem_hp0_interconnect sys_cpu_clk axi_hdmi_dma/M_AXI_MM2S
ad_mem_hp0_interconnect sys_cpu_clk axi_spdif_tx_dma/M_AXI_SG
ad_mem_hp0_interconnect sys_cpu_clk axi_spdif_tx_dma/M_AXI_MM2S

