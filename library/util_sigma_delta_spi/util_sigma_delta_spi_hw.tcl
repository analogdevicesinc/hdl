###############################################################################
## Copyright (C) 2024-2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
