#
# SPDX-FileCopyrightText: Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: MIT-0
#

package require -exact qsys 24.3


#
# module f2sdram_adapter
#
set_module_property DESCRIPTION ""
set_module_property NAME f2sdram_adapter
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "RSF"
set_module_property DISPLAY_NAME f2sdram_adapter
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property LOAD_ELABORATION_LIMIT 0
set_module_property PRE_COMP_MODULE_ENABLED false
set_module_property ELABORATION_CALLBACK elaboration

#
# parameters
#
add_parameter DATA_WIDTH INTEGER "64"
set_parameter_property DATA_WIDTH DISPLAY_NAME DATA_WIDTH
set_parameter_property DATA_WIDTH SYSTEM_INFO "DATA_WIDTH"
set_parameter_property DATA_WIDTH HDL_PARAMETER true
set_parameter_property DATA_WIDTH VISIBLE true
set_parameter_property DATA_WIDTH ALLOWED_RANGES {64 128 256}


#
# file sets
#
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH generate_verilog

add_fileset SIM_VERILOG SIM_VERILOG generate_verilog

add_fileset SIM_VHDL SIM_VHDL generate_verilog

proc elaboration {} {
set DATA_WIDTH          [ get_parameter_value DATA_WIDTH ]
}
#
# display items
#


#
# connection point clock
#
add_interface clock clock end
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""
set_interface_property clock IPXACT_REGISTER_MAP_VARIABLES ""
set_interface_property clock SV_INTERFACE_TYPE ""
set_interface_property clock SV_INTERFACE_MODPORT_TYPE ""

add_interface_port clock clk clk Input 1


#
# connection point reset
#
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""
set_interface_property reset IPXACT_REGISTER_MAP_VARIABLES ""
set_interface_property reset SV_INTERFACE_TYPE ""
set_interface_property reset SV_INTERFACE_MODPORT_TYPE ""

add_interface_port reset reset reset Input 1


#
# connection point axi4_man
#
add_interface axi4_man axi4 start
set_interface_property axi4_man associatedClock clock
set_interface_property axi4_man associatedReset reset
set_interface_property axi4_man wakeupSignals false
set_interface_property axi4_man uniqueIdSupport false
set_interface_property axi4_man poison false
set_interface_property axi4_man traceSignals false
set_interface_property axi4_man readIssuingCapability 1
set_interface_property axi4_man writeIssuingCapability 1
set_interface_property axi4_man combinedIssuingCapability 1
set_interface_property axi4_man issuesINCRBursts true
set_interface_property axi4_man issuesWRAPBursts true
set_interface_property axi4_man issuesFIXEDBursts true
set_interface_property axi4_man ENABLED true
set_interface_property axi4_man EXPORT_OF ""
set_interface_property axi4_man PORT_NAME_MAP ""
set_interface_property axi4_man CMSIS_SVD_VARIABLES ""
set_interface_property axi4_man SVD_ADDRESS_GROUP ""
set_interface_property axi4_man IPXACT_REGISTER_MAP_VARIABLES ""
set_interface_property axi4_man SV_INTERFACE_TYPE ""
set_interface_property axi4_man SV_INTERFACE_MODPORT_TYPE ""

