###############################################################################
## Copyright (C) 2014-2023, 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## Define the ADI_USE_OOC_SYNTHESIS environment variable to enable out of context
#  synthesis
if {[info exists ::env(ADI_USE_OOC_SYNTHESIS)]} {
  if {[string equal $::env(ADI_USE_OOC_SYNTHESIS) n]} {
     set ADI_USE_OOC_SYNTHESIS 0
  } else {
     set ADI_USE_OOC_SYNTHESIS 1
  }
} elseif {![info exists ADI_USE_OOC_SYNTHESIS]} {
   set ADI_USE_OOC_SYNTHESIS 1
}

## Set number of parallel out of context jobs through environment variable
if {![info exists ::env(ADI_MAX_OOC_JOBS)]} {
  set ADI_MAX_OOC_JOBS 4
} else {
  set ADI_MAX_OOC_JOBS $::env(ADI_MAX_OOC_JOBS)
}

## Set to enable incremental compilation
set ADI_USE_INCR_COMP 1

## Set to enable power optimization
set ADI_POWER_OPTIMIZATION 0

## Set to generate .bin (for selmap)
if {![info exists ::env(ADI_GENERATE_BIN)]} {
  set ADI_GENERATE_BIN 0
} else {
  if {[string equal $::env(ADI_GENERATE_BIN) n]} {
     set ADI_GENERATE_BIN 0
  } else {
     set ADI_GENERATE_BIN 1
  }
}

## Initialize global variables
set p_board "not-applicable"
set p_device "none"
set sys_zynq 1

set p_prcfg_init ""
set p_prcfg_list ""
set p_prcfg_status ""

## Creates a Xilinx project for a given board
#
# \param[project_name] - name of the project
# \param[mode] - if set non-project mode will be used, otherwise project mode
# flow, see UG892 for more information
# \param[parameter_list] - a list of global parameters (parameters of the
# system_top module)
#
# Supported carrier names are: ac701, vcu118, kcu105, zed, microzed, zc702,
# zc706, mitx405, zcu102.
#
proc adi_project {project_name {mode 0} {parameter_list {}} } {

  set device ""
  set board ""

  # Determine the device based on the board name
  if [regexp "_ac701" $project_name] {
    set device "xc7a200tfbg676-2"
    set board [lindex [lsearch -all -inline [get_board_parts] *ac701*] end]
  }
  if [regexp "_vcu118" $project_name] {
    set device "xcvu9p-flga2104-2L-e"
    set board [lindex [lsearch -all -inline [get_board_parts] *vcu118*] end]
  }
  if [regexp "_kcu105" $project_name] {
    set device "xcku040-ffva1156-2-e"
    set board [lindex [lsearch -all -inline [get_board_parts] *kcu105*] end]
  }
  if [regexp "_zed" $project_name] {
    set device "xc7z020clg484-1"
    set board [lindex [lsearch -all -inline [get_board_parts] *zed*] end]
  }
  if [regexp "_coraz7s" $project_name] {
    set device "xc7z007sclg400-1"
    set board "not-applicable"
  }
  if [regexp "_microzed" $project_name] {
    set device "xc7z010clg400-1"
    set board "not-applicable"
  }
  if [regexp "_zc702" $project_name] {
    set device "xc7z020clg484-1"
    set board [lindex [lsearch -all -inline [get_board_parts] *zc702*] end]
  }
  if [regexp "_zc706" $project_name] {
    set device "xc7z045ffg900-2"
    set board [lindex [lsearch -all -inline [get_board_parts] *zc706*] end]
  }
  if [regexp "_mitx045" $project_name] {
    set device "xc7z045ffg900-2"
    set board "not-applicable"
  }
  if [regexp "_zcu102" $project_name] {
    set device "xczu9eg-ffvb1156-2-e"
    set board [lindex [lsearch -all -inline [get_board_parts] *zcu102*] end]
  }
  if [regexp "_vmk180_es1" $project_name] {
    enable_beta_device xcvm*
    xhub::refresh_catalog [xhub::get_xstores xilinx_board_store]
    xhub::install [xhub::get_xitems xilinx.com:xilinx_board_store:vmk180_es:*] -quiet
    set_param board.repoPaths [get_property LOCAL_ROOT_DIR [xhub::get_xstores xilinx_board_store]]
    set device "xcvm1802-vsva2197-2MP-e-S-es1"
    set board [lindex [lsearch -all -inline [get_board_parts] *vmk180_es*] end]
  }
  if [regexp "_vmk180" $project_name] {
    set device "xcvm1802-vsva2197-2MP-e-S"
    set board [lindex [lsearch -all -inline [get_board_parts] *vmk180*] end]
  }
  if [regexp "_vck190" $project_name] {
    set device "xcvc1902-vsva2197-2MP-e-S"
    set board [lindex [lsearch -all -inline [get_board_parts] *vck190*] end]
  }
  if [regexp "_vpk180" $project_name] {
    set device "xcvp1802-lsvc4072-2MP-e-S"
    set board [lindex [lsearch -all -inline [get_board_parts] *vpk180*] end]
  }
  if [regexp "_vc709" $project_name] {
    set device "xc7vx690tffg1761-2"
    set board [lindex [lsearch -all -inline [get_board_parts] *vc709*] end]
  }
  if [regexp "_kv260" $project_name] {
    set device "xck26-sfvc784-2LV-c"
    set board [lindex [lsearch -all -inline [get_board_parts] *kv260*] end]
  }
  if [regexp "_k26" $project_name] {
    set device "xck26-sfvc784-2LVI-i"
    set board [lindex [lsearch -all -inline [get_board_parts] *k26*] end]
  }

  adi_project_create $project_name $mode $parameter_list $device $board
}


