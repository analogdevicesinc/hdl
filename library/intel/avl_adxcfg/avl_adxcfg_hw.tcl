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

set_module_property NAME avl_adxcfg
set_module_property DESCRIPTION "Avalon ADXCFG Core"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME avl_adxcfg
set_module_property ELABORATION_CALLBACK elaborate

# files

add_fileset quartus_synth QUARTUS_SYNTH "" ""
set_fileset_property quartus_synth TOP_LEVEL avl_adxcfg
add_fileset_file avl_adxcfg.v VERILOG PATH avl_adxcfg.v TOP_LEVEL_FILE

# add exportable hdl parameter

add_parameter ADDRESS_WIDTH INTEGER 10
set_parameter_property ADDRESS_WIDTH AFFECTS_GENERATION false
set_parameter_property ADDRESS_WIDTH HDL_PARAMETER true

# reconfiguration interfaces

add_interface rcfg_clk  clock sink
add_interface_port rcfg_clk rcfg_clk clk Input 1

add_interface rcfg_reset_n reset end
set_interface_property rcfg_reset_n associatedClock rcfg_clk
add_interface_port rcfg_reset_n rcfg_reset_n reset_n Input 1

proc elaborate {} {
  for {set n 0} {$n < 2} {incr n} {

    add_interface rcfg_s${n} avalon slave
    add_interface rcfg_m${n} avalon master

    add_interface_port rcfg_s${n} rcfg_in_read_${n} read Input 1
    add_interface_port rcfg_s${n} rcfg_in_write_${n} write Input 1
    add_interface_port rcfg_s${n} rcfg_in_address_${n} address Input [get_parameter_value ADDRESS_WIDTH]
    add_interface_port rcfg_s${n} rcfg_in_writedata_${n} writedata Input 32
    add_interface_port rcfg_s${n} rcfg_in_readdata_${n} readdata Output 32
    add_interface_port rcfg_s${n} rcfg_in_waitrequest_${n} waitrequest Output 1
    add_interface_port rcfg_m${n} rcfg_out_read_${n} read Output 1
    add_interface_port rcfg_m${n} rcfg_out_write_${n} write Output 1
    add_interface_port rcfg_m${n} rcfg_out_address_${n} address Output [get_parameter_value ADDRESS_WIDTH]
    add_interface_port rcfg_m${n} rcfg_out_writedata_${n} writedata Output 32
    add_interface_port rcfg_m${n} rcfg_out_readdata_${n} readdata Input 32
    add_interface_port rcfg_m${n} rcfg_out_waitrequest_${n} waitrequest Input 1

    set_interface_property rcfg_s${n} associatedClock rcfg_clk
    set_interface_property rcfg_s${n} associatedReset rcfg_reset_n
    set_interface_property rcfg_s${n} addressUnits WORDS
    set_interface_property rcfg_s${n} burstCountUnits WORDS
    set_interface_property rcfg_s${n} explicitAddressSpan 0
    set_interface_property rcfg_m${n} associatedClock rcfg_clk
    set_interface_property rcfg_m${n} associatedReset rcfg_reset_n
    set_interface_property rcfg_m${n} addressUnits WORDS
    set_interface_property rcfg_m${n} burstCountUnits WORDS
  }
}

