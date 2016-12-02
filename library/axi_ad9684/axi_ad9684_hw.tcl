
package require -exact qsys 13.0
source ../scripts/adi_env.tcl
source ../scripts/adi_ip_alt.tcl

set_module_property NAME axi_ad9684
set_module_property DESCRIPTION "AXI ad9684 Interface"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME axi_ad9684
set_module_property ELABORATION_CALLBACK p_axi_ad9684

# files

add_fileset quartus_synth QUARTUS_SYNTH "ad9684_fileset_callback" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL axi_ad9684

add_fileset_file  ad_rst.v               VERILOG PATH $ad_hdl_dir/library/common/ad_rst.v
add_fileset_file  ad_serdes_in.v         VERILOG PATH $ad_hdl_dir/library/altera/common/ad_serdes_in.v
add_fileset_file  ad_datafmt.v           VERILOG PATH $ad_hdl_dir/library/common/ad_datafmt.v
add_fileset_file  ad_pnmon.v             VERILOG PATH $ad_hdl_dir/library/common/ad_pnmon.v
add_fileset_file  up_xfer_status.v       VERILOG PATH $ad_hdl_dir/library/common/up_xfer_status.v
add_fileset_file  up_xfer_cntrl.v        VERILOG PATH $ad_hdl_dir/library/common/up_xfer_cntrl.v
add_fileset_file  up_clock_mon.v         VERILOG PATH $ad_hdl_dir/library/common/up_clock_mon.v
add_fileset_file  up_delay_cntrl.v       VERILOG PATH $ad_hdl_dir/library/common/up_delay_cntrl.v
add_fileset_file  up_adc_common.v        VERILOG PATH $ad_hdl_dir/library/common/up_adc_common.v
add_fileset_file  up_adc_channel.v       VERILOG PATH $ad_hdl_dir/library/common/up_adc_channel.v
add_fileset_file  up_axi.v               VERILOG PATH $ad_hdl_dir/library/common/up_axi.v
add_fileset_file  axi_ad9684_pnmon.v     VERILOG PATH axi_ad9684_pnmon.v
add_fileset_file  axi_ad9684_if.v        VERILOG PATH axi_ad9684_if.v
add_fileset_file  axi_ad9684_channel.v   VERILOG PATH axi_ad9684_channel.v
add_fileset_file  axi_ad9684.v           VERILOG PATH axi_ad9684.v TOP_LEVEL_FILE
add_fileset_file  ad_axi_ip_constr.sdc   SDC     PATH $ad_hdl_dir/library/common/ad_axi_ip_constr.sdc
add_fileset_file  axi_ad9684_constr.sdc  SDC     PATH axi_ad9684_constr.sdc

# paramter for fileset callback

add_parameter HDL_LIB_PATH STRING $ad_hdl_dir
set_parameter_property HDL_LIB_PATH TYPE STRING
set_parameter_property HDL_LIB_PATH HDL_PARAMETER false

# parameters

add_parameter DEVICE_TYPE INTEGER 0
set_parameter_property DEVICE_TYPE DEFAULT_VALUE 0
set_parameter_property DEVICE_TYPE DISPLAY_NAME DEVICE_TYPE
set_parameter_property DEVICE_TYPE TYPE INTEGER
set_parameter_property DEVICE_TYPE DESCRIPTION "Specify the FPGA device type"
set_parameter_property DEVICE_TYPE UNITS None
set_parameter_property DEVICE_TYPE HDL_PARAMETER true

add_parameter DAC_DATAPATH_DISABLE INTEGER 0
set_parameter_property DAC_DATAPATH_DISABLE DEFAULT_VALUE 0
set_parameter_property DAC_DATAPATH_DISABLE DISPLAY_NAME DAC_DATAPATH_DISABLE
set_parameter_property DAC_DATAPATH_DISABLE TYPE INTEGER
set_parameter_property DAC_DATAPATH_DISABLE DESCRIPTION "If active, all the data processing logic will be left out from the IP"
set_parameter_property DAC_DATAPATH_DISABLE UNITS None
set_parameter_property DAC_DATAPATH_DISABLE HDL_PARAMETER true

