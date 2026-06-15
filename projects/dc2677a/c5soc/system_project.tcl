###############################################################################
## Copyright (C) 2023, 2026 Analog Devices, Inc. All rights reserved.
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

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_intel.tcl

set LVDS_CMOS_N [get_env_param LVDS_CMOS_N 0]
  # 0 - CMOS
  # 1 - LVDS
set LTC235X_FAMILY [get_env_param LTC235X_FAMILY 0]
  # 0 = 2358-18
  # 1 = 2358-16
  # 2 = 2357-18
  # 3 = 2357-16
  # 4 = 2353-18
  # 5 = 2353-16

adi_project dc2677a_c5soc [list \
  LVDS_CMOS_N $LVDS_CMOS_N \
  LTC235X_FAMILY $LTC235X_FAMILY \
]

source $ad_hdl_dir/projects/common/c5soc/c5soc_system_assign.tcl

set_global_assignment -name VERILOG_FILE -remove system_top.v

# ltc235x interface

set_location_assignment PIN_K12 -to lvds_cmos_n ; # lvds_cmos_n 54 lvds_rxp1
set_location_assignment PIN_G12 -to cnv         ; # cnv 48 lvds_rxp0
set_location_assignment PIN_F9 -to busy         ; # busy 90 lvds_rxp7
set_location_assignment PIN_F8 -to cs_n         ; # cs_n 92 lvds_rxn7
set_location_assignment PIN_G11 -to pd          ; # pd 50 lvds_rxn0

