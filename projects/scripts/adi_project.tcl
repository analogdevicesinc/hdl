
variable p_board 
variable p_device 

if {![info exists REQUIRED_VIVADO_VERSION]} {
  set REQUIRED_VIVADO_VERSION "2014.4.1"
}

if {[info exists ::env(ADI_IGNORE_VERSION_CHECK)]} {
  set IGNORE_VERSION_CHECK 1
} elseif {![info exists IGNORE_VERSION_CHECK]} {
  set IGNORE_VERSION_CHECK 0
}

proc adi_project_create {project_name} {

  global ad_hdl_dir
  global ad_phdl_dir
  global p_board
  global p_device
  global REQUIRED_VIVADO_VERSION
  global IGNORE_VERSION_CHECK

  set p_device "none"
  set p_board "none"

  if [regexp "_ml605$" $project_name] {
    set p_device "xc6vlx240tff1156-1"
    set p_board "ml605"
  }
  if [regexp "_ac701$" $project_name] {
    set p_device "xc7a200tfbg676-2"
    set p_board "xilinx.com:artix7:ac701:1.0"
  }
  if [regexp "_kc705$" $project_name] {
    set p_device "xc7k325tffg900-2"
    set p_board "xilinx.com:kintex7:kc705:1.1"
  }
  if [regexp "_vc707$" $project_name] {
    set p_device "xc7vx485tffg1761-2"
    set p_board "xilinx.com:virtex7:vc707:1.1"
  }
  if [regexp "_kcu105$" $project_name] {
    set p_device "xcku040-ffva1156-2-e"
    set p_board "not-applicable"
  }
  if [regexp "_zed$" $project_name] {
    set p_device "xc7z020clg484-1"
    set p_board "em.avnet.com:zynq:zed:d"
  }
  if [regexp "_zc702$" $project_name] {
    set p_device "xc7z020clg484-1"
    set p_board "xilinx.com:zynq:zc702:1.0"
  }
  if [regexp "_zc706$" $project_name] {
    set p_device "xc7z045ffg900-2"
    set p_board "xilinx.com:zc706:part0:1.0"
  }
  if [regexp "_mitx045$" $project_name] {
    set p_device "xc7z045ffg900-2"
    set p_board "em.avnet.com:mini_itx_7z045:part0:1.0"
  }
  if [regexp "_rfsom$" $project_name] {
    set p_device "xc7z035ifbg676-2L"
    set p_board "not-applicable"
  }

  # planahead - 6 and down

  if {$p_board eq "ml605"} {

    set project_system_dir "./$project_name.srcs/sources_1/edk/$p_board"

    create_project $project_name . -part $p_device  -force
    set_property board $p_board [current_project]

    import_files -norecurse $ad_hdl_dir/projects/common/ml605/system.xmp

    generate_target {synthesis implementation} [get_files $project_system_dir/system.xmp]
    make_wrapper -files [get_files $project_system_dir/system.xmp] -top
    import_files -force -norecurse -fileset sources_1 $project_system_dir/system_stub.v

    return
  }

  # vivado - 7 and up

  if {!$IGNORE_VERSION_CHECK && [string compare [version -short] $REQUIRED_VIVADO_VERSION] != 0} {
    return -code error [format "ERROR: This project requires Vivado %s." $REQUIRED_VIVADO_VERSION]
  }

  set project_system_dir "./$project_name.srcs/sources_1/bd/system"

  create_project $project_name . -part $p_device -force
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
  global p_board

  # planahead - 6 and down

  if {$p_board eq "ml605"} {

    set project_system_dir "./$project_name.srcs/sources_1/edk/$p_board"

    set_property strategy MapTiming [get_runs impl_1]
    set_property strategy TimingWithIOBPacking [get_runs synth_1]

    launch_runs synth_1
    wait_on_run synth_1
    open_run synth_1
    report_timing -file timing_synth.log

    launch_runs impl_1 -to_step bitgen
    wait_on_run impl_1
    open_run impl_1
    report_timing -file timing_impl.log

    # -- Unable to find an equivalent
    #if [expr [get_property SLACK [get_timing_paths]] < 0] {
    #  puts "ERROR: Timing Constraints NOT met."
    #  use_this_invalid_command_to_crash
    #}

    export_hardware [get_files $project_system_dir/system.xmp] [get_runs impl_1] -bitstream

    return
  }

  # vivado - 7 and up

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

  #get_property STATS.THS [get_runs impl_1]
  #get_property STATS.TNS [get_runs impl_1]
  #get_property STATS.TPWS [get_runs impl_1]

  #export_hardware [get_files $project_system_dir/system.bd] [get_runs impl_1] -bitstream

  file mkdir $project_name.sdk
  file copy -force $project_name.runs/impl_1/system_top.sysdef $project_name.sdk/system_top.hdf

  if [expr [get_property SLACK [get_timing_paths]] < 0] {
    puts "ERROR: Timing Constraints NOT met."
    use_this_invalid_command_to_crash
  }
}

