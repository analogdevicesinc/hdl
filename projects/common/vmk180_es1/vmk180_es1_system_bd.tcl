source $ad_hdl_dir/projects/common/vmk180/vmk180_system_bd.tcl

# Apply High VCC_AUX Current Draw workaround
set_property -dict [list \
  CONFIG.PMC_MIO_37_DIRECTION {out} \
  CONFIG.PMC_MIO_37_USAGE {GPIO} \
  CONFIG.PMC_MIO_37_OUTPUT_DATA {high} \
] [get_bd_cells sys_cips]

