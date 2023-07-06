###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_fan_control
adi_ip_files axi_fan_control [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/util_pulse_gen.v" \
  "axi_fan_control.v"]

adi_ip_properties axi_fan_control

set_property company_url {https://wiki.analog.com/resources/fpga/docs/axi_fan_control} [ipx::current_core]

set cc [ipx::current_core]

ipx::save_core $cc
