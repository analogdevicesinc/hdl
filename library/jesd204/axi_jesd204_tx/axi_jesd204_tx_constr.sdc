#
# The ADI JESD204 Core is released under the following license, which is
# different than all other HDL cores in this repository.
#
# Please read this, and understand the freedoms and responsibilities you have
# by using this source code/core.
#
# The JESD204 HDL, is copyright © 2016-2017 Analog Devices Inc.
#
# This core is free software, you can use run, copy, study, change, ask
# questions about and improve this core. Distribution of source, or resulting
# binaries (including those inside an FPGA or ASIC) require you to release the
# source of the entire project (excluding the system libraries provide by the
# tools/compiler/FPGA vendor). These are the terms of the GNU General Public
# License version 2 as published by the Free Software Foundation.
#
# This core  is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License version 2
# along with this source code, and binary.  If not, see
# <http://www.gnu.org/licenses/>.
#
# Commercial licenses (with commercial support) of this JESD204 core are also
# available under terms different than the General Public License. (e.g. they
# do not require you to accompany any image (FPGA or ASIC) using the JESD204
# core with any corresponding source code.) For these alternate terms you must
# purchase a license from Analog Devices Technology Licensing Office. Users
# interested in such a license should contact jesd204-licensing@analog.com for
# more information. This commercial license is sub-licensable (if you purchase
# chips from Analog Devices, incorporate them into your PCB level product, and
# purchase a JESD204 license, end users of your product will also have a
# license to use this core in a commercial setting without releasing their
# source code).
#
# In addition, we kindly ask you to acknowledge ADI in any program, application
# or publication in which you use this JESD204 HDL core. (You are not required
# to do so; it is up to your common sense to decide whether you want to comply
# with this request or not.) For general publications, we suggest referencing :
# “The design and implementation of the JESD204 HDL Core used in this project
# is copyright © 2016-2017, Analog Devices, Inc.”
#

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
  -from [get_registers {*|jesd204_up_common:i_up_common|core_reset_vector[0]}] \
  -to [get_registers {*|jesd204_up_common:i_up_common|up_reset_synchronizer_vector[*]}]

set_false_path \
  -to [get_pins -compatibility_mode {*|jesd204_up_common:i_up_common|up_core_reset_ext_synchronizer_vector[*]|clrn}]

set_false_path \
  -from [get_registers {*|jesd204_up_common:i_up_common|up_cfg_*}] \
  -to [get_registers {*|jesd204_up_common:i_up_common|core_cfg_*}]

set_false_path \
  -from [get_registers {*|jesd204_up_tx:i_up_tx|up_cfg_ilas_data_*}] \
  -to [get_registers {*|jesd204_up_tx:i_up_tx|core_ilas_config_data[*]}]

set_false_path \
  -from [get_registers {*|jesd204_up_tx:i_up_tx|up_cfg_*}] \
  -to [get_registers {*|jesd204_up_common:i_up_common|core_extra_cfg[*]}]

set_false_path \
  -from [get_registers {*|jesd204_up_sysref:i_up_sysref|up_cfg_*}] \
  -to [get_registers {*|jesd204_up_common:i_up_common|core_extra_cfg[*]}]
