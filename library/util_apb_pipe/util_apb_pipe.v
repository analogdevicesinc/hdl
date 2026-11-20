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

`timescale 1ns/100ps

// APB pipeline of NUM_OF_STAGES registered stages (util_apb_pipe_stage),
// each stage adds wait states to the transfer.

module util_apb_pipe #(
  parameter   ADDRESS_WIDTH = 32,
  parameter   DATA_WIDTH = 32,
  parameter   NUM_OF_STAGES = 1
) (

  input                           clk,
  input                           resetn,

  // apb slave port

  input       [ADDRESS_WIDTH-1:0] s_apb_paddr,
  input                           s_apb_psel,
  input                           s_apb_penable,
  input                           s_apb_pwrite,
  input       [DATA_WIDTH-1:0]    s_apb_pwdata,
  output      [DATA_WIDTH-1:0]    s_apb_prdata,
  output                          s_apb_pready,
  output                          s_apb_pslverr,

  // apb master port

  output      [ADDRESS_WIDTH-1:0] m_apb_paddr,
  output                          m_apb_psel,
  output                          m_apb_penable,
  output                          m_apb_pwrite,
  output      [DATA_WIDTH-1:0]    m_apb_pwdata,
  input       [DATA_WIDTH-1:0]    m_apb_prdata,
  input                           m_apb_pready,
  input                           m_apb_pslverr
);

  // stage interconnect, index 0 is the slave port, NUM_OF_STAGES the master port

  wire        [ADDRESS_WIDTH-1:0] paddr_s [0:NUM_OF_STAGES];
  wire                            psel_s [0:NUM_OF_STAGES];
  wire                            penable_s [0:NUM_OF_STAGES];
  wire                            pwrite_s [0:NUM_OF_STAGES];
  wire        [DATA_WIDTH-1:0]    pwdata_s [0:NUM_OF_STAGES];
  wire        [DATA_WIDTH-1:0]    prdata_s [0:NUM_OF_STAGES];
  wire                            pready_s [0:NUM_OF_STAGES];
  wire                            pslverr_s [0:NUM_OF_STAGES];

  assign paddr_s[0] = s_apb_paddr;
  assign psel_s[0] = s_apb_psel;
  assign penable_s[0] = s_apb_penable;
  assign pwrite_s[0] = s_apb_pwrite;
  assign pwdata_s[0] = s_apb_pwdata;
  assign s_apb_prdata = prdata_s[0];
  assign s_apb_pready = pready_s[0];
  assign s_apb_pslverr = pslverr_s[0];

  assign m_apb_paddr = paddr_s[NUM_OF_STAGES];
  assign m_apb_psel = psel_s[NUM_OF_STAGES];
  assign m_apb_penable = penable_s[NUM_OF_STAGES];
  assign m_apb_pwrite = pwrite_s[NUM_OF_STAGES];
  assign m_apb_pwdata = pwdata_s[NUM_OF_STAGES];
  assign prdata_s[NUM_OF_STAGES] = m_apb_prdata;
  assign pready_s[NUM_OF_STAGES] = m_apb_pready;
  assign pslverr_s[NUM_OF_STAGES] = m_apb_pslverr;

  genvar n;
  generate
  for (n = 0; n < NUM_OF_STAGES; n = n + 1) begin: g_stage
    util_apb_pipe_stage #(
      .ADDRESS_WIDTH (ADDRESS_WIDTH),
      .DATA_WIDTH (DATA_WIDTH)
    ) i_stage (
      .clk (clk),
      .resetn (resetn),
      .s_apb_paddr (paddr_s[n]),
      .s_apb_psel (psel_s[n]),
      .s_apb_penable (penable_s[n]),
      .s_apb_pwrite (pwrite_s[n]),
      .s_apb_pwdata (pwdata_s[n]),
      .s_apb_prdata (prdata_s[n]),
      .s_apb_pready (pready_s[n]),
      .s_apb_pslverr (pslverr_s[n]),
      .m_apb_paddr (paddr_s[n+1]),
      .m_apb_psel (psel_s[n+1]),
      .m_apb_penable (penable_s[n+1]),
      .m_apb_pwrite (pwrite_s[n+1]),
      .m_apb_pwdata (pwdata_s[n+1]),
      .m_apb_prdata (prdata_s[n+1]),
      .m_apb_pready (pready_s[n+1]),
      .m_apb_pslverr (pslverr_s[n+1]));
  end
  endgenerate

endmodule
