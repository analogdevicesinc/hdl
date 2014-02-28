# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_i2c_mixer
adi_ip_files util_i2c_mixer [list \
  "util_i2c_mixer.vhd" ]

adi_ip_properties_lite util_i2c_mixer

ipx::save_core [ipx::current_core]

