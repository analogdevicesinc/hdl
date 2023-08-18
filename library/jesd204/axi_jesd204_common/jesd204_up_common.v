// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2016-2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module jesd204_up_common #(
  parameter PCORE_VERSION = 0,
  parameter PCORE_MAGIC = 0,
  parameter ID = 0,
  parameter NUM_LANES = 1,
  parameter NUM_LINKS = 1,
  parameter DATA_PATH_WIDTH_LOG2 = 2,
  parameter NUM_IRQS = 1,
  parameter EXTRA_CFG_WIDTH = 1,
  parameter DEV_EXTRA_CFG_WIDTH = 1,
  parameter ENABLE_LINK_STATS = 0
) (
  input up_clk,
  input ext_resetn,

  output up_reset,

  output up_reset_synchronizer,

  input core_clk,
  input core_reset_ext,
  output core_reset,

  input device_clk,
  output device_reset,

  input [11:0] up_raddr,
  output reg [31:0] up_rdata,

  input up_wreq,
  input [11:0] up_waddr,
  input [31:0] up_wdata,

  input [EXTRA_CFG_WIDTH-1:0] up_extra_cfg,
  input [DEV_EXTRA_CFG_WIDTH-1:0] up_dev_extra_cfg,

  input [NUM_IRQS-1:0] up_irq_trigger,
  output reg irq,

  output up_cfg_is_writeable,

  output reg [NUM_LANES-1:0] core_cfg_lanes_disable = {NUM_LANES{1'b0}},
  output reg [NUM_LINKS-1:0] core_cfg_links_disable = {NUM_LINKS{1'b0}},
  output reg [9:0] core_cfg_octets_per_multiframe = 'h00,
  output reg [7:0] core_cfg_octets_per_frame = 'h00,
  output reg core_cfg_disable_scrambler = 'h00,
  output reg core_cfg_disable_char_replacement = 'h00,
  output reg [EXTRA_CFG_WIDTH-1:0] core_extra_cfg = 'h00,

  output reg [DEV_EXTRA_CFG_WIDTH-1:0] device_extra_cfg = 'h00,

  output reg [9:0] device_cfg_octets_per_multiframe = 'h00,
  output reg [7:0] device_cfg_octets_per_frame = 'h00,
  output reg [7:0] device_cfg_beats_per_multiframe = 'h00,

  input [31:0] status_synth_params0,
  input [31:0] status_synth_params1,
  input [31:0] status_synth_params2
);

  reg [31:0] up_scratch = 32'h00000000;

  reg [7:0] up_cfg_octets_per_frame = 'h00;
  reg [9:0] up_cfg_octets_per_multiframe = {DATA_PATH_WIDTH_LOG2{1'b1}};
  reg [7:0] up_cfg_beats_per_multiframe = 'h00;
  reg [NUM_LANES-1:0] up_cfg_lanes_disable = {NUM_LANES{1'b0}};
  reg [NUM_LINKS-1:0] up_cfg_links_disable = {NUM_LINKS{1'b0}};
  reg up_cfg_disable_char_replacement = 1'b0;
  reg up_cfg_disable_scrambler = 1'b0;

  /* Reset for the register map */
  reg [2:0] up_reset_vector = 3'b111;
  assign up_reset = up_reset_vector[0];

  /* Reset signal generation for the JESD core */
  reg [4:0] core_reset_vector = 5'b11111;
  assign core_reset = core_reset_vector[0];

  reg [4:0] device_reset_vector = 5'b11111;
  assign device_reset = device_reset_vector[0];

  /* Transfer the reset signal back to the up domain, used to keep the
   * synchronizers in reset until the core is ready. This is done in order to
   * prevent bogus data to propagate to the register map. */
  reg [1:0] up_reset_synchronizer_vector = 2'b11;
  assign up_reset_synchronizer = up_reset_synchronizer_vector[0];

  /*
   * Synchronize the external core reset to the register map domain so the status
   * can be shown in the register map. This is useful for debugging.
   */
  reg [1:0] up_core_reset_ext_synchronizer_vector = 2'b11;
  wire up_core_reset_ext;

  assign up_core_reset_ext = up_core_reset_ext_synchronizer_vector[0];

  /* Transfer two cycles before the core comes out of reset */
  wire core_cfg_transfer_en;
  assign core_cfg_transfer_en = core_reset_vector[2] ^ core_reset_vector[1];

  wire device_cfg_transfer_en;
  assign device_cfg_transfer_en = device_reset_vector[2] ^ device_reset_vector[1];

  reg up_reset_core = 1'b1;

  assign up_cfg_is_writeable = up_reset_core;

  always @(posedge up_clk or negedge ext_resetn) begin
    if (ext_resetn == 1'b0) begin
      up_reset_vector <= 3'b111;
    end else begin
      up_reset_vector <= {1'b0,up_reset_vector[2:1]};
    end
  end

  wire core_reset_all = up_reset_core | core_reset_ext;

  always @(posedge core_clk or posedge core_reset_all) begin
    if (core_reset_all == 1'b1) begin
      core_reset_vector <= 5'b11111;
    end else begin
      core_reset_vector <= {1'b0,core_reset_vector[4:1]};
    end
  end

  always @(posedge device_clk or posedge core_reset_all) begin
    if (core_reset_all == 1'b1) begin
      device_reset_vector <= 5'b11111;
    end else begin
      device_reset_vector <= {1'b0,device_reset_vector[4:1]};
    end
  end

  always @(posedge up_clk or posedge core_reset) begin
    if (core_reset == 1'b1) begin
      up_reset_synchronizer_vector <= 2'b11;
    end else begin
      up_reset_synchronizer_vector <= {1'b0,up_reset_synchronizer_vector[1]};
    end
  end

  always @(posedge up_clk or posedge core_reset_ext) begin
    if (core_reset_ext == 1'b1) begin
      up_core_reset_ext_synchronizer_vector <= 2'b11;
    end else begin
      up_core_reset_ext_synchronizer_vector <= {1'b0,up_core_reset_ext_synchronizer_vector[1]};
    end
  end

  always @(posedge core_clk) begin
    if (core_cfg_transfer_en == 1'b1) begin
      core_cfg_octets_per_multiframe <= up_cfg_octets_per_multiframe;
      core_cfg_octets_per_frame <= up_cfg_octets_per_frame;
      core_cfg_lanes_disable <= up_cfg_lanes_disable;
      core_cfg_links_disable <= up_cfg_links_disable;
      core_cfg_disable_scrambler <= up_cfg_disable_scrambler;
      core_cfg_disable_char_replacement <= up_cfg_disable_char_replacement;
      core_extra_cfg <= up_extra_cfg;
    end
  end

  always @(posedge device_clk) begin
    if (device_cfg_transfer_en == 1'b1) begin
      device_cfg_octets_per_multiframe <= up_cfg_octets_per_multiframe;
      device_cfg_octets_per_frame <= up_cfg_octets_per_frame;
      device_cfg_beats_per_multiframe <= up_cfg_beats_per_multiframe;
      device_extra_cfg <= up_dev_extra_cfg;
    end
  end

  /* Interupt handling */
  reg [NUM_IRQS-1:0] up_irq_enable = {NUM_IRQS{1'b0}};
  reg [NUM_IRQS-1:0] up_irq_source = 'h00;
  reg [NUM_IRQS-1:0] up_irq_clear;
  wire [NUM_IRQS-1:0] up_irq_pending;

  assign up_irq_pending = up_irq_source & up_irq_enable;

  always @(posedge up_clk) begin
    if (up_reset == 1'b1) begin
      irq <= 1'b0;
    end else begin
      irq <= |up_irq_pending;
    end
  end

  always @(posedge up_clk) begin
    if (up_reset == 1'b1) begin
      up_irq_source <= 'h00;
    end else begin
      up_irq_source <= (up_irq_source & ~up_irq_clear) | up_irq_trigger;
    end
  end

  /* Count link enable */
  wire [8*16-1:0] up_irq_event_cnt_bus;
  wire [15:0] up_link_enable_cnt_s;

  genvar i;
  generate if (ENABLE_LINK_STATS == 1) begin : g_link_stats

    reg [15:0] up_link_enable_cnt = 'h0;
    reg up_reset_core_d1 = 'b1;

    wire up_stat_clear;

    assign up_stat_clear = (up_waddr == 12'h0b0 && up_wreq && up_wdata[0]);

    always @(posedge up_clk) begin
      up_reset_core_d1 <= up_reset_core;
      if (up_stat_clear) begin
        up_link_enable_cnt <= 'h0;
      end else begin
        if (~up_reset_core & up_reset_core_d1) begin
          up_link_enable_cnt <= up_link_enable_cnt + 16'd1;
        end
      end
    end

    assign up_link_enable_cnt_s = up_link_enable_cnt;

    /* Count IRQ events for max 8 interrupt sources */

    for (i = 0; i < NUM_IRQS; i=i+1) begin : irq_cnt

      reg [15:0] up_irq_event_cnt = 'h0;

      always @(posedge up_clk) begin
        if (up_stat_clear) begin
          up_irq_event_cnt <= 'h0;
        end else if (up_irq_trigger[i]) begin
          up_irq_event_cnt <= up_irq_event_cnt + 16'd1;
        end
      end

      assign up_irq_event_cnt_bus[i*16 +: 16] = up_irq_event_cnt;

    end
  end else begin : g_no_link_stats
    assign up_irq_event_cnt_bus = 'h0;
    assign up_link_enable_cnt_s = 'h0;
  end
  endgenerate

  wire [20:0] clk_mon_count;
  wire [20:0] device_clk_mon_count;

  always @(*) begin
    case (up_raddr)
      /* Standard registers */
      12'h000: up_rdata = PCORE_VERSION;
      12'h001: up_rdata = ID;
      12'h002: up_rdata = up_scratch;
      12'h003: up_rdata = PCORE_MAGIC;

      /* Core configuration */
      12'h004: up_rdata = status_synth_params0;
      12'h005: up_rdata = status_synth_params1;
      12'h006: up_rdata = status_synth_params2;
      /* 0x07-0x0f reserved for future use */
      /* 0x10-0x1f reserved for core specific HDL configuration information */

      /* IRQ block */
      12'h020: up_rdata = up_irq_enable;
      12'h021: up_rdata = up_irq_pending;
      12'h022: up_rdata = up_irq_source;
      /* 0x23-0x30 reserved for future use */

      /* JESD common control */
      12'h030: up_rdata = up_reset_core;
      12'h031: up_rdata = {up_core_reset_ext, up_reset_synchronizer}; /* core ready */
      12'h032: up_rdata = {11'h00, clk_mon_count}; /* Make it 16.16 */
      12'h033: up_rdata = {11'h00, device_clk_mon_count}; /* Make it 16.16 */
      /* 0x34-0x34 reserver for future use */

      12'h080: up_rdata = up_cfg_lanes_disable;
      /* 0x82-0x83 reserved for future lane disable bits (max 128 lanes) */
      12'h084: up_rdata = {
        /* 24-31 */ 8'h00, /* Reserved for future extensions of octets_per_frame */
        /* 16-23 */ up_cfg_octets_per_frame,
        /* 10-15 */ 6'b000000, /* Reserved for future extensions of beats_per_multiframe */
        /* 00-09 */ up_cfg_octets_per_multiframe
      };
      12'h85: up_rdata = {
        /* 02-31 */ 30'h00, /* Reserved for future additions */
        /*    01 */ up_cfg_disable_char_replacement, /* Disable character replacement */
        /*    00 */ up_cfg_disable_scrambler /* Disable scrambler */
      };
      12'h086: up_rdata = up_cfg_links_disable;
      12'h087: up_rdata = up_cfg_beats_per_multiframe;
      /* 0x88-0x8f reserved for future use */

      /* 0x90-0x9f reserved for core specific configuration options */

      /* 0xb0 Stat control */
      12'h0b1: up_rdata = up_link_enable_cnt_s;
      /* 0xb4-0xb7 IRQ Stat, max 8 interrupt sources */
      12'h0b4: up_rdata = up_irq_event_cnt_bus[0*32 +: 32];
      12'h0b5: up_rdata = up_irq_event_cnt_bus[1*32 +: 32];
      12'h0b6: up_rdata = up_irq_event_cnt_bus[2*32 +: 32];
      12'h0b7: up_rdata = up_irq_event_cnt_bus[3*32 +: 32];

      default: up_rdata = 'h00;
    endcase
  end

  /* IRQ pending register is write-1-to-clear */
  always @(*) begin
    if (up_wreq == 1'b1 && up_waddr == 12'h21) begin
      up_irq_clear = up_wdata[NUM_IRQS-1:0];
    end else begin
      up_irq_clear = {NUM_IRQS{1'b0}};
    end
  end

  always @(posedge up_clk) begin
    if (up_reset == 1'b1) begin
      up_scratch <= 'h00;
      up_irq_enable <= {NUM_IRQS{1'b0}};
      up_reset_core <= 1'b1;

      up_cfg_octets_per_frame <= 'h00;
      up_cfg_octets_per_multiframe <= {DATA_PATH_WIDTH_LOG2{1'b1}};
      up_cfg_lanes_disable <= {NUM_LANES{1'b0}};
      up_cfg_links_disable <= {NUM_LINKS{1'b0}};
      up_cfg_beats_per_multiframe <= 'h00;

      up_cfg_disable_char_replacement <= 1'b0;
      up_cfg_disable_scrambler <= 1'b0;
    end else if (up_wreq == 1'b1) begin
      case (up_waddr)
        /* Standard registers */
        12'h002: up_scratch <= up_wdata;

        /* IRQ block */
        12'h020: up_irq_enable <= up_wdata[NUM_IRQS-1:0];

        /* JESD common control */
        12'h030: up_reset_core <= up_wdata[0];
      endcase

      /*
       * The configuration needs to be static while the core is
       * active. To enforce this writes to configuration registers
       * will be ignored while the core is out of reset.
       */
      if (up_cfg_is_writeable == 1'b1) begin
        case (up_waddr)
          12'h080: begin
            up_cfg_lanes_disable <= up_wdata[NUM_LANES-1:0];
          end
          12'h084: begin
            up_cfg_octets_per_frame <= up_wdata[23:16];
            up_cfg_octets_per_multiframe <= {up_wdata[9:DATA_PATH_WIDTH_LOG2],
                                            {DATA_PATH_WIDTH_LOG2{1'b1}}};
          end
          12'h085: begin
            up_cfg_disable_char_replacement <= up_wdata[1];
            up_cfg_disable_scrambler <= up_wdata[0];
          end
          12'h086: begin
            up_cfg_links_disable <= up_wdata[NUM_LINKS-1:0];
          end
          12'h087: begin
            up_cfg_beats_per_multiframe <= up_wdata[7:0];
          end
        endcase
      end
    end
  end

  up_clock_mon #(
    .TOTAL_WIDTH(21)
  ) i_clock_mon (
    .up_rstn(~up_reset),
    .up_clk(up_clk),
    .up_d_count(clk_mon_count),
    .d_rst(1'b0),
    .d_clk(core_clk));

  up_clock_mon #(
    .TOTAL_WIDTH(21)
  ) i_dev_clock_mon (
    .up_rstn(~up_reset),
    .up_clk(up_clk),
    .up_d_count(device_clk_mon_count),
    .d_rst(1'b0),
    .d_clk(device_clk));

endmodule
