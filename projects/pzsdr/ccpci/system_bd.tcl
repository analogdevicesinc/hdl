
source $ad_hdl_dir/projects/common/pzsdr/pzsdr_system_bd.tcl
source ../common/ccpci_bd.tcl

## temporary
## ila 

delete_bd_objs [get_bd_cells ila_adc]
delete_bd_objs [get_bd_nets axi_ad9361_tdd_dbg] [get_bd_cells ila_tdd]

