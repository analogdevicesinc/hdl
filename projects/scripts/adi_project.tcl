
variable p_board
variable p_device
variable sys_zynq
variable p_prcfg_init
variable p_prcfg_list
variable p_prcfg_status

if {![info exists REQUIRED_VIVADO_VERSION]} {
  set REQUIRED_VIVADO_VERSION "2014.4.1"
}

if {[info exists ::env(ADI_IGNORE_VERSION_CHECK)]} {
  set IGNORE_VERSION_CHECK 1
} elseif {![info exists IGNORE_VERSION_CHECK]} {
  set IGNORE_VERSION_CHECK 0
}

proc adi_project_create {project_name {mode 0}} {

  global ad_hdl_dir
  global ad_phdl_dir
  global p_board
  global p_device
  global sys_zynq
  global REQUIRED_VIVADO_VERSION
  global IGNORE_VERSION_CHECK

  set p_device "none"
  set p_board "none"
  set sys_zynq 0

  if [regexp "_ac701$" $project_name] {
    set p_device "xc7a200tfbg676-2"
    set p_board "xilinx.com:artix7:ac701:1.0"
    set sys_zynq 0
  }
  if [regexp "_kc705$" $project_name] {
    set p_device "xc7k325tffg900-2"
    set p_board "xilinx.com:kintex7:kc705:1.1"
    set sys_zynq 0
  }
  if [regexp "_vc707$" $project_name] {
    set p_device "xc7vx485tffg1761-2"
    set p_board "xilinx.com:virtex7:vc707:1.1"
    set sys_zynq 0
  }
  if [regexp "_kcu105$" $project_name] {
    set p_device "xcku040-ffva1156-2-e"
    set p_board "not-applicable"
    set sys_zynq 0
  }
  if [regexp "_zed$" $project_name] {
    set p_device "xc7z020clg484-1"
    set p_board "em.avnet.com:zynq:zed:d"
    set sys_zynq 1
  }
  if [regexp "_zc702$" $project_name] {
    set p_device "xc7z020clg484-1"
    set p_board "xilinx.com:zynq:zc702:1.0"
    set sys_zynq 1
  }
  if [regexp "_zc706$" $project_name] {
    set p_device "xc7z045ffg900-2"
    set p_board "xilinx.com:zc706:part0:1.0"
    set sys_zynq 1
  }
  if [regexp "_mitx045$" $project_name] {
    set p_device "xc7z045ffg900-2"
    set p_board "not-applicable"
    set sys_zynq 1
  }
  if [regexp "_rfsom$" $project_name] {
    set p_device "xc7z035ifbg676-2L"
    set p_board "not-applicable"
    set sys_zynq 1
  }

  if {!$IGNORE_VERSION_CHECK && [string compare [version -short] $REQUIRED_VIVADO_VERSION] != 0} {
    return -code error [format "ERROR: This project requires Vivado %s." $REQUIRED_VIVADO_VERSION]
  }

  if {$mode == 0} {
    set project_system_dir "./$project_name.srcs/sources_1/bd/system"
    create_project $project_name . -part $p_device -force
  } else {
    set project_system_dir ".srcs/sources_1/bd/system"
    create_project -in_memory -part $p_device
  }

  if {$mode == 1} {
    file mkdir $project_name.data
  }

  if {$p_board ne "not-applicable"} {
    set_property board $p_board [current_project]
  }

  set lib_dirs $ad_hdl_dir/library
  if {$ad_hdl_dir ne $ad_phdl_dir} {
    lappend lib_dirs $ad_phdl_dir/library
  }

  set_property ip_repo_paths $lib_dirs [current_fileset]
  update_ip_catalog

  set_msg_config -id {BD 41-1348} -new_severity info
  set_msg_config -id {BD 41-1343} -new_severity info
  set_msg_config -id {BD 41-1306} -new_severity info
  set_msg_config -id {IP_Flow 19-1687} -new_severity info
  set_msg_config -id {filemgmt 20-1763} -new_severity info
  set_msg_config -severity {CRITICAL WARNING} -quiet -id {BD 41-1276} -new_severity error

  create_bd_design "system"
  source system_bd.tcl

  save_bd_design
  validate_bd_design

  generate_target {synthesis implementation} [get_files  $project_system_dir/system.bd]
  make_wrapper -files [get_files $project_system_dir/system.bd] -top

  if {$mode == 0} {
    import_files -force -norecurse -fileset sources_1 $project_system_dir/hdl/system_wrapper.v
  } else {
    write_hwdef -file "$project_name.data/$project_name.hwdef"
  }
}

proc adi_project_files {project_name project_files} {

  global ad_hdl_dir
  global ad_phdl_dir

  add_files -norecurse -fileset sources_1 $project_files
  set_property top system_top [current_fileset]
}

