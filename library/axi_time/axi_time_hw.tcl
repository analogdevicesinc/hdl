###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require qsys 14.0
source ../../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

set_module_property NAME axi_time
set_module_property DESCRIPTION "AXI Timestamp Interface"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME axi_time

ad_ip_files axi_time [list\
  $ad_hdl_dir/library/common/up_axi.v \
  $ad_hdl_dir/library/util_cdc/sync_bits.v \
  $ad_hdl_dir/library/util_cdc/sync_event.v \
  $ad_hdl_dir/library/util_axis_fifo/util_axis_fifo.v \
  $ad_hdl_dir/library/util_axis_fifo/util_axis_fifo_address_generator.v \
  axi_time_pkg.sv \
  axi_time_counter.sv \
  axi_time_regmap.sv \
  axi_time_rx.sv \
  axi_time.sv \
  axi_time_constr.sdc]

# parameters

set group "General Configuration"

# interfaces

