
source ../../scripts/kc705_system_bd.tcl
set_property -dict [list CONFIG.NUM_MI {13}] $axi_interconnect_1
set_property -dict [list CONFIG.NUM_SI {5}] $axi_interconnect_2
set_property -dict [list CONFIG.NUM_MI {1}] $axi_interconnect_2
set_property -dict [list CONFIG.NUM_PORTS {8}] $concat_intc_1


