
# environment related stuff

set ad_hdl_dir [file normalize [file join [file dirname [info script]] "../.."]]
set ad_ghdl_dir $ad_hdl_dir


if [info exists ::env(ADI_HDL_DIR)] {
  set ad_hdl_dir [file normalize $::env(ADI_HDL_DIR)]
}

if [info exists ::env(ADI_GHDL_DIR)] {
  set ad_ghdl_dir [file normalize $::env(ADI_GHDL_DIR)]
}

