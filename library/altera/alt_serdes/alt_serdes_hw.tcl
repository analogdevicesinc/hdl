
package require -exact qsys 13.0
source ../../scripts/adi_env.tcl
source ../../scripts/adi_ip_alt.tcl

set_module_property NAME util_serdes_clk
set_module_property DESCRIPTION "A simple Altera IOPLL macro instance"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME util_serdes_clk
set_module_property ELABORATION_CALLBACK p_util_serdes_clk

add_fileset quartus_synth QUARTUS_SYNTH "" ""
set_fileset_property quartus_synth TOP_LEVEL ad_serdes_clk
add_fileset_file  ad_serdes_clk.v  VERILOG PATH  $ad_hdl_dir/library/altera/common/ad_serdes_clk.v TOP_LEVEL_FILE

add_parameter DEVICE_FAMILY STRING
set_parameter_property DEVICE_FAMILY SYSTEM_INFO {DEVICE_FAMILY}
set_parameter_property DEVICE_FAMILY AFFECTS_GENERATION true
set_parameter_property DEVICE_FAMILY HDL_PARAMETER false
set_parameter_property DEVICE_FAMILY ENABLED false

add_parameter MODE STRING 0
set_parameter_property MODE DEFAULT_VALUE "TX"
set_parameter_property MODE DISPLAY_NAME MODE
set_parameter_property MODE TYPE STRING
set_parameter_property MODE UNITS None
set_parameter_property MODE HDL_PARAMETER true

add_hdl_instance alt_clk altera_iopll
set_instance_parameter_value alt_clk {gui_reference_clock_frequency} {500.0}
set_instance_parameter_value alt_clk {gui_use_locked} {1}
set_instance_parameter_value alt_clk {gui_operation_mode} {lvds}
set_instance_parameter_value alt_clk {gui_en_lvds_ports} {true}
set_instance_parameter_value alt_clk {gui_number_of_clocks} {4}
set_instance_parameter_value alt_clk {gui_output_clock_frequency0} {1200.0}
set_instance_parameter_value alt_clk {gui_ps_units0} {degrees}
set_instance_parameter_value alt_clk {gui_phase_shift_deg0} {180.0}
set_instance_parameter_value alt_clk {gui_duty_cycle0} {50.0}
set_instance_parameter_value alt_clk {gui_output_clock_frequency1} {150.0}
set_instance_parameter_value alt_clk {gui_ps_units1} {degrees}
set_instance_parameter_value alt_clk {gui_phase_shift_deg1} {315.0}
set_instance_parameter_value alt_clk {gui_duty_cycle1} {12.5}
set_instance_parameter_value alt_clk {gui_output_clock_frequency2} {150.0}
set_instance_parameter_value alt_clk {gui_ps_units2} {degrees}
set_instance_parameter_value alt_clk {gui_phase_shift_deg2} {22.5}
set_instance_parameter_value alt_clk {gui_duty_cycle2} {50.0}
set_instance_parameter_value alt_clk {gui_output_clock_frequency3} {600.0}
set_instance_parameter_value alt_clk {gui_ps_units3} {degrees}
set_instance_parameter_value alt_clk {gui_phase_shift_deg3} {90}
set_instance_parameter_value alt_clk {gui_duty_cycle3} {50.0}
set_instance_parameter_value alt_clk {system_info_device_family} DEVICE_FAMILY
set_instance_parameter_value alt_clk {gui_en_reconf} {true}

# input clock and reset

ad_alt_intf clock clk Output 1
ad_alt_intf clock div_clk Output 1
ad_alt_intf clock loaden Output 1

add_interface serdes_clk clock end
add_interface_port serdes_clk clk_in_p clk Input 1

add_interface serdes_rst reset end
set_interface_property serdes_rst associatedClock serdes_clk
add_interface_port serdes_rst mmcm_rst reset Input 1

# updates

