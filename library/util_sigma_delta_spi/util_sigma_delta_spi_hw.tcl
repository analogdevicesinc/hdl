###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
#################################################################################

# ip

package require qsys 14.0
source ../../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

ad_ip_create util_sigma_delta_spi {UTIL SIGMA DELTA SPI}
set_module_property ELABORATION_CALLBACK p_elaboration
ad_ip_files util_sigma_delta_spi [list \
  util_sigma_delta_spi.v]

# parameters

ad_ip_parameter IDLE_TIMEOUT INTEGER 63
ad_ip_parameter CS_PIN INTEGER 0
ad_ip_parameter NUM_OF_CS INTEGER 2

proc p_elaboration {} {

  set num_cs [get_parameter_value NUM_OF_CS]
# interfaces

# clock and reset interface

  ad_interface clock    clk    input 1
  ad_interface reset-n  resetn input 1 if_clk

  ad_interface signal data_ready output 1 if_pwm

  ad_interface clock s_sclk   input 1 sclk
  ad_interface signal s_sdo   input 1 sdo
  ad_interface signal s_sdo_t input 1 sdo_t
  ad_interface signal s_sdi   output 1 sdi
  ad_interface signal s_cs    input $num_cs cs

  ad_interface clock m_sclk   output 1
  ad_interface signal m_sdo   output 1
  ad_interface signal m_sdo_t output 1
  ad_interface signal m_sdi   input 1
  ad_interface signal m_cs    output $num_cs
}
