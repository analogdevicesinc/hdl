###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## SPDX short identifier: ADIBSD
###############################################################################

###############################################################################
# Microchip Libero SoC project procedures.
#
# * adi_project       - Creates a new Libero project.
# * adi_project_files - Imports HDL and constraint files, generates the
#                       SmartDesign, rebuilds the design hierarchy, and
#                       optionally finalizes constraint targets and tool
#                       associations.
# * adi_project_sim   - Sets up the presynth simulation with a testbench and
#                       writes its QuestaSim script (run.do).
# * adi_project_run   - Runs synthesis, place-and-route, timing verification,
#                       and exports the programming job file.
# * adi_project_envm_job - Exports the job of a built project with the HSS in
#                       the eNVM.
###############################################################################

source $ad_hdl_dir/scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_microchip.tcl

###############################################################################
## Writes the current project parameter overrides into a text file under the
## project directory.
##
## The generated file is consumed by helper scripts and debug workflows that
## need the resolved parameter set used for this build.
###############################################################################
proc adi_project_generate_parameter_file {} {
  global ad_project_dir
  global ad_project_params

  if {![array exists ad_project_params] || [llength [array names ad_project_params]] == 0} {
    return ""
  }

  set parameter_file_path [file join $ad_project_dir system_top_parameters.txt]
  set fh [open $parameter_file_path w]
  puts $fh "# System top parameters"
  puts $fh "# Generated on [clock format [clock seconds]]"
  puts $fh ""
  foreach param_name [lsort [array names ad_project_params]] {
    puts $fh "$param_name=$ad_project_params($param_name)"
  }
  close $fh

  return $parameter_file_path
}

###############################################################################
## Stores project-level parameter overrides from a flat NAME VALUE list.
##
## \param[parameter_list] - flat Tcl list: {NAME1 VALUE1 NAME2 VALUE2 ...}
###############################################################################
proc adi_project_set_parameters {parameter_list} {
  global ad_project_params

  if {[llength $parameter_list] == 0} {
    return
  }

  if {[llength $parameter_list] % 2 != 0} {
    error "adi_project: -parameter_list expects NAME VALUE pairs."
  }

  foreach {param_name param_value} $parameter_list {
    set ad_project_params($param_name) $param_value
  }
}

###############################################################################
## Creates a parameterized copy of a Verilog/SystemVerilog source file.
##
## Matching `parameter` assignments are rewritten into `output_file`; the
## original source is left untouched.
##
## \param[input_file]   - original Verilog/SystemVerilog file
## \param[output_file]  - generated file written into the project hdl/ folder
## \param[parameters]   - flat Tcl list: {NAME1 VALUE1 NAME2 VALUE2 ...}
## \return 1 if the file was rewritten, otherwise 0.
###############################################################################
proc adi_project_update_verilog_parameters {input_file output_file parameters} {
  if {[llength $parameters] == 0} {
    return 0
  }

  set fh [open $input_file r]
  set data [read $fh]
  close $fh

  array set param_map {}
  foreach {param_name param_value} $parameters {
    set param_map([string trim $param_name]) [string trim $param_value]
  }

  set updated_params {}
  set new_lines {}
  foreach line [split $data "\n"] {
    set updated_line $line
    if {[regexp {^(\s*parameter\s+)(\w+)(\s*=\s*)([^,;]+)(.*)} $line -> prefix param_name separator param_value suffix]} {
      set trimmed_name [string trim $param_name]
      if {[info exists param_map($trimmed_name)]} {
        set updated_line "${prefix}${trimmed_name}${separator}$param_map($trimmed_name)${suffix}"
        lappend updated_params $trimmed_name
      }
    }
    lappend new_lines $updated_line
  }

  if {[llength $updated_params] == 0} {
    return 0
  }

  set fh [open $output_file w]
  puts -nonewline $fh [join $new_lines "\n"]
  close $fh

  return 1
}

###############################################################################
## Returns only the parameter overrides that exist on the given HDL source.
##
## \param[hdl_source] - Verilog/SystemVerilog module source file
## \return flat Tcl list of matching NAME VALUE pairs.
###############################################################################
proc adi_project_get_matching_parameters {hdl_source} {
  global ad_project_params

  set matching_params {}
  if {![array exists ad_project_params]} {
    return $matching_params
  }

  set mod_data [ipm::parse_module $hdl_source]
  foreach param [dict get $mod_data parlist] {
    set param_name [dict get $param name]
    if {[info exists ad_project_params($param_name)]} {
      lappend matching_params $param_name $ad_project_params($param_name)
    }
  }

  return $matching_params
}

