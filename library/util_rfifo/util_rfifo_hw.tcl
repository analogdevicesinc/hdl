###############################################################################
## Copyright (C) 2016-2023, 2026 Analog Devices, Inc. All rights reserved.
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
###############################################################################

package require qsys 14.0
source ../../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

ad_ip_create util_rfifo {Utils Read FIFO} util_rfifo_elab
ad_ip_files util_rfifo [list\
  $ad_hdl_dir/library/common/ad_mem.v \
  util_rfifo.v \
  util_rfifo_constr.sdc]

# parameters

ad_ip_parameter NUM_OF_CHANNELS INTEGER 4
ad_ip_parameter DIN_DATA_WIDTH INTEGER 32
ad_ip_parameter DOUT_DATA_WIDTH INTEGER 64
ad_ip_parameter DIN_ADDRESS_WIDTH INTEGER 8

# defaults

ad_interface clock din_clk input 1
ad_interface reset-n din_rstn input 1 if_din_clk
ad_interface clock dout_clk input 1
ad_interface reset dout_rst input 1 if_dout_clk

add_interface din_0 conduit end
add_interface_port din_0 din_enable_0 enable Output 1
add_interface_port din_0 din_valid_0 valid Output 1
add_interface_port din_0 din_valid_in_0 data_valid Input 1
add_interface_port din_0 din_data_0 data Input DIN_DATA_WIDTH
set_interface_property din_0 associatedClock if_din_clk
set_interface_property din_0 associatedReset none

add_interface dout_0 conduit end
add_interface_port dout_0 dout_enable_0 enable Input 1
add_interface_port dout_0 dout_valid_0 valid Input 1
add_interface_port dout_0 dout_valid_out_0 data_valid Output 1
add_interface_port dout_0 dout_data_0 data Output DOUT_DATA_WIDTH
set_interface_property dout_0 associatedClock if_dout_clk
set_interface_property dout_0 associatedReset none

ad_interface signal din_unf input 1 unf
ad_interface signal dout_unf output 1 unf

proc util_rfifo_elab {} {

  for {set n 1} {$n < 8} {incr n} {
    if {[get_parameter_value NUM_OF_CHANNELS] > $n} {
      add_interface din_${n} conduit end
      add_interface_port din_${n} din_enable_${n} enable Output 1
      add_interface_port din_${n} din_valid_${n} valid Output 1
      add_interface_port din_${n} din_valid_in_${n} data_valid Input 1
      add_interface_port din_${n} din_data_${n} data Input DIN_DATA_WIDTH
      set_interface_property din_${n} associatedClock if_din_clk
      set_interface_property din_${n} associatedReset none

      add_interface dout_${n} conduit end
      add_interface_port dout_${n} dout_enable_${n} enable Input 1
      add_interface_port dout_${n} dout_valid_${n} valid Input 1
      add_interface_port dout_${n} dout_valid_out_${n} data_valid Output 1
      add_interface_port dout_${n} dout_data_${n} data Output DOUT_DATA_WIDTH
      set_interface_property dout_${n} associatedClock if_dout_clk
      set_interface_property dout_${n} associatedReset none
    }
  }
}

