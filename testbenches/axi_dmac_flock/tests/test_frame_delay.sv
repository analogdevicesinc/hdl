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
`include "environment.sv"

import axi_vip_pkg::*;
import axi4stream_vip_pkg::*;
import logger_pkg::*;

import `PKGIFY(test_harness, master_dma)::*;
import `PKGIFY(test_harness, slave_dma)::*;
import `PKGIFY(test_harness, src_axis_vip)::*;

program test_frame_delay;
  //declaring environment instance
  environment env;
  int frame_count;
  int max_frames = `GETPARAM(test_harness,master_dma,MAX_NUM_FRAMES);
  int has_sfsync = `GETPARAM(test_harness,master_dma,USE_EXT_SYNC);
  int has_dfsync = `GETPARAM(test_harness,slave_dma,USE_EXT_SYNC);
  int has_sautorun = `GETPARAM(test_harness,slave_dma,HAS_AUTORUN);
  int has_dautorun = `GETPARAM(test_harness,master_dma,HAS_AUTORUN);
  int sync_gen_en;

  initial begin
    //creating environment
    env = new(test_harness.mng_axi_vip.inst.IF,
              test_harness.ddr_axi_vip.inst.IF,
              `ifdef HAS_VDMA
              test_harness.ref_src_axis_vip.inst.IF,
              test_harness.ref_dst_axis_vip.inst.IF,
              `endif
              test_harness.src_axis_vip.inst.IF,
              test_harness.dst_axis_vip.inst.IF
    );

    #2ps;

    setLoggerVerbosity(6);
    start_clocks();
    sys_reset();

    env.start();

    if (has_sautorun + has_dautorun == 0) begin
      simpleRegTest;
    end

    `INFO(("start env"));
    env.run();

    // Test non-autorun mode
    if (has_sautorun + has_dautorun == 0) begin
      singleTest(
        .frame_num(10),
        .num_of_buffers(3),
        .frame_distance(1),
        .wr_clk(250000000),
        .rd_clk(250000000)
      );

      singleTest(
        .frame_num(10),
        .num_of_buffers(5),
        .frame_distance(3),
        .wr_clk(250000000),
        .rd_clk(250000000)
      );

      singleTest(
        .frame_num(10),
        .num_of_buffers(8),
        .frame_distance(7),
        .wr_clk(250000000),
        .rd_clk(250000000)
      );
    end

    // Test autorun mode
    if (has_sautorun + has_dautorun == 2) begin
      int autorun_num_of_buffers;
      int autorun_frame_distance;

      autorun_num_of_buffers =  `GETPARAM(test_harness,slave_dma,DMAC_DEF_FLOCK_CFG) & 'hFF;
      autorun_frame_distance = ((`GETPARAM(test_harness,slave_dma,DMAC_DEF_FLOCK_CFG) >> 16) & 'hFF)+1;
      singleTest(
        .frame_num(10),
        .num_of_buffers(autorun_num_of_buffers),
        .frame_distance(autorun_frame_distance),
        .wr_clk(250000000),
        .rd_clk(250000000),
        .has_autorun(1)
      );
    end
    if (has_sautorun + has_dautorun == 1) begin
      `ERROR(("Both DMACs must be set in autorun mode."));
    end

    stop_clocks();

    $display("Testbench done !!!");
    $finish();

  end

  task singleTest(
    int frame_num = 10,
    int num_of_buffers = 3,
    int frame_distance = 1,
    int wr_clk = 250000000,
    int rd_clk = 250000000,
    int has_autorun = 0
  );
    dma_flocked_2d_segment m_seg, s_seg;
    int m_tid, s_tid;
    int rand_succ = 0;
    int x_length,y_length,baseaddress;


    axi4stream_ready_gen tready_gen;
    axi_ready_gen  wready_gen;

    // Set no backpressure from AXIS destination
    tready_gen = env.dst_axis_seq.agent.driver.create_ready("tready");
    tready_gen.set_ready_policy(XIL_AXI4STREAM_READY_GEN_NO_BACKPRESSURE);
    env.dst_axis_seq.agent.driver.send_tready(tready_gen);
    `ifdef HAS_VDMA
    env.ref_dst_axis_seq.agent.driver.send_tready(tready_gen);
    `endif

    // Set no backpressure from DDR
    wready_gen = env.ddr_axi_agent.wr_driver.create_ready("wready");
    wready_gen.set_ready_policy(XIL_AXI_READY_GEN_NO_BACKPRESSURE);
    env.ddr_axi_agent.wr_driver.send_wready(wready_gen);

    // Configure external sync to drive mode.
    test_harness.`SRC_SYNC_IO.inst.set_driver_mode();
    test_harness.`DST_SYNC_IO.inst.set_driver_mode();

    m_seg = new;
    m_seg.set_params({`DMAC_PARAMS(test_harness, master_dma)});

    baseaddress = 0;
    x_length = 1024;
    y_length = 8;
    if (has_autorun) begin
      baseaddress = `GETPARAM(test_harness,master_dma,DMAC_DEF_DEST_ADDR);
      x_length = `GETPARAM(test_harness,master_dma,DMAC_DEF_X_LENGTH) + 1;
      y_length = `GETPARAM(test_harness,master_dma,DMAC_DEF_Y_LENGTH) + 1;
    end

    rand_succ = m_seg.randomize() with { dst_addr == baseaddress;
                                         length == x_length;
                                         ylength == y_length;
                                         dst_stride == length; };
    if (rand_succ == 0) `ERROR(("randomization failed"));

    m_seg.num_of_buffers = num_of_buffers;
    m_seg.frame_distance = frame_distance;
    m_seg.flock_mode = 1;
    m_seg.flock_wait_master = 1;

    s_seg = m_seg.toSlaveSeg();
    s_seg.set_params({`DMAC_PARAMS(test_harness, slave_dma)});

    env.src_axis_seq.configure(.mode(0),.rand_valid(0));
    env.src_axis_seq.enable();
    `ifdef HAS_VDMA
    env.ref_src_axis_seq.configure(.mode(0),.rand_valid(0));
    env.ref_src_axis_seq.enable();
    `endif

    if (has_autorun == 0) begin
      env.m_dmac_api.enable_dma();
      env.s_dmac_api.enable_dma();
    end

    `ifdef HAS_VDMA
    // Config S2MM
    //This enables run/stop, Circular_Park, GenlockEn, and GenlockSrc.
    env.mng.RegWrite32(`G_VDMA_BA + 'h30, 'h8b);
    //Set S2MM_Start_Address1 .. S2MM_Start_Address8
    for (int i=0;i<8;i++) begin
      env.mng.RegWrite32(`G_VDMA_BA + 'hAC+i*4, 'h80000000+i*'h01000000);
    end
    //Set S2MM_FRMDLY_STRIDE
    env.mng.RegWrite32(`G_VDMA_BA + 'hA8, m_seg.length | (frame_distance << 24));
    //Set S2MM_HSIZE
    env.mng.RegWrite32(`G_VDMA_BA + 'hA4, m_seg.length);
    //Set S2MM_VSIZE
    env.mng.RegWrite32(`G_VDMA_BA + 'hA0, m_seg.ylength);

    // Config MM2S
    //This enables run/stop, Circular_Park, GenlockEn, and GenlockSrc
    env.mng.RegWrite32(`G_VDMA_BA + 'h00, 'h8b);
    //Set MM2S_Start_Address1 .. MM2S_Start_Address8
    for (int i=0;i<8;i++) begin
      env.mng.RegWrite32(`G_VDMA_BA + 'h5C+i*4, 'h80000000+i*'h01000000);
    end
    //Set MM2S_FRMDLY_STRIDE
    env.mng.RegWrite32(`G_VDMA_BA + 'h58, m_seg.length | (frame_distance << 24));
    //Set MM2S_HSIZE
    env.mng.RegWrite32(`G_VDMA_BA + 'h54, m_seg.length);
    //Set MM2S_VSIZE
    env.mng.RegWrite32(`G_VDMA_BA + 'h50, m_seg.ylength);
    `endif

    // Submit transfers to DMACs
    if (has_autorun == 0) begin
      env.m_dmac_api.submit_transfer(m_seg, m_tid);
      env.s_dmac_api.submit_transfer(s_seg, s_tid);
    end

    // Set clock generators
    set_writer_clock(wr_clk);
    set_reader_clock(rd_clk);

    sync_gen_en = 1;
    fork
      // Generate external sync and data for SRC
      begin
        #0.5us;
        for (int i=0; i<frame_num; i++) begin
          if (sync_gen_en) begin
            fork
              gen_src_fsync(.clk_period(wr_clk),
                            .bytes_to_transfer(m_seg.get_bytes_in_transfer));
              // Generate data
              begin
                for (int l=0; l<m_seg.ylength; l++) begin
                  // update the AXIS generator command
                  env.src_axis_seq.update(.bytes_to_generate(m_seg.length),
                                          .gen_last(1),
                                          .gen_sync(l==0));
                  `ifdef HAS_VDMA
                  env.ref_src_axis_seq.update(.bytes_to_generate(m_seg.length),
                                              .gen_last(1),
                                              .gen_sync(l==0));
                  `endif
                end

                // update the AXIS generator data
                for (int j=0; j<m_seg.get_bytes_in_transfer; j++) begin
                  // ADI DMA frames start from offset 0x00
                  env.src_axis_seq.byte_stream.push_back(frame_count);
                  `ifdef HAS_VDMA
                  // VDMA frames start from offset 0x80
                  env.ref_src_axis_seq.byte_stream.push_back(frame_count+'h80);
                  `endif
                end
              end
            join
            frame_count++;
          end
        end
      end

      // Generate external syncs for DEST
      begin
     //   #2us;
        for (int i=0; i<frame_num; i++) begin
          if (sync_gen_en) begin
            gen_dst_fsync(.clk_period(rd_clk),
                          .bytes_to_transfer(m_seg.get_bytes_in_transfer));
          end
        end
        #10;
      end
    join
    sync_gen_en = 0;

    // Wait until everything is transmitted
    do
      #100;
    while (env.src_axis_seq.byte_stream.size() > 0
           `ifdef HAS_VDMA
            && env.ref_src_axis_seq.byte_stream.size() > 0
           `endif
           );

    // Shutdown DMACs
    env.m_dmac_api.disable_dma();
    env.s_dmac_api.disable_dma();
    env.src_axis_seq.stop();
    `ifdef HAS_VDMA
    env.ref_src_axis_seq.stop();
    `endif

  endtask



  // This is a simple reg test to check the register access API
  task simpleRegTest;
    xil_axi_ulong mtestWADDR; // Write ADDR

    bit [63:0]    mtestWData; // Write Data
    bit [31:0]    rdData;

    env.mng.RegReadVerify32(`M_DMAC_BA + GetAddrs(dmac_IDENTIFICATION), 'h44_4D_41_43);

    mtestWData = 0;
    repeat (10) begin
      env.mng.RegWrite32(`M_DMAC_BA + GetAddrs(dmac_SCRATCH), mtestWData);
      env.mng.RegReadVerify32(`M_DMAC_BA + GetAddrs(dmac_SCRATCH), mtestWData);
      mtestWData += 4;
    end

    env.mng.RegReadVerify32(`S_DMAC_BA + GetAddrs(dmac_IDENTIFICATION), 'h44_4D_41_43);

  endtask

  // Set the writer AXIS side clock frequency
  task set_writer_clock(int freq);
    test_harness.clk_rst_gen.`SRC_CLK.inst.IF.set_clk_frq(.user_frequency(freq));
  endtask

  // Set the reader AXIS side clock frequency
  task set_reader_clock(int freq);
    test_harness.clk_rst_gen.`DST_CLK.inst.IF.set_clk_frq(.user_frequency(freq));
  endtask

  // Set the MM AXI side DDR clock frequency
  task set_ddr_clock(int freq);
    test_harness.clk_rst_gen.`DDR_CLK.inst.IF.set_clk_frq(.user_frequency(freq));
  endtask

  // Start all clocks
  task start_clocks;
     set_writer_clock(100000000);
     set_reader_clock(100000000);
     set_ddr_clock(500000000);

    test_harness.clk_rst_gen.`SRC_CLK.inst.IF.start_clock;
    test_harness.clk_rst_gen.`DST_CLK.inst.IF.start_clock;
    test_harness.clk_rst_gen.`MNG_CLK.inst.IF.start_clock;
    test_harness.clk_rst_gen.`DDR_CLK.inst.IF.start_clock;
    #100;
  endtask

  // Stop all clocks
  task stop_clocks;
    test_harness.clk_rst_gen.`SRC_CLK.inst.IF.stop_clock;
    test_harness.clk_rst_gen.`DST_CLK.inst.IF.stop_clock;
    test_harness.clk_rst_gen.`MNG_CLK.inst.IF.stop_clock;
    test_harness.clk_rst_gen.`DDR_CLK.inst.IF.stop_clock;
  endtask

  // Asserts all the resets for 100 ns
  task sys_reset;
    test_harness.clk_rst_gen.`RST.inst.IF.assert_reset;
    #100
    test_harness.clk_rst_gen.`RST.inst.IF.deassert_reset;
  endtask

  // Assert external sync for one clock cycle
  task assert_writer_ext_sync;
    test_harness.`SRC_SYNC_IO.inst.IF.setw_io(1);
    test_harness.`SRC_SYNC_IO.inst.IF.setw_io(0);
  endtask

  // Assert external sync for one clock cycle
  task assert_reader_ext_sync;
    test_harness.`DST_SYNC_IO.inst.IF.setw_io(1);
    test_harness.`DST_SYNC_IO.inst.IF.setw_io(0);
  endtask

  // Generate external sync pulse for input frames
  task gen_src_fsync(int clk_period, int bytes_to_transfer);
    real incycles,fperiod;
    if (has_sfsync) begin
      assert_writer_ext_sync();
    end
    // Calculate and wait one input frame duration plus a margin
    incycles = bytes_to_transfer / (`GETPARAM(test_harness,src_axis_vip,VIP_DATA_WIDTH)/8) * 1.8;
    fperiod = (incycles*1000000000)/ clk_period;
    #fperiod;
  endtask

  // Generate external sync pulse for output frames
  task gen_dst_fsync(int clk_period, int bytes_to_transfer);
    real incycles,fperiod;
    if (has_dfsync) begin
      assert_reader_ext_sync();
    end
    // Calculate and wait one output frame duration plus a margin
    incycles = bytes_to_transfer / (`GETPARAM(test_harness,dst_axis_vip,VIP_DATA_WIDTH)/8) * 1.8;
    fperiod = (incycles*1000000000)/ clk_period;
    #fperiod;
  endtask

endprogram
