global m_dma_cfg
global s_dma_cfg
global vdma_cfg
global src_axis_vip_cfg
global dst_axis_vip_cfg
global mng_axi_cfg
global ddr_axi_cfg

# Create DUTs
ad_ip_instance axi_dmac master_dma $m_dma_cfg
adi_sim_add_define "M_DMAC=master_dma"

ad_ip_instance axi_dmac slave_dma $s_dma_cfg
adi_sim_add_define "S_DMAC=slave_dma"

# Create VDMA
ad_ip_instance axi_vdma vdma $vdma_cfg

# Create data source and destination
ad_ip_instance axi4stream_vip src_axis_vip $src_axis_vip_cfg
adi_sim_add_define "SRC_AXI_STRM=src_axis_vip"

ad_ip_instance axi4stream_vip dst_axis_vip $dst_axis_vip_cfg
adi_sim_add_define "DST_AXI_STRM=dst_axis_vip"

# Create data source and destination for VDMA 
ad_ip_instance axi4stream_vip ref_src_axis_vip $src_axis_vip_cfg
adi_sim_add_define "REF_SRC_AXI_STRM=ref_src_axis_vip"

ad_ip_instance axi4stream_vip ref_dst_axis_vip $dst_axis_vip_cfg
adi_sim_add_define "REF_DST_AXI_STRM=ref_dst_axis_vip"

# Create data storage (AXI slave)
ad_ip_instance axi_vip ddr_axi_vip $ddr_axi_cfg
adi_sim_add_define "DDR_AXI=ddr_axi_vip"

# Create instance: mng_axi , and set properties
# VIP for management port
ad_ip_instance axi_vip mng_axi_vip $mng_axi_cfg
adi_sim_add_define "MNG_AXI=mng_axi_vip"

# Create IO VIPs
ad_ip_instance io_vip src_sync_io_vip
adi_sim_add_define "SRC_SYNC_IO=src_sync_io_vip"
ad_ip_instance io_vip dst_sync_io_vip
adi_sim_add_define "DST_SYNC_IO=dst_sync_io_vip"

# Create clock gens
ad_ip_instance clk_vip mng_clk_vip [list \
  INTERFACE_MODE {MASTER} \
  FREQ_HZ {100000000} \
]
adi_sim_add_define "MNG_CLK=mng_clk_vip"

ad_ip_instance clk_vip ddr_clk_vip [list \
  INTERFACE_MODE {MASTER} \
  FREQ_HZ {250000000} \
]
adi_sim_add_define "DDR_CLK=ddr_clk_vip"

ad_ip_instance clk_vip src_clk_vip [list \
  INTERFACE_MODE {MASTER} \
  FREQ_HZ {100000000} \
]
adi_sim_add_define "SRC_CLK=src_clk_vip"

ad_ip_instance clk_vip dst_clk_vip [list \
  INTERFACE_MODE {MASTER} \
  FREQ_HZ {200000000} \
]
adi_sim_add_define "DST_CLK=dst_clk_vip"

ad_ip_instance rst_vip rst_gen [ list \
  INTERFACE_MODE {MASTER} \
  RST_POLARITY {ACTIVE_LOW} \
]
adi_sim_add_define "RST=rst_gen"

# add interconnect
# config
ad_ip_instance axi_interconnect axi_cfg_interconnect [ list \
  NUM_SI {1} \
  NUM_MI {3} \
]

# data
ad_ip_instance axi_interconnect axi_ddr_interconnect [ list \
  NUM_SI {4} \
  NUM_MI {1} \
]

# connect datapath
#  src AXIS - M_DMA - ddr interconnect
ad_connect src_axis_vip/M_AXIS master_dma/s_axis
ad_connect master_dma/m_dest_axi axi_ddr_interconnect/S00_AXI

#  ref src AXIS - VDMA - ddr interconnect
ad_connect ref_src_axis_vip/M_AXIS vdma/S_AXIS_S2MM
ad_connect vdma/M_AXI_S2MM axi_ddr_interconnect/S02_AXI

# ddr interconnect - S_DMA - dest AXIS
ad_connect slave_dma/m_src_axi axi_ddr_interconnect/S01_AXI
ad_connect slave_dma/m_axis dst_axis_vip/S_AXIS

# ddr interconnect - VDMA - ref dest AXIS
ad_connect vdma/M_AXI_MM2S axi_ddr_interconnect/S03_AXI
ad_connect vdma/M_AXIS_MM2S ref_dst_axis_vip/S_AXIS