if {$LVDS_CMOS_N == 1} {
  # lvds

  set_global_assignment -name TOP_LEVEL_ENTITY system_top_lvds
  if {[info exists ::env(ADI_PROJECT_DIR)]} {
    set_global_assignment -name VERILOG_FILE ../system_top_lvds.v
  } else {
    set_global_assignment -name VERILOG_FILE system_top_lvds.v
  }

  set_instance_assignment -name IO_STANDARD "2.5V" -to lvds_cmos_n
  set_instance_assignment -name IO_STANDARD "2.5V" -to cnv
  set_instance_assignment -name IO_STANDARD "2.5V" -to busy
  set_instance_assignment -name IO_STANDARD "2.5V" -to cs_n
  set_instance_assignment -name IO_STANDARD "2.5V" -to pd

  set_location_assignment PIN_G10 -to sdi_p         ; # sdo_1 60 lvds_rxp2 / sdi_p
  set_location_assignment PIN_F10 -to "sdi_p(n)"    ; # sdo_2 62 lvds_rxn2 / sdi_n
  set_location_assignment PIN_J10 -to scki_p        ; # sdo_3 66 lvds_rxp3 / scki_p
  set_location_assignment PIN_J9 -to "scki_p(n)"    ; # scki 68 lvds_rxn3 / scki_n
  set_location_assignment PIN_K7 -to scko_p         ; # scko 72 lvds_rxp4 / scko_p
  set_location_assignment PIN_K8 -to "scko_p(n)"    ; # sdo_4 74 lvds_rxn4 / scko_n
  set_location_assignment PIN_J7 -to sdo_p          ; # sdo_5 78 lvds_rxp5 / sdo_p
  set_location_assignment PIN_H7 -to "sdo_p(n)"     ; # sdo_6 80 lvds_rxn5 / sdo_n

  set_instance_assignment -name IO_STANDARD "mini-LVDS_E_1R" -to sdi_p
  set_instance_assignment -name IO_STANDARD "mini-LVDS_E_1R" -to scki_p
  set_instance_assignment -name IO_STANDARD "LVDS" -to scko_p
  set_instance_assignment -name IO_STANDARD "LVDS" -to sdo_p

  set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to scko_p
  set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to sdo_p
} else {
  # cmos

  set_global_assignment -name TOP_LEVEL_ENTITY system_top_cmos
  if {[info exists ::env(ADI_PROJECT_DIR)]} {
    set_global_assignment -name VERILOG_FILE ../system_top_cmos.v
  } else {
    set_global_assignment -name VERILOG_FILE system_top_cmos.v
  }

  set_instance_assignment -name IO_STANDARD "3.3V LVCMOS" -to lvds_cmos_n
  set_instance_assignment -name IO_STANDARD "3.3V LVCMOS" -to cnv
  set_instance_assignment -name IO_STANDARD "3.3V LVCMOS" -to busy
  set_instance_assignment -name IO_STANDARD "3.3V LVCMOS" -to cs_n
  set_instance_assignment -name IO_STANDARD "3.3V LVCMOS" -to pd

  set_location_assignment PIN_G8 -to sdi      ; # sdi 86 lvds_rxn6
  set_location_assignment PIN_J9 -to scki     ; # scki 68 lvds_rxn3 / scki_n
  set_location_assignment PIN_K7 -to scko     ; # scko 72 lvds_rxp4 / scko_p

  set_instance_assignment -name IO_STANDARD "3.3V LVCMOS" -to sdi
  set_instance_assignment -name IO_STANDARD "3.3V LVCMOS" -to scki
  set_instance_assignment -name IO_STANDARD "3.3V LVCMOS" -to scko

  if {$LTC235X_FAMILY <= 1} {
    # 2358
    set_location_assignment PIN_J12 -to sdo[0]  ; # sdo_0 56 lvds_rxn1
    set_location_assignment PIN_G10 -to sdo[1]  ; # sdo_1 60 lvds_rxp2 / sdi_p
    set_location_assignment PIN_F10 -to sdo[2]  ; # sdo_2 62 lvds_rxn2 / sdi_n
    set_location_assignment PIN_J10 -to sdo[3]  ; # sdo_3 66 lvds_rxp3 / scki_p
    set_location_assignment PIN_K8 -to sdo[4]   ; # sdo_4 74 lvds_rxn4 / scko_n
    set_location_assignment PIN_J7 -to sdo[5]   ; # sdo_5 78 lvds_rxp5 / sdo_p
    set_location_assignment PIN_H7 -to sdo[6]   ; # sdo_6 80 lvds_rxn5 / sdo_n
    set_location_assignment PIN_H8 -to sdo[7]   ; # sdo_7 84 lvds_rxp6
  } elseif {$LTC235X_FAMILY <= 3} {
    # 2357
    set_location_assignment PIN_F10 -to sdo[0]  ; # sdo_1 62 lvds_rxn2 / sdi_n
    set_location_assignment PIN_J10 -to sdo[1]  ; # sdo_2 66 lvds_rxp3 / scki_p
    set_location_assignment PIN_K8 -to sdo[2]   ; # sdo_3 74 lvds_rxn4 / scko_n
    set_location_assignment PIN_J7 -to sdo[3]   ; # sdo_4 78 lvds_rxp5 / sdo_p
  } else {
    # 2353
    set_location_assignment PIN_J10 -to sdo[0]  ; # sdo_0 66 lvds_rxp3 / scki_p
    set_location_assignment PIN_K8 -to sdo[1]   ; # sdo_1 74 lvds_rxn4 / scko_n
  }

  set_instance_assignment -name IO_STANDARD "3.3V LVCMOS" -to sdo[0]
  set_instance_assignment -name IO_STANDARD "3.3V LVCMOS" -to sdo[1]
  set_instance_assignment -name IO_STANDARD "3.3V LVCMOS" -to sdo[2]
  set_instance_assignment -name IO_STANDARD "3.3V LVCMOS" -to sdo[3]
  set_instance_assignment -name IO_STANDARD "3.3V LVCMOS" -to sdo[4]
  set_instance_assignment -name IO_STANDARD "3.3V LVCMOS" -to sdo[5]
  set_instance_assignment -name IO_STANDARD "3.3V LVCMOS" -to sdo[6]
  set_instance_assignment -name IO_STANDARD "3.3V LVCMOS" -to sdo[7]
}

execute_flow -compile
