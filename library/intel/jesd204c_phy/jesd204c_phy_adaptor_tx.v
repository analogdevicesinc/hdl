//
// The ADI JESD204 Core is released under the following license, which is
// different than all other HDL cores in this repository.
//
// Please read this, and understand the freedoms and responsibilities you have
// by using this source code/core.
//
// The JESD204 HDL, is copyright © 2016-2017 Analog Devices Inc.
//
// This core is free software, you can use run, copy, study, change, ask
// questions about and improve this core. Distribution of source, or resulting
// binaries (including those inside an FPGA or ASIC) require you to release the
// source of the entire project (excluding the system libraries provide by the
// tools/compiler/FPGA vendor). These are the terms of the GNU General Public
// License version 2 as published by the Free Software Foundation.
//
// This core  is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License version 2
// along with this source code, and binary.  If not, see
// <http://www.gnu.org/licenses/>.
//
// Commercial licenses (with commercial support) of this JESD204 core are also
// available under terms different than the General Public License. (e.g. they
// do not require you to accompany any image (FPGA or ASIC) using the JESD204
// core with any corresponding source code.) For these alternate terms you must
// purchase a license from Analog Devices Technology Licensing Office. Users
// interested in such a license should contact jesd204-licensing@analog.com for
// more information. This commercial license is sub-licensable (if you purchase
// chips from Analog Devices, incorporate them into your PCB level product, and
// purchase a JESD204 license, end users of your product will also have a
// license to use this core in a commercial setting without releasing their
// source code).
//
// In addition, we kindly ask you to acknowledge ADI in any program, application
// or publication in which you use this JESD204 HDL core. (You are not required
// to do so; it is up to your common sense to decide whether you want to comply
// with this request or not.) For general publications, we suggest referencing :
// The design and implementation of the JESD204 HDL Core used in this project
// is copyright © 2016-2017, Analog Devices, Inc.
//

`timescale 1ns/100ps

module jesd204c_phy_adaptor_tx #(
  parameter O_WIDTH = 80,
  parameter DATA_PATH_WIDTH = 8
) (
  // output interface clock. Lane rate / serdes factor
  // e.g  lane rate/64
  input o_clk,

  output reg [O_WIDTH-1:0] o_phy_data = 'h0,
  input                    o_phy_tx_ready,

  // input interface clock. Lane rate / 66
  input i_clk,

  input [DATA_PATH_WIDTH*8-1:0] i_phy_data,
  input [1:0] i_phy_header,
  // Dummy interface to keep 204B compatibility
  input [DATA_PATH_WIDTH-1:0] i_phy_charisk,

  output reg o_status_rate_mismatch = 'b0
);


// shallow FIFO
parameter SIZE = 4;
localparam ADDR_WIDTH = $clog2(SIZE);

reg [ADDR_WIDTH:0] i_wr_addr = 'h00;
reg [ADDR_WIDTH:0] o_rd_addr = 'h00;

wire [65:0] o_data;
wire o_mem_rd;
wire o_mem_rd_en;

wire i_tx_ready;

// Valid to output interface can be high for 32 cycles out of 33
reg [5:0] rate_cnt = 6'd32;

always @(posedge o_clk) begin
  if (~o_mem_rd_en) begin
    rate_cnt <= 6'd32;
  end else if (rate_cnt[5] ) begin
    rate_cnt <= 6'd0;
  end else begin
    rate_cnt <= rate_cnt + 6'd1;
  end
end

assign o_mem_rd = ~rate_cnt[5];

// write to memory when PHY is ready and link clock domain is
// also running achieved with two sync_bits
always @(posedge i_clk) begin
  if (~i_tx_ready) begin
    i_wr_addr <= 'h00;
  end else if (1'b1) begin
    i_wr_addr <= i_wr_addr + 1'b1;
  end
end

sync_bits #(
  .NUM_OF_BITS (1),
  .ASYNC_CLK (1)
) i_tx_ready_cdc (
  .in_bits(o_phy_tx_ready),
  .out_clk(i_clk),
  .out_resetn(1'b1),
  .out_bits(i_tx_ready)
);

sync_bits #(
  .NUM_OF_BITS (1),
  .ASYNC_CLK (1)
) i_tx_ready_back_cdc (
  .in_bits(i_tx_ready),
  .out_clk(o_clk),
  .out_resetn(1'b1),
  .out_bits(o_mem_rd_en)
);

ad_mem #(
  .DATA_WIDTH (1+66),
  .ADDRESS_WIDTH (ADDR_WIDTH)
) i_ad_mem (
  .clka(i_clk),
  .wea(1'b1),
  .addra(i_wr_addr[ADDR_WIDTH-1:0]),
  .dina({i_wr_addr[ADDR_WIDTH],i_phy_header,i_phy_data}),

  .clkb(o_clk),
  .reb(o_mem_rd),
  .addrb(o_rd_addr[ADDR_WIDTH-1:0]),
  .doutb({o_tag,o_data})
);

reg o_ref_tag = 1'b0;

always @(posedge o_clk) begin
  if (~o_phy_tx_ready) begin
    o_rd_addr <= 'h00;
    o_ref_tag <= 1'b0;
  end else if (o_mem_rd) begin
    o_rd_addr <= o_rd_addr + 1'b1;
    o_ref_tag <= o_rd_addr[ADDR_WIDTH];
  end
end

// Detect overflow or underflow by checking reference tag against received
// one over the memory
always @(posedge o_clk) begin
  if (~o_phy_tx_ready) begin
    o_status_rate_mismatch <= 1'b0;
  end else if (o_tag ^ o_ref_tag) begin
    o_status_rate_mismatch <= 1'b1;
  end
end

always @(posedge o_clk) begin
 o_phy_data[68] <= o_mem_rd;
end

always @(*) begin
  o_phy_data[38:0] = o_data[38:0];
  o_phy_data[66:40] = o_data[65:39];
end

endmodule
