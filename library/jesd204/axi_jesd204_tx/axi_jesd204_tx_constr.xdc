###############################################################################
## Copyright (C) 2017, 2018, 2021 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

set axi_clk [get_clocks -of_objects [get_ports s_axi_aclk]]
set core_clk [get_clocks -of_objects [get_ports core_clk]]
set device_clk [get_clocks -of_objects [get_ports device_clk]]

set_property ASYNC_REG TRUE \
  [get_cells -hier {*cdc_sync_stage1_reg*}] \
  [get_cells -hier {*cdc_sync_stage2_reg*}]

# Used for synchronizing resets with asynchronous de-assert
set_property ASYNC_REG TRUE \
  [get_cells -hier {up_reset_vector_reg*}] \
  [get_cells -hier {core_reset_vector_reg*}] \
  [get_cells -hier {up_reset_synchronizer_vector_reg*}] \
  [get_cells -hier {up_core_reset_ext_synchronizer_vector_reg*}]

set_false_path \
  -from [get_pins {i_up_tx/i_cdc_status/out_toggle_d1_reg/C}] \
  -to [get_pins {i_up_tx/i_cdc_status/i_sync_in/cdc_sync_stage1_reg[0]/D}]

set_false_path \
  -from [get_pins {i_up_tx/i_cdc_status/in_toggle_d1_reg/C}] \
  -to [get_pins {i_up_tx/i_cdc_status/i_sync_out/cdc_sync_stage1_reg[0]/D}]

set_false_path \
  -from [get_pins {i_up_sysref/i_cdc_sysref_event/in_toggle_d1_reg/C}] \
  -to [get_pins {i_up_sysref/i_cdc_sysref_event/i_sync_out/cdc_sync_stage1_reg[0]/D}]

set_false_path \
  -from [get_pins {i_up_sysref/i_cdc_sysref_event/out_toggle_d1_reg/C}] \
  -to [get_pins {i_up_sysref/i_cdc_sysref_event/i_sync_in/cdc_sync_stage1_reg[0]/D}]

set_false_path \
  -from [get_pins {i_up_sysref/i_cdc_sysref_event/cdc_hold_reg*/C}] \
  -to [get_pins {i_up_sysref/i_cdc_sysref_event/out_event_reg*/D}]

# Don't place them too far appart
set_max_delay -datapath_only \
  -from [get_pins {i_up_tx/i_cdc_status/cdc_hold_reg[*]/C}] \
  -to [get_pins {i_up_tx/i_cdc_status/out_data_reg[*]/D}] \
  [get_property -min PERIOD $axi_clk]

set_false_path \
  -from $core_clk \
  -to [get_pins {i_up_tx/i_cdc_sync/cdc_sync_stage1_reg[*]/D}]

set_false_path \
  -from [get_pins {i_up_common/up_reset_core_reg/C}] \
  -to [get_pins {i_up_common/core_reset_vector_reg[*]/PRE}]

set_false_path \
  -from [get_pins {i_up_common/up_reset_core_reg/C}] \
  -to [get_pins {i_up_common/device_reset_vector_reg[*]/PRE}]

set_false_path \
  -from [get_pins {i_up_common/core_reset_vector_reg[0]/C}] \
  -to [get_pins {i_up_common/up_reset_synchronizer_vector_reg[*]/PRE}]

set_false_path \
  -to [get_pins {i_up_common/up_core_reset_ext_synchronizer_vector_reg[*]/PRE}]

# set_max_delay -datapath_only \
#   -from [get_pins {i_up_common/up_cfg_*_reg*/C}] \
#   -to [get_pins {i_up_common/core_cfg_*_reg*/D}] \
#   [get_property -min PERIOD $core_clk]

# set_max_delay -datapath_only \
#   -from [get_pins {i_up_common/up_cfg_*_reg*/C}] \
#   -to [get_pins {i_up_common/device_cfg_*_reg*/D}] \
#   [get_property -min PERIOD $device_clk]

# set_max_delay -datapath_only \
#   -from [get_pins {i_up_tx/up_cfg_ilas_data_*_reg*/C}] \
#   -to [get_cells {i_up_tx/*core_ilas_config_data_reg*}] \
#   [get_property -min PERIOD $core_clk]

# set_max_delay -datapath_only \
#   -from [get_pins {i_up_tx/up_cfg_*_reg*/C}] \
#   -to [get_pins {i_up_common/core_extra_cfg_reg[*]/D}] \
#   [get_property -min PERIOD $core_clk]

# set_max_delay -datapath_only \
#   -from [get_pins {i_up_tx/up_cfg_*_reg*/C}] \
#   -to [get_pins {i_up_common/device_extra_cfg_reg[*]/D}] \
#   [get_property -min PERIOD $device_clk]

# set_max_delay -datapath_only \
#   -from [get_pins {i_up_sysref/up_cfg_*_reg*/C}] \
#   -to [get_pins {i_up_common/device_extra_cfg_reg[*]/D}] \
#   [get_property -min PERIOD $device_clk]




set_false_path \
  -from [get_pins {i_up_common/up_cfg_*_reg*/C}] \
  -to [get_pins {i_up_common/core_cfg_*_reg*/D}] 

set_false_path \
  -from [get_pins {i_up_common/up_cfg_*_reg*/C}] \
  -to [get_pins {i_up_common/device_cfg_*_reg*/D}] 

set_false_path \
  -from [get_pins {i_up_tx/up_cfg_ilas_data_*_reg*/C}] \
  -to [get_cells {i_up_tx/*core_ilas_config_data_reg*}] 

set_false_path \
  -from [get_pins {i_up_tx/up_cfg_*_reg*/C}] \
  -to [get_pins {i_up_common/core_extra_cfg_reg[*]/D}] 

set_false_path \
  -from [get_pins {i_up_tx/up_cfg_*_reg*/C}] \
  -to [get_pins {i_up_common/device_extra_cfg_reg[*]/D}] 

set_false_path \
  -from [get_pins {i_up_sysref/up_cfg_*_reg*/C}] \
  -to [get_pins {i_up_common/device_extra_cfg_reg[*]/D}] 



set_false_path \
  -from [get_pins {i_up_tx/i_cdc_manual_sync_request/out_toggle_d1_reg/C}] \
  -to [get_pins {i_up_tx/i_cdc_manual_sync_request/i_sync_in/cdc_sync_stage1_reg[0]/D}]

set_false_path \
  -from [get_pins {i_up_tx/i_cdc_manual_sync_request/in_toggle_d1_reg/C}] \
  -to [get_pins {i_up_tx/i_cdc_manual_sync_request/i_sync_out/cdc_sync_stage1_reg[0]/D}]