###############################################################################
## Resolves the HDL file that should be imported for the selected top module.
##
## If active parameter overrides match the source file, this procedure creates
## a generated copy at `output_file` and returns that path. When no explicit
## output path is given, it falls back to the project hdl/ directory. If no
## parameter rewrite is needed, it returns the original source path unchanged.
##
## \param[hdl_source]  - top-level HDL source file
## \param[output_file] - optional generated-file path
## \return normalized path to the original or generated HDL file.
###############################################################################
proc adi_project_resolve_hdl_source {hdl_source {output_file ""}} {
  global ad_project_dir

  set normalized_source [file normalize $hdl_source]
  set extension [string tolower [file extension $normalized_source]]
  if {$extension ni {".v" ".sv"}} {
    return $normalized_source
  }

  set matching_params [adi_project_get_matching_parameters $normalized_source]
  if {[llength $matching_params] == 0} {
    return $normalized_source
  }

  if {$output_file eq ""} {
    set output_dir [file join $ad_project_dir hdl]
    file mkdir $output_dir
    set output_file [file join $output_dir [file tail $normalized_source]]
  } else {
    set output_file [file normalize $output_file]
    file mkdir [file dirname $output_file]
  }

  if {![adi_project_update_verilog_parameters $normalized_source $output_file $matching_params]} {
    return $normalized_source
  }

  return [file normalize $output_file]
}

###############################################################################
## Splits option/value arguments into local options and passthrough options.
##
## Known keys from `local_opt` are parsed into the returned option array;
## everything else is preserved for the caller to forward elsewhere.
##
## \param[args]       - flat option/value argument list
## \param[local_opt]  - flat default option/value list for this procedure
## \return two-element list: {parsed_local_options passthrough_args}
###############################################################################
proc adi_project_parse_args {args local_opt} {
  if {[llength $args] % 2 != 0} {
    error "Expected option/value pairs."
  }

  array set opt $local_opt
  set local_keys [dict keys $local_opt]
  set passthrough_args {}

  foreach {arg value} $args {
    if {[lsearch -exact $local_keys $arg] >= 0} {
      set opt($arg) $value
    } else {
      lappend passthrough_args $arg $value
    }
  }

  return [list [array get opt] $passthrough_args]
}

###############################################################################
## Associates an ordered list of already-imported constraint files to one tool.
##
## \param[tool]              - Libero tool name, e.g. SYNTHESIZE or PLACEROUTE
## \param[module]            - full Libero module name, usually <root>::work
## \param[constraint_files]  - ordered list of project-local constraint paths
###############################################################################
proc adi_project_organize_constraints {tool module constraint_files} {
  if {[llength $constraint_files] == 0} {
    return
  }

  set organize_args [list -tool $tool]
  foreach constraint_file $constraint_files {
    lappend organize_args -file $constraint_file
  }
  lappend organize_args -module $module -input_type {constraint}
  organize_tool_files {*}$organize_args
}

###############################################################################
## Maps an original vendor file-add option to its constraint type and the
## project-local sub-directory Libero imports that type into.
##
## \param[vendor_option]  - one of `-io_pdc`, `-fp_pdc`, `-sdc`
## \return {type subdir} pair, e.g. {io_pdc constraint/io}
###############################################################################
proc adi_project_constraint_option_info {vendor_option} {
  switch -exact -- $vendor_option {
    -io_pdc { return [list io_pdc [file join constraint io]] }
    -fp_pdc { return [list fp_pdc [file join constraint fp]] }
    -sdc    { return [list sdc [file join constraint]] }
    default {
      error "adi_project: unsupported constraint file option '$vendor_option'"
    }
  }
}

