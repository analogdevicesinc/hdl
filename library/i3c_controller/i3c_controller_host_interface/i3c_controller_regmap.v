// ***************************************************************************
// ***************************************************************************
// Copyright 2023 (c) Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps
`default_nettype wire
`include "i3c_controller_regmap_defs.v"

`define ADDRESS_WIDTH 8

module i3c_controller_regmap #(
  parameter ID = 0,
  parameter ASYNC_CLK = 0,
  parameter DATA_WIDTH = 32,
  parameter PID = 48'hC00FFE123456,
  parameter DCR = 8'h7b,
  parameter BCR = 8'h40,
  parameter OFFLOAD = 1
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

  input  offload_trigger,

  // uP accessible info

  output reg  [15:0] devs_ctrl,
  output reg  [15:0] devs_ctrl_is_i2c,
  output reg  [15:0] devs_ctrl_candidate,
  input       [15:0] devs_ctrl_commit,

  input              rmap_daa_status,
  output reg  [1:0]  rmap_ibi_config,
  output      [1:0]  rmap_pp_sg,
  input              rmap_dev_char_e,
  input              rmap_dev_char_we,
  input       [5:0]  rmap_dev_char_addr,
  input       [31:0] rmap_dev_char_wdata,
  output      [8:0]  rmap_dev_char_rdata
);

  localparam PCORE_VERSION = 'h12345678;
  localparam S_AXI = 0;
  localparam UP_FIFO = 1;

  wire rstn;

  // CMD FIFO
  wire [`ADDRESS_WIDTH-1:0] cmd_fifo_room;
  wire cmd_fifo_almost_empty;
  wire up_cmd_fifo_almost_empty;

  wire [DATA_WIDTH-1:0] cmd_fifo_data;
  wire cmd_fifo_ready;
  wire cmd_fifo_valid;
  // CMDR FIFO
  wire cmdr_fifo_data_msb_s;
  wire [`ADDRESS_WIDTH-1:0] cmdr_fifo_level;
  wire cmdr_fifo_almost_full;
  wire up_cmdr_fifo_almost_full;

  wire [DATA_WIDTH-1:0] cmdr_fifo_data;
  wire cmdr_fifo_ready;
  wire cmdr_fifo_valid;
  wire cmdr_fifo_empty;
  // SDO FIFO
  wire [`ADDRESS_WIDTH-1:0] sdo_fifo_room;
  wire sdo_fifo_almost_empty;
  wire up_sdo_fifo_almost_empty;

  wire [DATA_WIDTH-1:0] sdo_fifo_data;
  wire sdo_fifo_ready;
  wire sdo_fifo_valid;
  // SDI FIFO
  wire sdi_fifo_data_msb_s;
  wire [`ADDRESS_WIDTH-1:0] sdi_fifo_level;
  wire sdi_fifo_almost_full;
  wire up_sdi_fifo_almost_full;

  wire [DATA_WIDTH-1:0] sdi_fifo_data;
  wire sdi_fifo_ready;
  wire sdi_fifo_valid;
  wire sdi_fifo_empty;
  // IBI FIFO
  wire ibi_fifo_data_msb_s;
  wire [`ADDRESS_WIDTH-1:0] ibi_fifo_level;
  wire ibi_fifo_almost_full;
  wire up_ibi_fifo_almost_full;

  wire [DATA_WIDTH-1:0] ibi_fifo_data;
  wire ibi_fifo_ready;
  wire ibi_fifo_valid;
  wire ibi_fifo_empty;

  reg  up_sw_reset = 1'b1;
  wire up_sw_resetn = ~up_sw_reset;

  reg  [31:0] up_rdata_ff = 'd0;
  wire [31:0] up_rdata_ff_w;
  reg         up_wack_ff = 1'b0;
  reg         up_rack_ff = 1'b0;
  wire        up_wreq_s;
  wire        up_rreq_s;
  wire [31:0] up_wdata_s;
  wire [13:0] up_waddr_s;
  wire [13:0] up_raddr_s;

  // Scratch register
  reg [31:0] up_scratch = 'h00;

  reg cmdr_pending = 1'b0;
  reg ibi_pending = 1'b0;
  reg cmd_nop_reg;

  // assign clock and reset

  assign rstn = s_axi_aresetn;

  // interface wrapper

  up_axi #(
    .AXI_ADDRESS_WIDTH (16)
  ) i_up_axi (
    .up_rstn(rstn),
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

  // IRQ handling
  reg  [6:0] up_irq_mask = 7'h0;
  wire [6:0] up_irq_source;
  wire [6:0] up_irq_pending;

  assign up_irq_source = {
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
    if (rstn == 1'b0)
      irq <= 1'b0;
    else
      irq <= |up_irq_pending;
    end

  always @(posedge s_axi_aclk) begin
    if (rstn == 1'b0) begin
      up_wack_ff <= 1'b0;
      up_scratch <= 'h00;
      up_sw_reset <= 1'b1;
    end else begin
      up_wack_ff <= up_wreq_s;
      if (up_wreq_s) begin
        case (up_waddr_s[7:0])
          `I3C_REGMAP_ENABLE:         up_sw_reset <= up_wdata_s[0];
          `I3C_REGMAP_SCRATCH:        up_scratch <= up_wdata_s;
        endcase
      end
    end
  end

  reg  [6:0] ops;
  reg  [6:0] ops_candidate;
  wire       ops_mode;
  wire [3:0] ops_offload_len;
  wire [1:0] ops_sg;
  wire       offload_idle;
  assign ops_mode = ops[0];
  assign ops_offload_len = ops[4:1];
  assign ops_sg = ops[6:5];
  assign rmap_pp_sg = ops_sg;

  wire [31:0] cmd_w;
  wire cmd_valid_w;
  wire cmd_ready_w;

  always @(posedge s_axi_aclk) begin
    cmd_nop_reg <= cmd_nop;
    if (!up_sw_resetn) begin
      ops <= 7'b1100000;
    end else if (cmd_nop_reg) begin
      if ((~ops_mode & ~cmd_valid_w) | (ops_mode & offload_idle)) begin
        ops <= ops_candidate;
      end
    end
  end

  // the software reset should reset all the registers
  integer i;
  always @(posedge s_axi_aclk) begin
    if (!up_sw_resetn) begin
      up_irq_mask <= 'h00;
      rmap_ibi_config <= 'h00;
      devs_ctrl <= 'b0;
      devs_ctrl_is_i2c <= 'b0;
      devs_ctrl_candidate <= 'b0;
	    ops_candidate <= 7'd0;
    end else begin
      if (up_wreq_s) begin
        case (up_waddr_s[7:0])
          `I3C_REGMAP_IRQ_MASK:   up_irq_mask <= up_wdata_s[6:0];
          `I3C_REGMAP_IBI_CONFIG: rmap_ibi_config <= up_wdata_s[1:0];
          `I3C_REGMAP_OPS:        ops_candidate <= up_wdata_s[6:0];
          default: begin
          end
        endcase

        // When assigning an address...
        // Controller: set as attached.
        if (up_waddr_s[7:0] == {`I3C_REGMAP_DEV_CHAR_0_, 4'd0}) begin
          devs_ctrl[0] <= 1'b1;
        end
        // I2C peripherals: set as attached.
        if (up_waddr_s[7:4] == `I3C_REGMAP_DEV_CHAR_0_) begin
          if (up_wdata_s[8] == 1'b0) begin
            devs_ctrl[up_waddr_s[3:0]] <= 1'b1;
            devs_ctrl_is_i2c[up_waddr_s[3:0]] <= 1'b1;
          end
        end

        // I3C peripherals: set as candidate [1]...
        if (up_waddr_s[7:4] == `I3C_REGMAP_DEV_CHAR_0_ & up_waddr_s[3:0] != 4'h0) begin
          if (up_wdata_s[8] == 1'b1) begin
            devs_ctrl_candidate[up_waddr_s[3:0]] <= 1'b1;
          end
        end

        // Any device: clear
        if (up_waddr_s[7:0] == `I3C_REGMAP_DEVS_CTRL) begin
          for (i = 0; i < 16 ; i = i + 1) begin
            if (up_wdata_s[i+15] == 1'b1) begin
              devs_ctrl[i] <= 1'b0;
              devs_ctrl_candidate[i] <= 1'b0;
            end
          end
        end

      end
      // ...[1] then commit.
      for (i = 0; i < 16 ; i = i + 1) begin
        if (devs_ctrl_commit[i] == 1'b1) begin
          devs_ctrl_candidate[i] <= 1'b0;
          devs_ctrl[i] <= 1'b1;
        end
      end
    end
  end

  always @(posedge s_axi_aclk) begin
    if (rstn == 1'b0) begin
      up_rack_ff <= 'd0;
    end else begin
      up_rack_ff <= up_rreq_s;
    end
  end

  wire [13:0] rmap_daa_peripheral;

  wire dev_char_ea;
  wire dev_char_wea;
  wire dev_char_rea;
  wire [31:0] dev_char_douta;
  wire [5:0] dev_char_addra;

  always @(posedge s_axi_aclk) begin
    case (up_raddr_s[7:0])
      `I3C_REGMAP_VERSION:        up_rdata_ff <= PCORE_VERSION;
      `I3C_REGMAP_PERIPHERAL_ID:  up_rdata_ff <= ID;
      `I3C_REGMAP_SCRATCH:        up_rdata_ff <= up_scratch;
      `I3C_REGMAP_ENABLE:         up_rdata_ff <= up_sw_reset;
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
      `I3C_REGMAP_OPS:            up_rdata_ff <= {cmd_nop_reg, rmap_daa_status, ops};
      `I3C_REGMAP_DEV_CHAR_1_0:   up_rdata_ff <= PID[47:16];
      `I3C_REGMAP_DEV_CHAR_2_0:   up_rdata_ff <= {PID[16:0], BCR, DCR};
      `I3C_REGMAP_DEVS_CTRL:      up_rdata_ff <= {16'd0, devs_ctrl};
      default:                    up_rdata_ff <= 'h00;
    endcase
  end
  // NOTE: Could pre-load the Controller PID in the BRAM instead.
  assign up_rdata_ff_w =   up_raddr_s[7:4] == `I3C_REGMAP_DEV_CHAR_0_  ? dev_char_douta :
                           up_raddr_s[7:4] == `I3C_REGMAP_OFFLOAD_CMD_ ? offload_douta :
                           up_raddr_s[7:4] == `I3C_REGMAP_OFFLOAD_SDO_ ? offload_douta :
                         ~|up_raddr_s[3:0] ? up_rdata_ff :
                           up_raddr_s[7:4] == `I3C_REGMAP_DEV_CHAR_1_  ? dev_char_douta :
                           up_raddr_s[7:4] == `I3C_REGMAP_DEV_CHAR_2_  ? dev_char_douta :
                           up_rdata_ff;
  ad_mem_dual #(
    .DATA_WIDTH(32),
    .ADDRESS_WIDTH(6)
  ) i_mem_dev_char (
    .clka(s_axi_aclk),
    .wea(dev_char_wea),
    .ea(dev_char_ea),
    .addra(dev_char_addra),
    .dina(up_wdata_s),
    .douta(dev_char_douta),
    .clkb(s_axi_aclk),
    .web(rmap_dev_char_we),
    .eb(rmap_dev_char_e),
    .addrb(rmap_dev_char_addr),
    .dinb(rmap_dev_char_wdata),
    .doutb(rmap_dev_char_rdata));

  assign dev_char_addra = up_wreq_s ?
                       {up_waddr_s[7], up_waddr_s[4], up_waddr_s[3:0]} :
                       {up_raddr_s[7], up_raddr_s[4], up_raddr_s[3:0]};
  assign dev_char_rea = up_rreq_s == 1'b1 &&
                       (up_raddr_s[7:4] == `I3C_REGMAP_DEV_CHAR_0_ |
                        up_raddr_s[7:4] == `I3C_REGMAP_DEV_CHAR_1_ |
                        up_raddr_s[7:4] == `I3C_REGMAP_DEV_CHAR_2_ );
  assign dev_char_wea = up_wreq_s == 1'b1 &&
                       (up_waddr_s[7:4] == `I3C_REGMAP_DEV_CHAR_0_ |
                        up_waddr_s[7:4] == `I3C_REGMAP_DEV_CHAR_2_ );
  assign dev_char_ea = dev_char_rea | dev_char_wea;

  wire [31:0] offload_douta;
  wire [31:0] offload_cmd;
  wire [31:0] offload_sdo;
  wire offload_cmd_valid;
  wire offload_sdo_valid;

  generate if (OFFLOAD == 1) begin
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

    reg [1:0] smt;
    reg [3:0] k;
    reg [3:0] j;
    localparam [1:0]
      cmd_setup    = 0,
      cmd_transfer = 1,
      sdo_setup    = 2,
      sdo_transfer = 3;

    always @(posedge s_axi_aclk) begin
      if (!a_reset_n | ~ops_mode | ops_offload_len == 0) begin
         smt <= cmd_setup;
         k <= 'd0;
      end else begin
        // The same BRAM provides both cmd and sdo,
        // thefore a request-like interface is used
        if (smt[1] == 1'b0) begin
          j <= 0;
        end
        case (smt)
          cmd_setup: begin
            if (offload_trigger | k != 0) begin
              smt <= cmd_transfer;
              k <= k == ops_offload_len - 1 ? 0 : k + 1;
            end
          end
          cmd_transfer: begin
            if (cmd_ready) begin
              smt <= sdo_setup;
            end
          end
          sdo_setup: begin
            smt <= sdo_transfer;
            j <= j + 1;
          end
          sdo_transfer: begin
            // New payload requested is cmd or sdo?
            if (cmd_ready) begin
              smt <= cmd_setup;
            end else if (sdo_ready) begin
              smt <= sdo_setup;
            end
          end
       endcase
      end
    end
    assign offload_idle = smt == cmd_setup & k == 0;
    assign offload_addrb = smt[1] == 1'b0 ? {1'b0,k} : {1'b1,j};
    assign offload_eb    = smt[0] == 1'b0 & ops_mode;
    assign offload_cmd_valid = smt == cmd_transfer;
    assign offload_sdo_valid = smt == sdo_transfer;
    assign offload_cmd = offload_doutb;
    assign offload_sdo = offload_doutb;
  end
  endgenerate

  always @(posedge s_axi_aclk) begin
    if (up_sw_resetn == 1'b0) begin
      cmdr_pending <= 1'b0;
      ibi_pending <= 1'b0;
    end else begin
      if (cmdr_fifo_valid == 1'b1) begin
        cmdr_pending <= 1'b1;
      end else if (up_wreq_s == 1'b1 && up_waddr_s == `I3C_REGMAP_IRQ_PENDING && up_wdata_s[`I3C_REGMAP_IRQ_PENDING_CMDR_PENDING] == 1'b1) begin
        cmdr_pending <= 1'b0;
      end
      if (ibi_fifo_valid == 1'b1) begin
        ibi_pending <= 1'b1;
      end else if (up_wreq_s == 1'b1 && up_waddr_s == `I3C_REGMAP_IRQ_PENDING && up_wdata_s[`I3C_REGMAP_IRQ_PENDING_IBI_PENDING] == 1'b1) begin
        ibi_pending <= 1'b0;
      end
    end
  end

  wire clk_1;

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
  assign cmd_fifo_valid = up_wreq_s == 1'b1 && up_waddr_s == `I3C_REGMAP_CMD_FIFO;
  assign cmd_fifo_data = up_wdata_s;

  util_axis_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDRESS_WIDTH(`ADDRESS_WIDTH),
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

  wire cmdr_valid_w;
  wire cmdr_ready_w;
  assign cmdr_ready   = ~ops_mode ? cmdr_ready_w : 1'b1; // In offload, discard cmdr
  assign cmdr_valid_w = ~ops_mode ? cmdr_valid   : 1'b0;
  assign cmdr_fifo_ready = up_rreq_s == 1'b1 && up_raddr_s == `I3C_REGMAP_CMDR_FIFO;

  util_axis_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .ASYNC_CLK(ASYNC_CLK),
    .ADDRESS_WIDTH(`ADDRESS_WIDTH),
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

  wire [31:0] sdo_w;
  wire sdo_valid_w;
  wire sdo_ready_w;
  assign sdo = ~ops_mode ? sdo_w : offload_sdo;
  assign sdo_valid   = ~ops_mode ? sdo_valid_w : offload_sdo_valid;
  assign sdo_ready_w = ~ops_mode ? sdo_ready   : 1'b0;
  assign sdo_fifo_valid = up_wreq_s == 1'b1 && up_waddr_s == `I3C_REGMAP_SDO_FIFO;
  assign sdo_fifo_data = up_wdata_s[31:0];

  util_axis_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .ASYNC_CLK(ASYNC_CLK),
    .ADDRESS_WIDTH(`ADDRESS_WIDTH),
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
    .m_axis_empty(),
    .m_axis_almost_empty(sdo_fifo_almost_empty));

  wire sdi_valid_w;
  wire sdi_ready_w;
  assign offload_sdi = sdi;
  assign offload_sdi_valid =  ops_mode ? sdi_valid : 1'b0;
  assign sdi_valid_w       = ~ops_mode ? sdi_valid : 1'b0;
  assign sdi_ready = ops_mode ? offload_sdi_ready : sdi_ready_w;
  assign sdi_fifo_ready = up_rreq_s == 1'b1 && up_raddr_s == `I3C_REGMAP_SDI_FIFO;

  util_axis_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .ASYNC_CLK(ASYNC_CLK),
    .ADDRESS_WIDTH(`ADDRESS_WIDTH),
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

  assign ibi_fifo_ready = up_rreq_s == 1'b1 && up_raddr_s == `I3C_REGMAP_IBI_FIFO;

  util_axis_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .ASYNC_CLK(ASYNC_CLK),
    .ADDRESS_WIDTH(`ADDRESS_WIDTH),
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
    .NUM_OF_BITS (5),
    .ASYNC_CLK (ASYNC_CLK)
  ) i_fifo_status (
    .in_bits ({cmd_fifo_almost_empty, cmdr_fifo_almost_full, sdo_fifo_almost_empty, sdi_fifo_almost_full, ibi_fifo_almost_full}),
    .out_resetn (up_sw_resetn),
    .out_clk (s_axi_aclk),
    .out_bits ({up_cmd_fifo_almost_empty, up_cmdr_fifo_almost_full, up_sdo_fifo_almost_empty, up_sdi_fifo_almost_full, up_ibi_fifo_almost_full}));

endmodule
