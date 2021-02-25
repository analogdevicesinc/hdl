

package require qsys
source ../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

set_module_property NAME util_wfifo
set_module_property DESCRIPTION "Utils Write FIFO"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME util_wfifo
set_module_property ELABORATION_CALLBACK p_util_wfifo

# files

add_fileset quartus_synth QUARTUS_SYNTH "" ""
set_fileset_property quartus_synth TOP_LEVEL util_wfifo
add_fileset_file ad_mem.v               VERILOG PATH $ad_hdl_dir/library/common/ad_mem.v
add_fileset_file util_wfifo.v           VERILOG PATH util_wfifo.v TOP_LEVEL_FILE
add_fileset_file util_wfifo_constr.sdc  SDC     PATH util_wfifo_constr.sdc

# parameters

add_parameter NUM_OF_CHANNELS INTEGER 0
set_parameter_property NUM_OF_CHANNELS DEFAULT_VALUE 4
set_parameter_property NUM_OF_CHANNELS DISPLAY_NAME NUM_OF_CHANNELS
set_parameter_property NUM_OF_CHANNELS UNITS None
set_parameter_property NUM_OF_CHANNELS HDL_PARAMETER true

add_parameter DIN_DATA_WIDTH INTEGER 0
set_parameter_property DIN_DATA_WIDTH DEFAULT_VALUE 32
set_parameter_property DIN_DATA_WIDTH DISPLAY_NAME DIN_DATA_WIDTH
set_parameter_property DIN_DATA_WIDTH UNITS None
set_parameter_property DIN_DATA_WIDTH HDL_PARAMETER true

add_parameter DOUT_DATA_WIDTH INTEGER 0
set_parameter_property DOUT_DATA_WIDTH DEFAULT_VALUE 64
set_parameter_property DOUT_DATA_WIDTH DISPLAY_NAME DOUT_DATA_WIDTH
set_parameter_property DOUT_DATA_WIDTH UNITS None
set_parameter_property DOUT_DATA_WIDTH HDL_PARAMETER true

add_parameter DIN_ADDRESS_WIDTH INTEGER 0
set_parameter_property DIN_ADDRESS_WIDTH DEFAULT_VALUE 8
set_parameter_property DIN_ADDRESS_WIDTH DISPLAY_NAME DIN_ADDRESS_WIDTH
set_parameter_property DIN_ADDRESS_WIDTH UNITS None
set_parameter_property DIN_ADDRESS_WIDTH HDL_PARAMETER true

# defaults

ad_interface clock   din_clk         input   1
ad_interface reset   din_rst         input   1 if_din_clk

ad_interface clock   dout_clk        input   1
ad_interface reset-n dout_rstn       input   1 if_dout_clk

add_interface din_0 conduit end
add_interface_port din_0  din_enable_0  enable   Input  1
add_interface_port din_0  din_valid_0   valid    Input  1
add_interface_port din_0  din_data_0    data     Input  DIN_DATA_WIDTH

set_interface_property din_0 associatedClock if_din_clk
set_interface_property din_0 associatedReset none

add_interface dout_0 conduit end
add_interface_port dout_0 dout_enable_0 enable   Output 1
add_interface_port dout_0 dout_valid_0  valid    Output 1
add_interface_port dout_0 dout_data_0   data     Output DOUT_DATA_WIDTH

set_interface_property dout_0 associatedClock if_dout_clk
set_interface_property dout_0 associatedReset none

ad_interface signal din_ovf output 1 ovf
ad_interface signal dout_ovf input 1 ovf

