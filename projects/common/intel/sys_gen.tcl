
# globals

set_global_assignment -name OPTIMIZATION_MODE "AGGRESSIVE PERFORMANCE"
set_global_assignment -name SYNCHRONIZER_IDENTIFICATION AUTO
set_global_assignment -name ENABLE_ADVANCED_IO_TIMING ON
set_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER ON
set_global_assignment -name TIMEQUEST_DO_REPORT_TIMING ON
set_global_assignment -name TIMEQUEST_DO_CCPP_REMOVAL ON
set_global_assignment -name TIMEQUEST_REPORT_SCRIPT $ad_hdl_dir/projects/scripts/adi_tquest.tcl
set_global_assignment -name ON_CHIP_BITSTREAM_DECOMPRESSION OFF

# version check

set REQUIRED_QUARTUS_VERSION "16.1.2"
set QUARTUS_VERSION [lindex $quartus(version) 1]
if {[string compare $QUARTUS_VERSION $REQUIRED_QUARTUS_VERSION] != 0} {
  puts -nonewline "Critical Warning: quartus version mismatch; "
  puts -nonewline "expected $REQUIRED_QUARTUS_VERSION, "
  puts -nonewline "got $QUARTUS_VERSION.\n"
}

# library paths

set ad_lib_folders "$ad_hdl_dir/library/**/*;$ad_ghdl_dir/library/**/*"

set_user_option -name USER_IP_SEARCH_PATHS $ad_lib_folders
set_global_assignment -name IP_SEARCH_PATHS $ad_lib_folders

# qsys-script is a crippled tool, so work around is generate a run-time one

set mmu_enabled 1
if [info exists ::env(NIOS_MMU_ENABLED)] {
  set mmu_enabled $::env(NIOS_MMU_ENABLED)
}

set QFILE [open "system_qsys_script.tcl" "w"]
puts $QFILE "set mmu_enabled $mmu_enabled"
puts $QFILE "set ad_hdl_dir $ad_hdl_dir"
puts $QFILE "set ad_ghdl_dir $ad_ghdl_dir"
puts $QFILE "source system_qsys.tcl"
puts $QFILE "set_interconnect_requirement {\$system} {qsys_mm.clockCrossingAdapter} {FIFO}"
puts $QFILE "set_interconnect_requirement {\$system} {qsys_mm.maxAdditionalLatency} {2}"
puts $QFILE "save_system {system_bd.qsys}"
close $QFILE

exec -ignorestderr $quartus(quartus_rootpath)/sopc_builder/bin/qsys-script \
  --script=system_qsys_script.tcl

# remove altshift_taps

set_instance_assignment -name AUTO_SHIFT_REGISTER_RECOGNITION OFF -to * -entity up_xfer_cntrl
set_instance_assignment -name AUTO_SHIFT_REGISTER_RECOGNITION OFF -to * -entity up_xfer_status
set_instance_assignment -name AUTO_SHIFT_REGISTER_RECOGNITION OFF -to * -entity up_clock_mon
set_instance_assignment -name AUTO_SHIFT_REGISTER_RECOGNITION OFF -to * -entity ad_rst
set_instance_assignment -name QII_AUTO_PACKED_REGISTERS OFF -to * -entity up_xfer_cntrl
set_instance_assignment -name QII_AUTO_PACKED_REGISTERS OFF -to * -entity up_xfer_status
set_instance_assignment -name QII_AUTO_PACKED_REGISTERS OFF -to * -entity up_clock_mon
set_instance_assignment -name QII_AUTO_PACKED_REGISTERS OFF -to * -entity ad_rst