# ddr interconnect to ddr AXI VIP
ad_connect axi_ddr_interconnect/M00_AXI ddr_axi_vip/S_AXI

# connect config
ad_connect mng_axi_vip/M_AXI  axi_cfg_interconnect/S00_AXI
ad_connect axi_cfg_interconnect/M00_AXI master_dma/s_axi
ad_connect axi_cfg_interconnect/M01_AXI slave_dma/s_axi
ad_connect axi_cfg_interconnect/M02_AXI vdma/S_AXI_LITE

# connect framelock
ad_connect master_dma/m_framelock slave_dma/s_framelock

# connect external syncs
if {[dict exists $m_dma_cfg USE_EXT_SYNC]} {
  if {[dict get $m_dma_cfg USE_EXT_SYNC] == 1} {
    ad_connect src_sync_io_vip/out master_dma/src_ext_sync
  }
}
if {[dict exists $s_dma_cfg USE_EXT_SYNC]} {
  if {[dict get $s_dma_cfg USE_EXT_SYNC] == 1} {
    ad_connect dst_sync_io_vip/out slave_dma/dest_ext_sync
  }
}

# connect external syncs to VDMA
if {[dict exists $vdma_cfg c_use_s2mm_fsync]} {
  if {[dict get $vdma_cfg c_use_s2mm_fsync] == 1} {
    ad_connect src_sync_io_vip/out vdma/s2mm_fsync
  }
}
if {[dict exists $vdma_cfg c_use_mm2s_fsync]} {
  if {[dict get $vdma_cfg c_use_mm2s_fsync] == 1} {
    ad_connect dst_sync_io_vip/out vdma/mm2s_fsync
  }
}

# connect reset and clocks
ad_connect rst_gen/rst_out master_dma/s_axi_aresetn
ad_connect rst_gen/rst_out master_dma/m_dest_axi_aresetn

ad_connect rst_gen/rst_out slave_dma/s_axi_aresetn
ad_connect rst_gen/rst_out slave_dma/m_src_axi_aresetn

ad_connect rst_gen/rst_out vdma/axi_resetn

ad_connect rst_gen/rst_out mng_axi_vip/aresetn

ad_connect rst_gen/rst_out axi_cfg_interconnect/ARESETN
ad_connect rst_gen/rst_out axi_cfg_interconnect/S00_ARESETN
ad_connect rst_gen/rst_out axi_cfg_interconnect/M00_ARESETN
ad_connect rst_gen/rst_out axi_cfg_interconnect/M01_ARESETN
ad_connect rst_gen/rst_out axi_cfg_interconnect/M02_ARESETN

ad_connect rst_gen/rst_out axi_ddr_interconnect/ARESETN
ad_connect rst_gen/rst_out axi_ddr_interconnect/S00_ARESETN
ad_connect rst_gen/rst_out axi_ddr_interconnect/S01_ARESETN
ad_connect rst_gen/rst_out axi_ddr_interconnect/S02_ARESETN
ad_connect rst_gen/rst_out axi_ddr_interconnect/S03_ARESETN
ad_connect rst_gen/rst_out axi_ddr_interconnect/M00_ARESETN

ad_connect rst_gen/rst_out src_axis_vip/aresetn
ad_connect rst_gen/rst_out ref_src_axis_vip/aresetn
ad_connect rst_gen/rst_out dst_axis_vip/aresetn
ad_connect rst_gen/rst_out ref_dst_axis_vip/aresetn
ad_connect rst_gen/rst_out ddr_axi_vip/aresetn

ad_connect mng_clk_vip/clk_out mng_axi_vip/aclk
ad_connect mng_clk_vip/clk_out master_dma/s_axi_aclk
ad_connect mng_clk_vip/clk_out slave_dma/s_axi_aclk
ad_connect mng_clk_vip/clk_out vdma/s_axi_lite_aclk
ad_connect mng_clk_vip/clk_out axi_cfg_interconnect/ACLK
ad_connect mng_clk_vip/clk_out axi_cfg_interconnect/S00_ACLK
ad_connect mng_clk_vip/clk_out axi_cfg_interconnect/M00_ACLK
ad_connect mng_clk_vip/clk_out axi_cfg_interconnect/M01_ACLK
ad_connect mng_clk_vip/clk_out axi_cfg_interconnect/M02_ACLK