add_parameter OR_STATUS INTEGER 1
set_parameter_property OR_STATUS DEFAULT_VALUE 1
set_parameter_property OR_STATUS DISPLAY_NAME OR_STATUS
set_parameter_property OR_STATUS TYPE INTEGER
set_parameter_property OR_STATUS DESCRIPTION "This parameter enables the OVER RANGE line at the physical interface"
set_parameter_property OR_STATUS UNITS None
set_parameter_property OR_STATUS HDL_PARAMETER true

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

# adc device interface

add_interface device_if conduit end
set_interface_property device_if associatedClock none
set_interface_property device_if associatedReset none

add_interface_port device_if adc_clk_in_p adc_clk_in_p Input 1
add_interface_port device_if adc_clk_in_n adc_clk_in_n Input 1
add_interface_port device_if adc_data_in_p adc_data_in_p Input 14
add_interface_port device_if adc_data_in_n adc_data_in_n Input 14

# dma interface

ad_alt_intf clock adc_clk output 1
ad_alt_intf reset adc_rst output 1 if_adc_clk

add_interface adc_ch_0 conduit end
add_interface_port adc_ch_0 adc_valid_0   valid   Output 1
add_interface_port adc_ch_0 adc_enable_0  enable  Output 1
add_interface_port adc_ch_0 adc_ddata_0   data    Output 32
set_interface_property adc_ch_0 associatedClock if_adc_clk
set_interface_property adc_ch_0 associatedReset none

add_interface adc_ch_1 conduit end
add_interface_port adc_ch_1 adc_valid_1   valid   Output 1
add_interface_port adc_ch_1 adc_enable_1  enable  Output 1
add_interface_port adc_ch_1 adc_ddata_1   data    Output 32
set_interface_property adc_ch_1 associatedClock if_adc_clk
set_interface_property adc_ch_1 associatedReset none

ad_alt_intf signal adc_dovf input 1 ovf
ad_alt_intf signal adc_dunf input 1 unf

# SERDES instances and configurations

add_hdl_instance alt_serdes_clk_core_rx alt_serdes
set_instance_parameter_value alt_serdes_clk_core_rx {MODE} {CLK}
set_instance_parameter_value alt_serdes_clk_core_rx {DDR_OR_SDR_N} {1}
set_instance_parameter_value alt_serdes_clk_core_rx {SERDES_FACTOR} {4}
set_instance_parameter_value alt_serdes_clk_core_rx {CLKIN_FREQUENCY} {500.0}

add_hdl_instance alt_serdes_in_core alt_serdes
set_instance_parameter_value alt_serdes_in_core {MODE} {IN}
set_instance_parameter_value alt_serdes_in_core {DDR_OR_SDR_N} {1}
set_instance_parameter_value alt_serdes_in_core {SERDES_FACTOR} {4}
set_instance_parameter_value alt_serdes_in_core {CLKIN_FREQUENCY} {500.0}

proc p_axi_ad9684 {} {

  set or_status [get_parameter_value OR_STATUS]

  if {$or_status == 1} {
    add_interface_port device_if adc_data_or_p adc_data_or_p Input 1
    add_interface_port device_if adc_data_or_n adc_data_or_n Input 1
  }
}

# fileset callback to create the SERDES CLOCK instances

proc ad9684_fileset_callback { entityName } {

  send_message INFO "Generating SERDES clock instance for $entityName"
  set ad_hdl_dir [get_parameter_value HDL_LIB_PATH]
  exec mkdir -p generated

  # copy the generic ad_serdes_clk into working directory with modified ALT_IOPLL instance name
  ad_generate_module_inst "alt_serdes_clk_core" "rx" $ad_hdl_dir/library/altera/common/ad_serdes_clk.v generated/ad_serdes_clk.v

  add_fileset_file  generated/ad_serdes_clk.v   VERILOG PATH  generated/ad_serdes_clk.v
}