proc adi_project_run {project_name} {

  global ad_hdl_dir
  global ad_phdl_dir
  global p_board

  set project_system_dir "./$project_name.srcs/sources_1/bd/system"

  set_property constrs_type XDC [current_fileset -constrset]

  launch_runs synth_1
  wait_on_run synth_1
  open_run synth_1
  report_timing_summary -file timing_synth.log

  set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
  set_property STEPS.PHYS_OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]
  set_property STRATEGY "Performance_Explore" [get_runs impl_1]

  launch_runs impl_1 -to_step write_bitstream
  wait_on_run impl_1
  open_run impl_1
  report_timing_summary -file timing_impl.log

  file mkdir $project_name.sdk
  file copy -force $project_name.runs/impl_1/system_top.sysdef $project_name.sdk/system_top.hdf

  if [expr [get_property SLACK [get_timing_paths]] < 0] {
    return -code error [format "ERROR: Timing Constraints NOT met!"]
  }
}

proc adi_project_synth {project_name prcfg_name hdl_files {xdc_files ""}} {

  global p_device

  set p_prefix "$project_name.data/$project_name"

  if {$prcfg_name eq ""} {

    read_verilog .srcs/sources_1/bd/system/hdl/system_wrapper.v
    read_verilog $hdl_files
    read_xdc $xdc_files

    synth_design -mode default -top system_top -part $p_device > $p_prefix.synth.rds
    write_checkpoint -force $p_prefix.synth.dcp
    close_project

  } else {

    create_project -in_memory -part $p_device
    read_verilog $hdl_files
    synth_design -mode out_of_context -top "prcfg" -part $p_device > $p_prefix.${prcfg_name}_synth.rds
    write_checkpoint -force $p_prefix.${prcfg_name}_synth.dcp
    close_project
  }
}

proc adi_project_impl {project_name prcfg_name {xdc_files ""}} {

  global p_device
  global p_prcfg_init
  global p_prcfg_list
  global p_prcfg_status

  set p_prefix "$project_name.data/$project_name"

  if {$prcfg_name eq "default"} {
    set p_prcfg_status 0
    set p_prcfg_list ""
    set p_prcfg_init "$p_prefix.${prcfg_name}_impl.dcp"
    file mkdir $project_name.sdk
  }

  if {$prcfg_name eq "default"} {

    open_checkpoint $p_prefix.synth.dcp -part $p_device
    read_xdc $xdc_files
    read_checkpoint -cell i_prcfg $p_prefix.${prcfg_name}_synth.dcp
    set_property HD.RECONFIGURABLE 1 [get_cells i_prcfg]
    opt_design > $p_prefix.${prcfg_name}_opt.rds
    write_debug_probes -force $p_prefix.${prcfg_name}_debug_nets.ltx
    place_design > $p_prefix.${prcfg_name}_place.rds
    route_design > $p_prefix.${prcfg_name}_route.rds

  } else {

    open_checkpoint $p_prefix.default_impl_bb.dcp -part $p_device
    lock_design -level routing
    read_checkpoint -cell i_prcfg $p_prefix.${prcfg_name}_synth.dcp
    read_xdc $xdc_files
    opt_design > $p_prefix.${prcfg_name}_opt.rds
    place_design > $p_prefix.${prcfg_name}_place.rds
    route_design > $p_prefix.${prcfg_name}_route.rds
  }

  write_checkpoint -force $p_prefix.${prcfg_name}_impl.dcp
  report_utilization -pblocks pb_prcfg -file $p_prefix.${prcfg_name}_utilization.rpt
  report_timing_summary -file $p_prefix.${prcfg_name}_timing_summary.rpt

  if [expr [get_property SLACK [get_timing_paths]] < 0] {
    set p_prcfg_status 1
    puts "CRITICAL WARNING: Timing Constraints NOT met ($prcfg_name)!"
  }

  write_checkpoint -force -cell i_prcfg $p_prefix.${prcfg_name}_prcfg_impl.dcp
  update_design -cell i_prcfg -black_box
  write_checkpoint -force $p_prefix.${prcfg_name}_impl_bb.dcp
  open_checkpoint $p_prefix.${prcfg_name}_impl.dcp -part $p_device
  write_bitstream -force -bin_file -file $p_prefix.${prcfg_name}.bit
  write_sysdef -hwdef $p_prefix.hwdef -bitfile $p_prefix.${prcfg_name}.bit -file $p_prefix.${prcfg_name}.hdf
  file copy -force $p_prefix.${prcfg_name}.hdf $project_name.sdk/system_top.${prcfg_name}.hdf

  if {$prcfg_name ne "default"} {
    lappend p_prcfg_list "$p_prefix.${prcfg_name}_impl.dcp"
  }

  if {$prcfg_name eq "default"} {
    file copy -force $p_prefix.${prcfg_name}.hdf $project_name.sdk/system_top.hdf
  }
}

proc adi_project_verify {project_name} {

  global p_prcfg_init
  global p_prcfg_list
  global p_prcfg_status

  set p_prefix "$project_name.data/$project_name"

  pr_verify -full_check -initial $p_prcfg_init \
    -additional $p_prcfg_list \
    -file $p_prefix.prcfg_verify.log

  if {$p_prcfg_status == 1} {
    return -code error [format "ERROR: Timing Constraints NOT met!"]
  }
}

