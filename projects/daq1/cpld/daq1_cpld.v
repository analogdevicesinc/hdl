// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsabilities that he or she has by using this source/core.
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

module daq1_cpld (

  // FMC SPI interface

  input                   fmc_spi_sclk,
  input                   fmc_spi_csn,
  inout                   fmc_spi_sdio,
  output                  fmc_irq,

  // on board SPI interface

  output                  adc_spicsn,
  output                  dac_spicsn,
  output                  clk_spicsn,
  output                  sclk,
  inout                   sdio,

  // control and status lines

  input                   adc_fda,
  input                   adc_fdb,
  input                   adc_status_p,
  input                   adc_status_n,
  output                  adc_pwdn_stby,

  input                   dac_irqn,
  output                  dac_resetn,

  input                   clk_status1,
  input                   clk_status2,
  output                  clk_pwdnn,
  output                  clk_syncn,
  output                  clk_resetn
);

  // FMC SPI Selects

  localparam  [ 7:0]  FMC_SPI_SEL_AD9684  = 8'h80;
  localparam  [ 7:0]  FMC_SPI_SEL_AD9122  = 8'h81;
  localparam  [ 7:0]  FMC_SPI_SEL_AD9523  = 8'h82;
  localparam  [ 7:0]  FMC_SPI_SEL_CPLD    = 8'h83;

  // CPLD Register Map Addresses

  localparam  [ 6:0]  CPLD_VERSION_ADDR   = 7'h00;
  localparam  [ 6:0]  ADC_CONTROL_ADDR    = 7'h10;
  localparam  [ 6:0]  DAC_CONTROL_ADDR    = 7'h11;
  localparam  [ 6:0]  CLK_CONTROL_ADDR    = 7'h12;
  localparam  [ 6:0]  IRQ_MASK_ADDR       = 7'h13;
  localparam  [ 6:0]  ADC_STATUS_ADDR     = 7'h20;
  localparam  [ 6:0]  DAC_STATUS_ADDR     = 7'h21;
  localparam  [ 6:0]  CLK_STATUS_ADDR     = 7'h22;

  localparam  [ 7:0]  CPLD_VERSION        = 8'h11;

  // Internal Registers/Signals

  reg   [ 7:0]  fmc_spi_dev_sel = 8'b0;
  reg   [ 7:0]  fmc_cpld_addr = 8'b0;
  reg   [ 5:0]  fmc_spi_counter = 6'b0;
  reg           fmc_spi_csn_enb = 1'b1;

  reg   [ 7:0]  adc_control = 8'b0;
  reg   [ 7:0]  dac_control = 8'b0;
  reg   [ 7:0]  clk_control = 8'b0;

  reg   [ 7:0]  adc_status = 8'b0;
  reg   [ 7:0]  dac_status = 8'b0;
  reg   [ 7:0]  clk_status = 8'b0;

  reg           cpld_to_fpga = 1'b0;
  reg    [ 7:0] cpld_rdata = 8'b0;
  reg           cpld_rdata_bit = 1'b0;
  reg    [ 2:0] cpld_rdata_index = 3'h0;
  reg    [ 7:0] cpld_wdata = 8'b0;
  reg    [ 7:0] cpld_irq_mask = 8'b0;
  reg    [ 7:0] cpld_irq = 8'b0;

  wire          rdnwr;
  wire          cpld_rdata_s;

  // SCLK counter for control signals

  always @(posedge fmc_spi_sclk or posedge fmc_spi_csn) begin
    if (fmc_spi_csn == 1'b1) begin
      fmc_spi_dev_sel <= 8'h0;
      fmc_cpld_addr <= 8'h0;
    end else begin
      if (fmc_spi_counter <= 7) begin
        fmc_spi_dev_sel <= {fmc_spi_dev_sel[6:0], fmc_spi_sdio};
      end
      if (fmc_spi_counter <= 15) begin
        fmc_cpld_addr <= {fmc_cpld_addr[6:0], fmc_spi_sdio};
      end
    end
  end

  // chip select control

  assign adc_spicsn = (fmc_spi_dev_sel == FMC_SPI_SEL_AD9684) ? (fmc_spi_csn | fmc_spi_csn_enb) : 1'b1;
  assign dac_spicsn = (fmc_spi_dev_sel == FMC_SPI_SEL_AD9122) ? (fmc_spi_csn | fmc_spi_csn_enb) : 1'b1;
  assign clk_spicsn = (fmc_spi_dev_sel == FMC_SPI_SEL_AD9523) ? (fmc_spi_csn | fmc_spi_csn_enb) : 1'b1;
  assign cpld_spicsn = (fmc_spi_dev_sel == FMC_SPI_SEL_CPLD) ? (fmc_spi_csn | fmc_spi_csn_enb) : 1'b1;

  // SPI control and data

  assign sdio = cpld_to_fpga ? 1'bZ : fmc_spi_sdio;
  assign fmc_spi_sdio = cpld_to_fpga ? cpld_rdata_s : 1'bZ ;
  assign cpld_rdata_s = cpld_spicsn ? sdio : cpld_rdata_bit;
  assign rdnwr = fmc_cpld_addr[7];

  assign sclk = (~(fmc_spi_csn | fmc_spi_csn_enb)) ? fmc_spi_sclk : 1'b0;

  always @(negedge fmc_spi_sclk or posedge fmc_spi_csn) begin
    if (fmc_spi_csn == 1'b1) begin
      fmc_spi_counter <= 6'h0;
      cpld_to_fpga <= 1'b0;
      fmc_spi_csn_enb <= 1'b1;
    end else begin
      fmc_spi_counter <= (fmc_spi_counter <= 6'h3F) ? fmc_spi_counter + 1 : fmc_spi_counter;
      fmc_spi_csn_enb <= (fmc_spi_counter < 7) ? 1'b1 : 1'b0;
      if (adc_spicsn & clk_spicsn) begin
        cpld_to_fpga <= (fmc_spi_counter >= 15) ? rdnwr : 1'b0;
      end else begin
        cpld_to_fpga <= (fmc_spi_counter >= 23) ? rdnwr : 1'b0;
      end
    end
  end

  // Internal register read access

  always @(fmc_cpld_addr) begin
    case (fmc_cpld_addr[6:0])
      CPLD_VERSION_ADDR :
        cpld_rdata <= CPLD_VERSION;
      ADC_CONTROL_ADDR :
        cpld_rdata <= adc_pwdn_stby;
      DAC_CONTROL_ADDR :
        cpld_rdata <= dac_resetn;
      CLK_CONTROL_ADDR :
        cpld_rdata <= {clk_syncn, clk_resetn, clk_pwdnn};
      IRQ_MASK_ADDR:
        cpld_rdata <= cpld_irq_mask;
      ADC_STATUS_ADDR  :
        cpld_rdata <= {adc_status_p, adc_fdb, adc_fda};
      DAC_STATUS_ADDR  :
        cpld_rdata <= dac_irqn;
      CLK_STATUS_ADDR  :
        cpld_rdata <= {clk_status2, clk_status1};
      default:
        cpld_rdata <= 8'hFA;
    endcase
  end

  always @(negedge fmc_spi_sclk or posedge fmc_spi_csn) begin
    if (fmc_spi_csn == 1'b1) begin
      cpld_rdata_bit <= cpld_rdata[7];
      cpld_rdata_index <= 3'h6;
    end else begin
      if (cpld_to_fpga == 1'b1) begin
        cpld_rdata_bit <= cpld_rdata[cpld_rdata_index];
        cpld_rdata_index <= cpld_rdata_index - 1;
      end
    end
  end

  // Internal register write access

  always @(cpld_to_fpga, cpld_spicsn, fmc_spi_counter) begin
    if ((cpld_to_fpga == 1'b0) &&
        (cpld_spicsn == 1'b0) &&
        (fmc_spi_counter == 8'h18)) begin
      case (fmc_cpld_addr[6:0])
        ADC_CONTROL_ADDR :
          adc_control <= cpld_wdata;
        DAC_CONTROL_ADDR :
          dac_control <= cpld_wdata;
        CLK_CONTROL_ADDR :
          clk_control <= cpld_wdata;
        IRQ_MASK_ADDR:
          cpld_irq_mask <= cpld_wdata;
      endcase
    end
  end

  always @(posedge fmc_spi_sclk or posedge fmc_spi_csn) begin
    if (fmc_spi_csn == 1'b1) begin
      cpld_wdata <= 8'h0;
    end else begin
      if (fmc_spi_counter >= 16) begin
        cpld_wdata <= {cpld_wdata[6:0], fmc_spi_sdio};
      end
    end
  end

  // input/output logic

  // AD9648

  assign adc_pwdn_stby = adc_control[0];

  // AD9122

  assign dac_resetn = dac_control[0];

  // AD9523-1

  assign clk_pwdnn = clk_control[0];
  assign clk_resetn = clk_control[1];
  assign clk_syncn = clk_control[2];

  // interrupt logic

  always @(*) begin
    cpld_irq <= {2'b00, dac_irqn, clk_status2, clk_status1, adc_status_p, adc_fdb, adc_fda};
  end

  assign fmc_irq = |(~cpld_irq_mask & cpld_irq);

endmodule