ad_connect ddr_clk_vip/clk_out master_dma/m_dest_axi_aclk
ad_connect ddr_clk_vip/clk_out slave_dma/m_src_axi_aclk
ad_connect ddr_clk_vip/clk_out vdma/m_axi_mm2s_aclk
ad_connect ddr_clk_vip/clk_out vdma/m_axi_s2mm_aclk
ad_connect ddr_clk_vip/clk_out axi_ddr_interconnect/ACLK
ad_connect ddr_clk_vip/clk_out axi_ddr_interconnect/S00_ACLK
ad_connect ddr_clk_vip/clk_out axi_ddr_interconnect/S01_ACLK
ad_connect ddr_clk_vip/clk_out axi_ddr_interconnect/S02_ACLK
ad_connect ddr_clk_vip/clk_out axi_ddr_interconnect/S03_ACLK
ad_connect ddr_clk_vip/clk_out axi_ddr_interconnect/M00_ACLK
ad_connect ddr_clk_vip/clk_out ddr_axi_vip/aclk

ad_connect src_clk_vip/clk_out master_dma/s_axis_aclk
ad_connect src_clk_vip/clk_out vdma/s_axis_s2mm_aclk
ad_connect src_clk_vip/clk_out src_axis_vip/aclk
ad_connect src_clk_vip/clk_out ref_src_axis_vip/aclk
ad_connect src_clk_vip/clk_out src_sync_io_vip/clk

ad_connect dst_clk_vip/clk_out slave_dma/m_axis_aclk
ad_connect dst_clk_vip/clk_out vdma/m_axis_mm2s_aclk
ad_connect dst_clk_vip/clk_out dst_axis_vip/aclk
ad_connect dst_clk_vip/clk_out ref_dst_axis_vip/aclk
ad_connect dst_clk_vip/clk_out dst_sync_io_vip/clk

# assign addresses
create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 [get_bd_addr_spaces mng_axi_vip/Master_AXI] [get_bd_addr_segs master_dma/s_axi/axi_lite] SEG_axi_m_dmac_0_axi_lite
create_bd_addr_seg -range 0x00010000 -offset 0x44A10000 [get_bd_addr_spaces mng_axi_vip/Master_AXI] [get_bd_addr_segs  slave_dma/s_axi/axi_lite] SEG_axi_s_dmac_0_axi_lite
create_bd_addr_seg -range 0x00010000 -offset 0x44A20000 [get_bd_addr_spaces mng_axi_vip/Master_AXI] [get_bd_addr_segs vdma/S_AXI_LITE/Reg] SEG_axi_g_vdma_0_axi_lite

adi_sim_add_define "M_DMAC_BA=\'h44A00000"
adi_sim_add_define "S_DMAC_BA=\'h44A10000"
adi_sim_add_define "G_VDMA_BA=\'h44A20000"

# Create hierarchies
group_bd_cells DUT [get_bd_cells master_dma] [get_bd_cells slave_dma]
group_bd_cells clk_rst_gen [get_bd_cells ddr_clk_vip] [get_bd_cells src_clk_vip] [get_bd_cells dst_clk_vip] [get_bd_cells mng_clk_vip] [get_bd_cells rst_gen]

# assign DDR address range
assign_bd_address [get_bd_addr_segs {ddr_axi_vip/S_AXI/Reg }]
set_property offset 0x00000000 [get_bd_addr_segs {DUT/master_dma/m_dest_axi/SEG_ddr_axi_vip_Reg}]
set_property range 2G [get_bd_addr_segs {DUT/master_dma/m_dest_axi/SEG_ddr_axi_vip_Reg}]
set_property offset 0x00000000 [get_bd_addr_segs {DUT/slave_dma/m_src_axi/SEG_ddr_axi_vip_Reg}]
set_property range 2G [get_bd_addr_segs {DUT/slave_dma/m_src_axi/SEG_ddr_axi_vip_Reg}]

include_bd_addr_seg [get_bd_addr_segs -excluded vdma/Data_S2MM/SEG_ddr_axi_vip_Reg]
include_bd_addr_seg [get_bd_addr_segs -excluded vdma/Data_MM2S/SEG_ddr_axi_vip_Reg]
set_property offset 0x80000000 [get_bd_addr_segs {vdma/Data_MM2S/SEG_ddr_axi_vip_Reg}]
set_property range 2G [get_bd_addr_segs {vdma/Data_MM2S/SEG_ddr_axi_vip_Reg}]
set_property offset 0x80000000 [get_bd_addr_segs {vdma/Data_S2MM/SEG_ddr_axi_vip_Reg}]
set_property range 2G [get_bd_addr_segs {vdma/Data_S2MM/SEG_ddr_axi_vip_Reg}]