## Creates a Xilinx project.
#
# \param[project_name] - name of the project
# \param[mode] - if set non-project mode will be used, otherwise project mode
# flow, see UG892 for more information
# \param[parameter_list] - a list of global parameters (parameters of the
# system_top module)
# \param[device] - Canonical Xilinx device string
# \param[board] - board BSP name (optional)
#
proc adi_project_create {project_name mode parameter_list device {board "not-applicable"}}  {

  global ad_hdl_dir
  global ad_ghdl_dir
  global ad_project_dir
  global p_board
  global p_device
  global sys_zynq
  global required_vivado_version
  global IGNORE_VERSION_CHECK
  global ADI_USE_OOC_SYNTHESIS
  global ADI_USE_INCR_COMP
  global use_smartconnect

  if {![info exists ::env(ADI_PROJECT_DIR)]} {
    set actual_project_name $project_name
  } else {
    set actual_project_name "$::env(ADI_PROJECT_DIR)${project_name}"
  }

  ## update the value of $p_device only if it was not already updated elsewhere
  if {$p_device eq "none"} {
    set p_device $device
  }
  set p_board $board

  set use_smartconnect 1
  if [regexp "^xc7z" $p_device] {
    # SmartConnect has higher resource utilization and worse timing closure on older families
    set use_smartconnect 0
  }

  if [regexp "^xc7z" $p_device] {
    set sys_zynq 1
  } elseif [regexp "^xck26" $p_device] {
    set sys_zynq 2
  } elseif [regexp "^xczu" $p_device]  {
    set sys_zynq 2
  } elseif [regexp "^xcv\[ecmph\]" $p_device]  {
    set sys_zynq 3
  } else {
    set sys_zynq 0
  }

  set VIVADO_VERSION [version -short]
  if {$IGNORE_VERSION_CHECK} {
    if {[string compare $VIVADO_VERSION $required_vivado_version] != 0} {
      puts -nonewline "CRITICAL WARNING: vivado version mismatch; "
      puts -nonewline "expected $required_vivado_version, "
      puts -nonewline "got $VIVADO_VERSION.\n"
    }
  } else {
    if {[string compare $VIVADO_VERSION $required_vivado_version] != 0} {
      puts -nonewline "ERROR: vivado version mismatch; "
      puts -nonewline "expected $required_vivado_version, "
      puts -nonewline "got $VIVADO_VERSION.\n"
      puts -nonewline "This ERROR message can be down-graded to CRITICAL WARNING by setting ADI_IGNORE_VERSION_CHECK environment variable to 1. Be aware that ADI will not support you, if you are using a different tool version.\n"
      exit 2
    }
  }

   if {[info exists ::env(ADI_MATLAB)]} {
    set ADI_MATLAB 1
    set actual_project_name "$ad_hdl_dir/vivado_prj"
    if {$mode != 0} {
        puts -nonewline "MATLAB builds do not support mode 2"
        exit 2
    }
  } else {
    set ADI_MATLAB 0
  }

  if {$mode == 0} {
     set project_system_dir "${actual_project_name}.srcs/sources_1/bd/system"
     if {$ADI_MATLAB == 0} {
       create_project ${actual_project_name} . -part $p_device -force
     }
  } else {
    set project_system_dir "${actual_project_name}.srcs/sources_1/bd/system"
    create_project -in_memory -part $p_device
  }

  if {$mode == 1} {
    file mkdir ${actual_project_name}.data
  }

  if {$p_board ne "not-applicable"} {
    set_property board_part $p_board [current_project]
  }

  if {$ADI_MATLAB == 0} {
    set lib_dirs $ad_hdl_dir/library
  } else {
    set lib_dirs [get_property ip_repo_paths [current_fileset]]
     lappend lib_dirs $ad_hdl_dir/library
  }
  if {[info exists ::env(ADI_GHDL_DIR)]} {
    if {$ad_hdl_dir ne $ad_ghdl_dir} {
      lappend lib_dirs $ad_ghdl_dir/library
    }
  }

  # Set a common IP cache for all projects
  if {$ADI_USE_OOC_SYNTHESIS == 1} {
    if {[file exists $ad_hdl_dir/ipcache] == 0} {
      file mkdir $ad_hdl_dir/ipcache
    }
    config_ip_cache -import_from_project -use_cache_location $ad_hdl_dir/ipcache
  }

  set_property ip_repo_paths $lib_dirs [current_fileset]
  update_ip_catalog

  ## Load custom message severity definitions

  if {![info exists ::env(ADI_DISABLE_MESSAGE_SUPPRESION)]} {
    source $ad_hdl_dir/projects/scripts/adi_xilinx_msg.tcl
  }

  ## In Vivado there is a limit for the number of warnings and errors which are
  ## displayed by the tool for a particular error or warning; the default value
  ## of this limit is 100.
  ## Overrides the default limit to 2000.
  set_param messaging.defaultLimit 2000

  # Set parameters of the top level file
  # Make the same parameters available to system_bd.tcl
  set proj_params [get_property generic [current_fileset]]
  foreach {param value} $parameter_list {
    lappend proj_params $param=$value
    set ad_project_params($param) $value
  }
  set_property generic $proj_params [current_fileset]

  create_bd_design "system"
  source system_bd.tcl

  save_bd_design
  validate_bd_design

  if {$ADI_USE_OOC_SYNTHESIS == 1} {
    set_property synth_checkpoint_mode Hierarchical [get_files  $project_system_dir/system.bd]
  } else {
    set_property synth_checkpoint_mode None [get_files  $project_system_dir/system.bd]
  }
  generate_target {synthesis implementation} [get_files  $project_system_dir/system.bd]
  if {$ADI_USE_OOC_SYNTHESIS == 1} {
    export_ip_user_files -of_objects [get_files  $project_system_dir/system.bd] -no_script -sync -force -quiet
    create_ip_run [get_files  $project_system_dir/system.bd]
  }
  make_wrapper -files [get_files $project_system_dir/system.bd] -top

  if {$mode == 0} {
    import_files -force -norecurse -fileset sources_1 $project_system_dir/hdl/system_wrapper.v
  } else {
    write_hwdef -file "${actual_project_name}.data/$project_name.hwdef"
  }

  if {$ADI_USE_INCR_COMP == 1} {
    if {[file exists ./reference.dcp]} {
      set_property incremental_checkpoint ./reference.dcp [get_runs impl_1]
    }
  }

}

