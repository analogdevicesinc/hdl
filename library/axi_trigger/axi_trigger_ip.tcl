# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_trigger
 create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name my_ila
    set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] [get_ips my_ila]
    set_property -dict [list CONFIG.C_NUM_OF_PROBES {4}] [get_ips my_ila]
    set_property -dict [list CONFIG.C_DATA_DEPTH {4096}] [get_ips my_ila]
    set_property -dict [list CONFIG.C_TRIGIN_EN {false}] [get_ips my_ila]
    set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] [get_ips my_ila]
    set_property -dict [list CONFIG.C_PROBE1_WIDTH {1}] [get_ips my_ila]
    set_property -dict [list CONFIG.C_PROBE2_WIDTH {16}] [get_ips my_ila]
    set_property -dict [list CONFIG.C_PROBE3_WIDTH {16}] [get_ips my_ila]
    generate_target {all} [get_files axi_trigger.srcs/sources_1/ip/my_ila/my_ila.xci]

adi_ip_files axi_trigger [list \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "axi_trigger.v" \
  "channel_trigger.v" \
  "adc_trigger.v" \
  "digital_trigger.v" \
  "trigger_ip_regmap.v" ]

adi_ip_properties axi_trigger

ipx::infer_bus_interface clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface rst xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]

ipx::save_core [ipx::current_core]
