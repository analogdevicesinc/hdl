// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
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

module axi_ad5766 #(

  parameter   FPGA_TECHNOLOGY = 0,
  parameter   FPGA_FAMILY = 0,
  parameter   SPEED_GRADE = 0,
  parameter   DEV_PACKAGE = 0,
  parameter   ASYNC_SPI_CLK = 0,
  parameter   CMD_MEM_ADDRESS_WIDTH = 4,
  parameter   SDO_MEM_ADDRESS_WIDTH = 4
) (

  // Slave AXI interface

  input                                 s_axi_aclk,
  input                                 s_axi_aresetn,
  input                                 s_axi_awvalid,
  input       [15:0]                    s_axi_awaddr,
  output                                s_axi_awready,
  input       [ 2:0]                    s_axi_awprot,
  input                                 s_axi_wvalid,
  input       [31:0]                    s_axi_wdata,
  input       [ 3:0]                    s_axi_wstrb,
  output                                s_axi_wready,
  output                                s_axi_bvalid,
  output      [ 1:0]                    s_axi_bresp,
  input                                 s_axi_bready,
  input                                 s_axi_arvalid,
  input       [15:0]                    s_axi_araddr,
  output                                s_axi_arready,
  input       [ 2:0]                    s_axi_arprot,
  output                                s_axi_rvalid,
  input                                 s_axi_rready,
  output      [ 1:0]                    s_axi_rresp,
  output      [31:0]                    s_axi_rdata,

  // FIFO transmit

  output                                dma_clk,
  output  reg                           dma_valid,
  input                                 dma_enable,
  input       [15:0]                    dma_data,
  input                                 dma_xfer_req,
  input                                 dma_underflow,

  // SPI engine control interface (to the SPI engine interconnect)

  input                                 spi_clk,        // should be connected to up_clk
  input                                 spi_resetn,

  input                                 cmd_ready,
  output                                cmd_valid,
  output      [15:0]                    cmd_data,

  input                                 sdo_data_ready,
  output                                sdo_data_valid,
  output      [ 7:0]                    sdo_data,

  output                                sdi_data_ready,
  input                                 sdi_data_valid,
  input       [ 7:0]                    sdi_data,

  output                                sync_ready,
  input                                 sync_valid,
  input       [ 7:0]                    sync_data,

  // SPI engine offload interface (to the AXI SPI engine)

  input                                 ctrl_clk,
  input                                 ctrl_cmd_wr_en,
  input       [15:0]                    ctrl_cmd_wr_data,

  input                                 ctrl_enable,
  output                                ctrl_enabled,
  input                                 ctrl_mem_reset
);

  // internal wires

  wire                                  up_wreq_s;
  wire        [13:0]                    up_waddr_s;
  wire        [31:0]                    up_wdata_s;
  wire                                  up_rreq_s;
  wire        [13:0]                    up_raddr_s;
  wire        [31:0]                    up_rdata_s[0:1];
  wire                                  up_rack_s[0:1];
  wire                                  up_wack_s[0:1];
  wire                                  trigger_s;
  wire        [31:0]                    pulse_period_s;
  wire        [15:0]                    dac_datarate_s;
  wire                                  spi_reset;
  wire                                  spi_enable_s;
  wire        [ 3:0]                    sequencer[15:0];
  wire        [ 3:0]                    cmd_bits;
  wire        [ 3:0]                    end_of_sequence;
  wire                                  spi_mem_reset_s;
  wire                                  sequence_valid_s;
  wire        [ 7:0]                    sequence_data_s;
  wire                                  dac_rst_s;
  wire                                  dac_rstn_s;
  wire [CMD_MEM_ADDRESS_WIDTH-1:0]      spi_cmd_rd_addr_next;

  // registers

  reg         [31:0]                    up_rdata = 32'b0;
  reg                                   up_rack = 0;
  reg                                   up_wack = 1'b0;
  reg         [15:0]                    cmd_mem[0:2**CMD_MEM_ADDRESS_WIDTH-1];
  reg         [ 7:0]                    sdo_mem[0:2];
  reg [CMD_MEM_ADDRESS_WIDTH-1:0]       ctrl_cmd_wr_addr = 'b0;
  reg [CMD_MEM_ADDRESS_WIDTH-1:0]       spi_cmd_rd_addr = 'b0;
  reg [SDO_MEM_ADDRESS_WIDTH-1:0]       ctrl_sdo_wr_addr = 'b0;
  reg [SDO_MEM_ADDRESS_WIDTH-1:0]       spi_sdo_rd_addr = 'b0;
  reg                                   spi_active = 1'b0;

  assign up_rstn = s_axi_aresetn;

  // the dma interface runs on SPI_CLK

  assign  dma_clk = spi_clk;

  // command and SDO data offload

  assign cmd_valid = spi_active;
  assign cmd_data = cmd_mem[spi_cmd_rd_addr];
  assign sdo_data_valid = spi_active;
  assign sdo_data = sdo_mem[spi_sdo_rd_addr];
  assign sync_ready = 1'b1;

  assign sdi_data_ready = 1'b0;

  generate if (ASYNC_SPI_CLK) begin

    /*
     * The synchronization circuit takes care that there are no glitches on the
     * ctrl_enabled signal. ctrl_do_enable is asserted whenever ctrl_enable is
     * asserted, but only deasserted once the signal has been synchronized back from
     * the SPI domain. This makes sure that we can't end up in a state where the
     * enable signal in the SPI domain is asserted, but neither enable nor enabled
     * is asserted in the control domain.
     */

    reg ctrl_do_enable = 1'b0;
    wire ctrl_is_enabled;
    reg spi_enabled = 1'b0;

    always @(posedge ctrl_clk) begin
        if (ctrl_enable == 1'b1) begin
                ctrl_do_enable <= 1'b1;
        end else if (ctrl_is_enabled == 1'b1) begin
                ctrl_do_enable <= 1'b0;
        end
    end

    assign ctrl_enabled = ctrl_is_enabled | ctrl_do_enable;

    always @(posedge spi_clk) begin
        spi_enabled <= spi_enable_s | spi_active;
    end

    sync_bits #(
      .NUM_OF_BITS(1),
      .ASYNC_CLK(1)
    ) i_sync_enable (
      .in_bits(ctrl_do_enable),
      .out_clk(spi_clk),
      .out_resetn(1'b1),
      .out_bits(spi_enable_s));

    sync_bits #(
      .NUM_OF_BITS(1),
      .ASYNC_CLK(1)
    ) i_sync_enabled (
      .in_bits(spi_enabled),
      .out_clk(ctrl_clk),
      .out_resetn(1'b1),
      .out_bits(ctrl_is_enabled));

    sync_bits #(
      .NUM_OF_BITS(1),
      .ASYNC_CLK(1)
    ) i_sync_mem_reset (
      .in_bits(ctrl_mem_reset),
      .out_clk(spi_clk),
      .out_resetn(1'b1),
      .out_bits(spi_mem_reset_s));

  end else begin
    assign spi_enable_s = ctrl_enable;
    assign ctrl_enabled = spi_enable_s | spi_active;
    assign spi_mem_reset_s = ctrl_mem_reset;
  end endgenerate

  assign spi_cmd_rd_addr_next = spi_cmd_rd_addr + 1;

  always @(posedge spi_clk) begin
    if (spi_resetn == 1'b0) begin
      spi_active <= 1'b0;
    end else begin
      if (spi_active == 1'b0) begin
        if ((trigger_s == 1'b1 && spi_enable_s == 1'b1)) begin
          spi_active <= 1'b1;
        end
      end else if (cmd_ready == 1'b1 && spi_cmd_rd_addr_next == ctrl_cmd_wr_addr) begin
          spi_active <= 1'b0;
      end
    end
  end

  always @(posedge spi_clk) begin
    if (cmd_valid == 1'b0) begin
      spi_cmd_rd_addr <= 'h00;
    end else if (cmd_ready == 1'b1) begin
      spi_cmd_rd_addr <= spi_cmd_rd_addr_next;
    end
  end

  always @(posedge spi_clk) begin
    if (spi_active == 1'b0) begin
      spi_sdo_rd_addr <= 'h00;
    end else if (sdo_data_ready == 1'b1) begin
      spi_sdo_rd_addr <= spi_sdo_rd_addr + 1'b1;
    end
  end

  always @(posedge ctrl_clk) begin
    if (ctrl_cmd_wr_en == 1'b1) begin
      cmd_mem[ctrl_cmd_wr_addr] <= ctrl_cmd_wr_data;
    end
  end

  always @(posedge ctrl_clk) begin
    if (ctrl_mem_reset == 1'b1) begin
      ctrl_cmd_wr_addr <= 0;
    end else if (ctrl_cmd_wr_en == 1'b1) begin
      ctrl_cmd_wr_addr <= ctrl_cmd_wr_addr + 1;
    end
  end

  // request data from the DMA at the desired rate

  always @(posedge dma_clk) begin
    if (dma_xfer_req == 1'b0) begin
      dma_valid <= 1'b0;
    end else begin
      if ((trigger_s == 1'b1) && (dma_enable == 1'b1) && (spi_enable_s == 1'b1)) begin
        dma_valid <= 1'b1;
      end
      if (dma_valid == 1'b1) begin
        dma_valid <= 1'b0;
      end
    end
    if (dma_valid == 1'b1) begin
      sdo_mem[1] <= dma_data[15:8];
      sdo_mem[2] <= dma_data[ 7:0];
    end
    if (sequence_valid_s == 1'b1) begin
      sdo_mem[0] <= sequence_data_s;
    end
  end

  // rate controller

  assign dac_rstn_s = ~dac_rst_s;
  util_pulse_gen #(
    .PULSE_WIDTH(1)
  ) i_trigger_gen (
    .clk (spi_clk),
    .rstn (dac_rstn_s),
    .pulse_width (1'b1),
    .pulse_period (pulse_period_s),
    .load_config (1'b1),
    .pulse (trigger_s));

  // offset of the sequencer registers are 8'h40

  always @(negedge up_rstn or posedge spi_clk) begin
    if (up_rstn == 1'b0) begin
      up_rdata <= 'd0;
      up_rack <= 'd0;
      up_wack <= 'd0;
    end else begin
      up_rdata <= up_rdata_s[0] | up_rdata_s[1];
      up_rack <=  up_rack_s[0] | up_rack_s[1];
      up_wack <=  up_wack_s[0] | up_wack_s[1];
    end
  end

  // DAC common registermap

  assign pulse_period_s = {16'h0, dac_datarate_s};

  up_ad5766_sequencer #(
    .SEQ_ID(4)
  ) i_sequencer (
    .sequence_clk (spi_clk),
    .sequence_rst (spi_mem_reset_s),
    .sequence_req (dma_valid),
    .sequence_valid (sequence_valid_s),
    .sequence_data (sequence_data_s),
    .up_rstn (up_rstn),
    .up_clk (spi_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[1]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[1]),
    .up_rack (up_rack_s[1]));

  up_dac_common #(
    .COMMON_ID (0),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .CONFIG (0),
    .CLK_EDGE_SEL (0),
    .DRP_DISABLE (6'h00),
    .USERPORTS_DISABLE (0),
    .GPIO_DISABLE (0)
  ) i_dac_common (
    .mmcm_rst (),
    .dac_clk (spi_clk),
    .dac_rst (dac_rst_s),
    .dac_sync (),
    .dac_frame (),
    .dac_clksel (),
    .dac_custom_wr(),
    .dac_custom_rd(32'b0),
    .dac_custom_control(),
    .dac_status_if_busy(1'b0),
    .dac_par_type (),
    .dac_par_enb (),
    .dac_r1_mode (),
    .dac_datafmt (dac_datafmt),
    .dac_datarate (dac_datarate_s),
    .dac_status (1'b0),
    .dac_status_unf (dma_underflow),
    .dac_clk_ratio (32'b0),
    .up_dac_ce (),
    .up_pps_rcounter (32'b0),
    .up_pps_status (1'b0),
    .up_pps_irq_mask (),
    .up_drp_sel (),
    .up_drp_wr (),
    .up_drp_addr (),
    .up_drp_wdata (),
    .up_drp_rdata (16'b0),
    .up_drp_ready (1'b0),
    .up_drp_locked (1'b0),
    .up_usr_chanmax (),
    .dac_usr_chanmax (8'b0),
    .up_dac_gpio_in (32'b0),
    .up_dac_gpio_out (),
    .up_rstn (up_rstn),
    .up_clk (spi_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s[0]),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s[0]),
    .up_rack (up_rack_s[0]));

  // AXI wrapper

  up_axi #(
    .AXI_ADDRESS_WIDTH (16)
  ) i_up_axi (
    .up_rstn (up_rstn),
    .up_clk (spi_clk),
    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr (s_axi_awaddr),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr (s_axi_araddr),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid (s_axi_rvalid),
    .up_axi_rresp (s_axi_rresp),
    .up_axi_rdata (s_axi_rdata),
    .up_axi_rready (s_axi_rready),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata),
    .up_rack (up_rack));

endmodule
