###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/de10nano/de10nano_system_qsys.tcl

set_instance_parameter_value sys_gpio_in {captureEdge} {true}
set_instance_parameter_value sys_gpio_in {edgeType} {FALLING}
set_instance_parameter_value sys_gpio_in {generateIRQ} {true}
set_instance_parameter_value sys_gpio_in {irqType} {EDGE}

set_instance_parameter_value sys_spi {targetClockRate} {5000000.0}
set_instance_parameter_value sys_spi {clockPhase} {1}
set_instance_parameter_value sys_spi {clockPolarity} {1}

#system ID
set_instance_parameter_value axi_sysid_0 {ROM_ADDR_BITS} {9}
set_instance_parameter_value rom_sys_0 {ROM_ADDR_BITS} {9}

set_instance_parameter_value rom_sys_0 {PATH_TO_FILE} "[pwd]/mem_init_sys.txt"

sysid_gen_sys_init_file;
