// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
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

`include "i3c_controller_regmap.vh"

module i3c_controller_regmap #(
  parameter CMD_FIFO_ADDRESS_WIDTH = 4,
  parameter CMDR_FIFO_ADDRESS_WIDTH = 4,
  parameter SDO_FIFO_ADDRESS_WIDTH = 5,
  parameter SDI_FIFO_ADDRESS_WIDTH = 5,
  parameter IBI_FIFO_ADDRESS_WIDTH = 4,
  parameter ID = 0,
  parameter DA = 7'h31,
  parameter ASYNC_CLK = 0,
  parameter OFFLOAD = 1,
  parameter DATA_WIDTH = 32,
  parameter PID_MANUF_ID = 15'b0,
  parameter PID_TYPE_SELECTOR = 1'b1,
  parameter PID_PART_ID = 16'b0,
  parameter PID_INSTANCE_ID = 4'b0,
  parameter PID_EXTRA_ID = 12'b0
) (

  // Slave AXI interface

  input         s_axi_aclk,
  input         s_axi_aresetn,
  input         s_axi_awvalid,
  input  [15:0] s_axi_awaddr,
  output        s_axi_awready,
  input   [2:0] s_axi_awprot,
  input         s_axi_wvalid,
  input  [31:0] s_axi_wdata,
  input  [ 3:0] s_axi_wstrb,
  output        s_axi_wready,
  output        s_axi_bvalid,
  output [ 1:0] s_axi_bresp,
  input         s_axi_bready,
  input         s_axi_arvalid,
  input  [15:0] s_axi_araddr,
  output        s_axi_arready,
  input   [2:0] s_axi_arprot,
  output        s_axi_rvalid,
  input         s_axi_rready,
  output [ 1:0] s_axi_rresp,
  output [31:0] s_axi_rdata,

  output reg irq,

  // Core basic signals

  input  clk,
  output a_reset_n,

  // I3C control signals

  input  cmd_ready,
  input  cmd_nop,
  output cmd_valid,
  output [DATA_WIDTH-1:0] cmd,

  output cmdr_ready,
  input  cmdr_valid,
  input  [DATA_WIDTH-1:0] cmdr,

  input  sdo_ready,
  output sdo_valid,
  output [DATA_WIDTH-1:0] sdo,

  output sdi_ready,
  input  sdi_valid,
  input  [DATA_WIDTH-1:0] sdi,

  input  offload_sdi_ready,
  output offload_sdi_valid,
  output [DATA_WIDTH-1:0] offload_sdi,

  output ibi_ready,
  input  ibi_valid,
  input  [DATA_WIDTH-1:0] ibi,

  input  daa_trigger,
  input  offload_trigger,

  // uP accessible info

  output reg [1:0] rmap_ibi_config,
  output     [1:0] rmap_pp_sg,
  input      [6:0] rmap_dev_char_addr,
  output     [3:0] rmap_dev_char_data
);

  localparam [31:0] CORE_VERSION = {16'h0001,     /* MAJOR */
                                     8'h00,       /* MINOR */
                                     8'h01};      /* PATCH */

  reg [31:0] up_scratch  = 32'h00; // Scratch register
  reg [31:0] up_pid_l  = {PID_PART_ID, PID_INSTANCE_ID, PID_EXTRA_ID};
  reg [31:0] up_pid_h  = {16'd0, PID_MANUF_ID, PID_TYPE_SELECTOR};
  reg [6:0]  up_da  = DA;
  reg [7:0]  up_bcr = 'h40;
  reg [7:0]  up_dcr = 'h00;
  reg        up_sw_reset = 1'b1;
  reg [31:0] up_rdata_ff = 32'd0;
  reg        up_wack_ff  = 1'b0;
  reg        up_rack_ff  = 1'b0;

  reg        cmdr_fifo_valid_r;
  reg        ibi_fifo_valid_r;
  reg        daa_trigger_r;
  reg        cmdr_pending;
  reg        ibi_pending;
  reg        daa_pending;

  reg  [`I3C_REGMAP_IRQ_WIDTH:0] up_irq_mask = 8'h0;
  reg  [6:0] ops;
  reg  [6:0] ops_candidate;
  reg  [6:0] dev_char_addr_reg;

  // CMD FIFO

  wire [CMD_FIFO_ADDRESS_WIDTH-1:0] cmd_fifo_room;
  wire cmd_fifo_almost_empty;
  wire up_cmd_fifo_almost_empty;

  wire [DATA_WIDTH-1:0] cmd_fifo_data;
  wire cmd_fifo_ready;
  wire cmd_fifo_valid;

  // CMDR FIFO

  wire cmdr_fifo_data_msb_s;
  wire [CMDR_FIFO_ADDRESS_WIDTH-1:0] cmdr_fifo_level;
  wire cmdr_fifo_almost_full;
  wire up_cmdr_fifo_almost_full;

  wire [DATA_WIDTH-1:0] cmdr_fifo_data;
  wire cmdr_fifo_ready;
  wire cmdr_fifo_valid;
  wire cmdr_fifo_empty;

  // SDO FIFO

  wire [SDO_FIFO_ADDRESS_WIDTH-1:0] sdo_fifo_room;
  wire sdo_fifo_almost_empty;
  wire up_sdo_fifo_almost_empty;

  wire [DATA_WIDTH-1:0] sdo_fifo_data;
  wire sdo_fifo_ready;
  wire sdo_fifo_valid;
  wire sdo_fifo_empty;

  // SDI FIFO

  wire sdi_fifo_data_msb_s;
  wire [SDI_FIFO_ADDRESS_WIDTH-1:0] sdi_fifo_level;
  wire sdi_fifo_almost_full;
  wire up_sdi_fifo_almost_full;

  wire [DATA_WIDTH-1:0] sdi_fifo_data;
  wire sdi_fifo_ready;
  wire sdi_fifo_valid;
  wire sdi_fifo_empty;

  // IBI FIFO

  wire ibi_fifo_data_msb_s;
  wire [IBI_FIFO_ADDRESS_WIDTH-1:0] ibi_fifo_level;
  wire ibi_fifo_almost_full;
  wire up_ibi_fifo_almost_full;

  wire [DATA_WIDTH-1:0] ibi_fifo_data;
  wire ibi_fifo_ready;
  wire ibi_fifo_valid;
  wire ibi_fifo_empty;

  wire up_sw_resetn = ~up_sw_reset;

  wire [31:0] up_rdata_ff_w;
  wire        up_wreq_s;
  wire        up_rreq_s;
  wire [31:0] up_wdata_s;
  wire [13:0] up_waddr_s;
  wire [13:0] up_raddr_s;
  wire        up_cmd_nop;

  // IRQ handling

  wire [`I3C_REGMAP_IRQ_WIDTH:0] up_irq_source;
  wire [`I3C_REGMAP_IRQ_WIDTH:0] up_irq_pending;

  wire       ops_mode;
  wire [3:0] ops_offload_len;
  wire [1:0] ops_sg;
  wire       offload_idle;

  wire [31:0] cmd_w;
  wire cmd_valid_w;
  wire cmd_ready_w;

  wire [6:0] dev_char_addr;
  wire dev_char_w;
  wire dev_char_wea;
  wire dev_char_rea;
  wire dev_char_ea;
  wire [3:0] dev_char_wdata;
  wire [3:0] dev_char_rdata;

  // Offload mode

  wire [31:0] offload_douta;
  wire [31:0] offload_cmd;
  wire [31:0] offload_sdo;
  wire offload_cmd_valid;
  wire offload_sdo_valid;

  wire clk_1;

  wire cmdr_valid_w;
  wire cmdr_ready_w;

  wire [31:0] sdo_w;
  wire sdo_valid_w;
  wire sdo_ready_w;

  // Interface wrapper

  up_axi #(
    .AXI_ADDRESS_WIDTH (16)
  ) i_up_axi (
    .up_rstn(s_axi_aresetn),
    .up_clk(s_axi_aclk),
    .up_axi_awvalid(s_axi_awvalid),
    .up_axi_awaddr(s_axi_awaddr),
    .up_axi_awready(s_axi_awready),
    .up_axi_wvalid(s_axi_wvalid),
    .up_axi_wdata(s_axi_wdata),
    .up_axi_wstrb(s_axi_wstrb),
    .up_axi_wready(s_axi_wready),
    .up_axi_bvalid(s_axi_bvalid),
    .up_axi_bresp(s_axi_bresp),
    .up_axi_bready(s_axi_bready),
    .up_axi_arvalid(s_axi_arvalid),
    .up_axi_araddr(s_axi_araddr),
    .up_axi_arready(s_axi_arready),
    .up_axi_rvalid(s_axi_rvalid),
    .up_axi_rresp(s_axi_rresp),
    .up_axi_rdata(s_axi_rdata),
    .up_axi_rready(s_axi_rready),
    .up_wreq(up_wreq_s),
    .up_waddr(up_waddr_s),
    .up_wdata(up_wdata_s),
    .up_wack(up_wack_ff),
    .up_rreq(up_rreq_s),
    .up_raddr(up_raddr_s),
    .up_rdata(up_rdata_ff_w),
    .up_rack(up_rack_ff));

  assign up_irq_source = {
    daa_pending,
    ibi_pending,
    cmdr_pending,
    up_ibi_fifo_almost_full,
    up_sdi_fifo_almost_full,
    up_sdo_fifo_almost_empty,
    up_cmdr_fifo_almost_full,
    up_cmd_fifo_almost_empty
  };

  assign up_irq_pending = up_irq_mask & up_irq_source;

  always @(posedge s_axi_aclk) begin
    if (s_axi_aresetn == 1'b0) begin
      irq <= 1'b0;
    end else begin
      irq <= |up_irq_pending;
    end
  end

  always @(posedge s_axi_aclk) begin
    if (s_axi_aresetn == 1'b0) begin
      up_wack_ff <= 1'b0;
      up_scratch <= 32'h0;
      up_sw_reset <= 1'b1;
    end else begin
      up_wack_ff <= up_wreq_s;
      if (up_wreq_s) begin
        case (up_waddr_s[7:0])
          `I3C_REGMAP_ENABLE:     up_sw_reset <= up_wdata_s[0];
          `I3C_REGMAP_SCRATCH:    up_scratch <= up_wdata_s;
          `I3C_REGMAP_DCR_BCR_DA: up_da <= up_wdata_s[22:16];
        endcase
      end
    end
  end

  assign ops_mode = ops[0];
  assign ops_offload_len = ops[4:1];
  assign ops_sg = ops[6:5];
  assign rmap_pp_sg = ops_sg;

  always @(posedge s_axi_aclk) begin
    if (!up_sw_resetn) begin
      ops <= 7'b1100000;
    end else if (up_cmd_nop) begin
      if ((~ops_mode & ~cmd_valid_w) | (ops_mode & offload_idle)) begin
        ops <= ops_candidate;
      end
    end
  end

  // the software reset should reset all the registers
  integer i;
  always @(posedge s_axi_aclk) begin
    if (!up_sw_resetn) begin
      up_irq_mask <= 8'h0;
      rmap_ibi_config <= 2'h0;
      ops_candidate <= 7'd0;
    end else begin
      if (up_wreq_s) begin
        case (up_waddr_s[7:0])
          `I3C_REGMAP_IRQ_MASK:   up_irq_mask <= up_wdata_s[`I3C_REGMAP_IRQ_WIDTH:0];
          `I3C_REGMAP_IBI_CONFIG: rmap_ibi_config <= up_wdata_s[1:0];
          `I3C_REGMAP_OPS:        ops_candidate <= up_wdata_s[6:0];
          default: begin
          end
        endcase
      end
    end
  end

  always @(posedge s_axi_aclk) begin
    if (s_axi_aresetn == 1'b0) begin
      up_rack_ff <= 1'd0;
    end else begin
      up_rack_ff <= up_rreq_s;
    end
  end

  always @(posedge s_axi_aclk) begin
    case (up_raddr_s[7:0])
      `I3C_REGMAP_VERSION:        up_rdata_ff <= CORE_VERSION;
      `I3C_REGMAP_DEVICE_ID:      up_rdata_ff <= ID;
      `I3C_REGMAP_SCRATCH:        up_rdata_ff <= up_scratch;
      `I3C_REGMAP_ENABLE:         up_rdata_ff <= up_sw_reset;
      `I3C_REGMAP_PID_L:          up_rdata_ff <= up_pid_l;
      `I3C_REGMAP_PID_H:          up_rdata_ff <= up_pid_h;
      `I3C_REGMAP_DCR_BCR_DA:     up_rdata_ff <= {up_da, up_bcr, up_dcr};
      `I3C_REGMAP_IRQ_MASK:       up_rdata_ff <= up_irq_mask;
      `I3C_REGMAP_IRQ_PENDING:    up_rdata_ff <= up_irq_pending;
      `I3C_REGMAP_IRQ_SOURCE:     up_rdata_ff <= up_irq_source;
      `I3C_REGMAP_CMD_FIFO_ROOM:  up_rdata_ff <= cmd_fifo_room;
      `I3C_REGMAP_CMDR_FIFO_LEVEL:up_rdata_ff <= cmdr_fifo_level;
      `I3C_REGMAP_SDO_FIFO_ROOM:  up_rdata_ff <= sdo_fifo_room;
      `I3C_REGMAP_SDI_FIFO_LEVEL: up_rdata_ff <= sdi_fifo_level;
      `I3C_REGMAP_IBI_FIFO_LEVEL: up_rdata_ff <= ibi_fifo_level;
      `I3C_REGMAP_CMDR_FIFO:      up_rdata_ff <= cmdr_fifo_data;
      `I3C_REGMAP_SDI_FIFO:       up_rdata_ff <= sdi_fifo_data;
      `I3C_REGMAP_IBI_FIFO:       up_rdata_ff <= ibi_fifo_data;
      `I3C_REGMAP_FIFO_STATUS:    up_rdata_ff <= {sdi_fifo_empty, ibi_fifo_empty, cmdr_fifo_empty};
      `I3C_REGMAP_OPS:            up_rdata_ff <= {cmd_nop, ops};
      default:                    up_rdata_ff <= 32'h0;
    endcase
  end

  assign up_rdata_ff_w =  up_raddr_s[7:0] == `I3C_REGMAP_DEV_CHAR     ? {16'b0, dev_char_addr, 5'b0, dev_char_rdata} :
                          up_raddr_s[7:4] == `I3C_REGMAP_OFFLOAD_CMD_ ? offload_douta :
                          up_raddr_s[7:4] == `I3C_REGMAP_OFFLOAD_SDO_ ? offload_douta :
                        ~|up_raddr_s[3:0] ? up_rdata_ff :
                          up_rdata_ff;

  ad_mem_dual #(
    .INITIALIZE(1),
    .DATA_WIDTH(4),
    .ADDRESS_WIDTH(7)
  ) i_mem_dev_char (
    .clka(s_axi_aclk),
    .wea(dev_char_wea),
    .ea(1'b1),
    .addra(dev_char_addr),
    .dina(dev_char_wdata),
    .douta(dev_char_rdata),
    .clkb(s_axi_aclk),
    .web(1'b0),
    .eb(1'b1),
    .addrb(rmap_dev_char_addr),
    .dinb(),
    .doutb(rmap_dev_char_data));

  always @(posedge s_axi_aclk) begin
    if (dev_char_w) begin
      dev_char_addr_reg <= dev_char_addr;
    end
  end

  assign dev_char_wdata = up_wdata_s[3:0];
  assign dev_char_addr  = dev_char_w ? up_wdata_s[15:9] : dev_char_addr_reg;
  assign dev_char_rea   = up_rreq_s == 1'b1 && (up_raddr_s[7:0] == `I3C_REGMAP_DEV_CHAR);
  assign dev_char_w     = up_wreq_s == 1'b1 && (up_waddr_s[7:0] == `I3C_REGMAP_DEV_CHAR);
  assign dev_char_wea   = dev_char_w && up_wdata_s[8];
  assign dev_char_ea    = dev_char_rea | dev_char_wea;

  generate if (OFFLOAD) begin
    localparam [1:0] SM_CMD_GET = 0;
    localparam [1:0] SM_CMD_PUT = 1;
    localparam [1:0] SM_SDO_GET = 2;
    localparam [1:0] SM_SDO_PUT = 3;

    reg [1:0] sm;
    reg [3:0] k;
    reg [3:0] j;
    reg [9:0] offload_sdo_buffer_len;

    wire offload_ea;
    wire offload_wea;
    wire offload_rea;
    wire [4:0] offload_addra;
    wire offload_eb;
    wire [4:0] offload_addrb;
    wire [31:0] offload_doutb;

    ad_mem_dual #(
      .DATA_WIDTH(32),
      .ADDRESS_WIDTH(5)
    ) i_mem_offload (
      .clka(s_axi_aclk),
      .wea(offload_wea),
      .ea(offload_ea),
      .addra(offload_addra),
      .dina(up_wdata_s),
      .douta(offload_douta),
      .clkb(s_axi_aclk),
      .web(1'b0),
      .eb(offload_eb),
      .addrb(offload_addrb),
      .dinb('d0),
      .doutb(offload_doutb));

    assign offload_addra = up_wreq_s ?
                        {up_waddr_s[6], up_waddr_s[3:0]} :
                        {up_raddr_s[6], up_raddr_s[3:0]};
    assign offload_rea = up_rreq_s == 1'b1 &&
                        (up_raddr_s[7:4] == `I3C_REGMAP_OFFLOAD_CMD_ |
                         up_raddr_s[7:4] == `I3C_REGMAP_OFFLOAD_SDO_ );
    assign offload_wea = up_wreq_s == 1'b1 &&
                        (up_waddr_s[7:4] == `I3C_REGMAP_OFFLOAD_CMD_ |
                         up_waddr_s[7:4] == `I3C_REGMAP_OFFLOAD_SDO_ );
    assign offload_ea = offload_rea | offload_wea;

    always @(posedge s_axi_aclk) begin
      if (!a_reset_n | ~ops_mode | ops_offload_len == 0) begin
         offload_sdo_buffer_len <= 0;
         sm <= SM_CMD_GET;
         k <= 'd0;
      end else begin
        // The same BRAM provides both cmd and sdo,
        // therefore a request-like interface is used.
        if (sm[1] == 1'b0) begin
          j <= 0;
        end
        case (sm)
          SM_CMD_GET: begin
            if (offload_trigger | k != 0) begin
              sm <= SM_CMD_PUT;
              k <= k == ops_offload_len - 1 ? 0 : k + 1;
            end
          end
          SM_CMD_PUT: begin
            if (cmd_ready) begin
              sm <= SM_SDO_GET;
              if (~cmd[0]) begin
                offload_sdo_buffer_len <= cmd[19:10] + {9'd0, |cmd[9:8]};
              end
            end
          end
          SM_SDO_GET: begin
            sm <= SM_SDO_PUT;
            j <= j + 1;
          end
          SM_SDO_PUT: begin
            // New payload requested, check if is cmd or sdo.
            if (cmd_ready) begin
              sm <= SM_CMD_GET;
            end else if (sdo_ready) begin
              if (|offload_sdo_buffer_len) begin
                offload_sdo_buffer_len <= offload_sdo_buffer_len - 1;
              end
              sm <= SM_SDO_GET;
            end
          end
        endcase
      end
    end

    assign offload_idle  = sm == SM_CMD_GET & k == 0;
    assign offload_addrb = sm[1] == 1'b0 ? {1'b0,k} : {1'b1,j};
    assign offload_eb    = sm[0] == 1'b0 & ops_mode;
    assign offload_cmd_valid = sm == SM_CMD_PUT;
    assign offload_sdo_valid = sm == SM_SDO_PUT & |offload_sdo_buffer_len;
    assign offload_cmd = offload_doutb;
    assign offload_sdo = offload_doutb;
  end
  endgenerate

  always @(posedge s_axi_aclk) begin
    if (up_sw_resetn == 1'b0) begin
      daa_pending <= 1'b0;
      cmdr_pending <= 1'b0;
      ibi_pending <= 1'b0;
    end else begin
      if (cmdr_fifo_valid == 1'b1 && cmdr_fifo_valid_r == 1'b0) begin
        cmdr_pending <= 1'b1;
      end else if (up_wreq_s == 1'b1 &&
        up_waddr_s[7:0] == `I3C_REGMAP_IRQ_PENDING &&
        up_wdata_s[`I3C_REGMAP_IRQ_CMDR_PENDING] == 1'b1) begin
        cmdr_pending <= 1'b0;
      end
      if (ibi_fifo_valid == 1'b1 && ibi_fifo_valid_r == 1'b0) begin
        ibi_pending <= 1'b1;
      end else if (up_wreq_s == 1'b1 &&
        up_waddr_s[7:0] == `I3C_REGMAP_IRQ_PENDING &&
        up_wdata_s[`I3C_REGMAP_IRQ_IBI_PENDING] == 1'b1) begin
        ibi_pending <= 1'b0;
      end
      if (daa_trigger == 1'b1 && daa_trigger_r == 1'b0) begin
        daa_pending <= 1'b1;
      end else if (up_wreq_s == 1'b1 &&
        up_waddr_s[7:0] == `I3C_REGMAP_IRQ_PENDING &&
        up_wdata_s[`I3C_REGMAP_IRQ_DAA_PENDING] == 1'b1) begin
        daa_pending <= 1'b0;
      end
      cmdr_fifo_valid_r <= cmdr_fifo_valid;
      ibi_fifo_valid_r <= ibi_fifo_valid;
      daa_trigger_r <= daa_trigger;
    end
  end

  generate if (ASYNC_CLK) begin
    wire a_reset;
    ad_rst i_resetn (
      .rst_async(up_sw_reset),
      .clk(clk),
      .rst(a_reset),
      .rstn());
    assign a_reset_n = ~a_reset;
    assign clk_1 = clk;
  end else begin /* ASYNC_CLK == 0 */
    assign a_reset_n = ~up_sw_reset;
    assign clk_1 = s_axi_aclk;
  end
  endgenerate

  assign cmd = ~ops_mode ? cmd_w : offload_cmd;
  assign cmd_valid   = ~ops_mode ? cmd_valid_w : offload_cmd_valid;
  assign cmd_ready_w = ~ops_mode ? cmd_ready   : 1'b0;
  assign cmd_fifo_valid = up_wreq_s == 1'b1 && up_waddr_s[7:0] == `I3C_REGMAP_CMD_FIFO;
  assign cmd_fifo_data = up_wdata_s;

  util_axis_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDRESS_WIDTH(CMD_FIFO_ADDRESS_WIDTH),
    .ASYNC_CLK(ASYNC_CLK),
    .M_AXIS_REGISTERED(0),
    .ALMOST_EMPTY_THRESHOLD(1),
    .ALMOST_FULL_THRESHOLD(1)
  ) i_cmd_fifo (
    .s_axis_aclk(s_axi_aclk),
    .s_axis_aresetn(up_sw_resetn),
    .s_axis_ready(cmd_fifo_ready),
    .s_axis_valid(cmd_fifo_valid),
    .s_axis_data(cmd_fifo_data),
    .s_axis_room(cmd_fifo_room),
    .s_axis_tlast(1'b0),
    .s_axis_full(),
    .s_axis_almost_full(),
    .m_axis_aclk(clk_1),
    .m_axis_aresetn(a_reset_n),
    .m_axis_ready(cmd_ready_w),
    .m_axis_valid(cmd_valid_w),
    .m_axis_data(cmd_w),
    .m_axis_tlast(),
    .m_axis_empty(),
    .m_axis_almost_empty(cmd_fifo_almost_empty),
    .m_axis_level());

  assign cmdr_ready   = ~ops_mode ? cmdr_ready_w : 1'b1; // In offload, discard cmdr
  assign cmdr_valid_w = ~ops_mode ? cmdr_valid   : 1'b0;
  assign cmdr_fifo_ready = up_rreq_s == 1'b1 && up_raddr_s[7:0] == `I3C_REGMAP_CMDR_FIFO;

  util_axis_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .ASYNC_CLK(ASYNC_CLK),
    .ADDRESS_WIDTH(CMDR_FIFO_ADDRESS_WIDTH),
    .M_AXIS_REGISTERED(0),
    .ALMOST_EMPTY_THRESHOLD(1),
    .ALMOST_FULL_THRESHOLD(31)
  ) i_cmdr_fifo (
    .s_axis_aclk(clk_1),
    .s_axis_aresetn(a_reset_n),
    .s_axis_ready(cmdr_ready_w),
    .s_axis_valid(cmdr_valid_w),
    .s_axis_data(cmdr),
    .s_axis_room(),
    .s_axis_tlast(),
    .s_axis_full(),
    .s_axis_almost_full(cmdr_fifo_almost_full),
    .m_axis_aclk(s_axi_aclk),
    .m_axis_aresetn(up_sw_resetn),
    .m_axis_ready(cmdr_fifo_ready),
    .m_axis_valid(cmdr_fifo_valid),
    .m_axis_data(cmdr_fifo_data),
    .m_axis_tlast(),
    .m_axis_level(cmdr_fifo_level),
    .m_axis_empty(cmdr_fifo_empty),
    .m_axis_almost_empty());

  assign sdo = ~ops_mode ? sdo_w : offload_sdo;
  assign sdo_valid   = ~ops_mode ? sdo_valid_w : offload_sdo_valid;
  assign sdo_ready_w = ~ops_mode ? sdo_ready   : 1'b0;
  assign sdo_fifo_valid = up_wreq_s == 1'b1 && up_waddr_s[7:0] == `I3C_REGMAP_SDO_FIFO;
  assign sdo_fifo_data = up_wdata_s[31:0];

  util_axis_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .ASYNC_CLK(ASYNC_CLK),
    .ADDRESS_WIDTH(SDO_FIFO_ADDRESS_WIDTH),
    .M_AXIS_REGISTERED(0),
    .ALMOST_EMPTY_THRESHOLD(1),
    .ALMOST_FULL_THRESHOLD(1)
  ) i_sdo_fifo (
    .s_axis_aclk(s_axi_aclk),
    .s_axis_aresetn(up_sw_resetn),
    .s_axis_ready(sdo_fifo_ready),
    .s_axis_valid(sdo_fifo_valid),
    .s_axis_data(sdo_fifo_data),
    .s_axis_room(sdo_fifo_room),
    .s_axis_tlast(1'b0),
    .s_axis_full(),
    .s_axis_almost_full(),
    .m_axis_aclk(clk_1),
    .m_axis_aresetn(a_reset_n),
    .m_axis_ready(sdo_ready_w),
    .m_axis_valid(sdo_valid_w),
    .m_axis_data(sdo_w),
    .m_axis_tlast(),
    .m_axis_level(),
    .m_axis_empty(sdo_fifo_empty),
    .m_axis_almost_empty(sdo_fifo_almost_empty));

  wire sdi_valid_w;
  wire sdi_ready_w;
  assign offload_sdi = sdi;
  assign offload_sdi_valid =  ops_mode ? sdi_valid : 1'b0;
  assign sdi_valid_w       = ~ops_mode ? sdi_valid : 1'b0;
  assign sdi_ready = ops_mode ? offload_sdi_ready : sdi_ready_w;
  assign sdi_fifo_ready = up_rreq_s == 1'b1 && up_raddr_s[7:0] == `I3C_REGMAP_SDI_FIFO;

  util_axis_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .ASYNC_CLK(ASYNC_CLK),
    .ADDRESS_WIDTH(SDI_FIFO_ADDRESS_WIDTH),
    .M_AXIS_REGISTERED(0),
    .ALMOST_EMPTY_THRESHOLD(1),
    .ALMOST_FULL_THRESHOLD(31)
  ) i_sdi_fifo (
    .s_axis_aclk(clk_1),
    .s_axis_aresetn(a_reset_n),
    .s_axis_ready(sdi_ready_w),
    .s_axis_valid(sdi_valid_w),
    .s_axis_data(sdi),
    .s_axis_room(),
    .s_axis_tlast(),
    .s_axis_full(),
    .s_axis_almost_full(sdi_fifo_almost_full),
    .m_axis_aclk(s_axi_aclk),
    .m_axis_aresetn(up_sw_resetn),
    .m_axis_ready(sdi_fifo_ready),
    .m_axis_valid(sdi_fifo_valid),
    .m_axis_data(sdi_fifo_data),
    .m_axis_tlast(),
    .m_axis_level(sdi_fifo_level),
    .m_axis_empty(sdi_fifo_empty),
    .m_axis_almost_empty());

  assign ibi_fifo_ready = up_rreq_s == 1'b1 && up_raddr_s[7:0] == `I3C_REGMAP_IBI_FIFO;

  util_axis_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .ASYNC_CLK(ASYNC_CLK),
    .ADDRESS_WIDTH(IBI_FIFO_ADDRESS_WIDTH),
    .M_AXIS_REGISTERED(0),
    .ALMOST_EMPTY_THRESHOLD(1),
    .ALMOST_FULL_THRESHOLD(31)
  ) i_ibi_fifo (
    .s_axis_aclk(clk_1),
    .s_axis_aresetn(a_reset_n),
    .s_axis_ready(ibi_ready),
    .s_axis_valid(ibi_valid),
    .s_axis_data(ibi),
    .s_axis_room(),
    .s_axis_tlast(),
    .s_axis_full(),
    .s_axis_almost_full(ibi_fifo_almost_full),
    .m_axis_aclk(s_axi_aclk),
    .m_axis_aresetn(up_sw_resetn),
    .m_axis_ready(ibi_fifo_ready),
    .m_axis_valid(ibi_fifo_valid),
    .m_axis_data(ibi_fifo_data),
    .m_axis_tlast(),
    .m_axis_level(ibi_fifo_level),
    .m_axis_empty(ibi_fifo_empty),
    .m_axis_almost_empty());

  sync_bits #(
    .NUM_OF_BITS (6),
    .ASYNC_CLK (ASYNC_CLK)
  ) i_fifo_status (
    .in_bits ({
      cmd_fifo_almost_empty, cmdr_fifo_almost_full, sdo_fifo_almost_empty,
      sdi_fifo_almost_full, ibi_fifo_almost_full, cmd_nop
    }),
    .out_resetn (up_sw_resetn),
    .out_clk (s_axi_aclk),
    .out_bits ({up_cmd_fifo_almost_empty, up_cmdr_fifo_almost_full,
      up_sdo_fifo_almost_empty, up_sdi_fifo_almost_full, up_ibi_fifo_almost_full,
      up_cmd_nop
    }));

endmodule
