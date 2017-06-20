
source $ad_hdl_dir/projects/common/kcu105/kcu105_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/sys_dmafifo.tcl

p_sys_dmafifo [current_bd_instance .] axi_ad9680_fifo 128 16
p_sys_dacfifo [current_bd_instance .] axi_ad9144_fifo 128 10

source ../common/daq2_bd.tcl

set_property -dict [list CONFIG.GTH_OR_GTX_N {1}] $axi_daq2_gt
set_property -dict [list CONFIG.QPLL0_FBDIV {20}] $axi_daq2_gt
set_property -dict [list CONFIG.QPLL0_REFCLK_DIV {1}] $axi_daq2_gt

ad_connect  axi_ad9144_fifo/dac_fifo_bypass GND

set_property -dict [list CONFIG.ENABLE_ADVANCED_OPTIONS {1}] [get_bd_cells axi_mem_interconnect]
set_property -dict [list CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER] [get_bd_cells axi_mem_interconnect]
set_property -dict [list CONFIG.XBAR_DATA_WIDTH {512}] [get_bd_cells axi_mem_interconnect]
set_property -dict [list CONFIG.M00_HAS_REGSLICE {4}] [get_bd_cells axi_mem_interconnect]
set_property -dict [list CONFIG.S00_HAS_REGSLICE {4}] [get_bd_cells axi_mem_interconnect]
set_property -dict [list CONFIG.S01_HAS_REGSLICE {4}] [get_bd_cells axi_mem_interconnect]
set_property -dict [list CONFIG.S02_HAS_REGSLICE {4}] [get_bd_cells axi_mem_interconnect]
set_property -dict [list CONFIG.S03_HAS_REGSLICE {4}] [get_bd_cells axi_mem_interconnect]
set_property -dict [list CONFIG.S04_HAS_REGSLICE {4}] [get_bd_cells axi_mem_interconnect]
set_property -dict [list CONFIG.S05_HAS_REGSLICE {4}] [get_bd_cells axi_mem_interconnect]
set_property -dict [list CONFIG.S06_HAS_REGSLICE {4}] [get_bd_cells axi_mem_interconnect]
set_property -dict [list CONFIG.S07_HAS_REGSLICE {4}] [get_bd_cells axi_mem_interconnect]