###############################################################################
## Creates a new Libero SoC project.
#
# An existing project directory is deleted first: the project is always built
# from its sources. Local options are handled here; any remaining options are
# passed through to `new_project`.
#
# \param[project_name]  - project name
# \opt[dev_select]      -dev_select "auto"
# \opt[ppath]           -ppath "./_bld/prj", or the ADI_BUILD_DIR
#                       environment variable when it is set
#                       (project-microchip.mk sets it from the make
#                       parameters); the project directory itself
# \opt[family]          -family "PolarFireSoC"
# \opt[device]          -device ""
# \opt[die]             -die ""
# \opt[package]         -package ""
# \opt[speed]           -speed ""
# \opt[die_voltage]     -die_voltage ""
# \opt[hdl]             -hdl "VERILOG"
# \opt[parameter_list]  -parameter_list {NAME1 VALUE1 NAME2 VALUE2}
###############################################################################
proc adi_project {project_name args} {
  global ad_hdl_dir
  global ad_project_dir
  global required_libero_version
  global IGNORE_VERSION_CHECK

  # the project name for the later steps (adi_pd.tcl takes it from the global
  # project_name; Libero has no current_project like Vivado)
  set ::project_name $project_name

  set local_opt [list \
    -dev_select   "auto" \
    -ppath        [get_env_param ADI_BUILD_DIR "./_bld/prj"] \
    -family       "PolarFireSoC" \
    -device       "" \
    -die          "" \
    -package      "" \
    -speed        "" \
    -die_voltage  "" \
    -hdl          "VERILOG" \
    -parameter_list {}]

  lassign [adi_project_parse_args $args $local_opt] parsed_opt new_project_optional_args
  array set opt $parsed_opt

  set dev_select  $opt(-dev_select)
  set ppath       [file normalize $opt(-ppath)]
  set ad_project_dir $ppath
  set family      $opt(-family)
  set hdl         $opt(-hdl)

  adi_project_set_parameters $opt(-parameter_list)

  # -- Version check ----------------------------------------------------------
  if {![info exists IGNORE_VERSION_CHECK] || !$IGNORE_VERSION_CHECK} {
    set libero_ver [get_libero_version]
    if {![string match "${required_libero_version}*" $libero_ver]} {
      puts "WARNING: Libero version mismatch. Required: $required_libero_version, Found: $libero_ver"
    }
  }

  # -- Device selection -------------------------------------------------------
  if {[string match "auto" $dev_select]} {
    source $ad_hdl_dir/projects/scripts/adi_microchip_dev_select.tcl
  } elseif {[string match "manual" $dev_select]} {
    set device      $opt(-device)
    set die         $opt(-die)
    set package     $opt(-package)
    set speed       $opt(-speed)
    set die_voltage $opt(-die_voltage)
  } else {
    puts "ERROR: adi_project: unknown -dev_select value: $dev_select"
    exit 2
  }

  # -- Create project ---------------------------------------------------------
  if {[file exists $ppath]} {
    file delete -force $ppath
  }

  new_project \
    -name              $project_name \
    -location          $ppath \
    -family            $family \
    -die               $die \
    -package           $package \
    -speed             $speed \
    -die_voltage       $die_voltage \
    -hdl               $hdl {*}$new_project_optional_args

  puts "Created Libero project: $ppath/$project_name.prjx"

  save_project
}

