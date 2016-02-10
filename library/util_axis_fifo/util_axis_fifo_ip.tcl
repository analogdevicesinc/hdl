
source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_axis_fifo
adi_ip_files util_axis_fifo [list \
	"$ad_hdl_dir/library/common/sync_bits.v" \
	"$ad_hdl_dir/library/common/sync_gray.v" \
	"address_gray.v" \
	"address_gray_pipelined.v" \
	"address_sync.v" \
	"util_axis_fifo.v" \
]

adi_ip_properties_lite util_axis_fifo

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

adi_add_bus_clock "m_axis_aclk" "M_AXIS" "m_axis_aresetn"
adi_add_bus_clock "s_axis_aclk" "S_AXIS" "m_axis_aresetn"

ipx::save_core [ipx::current_core]
