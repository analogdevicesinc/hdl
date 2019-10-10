# Select the device and mode you want the project synthesise for, by setting the
# ADI_DAC_DEVICE and ADI_DAC_MODE environment variables:
#
# make ADI_DAC_DEVICE=AD9172 ADI_DAC_MODE=04

# Default:
set device AD9172
set mode   04

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

#  1 - Single link
#  2 - Dual link
set num_links 1

# This reference design supports the following devices and modes:

# AD9135/AD9136
#                 Mode M L S F HD N NP
set params(AD9135,08) {1 4 2 1 1 16 16}
set params(AD9135,09) {1 2 1 1 1 16 16}
set params(AD9135,10) {1 1 1 2 0 16 16}
set params(AD9135,11) {2 8 2 1 1 16 16}
set params(AD9135,12) {2 4 1 1 1 16 16}
set params(AD9135,13) {2 2 1 2 0 16 16}
set params(AD9135,device_code) 0
#                 Mode M L S F HD N NP
set params(AD9136,08) {1 4 2 1 1 16 16}
set params(AD9136,09) {1 2 1 1 1 16 16}
set params(AD9136,10) {1 1 1 2 0 16 16}
set params(AD9136,11) {2 8 2 1 1 16 16}
set params(AD9136,12) {2 4 1 1 1 16 16}
set params(AD9136,13) {2 2 1 2 0 16 16}
set params(AD9136,device_code) 0

# AD9144/AD9154
#                 Mode M L S F HD N NP
set params(AD9144,00) {4 8 1 1 1 16 16}
set params(AD9144,01) {4 8 2 2 0 16 16}
set params(AD9144,02) {4 4 1 2 0 16 16}
set params(AD9144,03) {4 2 1 4 0 16 16}
set params(AD9144,04) {2 4 1 1 1 16 16}
set params(AD9144,05) {2 4 2 2 0 16 16}
set params(AD9144,06) {2 2 1 2 0 16 16}
set params(AD9144,07) {2 1 1 4 0 16 16}
set params(AD9144,09) {1 2 1 1 1 16 16}
set params(AD9144,10) {1 1 1 2 0 16 16}
set params(AD9144,device_code) 1
#                 Mode M L S F HD N NP
set params(AD9154,00) {4 8 1 1 1 16 16}
set params(AD9154,01) {4 8 2 2 0 16 16}
set params(AD9154,02) {4 4 1 2 0 16 16}
set params(AD9154,03) {4 2 1 4 0 16 16}
set params(AD9154,04) {2 4 1 1 1 16 16}
set params(AD9154,05) {2 4 2 2 0 16 16}
set params(AD9154,06) {2 2 1 2 0 16 16}
set params(AD9154,07) {2 1 1 4 0 16 16}
set params(AD9154,09) {1 2 1 1 1 16 16}
set params(AD9154,10) {1 1 1 2 0 16 16}
set params(AD9154,device_code) 1

# AD9152
#                 Mode M L S F HD N NP
set params(AD9152,04) {2 4 1 1 1 16 16}
set params(AD9152,05) {2 4 2 2 0 16 16}
set params(AD9152,06) {2 2 1 2 0 16 16}
set params(AD9152,07) {2 1 1 4 0 16 16}
set params(AD9152,09) {1 2 1 1 1 16 16}
set params(AD9152,10) {1 1 1 2 0 16 16}
set params(AD9152,device_code) 2

# AD9161/2/3/4
#                 Mode M L S F HD N NP
set params(AD9161,01) {2 1 1 4 1 16 16}
set params(AD9161,02) {2 2 2 2 1 16 16}
set params(AD9161,03) {2 3 3 4 1 16 16}
set params(AD9161,04) {2 4 1 1 1 16 16}
set params(AD9161,06) {2 6 3 2 1 16 16}
set params(AD9161,08) {2 8 2 2 1 16 16}
set params(AD9161,device_code) 3
#                 Mode M L S F HD N NP
set params(AD9162,01) {2 1 1 4 1 16 16}
set params(AD9162,02) {2 2 2 2 1 16 16}
set params(AD9162,03) {2 3 3 4 1 16 16}
set params(AD9162,04) {2 4 1 1 1 16 16}
set params(AD9162,06) {2 6 3 2 1 16 16}
set params(AD9162,08) {2 8 2 2 1 16 16}
set params(AD9162,device_code) 3
#                 Mode M L S F HD N NP
set params(AD9163,01) {2 1 1 4 1 16 16}
set params(AD9163,02) {2 2 2 2 1 16 16}
set params(AD9163,03) {2 3 3 4 1 16 16}
set params(AD9163,04) {2 4 1 1 1 16 16}
set params(AD9163,06) {2 6 3 2 1 16 16}
set params(AD9163,08) {2 8 2 2 1 16 16}
set params(AD9163,device_code) 3
#                 Mode M L S F HD N NP
set params(AD9164,01) {2 1 1 4 1 16 16}
set params(AD9164,02) {2 2 2 2 1 16 16}
set params(AD9164,03) {2 3 3 4 1 16 16}
set params(AD9164,04) {2 4 1 1 1 16 16}
set params(AD9164,06) {2 6 3 2 1 16 16}
set params(AD9164,08) {2 8 2 2 1 16 16}
set params(AD9164,device_code) 3

# AD9171
#                 Mode M L S F HD N NP
set params(AD9171,00) {2 1 1 4 1 16 16}
set params(AD9171,03) {2 2 1 2 1 16 16}
set params(AD9171,device_code) 4

# AD9172/AD9174/AD9176
#                 Mode M L S F HD N NP
set params(AD9172,00) {2 1 1 4 1 16 16}
set params(AD9172,01) {4 2 1 4 1 16 16}
set params(AD9172,02) {6 3 1 4 1 16 16}
set params(AD9172,03) {2 2 1 2 1 16 16}
set params(AD9172,04) {4 4 1 2 1 16 16}
set params(AD9172,08) {2 4 1 1 1 16 16}
set params(AD9172,09) {2 4 2 2 1 16 16}
set params(AD9172,10) {2 8 2 1 1 16 16}
set params(AD9172,11) {2 8 4 2 1 16 16}
set params(AD9172,18) {1 4 2 1 1 16 16}
set params(AD9172,19) {1 4 4 2 1 16 16}
set params(AD9172,20) {1 8 4 1 1 16 16}
set params(AD9172,21) {1 8 8 2 1 16 16}
set params(AD9172,device_code) 5

# AD9173/AD9175
#                 Mode M L S F HD N NP
set params(AD9173,00) {2 1 1 4 1 16 16}
set params(AD9173,01) {4 2 1 4 1 16 16}
set params(AD9173,02) {6 3 1 4 1 16 16}
set params(AD9173,03) {2 2 1 2 1 16 16}
set params(AD9173,04) {4 4 1 2 1 16 16}
set params(AD9173,08) {2 4 1 1 1 16 16}
set params(AD9173,09) {2 4 2 2 1 16 16}
set params(AD9173,13) {2 4 1 1 1 11 16}
set params(AD9173,14) {2 4 2 2 1 11 16}
set params(AD9173,15) {2 8 2 1 1 11 16}
set params(AD9173,16) {2 8 4 2 1 11 16}
set params(AD9173,device_code) 6

set device_code $params($device,device_code)

# Internal procedures
proc get_config_param {param} {
  upvar device device
  upvar mode mode
  upvar params params

  set jesd_params {M L S F HD N NP}
  set index [lsearch $jesd_params $param]

  return [lindex $params($device,$mode) $index]
}