proc p_util_serdes_clk {} {

  set serdes_clk_mode [get_parameter_value MODE]

  if {$serdes_clk_mode eq "TX"} {
    set_instance_parameter_value alt_clk {gui_en_phout_ports} {false}
  } elseif {$serdes_clk_mode eq "RX"} {
    set_instance_parameter_value alt_clk {gui_en_phout_ports} {true}
    ad_alt_intf signal phase   Output 8
  } else {
    set_instance_parameter_value alt_clk {gui_en_phout_ports} {false}
  }

}


package require -exact qsys 13.0
source ../../scripts/adi_env.tcl
source ../../scripts/adi_ip_alt.tcl

set_module_property NAME util_serdes_in
set_module_property DESCRIPTION "A simple Altera LVDS Serdes macro instance in rx mode"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME util_serdes_in

add_fileset quartus_synth QUARTUS_SYNTH "" ""
set_fileset_property quartus_synth TOP_LEVEL ad_serdes_in
add_fileset_file  ad_serdes_in.v  VERILOG PATH  $ad_hdl_dir/library/altera/common/ad_serdes_in.v TOP_LEVEL_FILE

add_parameter DEVICE_FAMILY STRING
set_parameter_property DEVICE_FAMILY SYSTEM_INFO {DEVICE_FAMILY}
set_parameter_property DEVICE_FAMILY AFFECTS_GENERATION true
set_parameter_property DEVICE_FAMILY HDL_PARAMETER false
set_parameter_property DEVICE_FAMILY ENABLED false

add_parameter DATA_WIDTH STRING
set_parameter_property DATA_WIDTH DEFAULT_VALUE 16
set_parameter_property DATA_WIDTH DISPLAY_NAME DATA_WIDTH
set_parameter_property DATA_WIDTH TYPE INTEGER
set_parameter_property DATA_WIDTH UNITS None
set_parameter_property DATA_WIDTH HDL_PARAMETER true

add_hdl_instance alt_serdes_in altera_lvds
set_instance_parameter_value alt_serdes_in {DATA_RATE} {600.0}
set_instance_parameter_value alt_serdes_in {MODE} {dpa_mode_fifo}
set_instance_parameter_value alt_serdes_in {NUM_CHANNELS} {1}
set_instance_parameter_value alt_serdes_in {J_FACTOR} {8}
set_instance_parameter_value alt_serdes_in {INCLOCK_FREQUENCY} {100}
set_instance_parameter_value alt_serdes_in {PLL_USE_RESET} {false}
set_instance_parameter_value alt_serdes_in {TX_EXPORT_CORECLOCK} {false}
set_instance_parameter_value alt_serdes_in {TX_USE_OUTCLOCK} {false}
set_instance_parameter_value alt_serdes_in {USE_EXTERNAL_PLL} {true}
set_instance_parameter_value alt_serdes_in {SYS_INFO_DEVICE_FAMILY} DEVICE_FAMILY

# input clock and reset

add_interface fast_clk clock end
add_interface_port fast_clk clk clk Input 1
set_interface_property fast_clk associatedReset serdes_rst

add_interface serdes_rst reset end
add_interface_port serdes_rst rst reset Input 1
set_interface_property serdes_rst associatedClock fast_clk

add_interface div_clk clock end
add_interface_port div_clk div_clk clk Input 1
set_interface_property div_clk associatedReset none

add_interface loaden clock end
add_interface_port loaden loaden clk Input 1
set_interface_property loaden associatedReset none

add_interface parallel_data   conduit end
add_interface_port parallel_data  data_s0 data0 output DATA_WIDTH
add_interface_port parallel_data  data_s1 data1 output DATA_WIDTH
add_interface_port parallel_data  data_s2 data2 output DATA_WIDTH
add_interface_port parallel_data  data_s3 data3 output DATA_WIDTH
add_interface_port parallel_data  data_s4 data4 output DATA_WIDTH
add_interface_port parallel_data  data_s5 data5 output DATA_WIDTH
add_interface_port parallel_data  data_s6 data6 output DATA_WIDTH
add_interface_port parallel_data  data_s7 data7 output DATA_WIDTH

set_interface_property parallel_data associatedClock div_clk
set_interface_property parallel_data associatedReset none

