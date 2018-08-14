

package require qsys
package require quartus::device
source ../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

set_module_property NAME axi_ad9144
set_module_property DESCRIPTION "AXI AD9144 Interface"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME axi_ad9144
set_module_property ELABORATION_CALLBACK p_axi_ad9144
set_module_property VALIDATION_CALLBACK info_param_validate

# files

ad_ip_files axi_ad9144 [list \
  $ad_hdl_dir/library/intel/common/ad_mul.v \
  $ad_hdl_dir/library/common/ad_dds_cordic_pipe.v \
  $ad_hdl_dir/library/common/ad_dds_sine_cordic.v \
  $ad_hdl_dir/library/common/ad_dds_sine.v \
  $ad_hdl_dir/library/common/ad_dds_2.v \
  $ad_hdl_dir/library/common/ad_dds_1.v \
  $ad_hdl_dir/library/common/ad_dds.v \
  $ad_hdl_dir/library/common/ad_perfect_shuffle.v \
  $ad_hdl_dir/library/common/ad_rst.v \
  $ad_hdl_dir/library/common/up_axi.v \
  $ad_hdl_dir/library/common/up_xfer_cntrl.v \
  $ad_hdl_dir/library/common/up_xfer_status.v \
  $ad_hdl_dir/library/common/up_clock_mon.v \
  $ad_hdl_dir/library/common/up_dac_common.v \
  $ad_hdl_dir/library/common/up_dac_channel.v \
  \
  $ad_hdl_dir/library/jesd204/ad_ip_jesd204_tpl_dac/ad_ip_jesd204_tpl_dac.v \
  $ad_hdl_dir/library/jesd204/ad_ip_jesd204_tpl_dac/ad_ip_jesd204_tpl_dac_channel.v \
  $ad_hdl_dir/library/jesd204/ad_ip_jesd204_tpl_dac/ad_ip_jesd204_tpl_dac_core.v \
  $ad_hdl_dir/library/jesd204/ad_ip_jesd204_tpl_dac/ad_ip_jesd204_tpl_dac_framer.v \
  $ad_hdl_dir/library/jesd204/ad_ip_jesd204_tpl_dac/ad_ip_jesd204_tpl_dac_pn.v \
  $ad_hdl_dir/library/jesd204/ad_ip_jesd204_tpl_dac/ad_ip_jesd204_tpl_dac_regmap.v \
  $ad_hdl_dir/library/jesd204/ad_ip_jesd204_tpl_common/up_tpl_common.v \
  \
  axi_ad9144.v \
  $ad_hdl_dir/library/intel/common/up_xfer_cntrl_constr.sdc \
  $ad_hdl_dir/library/intel/common/up_xfer_status_constr.sdc \
  $ad_hdl_dir/library/intel/common/up_clock_mon_constr.sdc \
  $ad_hdl_dir/library/intel/common/up_rst_constr.sdc \
]

# parameters

add_parameter ID INTEGER 0
set_parameter_property ID DEFAULT_VALUE 0
set_parameter_property ID DISPLAY_NAME ID
set_parameter_property ID TYPE INTEGER
set_parameter_property ID UNITS None
set_parameter_property ID HDL_PARAMETER true

add_parameter QUAD_OR_DUAL_N INTEGER 0
set_parameter_property QUAD_OR_DUAL_N DEFAULT_VALUE 0
set_parameter_property QUAD_OR_DUAL_N DISPLAY_NAME QUAD_OR_DUAL_N
set_parameter_property QUAD_OR_DUAL_N TYPE INTEGER
set_parameter_property QUAD_OR_DUAL_N UNITS None
set_parameter_property QUAD_OR_DUAL_N HDL_PARAMETER true

adi_add_auto_fpga_spec_params

# axi4 slave

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn 12

# transceiver interface

ad_interface clock   tx_clk        input   1

add_interface if_tx_data avalon_streaming source
add_interface_port if_tx_data tx_data data output 128*(QUAD_OR_DUAL_N+1)
add_interface_port if_tx_data tx_valid valid output 1
add_interface_port if_tx_data tx_ready ready input 1
set_interface_property if_tx_data associatedClock if_tx_clk
set_interface_property if_tx_data dataBitsPerSymbol 128

# dma interface

ad_interface clock   dac_clk       output  1

for {set i 0} {$i < 4} {incr i} {
  add_interface dac_ch_${i} conduit end
  add_interface_port dac_ch_${i}  dac_enable_${i}  enable   Output  1
  add_interface_port dac_ch_${i}  dac_valid_${i}   valid    Output  1
  add_interface_port dac_ch_${i}  dac_ddata_${i}   data     Input   64

  set_interface_property dac_ch_${i} associatedClock if_tx_clk
  set_interface_property dac_ch_${i} associatedReset none
}

ad_interface signal  dac_dunf      input   1 unf

proc p_axi_ad9144 {} {

  if {[get_parameter_value QUAD_OR_DUAL_N] != 1} {
    set_interface_property dac_ch_2 ENABLED false
    set_interface_property dac_ch_3 ENABLED false
  }
}
