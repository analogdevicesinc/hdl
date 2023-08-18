// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017, 2018, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module rx_ctrl_tb;
  parameter VCD_FILE = "rx_ctrl_tb.vcd";

  `include "tb_base.v"

  integer phy_reset_counter = 'h00;
  integer align_counter = 'h00;
  integer cgs_counter = 'h00;

  reg phy_ready = 1'b0;
  reg aligned = 1'b0;
  reg cgs_ready = 1'b0;

  wire en_align;
  wire cgs_reset;

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      phy_reset_counter <= 'h00;
      phy_ready <= 1'b0;
    end else begin
      if (phy_reset_counter == 'h7) begin
        phy_ready <= 1'b1;
      end else begin
        phy_reset_counter <= phy_reset_counter + 1'b1;
      end
    end
  end

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      aligned <= 1'b0;
      align_counter <= 'h00;
    end else if (phy_ready == 1'b1) begin
      if (en_align == 1'b1) begin
        if (align_counter == 'h20) begin
          aligned <= 1'b1;
        end else begin
          align_counter <= align_counter + 1;
        end
      end
    end
  end

  always @(posedge clk or posedge cgs_reset) begin
    if (cgs_reset == 1'b1) begin
      cgs_counter <= 'h00;
      cgs_ready <= 1'b0;
    end else begin
      if (cgs_counter == 'h20) begin
        cgs_ready <= 1'b1;
      end else begin
        cgs_counter <= cgs_counter + 1;
      end
    end
  end

  jesd204_rx_ctrl i_rx_ctrl (
    .clk(clk),
    .reset(reset),
    .phy_ready(phy_ready),
    .phy_en_char_align(en_align),
    .cgs_reset(cgs_reset),
    .cgs_ready(cgs_ready));

endmodule