## Add source files to an existing project.
#
# \param[project_name] - name of the project
# \param[project_files] - list of project files
#
proc adi_project_files {project_name project_files} {
  global ADI_POST_ROUTE_SCRIPT

  foreach pfile $project_files {
    if {[string range $pfile [expr 1 + [string last . $pfile]] end] == "xdc"} {
      add_files -norecurse -fileset constrs_1 $pfile
    } else {
      add_files -norecurse -fileset sources_1 $pfile
    }
  }

  if {[info exists ADI_POST_ROUTE_SCRIPT]} {
    add_files -fileset utils_1 -norecurse ${ADI_POST_ROUTE_SCRIPT}
  }

  # NOTE: top file name is always system_top
  set_property top system_top [current_fileset]
}

## Run an existing project (generate bit stream).
#
# \param[project_name] - name of the project
#
# Additional configuration flags are documented in docs/user_guide/build_hdl.rst
# at the "Available build flags and parameters" section.
proc adi_project_run {project_name} {

  global ad_project_dir
  global sys_zynq
  global ADI_POWER_OPTIMIZATION
  global ADI_USE_OOC_SYNTHESIS
  global ADI_MAX_OOC_JOBS
  global ADI_GENERATE_BIN
  global ADI_POST_ROUTE_SCRIPT

  if {[info exists ::env(ADI_MAX_THREADS)]} {
    set_param general.maxThreads ${::env(ADI_MAX_THREADS)}
    puts "INFO: maxThreads set to ${::env(ADI_MAX_THREADS)}"
  }

  if {![info exists ::env(ADI_PROJECT_DIR)]} {
    set actual_project_name $project_name
    set ad_project_dir ""
  } else {
    set actual_project_name "$::env(ADI_PROJECT_DIR)${project_name}"
    set ad_project_dir "$::env(ADI_PROJECT_DIR)"
  }
  if {[info exists ::env(ADI_SKIP_SYNTHESIS)]} {
    puts "Skipping synthesis"
    return
  }

  if {$ADI_USE_OOC_SYNTHESIS == 1} {
    launch_runs -jobs $ADI_MAX_OOC_JOBS system_*_synth_1 synth_1
  } else {
    launch_runs synth_1
  }
  wait_on_run synth_1
  open_run synth_1
  report_timing_summary -file ${ad_project_dir}timing_synth.log

  if {![info exists ::env(ADI_NO_BITSTREAM_COMPRESSION)] && ![info exists ADI_NO_BITSTREAM_COMPRESSION]} {
    set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
  }

  if {$ADI_POWER_OPTIMIZATION == 1} {
  set_property STEPS.POWER_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
  set_property STEPS.POST_PLACE_POWER_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
  }

  set_param board.repoPaths [get_property LOCAL_ROOT_DIR [xhub::get_xstores xilinx_board_store]]

  if {[info exists ADI_POST_ROUTE_SCRIPT]} {
    set_property STEPS.ROUTE_DESIGN.TCL.POST [ get_files ${ADI_POST_ROUTE_SCRIPT} -of [get_fileset utils_1] ] [get_runs impl_1]
  }

  launch_runs impl_1 -to_step write_bitstream
  wait_on_run impl_1
  open_run impl_1
  report_timing_summary -warn_on_violation -file ${ad_project_dir}timing_impl.log

  if {[info exists ::env(ADI_GENERATE_UTILIZATION)]} {
    set csv_file ${ad_project_dir}resource_utilization.csv
    if {[ catch {
      xilinx::designutils::report_failfast -csv -file $csv_file -transpose -no_header -ignore_pr -quiet
      set MMCM [llength [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ *MMCM* }]]
      set PLL [llength [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ *PLL* }]]
      set worst_slack_setup [get_property SLACK [get_timing_paths -setup]]
      set worst_slack_hold [get_property SLACK [get_timing_paths -hold]]

      set fileRead [open $csv_file r]
      set lines [split [read $fileRead] "\n"]
      set names_line [lindex $lines end-3]
      set values_line [lindex $lines end-2]
      close $fileRead

      set fileWrite [open $csv_file w]
      puts $fileWrite "$names_line,MMCM*,PLL*,Worst_Setup_Slack,Worst_Hold_Slack"
      puts $fileWrite "$values_line,$MMCM,$PLL,$worst_slack_setup,$worst_slack_hold"
      close $fileWrite
      } issue ] != 0 } {
        puts "GENERATE_REPORTS: tclapp::xilinx::designutils not installed"
      }

      # Define a list of IPs for which to generate report utilization
      set IP_list {
        ad_ip_jesd_204_tpl_adc
        ad_ip_jesd_204_tpl_dac
        axi_jesd204_rx
        axi_jesd204_tx
        jesd204_rx
        jesd204_tx
        axi_adxcvr
        util_adxcvr
        axi_dmac
        util_cpack2
        util_upack2
      }

      foreach IP_name $IP_list {
	set output_file ${ad_project_dir}${IP_name}_resource_utilization.log
        file delete $output_file
        foreach IP_instance [ get_cells -quiet -hierarchical -filter " ORIG_REF_NAME =~ $IP_name || REF_NAME =~ $IP_name " ] {
          report_utilization -hierarchical -hierarchical_depth 1 -cells $IP_instance -file $output_file -append -quiet
          report_property $IP_instance -file $output_file -append -quiet
          set report_file [ open $output_file a ]
          puts $report_file "\n\n\n"
          close $report_file
        }
      }
    } else {
    puts "GENERATE_REPORTS: Resource utilization files won't be generated because ADI_GENERATE_UTILIZATION env var is not set"
  }

  ## Extract IP ports and their properties

  if {[info exists ::env(ADI_EXTRACT_PORTS)]} {

    set p_output_file ports_properties.txt

    # Define a list of IPs for which to generate the ports properties and nets report
    set P_IP_list {
      util_wfifo
      util_rfifo
      util_cpack2
      util_upack2
      ad_ip_jesd204_tpl_adc
      ad_ip_jesd204_tpl_dac
      rx_fir_decimator
      tx_fir_interpolator
      axi_ad9361
      axi_adrv9009
    }

    set fileWrite [open $p_output_file w]

    foreach P_IP_name $P_IP_list {
      foreach P_IP_instance [ get_cells -quiet -hierarchical -filter " ORIG_REF_NAME =~ $P_IP_name || REF_NAME =~ $P_IP_name " ] {
        set P_IP_instance_name [regsub -all {i_system_wrapper\/system_i\/} $P_IP_instance {}]
	if { [regexp {adc_tpl_core} $P_IP_instance_name] } {
            set P_IP_INST  [regsub -all {\/adc_tpl_core/inst} $P_IP_instance_name {}]
            puts "$P_IP_INST\n"
        } elseif { [regexp {dac_tpl_core} $P_IP_instance_name] } {
            set P_IP_INST  [regsub -all {\/dac_tpl_core/inst} $P_IP_instance_name {}]
            puts "$P_IP_INST\n"
        } else {
            set P_IP_INST  [regsub -all {\/inst} $P_IP_instance_name {}]
            puts "$P_IP_INST\n"
        }
        puts $fileWrite "\n$P_IP_INST properties: \n"
        set list_of_IP_ports [ get_bd_pins -of_objects [get_bd_cells $P_IP_INST]]
        foreach IP_port $list_of_IP_ports {
          set pin_direction [get_property DIR [get_bd_pins $IP_port]]
          set pin_path [get_property PATH [get_bd_pins $IP_port]]
          set pin_path_name  [regsub {\/} $pin_path {}]
          set left [get_property LEFT [get_bd_pins $IP_port]]
          set right [get_property RIGHT [get_bd_pins $IP_port]]
          puts $fileWrite "direction $pin_direction \nMSB $left \nLSB $right \nname $pin_path_name"
          set net_info [get_bd_nets -of_objects [get_bd_pins $IP_port]]
          set net_name  [regsub -all {\/} $net_info {}]
          puts $fileWrite "net $net_name\n"
        }
      }
    }
    close $fileWrite

  } else {
  puts "GENERATE_PORTS_REPORTS: IP ports properties and nets report files won't be generated because ADI_EXTRACT_PORTS env var is not set"
  }

  if {[info exists ::env(ADI_GENERATE_XPA)]} {
    set csv_file ${ad_project_dir}power_analysis.csv
    set Layers "8to11"
    set CapLoad "20"
    set ToggleRate "15.00000"
    set StatProb "0.500000"

    set_load $CapLoad [all_outputs]
    set_operating_conditions -board_layers $Layers
    set_switching_activity -default_toggle_rate $ToggleRate
    set_switching_activity -default_static_probability $StatProb
    set_switching_activity -type lut -toggle_rate $ToggleRate -static_probability $StatProb -all
    set_switching_activity -type register -toggle_rate $ToggleRate -static_probability $StatProb -all
    set_switching_activity -type shift_register -toggle_rate $ToggleRate -static_probability $StatProb -all
    set_switching_activity -type lut_ram -toggle_rate $ToggleRate -static_probability $StatProb -all
    set_switching_activity -type bram -toggle_rate $ToggleRate -static_probability $StatProb -all
    set_switching_activity -type dsp -toggle_rate $ToggleRate -static_probability $StatProb -all
    set_switching_activity -type gt_rxdata -toggle_rate $ToggleRate -static_probability $StatProb -all
    set_switching_activity -type gt_txdata -toggle_rate $ToggleRate -static_probability $StatProb -all
    set_switching_activity -type io_output -toggle_rate $ToggleRate -static_probability $StatProb -all
    set_switching_activity -type bram_enable -toggle_rate $ToggleRate -static_probability $StatProb -all
    set_switching_activity -type bram_wr_enable -toggle_rate $ToggleRate -static_probability $StatProb -all
    set_switching_activity -type io_bidir_enable -toggle_rate $ToggleRate -static_probability $StatProb -all
    report_power -file $csv_file

    set fileRead [open $csv_file r]
    set filecontent [read $fileRead]
    set input_list [split $filecontent "\n"]

    set TextList [lsearch -all -inline $input_list "*Total On-Chip Power (W)*"]
    set on_chip_pwr "[lindex [lindex $TextList 0] 6] W"
    set TextList [lsearch -all -inline $input_list "*Junction Temperature (C)*"]
    set junction_temp "[lindex [lindex $TextList 0] 5] *C"
    close $fileRead

    set fileWrite [open $csv_file w]
    puts $fileWrite "On-chip_power,Junction_temp"
    puts $fileWrite "$on_chip_pwr,$junction_temp"
    close $fileWrite
  } else {
    puts "GENERATE_REPORTS: Power analysis files won't be generated because ADI_GENERATE_XPA env var is not set"
  }

  # Look for undefined clocks which do not show up in the timing summary
  set timing_check [check_timing -override_defaults no_clock -no_header -return_string]
  if {[regexp { (\d+) register} $timing_check -> num_regs]} {

    if {[info exist num_regs]} {
      if {$num_regs > 0} {
        puts "CRITICAL WARNING: There are $num_regs registers with no clocks !!! See no_clock.log for details."
        check_timing -override_defaults no_clock -verbose -file ${ad_project_dir}no_clock.log
      }
    }

  } else {
    puts "CRITICAL WARNING: The search for undefined clocks failed !!!"
  }

  file mkdir ${actual_project_name}.sdk

  set timing_string $[report_timing_summary -return_string]
  if { [string match "*VIOLATED*" $timing_string] == 1 ||
       [string match "*Timing constraints are not met*" $timing_string] == 1} {
    write_hw_platform -fixed -force  -include_bit -file ${actual_project_name}.sdk/system_top_bad_timing.xsa
    # Generate .bin file only for non Versal designs
    if {$ADI_GENERATE_BIN == 1} {
      if {$sys_zynq == 3} {
        puts "Bin generation skipped, Versal families do not support it."
      } else {
        write_bitstream -bin_file ${actual_project_name}.sdk/system_top_bad_timing.bit
      }
    }
    return -code error [format "ERROR: Timing Constraints NOT met!"]
  } else {
    write_hw_platform -fixed -force  -include_bit -file ${actual_project_name}.sdk/system_top.xsa
    # Generate .bin file only for non Versal designs
    if {$ADI_GENERATE_BIN == 1} {
      if {$sys_zynq == 3} {
        puts "Bin generation skipped, Versal families do not support it."
      } else {
        write_bitstream -bin_file ${actual_project_name}.sdk/system_top.bit
      }
    }
  }
}

