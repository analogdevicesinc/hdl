
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create util_axis_fifo_asym
adi_ip_files util_axis_fifo_asym [list \
  "util_axis_fifo_asym.v" \
]

adi_ip_properties_lite util_axis_fifo_asym

set_property company_url {https://wiki.analog.com/resources/fpga/docs/util_axis_fifo_asym} [ipx::current_core]

adi_ip_add_core_dependencies [list \
	analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
	analog.com:$VIVADO_IP_LIBRARY:util_axis_fifo:1.0 \
]

adi_add_bus "s_axis" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"s_axis_valid" "TVALID"} \
		{"s_axis_ready" "TREADY"} \
		{"s_axis_data" "TDATA"} \
		{"s_axis_tlast" "TLAST"} \
	}

adi_add_bus "m_axis" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"m_axis_valid" "TVALID"} \
		{"m_axis_ready" "TREADY"} \
		{"m_axis_data" "TDATA"} \
		{"m_axis_tlast" "TLAST"} \
	}

adi_add_bus_clock "m_axis_aclk" "m_axis" "m_axis_aresetn"
adi_add_bus_clock "s_axis_aclk" "s_axis" "s_axis_aresetn"

## TODO: Validate RD_ADDRESS_WIDTH

ipx::save_core [ipx::current_core]
