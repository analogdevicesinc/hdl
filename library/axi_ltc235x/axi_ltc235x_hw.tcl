# ip

package require qsys 14.0
package require quartus::device

source ../../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

ad_ip_create axi_ltc235x {AXI LTC235x Interface}
set_module_property AUTHOR {Geronimo, John Erasmus Mari F.}
set_module_property VALIDATION_CALLBACK info_param_validate
ad_ip_files axi_ltc235x [list \
    $ad_hdl_dir/library/common/up_axi.v \
    $ad_hdl_dir/library/common/up_adc_common.v \
    $ad_hdl_dir/library/common/ad_rst.v \
    $ad_hdl_dir/library/common/up_xfer_cntrl.v \
    $ad_hdl_dir/library/common/up_xfer_status.v \
    $ad_hdl_dir/library/common/up_clock_mon.v \
    $ad_hdl_dir/library/common/up_adc_channel.v \
    $ad_hdl_dir/library/intel/common/up_xfer_cntrl_constr.sdc \
    $ad_hdl_dir/library/intel/common/up_rst_constr.sdc \
    $ad_hdl_dir/library/intel/common/up_xfer_status_constr.sdc \
    $ad_hdl_dir/library/intel/common/up_clock_mon_constr.sdc \
    axi_ltc235x_cmos.v \
    axi_ltc235x.v]
# add_documentation_link <title> <path>

# parameters

set ADC_LVDS_CMOS_N     0
set CHIP_SELECT_N       0
set ADC_LANE_0_ENABLE   1
set ADC_LANE_1_ENABLE   1
set ADC_LANE_2_ENABLE   1
set ADC_LANE_3_ENABLE   1
set ADC_LANE_4_ENABLE   1
set ADC_LANE_5_ENABLE   1
set ADC_LANE_6_ENABLE   1
set ADC_LANE_7_ENABLE   1
set ADC_NUM_CHANNELS    8
set ADC_DATA_WIDTH      18
set ADC_EXTERNAL_CLK    0

ad_ip_parameter ID INTEGER 0
ad_ip_parameter LVDS_CMOS_N INTEGER $ADC_LVDS_CMOS_N
ad_ip_parameter LANE_0_ENABLE INTEGER $ADC_LANE_0_ENABLE
ad_ip_parameter LANE_1_ENABLE INTEGER $ADC_LANE_1_ENABLE
ad_ip_parameter LANE_2_ENABLE INTEGER $ADC_LANE_2_ENABLE
ad_ip_parameter LANE_3_ENABLE INTEGER $ADC_LANE_3_ENABLE
ad_ip_parameter LANE_4_ENABLE INTEGER $ADC_LANE_4_ENABLE
ad_ip_parameter LANE_5_ENABLE INTEGER $ADC_LANE_5_ENABLE
ad_ip_parameter LANE_6_ENABLE INTEGER $ADC_LANE_6_ENABLE
ad_ip_parameter LANE_7_ENABLE INTEGER $ADC_LANE_7_ENABLE
ad_ip_parameter NUM_CHANNELS INTEGER $ADC_NUM_CHANNELS
ad_ip_parameter DATA_WIDTH INTEGER $ADC_DATA_WIDTH
ad_ip_parameter EXTERNAL_CLK INTEGER $ADC_EXTERNAL_CLK

adi_add_auto_fpga_spec_params

# interfaces

# physical interface
add_interface device_if conduit end
# common
add_interface_port device_if busy busy Input 1
add_interface_port device_if lvds_cmos_n lvds_cmos_n Output 1
add_interface_port device_if cs_n cs_n Output 1
add_interface_port device_if pd pd Output 1
# cmos
add_interface_port device_if scki scki Output 1
add_interface_port device_if scko scko Input 1
add_interface_port device_if sdi sdi Output 1
for {set i 0} {$i < $ADC_NUM_CHANNELS} {incr i} {
    add_interface_port device_if sdo_$i sdo_$i Input 1
}
# lvds
#add_interface_port device_if scki_p scki_p Output 1
#add_interface_port device_if scki_n scki_n Output 1
#add_interface_port device_if scko_p scko_p Input 1
#add_interface_port device_if scko_n scko_n Input 1
#add_interface_port device_if sdi_p sdi_p Output 1
#add_interface_port device_if sdi_n sdi_n Output 1
#add_interface_port device_if sdo_p sdo_p Input 1
#add_interface_port device_if sdo_n sdo_n Input 1

# clock
ad_interface clock external_clk input 1

# axi
ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn

# others
ad_interface signal adc_dovf Input 1 ovf

for {set i 0} {$i < $ADC_NUM_CHANNELS} {incr i} {
    add_interface adc_ch_$i conduit end
    add_interface_port adc_ch_$i adc_enable_$i enable Output 1
    add_interface_port adc_ch_$i adc_valid_$i valid Output 1
    add_interface_port adc_ch_$i adc_data_$i data Output 32
    
    set_interface_property adc_ch_$i associatedClock if_external_clk
    set_interface_property adc_ch_$i associatedReset ""
}
