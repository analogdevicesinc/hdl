
source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create cordic_demod
adi_ip_files cordic_demod [list \
	"cordic_demod.v" \
]

adi_ip_properties_lite cordic_demod

adi_add_bus "S_AXIS" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"s_axis_valid" "TVALID"} \
		{"s_axis_ready" "TREADY"} \
		{"s_axis_data" "TDATA"} \
	}

adi_add_bus "M_AXIS" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"m_axis_valid" "TVALID"} \
		{"m_axis_ready" "TREADY"} \
		{"m_axis_data" "TDATA"} \
	}

adi_add_bus_clock "clk" "S_AXIS:M_AXIS" "resetn"

ipx::save_core [ipx::current_core]
