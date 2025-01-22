module axi_adf4030_regmap #(
  parameter ID = 0,
  parameter CHANNEL_COUNT = 1
) (

  input  logic                       clk,
  output logic                       rstn,

  // adf4030 control interface
  output logic [CHANNEL_COUNT - 1:0] trig_channel_en,
  output logic [15:0]                trig_channel_phase [CHANNEL_COUNT - 1:0],
  output logic                       direction,
  output logic                       disable_internal_bsync,
  output logic                       manual_trig,
  output logic                       select_trig,
  output logic                       enable_debug_trig,
  output logic                       debug_trig,

  // adf4030 debug interface
  input  logic                       bsync_ready,
  input  logic [ 4:0]                bsync_delay,
  input  logic [15:0]                bsync_ratio,
  input  logic                       bsync_alignment_error,
  input  logic                       bsync_captured,
  input  logic [ 2:0]                bsync_state,
  input  logic [ 2:0]                trig_state [CHANNEL_COUNT - 1:0],

  // bus interface
  input  logic                       up_rstn,
  input  logic                       up_clk,
  input  logic                       up_wreq,
  input  logic [ 7:0]                up_waddr,
  input  logic [31:0]                up_wdata,
  output logic                       up_wack,
  input  logic                       up_rreq,
  input  logic [ 7:0]                up_raddr,
  output logic [31:0]                up_rdata,
  output logic                       up_rack
);

  // local parameters
  localparam [31:0] CORE_VERSION = 32'h00010061;  // 1.00.a
  localparam [31:0] CORE_MAGIC   = 32'h41494F4E;  // AION

  // internal registers
  logic [31:0]                up_scratch;
  logic                       up_manual_trig;
  logic                       up_select_trig;
  logic                       up_enable_debug_trig;
  logic                       up_debug_trig;
  logic                       up_sw_reset;
  logic                       up_direction;
  logic                       up_disable_internal_bsync;
  logic [CHANNEL_COUNT - 1:0] up_trig_channel_en;
  logic [15:0]                up_trig_channel_phase [CHANNEL_COUNT - 1:0];
  logic [ 2:0]                up_trig_state         [CHANNEL_COUNT - 1:0];

  //internal signals
  logic                       up_bsync_ready_s;
  logic [ 4:0]                up_bsync_delay_s;
  logic [15:0]                up_bsync_ratio_s;
  logic                       up_bsync_alignment_error_s;
  logic                       up_bsync_captured_s;
  logic [ 2:0]                up_bsync_state_s;
  logic [31:0]                up_trig_channel_s [7:0];

  //initial values
  initial begin
    up_rdata = 32'b0;
    up_wack = 1'b0;
    up_rack = 1'b0;
    up_scratch = 32'b0;
    up_manual_trig = 1'b0;
    up_select_trig = 1'b0;
    up_enable_debug_trig = 1'b0;
    up_debug_trig = 1'b0;
    up_sw_reset = 1'b0;
    up_direction = 1'b1;
    up_disable_internal_bsync = 1'b0;
    up_trig_channel_en = '0;
    up_trig_channel_phase = '{default:0};
  end

  // write interface
  always @(posedge up_clk) begin
    if (up_rstn == 1'b0 || up_sw_reset == 1'b1) begin
      up_wack <= 1'b0;
      up_scratch <= 32'b0;
      up_select_trig <= 1'b0;
      up_enable_debug_trig <= 1'b0;
      up_debug_trig <= 1'b0;
      up_sw_reset <= 1'b0;
      up_direction <= 1'b1;
      up_disable_internal_bsync <= 1'b0;
      up_trig_channel_en <= '0;
    end else begin
      up_wack <= up_wreq;
      /* Scratch Register */
      if ((up_wreq == 1'b1) && (up_waddr == 'h02)) begin
        up_scratch <= up_wdata;
      end
      /* Control Register */
      if ((up_wreq == 1'b1) && (up_waddr == 'h04)) begin
        up_debug_trig <= up_wdata[13];
        up_enable_debug_trig <= up_wdata[12];
        up_select_trig <= up_wdata[11];
        up_sw_reset <= up_wdata[10];
        up_trig_channel_en <= up_wdata[(CHANNEL_COUNT-1)+2:2];
        up_disable_internal_bsync <= up_wdata[1];
        up_direction <= up_wdata[0];
      end
    end
  end

  always @(posedge up_clk) begin
    if (up_manual_trig == 1'b1) begin
      up_manual_trig <= 1'b0;
    end else begin
      /* Manual Trigger Register */
      if ((up_wreq == 1'b1) && (up_waddr == 'h06)) begin
        up_manual_trig <= up_wdata[0];
      end
    end
  end

  // channel register generation
  genvar i;
  generate
    for (i=0; i<CHANNEL_COUNT; i=i+1) begin
      always @(posedge up_clk) begin
        if (up_rstn == 0 || up_sw_reset == 1'b1) begin
          up_trig_channel_phase[i] <= '0;
        end else begin
          if ((up_wreq == 1'b1) && (up_waddr == 'h07 + i) && up_trig_channel_en[i]) begin
            up_trig_channel_phase[i] <= ((2 * up_bsync_ratio_s) - 2) - up_wdata[15:0];
          end
        end
      end

      assign up_trig_channel_s[i] = {13'b0,up_trig_state[i],up_trig_channel_phase[i]};

      sync_data #(
        .NUM_OF_BITS (3),
        .ASYNC_CLK (1)
      ) i_trig_state (
        .in_clk (clk),
        .in_data (trig_state[i]),
        .out_clk (up_clk),
        .out_data (up_trig_state[i]));

      sync_data #(
        .NUM_OF_BITS (16),
        .ASYNC_CLK (1)
      ) i_trig_channel_phase (
        .in_clk (up_clk),
        .in_data (up_trig_channel_phase[i]),
        .out_clk (clk),
        .out_data (trig_channel_phase[i]));
    end

    if (CHANNEL_COUNT<8) begin
      assign up_trig_channel_s[7:CHANNEL_COUNT] = '{default:0};
    end
  endgenerate

  //read interface for common registers
  always @(posedge up_clk) begin
    if (up_rstn == 1'b0 || up_sw_reset == 1'b1) begin
      up_rack <= 1'b0;
      up_rdata <= 32'b0;
    end else begin
      up_rack <= up_rreq;
      if (up_rreq == 1'b1) begin
        case(up_raddr)
          /* Version Register */
          'h00:  up_rdata <= {
            CORE_VERSION[31:16], /* MAJOR */
            CORE_VERSION[15: 8], /* MINOR */
            CORE_VERSION[ 7: 0]  /* PATCH */
          };
          /* Peripheral ID Register */
          'h01:  up_rdata <= ID;

          /* Peripheral ID Register */
          'h02:  up_rdata <= up_scratch;

          /* Identification Register */
          'h03:  up_rdata <= CORE_MAGIC;

          /* Control Register */
          'h04:  up_rdata <= {
            18'b0,
            up_debug_trig,
            up_enable_debug_trig,
            up_select_trig,
            up_sw_reset,
            {(8-CHANNEL_COUNT){1'b0}},
            up_trig_channel_en,
            up_disable_internal_bsync,
            up_direction
          };

          /* Debug Register */
          'h05: up_rdata <= {
            5'b0,
            up_bsync_state_s,
            up_bsync_captured_s,
            up_bsync_alignment_error_s,
            up_bsync_ratio_s,
            up_bsync_delay_s,
            up_bsync_ready_s
          };

          /* Manual Trigger Register*/
          'h06: up_rdata <= {
            31'b0,
            up_manual_trig
          };

          'h07: up_rdata <= up_trig_channel_s[0];
          'h08: up_rdata <= up_trig_channel_s[1];
          'h09: up_rdata <= up_trig_channel_s[2];
          'h0A: up_rdata <= up_trig_channel_s[3];
          'h0B: up_rdata <= up_trig_channel_s[4];
          'h0C: up_rdata <= up_trig_channel_s[5];
          'h0D: up_rdata <= up_trig_channel_s[6];
          'h0E: up_rdata <= up_trig_channel_s[7];
          default: up_rdata <= 32'b0;
        endcase
      end else begin
        up_rdata <= 32'b0;
      end
    end
  end /* read interface */

  assign direction = up_direction;

  // Clock Domain Crossing Logic for reset, control and status signals
  sync_data #(
    .NUM_OF_BITS (CHANNEL_COUNT),
    .ASYNC_CLK (1)
  ) i_trig_channel_en (
    .in_clk (up_clk),
    .in_data (up_trig_channel_en),
    .out_clk (clk),
    .out_data (trig_channel_en));

  sync_bits #(
    .NUM_OF_BITS (5),
    .ASYNC_CLK (1)
  ) i_control_signals (
    .in_bits ({up_debug_trig, up_enable_debug_trig, up_select_trig, ~up_sw_reset, up_disable_internal_bsync}),
    .out_clk (clk),
    .out_resetn (1'b1),
    .out_bits ({debug_trig, enable_debug_trig, select_trig, rstn, disable_internal_bsync}));

  sync_bits #(
    .NUM_OF_BITS (1),
    .ASYNC_CLK (1)
  ) i_manual_trig (
    .in_bits (up_manual_trig),
    .out_clk (clk),
    .out_resetn (1'b1),
    .out_bits (manual_trig));

  sync_data #(
    .NUM_OF_BITS (3),
    .ASYNC_CLK (1)
  ) i_bsync_state (
    .in_clk (clk),
    .in_data (bsync_state),
    .out_clk (up_clk),
    .out_data (up_bsync_state_s));

  sync_data #(
    .NUM_OF_BITS (16),
    .ASYNC_CLK (1)
  ) i_bsync_ratio (
    .in_clk (clk),
    .in_data (bsync_ratio),
    .out_clk (up_clk),
    .out_data (up_bsync_ratio_s));

  sync_data #(
    .NUM_OF_BITS (5),
    .ASYNC_CLK (1)
  ) i_bsync_delay (
    .in_clk (clk),
    .in_data (bsync_delay),
    .out_clk (up_clk),
    .out_data (up_bsync_delay_s));
 
  sync_bits #(
    .NUM_OF_BITS (3),
    .ASYNC_CLK (1)
  ) i_debug_signals (
    .in_bits ({bsync_captured, bsync_alignment_error, bsync_ready}),
    .out_clk (up_clk),
    .out_resetn (1'b1),
    .out_bits ({up_bsync_captured_s, up_bsync_alignment_error_s, up_bsync_ready_s}));

endmodule
