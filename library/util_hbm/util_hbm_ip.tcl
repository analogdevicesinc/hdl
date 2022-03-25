source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create util_hbm
adi_ip_files util_hbm [list \
  "util_hbm_constr.xdc" \
  "util_hbm_ooc.ttcl" \
  "util_hbm.v" \
  "bd/bd.tcl" \
]

adi_ip_properties_lite util_hbm
adi_ip_ttcl util_dacfifo "util_hbm_ooc.ttcl"
adi_ip_bd util_hbm "bd/bd.tcl"

set_property PROCESSING_ORDER LATE [ipx::get_files util_hbm_constr.xdc \
  -of_objects [ipx::get_file_groups -of_objects [ipx::current_core] \
  -filter {NAME =~ *synthesis*}]]

adi_ip_add_core_dependencies { \
  analog.com:user:util_cdc:1.0 \
  analog.com:user:axi_dmac:1.0 \
}

set_property display_name "ADI FIFO to HBM AXI3 bridge" [ipx::current_core]
set_property description "Bridge between a FIFO READ/WRITE interface and an AXI4 Memory Mapped interface" [ipx::current_core]

set max_axi_ifc 16
set cc [ipx::current_core]

adi_add_bus "s_axis" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	[list {"s_axis_ready" "TREADY"} \
	  {"s_axis_valid" "TVALID"} \
	  {"s_axis_data" "TDATA"} \
	  {"s_axis_strb" "TSTRB"} \
	  {"s_axis_keep" "TKEEP"} \
	  {"s_axis_user" "TUSER"} \
	  {"s_axis_last" "TLAST"}]

adi_add_bus "m_axis" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	[list {"m_axis_ready" "TREADY"} \
	  {"m_axis_valid" "TVALID"} \
	  {"m_axis_data" "TDATA"} \
	  {"m_axis_strb" "TSTRB"} \
	  {"m_axis_keep" "TKEEP"} \
	  {"m_axis_user" "TUSER"} \
	  {"m_axis_last" "TLAST"}]

adi_add_multi_bus $max_axi_ifc "MAXI_" "master" \
  "xilinx.com:interface:aximm_rtl:1.0" \
  "xilinx.com:interface:aximm:1.0" \
  [list \
    { "m_axi_araddr"  "ARADDR"   32 "(spirit:decode(id('MODELPARAM_VALUE.AXI_ADDR_WIDTH')))"} \
    { "m_axi_arburst" "ARBURST"  2 } \
    { "m_axi_arid"    "ARID"     6 "(spirit:decode(id('MODELPARAM_VALUE.AXI_ID_WIDTH')))"} \
    { "m_axi_arlen"   "ARLEN"    4 } \
    { "m_axi_arready" "ARREADY"  1 } \
    { "m_axi_arsize"  "ARSIZE"   3 } \
    { "m_axi_arvalid" "ARVALID"  1 } \
    { "m_axi_awaddr"  "AWADDR"  32 "(spirit:decode(id('MODELPARAM_VALUE.AXI_ADDR_WIDTH')) * 1)"} \
    { "m_axi_awburst" "AWBURST"  2 } \
    { "m_axi_awid"    "AWID"     1 "(spirit:decode(id('MODELPARAM_VALUE.AXI_ID_WIDTH')))"} \
    { "m_axi_awlen"   "AWLEN"    4 } \
    { "m_axi_awready" "AWREADY"  1 } \
    { "m_axi_awsize"  "AWSIZE"   3 } \
    { "m_axi_awvalid" "AWVALID"  1 } \
    { "m_axi_bid"     "BID"      6 "(spirit:decode(id('MODELPARAM_VALUE.AXI_ID_WIDTH')))"} \
    { "m_axi_bready"  "BREADY"   1 } \
    { "m_axi_bresp"   "BRESP"    2 } \
    { "m_axi_bvalid"  "BVALID"   1 } \
    { "m_axi_rdata"   "RDATA"   32 "(spirit:decode(id('MODELPARAM_VALUE.AXI_DATA_WIDTH')))"} \
    { "m_axi_rid"     "RID"      6 "(spirit:decode(id('MODELPARAM_VALUE.AXI_ID_WIDTH')))"} \
    { "m_axi_rlast"   "RLAST"    1 } \
    { "m_axi_rready"  "RREADY"   1 } \
    { "m_axi_rresp"   "RRESP"    2 } \
    { "m_axi_rvalid"  "RVALID"   1 } \
    { "m_axi_wdata"   "WDATA"   32 "(spirit:decode(id('MODELPARAM_VALUE.AXI_DATA_WIDTH')))"} \
    { "m_axi_wid"     "WID"      6 "(spirit:decode(id('MODELPARAM_VALUE.AXI_ID_WIDTH')))"} \
    { "m_axi_wlast"   "WLAST"    1 } \
    { "m_axi_wready"  "WREADY"   1 } \
    { "m_axi_wstrb"   "WSTRB"    4 "(spirit:decode(id('MODELPARAM_VALUE.AXI_DATA_WIDTH'))/8)"} \
    { "m_axi_wvalid"  "WVALID"   1 } \
  ] \
  "(spirit:decode(id('MODELPARAM_VALUE.NUM_M')) > {i})"

