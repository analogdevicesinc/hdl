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

module jesd204_up_tx # (
  parameter NUM_LANES = 1,
  parameter NUM_LINKS = 1
) (
  input up_clk,
  input up_reset,

  input [11:0] up_raddr,
  output reg [31:0] up_rdata,
  input up_wreq,
  input [11:0] up_waddr,
  input [31:0] up_wdata,

  input up_cfg_is_writeable,

  output reg up_cfg_skip_ilas,
  output reg up_cfg_continuous_ilas,
  output reg up_cfg_continuous_cgs,
  output reg [7:0] up_cfg_mframes_per_ilas,

  input core_clk,
  input core_ilas_config_rd,
  input [1:0] core_ilas_config_addr,
  output reg [32*NUM_LANES-1:0] core_ilas_config_data,

  output core_ctrl_manual_sync_request,

  input [1:0] core_status_state,
  input [NUM_LINKS-1:0] core_status_sync
);

reg [31:0] up_cfg_ilas_data[0:NUM_LANES-1][0:3];
reg up_ctrl_manual_sync_request = 1'b0;

wire [1:0] up_status_state;
wire [NUM_LINKS-1:0] up_status_sync;

sync_bits #(
  .NUM_OF_BITS (NUM_LINKS))
i_cdc_sync (
  .in_bits(core_status_sync),
  .out_clk(up_clk),
  .out_resetn(1'b1),
  .out_bits(up_status_sync)
);

sync_data #(
  .NUM_OF_BITS(2)
) i_cdc_status (
  .in_clk(core_clk),
  .in_data(core_status_state),
  .out_clk(up_clk),
  .out_data(up_status_state)
);

sync_event #(
  .NUM_OF_EVENTS(1),
  .ASYNC_CLK(1)
) i_cdc_manual_sync_request (
  .in_clk(up_clk),
  .in_event(up_ctrl_manual_sync_request),
  .out_clk(core_clk),
  .out_event(core_ctrl_manual_sync_request)
);

integer i;