add_interface_port axi4_man man_araddr araddr Output 32
add_interface_port axi4_man man_arburst arburst Output 2
add_interface_port axi4_man man_arcache arcache Output 4
add_interface_port axi4_man man_arid arid Output 5
add_interface_port axi4_man man_arlen arlen Output 8
add_interface_port axi4_man man_arlock arlock Output 1
add_interface_port axi4_man man_arprot arprot Output 3
add_interface_port axi4_man man_arqos arqos Output 4
add_interface_port axi4_man man_arready arready Input 1
add_interface_port axi4_man man_arsize arsize Output 3
add_interface_port axi4_man man_arvalid arvalid Output 1
add_interface_port axi4_man man_awaddr awaddr Output 32
add_interface_port axi4_man man_awburst awburst Output 2
add_interface_port axi4_man man_awcache awcache Output 4
add_interface_port axi4_man man_awid awid Output 5
add_interface_port axi4_man man_awlen awlen Output 8
add_interface_port axi4_man man_awlock awlock Output 1
add_interface_port axi4_man man_awprot awprot Output 3
add_interface_port axi4_man man_awqos awqos Output 4
add_interface_port axi4_man man_awready awready Input 1
add_interface_port axi4_man man_awsize awsize Output 3
add_interface_port axi4_man man_awvalid awvalid Output 1
add_interface_port axi4_man man_bid bid Input 5
add_interface_port axi4_man man_bready bready Output 1
add_interface_port axi4_man man_bresp bresp Input 2
add_interface_port axi4_man man_bvalid bvalid Input 1
add_interface_port axi4_man man_rdata rdata Input DATA_WIDTH
add_interface_port axi4_man man_rid rid Input 5
add_interface_port axi4_man man_rlast rlast Input 1
add_interface_port axi4_man man_rready rready Output 1
add_interface_port axi4_man man_rresp rresp Input 2
add_interface_port axi4_man man_rvalid rvalid Input 1
add_interface_port axi4_man man_wdata wdata Output DATA_WIDTH
add_interface_port axi4_man man_wlast wlast Output 1
add_interface_port axi4_man man_wready wready Input 1
add_interface_port axi4_man man_wstrb wstrb Output DATA_WIDTH/8
add_interface_port axi4_man man_wvalid wvalid Output 1
add_interface_port axi4_man man_aruser aruser Output 8
add_interface_port axi4_man man_awuser awuser Output 8
add_interface_port axi4_man man_wuser wuser Output 8
add_interface_port axi4_man man_buser buser Input 8
add_interface_port axi4_man man_arregion arregion Output 4
add_interface_port axi4_man man_ruser ruser Input 8
add_interface_port axi4_man man_awregion awregion Output 4


#
# connection point axi4_sub
#
add_interface axi4_sub axi4 end
set_interface_property axi4_sub associatedClock clock
set_interface_property axi4_sub associatedReset reset
set_interface_property axi4_sub wakeupSignals false
set_interface_property axi4_sub uniqueIdSupport false
set_interface_property axi4_sub poison false
set_interface_property axi4_sub traceSignals false
set_interface_property axi4_sub readAcceptanceCapability 1
set_interface_property axi4_sub writeAcceptanceCapability 1
set_interface_property axi4_sub combinedAcceptanceCapability 1
set_interface_property axi4_sub readDataReorderingDepth 1
set_interface_property axi4_sub bridgesToMaster ""
set_interface_property axi4_sub dfhFeatureGuid 0
set_interface_property axi4_sub dfhGroupId 0
set_interface_property axi4_sub dfhParameterId ""
set_interface_property axi4_sub dfhParameterName ""
set_interface_property axi4_sub dfhParameterVersion ""
set_interface_property axi4_sub dfhParameterData ""
set_interface_property axi4_sub dfhParameterDataLength ""
set_interface_property axi4_sub dfhFeatureMajorVersion 0
set_interface_property axi4_sub dfhFeatureMinorVersion 0
set_interface_property axi4_sub dfhFeatureId 35
set_interface_property axi4_sub ENABLED true
set_interface_property axi4_sub EXPORT_OF ""
set_interface_property axi4_sub PORT_NAME_MAP ""
set_interface_property axi4_sub CMSIS_SVD_VARIABLES ""
set_interface_property axi4_sub SVD_ADDRESS_GROUP ""
set_interface_property axi4_sub IPXACT_REGISTER_MAP_VARIABLES ""
set_interface_property axi4_sub SV_INTERFACE_TYPE ""
set_interface_property axi4_sub SV_INTERFACE_MODPORT_TYPE ""

