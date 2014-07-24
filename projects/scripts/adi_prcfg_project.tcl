#-------------------------------------------------------------------------------
# Processes for non-project mode development flow used for partial reconfiguration
#-------------------------------------------------------------------------------

# Initialize the workspace
proc prcfg_init_workspace {prcfg_name_list} {

  # directory names
  set static_dir "prcfg_static"
  set sdk_dir "sdk_export"

  # make/clean all directory for design files
  if {![file exists $static_dir]} {
    file mkdir $static_dir
  } else {
    file delete -force $static_dir
    file mkdir $static_dir
  }

  foreach i $prcfg_name_list {
    if {![file exists prcfg_$i]} {
      file mkdir prcfg_$i
    } else {
      file delete -force prcfg_$i
      file mkdir prcfg_$i
    }
  }

  if {![file exists $sdk_dir]} {
    file mkdir $sdk_dir
  } else {
    file delete -force $sdk_dir
    file mkdir $sdk_dir
  }
}

# Create and synthesize the static part of the project
proc prcfg_synth_static { verilog_files xdc_files } {

  global ad_hdl_dir
  global ad_phdl_dir
  global part

  # location of the generated block design file
  set system_project_dir ".srcs/sources_1/bd/system"

  # create project in mememory
  create_project -in_memory -part $part

  # setup repo for library
  set lib_dirs $ad_hdl_dir/library
  lappend lib_dirs $ad_phdl_dir/library

  set_property ip_repo_paths $lib_dirs [current_fileset]
  update_ip_catalog

  # create bd design

  create_bd_design "system"
  source system_bd.tcl

  generate_target all [get_files $system_project_dir/system.bd]
  make_wrapper -files [get_files $system_project_dir/system.bd] -top
  read_verilog $system_project_dir/hdl/system_wrapper.v

  # add project files
  read_verilog $verilog_files
  read_xdc $xdc_files

  # run shyntesis
  file mkdir "./prcfg_static/logs"
  synth_design -mode default -top system_top -part $part > "./prcfg_static/logs/synth_static.rds"

  # generate hardware specification file for sdk
  export_hardware [get_files .srcs/sources_1/bd/system/system.bd] -dir "./sdk_export"

  # write checkpoint
  file mkdir "./prcfg_static/checkpoints"
  write_checkpoint -force "./prcfg_static/checkpoints/synth_static.dcp"
  close_project
}

# Create and synthesize the reconfigurable part of the project
proc prcfg_synth_reconf { prcfg_name verilog_files } {

  global ad_hdl_dir
  global ad_phdl_dir
  global part

  create_project -in_memory -part $part

  # add project files
  read_verilog $verilog_files

  # run OOC synthesis
  file mkdir "./prcfg_${prcfg_name}/logs"
  synth_design -mode out_of_context -top "prcfg_system_top" -part $part > "./prcfg_${prcfg_name}/logs/synth_${prcfg_name}.rds"

  # write checkpoint
  file mkdir "./prcfg_${prcfg_name}/checkpoints"
  write_checkpoint -force "./prcfg_${prcfg_name}/checkpoints/synth_${prcfg_name}.dcp"
  close_project
}

# Make the implementation of the project
proc prcfg_impl { xdc_file reconfig_name_list } {

  global part

  for { set i 0 } { $i < [llength $reconfig_name_list] } { incr i } {
    set prcfg_name [lindex $reconfig_name_list $i]
    if { $i == 0 } {

      open_checkpoint "./prcfg_static/checkpoints/synth_static.dcp" -part $part

      # Create the RP area on the fabric and load the default logic on it
      read_xdc $xdc_file
      read_checkpoint -cell i_prcfg_system_top "./prcfg_${prcfg_name}/checkpoints/synth_${prcfg_name}.dcp"
      set_property HD.RECONFIGURABLE 1 [get_cells i_prcfg_system_top]
      # implement the first configurations
      opt_design > "./prcfg_${prcfg_name}/logs/opt_${prcfg_name}.rds"
      # generate ltx file for debug probes
      write_debug_probes -force "./debug_nets.ltx"
      place_design > "./prcfg_${prcfg_name}/logs/place_${prcfg_name}.rds"
      route_design > "./prcfg_${prcfg_name}/logs/route_${prcfg_name}.rds"

      # save results
      save_results $prcfg_name

      # clear out RM
      update_design -cell i_prcfg_system_top -black_box

      # save static-only route
      write_checkpoint -force "./prcfg_static/checkpoints/route_static_only.dcp"

      close_project
    } else {

      open_checkpoint "./prcfg_static/checkpoints/route_static_only.dcp" -part $part

      # implement the next configuration
      # with the static-only design loaded in memory, lock down all placement and route
      lock_design -level routing

      read_checkpoint -cell i_prcfg_system_top "./prcfg_${prcfg_name}/checkpoints/synth_${prcfg_name}.dcp"
      opt_design > "./prcfg_${prcfg_name}/logs/opt_${prcfg_name}.rds"
      place_design > "./prcfg_${prcfg_name}/logs/place_${prcfg_name}.rds"
      route_design > "./prcfg_${prcfg_name}/logs/route_${prcfg_name}.rds"

      # save results
      save_results $prcfg_name

      close_project
    }
  }
}

# Save the result of an implementation, generate reports
proc save_results { prcfg_name } {

  file mkdir "./prcfg_${prcfg_name}/results"
  # checkpoint to the routed design
  write_checkpoint -force "./prcfg_${prcfg_name}/results/top_route_design.dcp"
  # reports
  report_utilization -file "./prcfg_${prcfg_name}/results/top_utilization.rpt"
  report_timing_summary -file "./prcfg_${prcfg_name}/results/top_timing_summary.rpt"
  # checkpoint to the routed RP
  write_checkpoint -force -cell i_prcfg_system_top "./prcfg_${prcfg_name}/checkpoints/route_rm_${prcfg_name}.dcp"

}

# Verify the compatibility of different configurations
proc prcfg_verify { prcfg_name_list } {
  set counter 0
  set list_length [llength $prcfg_name_list]

  file mkdir "./verify_design"

  for {set i 0} {$i < [expr $list_length - 1]} {incr i} {
    for {set j [expr $i + 1]} {$j < $list_length} {incr j} {
      set prcfg_name_a [lindex $prcfg_name_list $i]
      set prcfg_name_b [lindex $prcfg_name_list $j]
      pr_verify -full_check ./prcfg_${prcfg_name_a}/results/top_route_design.dcp \
                            ./prcfg_${prcfg_name_b}/results/top_route_design.dcp > \
                            ./verify_design/pr_verify_${counter}.rpt
      incr counter
    }
  }
}

# Generate bitstream
proc prcfg_gen_bit { prcfg_name_list } {

  global part

  foreach i $prcfg_name_list {
    open_checkpoint "./prcfg_${i}/results/top_route_design.dcp" -part $part
    file mkdir "./prcfg_${i}/bit"
    write_bitstream -force -bin_file -file "./prcfg_${i}/bit/config_${i}.bit"
    close_project
  }
}
