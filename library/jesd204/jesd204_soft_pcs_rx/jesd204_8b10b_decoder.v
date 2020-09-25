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

module jesd204_8b10b_decoder (
  input in_disparity,
  input [9:0] in_char,

  output [7:0] out_char,
  output out_charisk,
  output out_notintable,
  output reg out_disperr,
  output reg out_disparity
);

/*
 * Only supports the subset of 8b10b that is used by JESD204.
 * If non-supported control characters are supplied the output is undefined.
 */

reg [4:0] data5b;
reg notintable5b;
reg [1:0] disparity5b;
reg ignore5b;
reg [2:0] data3b;
reg notintable3b;
reg [1:0] disparity3b;
reg ignore3b;
reg [1:0] total_disparity;
reg notintable_disparity;

// Only detect K28.X
wire charisk = in_char[5:0] == 6'b000011 || in_char[5:0] == 6'b111100;

always @(*) begin
  notintable5b = 1'b0;
  disparity5b = 2'b00;
  ignore5b = 1'b0;

  case (in_char[5:0])
  6'b000011: begin
    data5b = 5'd28;
    disparity5b = 2'b11;
  end
  6'b111100: begin
    data5b = 5'd28;
    disparity5b = 2'b01;
  end
  6'b000110: begin
    data5b = 5'd00;
    disparity5b = 2'b11;
  end
  6'b111001: begin
    data5b = 5'd00;
    disparity5b = 2'b01;
  end
  6'b010001: begin
    data5b = 5'd01;
    disparity5b = 2'b11;
  end
  6'b101110: begin
    data5b = 5'd01;
    disparity5b = 2'b01;
  end
  6'b010010: begin
    data5b = 5'd02;
    disparity5b = 2'b11;
  end
  6'b101101: begin
    data5b = 5'd02;
    disparity5b = 2'b01;
  end
  6'b100011: begin
    data5b = 5'd03;
  end
  6'b010100: begin
    data5b = 5'd04;
    disparity5b = 2'b11;
  end
  6'b101011: begin
    data5b = 5'd04;
    disparity5b = 2'b01;
  end
  6'b100101: begin
    data5b = 5'd05;
  end
  6'b100110: begin
    data5b = 5'd06;
  end
  6'b000111: begin
    data5b = 5'd7;
    disparity5b = 2'b11;
    ignore5b = 1'b1;
  end
  6'b111000: begin
    data5b = 5'd7;
    disparity5b = 2'b01;
    ignore5b = 1'b1;
  end
  6'b011000: begin
    data5b = 5'd8;
    disparity5b = 2'b11;
  end
  6'b100111: begin
    data5b = 5'd8;
    disparity5b = 2'b01;
  end
  6'b101001: begin
    data5b = 5'd9;
  end
  6'b101010: begin
    data5b = 5'd10;
  end
  6'b001011: begin
    data5b = 5'd11;
  end
  6'b101100: begin
    data5b = 5'd12;
  end
  6'b001101: begin
    data5b = 5'd13;
  end
  6'b001110: begin
    data5b = 5'd14;
  end
  6'b000101: begin
    data5b = 5'd15;
    disparity5b = 2'b11;
  end
  6'b111010: begin
    data5b = 5'd15;
    disparity5b = 2'b01;
  end
  6'b001001: begin
    data5b = 5'd16;
    disparity5b = 2'b11;
  end
  6'b110110: begin
    data5b = 5'd16;
    disparity5b = 2'b01;
  end
  6'b110001: begin
    data5b = 5'd17;
  end
  6'b110010: begin
    data5b = 5'd18;
  end
  6'b010011: begin
    data5b = 5'd19;
  end
  6'b110100: begin
    data5b = 5'd20;
  end
  6'b010101: begin
    data5b = 5'd21;
  end
  6'b010110: begin
    data5b = 5'd22;
  end
  6'b101000: begin
    data5b = 5'd23;
    disparity5b = 2'b11;
  end
  6'b010111: begin
    data5b = 5'd23;
    disparity5b = 2'b01;
  end
  6'b001100: begin
    data5b = 5'd24;
    disparity5b = 2'b11;
  end
  6'b110011: begin
    data5b = 5'd24;
    disparity5b = 2'b01;
  end
  6'b011001: begin
    data5b = 5'd25;
  end
  6'b011010: begin
    data5b = 5'd26;
  end
  6'b100100: begin
    data5b = 5'd27;
    disparity5b = 2'b11;
  end
  6'b011011: begin
    data5b = 5'd27;
    disparity5b = 2'b01;
  end
  6'b011100: begin
    data5b = 5'd28;
  end
  6'b100010: begin
    data5b = 5'd29;
    disparity5b = 2'b11;
  end
  6'b011101: begin
    data5b = 5'd29;
    disparity5b = 2'b01;
  end
  6'b100001: begin
    data5b = 5'd30;
    disparity5b = 2'b11;
  end
  6'b011110: begin
    data5b = 5'd30;
    disparity5b = 2'b01;
  end
  6'b001010: begin
    data5b = 5'd31;
    disparity5b = 2'b11;
  end
  6'b110101: begin
    data5b = 5'd31;
    disparity5b = 2'b01;
  end
  default: begin
    data5b = 5'd00;
    notintable5b = 1'b1;
  end
  endcase
