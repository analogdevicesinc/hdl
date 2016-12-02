
# environment related stuff

set ad_hdl_dir [file normalize [file join [file dirname [info script]] "../.."]]
set ad_phdl_dir $ad_hdl_dir


if [info exists ::env(ADI_HDL_DIR)] {
  set ad_hdl_dir $::env(ADI_HDL_DIR)
}

if [info exists ::env(ADI_PHDL_DIR)] {
  set ad_phdl_dir $::env(ADI_PHDL_DIR)
}

