
source $ad_hdl_dir/projects/common/kcu105/kcu105_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/sys_adcfifo.tcl
source $ad_hdl_dir/projects/common/xilinx/sys_dacfifo.tcl

p_sys_adcfifo [current_bd_instance .] axi_ad9680_fifo 128 16
p_sys_dacfifo [current_bd_instance .] axi_ad9144_fifo 128 10

source ../common/daq2_bd.tcl

set_property -dict [list CONFIG.XCVR_TYPE {1}] $util_daq2_xcvr
set_property -dict [list CONFIG.QPLL_FBDIV {20}] $util_daq2_xcvr
set_property -dict [list CONFIG.QPLL_REFCLK_DIV {1}] $util_daq2_xcvr

set_property -dict [list CONFIG.S00_HAS_REGSLICE {4}] [get_bd_cells axi_mem_interconnect]
set_property -dict [list CONFIG.S01_HAS_REGSLICE {4}] [get_bd_cells axi_mem_interconnect]
set_property -dict [list CONFIG.S02_HAS_REGSLICE {4}] [get_bd_cells axi_mem_interconnect]
set_property -dict [list CONFIG.S03_HAS_REGSLICE {4}] [get_bd_cells axi_mem_interconnect]
set_property -dict [list CONFIG.S04_HAS_REGSLICE {4}] [get_bd_cells axi_mem_interconnect]
set_property -dict [list CONFIG.S05_HAS_REGSLICE {4}] [get_bd_cells axi_mem_interconnect]
set_property -dict [list CONFIG.S06_HAS_REGSLICE {4}] [get_bd_cells axi_mem_interconnect]
set_property -dict [list CONFIG.S07_HAS_REGSLICE {4}] [get_bd_cells axi_mem_interconnect]

set_property -dict [list CONFIG.ENABLE_ADVANCED_OPTIONS {1}] [get_bd_cells axi_ddr_interconnect]
set_property -dict [list CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER] [get_bd_cells axi_ddr_interconnect]
set_property -dict [list CONFIG.XBAR_DATA_WIDTH {512}] [get_bd_cells axi_ddr_interconnect]

