###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
package require qsys 14.0
package require quartus::device

source ../../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

ad_ip_create axi_pwm_gen {AXI PWM GEN}
ad_ip_files axi_pwm_gen [list \
  $ad_hdl_dir/library/util_cdc/sync_data.v \
  $ad_hdl_dir/library/util_cdc/sync_bits.v \
  $ad_hdl_dir/library/common/ad_rst.v \
  $ad_hdl_dir/library/common/up_axi.v \
  $ad_hdl_dir/library/intel/common/up_rst_constr.sdc \
  $ad_hdl_dir/library/util_cdc/util_cdc_constr.tcl \
  axi_pwm_gen_constr.sdc \
  axi_pwm_gen_regmap.sv \
  axi_pwm_gen_1.v \
  axi_pwm_gen.sv]

# parameters

ad_ip_parameter ID INTEGER 0
ad_ip_parameter ASYNC_CLK_EN INTEGER 1
ad_ip_parameter N_PWMS INTEGER 1
ad_ip_parameter PWM_EXT_SYNC INTEGER 0
ad_ip_parameter EXT_ASYNC_SYNC INTEGER 0
ad_ip_parameter PULSE_0_WIDTH INTEGER 7
ad_ip_parameter PULSE_1_WIDTH INTEGER 7
ad_ip_parameter PULSE_2_WIDTH INTEGER 7
ad_ip_parameter PULSE_3_WIDTH INTEGER 7
ad_ip_parameter PULSE_4_WIDTH INTEGER 7
ad_ip_parameter PULSE_5_WIDTH INTEGER 7
ad_ip_parameter PULSE_6_WIDTH INTEGER 7
ad_ip_parameter PULSE_7_WIDTH INTEGER 7
ad_ip_parameter PULSE_8_WIDTH INTEGER 7
ad_ip_parameter PULSE_9_WIDTH INTEGER 7
ad_ip_parameter PULSE_10_WIDTH INTEGER 7
ad_ip_parameter PULSE_11_WIDTH INTEGER 7
ad_ip_parameter PULSE_12_WIDTH INTEGER 7
ad_ip_parameter PULSE_13_WIDTH INTEGER 7
ad_ip_parameter PULSE_14_WIDTH INTEGER 7
ad_ip_parameter PULSE_15_WIDTH INTEGER 7
ad_ip_parameter PULSE_0_PERIOD INTEGER 10
ad_ip_parameter PULSE_1_PERIOD INTEGER 10
ad_ip_parameter PULSE_2_PERIOD INTEGER 10
ad_ip_parameter PULSE_3_PERIOD INTEGER 10
ad_ip_parameter PULSE_4_PERIOD INTEGER 10
ad_ip_parameter PULSE_5_PERIOD INTEGER 10
ad_ip_parameter PULSE_6_PERIOD INTEGER 10
ad_ip_parameter PULSE_7_PERIOD INTEGER 10
ad_ip_parameter PULSE_8_PERIOD INTEGER 10
ad_ip_parameter PULSE_9_PERIOD INTEGER 10
ad_ip_parameter PULSE_10_PERIOD INTEGER 10
ad_ip_parameter PULSE_11_PERIOD INTEGER 10
ad_ip_parameter PULSE_12_PERIOD INTEGER 10
ad_ip_parameter PULSE_13_PERIOD INTEGER 10
ad_ip_parameter PULSE_14_PERIOD INTEGER 10
ad_ip_parameter PULSE_15_PERIOD INTEGER 10
ad_ip_parameter PULSE_0_OFFSET INTEGER 0
ad_ip_parameter PULSE_1_OFFSET INTEGER 0
ad_ip_parameter PULSE_2_OFFSET INTEGER 0
ad_ip_parameter PULSE_3_OFFSET INTEGER 0
ad_ip_parameter PULSE_4_OFFSET INTEGER 0
ad_ip_parameter PULSE_5_OFFSET INTEGER 0
ad_ip_parameter PULSE_6_OFFSET INTEGER 0
ad_ip_parameter PULSE_7_OFFSET INTEGER 0
ad_ip_parameter PULSE_8_OFFSET INTEGER 0
ad_ip_parameter PULSE_9_OFFSET INTEGER 0
ad_ip_parameter PULSE_10_OFFSET INTEGER 0
ad_ip_parameter PULSE_11_OFFSET INTEGER 0
ad_ip_parameter PULSE_12_OFFSET INTEGER 0
ad_ip_parameter PULSE_13_OFFSET INTEGER 0
ad_ip_parameter PULSE_14_OFFSET INTEGER 0
ad_ip_parameter PULSE_15_OFFSET INTEGER 0

# interfaces

# axi
ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn 16

# external clock and external sync
ad_interface clock ext_clk input 1
ad_interface signal ext_sync input 1

# output signals
for {set i 0} {$i < 16} {incr i} {
  ad_interface signal pwm_$i output 1 if_pwm
}