proc p_util_wfifo {} {

  if {[get_parameter_value NUM_OF_CHANNELS] > 1} {

    add_interface din_1 conduit end
    add_interface_port din_1  din_enable_1  enable   Input  1
    add_interface_port din_1  din_valid_1   valid    Input  1
    add_interface_port din_1  din_data_1    data     Input  DIN_DATA_WIDTH

    set_interface_property din_1 associatedClock if_din_clk
    set_interface_property din_1 associatedReset none

    add_interface dout_1 conduit end
    add_interface_port dout_1 dout_enable_1 enable   Output 1
    add_interface_port dout_1 dout_valid_1  valid    Output 1
    add_interface_port dout_1 dout_data_1   data     Output DOUT_DATA_WIDTH

    set_interface_property dout_1 associatedClock if_dout_clk
    set_interface_property dout_1 associatedReset none
  }

  if {[get_parameter_value NUM_OF_CHANNELS] > 2} {

    add_interface din_2 conduit end
    add_interface_port din_2  din_enable_2  enable   Input  1
    add_interface_port din_2  din_valid_2   valid    Input  1
    add_interface_port din_2  din_data_2    data     Input  DIN_DATA_WIDTH

    set_interface_property din_2 associatedClock if_din_clk
    set_interface_property din_2 associatedReset none

    add_interface dout_2 conduit end
    add_interface_port dout_2 dout_enable_2 enable   Output 1
    add_interface_port dout_2 dout_valid_2  valid    Output 1
    add_interface_port dout_2 dout_data_2   data     Output DOUT_DATA_WIDTH

    set_interface_property dout_2 associatedClock if_dout_clk
    set_interface_property dout_2 associatedReset none
  }

  if {[get_parameter_value NUM_OF_CHANNELS] > 3} {

    add_interface din_3 conduit end
    add_interface_port din_3  din_enable_3  enable   Input  1
    add_interface_port din_3  din_valid_3   valid    Input  1
    add_interface_port din_3  din_data_3    data     Input  DIN_DATA_WIDTH

    set_interface_property din_3 associatedClock if_din_clk
    set_interface_property din_3 associatedReset none

    add_interface dout_3 conduit end
    add_interface_port dout_3 dout_enable_3 enable   Output 1
    add_interface_port dout_3 dout_valid_3  valid    Output 1
    add_interface_port dout_3 dout_data_3   data     Output DOUT_DATA_WIDTH

    set_interface_property dout_3 associatedClock if_dout_clk
    set_interface_property dout_3 associatedReset none
  }

  if {[get_parameter_value NUM_OF_CHANNELS] > 4} {

    add_interface din_4 conduit end
    add_interface_port din_4  din_enable_4  enable   Input  1
    add_interface_port din_4  din_valid_4   valid    Input  1
    add_interface_port din_4  din_data_4    data     Input  DIN_DATA_WIDTH

    set_interface_property din_4 associatedClock if_din_clk
    set_interface_property din_4 associatedReset none

    add_interface dout_4 conduit end
    add_interface_port dout_4 dout_enable_4 enable   Output 1
    add_interface_port dout_4 dout_valid_4  valid    Output 1
    add_interface_port dout_4 dout_data_4   data     Output DOUT_DATA_WIDTH

    set_interface_property dout_4 associatedClock if_dout_clk
    set_interface_property dout_4 associatedReset none
  }

  if {[get_parameter_value NUM_OF_CHANNELS] > 5} {

    add_interface din_5 conduit end
    add_interface_port din_5  din_enable_5  enable   Input  1
    add_interface_port din_5  din_valid_5   valid    Input  1
    add_interface_port din_5  din_data_5    data     Input  DIN_DATA_WIDTH

    set_interface_property din_5 associatedClock if_din_clk
    set_interface_property din_5 associatedReset none

    add_interface dout_5 conduit end
    add_interface_port dout_5 dout_enable_5 enable   Output 1
    add_interface_port dout_5 dout_valid_5  valid    Output 1
    add_interface_port dout_5 dout_data_5   data     Output DOUT_DATA_WIDTH

    set_interface_property dout_5 associatedClock if_dout_clk
    set_interface_property dout_5 associatedReset none
  }

  if {[get_parameter_value NUM_OF_CHANNELS] > 6} {

    add_interface din_6 conduit end
    add_interface_port din_6  din_enable_6  enable   Input  1
    add_interface_port din_6  din_valid_6   valid    Input  1
    add_interface_port din_6  din_data_6    data     Input  DIN_DATA_WIDTH

    set_interface_property din_6 associatedClock if_din_clk
    set_interface_property din_6 associatedReset none

    add_interface dout_6 conduit end
    add_interface_port dout_6 dout_enable_6 enable   Output 1
    add_interface_port dout_6 dout_valid_6  valid    Output 1
    add_interface_port dout_6 dout_data_6   data     Output DOUT_DATA_WIDTH

    set_interface_property dout_6 associatedClock if_dout_clk
    set_interface_property dout_6 associatedReset none
  }

  if {[get_parameter_value NUM_OF_CHANNELS] > 7} {

    add_interface din_7 conduit end
    add_interface_port din_7  din_enable_7  enable   Input  1
    add_interface_port din_7  din_valid_7   valid    Input  1
    add_interface_port din_7  din_data_7    data     Input  DIN_DATA_WIDTH

    set_interface_property din_7 associatedClock if_din_clk
    set_interface_property din_7 associatedReset none

    add_interface dout_7 conduit end
    add_interface_port dout_7 dout_enable_7 enable   Output 1
    add_interface_port dout_7 dout_valid_7  valid    Output 1
    add_interface_port dout_7 dout_data_7   data     Output DOUT_DATA_WIDTH

    set_interface_property dout_7 associatedClock if_dout_clk
    set_interface_property dout_7 associatedReset none
  }

}

