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
// “The design and implementation of the JESD204 HDL Core used in this project
// is copyright © 2016-2017, Analog Devices, Inc.”
//

`timescale 1ns/100ps

module jesd204_up_ilas_mem (
  input up_clk,

  input up_rreq,
  input [1:0] up_raddr,
  output reg [31:0] up_rdata,

  input core_clk,
  input core_reset,

  input core_ilas_config_valid,
  input [1:0] core_ilas_config_addr,
  input [31:0] core_ilas_config_data,

  output up_ilas_ready
);

reg [31:0] mem[0:3];
reg core_ilas_captured = 1'b0;

sync_bits i_cdc_ilas_ready (
  .in_bits(core_ilas_captured),
  .out_resetn(1'b1),
  .out_clk(up_clk),
  .out_bits(up_ilas_ready)
);

always @(posedge core_clk) begin
  if (core_reset == 1'b1) begin
    core_ilas_captured <= 1'b0;
  end else begin
    if (core_ilas_config_valid == 1'b1 && core_ilas_config_addr == 'h3) begin
      core_ilas_captured <= 1'b1;
    end
  end
end

always @(posedge up_clk) begin
  if (up_rreq == 1'b1) begin
    up_rdata <= mem[up_raddr];
  end
end

always @(posedge core_clk) begin
  if (core_ilas_config_valid == 1'b1) begin
    mem[core_ilas_config_addr] <= core_ilas_config_data;
  end
end

/*
 * Shift register with variable tap for accessing the stored data.
 *
 * This has slightly better utilization on Xilinx based platforms than the dual
 * port RAM approach, but there is no equivalent primitive on Intel resulting
 * in increased utilization since it needs to be implemented used registers and
 * muxes.
 *
 * We might make this a device dependent configuration option at some point.

reg [3:0] mem[0:31];

generate
genvar i;
for (i = 0; i < 32; i = i + 1) begin: gen_ilas_mem
  assign up_rdata[i] = mem[i][~up_raddr];

  always @(posedge core_clk) begin
    if (core_ilas_config_valid == 1'b1) begin
      mem[i] <= {mem[i][2:0],core_ilas_config_data[i]};
    end
  end
end
endgenerate
*/

endmodule