add_interface serial_data   conduit end
add_interface_port serial_data  data_out_p data_p output 1
add_interface_port serial_data  data_out_n data_n output 1

package require -exact qsys 13.0
source ../../scripts/adi_env.tcl
source ../../scripts/adi_ip_alt.tcl

set_module_property NAME util_serdes_out
set_module_property DESCRIPTION "A simple Altera LVDS Serdes macro instance in tx mode"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME util_serdes_out

add_fileset quartus_synth QUARTUS_SYNTH "" ""
set_fileset_property quartus_synth TOP_LEVEL ad_serdes_out
add_fileset_file  ad_serdes_out.v  VERILOG PATH  $ad_hdl_dir/library/altera/common/ad_serdes_out.v TOP_LEVEL_FILE

add_parameter DEVICE_FAMILY STRING
set_parameter_property DEVICE_FAMILY SYSTEM_INFO {DEVICE_FAMILY}
set_parameter_property DEVICE_FAMILY AFFECTS_GENERATION true
set_parameter_property DEVICE_FAMILY HDL_PARAMETER false
set_parameter_property DEVICE_FAMILY ENABLED false

add_parameter DATA_WIDTH STRING
set_parameter_property DATA_WIDTH DEFAULT_VALUE 16
set_parameter_property DATA_WIDTH DISPLAY_NAME DATA_WIDTH
set_parameter_property DATA_WIDTH TYPE INTEGER
set_parameter_property DATA_WIDTH UNITS None
set_parameter_property DATA_WIDTH HDL_PARAMETER true

add_parameter DEVICE_TYPE STRING
set_parameter_property DEVICE_TYPE DEFAULT_VALUE 0
set_parameter_property DEVICE_TYPE DISPLAY_NAME DEVICE_TYPE
set_parameter_property DEVICE_TYPE TYPE INTEGER
set_parameter_property DEVICE_TYPE UNITS None
set_parameter_property DEVICE_TYPE HDL_PARAMETER true

add_hdl_instance alt_serdes_out altera_lvds
set_instance_parameter_value alt_serdes_out {DATA_RATE} {600.0}
set_instance_parameter_value alt_serdes_out {MODE} {TX}
set_instance_parameter_value alt_serdes_out {NUM_CHANNELS} {1}
set_instance_parameter_value alt_serdes_out {J_FACTOR} {8}
set_instance_parameter_value alt_serdes_out {INCLOCK_FREQUENCY} {100}
set_instance_parameter_value alt_serdes_out {PLL_USE_RESET} {false}
set_instance_parameter_value alt_serdes_out {TX_EXPORT_CORECLOCK} {false}
set_instance_parameter_value alt_serdes_out {TX_USE_OUTCLOCK} {false}
set_instance_parameter_value alt_serdes_out {USE_EXTERNAL_PLL} {true}
set_instance_parameter_value alt_serdes_out {SYS_INFO_DEVICE_FAMILY} DEVICE_FAMILY

# input clock and reset

ad_alt_intf clock clk Input 1
ad_alt_intf clock div_clk Input 1
ad_alt_intf clock loaden Input 1
ad_alt_intf reset rst Input 1

add_interface parallel_data   conduit end
add_interface_port parallel_data  data_s0 data0 input DATA_WIDTH
add_interface_port parallel_data  data_s1 data1 input DATA_WIDTH
add_interface_port parallel_data  data_s2 data2 input DATA_WIDTH
add_interface_port parallel_data  data_s3 data3 input DATA_WIDTH
add_interface_port parallel_data  data_s4 data4 input DATA_WIDTH
add_interface_port parallel_data  data_s5 data5 input DATA_WIDTH
add_interface_port parallel_data  data_s6 data6 input DATA_WIDTH
add_interface_port parallel_data  data_s7 data7 input DATA_WIDTH

set_interface_property parallel_data associatedClock div_clk
set_interface_property parallel_data associatedReset none

add_interface serial_data   conduit end
add_interface_port serial_data  data_out_p data_p output 1
add_interface_port serial_data  data_out_n data_n output 1

