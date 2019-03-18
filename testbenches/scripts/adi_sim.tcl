# List of defines which will be passed to the simulation
variable adi_sim_defines {}
variable design_name "test_harness"

proc adi_sim_add_define {value} {
  global adi_sim_defines
  lappend adi_sim_defines $value
}

proc adi_sim_project_xilinx {project_name } {
  global design_name

  # Create project
  create_project ${project_name} ./runs/${project_name} -part xc7vx485tffg1157-1 -force

  # Set project properties
  set_property -name "default_lib" -value "xil_defaultlib" -objects [current_project]

  # Set IP repository paths
  set_property "ip_repo_paths" "[file normalize "./../../../hdl/library"] " \
    [get_filesets sources_1]

  # Rebuild user ip_repo's index before adding any source files
  update_ip_catalog -rebuild


  ## Create the bd
  ######################
  create_bd_design $design_name
  # Build the test harness based on the topology
  source system_bd.tcl

  save_bd_design
  validate_bd_design

  # Pass the test harness instance name to the simulation
  adi_sim_add_define "TH=$design_name"
}

proc adi_sim_project_files {project_files} {
  add_files -fileset sim_1 $project_files
  # Set 'sim_1' fileset properties
  set_property -name "top" -value "system_tb" -objects [get_filesets sim_1]
}

proc adi_sim_generate {project_name } {
  global design_name
  global adi_sim_defines

  # Set the defines for simulation
  set_property verilog_define $adi_sim_defines [get_filesets sim_1]

  set_property -name {xsim.simulate.runtime} -value {} -objects [get_filesets sim_1]

  set project_system_dir "./runs/$project_name/$project_name.srcs/sources_1/bd/$design_name"

  generate_target Simulation [get_files $project_system_dir/$design_name.bd]

  set_property include_dirs . [get_filesets sim_1]
}

proc adi_open_project {project_path} {
  open_project $project_path
}

proc adi_update_define {name value} {
  set defines [get_property verilog_define [get_filesets sim_1]]
  foreach def $defines {
    set def [split $def {=}]
    if {[lindex $def 0] == $name} {
      set def [lreplace $def 1 1 $value]
      puts "reaplacing"
      }
    lappend defines_new "[lindex $def 0]=[lindex $def 1]"
  }
  set_property verilog_define $defines_new [get_filesets sim_1]

}
