
set xl_board "none"

proc adi_project_create {project_name} {

  global ad_hdl_dir
  global ad_phdl_dir
  global xl_board

  set xl_board "none"
  set project_part "none"
  set project_board "none"

  if [regexp "_ac701$" $project_name] {
    set xl_board "ac701"
    set project_part "xc7a200tfbg676-2"
    set project_board "xilinx.com:artix7:ac701:1.0"
  }
  if [regexp "_kc705$" $project_name] {
    set xl_board "kc705"
    set project_part "xc7k325tffg900-2"
    set project_board "xilinx.com:kintex7:kc705:1.1"
  }
  if [regexp "_vc707$" $project_name] {
    set xl_board "vc707"
    set project_part "xc7vx485tffg1761-2"
    set project_board "xilinx.com:virtex7:vc707:1.1"
  }
  if [regexp "_zed$" $project_name] {
    set xl_board "zed"
    set project_part "xc7z020clg484-1"
    set project_board "em.avnet.com:zynq:zed:d"
  }
  if [regexp "_zc702$" $project_name] {
    set xl_board "zc702"
    set project_part "xc7z020clg484-1"
    set project_board "xilinx.com:zynq:zc702:1.0"
  }
  if [regexp "_zc706$" $project_name] {
    set xl_board "zc706"
    set project_part "xc7z045ffg900-2"
    set project_board "xilinx.com:zynq:zc706:1.1"
  }

  set project_system_dir "./$project_name.srcs/sources_1/bd/system"

  create_project $project_name . -part $project_part -force
  set_property board $project_board [current_project]

  set lib_dirs $ad_hdl_dir/library
  if {$ad_hdl_dir ne $ad_phdl_dir} {
    lappend lib_dirs $ad_phdl_dir/library
  }

  set_property ip_repo_paths $lib_dirs [current_fileset]
  update_ip_catalog

  create_bd_design "system"
  source system_bd.tcl

  generate_target {synthesis implementation} [get_files  $project_system_dir/system.bd]
  make_wrapper -files [get_files $project_system_dir/system.bd] -top
  import_files -force -norecurse -fileset sources_1 $project_system_dir/hdl/system_wrapper.v
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

  set project_system_dir "./$project_name.srcs/sources_1/bd/system"

  set_property constrs_type XDC [current_fileset -constrset]

  launch_runs synth_1
  wait_on_run synth_1
  open_run synth_1
  report_timing_summary -file timing_synth.log

  set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
  set_property STEPS.PHYS_OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]

  launch_runs impl_1 -to_step write_bitstream
  wait_on_run impl_1
  open_run impl_1
  report_timing_summary -file timing_impl.log

  #get_property STATS.THS [get_runs impl_1]
  #get_property STATS.TNS [get_runs impl_1]
  #get_property STATS.TPWS [get_runs impl_1]

  if [expr [get_property SLACK [get_timing_paths]] < 0] {
    puts "ERROR: Timing Constraints NOT met."
    use_this_invalid_command_to_crash
  }

  export_hardware [get_files $project_system_dir/system.bd] [get_runs impl_1] -bitstream
}

