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

set axi_clk [get_clocks -of_objects [get_ports s_axi_aclk]]
set core_clk [get_clocks -of_objects [get_ports core_clk]]

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
  -from [get_pins {i_up_rx/i_cdc_status/in_toggle_d1_reg/C}] \
  -to [get_pins {i_up_rx/i_cdc_status/i_sync_out/cdc_sync_stage1_reg[0]/D}]

set_false_path \
  -from [get_pins {i_up_rx/i_cdc_status/out_toggle_d1_reg/C}] \
  -to [get_pins {i_up_rx/i_cdc_status/i_sync_in/cdc_sync_stage1_reg[0]/D}]

set_false_path \
  -from [get_pins {i_up_rx/i_cdc_cfg/in_toggle_d1_reg/C}] \
  -to [get_pins {i_up_rx/i_cdc_cfg/i_sync_out/cdc_sync_stage1_reg[0]/D}]

set_false_path \
  -from [get_pins {i_up_rx/i_cdc_cfg/out_toggle_d1_reg/C}] \
  -to [get_pins {i_up_rx/i_cdc_cfg/i_sync_in/cdc_sync_stage1_reg[0]/D}]

set_false_path \
  -from [get_pins {i_up_sysref/i_cdc_sysref_event/in_toggle_d1_reg/C}] \
  -to [get_pins {i_up_sysref/i_cdc_sysref_event/i_sync_out/cdc_sync_stage1_reg[0]/D}]

set_false_path \
  -from [get_pins {i_up_sysref/i_cdc_sysref_event/out_toggle_d1_reg/C}] \
  -to [get_pins {i_up_sysref/i_cdc_sysref_event/i_sync_in/cdc_sync_stage1_reg[0]/D}]

set_false_path \
  -from [get_pins {i_up_sysref/i_cdc_sysref_event/cdc_hold_reg*/C}] \
  -to [get_pins {i_up_sysref/i_cdc_sysref_event/out_event_reg*/D}]

set_false_path \
  -from [get_pins {i_sync_frame_align_err/in_toggle_d1_reg/C}] \
  -to [get_pins {i_sync_frame_align_err/i_sync_out/cdc_sync_stage1_reg[0]/D}]

set_false_path \
  -from [get_pins {i_sync_frame_align_err/out_toggle_d1_reg/C}] \
  -to [get_pins {i_sync_frame_align_err/i_sync_in/cdc_sync_stage1_reg[0]/D}]

set_false_path \
  -from [get_pins {i_sync_frame_align_err/cdc_hold_reg*/C}] \
  -to [get_pins {i_sync_frame_align_err/out_event_reg*/D}]

# Don't place them too far appart
set_max_delay -datapath_only \
  -from [get_pins {i_up_rx/i_cdc_status/cdc_hold_reg[*]/C}] \
  -to [get_pins {i_up_rx/i_cdc_status/out_data_reg[*]/D}] \
  [get_property -min PERIOD $axi_clk]

set_false_path \
  -from $core_clk \
  -to [get_pins {i_up_rx/*i_up_rx_lane/i_cdc_status_ready/cdc_sync_stage1_reg*/D}]

set_max_delay -datapath_only \
  -from [get_pins {i_up_rx/i_cdc_cfg/cdc_hold_reg[*]/C}] \
  -to [get_pins {i_up_rx/i_cdc_cfg/out_data_reg[*]/D}] \
  [get_property -min PERIOD $core_clk]

set_max_delay -datapath_only \
  -from $core_clk \
  -to [get_pins {i_up_rx/*i_up_rx_lane/up_status_latency_reg[*]/D}] \
  [get_property -min PERIOD $axi_clk]

set_false_path \
  -from $core_clk \
  -to [get_pins {i_up_rx/*i_up_rx_lane/i_ilas_mem/i_cdc_ilas_ready/cdc_sync_stage1_reg[0]/D}]

# Use -quiet here since the ILAS mem is missing in non 8b10b configuration
set_max_delay -quiet -datapath_only \
 -from [get_pins {i_up_rx/gen_lane[*].i_up_rx_lane/i_ilas_mem/mem_reg_*/*/CLK}] \
 -to [get_pins {i_up_rx/gen_lane[*].i_up_rx_lane/i_ilas_mem/up_rdata_reg[*]/D}] \
  [get_property -min PERIOD $axi_clk]

set_false_path \
  -from [get_pins {i_up_common/up_reset_core_reg/C}] \
  -to [get_pins {i_up_common/core_reset_vector_reg[*]/PRE}]

set_false_path \
  -from [get_pins {i_up_common/core_reset_vector_reg[0]/C}] \
  -to [get_pins {i_up_common/up_reset_synchronizer_vector_reg[*]/PRE}]

set_false_path \
  -to [get_pins {i_up_common/up_core_reset_ext_synchronizer_vector_reg[*]/PRE}]

set_max_delay -datapath_only \
  -from [get_pins {i_up_common/up_cfg_*_reg*/C}] \
  -to [get_pins {i_up_common/core_cfg_*_reg*/D}] \
  [get_property -min PERIOD $core_clk]

set_max_delay -datapath_only \
  -from [get_pins {i_up_rx/up_cfg_*_reg*/C}] \
  -to [get_pins {i_up_common/core_extra_cfg_reg[*]/D}] \
  [get_property -min PERIOD $core_clk]

set_max_delay -datapath_only \
  -from [get_pins {i_up_sysref/up_cfg_*_reg*/C}] \
  -to [get_pins {i_up_common/core_extra_cfg_reg[*]/D}] \
  [get_property -min PERIOD $core_clk]