###############################################################################
## Imports HDL and constraint files into the open project, generates the
## SmartDesign and rebuilds the Libero hierarchy view.
#
# The first phase imports every file into the project and generates the
# SmartDesign `sd_name` (empty: none). When constraint inputs are present, the
# second phase delegates target selection and tool binding to
# `adi_project_finalize_constraints`.
#
# Local options:
# \opt[top_module_file_in]  -top_module_file_in "system_top.v"
# \opt[top_module_file_out] -top_module_file_out ""
# \opt[root]                -root "system_top"
# \opt[finalize_constraints] -finalize_constraints auto|0|1: auto finalizes if
#                           a constraint group is given; 1 also without one
#                           (the derived SDC of the cores still constrains the
#                           timing); 0 imports the constraints without binding
#                           them to the tools
# \opt[sd_name]             -sd_name "system_lb"
#
# All remaining arguments are passed directly to `import_files`.
#
# Constraints are given as tool groups `-synthesize`, `-placeroute`, and
# `-verifytiming`. Each group is an option list of original vendor file-add
# options, e.g. `-placeroute {-io_pdc a.pdc -io_pdc b.pdc}`.
###############################################################################
proc adi_project_files {project_name args} {
  global ad_project_dir

  set local_opt [list \
    -top_module_file_in system_top.v \
    -top_module_file_out "" \
    -finalize_constraints auto \
    -sd_name "system_lb" \
    -root "system_top" \
    -synthesize {} \
    -placeroute {} \
    -verifytiming {}]

  lassign [adi_project_parse_args $args $local_opt] parsed_opt import_files_args
  array set opt $parsed_opt

  # -- Constraint tool groups -------------------------------------------------
  # Each group is an option list of original vendor file-add options; every
  # file is imported once, with its original vendor option.
  set synthesize_group   $opt(-synthesize)
  set placeroute_group   $opt(-placeroute)
  set verifytiming_group $opt(-verifytiming)

  set grouped_import_args {}
  set grouped_import_seen {}
  foreach group [list $opt(-synthesize) $opt(-placeroute) $opt(-verifytiming)] {
    foreach {vendor_option constraint_file} $group {
      set file_key "$vendor_option\t$constraint_file"
      if {[lsearch -exact $grouped_import_seen $file_key] < 0} {
        lappend grouped_import_seen $file_key
        lappend grouped_import_args $vendor_option $constraint_file
      }
    }
  }

  if {[string equal -nocase $opt(-finalize_constraints) "auto"]} {
    set finalize_constraints [expr {
      [llength $synthesize_group] > 0 ||
      [llength $placeroute_group] > 0 ||
      [llength $verifytiming_group] > 0
    }]
  } else {
    set finalize_constraints [expr {$opt(-finalize_constraints) ? 1 : 0}]
  }
  set top_module_file_in $opt(-top_module_file_in)
  set top_module_file_in [file normalize $top_module_file_in]
  set top_module_file_out $opt(-top_module_file_out)
  if {$top_module_file_out eq ""} {
    set top_module_file_out [file join $ad_project_dir hdl [file tail $top_module_file_in]]
  }
  set top_module_file_out [file normalize $top_module_file_out]

  adi_project_generate_parameter_file
  # When top-level parameter overrides are active, import the generated copy
  # instead of the original HDL file so Libero sees the effective values.
  set generated_top_module_file [adi_project_resolve_hdl_source $top_module_file_in $top_module_file_out]
  if {$generated_top_module_file ne $top_module_file_in} {
    set new_import_files_args {}
    foreach arg $import_files_args {
      if {[file tail $arg] eq [file tail $top_module_file_in]} {
        lappend new_import_files_args $generated_top_module_file
        puts "Updating top module parameters: replacing $arg with $generated_top_module_file"
      } else {
        lappend new_import_files_args $arg
      }
    }
    set import_files_args $new_import_files_args
  }

  if {[llength $import_files_args] > 0} {
    import_files {*}$import_files_args
  }
  if {[llength $grouped_import_args] > 0} {
    import_files {*}$grouped_import_args
  }

  if {$opt(-sd_name) ne ""} {
    auto_promote_pad_pins -promote_all 1
    save_smartdesign -sd_name $opt(-sd_name)
    generate_component -component_name $opt(-sd_name)
  }

  # -- Build hierarchy so Libero sees all modules -----------------------------
  build_design_hierarchy

  if {$finalize_constraints} {
    adi_project_finalize_constraints \
      -root $opt(-root) \
      -synthesize $synthesize_group \
      -placeroute $placeroute_group \
      -verifytiming $verifytiming_group
    return
  }

  save_project
}