always @(*) begin
  case (up_raddr)
  /* JESD TX configuration */
  12'h090: up_rdata = {
    /* 03-31 */ 29'h00, /* Reserved for future additions */
    /*    02 */ up_cfg_skip_ilas, /* Don't send ILAS, go directly from CGS to DATA */
    /*    01 */ up_cfg_continuous_ilas, /* Continuously send ILAS sequence */
    /*    00 */ up_cfg_continuous_cgs /* Continuously send CGS characters */
  };
  12'h091: up_rdata = {
    /* 08-31 */ 24'h00, /* Reserved for future additions */
    /* 00-07 */ up_cfg_mframes_per_ilas /* Number of multiframes send during the ILAS */
  };

  /* JESD TX status */
  12'ha0: up_rdata = {
    /* 12-31 */ 20'h00, /* Reserved for future additions */
    /* 04-11 */ up_status_sync, /* Raw value of the SYNC pin */
    /* 02-03 */ 2'b0, /* Reserved fo future extension of the status_state field */
    /* 00-01 */ up_status_state /* State of the internal state machine (0=CGS, 1=ILAS, 2=DATA) */
  };
  default: begin
    if (up_raddr[10:3] >= ('h300/32) &&
        up_raddr[10:3] < (('h300/32) + NUM_LANES) &&
      up_raddr[2] == 1'b1) begin
      up_rdata = up_cfg_ilas_data[up_raddr[5:3]][up_raddr[1:0]];
    end else begin
       up_rdata = 32'h00000000;
    end
  end
  endcase

end

always @(posedge up_clk) begin
  if (up_reset == 1'b1) begin
    up_cfg_skip_ilas <= 1'b0;
    up_cfg_continuous_ilas <= 1'b0;
    up_cfg_continuous_cgs <= 1'b0;
    up_cfg_mframes_per_ilas <= 'h3;
  end else if (up_wreq == 1'b1 && up_cfg_is_writeable == 1'b1) begin
    case (up_waddr)
    /* JESD TX configuraton */
    12'h090: begin
      up_cfg_skip_ilas <= up_wdata[2];
      up_cfg_continuous_ilas <= up_wdata[1];
      up_cfg_continuous_cgs <= up_wdata[0];
    end
    12'h091: begin
//      We'll enable this if we ever have a usecase
//      cfg_mframes_per_ilas <= up_wdata[7:0];
    end
    endcase
  end
end

always @(posedge up_clk) begin
  if (up_reset == 1'b1) begin
    up_ctrl_manual_sync_request <= 1'b0;
  end else if (up_wreq == 1'b1 && up_waddr == 12'h092) begin
    up_ctrl_manual_sync_request <= up_wdata[0];
  end else begin
    up_ctrl_manual_sync_request <= 1'b0;
  end
end

/* Shared ILAS data can be access through any lane register map window */

/* Shared ILAS data */
reg [7:0] up_cfg_ilas_data_did = 'h00;
reg [3:0] up_cfg_ilas_data_bid = 'h00;
reg [4:0] up_cfg_ilas_data_l = 'h00;
reg up_cfg_ilas_data_scr = 'h00;
reg [7:0] up_cfg_ilas_data_f = 'h00;
reg [4:0] up_cfg_ilas_data_k = 'h00;
reg [7:0] up_cfg_ilas_data_m = 'h00;
reg [4:0] up_cfg_ilas_data_n = 'h00;
reg [1:0] up_cfg_ilas_data_cs = 'h00;
reg [4:0] up_cfg_ilas_data_np = 'h00;
reg [2:0] up_cfg_ilas_data_subclassv = 'h00;
reg [4:0] up_cfg_ilas_data_s = 'h00;
reg [2:0] up_cfg_ilas_data_jesdv = 'h00;
reg [4:0] up_cfg_ilas_data_cf = 'h00;
reg up_cfg_ilas_data_hd = 'h00;

/* Per lane ILAS data */
reg [4:0] up_cfg_ilas_data_lid[0:NUM_LANES-1];
reg [7:0] up_cfg_ilas_data_fchk[0:NUM_LANES-1];

always @(*) begin
  for (i = 0; i < NUM_LANES; i = i + 1) begin
    up_cfg_ilas_data[i][0] = {
      4'b0000,
      up_cfg_ilas_data_bid,
      up_cfg_ilas_data_did,
      16'h00
    };
    up_cfg_ilas_data[i][1] = {
      3'b000,
      up_cfg_ilas_data_k,
      up_cfg_ilas_data_f,
      up_cfg_ilas_data_scr,
      2'b00,
      up_cfg_ilas_data_l,
      3'b000,
      up_cfg_ilas_data_lid[i]
    };
    up_cfg_ilas_data[i][2] = {
      up_cfg_ilas_data_jesdv,
      up_cfg_ilas_data_s,
      up_cfg_ilas_data_subclassv,
      up_cfg_ilas_data_np,
      up_cfg_ilas_data_cs,
      1'b0,
      up_cfg_ilas_data_n,
      up_cfg_ilas_data_m
    };
    up_cfg_ilas_data[i][3] = {
      up_cfg_ilas_data_fchk[i],
      16'h0000,
      up_cfg_ilas_data_hd,
      2'b00,
      up_cfg_ilas_data_cf
    };
  end
end

always @(posedge up_clk) begin
  if (up_reset == 1'b1) begin
    up_cfg_ilas_data_did <= 'h00;
    up_cfg_ilas_data_bid <= 'h00;
    up_cfg_ilas_data_scr <= 'h00;
    up_cfg_ilas_data_f <= 'h00;
    up_cfg_ilas_data_k <= 'h00;
    up_cfg_ilas_data_m <= 'h00;
    up_cfg_ilas_data_n <= 'h00;
    up_cfg_ilas_data_cs <= 'h00;
    up_cfg_ilas_data_np <= 'h00;
    up_cfg_ilas_data_subclassv <= 'h00;
    up_cfg_ilas_data_s <= 'h00;
    up_cfg_ilas_data_jesdv <= 'h00;
    up_cfg_ilas_data_cf <= 'h00;
    up_cfg_ilas_data_hd <= 'h00;
    up_cfg_ilas_data_l <= 'h00;
    for (i = 0; i < NUM_LANES; i = i + 1) begin
      up_cfg_ilas_data_lid[i] <= 'h00;
      up_cfg_ilas_data_fchk[i] <= 'h00;
    end
  end else if (up_wreq == 1'b1 && up_cfg_is_writeable == 1'b1) begin
    for (i = 0; i < NUM_LANES; i = i + 1) begin
      if (up_waddr[10:2] == ('h310 / 16) + i*2) begin
        case (up_waddr[1:0])
          2'h0: begin
            up_cfg_ilas_data_bid <= up_wdata[27:24];
            up_cfg_ilas_data_did <= up_wdata[23:16];
          end
          2'h1: begin
            up_cfg_ilas_data_k <= up_wdata[28:24];
            up_cfg_ilas_data_f <= up_wdata[23:16];
            up_cfg_ilas_data_scr <= up_wdata[15];
            up_cfg_ilas_data_l <= up_wdata[12:8];
            up_cfg_ilas_data_lid[i] <= up_wdata[4:0];
          end
          2'h2: begin
            up_cfg_ilas_data_jesdv <= up_wdata[31:29];
            up_cfg_ilas_data_s <= up_wdata[28:24];
            up_cfg_ilas_data_subclassv <= up_wdata[23:21];
            up_cfg_ilas_data_np <= up_wdata[20:16];
            up_cfg_ilas_data_cs <= up_wdata[15:14];
            up_cfg_ilas_data_n <= up_wdata[12:8];
            up_cfg_ilas_data_m <= up_wdata[7:0];
          end
          2'h3: begin
            up_cfg_ilas_data_fchk[i] <= up_wdata[31:24];
            up_cfg_ilas_data_hd <= up_wdata[7];
            up_cfg_ilas_data_cf <= up_wdata[4:0];
          end
        endcase
      end
    end
  end
end

always @(posedge core_clk) begin
  if (core_ilas_config_rd == 1'b1) begin
    for (i = 0; i < NUM_LANES; i = i + 1) begin
      core_ilas_config_data[i*32+:32] <= up_cfg_ilas_data[i][core_ilas_config_addr];
    end
  end
end

endmodule
