// ***************************************************************************
// ***************************************************************************
// Copyright 2017(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************

module cic_comb #(
  parameter DATA_WIDTH = 32,
  parameter SEQ = 1
) (
  input clk,
  input ce,
  input [DATA_WIDTH-1:0] data_in,
  output [DATA_WIDTH-1:0] data_out
);

reg [SEQ-1:0] storage[0:DATA_WIDTH-1];
reg [DATA_WIDTH-1:0] state = 'h00;

reg [2:0] counter = 'h00;
reg active = 1'b0;

integer x;

initial begin
  for (x = 0; x < DATA_WIDTH; x = x + 1) begin
    storage[x] = 'h00;
  end
end

generate if (SEQ != 1) begin

always @(posedge clk) begin
  if (ce == 1'b1) begin
    counter <= SEQ-1;
    active <= 1'b1;
  end else if (active == 1'b1) begin
    counter <= counter - 1'b1;
    if (counter == 'h1) begin
      active <= 1'b0;
    end
  end
end

end
endgenerate

reg [DATA_WIDTH-1:0] data_in_seq;
wire [DATA_WIDTH-1:0] storage_out;

always @(*) begin
  if (ce == 1'b1) begin
    data_in_seq <= data_in;
  end else begin
    data_in_seq <= SEQ != 1 ? state : 'h00;
  end
end

always @(posedge clk) begin
  if (ce == 1'b1 || active == 1'b1) begin
    state <= data_in_seq - storage_out;
  end
end

generate
  genvar i;

  for (i = 0; i < DATA_WIDTH; i = i + 1) begin: shift_r
    always @(posedge clk) begin
      if (ce == 1'b1 || active == 1'b1) begin
        if (SEQ > 1) begin
          storage[i] <= {storage[i][SEQ-2:0],data_in_seq[i]};
        end else begin
          storage[i] <= data_in_seq[i];
        end
      end
    end

    assign storage_out[i] = storage[i][SEQ-1];
  end
endgenerate

assign data_out = state;

endmodule
