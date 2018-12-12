

package require qsys
package require quartus::device

source ../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

set_module_property NAME axi_ad9371
set_module_property DESCRIPTION "AXI AD9371 Interface"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME axi_ad9371
set_module_property VALIDATION_CALLBACK info_param_validate

# files

add_fileset quartus_synth QUARTUS_SYNTH "" "Quartus Synthesis"
set_fileset_property quartus_synth TOP_LEVEL axi_ad9371
add_fileset_file ad_rst.v                   VERILOG PATH $ad_hdl_dir/library/common/ad_rst.v
add_fileset_file ad_mul.v                   VERILOG PATH $ad_hdl_dir/library/intel/common/ad_mul.v
add_fileset_file ad_dds_cordic_pipe.v       VERILOG PATH $ad_hdl_dir/library/common/ad_dds_cordic_pipe.v
add_fileset_file ad_dds_sine_cordic.v       VERILOG PATH $ad_hdl_dir/library/common/ad_dds_sine_cordic.v
add_fileset_file ad_dds_sine.v              VERILOG PATH $ad_hdl_dir/library/common/ad_dds_sine.v
add_fileset_file ad_dds_2.v                 VERILOG PATH $ad_hdl_dir/library/common/ad_dds_2.v
add_fileset_file ad_dds_1.v                 VERILOG PATH $ad_hdl_dir/library/common/ad_dds_1.v
add_fileset_file ad_dds.v                   VERILOG PATH $ad_hdl_dir/library/common/ad_dds.v
add_fileset_file ad_datafmt.v               VERILOG PATH $ad_hdl_dir/library/common/ad_datafmt.v
add_fileset_file ad_dcfilter.v              VERILOG PATH $ad_hdl_dir/library/intel/common/ad_dcfilter.v
add_fileset_file ad_iqcor.v                 VERILOG PATH $ad_hdl_dir/library/common/ad_iqcor.v
add_fileset_file up_axi.v                   VERILOG PATH $ad_hdl_dir/library/common/up_axi.v
add_fileset_file up_xfer_cntrl.v            VERILOG PATH $ad_hdl_dir/library/common/up_xfer_cntrl.v
add_fileset_file up_xfer_status.v           VERILOG PATH $ad_hdl_dir/library/common/up_xfer_status.v
add_fileset_file up_clock_mon.v             VERILOG PATH $ad_hdl_dir/library/common/up_clock_mon.v
add_fileset_file up_adc_common.v            VERILOG PATH $ad_hdl_dir/library/common/up_adc_common.v
add_fileset_file up_adc_channel.v           VERILOG PATH $ad_hdl_dir/library/common/up_adc_channel.v
add_fileset_file up_dac_common.v            VERILOG PATH $ad_hdl_dir/library/common/up_dac_common.v
add_fileset_file up_dac_channel.v           VERILOG PATH $ad_hdl_dir/library/common/up_dac_channel.v
add_fileset_file ad_xcvr_rx_if.v            VERILOG PATH $ad_hdl_dir/library/common/ad_xcvr_rx_if.v
add_fileset_file axi_ad9371_if.v            VERILOG PATH axi_ad9371_if.v
add_fileset_file axi_ad9371_rx_channel.v    VERILOG PATH axi_ad9371_rx_channel.v
add_fileset_file axi_ad9371_rx.v            VERILOG PATH axi_ad9371_rx.v
add_fileset_file axi_ad9371_rx_os.v         VERILOG PATH axi_ad9371_rx_os.v
add_fileset_file axi_ad9371_tx_channel.v    VERILOG PATH axi_ad9371_tx_channel.v
add_fileset_file axi_ad9371_tx.v            VERILOG PATH axi_ad9371_tx.v
add_fileset_file axi_ad9371.v               VERILOG PATH axi_ad9371.v TOP_LEVEL_FILE
add_fileset_file up_xfer_cntrl_constr.sdc   SDC PATH  $ad_hdl_dir/library/intel/common/up_xfer_cntrl_constr.sdc
add_fileset_file up_xfer_status_constr.sdc  SDC PATH  $ad_hdl_dir/library/intel/common/up_xfer_status_constr.sdc
add_fileset_file up_clock_mon_constr.sdc    SDC PATH  $ad_hdl_dir/library/intel/common/up_clock_mon_constr.sdc
add_fileset_file up_rst_constr.sdc          SDC PATH  $ad_hdl_dir/library/intel/common/up_rst_constr.sdc

