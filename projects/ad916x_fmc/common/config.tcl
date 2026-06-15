###############################################################################
## Copyright (C) 2019-2026 Analog Devices, Inc. All rights reserved.
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

# Select the device and mode you want the project synthesise for, by setting the
# ADI_DAC_DEVICE, ADI_DAC_MODE or ADI_LANE_RATE environment variables:
#
# make ADI_LANE_RATE=4.16 ADI_DAC_DEVICE=AD9163 ADI_DAC_MODE=08
# 
# Or just run make without any parameters (will build for AD9162, Mode 08,
# 12.5 GHz)

# Default:
set device AD9162
set mode   08

if [info exists ::env(ADI_DAC_DEVICE)] {
  set device $::env(ADI_DAC_DEVICE)
} else {
  set env(ADI_DAC_DEVICE) $device
}

if [info exists ::env(ADI_DAC_MODE)] {
  set mode $::env(ADI_DAC_MODE)
} else {
  set env(ADI_DAC_MODE) $mode
}

# single link only
set num_links 1

# This reference design supports the following devices and modes:

# AD9161
#                 Mode M L S F HD N NP
set params(AD9161,01) {2 1 1 4 1 16 16}
set params(AD9161,02) {2 2 2 2 1 16 16}
set params(AD9161,03) {2 3 3 4 1 16 16}
set params(AD9161,04) {2 4 1 1 1 16 16}
set params(AD9161,06) {2 6 3 2 1 16 16}
set params(AD9161,08) {2 8 2 1 1 16 16}

# AD9162
#                 Mode M L S F HD N NP
set params(AD9162,01) {2 1 1 4 1 16 16}
set params(AD9162,02) {2 2 2 2 1 16 16}
set params(AD9162,03) {2 3 3 4 1 16 16}
set params(AD9162,04) {2 4 1 1 1 16 16}
set params(AD9162,06) {2 6 3 2 1 16 16}
set params(AD9162,08) {2 8 2 1 1 16 16}

# AD9163
#                 Mode M L S F HD N NP
set params(AD9163,01) {2 1 1 4 1 16 16}
set params(AD9163,02) {2 2 1 2 1 16 16}
set params(AD9163,03) {2 3 3 4 1 16 16}
set params(AD9163,04) {2 4 1 1 1 16 16}
set params(AD9163,06) {2 6 3 2 1 16 16}
set params(AD9163,08) {2 8 2 1 1 16 16}

# AD9164
#                 Mode M L S F HD N NP
set params(AD9164,01) {2 1 1 4 1 16 16}
set params(AD9164,02) {2 2 2 2 1 16 16}
set params(AD9164,03) {2 3 3 4 1 16 16}
set params(AD9164,04) {2 4 1 1 1 16 16}
set params(AD9164,06) {2 6 3 2 1 16 16}
set params(AD9164,08) {2 8 2 1 1 16 16}

# Internal procedures
proc get_config_param {param} {
  upvar device device
  upvar mode mode
  upvar params params

  set jesd_params {M L S F HD N NP}

  if {[info exists ::env($param)]} {
    return $::env($param)
  } else {
    set index [lsearch $jesd_params $param]
    return [lindex $params($device,$mode) $index]
  }
}
