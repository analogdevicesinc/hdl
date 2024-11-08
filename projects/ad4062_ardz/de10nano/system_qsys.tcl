###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/de10nano/de10nano_system_qsys.tcl

# disable I2C1

set_instance_parameter_value sys_hps {I2C1_Mode} {N/A}
set_instance_parameter_value sys_hps {I2C1_PinMuxing} {Unused}

# set clk to 100MHz

set_instance_parameter_value sys_hps {S2FCLK_USER0CLK_FREQ} {100.0}

if [info exists ad_project_dir] {
  source ../../common/ad4062_qsys.tcl
} else {
  source ../common/ad4062_qsys.tcl
}

# system ID

set_instance_parameter_value axi_sysid_0 {ROM_ADDR_BITS} {9}
set_instance_parameter_value rom_sys_0 {ROM_ADDR_BITS} {9}

set_instance_parameter_value rom_sys_0 {PATH_TO_FILE} "[pwd]/mem_init_sys.txt"

sysid_gen_sys_init_file;
