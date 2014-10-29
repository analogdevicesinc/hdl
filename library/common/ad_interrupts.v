// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
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
// ***************************************************************************
// ***************************************************************************

`timescale 1ps/1ps

module ad_interrupts (
  // interrupt lines
  input             timer_irq,
  input             eth_irq,
  input             eth_dma_mm2s_irq,
  input             eth_dma_s2mm_irq,
  input             uart_irq,
  input             gpio_lcd_irq,
  input             gpio_sw_irq,
  input             spdif_dma_irq,
  input             hdmi_dma_irq,
  input             iic_irq,
  input             dev0_dma_irq,
  input             dev1_dma_irq,
  input             dev2_dma_irq,
  input             dev3_dma_irq,
  input             dev4_dma_irq,
  input             dev5_dma_irq,
  input             spi0_irq,
  input             spi1_irq,
  input             spi2_irq,
  input             spi3_irq,
  input             gpio0_irq,
  input             gpio1_irq,
  input             gpio2_irq,
  input             gpio3_irq,
  // concatanated interrupt outputs
  output  [31:0]    mb_axi_intr,
  output  [15:0]    ps7_irq_f2p
);

  localparam  ZYNQ    = 1;
  localparam  MBLAZE  = 0;

  parameter   C_PROC_TYPE = ZYNQ;
  parameter   C_DEVICE_NR = 0;
  parameter   C_XSPI_NR   = 0;
  parameter   C_XGPIO_NR  = 0;

  localparam  IRQ_F2P_WIDTH     = 16;

  localparam  IRQ_NUMBER_ZQ     = 2 + C_DEVICE_NR + C_XSPI_NR + C_XGPIO_NR;
  localparam  IRQ_NUMBER_MB     = 10 + C_DEVICE_NR + C_XSPI_NR + C_XGPIO_NR;

  localparam  DEVICE_OFFSET_ZQ  = 2;
  localparam  XSPI_OFFSET_ZQ    = 2 + C_DEVICE_NR;
  localparam  XGPIO_OFFSET_ZQ   = 2 + C_DEVICE_NR + C_XSPI_NR;
  localparam  DEVICE_OFFSET_MB  = 10;
  localparam  XSPI_OFFSET_MB    = 10 + C_DEVICE_NR;
  localparam  XGPIO_OFFSET_MB   = 10 + C_DEVICE_NR + C_XSPI_NR;

  wire    [31:0]    mb_axi_intr_s;
  wire    [15:0]    ps7_irq_f2p_s;
  wire    [15:0]    ps7_irq_f2p_inv_s;

  // ==========================================================================
  // IRQ assignments just for MicroBlaze devices
  // ==========================================================================

  assign mb_axi_intr_s[0] = timer_irq;
  assign mb_axi_intr_s[1] = eth_irq;
  assign mb_axi_intr_s[2] = eth_dma_mm2s_irq;
  assign mb_axi_intr_s[3] = eth_dma_s2mm_irq;
  assign mb_axi_intr_s[4] = uart_irq;
  assign mb_axi_intr_s[5] = gpio_lcd_irq;
  assign mb_axi_intr_s[6] = gpio_sw_irq;
  assign mb_axi_intr_s[7] = spdif_dma_irq;

  // ==========================================================================
  // Common IRQ assignments
  // ==========================================================================

  assign mb_axi_intr_s[8] = hdmi_dma_irq;
  assign mb_axi_intr_s[9] = iic_irq;
  assign ps7_irq_f2p_s[0] = hdmi_dma_irq;
  assign ps7_irq_f2p_s[1] = iic_irq;

  // Device's DMA interrupts

  genvar i;

  generate
    for(i=0; i < C_DEVICE_NR; i=i+1) begin : DEVICE_IRQ
      assign mb_axi_intr_s[DEVICE_OFFSET_MB+i] = (i == 0) ? dev0_dma_irq :
                                                 (i == 1) ? dev1_dma_irq :
                                                 (i == 2) ? dev2_dma_irq :
                                                 (i == 3) ? dev3_dma_irq :
                                                 (i == 4) ? dev4_dma_irq :
                                                 (i == 5) ? dev5_dma_irq : 1'b0;
      assign ps7_irq_f2p_s[DEVICE_OFFSET_ZQ+i] = (i == 0) ? dev0_dma_irq :
                                                 (i == 1) ? dev1_dma_irq :
                                                 (i == 2) ? dev2_dma_irq :
                                                 (i == 3) ? dev3_dma_irq :
                                                 (i == 4) ? dev4_dma_irq :
                                                 (i == 5) ? dev5_dma_irq : 1'b0;
    end
  endgenerate

  // Additional external SPI interrupts

  generate
    for(i=0; i < C_XSPI_NR; i=i+1) begin : XSPI_NR
      assign mb_axi_intr_s[XSPI_OFFSET_MB+i] = (i == 0) ? spi0_irq :
                                               (i == 1) ? spi1_irq :
                                               (i == 2) ? spi2_irq :
                                               (i == 3) ? spi3_irq : 1'b0;
      assign ps7_irq_f2p_s[XSPI_OFFSET_ZQ+i] = (i == 0) ? spi0_irq :
                                               (i == 1) ? spi1_irq :
                                               (i == 2) ? spi2_irq :
                                               (i == 3) ? spi3_irq : 1'b0;
    end
  endgenerate

  // Additional external GPIO interrupts

  generate
    for(i=0; i < C_XGPIO_NR; i=i+1) begin : XGPIO_IRQ
      assign mb_axi_intr_s[XGPIO_OFFSET_MB+i] = (i == 0) ? gpio0_irq :
                                                (i == 1) ? gpio1_irq :
                                                (i == 2) ? gpio2_irq :
                                                (i == 3) ? gpio3_irq : 1'b0;
      assign ps7_irq_f2p_s[XGPIO_OFFSET_ZQ+i] = (i == 0) ? gpio0_irq :
                                                (i == 1) ? gpio1_irq :
                                                (i == 2) ? gpio2_irq :
                                                (i == 3) ? gpio3_irq : 1'b0;
    end
  endgenerate


  assign mb_axi_intr_s[31:IRQ_NUMBER_MB] = 'b0;
  assign ps7_irq_f2p_s[15:IRQ_NUMBER_ZQ] = 'b0;

  // output logic

  // ZYNQ interrupts are assigned from top to down
  generate
    for(i=0; i < IRQ_F2P_WIDTH; i=i+1) begin : REVERSE_IRQ_ZYNQ
      assign ps7_irq_f2p_inv_s[i] = ps7_irq_f2p_s[(IRQ_F2P_WIDTH-1)-i];
    end
  endgenerate

  assign mb_axi_intr = (C_PROC_TYPE == MBLAZE) ? mb_axi_intr_s : 32'b0;
  assign ps7_irq_f2p = (C_PROC_TYPE == ZYNQ)   ? ps7_irq_f2p_inv_s : 16'b0;

endmodule
