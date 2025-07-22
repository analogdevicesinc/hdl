`timescale 1ns / 1ps

module axi_adf4030 #(
  parameter FPGA_FAMILY = 0,
  // Peripheral ID
  parameter ID = 0,

  // Number of active trigger channels
  parameter CHANNEL_COUNT = 1
) (

  inout  logic bsync_p,
  inout  logic bsync_n,
  input  logic device_clk,
  input  logic trigger,
  output logic sysref,
  output logic [CHANNEL_COUNT-1:0] trig_channel,

  // AXI BUS
  input  logic                     s_axi_aresetn,
  input  logic                     s_axi_aclk,
  input  logic                     s_axi_awvalid,
  input  logic [ 9:0]              s_axi_awaddr,
  input  logic [ 2:0]              s_axi_awprot,
  output logic                     s_axi_awready,
  input  logic                     s_axi_wvalid,
  input  logic [31:0]              s_axi_wdata,
  input  logic [ 3:0]              s_axi_wstrb,
  output logic                     s_axi_wready,
  output logic                     s_axi_bvalid,
  output logic [ 1:0]              s_axi_bresp,
  input  logic                     s_axi_bready,
  input  logic                     s_axi_arvalid,
  input  logic [ 9:0]              s_axi_araddr,
  input  logic [ 2:0]              s_axi_arprot,
  output logic                     s_axi_arready,
  output logic                     s_axi_rvalid,
  output logic [ 1:0]              s_axi_rresp,
  output logic [31:0]              s_axi_rdata,
  input  logic                     s_axi_rready
);

  localparam SIM_DEVICE = (FPGA_FAMILY == 6) ? "VERSAL_AI_CORE" : "ULTRASCALE" ;

  logic        external_bsync;
  logic        internal_bsync;
  logic        trigger_sync;
  logic        bsync_ready;
  logic [15:0] bsync_ratio;
  logic [ 4:0] bsync_delay;
  logic        bsync_alignment_error;
  logic        bsync_captured;
  logic [ 2:0] bsync_state;
  logic        bsync_event;
  logic        manual_trig;
  logic        select_trig;
  logic        enable_debug_trig;
  logic        debug_trig;
  logic        enable_misalign_check;
  logic        trig;

  // Internal up bus, translated by up_axi
  logic        up_rstn;
  logic        up_clk;
  logic        up_wreq;
  logic [ 7:0] up_waddr;
  logic [31:0] up_wdata;
  logic        up_wack;
  logic        up_rreq;
  logic [ 7:0] up_raddr;
  logic [31:0] up_rdata;
  logic        up_rack;

  assign up_clk  = s_axi_aclk;
  assign up_rstn = s_axi_aresetn;

  logic [CHANNEL_COUNT-1:0] trig_channel_en;
  logic [15:0]              trig_channel_phase [CHANNEL_COUNT - 1:0];
  logic [ 2:0]              trig_state         [CHANNEL_COUNT - 1:0];
  logic                     direction;
  logic                     disable_internal_bsync;
  logic [CHANNEL_COUNT-1:0] trig_channel_s;

  IOBUFDS_DCIEN #( 
    .SIM_DEVICE      (SIM_DEVICE),
    .USE_IBUFDISABLE ("TRUE")
  ) IOBUFDS_inst (
   .O              (external_bsync),
   .DCITERMDISABLE (0),
   .I              (internal_bsync),
   .IBUFDISABLE    (!direction),
   .IO             (bsync_p),
   .IOB            (bsync_n),
   .T              (direction));

  assign sysref = external_bsync;

  bsync_generator i_bsync_gen (
    .clk                    (device_clk),
    .rstn                   (rstn),
    .direction              (direction),
    .bsync_in               (external_bsync),
    .disable_internal_bsync (disable_internal_bsync),
    .enable_misalign_check  (enable_misalign_check),
    .bsync_ready            (bsync_ready),
    .bsync_delay            (bsync_delay),
    .bsync_ratio            (bsync_ratio),
    .bsync_alignment_error  (bsync_alignment_error),
    .bsync_captured         (bsync_captured),
    .bsync_state            (bsync_state),
    .bsync_event            (bsync_event),
    .bsync_out              (internal_bsync));

  ad_rst i_trig_sync (
    .rst_async (trigger),
    .clk       (device_clk),
    .rstn      (),
    .rst       (trigger_sync));

  assign trig = enable_debug_trig ? 1'b0 : (select_trig ? trigger_sync : manual_trig);

  genvar i;
  generate
    for (i = 0; i < CHANNEL_COUNT; i = i + 1) begin
      trigger_channel i_channel (
        .clk         (device_clk),
        .rstn        (rstn),
        .trigger     (trig),
        .ch_en       (trig_channel_en[i]),
        .ch_phase    (trig_channel_phase[i]),
        .bsync_event (bsync_event),
        .bsync_ready (bsync_ready),
        .bsync_delay (bsync_delay),
        .bsync_ratio (bsync_ratio),
        .trig_state  (trig_state[i]),
        .trig_out    (trig_channel_s[i]));

      assign trig_channel[i] = enable_debug_trig ? debug_trig : trig_channel_s[i];
    end
  endgenerate

  axi_adf4030_regmap #(
    .ID            (ID),
    .CHANNEL_COUNT (CHANNEL_COUNT)
  ) i_regmap (
    .clk                    (device_clk),
    .rstn                   (rstn),

    .trig_channel_en        (trig_channel_en),
    .trig_channel_phase     (trig_channel_phase),
    .direction              (direction),
    .disable_internal_bsync (disable_internal_bsync),
    .manual_trig            (manual_trig),
    .select_trig            (select_trig),
    .enable_debug_trig      (enable_debug_trig),
    .debug_trig             (debug_trig),
    .enable_misalign_check  (enable_misalign_check),

    .bsync_ready            (bsync_ready),
    .bsync_delay            (bsync_delay),
    .bsync_ratio            (bsync_ratio),
    .bsync_alignment_error  (bsync_alignment_error),
    .bsync_captured         (bsync_captured),
    .bsync_state            (bsync_state),
    .trig_state             (trig_state),

    .up_rstn                (up_rstn),
    .up_clk                 (up_clk),
    .up_wreq                (up_wreq),
    .up_waddr               (up_waddr),
    .up_wdata               (up_wdata),
    .up_wack                (up_wack),
    .up_rreq                (up_rreq),
    .up_raddr               (up_raddr),
    .up_rdata               (up_rdata),
    .up_rack                (up_rack));

  up_axi #(
    .AXI_ADDRESS_WIDTH(10)
  ) i_up_axi (
    .up_rstn        (s_axi_aresetn),
    .up_clk         (s_axi_aclk),

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

    .up_wreq        (up_wreq),
    .up_waddr       (up_waddr),
    .up_wdata       (up_wdata),
    .up_wack        (up_wack),
    .up_rreq        (up_rreq),
    .up_raddr       (up_raddr),
    .up_rdata       (up_rdata),
    .up_rack        (up_rack));

endmodule
