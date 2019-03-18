// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2018 (c) Analog Devices, Inc. All rights reserved.
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

`include "utils.svh"

`ifndef __M_AXIS_SEQUENCER_SV__
`define __M_AXIS_SEQUENCER_SV__

import axi4stream_vip_pkg::*;

class m_axis_sequencer #( type T, `AXIS_VIP_PARAM_DECL);

  bit enabled = 1'b0;
  event en_ev;

  bit mode = 1'b1;  // 0 - get data from test;
                    // 1 - autogenerate data until aborted
  bit rand_valid = 1'b1;  // 0 - get valid instantaneously
                          // 1 - gen valid after a random delay
  int byte_count = 0;


  event data_av_ev;
  event beat_done;
  axi4stream_transaction trans;

  T agent;

  xil_axi4stream_data_byte byte_stream [$];
  typedef struct{
    int num_bytes;
    bit gen_last;
    bit gen_sync;
    } byte_count_t;

  byte_count_t byte_count_q [$];

  function new(T agent);
    this.agent = agent;
  endfunction

  function void configure(int mode, int rand_valid = 1);
    if (enabled)
      `ERROR(("sequencer must be disabled before configuration"));
    this.mode = mode;
    this.rand_valid = rand_valid;
    `INFOV(("configure start"), 55);
  endfunction


  function void update(int bytes_to_generate,
                       int gen_last = 1,
                       int gen_sync = 1);
    byte_count_t descriptor;
    descriptor.num_bytes = bytes_to_generate;
    descriptor.gen_last = gen_last;
    descriptor.gen_sync = gen_sync;
    `INFOV(("Updating generator with %0d bytes with last %0d, sync %0d",
             bytes_to_generate, gen_last, gen_sync), 5);

    byte_count_q.push_back(descriptor);
  endfunction

  task generator();
    `INFOV(("generator start"), 55);
    while (1) begin
      if (enabled == 0) begin
        `INFOV(("Waiting for enable"), 55);
        @en_ev;
        `INFOV(("Enable found"), 55);
      end else begin
        // start to packetize a little later than starting the sender
        #10;
        if (byte_count_q.size() > 0)
          packetize();
      end
    end
  endtask

  // pack the byte stream into transfers(beats) then in packets by setting the tlast
  task packetize();
    xil_axi4stream_data_byte data[];
    int packet_length;
    int byte_per_beat;
    byte_count_t descriptor;

    `INFOV(("packetize start"), 55);
    byte_per_beat = AXIS_VIP_DATA_WIDTH/8;
    data = new[byte_per_beat];
    descriptor = byte_count_q.pop_front();

    packet_length = descriptor.num_bytes / byte_per_beat;

    for (int tc=0; tc<packet_length; tc++) begin : packet_loop

      for (int i=0; i<byte_per_beat; i++) begin
        case (mode)
          0:
            // block transfer until we get data from byte stream queue
            while (1) begin
              if (byte_stream.size() > 0) begin
                data[i] = byte_stream.pop_front();
                break;
              end else
                `INFOV(("Waiting for data"), 55);
                #1;
              if (enabled == 0)
                disable packet_loop;
            end
          1:
            data[i] = byte_count++;
          default:
            data[i] = $random;
        endcase
      end

      `INFOV(("generating axis transaction"), 55);
      trans = agent.driver.create_transaction();
      trans.set_data(data);
      if (rand_valid == 1) begin
        // set transaction delay to be in most of the cases zero 
        // but occasionally insert small or a larger delay
        case ($urandom_range(0,10))
          0       : trans.set_delay(1);
          1       : trans.set_delay(8);
          default : trans.set_delay(0);
        endcase
      end else begin
        trans.set_delay(0);
      end

      if (AXIS_VIP_HAS_TLAST)
        trans.set_last((tc == packet_length-1) & descriptor.gen_last);

      if (AXIS_VIP_USER_WIDTH > 0)
        trans.set_user_beat((tc == 0) & descriptor.gen_sync);

      -> data_av_ev;
      `INFOV(("waiting transfer to complete"), 55);
      @(beat_done);
      if (enabled == 0) begin
        `INFOV(("block disabled, leaving packetize"), 55);
        break;
      end
    end

  endtask

  task enable();
    `INFOV(("enable sequencer"), 55);
    enabled = 1;
    #1;
    -> en_ev;
  endtask

  task stop();
    `INFOV(("disable sequencer"), 55);
    enabled = 0;
    byte_count = 0;
    #1;
  endtask


  task sender();
    `INFOV(("sender start"), 55);
    while (1) begin
      if (enabled == 0)
        @en_ev;
      else begin
        `INFOV(("waiting for data to be available"), 55);
        @data_av_ev;
        `INFOV(("sending axis transaction"), 55);
        agent.driver.send(trans);
        #1;
        -> beat_done;
      end
    end
  endtask

  task run();
    fork
      generator();
      sender();
    join_none
  endtask

endclass

`endif