set ifc_list ""
for {set idx 0} {$idx < $max_axi_ifc} {incr idx} {
  set ifc_list $ifc_list:MAXI_$idx

  ipx::add_address_space MAXI_$idx [ipx::current_core]
  set_property master_address_space_ref MAXI_${idx} \
    [ipx::get_bus_interfaces MAXI_$idx \
    -of_objects [ipx::current_core]]
  set_property range 4G [ipx::get_address_spaces MAXI_${idx}]

}
adi_add_bus_clock "m_axi_aclk" $ifc_list "m_axi_aresetn"

adi_add_bus "wr_ctrl" "slave" \
	"analog.com:interface:if_do_ctrl_rtl:1.0" \
	"analog.com:interface:if_do_ctrl:1.0" \
	[list {"wr_request_enable" "request_enable"} \
	      {"wr_request_valid" "request_valid"} \
	      {"wr_request_ready" "request_ready"} \
	      {"wr_request_length" "request_length"} \
	      {"wr_response_measured_length" "response_measured_length"} \
	      {"wr_response_eot" "response_eot"} \
	      {"wr_overflow" "status_overflow"} \
	  ]

adi_add_bus "rd_ctrl" "slave" \
	"analog.com:interface:if_do_ctrl_rtl:1.0" \
	"analog.com:interface:if_do_ctrl:1.0" \
	[list {"rd_request_enable" "request_enable"} \
	      {"rd_request_valid" "request_valid"} \
	      {"rd_request_ready" "request_ready"} \
	      {"rd_request_length" "request_length"} \
	      {"rd_response_eot" "response_eot"} \
	      {"rd_underflow" "status_underflow"} \
	  ]

adi_add_bus_clock "s_axis_aclk" "s_axis:wr_ctrl" "s_axis_aresetn"
adi_add_bus_clock "m_axis_aclk" "m_axis:rd_ctrl" "m_axis_aresetn"

# The core does not issue narrow bursts
foreach intf [ipx::get_bus_interfaces MAXI_* -of_objects $cc] {
	set para [ipx::add_bus_parameter SUPPORTS_NARROW_BURST $intf]
	set_property "VALUE" "0" $para
}

set_property  -dict [list \
  display_name {Device type} \
  widget {comboBox} \
 ] [ipgui::get_guiparamspec TX_RX_N -component $cc]

set_property  -dict [list \
  value_resolve_type user \
  value 1 \
  value_validation_type pairs \
  value_validation_pairs {{DAC (TX)} 1 {ADC (RX)} 0} \
  ] [ipx::get_user_parameters TX_RX_N -of_objects $cc]


set_property value_tcl_expr {expr round((${TX_RX_N} == 1 ? ${DST_DATA_WIDTH}.0 : ${SRC_DATA_WIDTH}.0) / ${AXI_DATA_WIDTH}.0)} \
  [ipx::get_user_parameters NUM_M -of_objects $cc]


ipgui::remove_param -component $cc [ipgui::get_guiparamspec -name "NUM_M" -component $cc]
ipgui::remove_param -component $cc [ipgui::get_guiparamspec -name "AXI_ID_WIDTH" -component $cc]

ipx::create_xgui_files [ipx::current_core]
ipx::save_core [ipx::current_core]
