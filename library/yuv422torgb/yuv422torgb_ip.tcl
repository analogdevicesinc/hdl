#ip

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create yuv422torgb
adi_ip_files yuv422torgb [list \
  "$ad_hdl_dir/library/common/ad_csc.v" \
  "yuv422torgb.v" \
  "yuv422torgb_upscale.v" \
  "yuv422torgb_conversion.v" ]

adi_ip_properties_lite yuv422torgb

set_property company_url {https://wiki.analog.com/resources/fpga/docs/yuv422torgb} [ipx::current_core]

ipx::infer_bus_interface video_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

adi_add_bus "video_in" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"video_in_valid" "TVALID"} \
		{"video_in_ready" "TREADY"} \
		{"video_in_data" "TDATA"} \
	}

adi_add_bus "video_out" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"video_out_valid" "TVALID"} \
		{"video_out_ready" "TREADY"} \
		{"video_out_data" "TDATA"} \
	}

ipx::infer_bus_interface video_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

ipx::associate_bus_interfaces -busif video_in -clock video_clk [ipx::current_core]
ipx::associate_bus_interfaces -busif video_out -clock video_clk [ipx::current_core]

ipx::save_core [ipx::current_core]

