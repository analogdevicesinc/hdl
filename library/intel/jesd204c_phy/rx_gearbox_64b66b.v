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

module rx_gearbox_64b66b #(
  parameter SIZE = 4,
  parameter I_WIDTH = 64,
  parameter O_WIDTH = 66
) (
  input i_clk,
  input [I_WIDTH-1:0] i_data,
  input i_reset,

  input o_clk,
  output reg [O_WIDTH-1:0] o_data,
  output o_valid
);

  localparam ADDR_WIDTH = $clog2(SIZE);

  reg [O_WIDTH-1:0] mem[0:SIZE - 1];
  reg [ADDR_WIDTH:0] wr_addr = 'h00;
  reg [ADDR_WIDTH:0] rd_addr = 'h00;

  wire mem_wr;
  wire [O_WIDTH-1:0] mem_wr_data;
  wire o_ready;

  ad_pack #(
    .I_W(I_WIDTH),
    .O_W(O_WIDTH),
    .UNIT_W(1)
  ) i_ad_pack (
    .clk(i_clk),
    .reset(i_reset),
    .idata(i_data),
    .ivalid(1'b1),
    .odata(mem_wr_data),
    .ovalid(mem_wr));

  always @(posedge i_clk) begin
    if (i_reset) begin
      wr_addr <= 'h00;
    end else if (mem_wr) begin
      mem[wr_addr] <= mem_wr_data;
      wr_addr <= wr_addr + 1'b1;
    end
  end

  sync_bits i_sync_ready (
    .in_bits(i_reset),
    .out_resetn(1'b0),
    .out_clk(o_clk),
    .out_bits(o_ready));

  always @(posedge o_clk) begin
    if (o_ready == 1'b0) begin
      rd_addr <= 'h00;
      o_valid <= 1'b0;
    end else begin
      rd_addr <= rd_addr + 1'b1;
      o_data <= mem[rd_addr];
      o_valid <= 1'b1;
    end
  end

endmodule
