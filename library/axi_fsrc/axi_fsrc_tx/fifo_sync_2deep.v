// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/1ns

module fifo_sync_2deep #(
  parameter DWIDTH  = 8,
  parameter DORESET = 1'b1,
  parameter REGISTER_INTERFACE = 1'b0
) (
  input   wire              aclk,
  input   wire              aresetn,

  input   wire              m_tready,
  output  wire [DWIDTH-1:0] m_tdata,
  output  wire              m_tvalid,
  output  wire              m_tvalid_next,

  output  wire              s_tready,
  output  wire              s_tready_next,
  input   wire [DWIDTH-1:0] s_tdata,
  input   wire              s_tvalid,

  output  reg  [1:0]        cnt
);

  reg               wptr;
  reg               rptr;
  wire              fifo_we;
  wire              fifo_re;
  reg [DWIDTH-1:0]  data[1:0];

  assign  fifo_we   = s_tvalid & s_tready;
  assign  fifo_re   = m_tvalid & m_tready;

  assign s_tready_next = !(|cnt) || fifo_re || (!cnt[1] && !fifo_we);
  assign m_tvalid_next = cnt[1] || fifo_we || (cnt[0] && !fifo_re);

  if(!REGISTER_INTERFACE) begin : no_reg_gen
    assign  s_tready  = ~cnt[1];
    assign  m_tvalid  = |cnt;
    assign  m_tdata   = data[rptr];
  end else begin : reg_gen
    reg               s_tready_r;
    reg               m_tvalid_r;
    reg [DWIDTH-1:0]  dout;

    always @(posedge aclk) begin
      if(~aresetn) begin
        s_tready_r <= 1'b0;
        m_tvalid_r <= 1'b0;
      end else begin
        s_tready_r <= s_tready_next;
        m_tvalid_r <= m_tvalid_next;
      end
    end

    always @(posedge aclk) begin
      if (~aresetn & DORESET) begin
        dout <= {DWIDTH{1'b0}};
      end else begin
        if((cnt == 2'b00) && fifo_we) begin
          dout <= s_tdata;
        end else if(fifo_re) begin
          if(cnt == 2'b01) begin
            dout <= s_tdata;
          end else begin
            dout <= data[~rptr];
          end
        end
      end
    end

    assign s_tready = s_tready_r;
    assign m_tvalid = m_tvalid_r;
    assign m_tdata  = dout;
  end

  always @(posedge aclk) begin
    if(~aresetn) begin
      cnt <= 2'd0;
    end else begin
      case({fifo_we,fifo_re})
      2'b01   : cnt <= cnt - 1;
      2'b10   : cnt <= cnt + 1;
      default : cnt <= cnt;
      endcase
    end
  end

  always @(posedge aclk) wptr <= ~aresetn ? 1'b0 : fifo_we ? ~wptr : wptr;
  always @(posedge aclk) rptr <= ~aresetn ? 1'b0 : fifo_re ? ~rptr : rptr;

  always @(posedge aclk) begin
    if (~aresetn & DORESET) begin
      data[0] <= {DWIDTH{1'b0}};
      data[1] <= {DWIDTH{1'b0}};
    end else begin
      if(fifo_we) begin
        data[wptr] <= s_tdata;
      end
    end
  end

endmodule
