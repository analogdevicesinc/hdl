
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create cn0363_phase_data_sync
adi_ip_files cn0363_phase_data_sync [list \
	"cn0363_phase_data_sync.v"
]

adi_ip_properties_lite cn0363_phase_data_sync

adi_add_bus "S_AXIS_SAMPLE" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"s_axis_sample_valid" "TVALID"} \
		{"s_axis_sample_ready" "TREADY"} \
		{"s_axis_sample_data" "TDATA"} \
	}

adi_add_bus "M_AXIS_SAMPLE" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"m_axis_sample_valid" "TVALID"} \
		{"m_axis_sample_ready" "TREADY"} \
		{"m_axis_sample_data" "TDATA"} \
	}

adi_add_bus "M_AXIS_PHASE" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"m_axis_phase_valid" "TVALID"} \
		{"m_axis_phase_ready" "TREADY"} \
		{"m_axis_phase_data" "TDATA"} \
	}

adi_add_bus_clock "clk" "S_AXIS_SAMPLE:M_AXIS_SAMPLE:M_AXIS_PHASE" "resetn"

ipx::save_core [ipx::current_core]
