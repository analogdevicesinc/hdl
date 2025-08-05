// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************


`timescale 1ns / 100ps
`default_nettype none

module tb_link_layer_fec;

  localparam NUM_LANES=2;
  localparam NUM_LINKS=1;
  localparam SCR = 0;
  localparam DATA_PATH_WIDTH = 8;
  localparam DATA_WIDTH = DATA_PATH_WIDTH*8;

  localparam INPUT_DATA_WIDTH = 2048*9*2;
  localparam INPUT_DATA_CYCLES = INPUT_DATA_WIDTH/DATA_WIDTH;
  localparam logic [INPUT_DATA_WIDTH-1:0] DATA_VALUE = {2{{2048{1'b1}}, 1'b1, 2047'b0, {64{32'h12345678}}, {2048{1'b1}}, 2047'b0, 1'b1, {64{32'hABCDEF01}}, {64{32'h23456789}}, {2048{1'b1}}, 1'b1, 2047'b0}};
  localparam ERROR_CYCLE = (32*8)+4;    // Cycle of decoder data input to corrupt
  // localparam RECOVERABLE_ERROR_BITS = 64'h1FF000;
  localparam RECOVERABLE_ERROR_BITS = 64'h8000000000000000;
  localparam UNRECOVERABLE_ERROR_BITS = 64'h1FFFFF;
  localparam ERROR_BITS =  RECOVERABLE_ERROR_BITS; // Bits of decoder input data to corrupt
  localparam NEXT_ERROR_BITS = 64'h1;
  // localparam NEXT_ERROR_BITS = 64'h0000000000000000;
  localparam REPORT_GOOD_DATA = 1'b1;

  reg                             clk = 1'b0;
  reg                             sysref = 1'b0;
  logic                           rst;
  logic [INPUT_DATA_WIDTH-1:0]    DATA_VALUE_REVERSED;
  logic [INPUT_DATA_WIDTH-1:0]    data;
  logic [DATA_WIDTH-1:0]          data_in;
  logic [DATA_WIDTH-1:0]          data_in_swap;
  int                             data_in_cnt;
  int ii;
  int tx_cycle_cnt;
  int rx_cycle_cnt;
  genvar jj;

  logic [NUM_LANES-1:0] tx_cfg_lanes_disable;
  logic [NUM_LINKS-1:0] tx_cfg_links_disable;
  logic [9:0] tx_cfg_octets_per_multiframe;
  logic [7:0] tx_cfg_octets_per_frame;
  logic [9:0] tx_device_cfg_octets_per_multiframe;
  logic [7:0] tx_device_cfg_octets_per_frame;
  logic [7:0] tx_device_cfg_beats_per_multiframe;
  logic [7:0] tx_device_cfg_lmfc_offset;
  logic tx_device_cfg_sysref_oneshot;
  logic tx_device_cfg_sysref_disable;
  logic tx_cfg_continuous_cgs;
  logic tx_cfg_continuous_ilas;
  logic tx_cfg_skip_ilas;
  logic [7:0] tx_cfg_mframes_per_ilas;
  logic tx_cfg_disable_char_replacement;
  logic [1:0] tx_cfg_header_mode;
  logic tx_cfg_disable_scrambler;
  logic tx_lmfc_edge;
  logic tx_lmfc_clk;
  logic [DATA_PATH_WIDTH*8*NUM_LANES-1:0] tx_data;
  logic tx_ready;
  logic [DATA_PATH_WIDTH-1:0] tx_eof;
  logic [DATA_PATH_WIDTH-1:0] tx_sof;
  logic [DATA_PATH_WIDTH-1:0] tx_somf;
  logic [DATA_PATH_WIDTH-1:0] tx_eomf;
  logic tx_valid;

  logic [NUM_LANES-1:0] rx_cfg_lanes_disable;
  logic [NUM_LINKS-1:0] rx_cfg_links_disable;
  logic [9:0] rx_cfg_octets_per_multiframe;
  logic [7:0] rx_cfg_octets_per_frame;
  logic [9:0] rx_device_cfg_octets_per_multiframe;
  logic [7:0] rx_device_cfg_octets_per_frame;
  logic [7:0] rx_device_cfg_beats_per_multiframe;
  logic [7:0] rx_device_cfg_lmfc_offset;
  logic rx_device_cfg_sysref_oneshot;
  logic rx_device_cfg_sysref_disable;
  logic [7:0] rx_device_cfg_buffer_delay;
  logic rx_device_cfg_buffer_early_release;
  logic rx_cfg_disable_scrambler;
  logic rx_cfg_disable_char_replacement;
  logic [1:0] rx_cfg_header_mode;
  logic [7:0] rx_cfg_frame_align_err_threshold;


  logic [DATA_PATH_WIDTH*8*NUM_LANES-1:0] tx_phy_data;
  logic [2*NUM_LANES-1:0] tx_phy_header;
  logic [DATA_PATH_WIDTH*8*NUM_LANES-1:0] rx_phy_data;
  logic [2*NUM_LANES-1:0] rx_phy_header;
  logic [DATA_PATH_WIDTH*NUM_LANES-1:0] phy_charisk;
  logic [DATA_PATH_WIDTH*NUM_LANES-1:0] phy_notintable;
  logic [DATA_PATH_WIDTH*NUM_LANES-1:0] phy_disperr;
  logic [NUM_LANES-1:0] phy_block_sync;
  logic  rx_lmfc_edge;
  logic  rx_lmfc_clk;
  logic  phy_en_char_align;
  logic  [DATA_PATH_WIDTH*8*NUM_LANES-1:0] rx_data;
  logic  rx_valid;
  logic  [DATA_PATH_WIDTH-1:0] rx_eof;
  logic  [DATA_PATH_WIDTH-1:0] rx_sof;
  logic  [DATA_PATH_WIDTH-1:0] rx_eomf;
  logic  [DATA_PATH_WIDTH-1:0] rx_somf;
  logic  rx_ctrl_err_statistics_reset;
  logic [8:0] rx_ctrl_err_statistics_mask;
  logic [32*NUM_LANES-1:0] rx_status_err_statistics_cnt;

  logic tx_data_dropped;
  logic cur_error_cycle;
  logic [DATA_PATH_WIDTH*8*NUM_LANES-1:0] tx_data_q[$];
  logic [DATA_PATH_WIDTH*8*NUM_LANES-1:0] cur_tx_data;

  always #5ns clk = ~clk;

  always #(5ns*32*8) sysref = ~sysref;

  initial begin
    rst = 1'b1;
    #100ns;
    rst = 1'b0;
  end

  assign tx_valid = 1'b1;
  // assign tx_data = {DATA_PATH_WIDTH*8*NUM_LANES{1'b1}};

  initial begin
    // Shift data in MSb-first by reversing the data
    for(ii = 0; ii < INPUT_DATA_WIDTH; ii = ii + 1) begin
      DATA_VALUE_REVERSED[ii] = DATA_VALUE[INPUT_DATA_WIDTH-1-ii];
    end
    rst = 1'b1;
    #100ns;
    rst = 1'b0;
  end

  initial begin
    data = DATA_VALUE_REVERSED;
    data_in_cnt = '0;
    data_in = '0;
    forever begin
      data_in = data[0+:DATA_WIDTH];
      @(posedge clk);
      #0;
      if(tx_ready && (data_in_cnt < INPUT_DATA_CYCLES)) begin
        data = data >> DATA_WIDTH;
        data_in_cnt = data_in_cnt + 1;
      end
    end
  end

  // // TX data is dropped until the first EoMB is seen
  // initial begin
  //   tx_data_dropped = 1'b1;
  //   forever begin
  //     @(negedge clk);
  //     if(tx_ready & tx_eomf[DATA_PATH_WIDTH-1]) begin
  //       tx_data_dropped = 1'b0;
  //     end
  //   end
  // end

  // The first 7 multiblocks of data are dropped, one by TX, 6 by RX
  // TODO: is this dependent on TX data pattern when scrambling is disabled?
  initial begin
    tx_data_dropped = 1'b1;
    forever begin
      @(negedge clk);
      if(tx_ready && (data_in_cnt >= (32 * 7))) begin
        tx_data_dropped = 1'b0;
      end
    end
  end

  // always_ff @(posedge clk) begin
  //   if(rst) begin
  //     data <= DATA_VALUE_REVERSED;
  //     data_in_cnt <= '0;
  //     data_in <= '0;
  //   end else begin
  //     if(tx_ready) begin
  //       if(data_in_cnt < INPUT_DATA_WIDTH) begin
  //         data_in <= data[0+:DATA_WIDTH];
  //         data <= data >> DATA_WIDTH;
  //         data_in_cnt <= data_in_cnt + DATA_WIDTH;
  //       end
  //     end
  //   end
  // end

  always_ff @(posedge clk) begin
    if(rst) begin
      tx_cycle_cnt <= '0;
    end else begin
      if(tx_ready) begin
        tx_cycle_cnt <= tx_cycle_cnt + 1;
      end
    end
  end

  // Swap order of octets
  for(jj = 0; jj < DATA_PATH_WIDTH; jj=jj+1) begin : tx_data_gen
    assign data_in_swap[jj*8+:8] = data_in[(DATA_PATH_WIDTH-jj-1)*8+:8];
  end

  assign tx_data = {NUM_LANES{data_in_swap}};

  assign rx_phy_data = (tx_cycle_cnt == ERROR_CYCLE) ? (tx_phy_data ^ ERROR_BITS) : (tx_cycle_cnt == ERROR_CYCLE+1) ? (tx_phy_data ^ NEXT_ERROR_BITS) : tx_phy_data;
  // assign rx_phy_data = tx_phy_data;
  assign rx_phy_header = tx_phy_header;

  assign rx_ctrl_err_statistics_mask = 8'h3F;  // FEC trapped and non-trapped error
  assign rx_ctrl_err_statistics_reset = 1'b0;

  assign cur_error_cycle = tx_cycle_cnt == ERROR_CYCLE;

  initial begin
    tx_data_q = {};
    forever begin
      @(negedge clk);
      if(tx_ready && !tx_data_dropped && (data_in_cnt < INPUT_DATA_CYCLES)) begin
        tx_data_q.push_back(tx_data);
        // $display("%t TX Cycle %d: %X", $time, tx_cycle_cnt, tx_data);
      end
    end
  end

  initial begin
    rx_cycle_cnt = 0;
    forever begin
      @(negedge clk);
      if(rx_valid) begin
        if(tx_data_q.size() == 0) begin
          $finish;
        end
        cur_tx_data = tx_data_q.pop_front();
        if(cur_tx_data !== rx_data) begin
          $error("RX Cycle: %d Data mismatch. Expected: %X  Observed: %X", rx_cycle_cnt, cur_tx_data, rx_data);
        end else if(REPORT_GOOD_DATA) begin
          $display("RX Cycle: %d Good data:%X", rx_cycle_cnt, cur_tx_data);
        end
        rx_cycle_cnt = rx_cycle_cnt + 1;
      end
    end
  end

  jesd204_tx_static_config #(
    .NUM_LANES      (NUM_LANES),
    .OCTETS_PER_FRAME(8),
    .FRAMES_PER_MULTIFRAME(32),
    .SCR            (SCR),
    .LINK_MODE      (2),
    .HEADER_MODE    (2)
  ) jesd204_tx_static_config (
    .clk                               (clk),
    .cfg_lanes_disable                 (tx_cfg_lanes_disable),
    .cfg_links_disable                 (tx_cfg_links_disable),
    .cfg_octets_per_multiframe         (tx_cfg_octets_per_multiframe),
    .cfg_octets_per_frame              (tx_cfg_octets_per_frame),
    .device_cfg_octets_per_multiframe  (tx_device_cfg_octets_per_multiframe),
    .device_cfg_octets_per_frame       (tx_device_cfg_octets_per_frame),
    .device_cfg_beats_per_multiframe   (tx_device_cfg_beats_per_multiframe),
    .device_cfg_lmfc_offset            (tx_device_cfg_lmfc_offset),
    .device_cfg_sysref_oneshot         (tx_device_cfg_sysref_oneshot),
    .device_cfg_sysref_disable         (tx_device_cfg_sysref_disable),
    .cfg_continuous_cgs                (tx_cfg_continuous_cgs),
    .cfg_continuous_ilas               (tx_cfg_continuous_ilas),
    .cfg_skip_ilas                     (tx_cfg_skip_ilas),
    .cfg_mframes_per_ilas              (tx_cfg_mframes_per_ilas),
    .cfg_disable_char_replacement      (tx_cfg_disable_char_replacement),
    .cfg_header_mode                   (tx_cfg_header_mode),
    .cfg_disable_scrambler             (tx_cfg_disable_scrambler),
    .ilas_config_rd(),
    .ilas_config_addr(),
    .ilas_config_data()
  );

  jesd204_tx #(
    .NUM_LANES                            (NUM_LANES),
    .NUM_LINKS                            (NUM_LINKS),
    .NUM_INPUT_PIPELINE                   (1),
    .NUM_OUTPUT_PIPELINE                  (0),
    .LINK_MODE                            (2),
    .ENABLE_FEC                           (1),
    .DATA_PATH_WIDTH                      (DATA_PATH_WIDTH)
  ) jesd204_tx (
    .clk                                  (clk),
    .reset                                (rst),
    .device_clk                           (clk),
    .device_reset                         (rst),
    .phy_data                             (tx_phy_data),
    .phy_charisk                          (phy_charisk),
    .phy_header                           (tx_phy_header),
    .sysref                               (sysref),
    .lmfc_edge                            (tx_lmfc_edge),
    .lmfc_clk                             (tx_lmfc_clk),
    .sync                                 ('0),
    .tx_data                              (tx_data),
    .tx_ready                             (tx_ready),
    .tx_eof                               (tx_eof),
    .tx_sof                               (tx_sof),
    .tx_eomf                              (tx_eomf),
    .tx_somf                              (tx_somf),
    .tx_valid                             (tx_valid),
    .cfg_lanes_disable                    (tx_cfg_lanes_disable),
    .cfg_links_disable                    (tx_cfg_links_disable),
    .cfg_octets_per_multiframe            (tx_cfg_octets_per_multiframe),
    .cfg_octets_per_frame                 (tx_cfg_octets_per_frame),
    .device_cfg_octets_per_multiframe     (tx_device_cfg_octets_per_multiframe),
    .device_cfg_octets_per_frame          (tx_device_cfg_octets_per_frame),
    .device_cfg_beats_per_multiframe      (tx_device_cfg_beats_per_multiframe),
    .device_cfg_lmfc_offset               (tx_device_cfg_lmfc_offset),
    .device_cfg_sysref_oneshot            (tx_device_cfg_sysref_oneshot),
    .device_cfg_sysref_disable            (tx_device_cfg_sysref_disable),
    .cfg_continuous_cgs                   (tx_cfg_continuous_cgs),
    .cfg_continuous_ilas                  (tx_cfg_continuous_ilas),
    .cfg_skip_ilas                        (tx_cfg_skip_ilas),
    .cfg_mframes_per_ilas                 (tx_cfg_mframes_per_ilas),
    .cfg_disable_char_replacement         (tx_cfg_disable_char_replacement),
    .cfg_header_mode                      (tx_cfg_header_mode),
    .cfg_disable_scrambler                (tx_cfg_disable_scrambler),
    .ilas_config_rd                       (),
    .ilas_config_addr                     (),
    .ilas_config_data                     ('0),
    .ctrl_manual_sync_request             (),
    .device_event_sysref_edge             (),
    .device_event_sysref_alignment_error  (),
    .status_sync                          (),
    .status_state                         ()
  );



  jesd204_rx_static_config #(
    .NUM_LANES                         (NUM_LANES),
    .OCTETS_PER_FRAME                  (8),
    .FRAMES_PER_MULTIFRAME             (32),
    .SCR                               (SCR),
    .LINK_MODE                         (2),
    .HEADER_MODE                       (2),
    .SYSREF_DISABLE                    (0)
  ) jesd204_rx_static_config(
    .clk                                  (clk),
    .cfg_lanes_disable                    (rx_cfg_lanes_disable),
    .cfg_links_disable                    (rx_cfg_links_disable),
    .cfg_disable_scrambler                (rx_cfg_disable_scrambler),
    .cfg_disable_char_replacement         (rx_cfg_disable_char_replacement),
    .cfg_header_mode                      (rx_cfg_header_mode),
    .cfg_frame_align_err_threshold        (rx_cfg_frame_align_err_threshold),
    .cfg_octets_per_multiframe            (rx_cfg_octets_per_multiframe),
    .cfg_octets_per_frame                 (rx_cfg_octets_per_frame),
    .device_cfg_octets_per_multiframe     (rx_device_cfg_octets_per_multiframe),
    .device_cfg_octets_per_frame          (rx_device_cfg_octets_per_frame),
    .device_cfg_beats_per_multiframe      (rx_device_cfg_beats_per_multiframe),
    .device_cfg_lmfc_offset               (rx_device_cfg_lmfc_offset),
    .device_cfg_sysref_oneshot            (rx_device_cfg_sysref_oneshot),
    .device_cfg_sysref_disable            (rx_device_cfg_sysref_disable),
    .device_cfg_buffer_delay              (rx_device_cfg_buffer_delay),
    .device_cfg_buffer_early_release      (rx_device_cfg_buffer_early_release)
  );


  jesd204_rx #(
    .NUM_LANES                            (NUM_LANES),
    .LINK_MODE                            (2),
    .ENABLE_FEC                           (1)
  ) jesd204_rx (
    .clk                                  (clk),
    .reset                                (rst),
    .device_clk                           (clk),
    .device_reset                         (rst),
    .phy_data                             (rx_phy_data),
    .phy_header                           (rx_phy_header),
    .phy_charisk                          ('0),
    .phy_notintable                       ('0),
    .phy_disperr                          ('0),
    .phy_block_sync                       ('1),
    .sysref                               (sysref),
    .lmfc_edge                            (rx_lmfc_edge),
    .lmfc_clk                             (rx_lmfc_clk),
    .device_event_sysref_alignment_error  (),
    .device_event_sysref_edge             (),
    .event_frame_alignment_error          (),
    .event_unexpected_lane_state_error    (),
    .sync                                 (),
    .phy_en_char_align                    (),
    .rx_data                              (rx_data),
    .rx_valid                             (rx_valid),
    .rx_eof                               (rx_eof),
    .rx_sof                               (rx_sof),
    .rx_eomf                              (rx_eomf),
    .rx_somf                              (rx_somf),
    .cfg_lanes_disable                    (rx_cfg_lanes_disable),
    .cfg_links_disable                    (rx_cfg_links_disable),
    .cfg_octets_per_multiframe            (rx_cfg_octets_per_multiframe),
    .cfg_octets_per_frame                 (rx_cfg_octets_per_frame),
    .device_cfg_octets_per_multiframe     (rx_device_cfg_octets_per_multiframe),
    .device_cfg_octets_per_frame          (rx_device_cfg_octets_per_frame),
    .device_cfg_beats_per_multiframe      (rx_device_cfg_beats_per_multiframe),
    .cfg_disable_scrambler                (rx_cfg_disable_scrambler),
    .cfg_disable_char_replacement         (rx_cfg_disable_char_replacement),
    .cfg_header_mode                      (rx_cfg_header_mode),
    .cfg_frame_align_err_threshold        (rx_cfg_frame_align_err_threshold),
    .device_cfg_lmfc_offset               (rx_device_cfg_lmfc_offset),
    .device_cfg_sysref_disable            (rx_device_cfg_sysref_disable),
    .device_cfg_sysref_oneshot            (rx_device_cfg_sysref_oneshot),
    .device_cfg_buffer_early_release      (rx_device_cfg_buffer_early_release),
    .device_cfg_buffer_delay              (rx_device_cfg_buffer_delay),
    .ctrl_err_statistics_reset            (rx_ctrl_err_statistics_reset),
    .ctrl_err_statistics_mask             (rx_ctrl_err_statistics_mask),
    .status_err_statistics_cnt            (rx_status_err_statistics_cnt),
    .ilas_config_valid                    (),
    .ilas_config_addr                     (),
    .ilas_config_data                     (),
    .status_ctrl_state                    (),
    .status_lane_cgs_state                (),
    .status_lane_ifs_ready                (),
    .status_lane_latency                  (),
    .status_lane_emb_state                (),
    .status_lane_frame_align_err_cnt      ()
  );


endmodule

`default_nettype wire