end

always @(*) begin
  ignore3b = 1'b0;

  case (in_char[9:6])
  4'b0010: begin
    disparity3b = 2'b11;
  end
  4'b1101: begin
    disparity3b = 2'b01;
  end
  4'b1100: begin
    disparity3b = 2'b11;
    ignore3b = 1'b1;
  end
  4'b0011: begin
    disparity3b = 2'b01;
    ignore3b = 1'b1;
  end
  4'b0100: begin
    disparity3b = 2'b11;
  end
  4'b1011: begin
    disparity3b = 2'b01;
  end
  4'b1000: begin
    disparity3b = 2'b11;
  end
  4'b0111: begin
    disparity3b = 2'b01;
  end
  4'b0001: begin
    disparity3b = 2'b11;
  end
  4'b1110: begin
    disparity3b = 2'b01;
  end
  default: begin
    disparity3b = 2'b00;
  end
  endcase
end

always @(*) begin
  notintable3b = 1'b0;

  if (charisk == 1'b1) begin
    case (in_char[9:6] ^ {4{in_char[5]}})
    4'b1101: begin
      data3b = 3'd0;
    end
    4'b0011: begin
      data3b = 3'd3;
    end
    4'b1011: begin
      data3b = 3'd4;
    end
    4'b1010: begin
      data3b = 3'd5;
    end
    4'b1110: begin
      data3b = 3'd7;
    end
    default: begin
      data3b = 3'd0;
      notintable3b = 1'b1;
    end
    endcase
  end else begin
    case (in_char[9:6])
    4'b0010: begin
      data3b = 3'd0;
    end
    4'b1101: begin
      data3b = 3'd0;
    end
    4'b1001: begin
      data3b = 3'd1;
    end
    4'b1010: begin
      data3b = 3'd2;
    end
    4'b1100: begin
      data3b = 3'd3;
    end
    4'b0011: begin
      data3b = 3'd3;
    end
    4'b0100: begin
      data3b = 3'd4;
    end
    4'b1011: begin
      data3b = 3'd4;
    end
    4'b0101: begin
      data3b = 3'd5;
    end
    4'b0110: begin
      data3b = 3'd6;
    end
    4'b1000: begin
      data3b = 3'd7;
      notintable3b = in_char[5:4] == 2'b00;
    end
    4'b0111: begin
      data3b = 3'd7;
      notintable3b = in_char[5:4] == 2'b11;
    end
    4'b0001: begin
      data3b = 3'd7;
      notintable3b = in_char[5:4] != 2'b00;
    end
    4'b1110: begin
      data3b = 3'd7;
      notintable3b = in_char[5:4] != 2'b11;
    end
    default: begin
      data3b = 3'd0;
      notintable3b = 1'b1;
    end
    endcase
  end
end

always @(*) begin
  if (disparity3b == disparity5b && disparity3b != 2'b00) begin
    notintable_disparity = 1'b1;
  end else begin
    notintable_disparity = 1'b0;
  end
end

always @(*) begin
  total_disparity = (ignore3b ? 2'b00 : disparity3b) ^ (ignore5b ? 2'b00 : disparity5b);

  if (total_disparity[0] == 1'b0 || out_notintable == 1'b1) begin
    out_disparity = in_disparity;
    out_disperr = 1'b0;
  end else if (total_disparity[1] == 1'b1) begin
    out_disparity = 1'b0;
    out_disperr = ~in_disparity;
  end else begin
    out_disparity = 1'b1;
    out_disperr = in_disparity;
  end
end

assign out_char = {data3b,data5b};
assign out_charisk = charisk;
assign out_notintable = notintable5b | notintable3b | notintable_disparity;

endmodule
