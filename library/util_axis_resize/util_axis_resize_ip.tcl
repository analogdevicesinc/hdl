
source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_axis_resize
adi_ip_files util_axis_resize [list \
  "util_axis_resize.v" ]

adi_ip_properties_lite util_axis_resize

adi_add_bus "s_axis" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"s_valid" "TVALID"} \
		{"s_ready" "TREADY"} \
		{"s_data" "TDATA"} \
	}

adi_add_bus "m_axis" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"m_valid" "TVALID"} \
		{"m_ready" "TREADY"} \
		{"m_data" "TDATA"} \
	}

adi_add_bus_clock "clk" "s_axis:m_axis" "resetn"

ipx::save_core [ipx::current_core]