add_interface_port axi4_sub sub_araddr araddr Input 32
add_interface_port axi4_sub sub_arburst arburst Input 2
add_interface_port axi4_sub sub_arcache arcache Input 4
add_interface_port axi4_sub sub_arid arid Input 5
add_interface_port axi4_sub sub_arlen arlen Input 8
add_interface_port axi4_sub sub_arlock arlock Input 1
add_interface_port axi4_sub sub_arprot arprot Input 3
add_interface_port axi4_sub sub_arqos arqos Input 4
add_interface_port axi4_sub sub_arready arready Output 1
add_interface_port axi4_sub sub_arsize arsize Input 3
add_interface_port axi4_sub sub_arvalid arvalid Input 1
add_interface_port axi4_sub sub_awaddr awaddr Input 32
add_interface_port axi4_sub sub_awburst awburst Input 2
add_interface_port axi4_sub sub_awcache awcache Input 4
add_interface_port axi4_sub sub_awid awid Input 5
add_interface_port axi4_sub sub_awlen awlen Input 8
add_interface_port axi4_sub sub_awlock awlock Input 1
add_interface_port axi4_sub sub_awprot awprot Input 3
add_interface_port axi4_sub sub_awqos awqos Input 4
add_interface_port axi4_sub sub_awready awready Output 1
add_interface_port axi4_sub sub_awsize awsize Input 3
add_interface_port axi4_sub sub_awvalid awvalid Input 1
add_interface_port axi4_sub sub_bid bid Output 5
add_interface_port axi4_sub sub_bready bready Input 1
add_interface_port axi4_sub sub_bresp bresp Output 2
add_interface_port axi4_sub sub_bvalid bvalid Output 1
add_interface_port axi4_sub sub_rdata rdata Output DATA_WIDTH
add_interface_port axi4_sub sub_rid rid Output 5
add_interface_port axi4_sub sub_rlast rlast Output 1
add_interface_port axi4_sub sub_rready rready Input 1
add_interface_port axi4_sub sub_rresp rresp Output 2
add_interface_port axi4_sub sub_rvalid rvalid Output 1
add_interface_port axi4_sub sub_wdata wdata Input DATA_WIDTH
add_interface_port axi4_sub sub_wlast wlast Input 1
add_interface_port axi4_sub sub_wready wready Output 1
add_interface_port axi4_sub sub_wstrb wstrb Input DATA_WIDTH/8
add_interface_port axi4_sub sub_wvalid wvalid Input 1
add_interface_port axi4_sub sub_aruser aruser Input 8
add_interface_port axi4_sub sub_awuser awuser Input 8
add_interface_port axi4_sub sub_wuser wuser Input 8
add_interface_port axi4_sub sub_buser buser Output 8
add_interface_port axi4_sub sub_arregion arregion Input 4
add_interface_port axi4_sub sub_ruser ruser Output 8
add_interface_port axi4_sub sub_awregion awregion Input 4

