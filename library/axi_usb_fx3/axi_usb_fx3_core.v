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

module axi_usb_fx3_core (

  input                   clk,
  input                   reset,

  // s2mm

  input       [31:0]      s_axis_tdata,
  input       [ 3:0]      s_axis_tkeep,
  input                   s_axis_tlast,
  output  reg             s_axis_tready,
  input                   s_axis_tvalid,

  // mm2s

  output  reg [31:0]      m_axis_tdata,
  output  reg [ 3:0]      m_axis_tkeep,
  output  reg             m_axis_tlast,
  input                   m_axis_tready,
  output  reg             m_axis_tvalid,

  // configuration

  input       [ 7:0]      fifo0_header_size,
  input       [15:0]      fifo0_buffer_size,

  input       [ 7:0]      fifo1_header_size,
  input       [15:0]      fifo1_buffer_size,

  input       [ 7:0]      fifo2_header_size,
  input       [15:0]      fifo2_buffer_size,

  input       [ 7:0]      fifo3_header_size,
  input       [15:0]      fifo3_buffer_size,

  input       [ 7:0]      fifo4_header_size,
  input       [15:0]      fifo4_buffer_size,

  input       [ 7:0]      fifo5_header_size,
  input       [15:0]      fifo5_buffer_size,

  input       [ 7:0]      fifo6_header_size,
  input       [15:0]      fifo6_buffer_size,

  input       [ 7:0]      fifo7_header_size,
  input       [15:0]      fifo7_buffer_size,

  input       [ 7:0]      fifo8_header_size,
  input       [15:0]      fifo8_buffer_size,

  input       [ 7:0]      fifo9_header_size,
  input       [15:0]      fifo9_buffer_size,

  input       [ 7:0]      fifoa_header_size,
  input       [15:0]      fifoa_buffer_size,

  input       [ 7:0]      fifob_header_size,
  input       [15:0]      fifob_buffer_size,

  input       [ 7:0]      fifoc_header_size,
  input       [15:0]      fifoc_buffer_size,

  input       [ 7:0]      fifod_header_size,
  input       [15:0]      fifod_buffer_size,

  input       [ 7:0]      fifoe_header_size,
  input       [15:0]      fifoe_buffer_size,

  input       [ 7:0]      fifof_header_size,
  input       [15:0]      fifof_buffer_size,

  output  reg [31:0]      length_fx32dma,
  output  reg [31:0]      length_dma2fx3,

  // fx3 interface
  // IN -> TO HOST / FX3
  // OUT -> FROM HOST / FX3

  input                   fx32dma_valid,
  output                  fx32dma_ready,
  input       [31:0]      fx32dma_data,
  input                   fx32dma_sop,
  output  reg             fx32dma_eop,

  input                   dma2fx3_ready,
  output  reg             dma2fx3_valid,
  output  reg [31:0]      dma2fx3_data,
  output  reg             dma2fx3_eop,

  output                  error,
  output  reg             eot_fx32dma,
  output  reg             eot_dma2fx3,

  input       [ 2:0]      test_mode_tpm,
  input       [ 2:0]      test_mode_tpg,
  output  reg             monitor_error,

  input                   zlp,

  input       [ 4:0]      fifo_num);

  // internal parameters

  localparam IDLE         = 3'b001;
  localparam READ_HEADER  = 3'b010;
  localparam ADD_FOOTER   = 3'b010;
  localparam READ_DATA    = 3'b100;

  // internal signals

  wire            test_mode_active_tpm;
  wire            test_mode_active_tpg;

  // internal registers

  reg     [31:0]  data_size_transaction = 32'hffffffff;
  reg     [15:0]  buffer_size_current = 16'h0;
  reg     [ 7:0]  header_size_current = 8'h0;

  reg             error_fx32dma = 1'b0;
  reg             error_dma2fx3 = 1'b0;

  reg     [ 2:0]  state_fx32dma = 3'h0;
  reg     [ 2:0]  next_state_fx32dma = 3'h0;

  reg     [ 2:0]  state_dma2fx3 = 3'h0;
  reg     [ 2:0]  next_state_dma2fx3 = 3'h0;

  reg     [ 7:0]  header_pointer = 8'h0;
  reg             header_read = 1'b0;

  reg     [31:0]  dma2fx3_counter = 32'h0;
  reg     [ 7:0]  footer_pointer = 8'h0;

  reg     [31:0]  dma2fx3_data_reg = 32'h0;

  reg     [31:0]  expected_data = 32'h0;
  reg             first_transfer = 1'b0;

  function [31:0] pn23;
    input [31:0] din;
    reg   [31:0] dout;
    begin
      dout[31] = din[22] ^ din[17];
      dout[30] = din[21] ^ din[16];
      dout[29] = din[20] ^ din[15];
      dout[28] = din[19] ^ din[14];
      dout[27] = din[18] ^ din[13];
      dout[26] = din[17] ^ din[12];
      dout[25] = din[16] ^ din[11];
      dout[24] = din[15] ^ din[10];
      dout[23] = din[14] ^ din[ 9];
      dout[22] = din[13] ^ din[ 8];
      dout[21] = din[12] ^ din[ 7];
      dout[20] = din[11] ^ din[ 6];
      dout[19] = din[10] ^ din[ 5];
      dout[18] = din[ 9] ^ din[ 4];
      dout[17] = din[ 8] ^ din[ 3];
      dout[16] = din[ 7] ^ din[ 2];
      dout[15] = din[ 6] ^ din[ 1];
      dout[14] = din[ 5] ^ din[ 0];
      dout[13] = din[ 4] ^ din[22] ^ din[17];
      dout[12] = din[ 3] ^ din[21] ^ din[16];
      dout[11] = din[ 2] ^ din[20] ^ din[15];
      dout[10] = din[ 1] ^ din[19] ^ din[14];
      dout[ 9] = din[ 0] ^ din[18] ^ din[13];
      dout[ 8] = din[22] ^ din[12];
      dout[ 7] = din[21] ^ din[11];
      dout[ 6] = din[20] ^ din[10];
      dout[ 5] = din[19] ^ din[ 9];
      dout[ 4] = din[18] ^ din[ 8];
      dout[ 3] = din[17] ^ din[ 7];
      dout[ 2] = din[16] ^ din[ 6];
      dout[ 1] = din[15] ^ din[ 5];
      dout[ 0] = din[14] ^ din[ 4];
      pn23 = dout;
    end
  endfunction

  function [31:0] pn9;
    input [31:0] din;
    reg   [31:0] dout;
    begin
      dout[31] = din[ 8] ^ din[ 4];
      dout[30] = din[ 7] ^ din[ 3];
      dout[29] = din[ 6] ^ din[ 2];
      dout[28] = din[ 5] ^ din[ 1];
      dout[27] = din[ 4] ^ din[ 0];
      dout[26] = din[ 3] ^ din[ 8] ^ din[ 4];
      dout[25] = din[ 2] ^ din[ 7] ^ din[ 3];
      dout[24] = din[ 1] ^ din[ 6] ^ din[ 2];
      dout[23] = din[ 0] ^ din[ 5] ^ din[ 1];
      dout[22] = din[ 8] ^ din[ 0];
      dout[21] = din[ 7] ^ din[ 8] ^ din[ 4];
      dout[20] = din[ 6] ^ din[ 7] ^ din[ 3];
      dout[19] = din[ 5] ^ din[ 6] ^ din[ 2];
      dout[18] = din[ 4] ^ din[ 5] ^ din[ 1];
      dout[17] = din[ 3] ^ din[ 4] ^ din[ 0];
      dout[16] = din[ 2] ^ din[ 3] ^ din[ 8] ^ din[ 4];
      dout[15] = din[ 1] ^ din[ 2] ^ din[ 7] ^ din[ 3];
      dout[14] = din[ 0] ^ din[ 1] ^ din[ 6] ^ din[ 2];
      dout[13] = din[ 8] ^ din[ 0] ^ din[ 4] ^ din[ 5] ^ din[ 1];
      dout[12] = din[ 7] ^ din[ 8] ^ din[ 3] ^ din[ 0];
      dout[11] = din[ 6] ^ din[ 7] ^ din[ 2] ^ din[ 8] ^ din[ 4];
      dout[10] = din[ 5] ^ din[ 6] ^ din[ 1] ^ din[ 7] ^ din[ 3];
      dout[ 9] = din[ 4] ^ din[ 5] ^ din[ 0] ^ din[ 6] ^ din[ 2];
      dout[ 8] = din[ 3] ^ din[ 8] ^ din[ 5] ^ din[ 1];
      dout[ 7] = din[ 2] ^ din[ 4] ^ din[ 7] ^ din[ 0];
      dout[ 6] = din[ 1] ^ din[ 3] ^ din[ 6] ^ din[ 8] ^ din[ 4];
      dout[ 5] = din[ 0] ^ din[ 2] ^ din[ 5] ^ din[ 7] ^ din[ 3];
      dout[ 4] = din[ 8] ^ din[ 1] ^ din[ 6] ^ din[ 2];
      dout[ 3] = din[ 7] ^ din[ 0] ^ din[ 5] ^ din[ 1];
      dout[ 2] = din[ 6] ^ din[ 8] ^ din[ 0];
      dout[ 1] = din[5] ^ din[7] ^ din[8] ^ din[4];
      dout[ 0] = din[4] ^ din[6] ^ din[7] ^ din[3];
      pn9 = dout;
    end
  endfunction

  assign error = error_fx32dma | error_dma2fx3;

  assign test_mode_active_tpm = |test_mode_tpm;
  assign test_mode_active_tpg = |test_mode_tpg;

  // fx32dma

  assign fx32dma_ready = m_axis_tready;

  always @(*) begin
    case (fifo_num)
      5'h0: buffer_size_current = fifo0_buffer_size;
      5'h1: buffer_size_current = fifo1_buffer_size;
      5'h2: buffer_size_current = fifo2_buffer_size;
      5'h3: buffer_size_current = fifo3_buffer_size;
      5'h4: buffer_size_current = fifo4_buffer_size;
      5'h5: buffer_size_current = fifo5_buffer_size;
      5'h6: buffer_size_current = fifo6_buffer_size;
      5'h7: buffer_size_current = fifo7_buffer_size;
      5'h8: buffer_size_current = fifo8_buffer_size;
      5'h9: buffer_size_current = fifo9_buffer_size;
      5'ha: buffer_size_current = fifoa_buffer_size;
      5'hb: buffer_size_current = fifob_buffer_size;
      5'hc: buffer_size_current = fifoc_buffer_size;
      5'hd: buffer_size_current = fifod_buffer_size;
      5'he: buffer_size_current = fifoe_buffer_size;
      5'hf: buffer_size_current = fifof_buffer_size;
      default: buffer_size_current = fifo0_buffer_size;
    endcase
    case (fifo_num)
      5'h0: header_size_current = fifo0_header_size;
      5'h1: header_size_current = fifo1_header_size;
      5'h2: header_size_current = fifo2_header_size;
      5'h3: header_size_current = fifo3_header_size;
      5'h4: header_size_current = fifo4_header_size;
      5'h5: header_size_current = fifo5_header_size;
      5'h6: header_size_current = fifo6_header_size;
      5'h7: header_size_current = fifo7_header_size;
      5'h8: header_size_current = fifo8_header_size;
      5'h9: header_size_current = fifo9_header_size;
      5'ha: header_size_current = fifoa_header_size;
      5'hb: header_size_current = fifob_header_size;
      5'hc: header_size_current = fifoc_header_size;
      5'hd: header_size_current = fifod_header_size;
      5'he: header_size_current = fifoe_header_size;
      5'hf: header_size_current = fifof_header_size;
      default: header_size_current = fifo0_header_size;
    endcase
  end

  // state machine

  always @(posedge clk) begin
    if (reset == 1'b1 || error_fx32dma == 1'b1) begin
      state_fx32dma <= IDLE;
    end else begin
      state_fx32dma <= next_state_fx32dma;
    end
  end

  always @(*) begin
    case(state_fx32dma)
      IDLE:
      if(fx32dma_sop == 1'b1) begin
        next_state_fx32dma = READ_HEADER;
      end else begin
        next_state_fx32dma = state_fx32dma;
      end
      READ_HEADER:
      if(header_read == 1'b1) begin
        next_state_fx32dma = READ_DATA;
      end else begin
        next_state_fx32dma = state_fx32dma;
      end
      READ_DATA:
      if(data_size_transaction <= 4) begin
        next_state_fx32dma = IDLE;
      end else begin
        next_state_fx32dma = state_fx32dma;
      end
      default: next_state_fx32dma = IDLE;
    endcase
  end

  always @(*) begin
    m_axis_tdata = fx32dma_data;
    fx32dma_eop = 1'b0;
    m_axis_tlast = 1'b0;
    case(state_fx32dma)
      IDLE: begin
        m_axis_tvalid = 1'b0;
        m_axis_tkeep = 4'h0;
        eot_fx32dma  = 1'b0;
      end
      READ_HEADER: begin
        m_axis_tvalid = 1'b0;
        m_axis_tkeep = 4'h0;
        m_axis_tlast = 1'b0;
        eot_fx32dma  = 1'b0;
      end
      READ_DATA: begin
        m_axis_tvalid = fx32dma_valid;
        if (fx32dma_valid == 1'b1) begin
          if (data_size_transaction > 12 ) begin
            fx32dma_eop = 1'b0;
          end else begin
            fx32dma_eop = 1'b1;
          end
          if (data_size_transaction > 4) begin
            m_axis_tlast = 1'b0;
            m_axis_tkeep = 4'hf;
            eot_fx32dma  = 1'b0;
          end else begin
            m_axis_tlast = 1'b1;
            eot_fx32dma  = 1'b1;
            m_axis_tlast = 1'b1;
            case (data_size_transaction)
              1: m_axis_tkeep = 4'h1;
              2: m_axis_tkeep = 4'h3;
              3: m_axis_tkeep = 4'h7;
              default: m_axis_tkeep = 4'hf;
            endcase
          end
        end else begin
          m_axis_tkeep = 4'h0;
          eot_fx32dma  = 1'b0;
        end
      end
      default: begin
        m_axis_tvalid = 1'b0;
        m_axis_tkeep = 4'h0;
        m_axis_tlast = 1'b0;
        eot_fx32dma  = 1'b0;
      end
    endcase
  end

  always @(posedge clk) begin
    header_read <= 1'b0;
    if (state_fx32dma == IDLE) begin
      if (fx32dma_sop == 1'b1) begin
        header_pointer <= 8'h4;
        if (fx32dma_data != 32'h0ff00ff0) begin
          error_fx32dma <= 1'b1;
        end else begin
          error_fx32dma <= 1'b0;
        end
      end
      case (test_mode_tpm)
        4'h1: expected_data <= 32'haaaaaaaa;
        default: expected_data <= 32'hffffffff;
      endcase
    end
    if (state_fx32dma == READ_HEADER) begin
      if (fx32dma_valid == 1'b1) begin
        if (m_axis_tready == 1'b0) begin
          error_fx32dma <= 1'b1;
        end
        if(header_pointer < header_size_current - 4) begin
          header_pointer <= header_pointer + 8;
        end else begin
          header_read <= 1'b1;
        end
        if (header_pointer == 4) begin
          data_size_transaction <= fx32dma_data;
          length_fx32dma <= fx32dma_data;
          if (fx32dma_data > buffer_size_current) begin
            error_fx32dma <= 1'b1;
          end
        end
      end
    end
    if (state_fx32dma == READ_DATA) begin
      first_transfer <= 1'b1;
      if (fx32dma_valid == 1'b1) begin
        first_transfer <= 1'b0;
        if (data_size_transaction > 4) begin
          data_size_transaction <= data_size_transaction - 4;
        end
      end

      // monitor

      if (test_mode_active_tpm == 1'b1) begin
        if (first_transfer == 1) begin
          expected_data <= fx32dma_data;
        end else begin
          case (test_mode_tpm)
            4'h1: expected_data <= ~expected_data;
            4'h2: expected_data <= ~expected_data;
            4'h3: expected_data <= pn9(expected_data);
            4'h4: expected_data <= pn23(expected_data);
            4'h7: expected_data <= expected_data + 1;
            default:  expected_data <= 0;
          endcase
          if (expected_data != m_axis_tdata) begin
            monitor_error <= 1'b1;
          end else begin
            monitor_error <= 1'b0;
          end
        end
      end
    end
  end

  // dma2fx3

  always @(posedge clk) begin
    if (reset == 1'b1 || error_dma2fx3 == 1'b1) begin
      state_dma2fx3 <= IDLE;
    end else begin
      state_dma2fx3 <= next_state_dma2fx3;
    end
  end

  always @(*) begin
    case(state_dma2fx3)
      IDLE:
        if(dma2fx3_ready == 1'b1) begin
          if  (zlp == 1'b1) begin
            next_state_dma2fx3 = ADD_FOOTER;
          end else begin
            next_state_dma2fx3 = READ_DATA;
          end
        end else begin
          next_state_dma2fx3 = IDLE;
        end
      READ_DATA:
        if(s_axis_tlast == 1'b1 || dma2fx3_counter >= buffer_size_current - 4) begin
          next_state_dma2fx3 = ADD_FOOTER;
        end else begin
          next_state_dma2fx3 = READ_DATA;
        end
      ADD_FOOTER:
        if(dma2fx3_eop == 1'b1) begin
          next_state_dma2fx3 = IDLE;
        end else begin
          next_state_dma2fx3 = ADD_FOOTER;
        end
      default: next_state_dma2fx3 = IDLE;
    endcase
  end

  always @(*) begin
    case(state_dma2fx3)
      IDLE: begin
        s_axis_tready = 1'b0;
        dma2fx3_valid = 1'b0;
        eot_dma2fx3   = 1'b0;
        dma2fx3_eop   = 1'b0;
        dma2fx3_data  = dma2fx3_data_reg;
      end
      READ_DATA: begin
        eot_dma2fx3 = 1'b0;
        if (test_mode_active_tpg == 1'b1) begin
          s_axis_tready = 1'b0;
          dma2fx3_valid = 1'b1;
        end else begin
          dma2fx3_valid = s_axis_tvalid & s_axis_tready;
          s_axis_tready = dma2fx3_ready;
        end
        dma2fx3_eop = 1'b0;
        if (test_mode_active_tpg == 1'b1) begin
          dma2fx3_data = dma2fx3_data_reg;
        end else begin
          dma2fx3_data = s_axis_tdata;
        end
      end
      ADD_FOOTER: begin
        s_axis_tready = 1'b0;
        dma2fx3_valid = 1'b1;
        if (footer_pointer == header_size_current) begin
          dma2fx3_eop = 1'b1;
          eot_dma2fx3 = 1'b1;
        end else begin
          dma2fx3_eop = 1'b0;
          eot_dma2fx3 = 1'b0;
        end
        dma2fx3_data = dma2fx3_data_reg;
      end
      default: begin
        s_axis_tready = 1'b0;
        dma2fx3_valid = 1'b0;
        eot_dma2fx3   = 1'b0;
        dma2fx3_eop   = 1'b0;
        dma2fx3_data  = dma2fx3_data_reg;
      end
    endcase
  end

  always @(posedge clk) begin
    if(state_dma2fx3 == IDLE) begin
      footer_pointer <= 4;
      dma2fx3_counter <= 0;
      case (test_mode_tpg)
        4'h1: dma2fx3_data_reg <= 32'haaaaaaaa;
        default:  dma2fx3_data_reg <= 32'hffffffff;
      endcase
      if (zlp == 1'b1) begin
        dma2fx3_data_reg <= 32'h0ff00ff0;
      end
    end

    if(state_dma2fx3 == READ_DATA) begin
      if (test_mode_active_tpg == 1'b1) begin
        if (dma2fx3_ready == 1'b1) begin
          dma2fx3_counter <= dma2fx3_counter + 4;
          if (dma2fx3_counter >= buffer_size_current - 4) begin
            dma2fx3_data_reg <= 32'h0ff00ff0;
          end else begin
            case (test_mode_tpg)
              4'h1: dma2fx3_data_reg <= ~dma2fx3_data_reg;
              4'h2: dma2fx3_data_reg <= ~dma2fx3_data_reg;
              4'h3: dma2fx3_data_reg <= pn9(dma2fx3_data_reg);
              4'h4: dma2fx3_data_reg <= pn23(dma2fx3_data_reg);
              4'h7: dma2fx3_data_reg <= dma2fx3_data_reg + 1;
              default:  dma2fx3_data_reg <= 0;
            endcase
          end
        end
      end else begin
          dma2fx3_data_reg <= 32'h0ff00ff0;
        if (s_axis_tvalid== 1'b1 && s_axis_tready == 1'b1) begin
          case (s_axis_tkeep)
            1: dma2fx3_counter <= dma2fx3_counter + 1;
            3: dma2fx3_counter <= dma2fx3_counter + 2;
            7: dma2fx3_counter <= dma2fx3_counter + 3;
            default: dma2fx3_counter <= dma2fx3_counter + 4;
          endcase
        end
      end
    end

    if(state_dma2fx3 == ADD_FOOTER) begin
      footer_pointer <= footer_pointer + 4;
      length_dma2fx3 <= dma2fx3_counter;
      case(footer_pointer)
        32'h4: dma2fx3_data_reg <= dma2fx3_counter;
        32'h8: dma2fx3_data_reg <= 32'h0;
        default: dma2fx3_data_reg <= 32'h0;
      endcase
    end
  end

endmodule