# parameters

add_parameter ID INTEGER 0
set_parameter_property ID DEFAULT_VALUE 0
set_parameter_property ID DISPLAY_NAME ID
set_parameter_property ID UNITS None
set_parameter_property ID HDL_PARAMETER true

add_parameter DAC_DATAPATH_DISABLE INTEGER 0
set_parameter_property DAC_DATAPATH_DISABLE DEFAULT_VALUE 0
set_parameter_property DAC_DATAPATH_DISABLE DISPLAY_NAME DAC_DATAPATH_DISABLE
set_parameter_property DAC_DATAPATH_DISABLE UNITS None
set_parameter_property DAC_DATAPATH_DISABLE HDL_PARAMETER true

add_parameter ADC_DATAPATH_DISABLE INTEGER 0
set_parameter_property ADC_DATAPATH_DISABLE DEFAULT_VALUE 0
set_parameter_property ADC_DATAPATH_DISABLE DISPLAY_NAME ADC_DATAPATH_DISABLE
set_parameter_property ADC_DATAPATH_DISABLE UNITS None
set_parameter_property ADC_DATAPATH_DISABLE HDL_PARAMETER true

adi_add_auto_fpga_spec_params

# axi4 slave

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn

# transceiver interface

ad_interface clock adc_clk input 1
ad_interface signal adc_rx_sof input 4 export
add_interface if_adc_rx_data avalon_streaming sink
add_interface_port if_adc_rx_data adc_rx_data  data  input 64
add_interface_port if_adc_rx_data adc_rx_valid valid input 1
add_interface_port if_adc_rx_data adc_rx_ready ready output 1
set_interface_property if_adc_rx_data associatedClock if_adc_clk
set_interface_property if_adc_rx_data dataBitsPerSymbol 64

ad_interface clock adc_os_clk input 1
ad_interface signal adc_rx_os_sof input 4 export
add_interface if_adc_rx_os_data avalon_streaming sink
add_interface_port if_adc_rx_os_data adc_rx_os_data  data  input 64
add_interface_port if_adc_rx_os_data adc_rx_os_valid valid input 1
add_interface_port if_adc_rx_os_data adc_rx_os_ready ready output 1
set_interface_property if_adc_rx_os_data associatedClock if_adc_os_clk
set_interface_property if_adc_rx_os_data dataBitsPerSymbol 64

ad_interface clock dac_clk input 1
add_interface if_dac_tx_data avalon_streaming source
add_interface_port if_dac_tx_data dac_tx_data data output 128
add_interface_port if_dac_tx_data dac_tx_valid valid output 1
add_interface_port if_dac_tx_data dac_tx_ready ready input 1
set_interface_property if_dac_tx_data associatedClock if_dac_clk
set_interface_property if_dac_tx_data dataBitsPerSymbol 128

# master/slave

ad_interface signal  dac_sync_in     input   1
ad_interface signal  dac_sync_out    output  1

# adc-channel interface

add_interface adc_ch_0 conduit end
add_interface_port adc_ch_0  adc_enable_i0  enable   Output  1
add_interface_port adc_ch_0  adc_valid_i0   valid    Output  1
add_interface_port adc_ch_0  adc_data_i0    data     Output  16

set_interface_property adc_ch_0 associatedClock if_adc_clk
set_interface_property adc_ch_0 associatedReset none

