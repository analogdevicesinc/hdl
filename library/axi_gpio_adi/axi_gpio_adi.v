// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
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
`timescale 1ns / 1ps

module axi_gpio_adi (
  (* MARK_DEBUG = "TRUE" *) output reg irq,

  // AXI interface
  input               s_axi_aclk,
  (* MARK_DEBUG = "TRUE" *) input               s_axi_aresetn,
  input               s_axi_awvalid,
  input      [15:0]   s_axi_awaddr,
  input      [2:0]    s_axi_awprot,
  output              s_axi_awready,
  input               s_axi_wvalid,
 (* MARK_DEBUG = "TRUE" *) input      [31:0]   s_axi_wdata,
  input      [3:0]    s_axi_wstrb,
  output              s_axi_wready,
  output              s_axi_bvalid,
  output     [1:0]    s_axi_bresp,
  input               s_axi_bready,
  input               s_axi_arvalid,
  input      [15:0]   s_axi_araddr,
  input      [2:0]    s_axi_arprot,
  output              s_axi_arready,
  output              s_axi_rvalid,
  output     [1:0]    s_axi_rresp,
  (* MARK_DEBUG = "TRUE" *) output     [31:0]   s_axi_rdata,
  input               s_axi_rready,

  // GPIO Xilinx-style
  //(* X_INTERFACE_INFO = "xilinx.com:interface:gpio_rtl:1.0 gpio TRI_O" *)
  //(* X_INTERFACE_NAME = "gpio" *)
  output     [31:0]   gpio_io_o,
  //(* X_INTERFACE_INFO = "xilinx.com:interface:gpio_rtl:1.0 gpio TRI_I" *)
  input      [31:0]   gpio_io_i,
  //(* X_INTERFACE_INFO = "xilinx.com:interface:gpio_rtl:1.0 gpio TRI_T" *)
  output     [31:0]   gpio_io_t
);


  // Internal Registers

  reg        [31:0] gpio_out_reg;
  reg        [31:0] gpio_dir_reg;  // 1 = output, 0 = input
  //(* dont_touch = "true" *)
  (* MARK_DEBUG = "TRUE" *) reg        [31:0] up_rdata;
  reg        up_rack;
  reg        up_wack;
  reg               up_resetn;

  wire       [31:0] up_irq_pending;
  wire       [31:0] up_irq_trigger;
  wire       [31:0] up_irq_source_clear;
  reg        [31:0] up_irq_mask;
  reg        [31:0] up_irq_source;


  // Wire AXI-to-up bus interface

  wire              up_clk = s_axi_aclk;
  wire              up_wreq_s;
  wire [7:0]        up_waddr_s;
   (* MARK_DEBUG = "TRUE" *) wire [31:0]       up_wdata_s;
  wire              up_rreq_s;
  wire [7:0]        up_raddr_s;

  assign gpio_io_o = gpio_out_reg;
  assign gpio_io_t = ~gpio_dir_reg;

  up_axi #(
    .AXI_ADDRESS_WIDTH(10)
  ) i_up_axi (
    .up_rstn        (s_axi_aresetn),
    .up_clk         (up_clk),
    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr  (s_axi_awaddr),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid  (s_axi_wvalid),
    .up_axi_wdata   (s_axi_wdata),
    .up_axi_wstrb   (s_axi_wstrb),
    .up_axi_wready  (s_axi_wready),
    .up_axi_bvalid  (s_axi_bvalid),
    .up_axi_bresp   (s_axi_bresp),
    .up_axi_bready  (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr  (s_axi_araddr),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid  (s_axi_rvalid),
    .up_axi_rresp   (s_axi_rresp),
    .up_axi_rdata   (s_axi_rdata),
    .up_axi_rready  (s_axi_rready),
    .up_wreq        (up_wreq_s),
    .up_waddr       (up_waddr_s),
    .up_wdata       (up_wdata_s),
    .up_wack        (up_wack),
    .up_rreq        (up_rreq_s),
    .up_raddr       (up_raddr_s),
    .up_rdata       (up_rdata),
    .up_rack        (up_rack)
  );

  // Reset

  always @(posedge up_clk) begin
    if (!s_axi_aresetn) begin
      up_resetn <= 1'b0;
      up_wack   <= 1'b0;
    end else begin
      up_wack <= up_wreq_s;
      if (up_wreq_s && (up_waddr_s == 8'h20))
        up_resetn <= up_wdata_s[0];
    end
  end


  // Write Registers

  always @(posedge up_clk) begin
    if (!up_resetn) begin
      gpio_out_reg <= 32'd0;
      gpio_dir_reg <= 32'd0;
    end else if (up_wreq_s) begin
      case (up_waddr_s)
        8'h21: gpio_out_reg <= up_wdata_s;
        8'h24: gpio_dir_reg <= up_wdata_s;
      endcase
    end
  end

  // IRQ mask write
  always @(posedge up_clk) begin
    if (!up_resetn)
      up_irq_mask <= 32'hFFFFFFFF;
    else if (up_wreq_s && up_waddr_s == 8'h23)
      up_irq_mask <= up_wdata_s;
  end

  // Read Registers

  always @(posedge up_clk) begin
    if (!s_axi_aresetn) begin
      up_rack  <= 1'b0;
      up_rdata <= 32'd0;
    end else begin
      up_rack <= up_rreq_s;
      if (up_rreq_s) begin
        case (up_raddr_s)
          8'h21: up_rdata[31:0] <= gpio_out_reg[31:0];
          8'h22: up_rdata[31:0] <= gpio_io_i[31:0];
          8'h24: up_rdata[31:0] <= gpio_dir_reg[31:0];
          default: up_rdata <= 32'd0;
        endcase
        //modificare cod
      //up_rdata[31:0] <= gpio_io_i[31:0];
      if (|up_rdata) begin
        up_rack <= up_rack; // dummy logic
      end
      end
    end
  end


  // IRQ generation

  wire button_input = gpio_io_i[0];
  reg button_d1;

  always @(posedge up_clk)
    if (!up_resetn)
      button_d1 <= 1'b0;
    else
      button_d1 <= button_input;

  wire led_blink = button_input & ~button_d1;

  assign up_irq_trigger = {28'd0, 1'b0, led_blink, 1'b0, 1'b0};
  assign up_irq_source_clear = (up_wreq_s && (up_waddr_s == 8'h11)) ? up_wdata_s : 32'd0;
  assign up_irq_pending = ~up_irq_mask & up_irq_source;

  always @(posedge up_clk)
    if (!up_resetn)
      irq <= 1'b0;
    else
      irq <= |up_irq_pending;

  always @(posedge up_clk)
    if (!up_resetn)
      up_irq_source <= 32'd0;
    else
      up_irq_source <= up_irq_trigger | (up_irq_source & ~up_irq_source_clear);


  // Optional: LED toggle based on IRQ[2]

  reg [31:0] irq_source_d1;
  reg        led_state;

  always @(posedge up_clk) begin
    if (!up_resetn) begin
      irq_source_d1 <= 32'd0;
      led_state     <= 1'b0;
    end else begin
      irq_source_d1 <= up_irq_source;
      if ((up_irq_source[2] == 1'b1) && (irq_source_d1[2] == 1'b0))
        led_state <= ~led_state;
    end
  end

endmodule
