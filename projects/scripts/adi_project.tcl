
variable p_board
variable p_device
variable sys_zynq
variable p_prcfg_init
variable p_prcfg_list
variable p_prcfg_status

if {![info exists REQUIRED_VIVADO_VERSION]} {
  set REQUIRED_VIVADO_VERSION "2017.4.1"
}

if {[info exists ::env(ADI_IGNORE_VERSION_CHECK)]} {
  set IGNORE_VERSION_CHECK 1
} elseif {![info exists IGNORE_VERSION_CHECK]} {
  set IGNORE_VERSION_CHECK 0
}

set p_board "not-applicable"
set p_device "none"
set sys_zynq 1
set ADI_POWER_OPTIMIZATION 0

proc adi_project_xilinx {project_name {mode 0}} {

  global ad_hdl_dir
  global ad_phdl_dir
  global p_board
  global p_device
  global sys_zynq
  global REQUIRED_VIVADO_VERSION
  global IGNORE_VERSION_CHECK

  if [regexp "_ac701$" $project_name] {
    set p_device "xc7a200tfbg676-2"
    set p_board "xilinx.com:ac701:part0:1.0"
    set sys_zynq 0
  }
  if [regexp "_kc705$" $project_name] {
    set p_device "xc7k325tffg900-2"
    set p_board "xilinx.com:kc705:part0:1.1"
    set sys_zynq 0
  }
  if [regexp "_vc707$" $project_name] {
    set p_device "xc7vx485tffg1761-2"
    set p_board "xilinx.com:vc707:part0:1.1"
    set sys_zynq 0
  }
  if [regexp "_kcu105$" $project_name] {
    set p_device "xcku040-ffva1156-2-e"
    set p_board "xilinx.com:kcu105:part0:1.1"
    set sys_zynq 0
  }
  if [regexp "_zed$" $project_name] {
    set p_device "xc7z020clg484-1"
    set p_board "em.avnet.com:zed:part0:1.3"
    set sys_zynq 1
  }
  if [regexp "_microzed$" $project_name] {
    set p_device "xc7z010clg400-1"
    set p_board "not-applicable"
    set sys_zynq 1
  }
  if [regexp "_zc702$" $project_name] {
    set p_device "xc7z020clg484-1"
    set p_board "xilinx.com:zc702:part0:1.2"
    set sys_zynq 1
  }
  if [regexp "_zc706$" $project_name] {
    set p_device "xc7z045ffg900-2"
    set p_board "xilinx.com:zc706:part0:1.2"
    set sys_zynq 1
  }
  if [regexp "_mitx045$" $project_name] {
    set p_device "xc7z045ffg900-2"
    set p_board "not-applicable"
    set sys_zynq 1
  }
  if [regexp "_zcu102$" $project_name] {
    set p_device "xczu9eg-ffvb1156-2-e"
    set p_board "xilinx.com:zcu102:part0:3.1"
    set sys_zynq 2
  }

  set VIVADO_VERSION [version -short]
  if {[string compare $VIVADO_VERSION $REQUIRED_VIVADO_VERSION] != 0} {
    puts -nonewline "CRITICAL WARNING: vivado version mismatch; "
    puts -nonewline "expected $REQUIRED_VIVADO_VERSION, "
    puts -nonewline "got $VIVADO_VERSION.\n"
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
    set_property board_part $p_board [current_project]
  }

  set lib_dirs $ad_hdl_dir/library
  if {$ad_hdl_dir ne $ad_phdl_dir} {
    lappend lib_dirs $ad_phdl_dir/library
  }

  set_property ip_repo_paths $lib_dirs [current_fileset]
  update_ip_catalog

  ## Load custom message severity definitions
  source $ad_hdl_dir/projects/scripts/adi_xilinx_msg.tcl

  ## In Vivado there is a limit for the number of warnings and errors which are
  ## displayed by the tool for a particular error or warning; the default value
  ## of this limit is 100.
  ## Overrides the default limit to 2000.
  set_param messaging.defaultLimit 2000

  create_bd_design "system"
  source system_bd.tcl

  save_bd_design
  validate_bd_design

  set_property synth_checkpoint_mode None [get_files  $project_system_dir/system.bd]
  generate_target {synthesis implementation} [get_files  $project_system_dir/system.bd]
  make_wrapper -files [get_files $project_system_dir/system.bd] -top

  if {$mode == 0} {
    import_files -force -norecurse -fileset sources_1 $project_system_dir/hdl/system_wrapper.v
  } else {
    write_hwdef -file "$project_name.data/$project_name.hwdef"
  }
}

proc adi_project_files {project_name project_files} {

  add_files -norecurse -fileset sources_1 $project_files
  set_property top system_top [current_fileset]
}

proc adi_project_run {project_name} {
  global ADI_POWER_OPTIMIZATION

  launch_runs synth_1
  wait_on_run synth_1
  open_run synth_1
  report_timing_summary -file timing_synth.log

  if {![info exists ::env(ADI_NO_BITSTREAM_COMPRESSION)] && ![info exists ADI_NO_BITSTREAM_COMPRESSION]} {
    set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
  }

  if {$ADI_POWER_OPTIMIZATION == 1} {
  set_property STEPS.POWER_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
  set_property STEPS.POST_PLACE_POWER_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
  }

  launch_runs impl_1 -to_step write_bitstream
  wait_on_run impl_1
  open_run impl_1
  report_timing_summary -file timing_impl.log

  file mkdir $project_name.sdk

  if [expr [get_property SLACK [get_timing_paths]] < 0] {
    file copy -force $project_name.runs/impl_1/system_top.sysdef $project_name.sdk/system_top_bad_timing.hdf
  } else {
    file copy -force $project_name.runs/impl_1/system_top.sysdef $project_name.sdk/system_top.hdf
  }

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