add_interface adc_ch_1 conduit end
add_interface_port adc_ch_1  adc_enable_q0  enable   Output  1
add_interface_port adc_ch_1  adc_valid_q0   valid    Output  1
add_interface_port adc_ch_1  adc_data_q0    data     Output  16

set_interface_property adc_ch_1 associatedClock if_adc_clk
set_interface_property adc_ch_1 associatedReset none

add_interface adc_ch_2 conduit end
add_interface_port adc_ch_2  adc_enable_i1  enable   Output  1
add_interface_port adc_ch_2  adc_valid_i1   valid    Output  1
add_interface_port adc_ch_2  adc_data_i1    data     Output  16

set_interface_property adc_ch_2 associatedClock if_adc_clk
set_interface_property adc_ch_2 associatedReset none

add_interface adc_ch_3 conduit end
add_interface_port adc_ch_3  adc_enable_q1  enable   Output  1
add_interface_port adc_ch_3  adc_valid_q1   valid    Output  1
add_interface_port adc_ch_3  adc_data_q1    data     Output  16

set_interface_property adc_ch_3 associatedClock if_adc_clk
set_interface_property adc_ch_3 associatedReset none

ad_interface signal  adc_dovf      input   1 ovf

# adc-os-channel interface

add_interface adc_os_ch_0 conduit end
add_interface_port adc_os_ch_0  adc_os_enable_i0  enable   Output  1
add_interface_port adc_os_ch_0  adc_os_valid_i0   valid    Output  1
add_interface_port adc_os_ch_0  adc_os_data_i0    data     Output  32

set_interface_property adc_os_ch_0 associatedClock if_adc_os_clk
set_interface_property adc_os_ch_0 associatedReset none

add_interface adc_os_ch_1 conduit end
add_interface_port adc_os_ch_1  adc_os_enable_q0  enable   Output  1
add_interface_port adc_os_ch_1  adc_os_valid_q0   valid    Output  1
add_interface_port adc_os_ch_1  adc_os_data_q0    data     Output  32

set_interface_property adc_os_ch_1 associatedClock if_adc_os_clk
set_interface_property adc_os_ch_1 associatedReset none

ad_interface signal  adc_os_dovf      input   1 ovf

# dac-channel interface

add_interface dac_ch_0 conduit end
add_interface_port dac_ch_0  dac_enable_i0  enable   Output  1
add_interface_port dac_ch_0  dac_valid_i0   valid    Output  1
add_interface_port dac_ch_0  dac_data_i0    data     Input   32

set_interface_property dac_ch_0 associatedClock if_dac_clk
set_interface_property dac_ch_0 associatedReset none

add_interface dac_ch_1 conduit end
add_interface_port dac_ch_1  dac_enable_q0  enable   Output  1
add_interface_port dac_ch_1  dac_valid_q0   valid    Output  1
add_interface_port dac_ch_1  dac_data_q0    data     Input   32

set_interface_property dac_ch_1 associatedClock if_dac_clk
set_interface_property dac_ch_1 associatedReset none

add_interface dac_ch_2 conduit end
add_interface_port dac_ch_2  dac_enable_i1  enable   Output  1
add_interface_port dac_ch_2  dac_valid_i1   valid    Output  1
add_interface_port dac_ch_2  dac_data_i1    data     Input   32

set_interface_property dac_ch_2 associatedClock if_dac_clk
set_interface_property dac_ch_2 associatedReset none

add_interface dac_ch_3 conduit end
add_interface_port dac_ch_3  dac_enable_q1  enable   Output  1
add_interface_port dac_ch_3  dac_valid_q1   valid    Output  1
add_interface_port dac_ch_3  dac_data_q1    data     Input   32

set_interface_property dac_ch_3 associatedClock if_dac_clk
set_interface_property dac_ch_3 associatedReset none

ad_interface signal  dac_dunf      input   1 unf

