source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create util_fifo2axi_bridge
adi_ip_files util_fifo2axi_bridge [list \
  "util_fifo2axi_bridge_constr.xdc" \
  "util_fifo2axi_bridge.v" \
]

adi_ip_properties_lite util_fifo2axi_bridge

adi_ip_add_core_dependencies [list \
  analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
  analog.com:$VIVADO_IP_LIBRARY:util_axis_fifo_asym:1.0 \
]

set_property display_name "ADI FIFO to AXI4 bridge" [ipx::current_core]
set_property description "Bridge between a FIFO READ/WRITE interface and an AXI4 Memory Mapped interface" [ipx::current_core]

## Infer the AXI4 Memory Map interface
adi_add_bus "ddr_axi" "master" \
  "xilinx.com:interface:aximm_rtl:1.0" \
  "xilinx.com:interface:aximm:1.0" \
  [ list \
    {"axi_awvalid" "AWVALID"} \
    {"axi_awid" "AWID"} \
    {"axi_awburst" "AWBURST"} \
    {"axi_awlock" "AWLOCK"} \
    {"axi_awcache" "AWCACHE"} \
    {"axi_awprot" "AWPROT"} \
    {"axi_awqos" "AWQOS"} \
    {"axi_awlen" "AWLEN"} \
    {"axi_awsize" "AWSIZE"} \
    {"axi_awaddr" "AWADDR"} \
    {"axi_awready" "AWREADY"} \
    {"axi_wvalid" "WVALID"} \
    {"axi_wdata" "WDATA"} \
    {"axi_wstrb" "WSTRB"} \
    {"axi_wlast" "WLAST"} \
    {"axi_wready" "WREADY"} \
    {"axi_bvalid" "BVALID"} \
    {"axi_bid" "BID"} \
    {"axi_bresp" "BRESP"} \
    {"axi_bready" "BREADY"} \
    {"axi_arvalid" "ARVALID"} \
    {"axi_arid" "ARID"} \
    {"axi_arburst" "ARBURST"} \
    {"axi_arlock" "ARLOCK"} \
    {"axi_arcache" "ARCACHE"} \
    {"axi_arprot" "ARPROT"} \
    {"axi_arqos" "ARQOS"} \
    {"axi_arlen" "ARLEN"} \
    {"axi_arsize" "ARSIZE"} \
    {"axi_araddr" "ARADDR"} \
    {"axi_arready" "ARREADY"} \
    {"axi_rvalid" "RVALID"} \
    {"axi_rready" "RREADY"} \
    {"axi_rid" "RID"} \
    {"axi_rresp" "RRESP"} \
    {"axi_rlast" "RLAST"} \
    {"axi_rdata" "RDATA"} ]
adi_add_bus_clock "axi_clk" "ddr_axi" "axi_resetn"

ipx::add_address_space ddr_axi [ipx::current_core]
set_property master_address_space_ref ddr_axi [ipx::get_bus_interfaces ddr_axi \
  -of_objects [ipx::current_core]]
set_property range 4294967296 [ipx::get_address_spaces ddr_axi \
  -of_objects [ipx::current_core]]
set_property width 512 [ipx::get_address_spaces ddr_axi \
  -of_objects [ipx::current_core]]

ipx::save_core [ipx::current_core]
