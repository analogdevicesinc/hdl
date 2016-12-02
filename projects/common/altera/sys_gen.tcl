
# globals

set_global_assignment -name SYNCHRONIZER_IDENTIFICATION AUTO
set_global_assignment -name ENABLE_ADVANCED_IO_TIMING ON
set_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER ON
set_global_assignment -name TIMEQUEST_DO_REPORT_TIMING ON
set_global_assignment -name TIMEQUEST_DO_CCPP_REMOVAL ON
set_global_assignment -name TIMEQUEST_REPORT_SCRIPT $ad_hdl_dir/projects/scripts/adi_tquest.tcl
set_global_assignment -name ON_CHIP_BITSTREAM_DECOMPRESSION OFF

# library paths

set ad_lib_folders "$ad_hdl_dir/library/**/*;$ad_phdl_dir/library/**/*"

set_user_option -name USER_IP_SEARCH_PATHS $ad_lib_folders
set_global_assignment -name IP_SEARCH_PATHS $ad_lib_folders

# qsys-script is a crippled tool, so work around is generate a run-time one

set mmu_enabled 1
if [info exists ::env(ALT_NIOS_MMU_ENABLED)] {
  set mmu_enabled $::env(ALT_NIOS_MMU_ENABLED)
}

set QFILE [open "system_qsys_script.tcl" "w"]
puts $QFILE "set mmu_enabled $mmu_enabled"
puts $QFILE "set ad_hdl_dir $ad_hdl_dir"
puts $QFILE "set ad_phdl_dir $ad_phdl_dir"
puts $QFILE "source system_qsys.tcl"
close $QFILE

exec -ignorestderr $quartus(quartus_rootpath)/sopc_builder/bin/qsys-script \
  --script=system_qsys_script.tcl

