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

module jesd204_8b10b_encoder (
  input in_disparity,
  input [7:0] in_char,
  input in_charisk,

  output [9:0] out_char,
  output out_disparity
);

/*
 * Only supports the subset of 8b10b that is used by JESD204.
 * If non-supported control characters are supplied the output is undefined.
 */

reg [5:0] data6b;
reg [5:0] out6b;
reg may_invert6b;
reg disparity6b;
reg [3:0] data4b;
reg [3:0] out4b;
reg may_invert4b;
reg disparity4b;
wire disparity4b_in;
reg alt7;

always @(*) begin
  if (in_charisk == 1'b1) begin
    // Assume K28.x
    data6b = 6'b000011;
    may_invert6b = 1'b1;
    disparity6b = 1'b1;
  end else begin
    case (in_char[4:0])
    5'd00: begin
      data6b = 6'b000110;
      may_invert6b = 1'b1;
      disparity6b = 1'b1;
    end
    5'd01: begin
      data6b = 6'b010001;
      may_invert6b = 1'b1;
      disparity6b = 1'b1;
    end
    5'd02: begin
      data6b = 6'b010010;
      may_invert6b = 1'b1;
      disparity6b = 1'b1;
    end
    5'd03: begin
      data6b = 6'b100011;
      may_invert6b = 1'b0;
      disparity6b = 1'b0;
    end
    5'd04: begin
      data6b = 6'b010100;
      may_invert6b = 1'b1;
      disparity6b = 1'b1;
    end
    5'd05: begin
      data6b = 6'b100101;
      may_invert6b = 1'b0;
      disparity6b = 1'b0;
    end
    5'd06: begin
      data6b = 6'b100110;
      may_invert6b = 1'b0;
      disparity6b = 1'b0;
    end
    5'd07: begin
      data6b = 6'b111000;
      may_invert6b = 1'b1;
      disparity6b = 1'b0;
    end
    5'd08: begin
      data6b = 6'b011000;
      may_invert6b = 1'b1;
      disparity6b = 1'b1;
    end
    5'd09: begin
      data6b = 6'b101001;
      may_invert6b = 1'b0;
      disparity6b = 1'b0;
    end
    5'd10: begin
      data6b = 6'b101010;
      may_invert6b = 1'b0;
      disparity6b = 1'b0;
    end
    5'd11: begin
      data6b = 6'b001011;
      may_invert6b = 1'b0;
      disparity6b = 1'b0;
    end
    5'd12: begin
      data6b = 6'b101100;
      may_invert6b = 1'b0;
      disparity6b = 1'b0;
    end
    5'd13: begin
      data6b = 6'b001101;
      may_invert6b = 1'b0;
      disparity6b = 1'b0;
    end
    5'd14: begin
      data6b = 6'b001110;
      may_invert6b = 1'b0;
      disparity6b = 1'b0;
    end
    5'd15: begin
      data6b = 6'b000101;
      may_invert6b = 1'b1;
      disparity6b = 1'b1;
    end
    5'd16: begin
      data6b = 6'b001001;
      may_invert6b = 1'b1;
      disparity6b = 1'b1;
    end
    5'd17: begin
      data6b = 6'b110001;
      may_invert6b = 1'b0;
      disparity6b = 1'b0;
    end
    5'd18: begin
      data6b = 6'b110010;
      may_invert6b = 1'b0;
      disparity6b = 1'b0;
    end
    5'd19: begin
      data6b = 6'b010011;
      may_invert6b = 1'b0;
      disparity6b = 1'b0;
    end
    5'd20: begin
      data6b = 6'b110100;
      may_invert6b = 1'b0;
      disparity6b = 1'b0;
    end
    5'd21: begin
      data6b = 6'b010101;
      may_invert6b = 1'b0;
      disparity6b = 1'b0;
    end
    5'd22: begin
      data6b = 6'b010110;
      may_invert6b = 1'b0;
      disparity6b = 1'b0;
    end
    5'd23: begin
      data6b = 6'b101000;
      may_invert6b = 1'b1;
      disparity6b = 1'b1;
    end
    5'd24: begin
      data6b = 6'b001100;
      may_invert6b = 1'b1;
      disparity6b = 1'b1;
    end
    5'd25: begin
      data6b = 6'b011001;
      may_invert6b = 1'b0;
      disparity6b = 1'b0;
    end
    5'd26: begin
      data6b = 6'b011010;
      may_invert6b = 1'b0;
      disparity6b = 1'b0;
    end
    5'd27: begin
      data6b = 6'b100100;
      may_invert6b = 1'b1;
      disparity6b = 1'b1;
    end
    5'd28: begin
      data6b = 6'b011100;
      may_invert6b = 1'b0;
      disparity6b = 1'b0;
    end
    5'd29: begin
      data6b = 6'b100010;
      may_invert6b = 1'b1;
      disparity6b = 1'b1;
    end
    5'd30: begin
      data6b = 6'b100001;
      may_invert6b = 1'b1;
      disparity6b = 1'b1;
    end
    default: begin
      data6b = 6'b001010;
      may_invert6b = 1'b1;
      disparity6b = 1'b1;
    end
    endcase
  end
end

always @(*) begin
  if (in_charisk == 1'b1) begin
    alt7 = 1'b1;
  end else begin
//    case (in_char[4:0])
//    5'd11, 5'd13, 5'd14: alt7 = in_disparity;
//    5'd17, 5'd18, 5'd20: alt7 = ~in_disparity;
//    default: alt7 = 1'b0;
//    endcase

      // Slightly better packing
      case ({may_invert6b,data6b[5:4]})
      3'b000: alt7 = in_disparity;
      3'b011: alt7 = ~in_disparity;
      default: alt7 = 1'b0;
      endcase
  end
end

always @(*) begin
  case (in_char[7:5])
  3'd0: begin
    data4b = 4'b0010;
    may_invert4b = 1'b1;
    disparity4b = 1'b1;
  end
  3'd1: begin
    data4b = 4'b1001;
    may_invert4b = in_charisk;
    disparity4b = 1'b0;
  end
  3'd2: begin
    data4b = 4'b1010;
    may_invert4b = in_charisk;
    disparity4b = 1'b0;
  end
  3'd3: begin
    data4b = 4'b1100;
    may_invert4b = 1'b1;
    disparity4b = 1'b0;
  end
  3'd4: begin
    data4b = 4'b0100;
    may_invert4b = 1'b1;
    disparity4b = 1'b1;
  end
  3'd5: begin
    data4b = 4'b0101;
    may_invert4b = in_charisk;
    disparity4b = 1'b0;
  end
  3'd6: begin
    data4b = 4'b0110;
    may_invert4b = in_charisk;
    disparity4b = 1'b0;
  end
  default: begin
    if (alt7 == 1'b1) begin
      data4b = 4'b0001;
    end else begin
      data4b = 4'b1000;
    end
    may_invert4b = 1'b1;
    disparity4b = 1'b1;
  end
  endcase
end

assign disparity4b_in = in_disparity ^ disparity6b;
assign out_disparity = disparity4b_in ^ disparity4b;

always @(*) begin
  if (in_disparity == 1'b0 && may_invert6b == 1'b1) begin
    out6b = ~data6b;
  end else begin
    out6b = data6b;
  end
  if (disparity4b_in == 1'b0 && may_invert4b == 1'b1) begin
    out4b = ~data4b;
  end else begin
    out4b = data4b;
  end
end

assign out_char = {out4b,out6b};

endmodule