###############################################################################
## Binds imported/generated constraints to the correct tools and modules.
#
# Internal: adi_project_files calls it. This phase does not import design
# sources again. It assumes the project
# already contains the HDL, the generated SmartDesign and the user-provided
# constraint files, then derives the top-level SDC, selects per-type target
# files, and binds the ordered constraint lists to SYNTHESIZE / PLACEROUTE /
# VERIFYTIMING.
#
# Local options:
# \opt[root]          -root "system_top"
# \opt[synthesize]    -synthesize {-<vendor_option> file ...}
# \opt[placeroute]    -placeroute {-<vendor_option> file ...}
# \opt[verifytiming]  -verifytiming {-<vendor_option> file ...}
#
# Each tool-group value is an option list of original vendor file-add options
# (`-io_pdc`, `-fp_pdc`, `-sdc`). No type-to-tool policy is applied here, since
# the caller states the grouping directly; the derived top-level SDC is added
# to every tool group automatically.
###############################################################################
proc adi_project_finalize_constraints {args} {
  global ad_project_dir

  set local_opt [list \
    -root "system_top" \
    -synthesize {} \
    -placeroute {} \
    -verifytiming {}]

  lassign [adi_project_parse_args $args $local_opt] parsed_opt passthrough_args
  if {[llength $passthrough_args] != 0} {
    error "adi_project_finalize_constraints: unexpected options $passthrough_args"
  }

  array set opt $parsed_opt

  set root $opt(-root)
  if {[string first "::" $root] < 0} {
    set root "${root}::work"
  }

  build_design_hierarchy

  set_root -module $root
  derive_constraints_sdc
  # Libero writes the derived top-level timing file under constraint/ using the
  # root module base name as the prefix.
  set module_base [lindex [split $root "::"] 0]
  if {$module_base eq ""} {
    set module_base system_top
  }
  set derived_sdc_file [file normalize [file join $ad_project_dir constraint ${module_base}_derived_constraints.sdc]]
  set has_derived_sdc [expr {$derived_sdc_file ne "" && [file exists $derived_sdc_file]}]

  # -- Resolve each tool group's files to their imported project-local paths --
  # The tool group is the outer grouping; each inner option pair reuses the
  # original vendor file-add option to identify the constraint type.
  set tool_groups [list \
    SYNTHESIZE   $opt(-synthesize) \
    PLACEROUTE   $opt(-placeroute) \
    VERIFYTIMING $opt(-verifytiming)]

  set tool_constraint_files [dict create]
  set target_type_files [dict create]
  foreach {tool group} $tool_groups {
    set ordered_constraint_files {}
    foreach {vendor_option constraint_file} $group {
      lassign [adi_project_constraint_option_info $vendor_option] constraint_type constraint_subdir
      set local_path [file normalize [file join $ad_project_dir $constraint_subdir [file tail $constraint_file]]]
      lappend ordered_constraint_files $local_path
      dict lappend target_type_files $constraint_type $local_path
    }
    # The derived top-level timing file leads each tool's constraint set.
    if {$has_derived_sdc} {
      set ordered_constraint_files [linsert $ordered_constraint_files 0 $derived_sdc_file]
    }
    dict set tool_constraint_files $tool $ordered_constraint_files
  }

  # -- Vendor target selection (set_as_target -type ...) ----------------------
  # The active target for each type is its last file in appearance order.
  dict for {constraint_type constraint_files} $target_type_files {
    if {[llength $constraint_files] > 0} {
      set_as_target -type $constraint_type -file [lindex $constraint_files end]
    }
  }

  # -- Vendor tool binding (organize_tool_files -tool ...) --------------------
  dict for {tool ordered_constraint_files} $tool_constraint_files {
    adi_project_organize_constraints $tool $root $ordered_constraint_files
  }

  save_project
}

