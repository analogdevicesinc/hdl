###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_gpio_adi
adi_ip_files axi_gpio_adi [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "axi_gpio_adi.v"]

adi_ip_properties axi_gpio_adi

# Adaugare Device ID
set cc [ipx::current_core]
ipx::add_user_parameter DEVICE_ID $cc
set_property value 0 [ipx::get_user_parameter DEVICE_ID $cc]
set_property display_name {Device ID} [ipx::get_user_parameter DEVICE_ID $cc]
set_property description {Unique ID for driver instantiation (Vivado export)} [ipx::get_user_parameter DEVICE_ID $cc]

#set_property company_url {https://wiki.analog.com/resources/fpga/docs/axi_fan_control} [ipx::current_core]

adi_add_bus "gpio" "master" \
	"xilinx.com:interface:gpio_rtl:1.0" \
	"xilinx.com:interface:gpio:1.0" \
	[list \
    {"gpio_io_o" "TRI_O"} \
    {"gpio_io_t" "TRI_T"} \
    {"gpio_io_i" "TRI_I"} \
]


set cc [ipx::current_core]
ipx::save_core $cc
