`timescale 1ns / 1ps

module sys_id #(
  parameter ROM_WIDTH = 32,
  parameter ROM_ADDR_BITS = 9)(

   //axi interface
  input           s_axi_aclk,
  input           s_axi_aresetn,
  input           s_axi_awvalid,
  input   [15:0]  s_axi_awaddr,
  input   [2:0]   s_axi_awprot,
  output          s_axi_awready,
  input           s_axi_wvalid,
  input   [31:0]  s_axi_wdata,
  input   [3:0]   s_axi_wstrb,
  output          s_axi_wready,
  output          s_axi_bvalid,
  output  [1:0]   s_axi_bresp,
  input           s_axi_bready,
  input           s_axi_arvalid,
  input   [15:0]  s_axi_araddr,
  input   [2:0]   s_axi_arprot,
  output          s_axi_arready,
  output          s_axi_rvalid,
  output  [1:0]   s_axi_rresp,
  output  [31:0]  s_axi_rdata,
  input           s_axi_rready,

  input   [ROM_WIDTH-1:0]           sys_rom_data,
  input   [ROM_WIDTH-1:0]           pr_rom_data,
  output  [ROM_ADDR_BITS-1:0]       rom_addr);

localparam          AXI_ADDRESS_WIDTH    = 12;
localparam  [31:0]  CORE_VERSION         = {16'h0001,     /* MAJOR */
                                              8'h00,      /* MINOR */
                                              8'h61};     /* PATCH */
localparam  [31:0]  CORE_MAGIC           = 32'h53594944;  // SYID

reg                             up_wack = 'd0;
reg   [31:0]                    up_rdata_s = 'd0;
reg                             up_rack_s = 'd0;
reg                             up_rreq_s_d = 'd0;
reg   [31:0]                    up_scratch = 'd0;

wire                            up_clk;
wire                            up_rstn;
wire                            up_rreq_s;
wire  [(ROM_ADDR_BITS+1):0]     up_raddr_s;
wire                            up_wreq_s;
wire  [(ROM_ADDR_BITS+1):0]     up_waddr_s;
wire  [31:0]                    up_wdata_s;
wire  [31:0]                    rom_data_s;

assign up_clk = s_axi_aclk;
assign up_rstn = s_axi_aresetn;

assign rom_addr = up_raddr_s [ROM_ADDR_BITS-1:0];
assign rom_data_s = (up_raddr_s [ROM_ADDR_BITS + 1'h1: ROM_ADDR_BITS] == 2'h1) ? sys_rom_data :
                  (up_raddr_s [ROM_ADDR_BITS + 1'h1: ROM_ADDR_BITS] == 2'h2) ? pr_rom_data : 'h0;

up_axi #(
  .AXI_ADDRESS_WIDTH(ROM_ADDR_BITS+4))
i_up_axi (
  .up_rstn (up_rstn),
  .up_clk (up_clk),
  .up_axi_awvalid (s_axi_awvalid),
  .up_axi_awaddr (s_axi_awaddr[ROM_ADDR_BITS+3:0]),
  .up_axi_awready (s_axi_awready),
  .up_axi_wvalid (s_axi_wvalid),
  .up_axi_wdata (s_axi_wdata),
  .up_axi_wstrb (s_axi_wstrb),
  .up_axi_wready (s_axi_wready),
  .up_axi_bvalid (s_axi_bvalid),
  .up_axi_bresp (s_axi_bresp),
  .up_axi_bready (s_axi_bready),
  .up_axi_arvalid (s_axi_arvalid),
  .up_axi_araddr (s_axi_araddr[ROM_ADDR_BITS+3:0]),
  .up_axi_arready (s_axi_arready),
  .up_axi_rvalid (s_axi_rvalid),
  .up_axi_rresp (s_axi_rresp),
  .up_axi_rdata (s_axi_rdata),
  .up_axi_rready (s_axi_rready),
  .up_wreq (up_wreq_s),
  .up_waddr (up_waddr_s),
  .up_wdata (up_wdata_s),
  .up_wack (up_wack),
  .up_rreq (up_rreq_s),
  .up_raddr (up_raddr_s),
  .up_rdata (up_rdata_s),
  .up_rack (up_rack_s));

//delaying data read with 1 tck to compensate for the ROM latency
always @(posedge up_clk) begin
  up_rreq_s_d <= up_rreq_s;
end

//axi registers read
always @(posedge up_clk) begin
  if (up_rstn == 1'b0) begin
    up_rack_s <= 'd0;
    up_rdata_s <= 'd0;
  end else begin
    up_rack_s <= up_rreq_s_d;
    if (up_rreq_s_d == 1'b1) begin
      case (up_raddr_s)
        8'h00: up_rdata_s <= CORE_VERSION;
        8'h01: up_rdata_s <= 0;
        8'h02: up_rdata_s <= up_scratch;
        8'h03: up_rdata_s <= CORE_MAGIC;
        8'h10: up_rdata_s <= ROM_ADDR_BITS;
        default: begin
          up_rdata_s <= rom_data_s;
        end
      endcase
    end else begin
      up_rdata_s <= 32'd0;
    end
  end
end

//axi registers write
always @(posedge up_clk) begin
  if (up_rstn == 1'b0) begin
    up_wack <= 'd0;
    up_scratch <= 'd0;
  end else begin
    up_wack <= up_wreq_s;
    if ((up_wreq_s == 1'b1) && (up_waddr_s == 8'h02)) begin
      up_scratch <= up_wdata_s;
    end
  end
end

endmodule
