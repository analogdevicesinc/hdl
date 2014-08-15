

proc use_this_invalid_command_to_crash {} {

  puts "Ignoring timing errors for now!"
}

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl

adi_project_create daq2_kcu105
adi_project_files daq2_kcu105 [list \
  "../common/daq2_spi.v" \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/kcu105/kcu105_system_constr.xdc" ]

adi_project_run daq2_kcu105


