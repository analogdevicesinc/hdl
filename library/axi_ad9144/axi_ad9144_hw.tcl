

package require -exact qsys 13.0
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
add_fileset_file ad_axi_ip_constr.sdc SDC     PATH $ad_hdl_dir/library/common/ad_axi_ip_constr.sdc

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

add_parameter DEVICE_TYPE INTEGER 0
set_parameter_property DEVICE_TYPE DEFAULT_VALUE 1
set_parameter_property DEVICE_TYPE DISPLAY_NAME DEVICE_TYPE
set_parameter_property DEVICE_TYPE TYPE INTEGER
set_parameter_property DEVICE_TYPE UNITS None
set_parameter_property DEVICE_TYPE HDL_PARAMETER true

# axi4 slave

add_interface s_axi_clock clock end
add_interface_port s_axi_clock s_axi_aclk clk Input 1

add_interface s_axi_reset reset end
set_interface_property s_axi_reset associatedClock s_axi_clock
add_interface_port s_axi_reset s_axi_aresetn reset_n Input 1

add_interface s_axi axi4lite end
set_interface_property s_axi associatedClock s_axi_clock
set_interface_property s_axi associatedReset s_axi_reset
add_interface_port s_axi s_axi_awvalid awvalid Input 1
add_interface_port s_axi s_axi_awaddr awaddr Input 16
add_interface_port s_axi s_axi_awprot awprot Input 3
add_interface_port s_axi s_axi_awready awready Output 1
add_interface_port s_axi s_axi_wvalid wvalid Input 1
add_interface_port s_axi s_axi_wdata wdata Input 32
add_interface_port s_axi s_axi_wstrb wstrb Input 4
add_interface_port s_axi s_axi_wready wready Output 1
add_interface_port s_axi s_axi_bvalid bvalid Output 1
add_interface_port s_axi s_axi_bresp bresp Output 2
add_interface_port s_axi s_axi_bready bready Input 1
add_interface_port s_axi s_axi_arvalid arvalid Input 1
add_interface_port s_axi s_axi_araddr araddr Input 16
add_interface_port s_axi s_axi_arprot arprot Input 3
add_interface_port s_axi s_axi_arready arready Output 1
add_interface_port s_axi s_axi_rvalid rvalid Output 1
add_interface_port s_axi s_axi_rresp rresp Output 2
add_interface_port s_axi s_axi_rdata rdata Output 32
add_interface_port s_axi s_axi_rready rready Input 1

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

add_interface dac_ch_0 conduit end
add_interface_port dac_ch_0  dac_enable_0  enable   Output  1
add_interface_port dac_ch_0  dac_valid_0   valid    Output  1
add_interface_port dac_ch_0  dac_ddata_0   data     Input   64

set_interface_property dac_ch_0 associatedClock if_tx_clk
set_interface_property dac_ch_0 associatedReset none

add_interface dac_ch_1 conduit end
add_interface_port dac_ch_1  dac_enable_1  enable   Output  1
add_interface_port dac_ch_1  dac_valid_1   valid    Output  1
add_interface_port dac_ch_1  dac_ddata_1   data     Input   64

set_interface_property dac_ch_1 associatedClock if_tx_clk
set_interface_property dac_ch_1 associatedReset none

ad_alt_intf signal  dac_dovf      input   1 ovf
ad_alt_intf signal  dac_dunf      input   1 unf

proc p_axi_ad9144 {} {

  set p_pcore_quad_dual_n [get_parameter_value "QUAD_OR_DUAL_N"]

  if {[get_parameter_value QUAD_OR_DUAL_N] == 1} {

    add_interface dac_ch_2 conduit end
    add_interface_port dac_ch_2  dac_enable_2  enable   Output  1
    add_interface_port dac_ch_2  dac_valid_2   valid    Output  1
    add_interface_port dac_ch_2  dac_ddata_2   data     Input   64

    set_interface_property dac_ch_2 associatedClock if_tx_clk
    set_interface_property dac_ch_2 associatedReset none

    add_interface dac_ch_3 conduit end
    add_interface_port dac_ch_3  dac_enable_3  enable   Output  1
    add_interface_port dac_ch_3  dac_valid_3   valid    Output  1
    add_interface_port dac_ch_3  dac_ddata_3   data     Input   64

    set_interface_property dac_ch_3 associatedClock if_tx_clk
    set_interface_property dac_ch_3 associatedReset none
  }
}
