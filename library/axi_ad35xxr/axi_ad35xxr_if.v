// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2025 Analog Devices, Inc. All rights reserved.
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

module axi_ad35xxr_if (

  input                   clk_in,  // 132MHz
  input                   reset_in,
  input       [31:0]      dac_data,
  input                   dac_data_valid,
  input                   dac_data_valid_ext,
  output                  dac_data_ready,

  input       [ 7:0]      address,
  input       [23:0]      data_write,
  input       [ 1:0]      multi_io_mode,
  input                   sdr_ddr_n,
  input                   symb_8_16b,
  input                   transfer_data,
  input                   stream,
  input                   external_sync,
  input                   external_sync_arm,

  output                  if_busy,
  output                  sync_ext_device,
  output reg  [23:0]      data_read,

  // DAC control signals

  output                  sclk,
  output reg              csn,
  input       [ 3:0]      sdio_i,
  output      [ 3:0]      sdio_o,
  output      [ 3:0]      sdio_t
);

  wire            transfer_data_s;
  wire            start_synced;
  wire   [31:0]   dac_data_int;
  wire            dac_data_valid_synced;
  wire            external_sync_s;

  reg    [55:0]   transfer_reg_single = 0;
  reg    [55:0]   transfer_reg_dual   = 0;
  reg    [55:0]   transfer_reg_quad   = 0;

  reg    [15:0]   counter             = 0;
  reg             wa_cp               = 1'b0;
  reg    [ 3:0]   tf_cp               = 4'h0;
  reg    [ 3:0]   st_cp               = 4'h0;
  reg    [ 2:0]   transfer_state      = 0;
  reg    [ 2:0]   transfer_state_next = 0;
  reg    [ 2:0]   transfer_state_p    = 0;
  reg    [ 2:0]   transfer_state_prev = 0;
  reg             cycle_done          = 1'b0;
  reg             transfer_step       = 1'b0;
  reg             sclk_ddr            = 1'b0;
  reg             full_speed          = 1'b0;
  reg             transfer_data_d     = 1'b0;
  reg             transfer_data_dd    = 1'b0;
  reg    [ 3:0]   valid_captured_d    = 4'b0;
  reg             data_r_wn           = 1'b0;
  reg             valid_captured      = 1'b0;
  reg             start_transfer      = 1'b0;
  reg             if_busy_reg         = 1'b0;
  reg             dac_data_ready_s    = 1'b0;
  reg             external_sync_arm_reg = 1'b0;
  reg             external_sync_reg = 1'b0;

  localparam  [ 2:0]  IDLE = 3'h0,
                      CS_LOW = 3'h1,
                      WRITE_ADDRESS = 3'h2,
                      TRANSFER_REGISTER = 3'h3,
                      READ_REGISTER = 3'h4,
                      STREAM = 3'h5,
                      CS_HIGH = 3'h6;

  assign if_busy = if_busy_reg;

  // transform the transfer data rising edge into a pulse

  assign transfer_data_s = transfer_data_d & ~transfer_data_dd;

  // start the data stream transfer after valid has been captured

  assign start_synced = valid_captured_d[1] & start_transfer & stream;
  assign sync_ext_device = start_synced;

  // use dac_data valid from an external source only if external_sync_arm_reg is 1

  assign dac_data_valid_synced = (external_sync_arm_reg == 1'b1) ? (dac_data_valid & dac_data_valid_ext) : dac_data_valid ;
  assign dac_data_ready = dac_data_ready_s & dac_data_valid_synced;
  assign dac_data_int = dac_data;

  // sync the data only if the synchronizations has been armed in software

  assign external_sync_s =  ~external_sync_arm_reg | external_sync_reg;

  always @(posedge clk_in) begin
    if(reset_in == 1'b1) begin
      transfer_data_d  <= 'd0;
      transfer_data_dd <= 'd0;
      valid_captured_d <= 4'b0;
      valid_captured   <= 1'b0;
    end else begin
      transfer_data_d  <= transfer_data;
      transfer_data_dd <= transfer_data_d;
      valid_captured_d <= {valid_captured_d[2:0], valid_captured};
    end
    if(transfer_state == CS_HIGH || stream == 1'b0) begin
      start_transfer <= 1'b0;
      valid_captured <= 1'b0;
      valid_captured_d <= 4'b0;
    end

   // pulse to level conversion

    if(external_sync_arm == 1'b1) begin
      external_sync_arm_reg <= 1'b1;
    end
    if(external_sync == 1'b1) begin
      external_sync_reg <= 1'b1;
    end

    if(transfer_state == CS_HIGH) begin
      external_sync_arm_reg <= 1'b0;
      external_sync_reg <= 1'b0;
    end

    if(dac_data_valid == 1'b1 && start_transfer == 1'b1) begin
      valid_captured <= 1'b1;
    end
    if(transfer_data == 1'b1) begin
      start_transfer <= 1'b1;
    end

  end

  always @(posedge clk_in) begin
    if (reset_in == 1'b1) begin
      transfer_state <= IDLE;
    end else begin
      transfer_state <= transfer_state_next;
      transfer_state_p <= transfer_state_prev;
    end
  end

  // FSM next state logic

  always @(*) begin
    case (transfer_state)
      IDLE : begin
        // goes in to the next state only if the control is to transfer register or synced transfer(if it's armed in software)
        transfer_state_next = ((transfer_data_s == 1'b1 && stream == 1'b0) || (start_synced == 1'b1 && external_sync_s))  ? CS_LOW : IDLE;
        transfer_state_prev = IDLE;
        csn = 1'b1;
        transfer_step = 0;
        cycle_done = 0;
      end
      CS_LOW : begin
        // brings CS down
        // loads all configuration
        // puts data on the SDIO pins
        // needs 5 ns before the rising edge of the clock (t2)
        transfer_state_next = WRITE_ADDRESS;
        transfer_state_prev = CS_LOW;
        csn = 1'b0;
        transfer_step = 0;
        cycle_done = 0;
      end
      WRITE_ADDRESS : begin
        // writes the address
        // 8-bit addressing requires 8 clock cycles because dual mode only support
        // the address on a single lane
        // step requires at least (t1)ns
        // it works either at full speed (66 MHz) when streaming or
        // normal at speed (16.5 MHz)
        // full speed - 2 clock cycles
        // half speed 8 clock cycles
        cycle_done = wa_cp; //It is considering 8 bit address only
        transfer_state_next = cycle_done ? (stream ? STREAM : TRANSFER_REGISTER) : WRITE_ADDRESS;
        transfer_state_prev = WRITE_ADDRESS;
        csn = 1'b0;
        // in streaming, change data on falledge. On regular transfer, change data on negedge.
        transfer_step = full_speed ? counter[0] : ((counter[2:0] == 3'h5));
      end
      TRANSFER_REGISTER : begin
        // always works at 15 MHz due to the DAC limitation
        // can be DDR or SDR
        // counter is based on the "Clock Cycles Required to Transfer One Byte" table in the doc
        cycle_done = (sdr_ddr_n | data_r_wn) ? (symb_8_16b ? tf_cp[0] : tf_cp[1]):
                                               (symb_8_16b ? tf_cp[2] : tf_cp[3]);
                                 // DDR requires one more cycle to fulfill t3
                                 // DDR is only allowed in writte operations
                                 // It is necessary to keep sclk low for the last bit
        transfer_state_next = cycle_done ? CS_HIGH : TRANSFER_REGISTER;
        csn = 1'b0;
        // in DDR mode, change data on falledge
        transfer_step = (sdr_ddr_n | data_r_wn) ? (counter[2:0] == 3'h5) : ((counter[1:0] == 2'h0) && (transfer_state_p != WRITE_ADDRESS));
        transfer_state_prev = TRANSFER_REGISTER;
      end
      STREAM : begin
        // can be DDR or SDR
        // in DDR mode needs to be make sure the clock and data is shifted by 2 ns (t7 and t8)
        // the last word in the stream needs one more clock cycle to guarantee t3
        cycle_done = stream ? ((sdr_ddr_n | data_r_wn) ? st_cp[0] : st_cp[1]):
                              ((sdr_ddr_n | data_r_wn) ? st_cp[2] : st_cp[3]);
        transfer_state_next = (stream && external_sync_s) ? STREAM: ((cycle_done || external_sync_s == 1'b0) ?  CS_HIGH :STREAM);
        transfer_state_prev = STREAM;
        csn = 1'b0;
        transfer_step = (sdr_ddr_n | data_r_wn) ? counter[0] :  1'b1;
      end
      CS_HIGH : begin
        cycle_done = 1'b1;
        transfer_state_next = cycle_done ? IDLE : CS_HIGH;
        transfer_state_prev = CS_HIGH;
        csn = 1'b1;
        transfer_step = 0;
      end
      default : begin
        cycle_done = 0;
        transfer_state_next = IDLE;
        transfer_state_prev = IDLE;
        csn = 1'b1;
        transfer_step = 0;
      end
    endcase
  end

  // counter relies on a 132 Mhz clock or slower
  // counter is used to time all states
  // depends on number of clock cycles per phase

  always @(posedge clk_in) begin
    if (transfer_state == IDLE || reset_in == 1'b1) begin
      counter  <= 0;
      wa_cp    <= 1'b0;
      tf_cp[0] <= 1'b0;
      tf_cp[1] <= 1'b0;
      tf_cp[2] <= 1'b0;
      tf_cp[3] <= 1'b0;
      st_cp[0] <= 1'b0;
      st_cp[1] <= 1'b0;
      st_cp[2] <= 1'b0;
      st_cp[3] <= 1'b0;
    end else if (transfer_state == WRITE_ADDRESS | transfer_state == TRANSFER_REGISTER | transfer_state == STREAM) begin
      if (cycle_done) begin
        counter  <= 0;
        wa_cp    <= 1'b0;
        tf_cp[0] <= 1'b0;
        tf_cp[1] <= 1'b0;
        tf_cp[2] <= 1'b0;
        tf_cp[3] <= 1'b0;
        st_cp[0] <= 1'b0;
        st_cp[1] <= 1'b0;
        st_cp[2] <= 1'b0;
        st_cp[3] <= 1'b0;
      end else  begin
        counter  <= counter + 1;
        if (multi_io_mode == 2'h1) begin // Dual SPI
          wa_cp    <= full_speed ? (counter == 16'he) : (counter == 16'h3e);
          tf_cp[0] <= (counter == 16'h1f);
          tf_cp[1] <= (counter == 16'h3f);
          tf_cp[2] <= (counter == 16'h10);
          tf_cp[3] <= (counter == 16'h20);
          st_cp[0] <= (counter == 16'h1e);
          st_cp[1] <= (counter == 16'he);
          st_cp[2] <= (counter == 16'h1f);
          st_cp[3] <= (counter == 16'hf);
        end else if (multi_io_mode == 2'h2) begin // Quad SPI
          wa_cp    <= full_speed ? (counter == 16'h2) : (counter == 16'he);
          tf_cp[0] <= (counter == 16'he);
          tf_cp[1] <= (counter == 16'h1f);
          tf_cp[2] <= (counter == 16'h8);
          tf_cp[3] <= (counter == 16'h10);
          st_cp[0] <= (counter == 16'he);
          st_cp[1] <= (counter == 16'h6);
          st_cp[2] <= (counter == 16'hf);
          st_cp[3] <= (counter == 16'h7);
        end else begin // Any other case is classic SPI
          wa_cp    <= full_speed ? (counter == 16'he) : (counter == 16'h3e);
          tf_cp[0] <= (counter == 16'h3f);
          tf_cp[1] <= (counter == 16'h7f);
          tf_cp[2] <= (counter == 16'h1f);
          tf_cp[3] <= (counter == 16'h3f);
          st_cp[0] <= (counter == 16'h3e);
          st_cp[1] <= (counter == 16'h1e);
          st_cp[2] <= (counter == 16'h3f);
          st_cp[3] <= (counter == 16'h1f);
        end
      end
    end
  end

  always @(negedge clk_in) begin
    if (transfer_state == STREAM | transfer_state == TRANSFER_REGISTER | transfer_state == WRITE_ADDRESS) begin
      if (cycle_done) begin
        sclk_ddr <= 0;
      end else begin
        sclk_ddr <= !sclk_ddr;
      end
    end else begin
      sclk_ddr <= 0;
    end
  end

  // 66MHz for full speed
  // 16.5 MHz for normal speed
  // selection between 66 MHz and 16.5 MHz clocks for the SCLK
  // DDR mode requires a phase shift for the t7 and t8
  assign sclk = full_speed ? ((sdr_ddr_n | data_r_wn) ? counter[0] : sclk_ddr) : counter[2];

  always @(posedge clk_in) begin
    if (transfer_state == CS_LOW) begin
      data_r_wn <= address[7];
    end else if (transfer_state == CS_HIGH) begin
      data_r_wn <= 1'b0;
    end
    if (transfer_state == STREAM) begin
      if (cycle_done == 1'b1) begin
        dac_data_ready_s <= stream;
      end else begin
        dac_data_ready_s <= 1'b0;
      end
    end else begin
      dac_data_ready_s <= 1'b0;
    end
    if (transfer_state == CS_LOW) begin
      full_speed = stream;
      if(stream) begin
        transfer_reg_single <= {address,dac_data_int, {16{1'b0}}};
        transfer_reg_dual   <= {address,dac_data_int, {16{1'b0}}};
        transfer_reg_quad   <= {address,dac_data_int, {16{1'b0}}};
      end else begin
        transfer_reg_single <= {address,data_write, {24{1'b0}}};
        transfer_reg_dual   <= {address,data_write, {24{1'b0}}};
        transfer_reg_quad   <= {address,data_write, {24{1'b0}}};
      end
    end else if ((transfer_state == STREAM & cycle_done) || (transfer_state != STREAM  && transfer_state_next == STREAM)) begin
      transfer_reg_single <= {dac_data_int, {24{1'b0}}};
      transfer_reg_dual   <= {dac_data_int, {24{1'b0}}};
      transfer_reg_quad   <= {dac_data_int, {24{1'b0}}};
    end else if (transfer_step && transfer_state != CS_HIGH) begin
      if (multi_io_mode == 2'h2) begin // Quad SPI
        transfer_reg_quad <= {transfer_reg_quad[51:0], sdio_i};
      end else if ((multi_io_mode == 2'h0 || multi_io_mode == 2'h3)) begin
        transfer_reg_single <= {transfer_reg_single[54:0], sdio_i[1]};
      end else begin //Dual SPI
        if (transfer_state == WRITE_ADDRESS) begin
          transfer_reg_dual <= {transfer_reg_dual[54:0], sdio_i[0]};
        end else begin
          transfer_reg_dual <= {transfer_reg_dual[53:0], sdio_i[1:0]};
        end
      end
    end

    if (transfer_state == CS_HIGH) begin
      if (symb_8_16b == 1'b0) begin
        if (multi_io_mode == 2'h2) begin // Quad SPI
          data_read <= {8'h0, transfer_reg_quad[15:0]};
        end else if((multi_io_mode == 2'h0 || multi_io_mode == 2'h3)) begin
          data_read <= {8'h0, transfer_reg_single[15:0]};
        end else begin
          data_read <= {8'h0, transfer_reg_dual[15:0]};
        end
      end else begin
        if (multi_io_mode == 2'h2) begin //Quad SPI
          data_read <= {16'h0, transfer_reg_quad[7:0]};
        end else if((multi_io_mode == 2'h0 || multi_io_mode == 2'h3)) begin // Classic SPI
          data_read <= {16'h0, transfer_reg_single[7:0]};
        end else begin // dual SPI
          data_read <= {16'h0, transfer_reg_dual[7:0]};
        end
      end
    end else begin
      data_read <= data_read;
    end
    if (transfer_state == CS_HIGH || transfer_state == IDLE) begin
      if_busy_reg <= 1'b0;
    end else begin
      if_busy_reg <= 1'b1;
    end
  end

  // address[7] is r_wn : depends also on the state machine, input only when
  // in TRANSFER register mode

  assign sdio_t[0]   = (~(|multi_io_mode)) ? 1'b0 : (data_r_wn && transfer_state == TRANSFER_REGISTER); // for the Single SPI case
  assign sdio_t[3:1] = (~(|multi_io_mode)) ? 3'hf : {3{(data_r_wn && transfer_state == TRANSFER_REGISTER)}}; // high-impedance for the Single SPI case

  // multi_io_mode == 0xh3 is undefined, so the Classic SPI is chosen
  assign sdio_o = (multi_io_mode == 2'h2) ? transfer_reg_quad[55:52] :
                  ((multi_io_mode == 2'h0 || multi_io_mode == 2'h3) ? {3'h0, transfer_reg_single[55]} :
                                                                      ((transfer_state == WRITE_ADDRESS) ? {3'h0, transfer_reg_dual[55]} :
                                                                      {2'h0, transfer_reg_dual[55:54]}));

endmodule
