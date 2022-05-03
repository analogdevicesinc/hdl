set single_dual_n 1

# This code assumes the following was ran previously:

#  Dual Quad Flash mode

# write_cfgmem  -format mcs -size 256 -interface SPIx8 \
  -loadbit {up 0x00000000 "./empty_project_vcu118.runs/impl_1/system_top.bit" } \
  -loaddata {up 0x0C000000 " /home/lnagy/workspace/vitis/uboot_placeholder_system/_ide/flash/uboot_placeholder.elf.srec" } \
  -file "empty_project_bl.mcs" -force

#  Single Quad Flash mode

# write_cfgmem  -format mcs -size 256 -interface SPIx4 \
  -loadbit {up 0x00000000 "./empty_project_vcu118.runs/impl_1/system_top.bit" } \
  -loaddata {up 0x06000000 "/home/lnagy/workspace/vitis/uboot_placeholder_system/_ide/flash/uboot_placeholder.elf.srec" } \
  -file "empty_project_bl.mcs" -force

set TOP empty_project_bl

if {$single_dual_n == 0} {
  set part mt25qu01g-spi-x1_x2_x4_x8
  set files [list "${TOP}_primary.mcs" "${TOP}_secondary.mcs"]
  set prm_files [list "${TOP}_primary.prm" "${TOP}_secondary.prm"]
} else {
  set part mt25qu01g-spi-x1_x2_x4
  set files [list "${TOP}.mcs"]
  set prm_files {}
}

open_hw
connect_hw_server -allow_non_jtag
open_hw_target
current_hw_device [get_hw_devices xcvu9p_0]
refresh_hw_device [lindex [get_hw_devices xcvu9p_0] 0]
create_hw_cfgmem -hw_device [lindex [get_hw_devices xcvu9p_0] 0] [lindex [get_cfgmem_parts $part] 0]
set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcvu9p_0] 0]]
set_property PROGRAM.ERASE  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcvu9p_0] 0]]
set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcvu9p_0] 0]]
set_property PROGRAM.VERIFY  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcvu9p_0] 0]]
set_property PROGRAM.CHECKSUM  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcvu9p_0] 0]]
refresh_hw_device [lindex [get_hw_devices xcvu9p_0] 0]
set_property PROGRAM.ADDRESS_RANGE  {use_file} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcvu9p_0] 0]]
set_property PROGRAM.FILES $files [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcvu9p_0] 0]]
set_property PROGRAM.PRM_FILES $prm_files [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcvu9p_0] 0]]
set_property PROGRAM.UNUSED_PIN_TERMINATION {pull-none} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcvu9p_0] 0]]
set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcvu9p_0] 0]]
set_property PROGRAM.ERASE  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcvu9p_0] 0]]
set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcvu9p_0] 0]]
set_property PROGRAM.VERIFY  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcvu9p_0] 0]]
set_property PROGRAM.CHECKSUM  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcvu9p_0] 0]]
create_hw_bitstream -hw_device [lindex [get_hw_devices xcvu9p_0] 0] [get_property PROGRAM.HW_CFGMEM_BITFILE [ lindex [get_hw_devices xcvu9p_0] 0]]; program_hw_devices [lindex [get_hw_devices xcvu9p_0] 0]; refresh_hw_device [lindex [get_hw_devices xcvu9p_0] 0];
program_hw_cfgmem -hw_cfgmem [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcvu9p_0] 0]]
boot_hw_device  [lindex [get_hw_devices xcvu9p_0] 0]