proc generate_verilog { output_name } {
set verilog_code {
//
// SPDX-FileCopyrightText: Copyright (C) 2024 Intel Corporation
// SPDX-License-Identifier: MIT-0
//

`timescale 1 ps / 1 ps
module ${output_name} #(
    parameter DATA_WIDTH = 64
) (

	//
	// clock and reset
	//
	input  wire         clk,
	input  wire         reset,

	//
	// AXI4 subordinate
	//
	input  wire \[31:0\]  sub_araddr,
	input  wire \[1:0\]   sub_arburst,
	input  wire \[3:0\]   sub_arcache,
	input  wire \[4:0\]   sub_arid,
	input  wire \[7:0\]   sub_arlen,
	input  wire         sub_arlock,
	input  wire \[2:0\]   sub_arprot,
	input  wire \[3:0\]   sub_arqos,
	output wire         sub_arready,
	input  wire \[2:0\]   sub_arsize,
	input  wire         sub_arvalid,
	input  wire \[31:0\]  sub_awaddr,
	input  wire \[1:0\]   sub_awburst,
	input  wire \[3:0\]   sub_awcache,
	input  wire \[4:0\]   sub_awid,
	input  wire \[7:0\]   sub_awlen,
	input  wire         sub_awlock,
	input  wire \[2:0\]   sub_awprot,
	input  wire \[3:0\]   sub_awqos,
	output wire         sub_awready,
	input  wire \[2:0\]   sub_awsize,
	input  wire         sub_awvalid,
	output wire \[4:0\]   sub_bid,
	input  wire         sub_bready,
	output wire \[1:0\]   sub_bresp,
	output wire         sub_bvalid,
	output wire \[DATA_WIDTH-1:0\] sub_rdata,
	output wire \[4:0\]   sub_rid,
	output wire         sub_rlast,
	input  wire         sub_rready,
	output wire \[1:0\]   sub_rresp,
	output wire         sub_rvalid,
	input  wire \[DATA_WIDTH-1:0\] sub_wdata,
	input  wire         sub_wlast,
	output wire         sub_wready,
	input  wire \[DATA_WIDTH/8-1:0\]  sub_wstrb,
	input  wire         sub_wvalid,
	input  wire \[7:0\]   sub_aruser,
	input  wire \[7:0\]   sub_awuser,
	input  wire \[7:0\]   sub_wuser,
	output wire \[7:0\]   sub_buser,
	input  wire \[3:0\]   sub_arregion,
	output wire \[7:0\]   sub_ruser,
	input  wire \[3:0\]   sub_awregion,

	//
	// AXI4 manager
	//
	output wire \[31:0\]  man_araddr,
	output wire \[1:0\]   man_arburst,
	output wire \[3:0\]   man_arcache,
	output wire \[4:0\]   man_arid,
	output wire \[7:0\]   man_arlen,
	output wire         man_arlock,
	output wire \[2:0\]   man_arprot,
	output wire \[3:0\]   man_arqos,
	input  wire         man_arready,
	output wire \[2:0\]   man_arsize,
	output wire         man_arvalid,
	output wire \[31:0\]  man_awaddr,
	output wire \[1:0\]   man_awburst,
	output wire \[3:0\]   man_awcache,
	output wire \[4:0\]   man_awid,
	output wire \[7:0\]   man_awlen,
	output wire         man_awlock,
	output wire \[2:0\]   man_awprot,
	output wire \[3:0\]   man_awqos,
	input  wire         man_awready,
	output wire \[2:0\]   man_awsize,
	output wire         man_awvalid,
	input  wire \[4:0\]   man_bid,
	output wire         man_bready,
	input  wire \[1:0\]   man_bresp,
	input  wire         man_bvalid,
	input  wire \[DATA_WIDTH-1:0\] man_rdata,
	input  wire \[4:0\]   man_rid,
	input  wire         man_rlast,
	output wire         man_rready,
	input  wire \[1:0\]   man_rresp,
	input  wire         man_rvalid,
	output wire \[DATA_WIDTH-1:0\] man_wdata,
	output wire         man_wlast,
	input  wire         man_wready,
	output wire \[DATA_WIDTH/8-1:0\]  man_wstrb,
	output wire         man_wvalid,
	output wire \[7:0\]   man_aruser,
	output wire \[7:0\]   man_awuser,
	output wire \[7:0\]   man_wuser,
	input  wire \[7:0\]   man_buser,
	output wire \[3:0\]   man_arregion,
	input  wire \[7:0\]   man_ruser,
	output wire \[3:0\]   man_awregion
);

assign sub_ruser   = man_ruser;
assign sub_wready  = man_wready;
assign sub_rid     = man_rid;
assign sub_arready = man_arready;
assign sub_bresp   = man_bresp;
assign sub_rdata   = man_rdata;
assign sub_awready = man_awready;
assign sub_rlast   = man_rlast;
assign sub_buser   = man_buser;
assign sub_rresp   = man_rresp;
assign sub_bid     = man_bid;
assign sub_bvalid  = man_bvalid;
assign sub_rvalid  = man_rvalid;

assign man_wuser    = 8'h00;
assign man_awburst  = sub_awburst;
assign man_arregion = 4'h0;
assign man_arlen    = sub_arlen;
assign man_arqos    = 4'h0;
assign man_awuser   = 8'hE0;
assign man_wstrb    = sub_wstrb;
assign man_rready   = sub_rready;
assign man_awlen    = sub_awlen;
assign man_awqos    = 4'h0;
assign man_arcache  = 4'h2;
assign man_araddr   = sub_araddr;
assign man_wvalid   = sub_wvalid;
assign man_arprot   = 3'b011;
assign man_arvalid  = sub_arvalid;
assign man_awprot   = 3'b011;
assign man_wdata    = sub_wdata;
assign man_arid     = sub_arid;
assign man_awcache  = 4'h2;
assign man_arlock   = 1'b0;
assign man_awlock   = 1'b0;
assign man_awaddr   = sub_awaddr;
assign man_arburst  = sub_arburst;
assign man_arsize   = sub_arsize;
assign man_bready   = sub_bready;
assign man_wlast    = sub_wlast;
assign man_awregion = 4'h0;
assign man_awid     = sub_awid;
assign man_awsize   = sub_awsize;
assign man_awvalid  = sub_awvalid;
assign man_aruser   = 8'hE0;

endmodule
}

add_fileset_file "${output_name}.v" VERILOG TEXT [subst ${verilog_code}]

}
