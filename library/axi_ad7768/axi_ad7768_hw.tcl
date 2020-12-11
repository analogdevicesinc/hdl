
package require qsys
source ../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

set_module_property NAME axi_ad7768
set_module_property DESCRIPTION "AXI AD7768 interface and generic ADC"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME axi_ad7768

# source files

ad_ip_files axi_ad7768 [list \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/up_adc_channel.v" \
  "$ad_hdl_dir/library/common/up_adc_common.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_clock_mon.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/axi_generic_adc/axi_generic_adc.v" \
  "ad7768_if.v" \
  "axi_ad7768.v"]

# IP parameters

add_parameter ID INTEGER 0
set_parameter_property ID DEFAULT_VALUE 0
set_parameter_property ID DISPLAY_NAME "ID"
set_parameter_property ID UNITS None
set_parameter_property ID HDL_PARAMETER true

# AXI4 Memory Mapped Interface

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn 15

# ad7768_if and axi_gpreg ports

ad_interface signal adc_dovf            input  1 ovf

ad_interface signal clk_in              input  1
ad_interface signal ready_in            input  1
ad_interface signal data_in             input  8

ad_interface signal adc_sync           output  1 sync
ad_interface signal up_sshot            input  1
ad_interface signal up_format           input  2
ad_interface signal up_crc_enable       input  1
ad_interface signal up_crc_4_or_16_n    input  1
ad_interface signal up_status_clr       input  33
ad_interface signal up_status          output  33
ad_interface clock  adc_clk            output  1
ad_interface signal adc_valid          output  1  valid
ad_interface signal adc_data_p         output  32 data


set num_channels 8
set samples_per_channel 1
set sample_data_width 32
set channel_data_width [expr $sample_data_width * $samples_per_channel]

for {set n 0} {$n < $num_channels} {incr n} {
  add_interface adc_ch_$n conduit end

  add_interface_port adc_ch_$n adc_enable_$n enable Output 1
  set_port_property adc_enable_$n fragment_list [format "adc_enable(%d:%d)" $n $n]

  add_interface_port adc_ch_$n adc_valid_pp_$n valid Output 1
  set_port_property adc_valid_pp_$n fragment_list [format "adc_valid_pp(%d)" $n]

  add_interface_port adc_ch_$n adc_data_$n data Output $channel_data_width
  set_port_property adc_data_$n fragment_list [format "adc_data(%d:%d)" \
    [expr ($n+1) * $channel_data_width - 1] [expr $n * $channel_data_width]]

  set_interface_property adc_ch_$n associatedClock if_adc_clk

  set_interface_property adc_ch_$n associatedReset ""
}

