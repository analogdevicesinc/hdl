

package require qsys
source ../scripts/adi_env.tcl
source ../scripts/adi_ip_alt.tcl

set_module_property NAME axi_ad9144
set_module_property DESCRIPTION "AXI AD9144 Interface"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME axi_ad9144
set_module_property ELABORATION_CALLBACK p_axi_ad9144

# files

add_fileset quartus_synth QUARTUS_SYNTH "" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL axi_ad9144
add_fileset_file ad_mul.v             VERILOG PATH $ad_hdl_dir/library/altera/common/ad_mul.v
add_fileset_file ad_dds_cordic_pipe.v VERILOG PATH $ad_hdl_dir/library/common/ad_dds_cordic_pipe.v
add_fileset_file ad_dds_sine_cordic.v VERILOG PATH $ad_hdl_dir/library/common/ad_dds_sine_cordic.v
add_fileset_file ad_dds_sine.v        VERILOG PATH $ad_hdl_dir/library/common/ad_dds_sine.v
add_fileset_file ad_dds_1.v           VERILOG PATH $ad_hdl_dir/library/common/ad_dds_1.v
add_fileset_file ad_dds.v             VERILOG PATH $ad_hdl_dir/library/common/ad_dds.v
add_fileset_file ad_rst.v             VERILOG PATH $ad_hdl_dir/library/common/ad_rst.v
add_fileset_file up_axi.v             VERILOG PATH $ad_hdl_dir/library/common/up_axi.v
add_fileset_file up_xfer_cntrl.v      VERILOG PATH $ad_hdl_dir/library/common/up_xfer_cntrl.v
add_fileset_file up_xfer_status.v     VERILOG PATH $ad_hdl_dir/library/common/up_xfer_status.v
add_fileset_file up_clock_mon.v       VERILOG PATH $ad_hdl_dir/library/common/up_clock_mon.v
add_fileset_file up_dac_common.v      VERILOG PATH $ad_hdl_dir/library/common/up_dac_common.v
add_fileset_file up_dac_channel.v     VERILOG PATH $ad_hdl_dir/library/common/up_dac_channel.v
add_fileset_file axi_ad9144_channel.v VERILOG PATH axi_ad9144_channel.v
add_fileset_file axi_ad9144_core.v    VERILOG PATH axi_ad9144_core.v
add_fileset_file axi_ad9144_if.v      VERILOG PATH axi_ad9144_if.v
add_fileset_file axi_ad9144.v         VERILOG PATH axi_ad9144.v TOP_LEVEL_FILE
add_fileset_file up_xfer_cntrl_constr.sdc SDC PATH $ad_hdl_dir/library/altera/common/up_xfer_cntrl_constr.sdc
add_fileset_file up_xfer_status_constr.sdc  SDC PATH $ad_hdl_dir/library/altera/common/up_xfer_status_constr.sdc
add_fileset_file up_clock_mon_constr.sdc  SDC PATH $ad_hdl_dir/library/altera/common/up_clock_mon_constr.sdc
add_fileset_file up_rst_constr.sdc  SDC PATH $ad_hdl_dir/library/altera/common/up_rst_constr.sdc

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

# axi4 slave

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn

# transceiver interface

ad_alt_intf clock   tx_clk        input   1

add_interface if_tx_data avalon_streaming source
add_interface_port if_tx_data tx_data data output 128*(QUAD_OR_DUAL_N+1)
add_interface_port if_tx_data tx_valid valid output 1
add_interface_port if_tx_data tx_ready ready input 1
set_interface_property if_tx_data associatedClock if_tx_clk
set_interface_property if_tx_data dataBitsPerSymbol 128

# dma interface

ad_alt_intf clock   dac_clk       output  1

for {set i 0} {$i < 4} {incr i} {
  add_interface dac_ch_${i} conduit end
  add_interface_port dac_ch_${i}  dac_enable_${i}  enable   Output  1
  add_interface_port dac_ch_${i}  dac_valid_${i}   valid    Output  1
  add_interface_port dac_ch_${i}  dac_ddata_${i}   data     Input   64

  set_interface_property dac_ch_${i} associatedClock if_tx_clk
  set_interface_property dac_ch_${i} associatedReset none
}

ad_alt_intf signal  dac_dovf      input   1 ovf
ad_alt_intf signal  dac_dunf      input   1 unf

proc p_axi_ad9144 {} {

  if {[get_parameter_value QUAD_OR_DUAL_N] != 1} {
    set_interface_property dac_ch_2 ENABLED false
    set_interface_property dac_ch_3 ENABLED false
  }
}
