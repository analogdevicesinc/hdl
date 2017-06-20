
source $ad_hdl_dir/projects/common/kcu105/kcu105_system_bd.tcl
source ../common/adv7511_bd.tcl

set_property -dict [list CONFIG.DEVICE_TYPE {1}] $axi_hdmi_core

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

