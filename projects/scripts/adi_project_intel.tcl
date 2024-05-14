###############################################################################
## Copyright (C) 2017-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## Initialize global variable
set family "none"
set device "none"

## Create a project.
#
# \param[project_name] - name of the project, must contain a valid carrier name
# \param[parameter_list] - a list of global parameters (parameters of the
# system_top module)
#
# Supported carrier names are: a10gx, a10soc, c5soc, de10nano, a5soc, a5gt.
#
proc adi_project {project_name {parameter_list {}}} {

  global ad_hdl_dir
  global ad_ghdl_dir
  global family
  global device
  global REQUIRED_QUARTUS_VERSION
  global quartus
  global IGNORE_VERSION_CHECK
  global QUARTUS_PRO_ISUSED

  if {![info exists ::env(ADI_PROJECT_DIR)]} {
    set actual_project_name $project_name
    set ad_project_dir "."
  } else {
    set actual_project_name "$::env(ADI_PROJECT_DIR)${project_name}"
    set ad_project_dir [file normalize $::env(ADI_PROJECT_DIR)]
  }

  # check $ALT_NIOS_MMU_ENABLED environment variables

  set mmu_enabled 1
  if [info exists ::env(ALT_NIOS_MMU_ENABLED)] {
    set mmu_enabled $::env(ALT_NIOS_MMU_ENABLED)
  }

  # check $QUARTUS_PRO_ISUSED environment variables
  set quartus_pro_isused 1
  if {[info exists ::env(QUARTUS_PRO_ISUSED)]} {
    set quartus_pro_isused $::env(QUARTUS_PRO_ISUSED)
  } elseif {[info exists QUARTUS_PRO_ISUSED]} {
    set quartus_pro_isused $QUARTUS_PRO_ISUSED
  }

  if [regexp "_a10gx" $project_name] {
    set family "Arria 10"
    set device 10AX115S2F45I1SG
  }

  if [regexp "_a10soc" $project_name] {
    set family "Arria 10"
    set device 10AS066N3F40E2SG
  }

  if [regexp "_s10soc" $project_name] {
    set family "Stratix 10"
    set device 1SX280HU2F50E1VGAS
  }

  if [regexp "_c5soc" $project_name] {
    set family "Cyclone V"
    set device 5CSXFC6D6F31C8ES
    set system_qip_file ${ad_project_dir}/system_bd/synthesis/system_bd.qip
  }

  if [regexp "_de10nano" $project_name] {
    set family "Cyclone V"
    set device 5CSEBA6U23I7DK
    set system_qip_file ${ad_project_dir}/system_bd/synthesis/system_bd.qip
  }

  if [regexp "_a5soc" $project_name] {
    set family "Arria V"
    set device 5ASTFD5K3F40I3ES
    set system_qip_file ${ad_project_dir}/system_bd/synthesis/system_bd.qip
  }

  if [regexp "_a5gt" $project_name] {
    set family "Arria V"
    set device 5AGTFD7K3F40I3
    set system_qip_file ${ad_project_dir}/system_bd/synthesis/system_bd.qip
  }

  if [regexp "fm87" $project_name] {
    set family "Agilex 7"
    set device AGIB027R31B1E1V
    set system_qip_file ${ad_project_dir}/system_bd/synthesis/system_bd.qip
  }

  # version check

  set m_version [lindex $quartus(version) 1]
  if {$IGNORE_VERSION_CHECK} {
    if {[string compare $m_version $REQUIRED_QUARTUS_VERSION] != 0} {
      puts -nonewline "CRITICAL WARNING: Quartus version mismatch; "
      puts -nonewline "expected $REQUIRED_QUARTUS_VERSION, "
      puts -nonewline "got $m_version.\n"
    }
  } else {
    if {[string compare $m_version $REQUIRED_QUARTUS_VERSION] != 0} {
      puts -nonewline "ERROR: Quartus version mismatch; "
      puts -nonewline "expected $REQUIRED_QUARTUS_VERSION, "
      puts -nonewline "got $m_version.\n"
      puts -nonewline "This ERROR message can be down-graded to CRITICAL WARNING by setting ADI_IGNORE_VERSION_CHECK environment variable to 1. Be aware that ADI will not support you, if you are using a different tool version.\n"
      exit 2
    }
  }

  # packages used

  load_package flow

  # project

  project_new $actual_project_name -overwrite

  # library paths
  if {[info exists ::env(ADI_GHDL_DIR)]} {
    set ad_lib_folders "$ad_hdl_dir/library/**/*;$ad_ghdl_dir/library/**/*"
  } else {
    set ad_lib_folders "$ad_hdl_dir/library/**/*"
  }

  set_user_option -name USER_IP_SEARCH_PATHS $ad_lib_folders
  set_global_assignment -name IP_SEARCH_PATHS $ad_lib_folders

  # project & qsys

  set_global_assignment -name FAMILY $family
  set_global_assignment -name DEVICE $device

  # qsys

  set mmu_enabled 1
  if [info exists ::env(NIOS_MMU_ENABLED)] {
    set mmu_enabled $::env(NIOS_MMU_ENABLED)
  }

  set QFILE [open "system_qsys_script.tcl" "w"]
  puts $QFILE "set project_name $project_name"
  puts $QFILE "set mmu_enabled $mmu_enabled"
  puts $QFILE "set ad_hdl_dir $ad_hdl_dir"
  if {[info exists ::env(ADI_GHDL_DIR)]} {
    puts $QFILE "set ad_ghdl_dir $ad_ghdl_dir"
  }
  if {[info exists ::env(ADI_PROJECT_DIR)]} {
    puts $QFILE "set ad_project_dir $ad_project_dir"
  }
  puts $QFILE "package require qsys"
  puts $QFILE "set_module_property NAME {system_bd}"
  puts $QFILE "set_project_property DEVICE_FAMILY {$family}"
  puts $QFILE "set_project_property DEVICE $device"
  puts $QFILE "foreach {param value} {$parameter_list} { set ad_project_params(\$param) \$value }"
  if {[info exists ::env(ADI_PROJECT_DIR)]} {
    puts $QFILE "source ../system_qsys.tcl"
  } else {
    puts $QFILE "source system_qsys.tcl"
  }
  if {$quartus_pro_isused == 1} {
    puts $QFILE "set_domain_assignment {\$system} {qsys_mm.maxAdditionalLatency} {4}"
    puts $QFILE "set_domain_assignment {\$system} {qsys_mm.clockCrossingAdapter} {AUTO}"
    puts $QFILE "set_domain_assignment {\$system} {qsys_mm.burstAdapterImplementation} {PER_BURST_TYPE_CONVERTER}"
  } else {
    puts $QFILE "set_interconnect_requirement {\$system} {qsys_mm.maxAdditionalLatency} {4}"
    puts $QFILE "set_interconnect_requirement {\$system} {qsys_mm.clockCrossingAdapter} {AUTO}"
    puts $QFILE "set_interconnect_requirement {\$system} {qsys_mm.burstAdapterImplementation} {PER_BURST_TYPE_CONVERTER}"
  }
  puts $QFILE "save_system {system_bd.qsys}"
  close $QFILE

  # check which type of Quartus is used, to call the qsys utilities with the
  # correct attributes
  if {$quartus_pro_isused == 1} {

    exec -ignorestderr $quartus(quartus_rootpath)/sopc_builder/bin/qsys-script \
      --quartus_project=$project_name --script=system_qsys_script.tcl

    exec -ignorestderr $quartus(quartus_rootpath)/sopc_builder/bin/qsys-generate \
      system_bd.qsys --synthesis=VERILOG --family=$family --part=$device \
      --quartus-project=$project_name

  } else {

    exec -ignorestderr $quartus(quartus_rootpath)/sopc_builder/bin/qsys-script \
      --script=system_qsys_script.tcl

    exec -ignorestderr $quartus(quartus_rootpath)/sopc_builder/bin/qsys-generate \
      system_bd.qsys --synthesis=VERILOG --family=$family --part=$device \

    # I/O Timing Analysis is available just in Quartus Standard
    set_global_assignment -name ENABLE_ADVANCED_IO_TIMING ON

  }

  # source MESSAGE-DISABLE definitions - to ignore invalid critical warnings

  source $ad_hdl_dir/projects/scripts/adi_intel_msg.tcl

  # default assignments

  if {$quartus_pro_isused != 1} {
    set_global_assignment -name QIP_FILE $system_qip_file
  }
  if {[info exists ::env(ADI_PROJECT_DIR)]} {
    set_global_assignment -name VERILOG_FILE ../system_top.v
    set_global_assignment -name SDC_FILE ../system_constr.sdc
  } else {
    set_global_assignment -name VERILOG_FILE system_top.v
    set_global_assignment -name SDC_FILE system_constr.sdc
  }
  set_global_assignment -name TOP_LEVEL_ENTITY system_top
  set_global_assignment -name ENABLE_HPS_INTERNAL_TIMING ON

  # remove altshift_taps

  set_instance_assignment -name AUTO_SHIFT_REGISTER_RECOGNITION OFF -to * -entity up_xfer_cntrl
  set_instance_assignment -name AUTO_SHIFT_REGISTER_RECOGNITION OFF -to * -entity up_xfer_status
  set_instance_assignment -name AUTO_SHIFT_REGISTER_RECOGNITION OFF -to * -entity up_clock_mon
  set_instance_assignment -name AUTO_SHIFT_REGISTER_RECOGNITION OFF -to * -entity ad_rst
  set_instance_assignment -name QII_AUTO_PACKED_REGISTERS OFF -to * -entity up_xfer_cntrl
  set_instance_assignment -name QII_AUTO_PACKED_REGISTERS OFF -to * -entity up_xfer_status
  set_instance_assignment -name QII_AUTO_PACKED_REGISTERS OFF -to * -entity up_clock_mon
  set_instance_assignment -name QII_AUTO_PACKED_REGISTERS OFF -to * -entity ad_rst

  # globals

  set_global_assignment -name SYNCHRONIZER_IDENTIFICATION AUTO
  set_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER ON
  set_global_assignment -name TIMEQUEST_DO_REPORT_TIMING ON
  set_global_assignment -name TIMEQUEST_DO_CCPP_REMOVAL ON
  set_global_assignment -name TIMEQUEST_REPORT_SCRIPT $ad_hdl_dir/projects/scripts/adi_tquest.tcl
  set_global_assignment -name ON_CHIP_BITSTREAM_DECOMPRESSION OFF

  # set top level file parameters
  foreach {param value} $parameter_list {
    set_parameter -name $param $value
  }
}
