
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl
# github.com/analogdevicesinc/hdl/blob/master/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl

adi_project_xilinx fmcjesdadc1_kc705 1
adi_project_synth fmcjesdadc1_kc705 "" [list \
  "../common/fmcjesdadc1_spi.v" \
  "./hdl/design/system_top.v" \
  "./hdl/design/trigger_gen.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "$ad_hdl_dir/library/common/ad_sysref_gen.v"] \
  [list "./constrs/system_constr.xdc" \
  "./constrs/kc705_system_constr.xdc" ]
  
#  "$ad_hdl_dir/projects/common/kc705/kc705_system_constr.xdc" ]

set project_name fmcjesdadc1_kc705
set p_prefix "$project_name.data/$project_name"

puts $project_name

#https://github.com/analogdevicesinc/hdl/blob/master/projects/scripts/adi_project.tcl
#
#adi_project_impl fmcjesdadc1_kc705 "" "system_constr.xdc"

#adi_project_files fmcjesdadc1_kc705 [list \
  #"../common/fmcjesdadc1_spi.v" \
  #"system_top.v" \
  #"system_constr.xdc" \
  #"$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  #"$ad_hdl_dir/library/common/ad_sysref_gen.v" \
  #"$ad_hdl_dir/projects/common/kc705/kc705_system_constr.xdc" ]

#adi_project_run fmcjesdadc1_kc705

