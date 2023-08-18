###############################################################################
## Copyright (C) 2016-2018, 2021 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

set script_dir [file dirname [info script]]

source "$script_dir/util_cdc_constr.tcl"

util_cdc_sync_event_constr {*|jesd204_up_sysref:i_up_sysref|sync_event:i_cdc_sysref_event}
util_cdc_sync_event_constr {*|jesd204_up_tx:i_up_tx|sync_event:i_cdc_manual_sync_request}
util_cdc_sync_data_constr {*|jesd204_up_tx:i_up_tx|sync_data:i_cdc_status}
util_cdc_sync_bits_constr {*|jesd204_up_tx:i_up_tx|sync_bits:i_cdc_sync}

set_false_path \
  -from [get_registers {*|jesd204_up_common:i_up_common|up_reset_core}] \
  -to [get_registers {*|jesd204_up_common:i_up_common|core_reset_vector[*]}]

set_false_path \
  -from [get_registers {*|jesd204_up_common:i_up_common|up_reset_core}] \
  -to [get_registers {*|jesd204_up_common:i_up_common|device_reset_vector[*]}]

set_false_path \
  -from [get_registers {*|jesd204_up_common:i_up_common|core_reset_vector[0]}] \
  -to [get_registers {*|jesd204_up_common:i_up_common|up_reset_synchronizer_vector[*]}]

set_false_path \
  -to [get_pins -compatibility_mode {*|jesd204_up_common:i_up_common|up_core_reset_ext_synchronizer_vector[*]|clrn}]

set_false_path \
  -from [get_registers {*|jesd204_up_common:i_up_common|up_cfg_*}] \
  -to [get_registers {*|jesd204_up_common:i_up_common|core_cfg_*}]

set_false_path \
  -from [get_registers {*|jesd204_up_common:i_up_common|up_cfg_*}] \
  -to [get_registers {*|jesd204_up_common:i_up_common|device_cfg_*}]

set_false_path \
  -from [get_registers {*|jesd204_up_tx:i_up_tx|up_cfg_ilas_data_*}] \
  -to [get_registers {*|jesd204_up_tx:i_up_tx|core_ilas_config_data[*]}]

set_false_path \
  -from [get_registers {*|jesd204_up_tx:i_up_tx|up_cfg_*}] \
  -to [get_registers {*|jesd204_up_common:i_up_common|core_extra_cfg[*]}]

set_false_path \
  -from [get_registers {*|jesd204_up_tx:i_up_tx|up_cfg_*}] \
  -to [get_registers {*|jesd204_up_common:i_up_common|device_extra_cfg[*]}]

set_false_path \
  -from [get_registers {*|jesd204_up_sysref:i_up_sysref|up_cfg_*}] \
  -to [get_registers {*|jesd204_up_common:i_up_common|device_extra_cfg[*]}]
