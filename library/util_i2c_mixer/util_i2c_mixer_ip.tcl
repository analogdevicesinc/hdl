# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_i2c_mixer
adi_ip_files util_i2c_mixer [list \
  "util_i2c_mixer.vhd" ]

adi_ip_properties_lite util_i2c_mixer


adi_add_bus "upstream" "slave" \
	"xilinx.com:interface:iic_rtl:1.0" \
	"xilinx.com:interface:iic:1.0" \
	[list \
		{"upstream_scl_I" "SCL_O"} \
		{"upstream_scl_O" "SCL_I"} \
		{"upstream_scl_T" "SCL_T"} \
		{"upstream_sda_I" "SDA_O"} \
		{"upstream_sda_O" "SDA_I"} \
		{"upstream_sda_T" "SDA_T"} \
	 ]

ipx::save_core [ipx::current_core]
