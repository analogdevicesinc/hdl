
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl


adi_project empty_project_vcu118 0

adi_project_files empty_project_vcu118 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "timing_constr.xdc"\
  "../../../library/common/ad_3w_spi.v"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/vcu118/vcu118_system_constr.xdc" ]

# Avoid critical warning in OOC mode from the clock definitions
# since at that stage the submodules are not stiched together yet
if {$ADI_USE_OOC_SYNTHESIS == 1} {
  set_property used_in_synthesis false [get_files timing_constr.xdc]
}

# single 128MB flash range 0x0 - 0x0800_0000
#
# max 8MB SREC bootloader with address set to 0x0780_0000
add_files -norecurse ./mb_bootloader.elf
set_property SCOPED_TO_REF system [get_files -all -of_objects [get_fileset sources_1] {./mb_bootloader.elf}]
set_property SCOPED_TO_CELLS { sys_mb } [get_files -all -of_objects [get_fileset sources_1] {./mb_bootloader.elf}]

adi_project_run empty_project_vcu118

