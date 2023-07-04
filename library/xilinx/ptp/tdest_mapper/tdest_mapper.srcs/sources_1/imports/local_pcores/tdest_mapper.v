// This module is a simple packet classifier 
`timescale 1ps/1ps

module tdest_mapper # (
  parameter integer TDEST_WIDTH = 4,
  parameter integer TDATA_WIDTH = 64)(
  clk,
  reset,
  tdest_mapper_en,
  default_mcdma_ch,
  s_axis_tvalid,
  s_axis_tready,
  s_axis_tdata,
  s_axis_tkeep,
  s_axis_tlast,
  s_axis_tuser,
  m_axis_s2mm_tvalid,
  m_axis_s2mm_tready,
  m_axis_s2mm_tdata,
  m_axis_s2mm_tkeep,
  m_axis_s2mm_tlast,
  m_axis_s2mm_tuser,
  m_axis_s2mm_tdest
);

input wire clk;
input wire reset;
input wire tdest_mapper_en;
input [TDEST_WIDTH-1:0]  default_mcdma_ch;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TVALID" *)
input wire s_axis_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TREADY" *)
output wire s_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TDATA" *)
input wire [TDATA_WIDTH-1: 0] s_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TKEEP" *)
input wire [7 : 0] s_axis_tkeep;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TLAST" *)
input wire s_axis_tlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TUSER" *)
input wire [0 : 0] s_axis_tuser;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TVALID" *)
output wire m_axis_s2mm_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TREADY" *)
input wire m_axis_s2mm_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TDATA" *)
output wire [TDATA_WIDTH-1: 0] m_axis_s2mm_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TKEEP" *)
output wire [7 : 0] m_axis_s2mm_tkeep;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TLAST" *)
output wire m_axis_s2mm_tlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TUSER" *)
output wire [0 : 0] m_axis_s2mm_tuser;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TDEST" *)
output [TDEST_WIDTH-1:0]  m_axis_s2mm_tdest;

reg    latch_tdest;
reg [TDEST_WIDTH-1:0] m_axis_s2mm_tdest_d1;

always @(posedge clk)
begin
  if (reset == 1'b0) begin
    latch_tdest     <= 1'b1;
    m_axis_s2mm_tdest_d1 <= 0;
  end
  else begin
    m_axis_s2mm_tdest_d1 <= m_axis_s2mm_tdest;
    if (s_axis_tvalid && m_axis_s2mm_tready && s_axis_tlast) begin
      latch_tdest     <= 1'b1;
    end
    else if (s_axis_tvalid && m_axis_s2mm_tready) begin
      latch_tdest     <= 1'b0;
    end
  end
end

assign m_axis_s2mm_tvalid                   = s_axis_tvalid;
assign s_axis_tready                        = m_axis_s2mm_tready;
assign m_axis_s2mm_tdata                    = s_axis_tdata;
assign m_axis_s2mm_tkeep                    = s_axis_tkeep;
assign m_axis_s2mm_tlast                    = s_axis_tlast;
assign m_axis_s2mm_tuser                    = s_axis_tuser;
assign m_axis_s2mm_tdest[TDEST_WIDTH-1:0]   = (tdest_mapper_en) ? (s_axis_tvalid && m_axis_s2mm_tready && latch_tdest) ? s_axis_tdata[TDATA_WIDTH-2:TDATA_WIDTH-TDEST_WIDTH-1] : 
	                                                                                                                 m_axis_s2mm_tdest_d1[TDEST_WIDTH-1:0] : default_mcdma_ch;


endmodule
