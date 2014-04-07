

create_project ad_usdrx1_zc706 . -part xc7z045ffg900-2 -force
set_property board xilinx.com:zynq:zc706:1.1 [current_project]
set_property ip_repo_paths ../../../library [current_fileset]
update_ip_catalog

create_bd_design "system"
source system_bd.tcl

generate_target {synthesis implementation} \
  [get_files  ./ad_usdrx1_zc706.srcs/sources_1/bd/system/system.bd]

make_wrapper -files [get_files ./ad_usdrx1_zc706.srcs/sources_1/bd/system/system.bd] -top
import_files -force -norecurse -fileset sources_1 ./ad_usdrx1_zc706.srcs/sources_1/bd/system/hdl/system_wrapper.v
add_files -norecurse -fileset sources_1 ../../../library/misc/usdrx1_spi.v
add_files -norecurse -fileset sources_1 system_top.v
add_files -norecurse -fileset constrs_1 system_constr.xdc

set_property top system_top [current_fileset]

launch_runs synth_1
wait_on_run synth_1
open_run synth_1
report_timing_summary -file report_timing_summary_synth_1.log

launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
open_run impl_1
report_timing_summary -file report_timing_summary_impl_1.log

export_hardware [get_files ./ad_usdrx1_zc706.srcs/sources_1/bd/system/system.bd] \
  [get_runs impl_1] -bitstream