## Run synthesis on an partial design; use it in Partial Reconfiguration flow.
#
# \param[project_name] - project name
# \param[prcfg_name] - name of the partial design
# \param[hdl_files] - hdl source of the partial design
# \param[xdc_files] - XDC constraint source of the partial design
#
proc adi_project_synth {project_name prcfg_name hdl_files {xdc_files ""}} {

  global p_device
  global ad_project_dir

  if {![info exists ::env(ADI_PROJECT_DIR)]} {
    set actual_project_name $project_name
  } else {
    set actual_project_name "$::env(ADI_PROJECT_DIR)${project_name}"
  }

  set p_prefix "${actual_project_name}.data/$project_name"

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

## Run implementation on an partial design; use it in Partial Reconfiguration
#  flow.
#
# \param[project_name] - project name
# \param[prcfg_name] - name of the partial design
# \param[xdc_files] - XDC constraint source of the partial design
#
proc adi_project_impl {project_name prcfg_name {xdc_files ""}} {

  global p_device
  global p_prcfg_init
  global p_prcfg_list
  global p_prcfg_status
  global ad_project_dir

  if {![info exists ::env(ADI_PROJECT_DIR)]} {
    set actual_project_name $project_name
  } else {
    set actual_project_name "$::env(ADI_PROJECT_DIR)${project_name}"
  }

  set p_prefix "${actual_project_name}.data/$project_name"

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

## Verify an implemented partial reconfiguration design, checks if all the
#  partial design are compatible with the base design.
#
# \param[project_name] - project name
#
proc adi_project_verify {project_name} {

  # checkpoint for the default design
  global p_prcfg_init
  # list of checkpoints with all the PRs integrated into the default design
  global p_prcfg_list
  global p_prcfg_status

  set p_prefix "${actual_project_name}.data/$project_name"

  pr_verify -full_check -initial $p_prcfg_init \
    -additional $p_prcfg_list \
    -file $p_prefix.prcfg_verify.log

  if {$p_prcfg_status == 1} {
    return -code error [format "ERROR: Timing Constraints NOT met!"]
  }
}