###############################################################################
## Sets up the presynth simulation of the project and writes its QuestaSim
## script, then saves and closes the project.
#
# Imports the testbench, makes it the stimulus of the root module, copies the
# files the simulation reads at run time into the simulation directory and runs
# the simulation once: Libero writes run.do only when it runs the simulation.
# The run is short (-sim_runtime), only for run.do; project-microchip.mk runs
# the testbench with run.do and its own run time (sim, sim-cli, SIM_RUN_CMD).
#
# \param[project_name] - project name
# \opt[tb]             -tb "verification/system_tb.v"; the testbench module has
#                      the name of the file
# \opt[root]           -root "system_top"; the module under test
# \opt[run_files]      -run_files {verification/*.bfm verification/*.mem}: the
#                      files or glob patterns of the files the simulation reads
#                      at run time, named as it expects them (the defaults of
#                      project-microchip.mk); they are copied into the
#                      simulation directory, where run.do runs
# \opt[sim_runtime]    -sim_runtime "1ns": the run time of the simulation of
#                      Libero, which only writes run.do
# \opt[vsim_options]   -vsim_options "": further vsim options
###############################################################################
proc adi_project_sim {project_name args} {
  global ad_project_dir

  set local_opt [list \
    -tb "verification/system_tb.v" \
    -root "system_top" \
    -run_files {verification/*.bfm verification/*.mem} \
    -sim_runtime "1ns" \
    -vsim_options ""]

  lassign [adi_project_parse_args $args $local_opt] parsed_opt passthrough_args
  if {[llength $passthrough_args] != 0} {
    error "adi_project_sim: unexpected options $passthrough_args"
  }

  array set opt $parsed_opt

  set tb_name [file rootname [file tail $opt(-tb)]]
  set tb_file [file join $ad_project_dir hdl [file tail $opt(-tb)]]
  set root_module [lindex [split $opt(-root) ":"] 0]

  import_files -library {work} -hdl_source [file normalize $opt(-tb)]
  build_design_hierarchy
  associate_stimulus -file $tb_file -mode new -module $root_module
  set_root -module ${root_module}::work
  organize_tool_files -tool {SIM_PRESYNTH} \
    -file $tb_file -module $root_module -input_type {stimulus}

  set modelsim_args [list \
    -use_automatic_do_file 1 \
    -tb_module_name $tb_name \
    -sim_runtime $opt(-sim_runtime)]
  if {$opt(-vsim_options) ne ""} {
    lappend modelsim_args -add_vsim_options $opt(-vsim_options)
  }
  set_modelsim_options {*}$modelsim_args

  # A pattern may match nothing; a file name without a pattern must exist
  set simulation_dir [file join $ad_project_dir simulation]
  foreach pattern $opt(-run_files) {
    set run_files [glob -nocomplain -- $pattern]
    if {[llength $run_files] == 0 && ![regexp {[*?\[]} $pattern]} {
      error "adi_project_sim: no such run file: $pattern"
    }
    foreach run_file $run_files {
      file copy -force $run_file $simulation_dir
    }
  }

  run_tool -name {SIM_PRESYNTH}

  save_project
  close_project
}

###############################################################################
## Returns 1 if the last Verify Timing of the module met the max (setup) and min
## (hold) timing in all corners, 0 otherwise.
#
# \param[root_module] - root module name, e.g. system_top
###############################################################################
proc adi_project_timing_met {root_module} {
  global ad_project_dir

  set result_file [file join $ad_project_dir designer $root_module ${root_module}_has_violations]
  if {![file exists $result_file]} {
    puts "ERROR: No Verify Timing result: $result_file"
    return 0
  }

  set fid [open $result_file r]
  set results [read $fid]
  close $fid

  set met 1
  foreach check {max_timing_violations_multi_corner max_timing_multi_corner \
                 min_timing_violations_multi_corner min_timing_multi_corner} {
    if {![regexp -line "^_${check} (\\S+)$" $results -> state]} {
      set state "missing"
    }
    if {$state ne "met"} {
      puts "ERROR: Timing check $check: $state"
      set met 0
    }
  }
  return $met
}

###############################################################################
## Runs synthesis, place-and-route, timing, and optional programming export.
#
# The timing is verified on the implementation the bitstream is generated from.
# If it is not met, the FlashPro job is exported as <job>_bad_timing (as the
# Xilinx flow does with the bitstream) and the script fails.
#
# Local options are handled here; any remaining options are passed through to
# `export_prog_job`.
#
# \param[project_name]                   - project name
# \opt[root]                             -root "system_top"
# \opt[job_file_name]                    -job_file_name ""
# \opt[export_dir]                       -export_dir "./_bld"
# \opt[bitstream_file_type]              -bitstream_file_type "TRUSTED_FACILITY"
# \opt[bitstream_file_components]        -bitstream_file_components {FABRIC}
# \opt[zeroization_likenew_action]       -zeroization_likenew_action 0
# \opt[zeroization_unrecoverable_action] -zeroization_unrecoverable_action 0
# \opt[program_design]                   -program_design 1
# \opt[program_spi_flash]                -program_spi_flash 0
# \opt[include_plaintext_passkey]        -include_plaintext_passkey 0
# \opt[design_bitstream_format]          -design_bitstream_format {PPD}
#
# The public `-root` option accepts a short module name such as `system_top`.
# The default `::work` library suffix is added automatically before `set_root`.
###############################################################################
proc adi_project_run {project_name args} {
  set local_opt [list \
    -root "system_top" \
    -job_file_name "" \
    -export_dir "" \
    -bitstream_file_type "TRUSTED_FACILITY" \
    -bitstream_file_components {FABRIC} \
    -zeroization_likenew_action 0 \
    -zeroization_unrecoverable_action 0 \
    -program_design 1 \
    -program_spi_flash 0 \
    -include_plaintext_passkey 0 \
    -design_bitstream_format {PPD}]

  lassign [adi_project_parse_args $args $local_opt] parsed_opt export_prog_job_optional_args
  array set opt $parsed_opt

  set root $opt(-root)
  set job_file_name $opt(-job_file_name)
  set export_dir $opt(-export_dir)
  set bitstream_file_type $opt(-bitstream_file_type)
  set bitstream_file_components $opt(-bitstream_file_components)
  set zeroization_likenew_action $opt(-zeroization_likenew_action)
  set zeroization_unrecoverable_action $opt(-zeroization_unrecoverable_action)
  set program_design $opt(-program_design)
  set program_spi_flash $opt(-program_spi_flash)
  set include_plaintext_passkey $opt(-include_plaintext_passkey)
  set design_bitstream_format $opt(-design_bitstream_format)

  if {[string first "::" $root] < 0} {
    set root "${root}::work"
  }

  set root_module [lindex [split $root ":"] 0]

  set_root -module $root
  run_tool -name {SYNTHESIZE}
  run_tool -name {PLACEROUTE}
  if {$program_design || $program_spi_flash} {
    run_tool -name {GENERATEPROGRAMMINGDATA}
    # In a new project this reruns synthesis and place and route: verify the
    # timing of the implementation the bitstream is generated from
    generate_design_initialization_data
    run_tool -name {VERIFYTIMING}
    set timing_met [adi_project_timing_met $root_module]
    if {!$timing_met} {
      if {$job_file_name eq ""} {
        set job_file_name $root_module
      }
      set job_file_name "${job_file_name}_bad_timing"
    }

    set export_prog_job_args [list \
      -job_file_name $job_file_name \
      -bitstream_file_type $bitstream_file_type \
      -bitstream_file_components $bitstream_file_components \
      -zeroization_likenew_action $zeroization_likenew_action \
      -zeroization_unrecoverable_action $zeroization_unrecoverable_action \
      -program_design $program_design \
      -program_spi_flash $program_spi_flash \
      -include_plaintext_passkey $include_plaintext_passkey \
      -design_bitstream_format $design_bitstream_format]
    if {$export_dir ne ""} {
      set export_dir [file normalize $export_dir]
      if {![file exists $export_dir]} {
        file mkdir $export_dir
      }
      lappend export_prog_job_args -export_dir $export_dir
    }
    run_tool -name {GENERATEPROGRAMMINGFILE}
    export_prog_job \
      {*}$export_prog_job_args \
      {*}$export_prog_job_optional_args
  } else {
    run_tool -name {VERIFYTIMING}
    set timing_met [adi_project_timing_met $root_module]
    puts "INFO: Skipping programming data and job export because program_design and program_spi_flash both disabled."
  }

  save_project
  close_project

  if {!$timing_met} {
    error "ERROR: Timing constraints NOT met!"
  }
}

###############################################################################
## Returns the number of bytes of an Intel-Hex file from a base address to its
## last data byte.
#
# \param[hex_file] - Intel-Hex file
# \param[base]     - base address, e.g. 0x20220000
###############################################################################
proc adi_project_hex_size {hex_file base} {
  set fid [open $hex_file r]
  set upper 0
  set first ""
  set last ""
  while {[gets $fid line] >= 0} {
    if {![regexp {^:([0-9A-Fa-f]{2})([0-9A-Fa-f]{4})([0-9A-Fa-f]{2})([0-9A-Fa-f]*)} \
          $line -> count address type data]} {
      continue
    }
    scan $count %x count
    scan $address %x address
    switch -- $type {
      00 {
        set start [expr {$upper + $address}]
        set end [expr {$start + $count}]
        if {$first eq "" || $start < $first} {
          set first $start
        }
        if {$last eq "" || $end > $last} {
          set last $end
        }
      }
      02 {
        scan [string range $data 0 3] %x segment
        set upper [expr {$segment << 4}]
      }
      04 {
        scan [string range $data 0 3] %x linear
        set upper [expr {$linear << 16}]
      }
    }
  }
  close $fid

  if {$first eq "" || $first < $base} {
    error "ERROR: $hex_file has no data from [format 0x%08X $base]"
  }
  return [expr {$last - $base}]
}

###############################################################################
## Exports a FlashPro job with the fabric and the HSS in the eNVM.
#
# Opens a built project (`adi_project_run`), sets the HSS eNVM image (the
# Intel-Hex of the HSS build, e.g. hss-envm-wrapper.mpfs-video-kit.hex) as the
# boot mode 1 eNVM client and exports the job with the fabric and the eNVM.
# The timing of the implementation is checked as in `adi_project_run`: if it is
# not met, the job is exported as <job>_bad_timing and the script fails.
#
# Local options are handled here; any remaining options are passed through to
# `export_prog_job`.
#
# \param[project_file]               - Libero project file (.prjx)
# \param[envm_hex]                   - HSS eNVM image (Intel-Hex)
# \param[export_dir]                 - directory of the exported job
# \opt[root]                         -root "system_top"
# \opt[job_file_name]                -job_file_name "<root>_hss"
# \opt[bitstream_file_components]    -bitstream_file_components {FABRIC ENVM}
###############################################################################
proc adi_project_envm_job {project_file envm_hex export_dir args} {
  global ad_project_dir

  set local_opt [list \
    -root "system_top" \
    -job_file_name "" \
    -bitstream_file_components {FABRIC ENVM}]

  lassign [adi_project_parse_args $args $local_opt] parsed_opt export_prog_job_optional_args
  array set opt $parsed_opt

  set root_module [lindex [split $opt(-root) ":"] 0]
  set job_file_name $opt(-job_file_name)
  if {$job_file_name eq ""} {
    set job_file_name "${root_module}_hss"
  }

  set project_file [file normalize $project_file]
  set envm_hex [file normalize $envm_hex]
  set export_dir [file normalize $export_dir]
  set ad_project_dir [file dirname $project_file]
  if {![file exists $export_dir]} {
    file mkdir $export_dir
  }

  # The eNVM client of the HSS: boot mode 1, from the eNVM base
  set envm_base 0x20220000
  set envm_size [adi_project_hex_size $envm_hex $envm_base]
  set envm_cfg [file join $ad_project_dir envm.cfg]
  set fid [open $envm_cfg w]
  puts $fid "set_plain_text_client \\"
  puts $fid "  -client_name {BOOT_MODE_1_ENVM_CLIENT} \\"
  puts $fid "  -number_of_bytes $envm_size \\"
  puts $fid "  -content_type {MEMORY_FILE} \\"
  puts $fid "  -content_file_format {Intel-Hex} \\"
  puts $fid "  -content_file {$envm_hex} \\"
  puts $fid "  -mem_file_base_address {$envm_base} \\"
  puts $fid "  -start_page 0 \\"
  puts $fid "  -use_for_simulation 0 \\"
  puts $fid "  -reprogram 1 \\"
  puts $fid "  -use_as_rom 0 \\"
  puts $fid "  -fabric_access_read 1 \\"
  puts $fid "  -fabric_access_write 0 \\"
  puts $fid "  -mss_access_read 1 \\"
  puts $fid "  -mss_access_write 0"
  close $fid

  open_project $project_file

  run_tool -name {GENERATEPROGRAMMINGDATA}
  configure_envm -cfg_file $envm_cfg

  set timing_met [adi_project_timing_met $root_module]
  if {!$timing_met} {
    set job_file_name "${job_file_name}_bad_timing"
  }

  run_tool -name {GENERATEPROGRAMMINGFILE}
  export_prog_job \
    -job_file_name $job_file_name \
    -export_dir $export_dir \
    -bitstream_file_type {TRUSTED_FACILITY} \
    -bitstream_file_components $opt(-bitstream_file_components) \
    -zeroization_likenew_action 0 \
    -zeroization_unrecoverable_action 0 \
    -program_design 1 \
    -program_spi_flash 0 \
    -include_plaintext_passkey 0 \
    -design_bitstream_format {PPD} \
    {*}$export_prog_job_optional_args

  save_project
  close_project

  if {!$timing_met} {
    error "ERROR: Timing constraints NOT met!"
  }
}
