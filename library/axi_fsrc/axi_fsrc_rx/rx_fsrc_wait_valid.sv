`default_nettype none

module rx_fsrc_wait_valid #(
   localparam RX_NUM_LINK = 4,
   localparam NUM_LINK_GROUPS = 2,
   localparam RX_MAIN_LINK_OUT_WIDTH = 1024,
   localparam RX_DUAL_LINK_OUT_WIDTH = 512,
   localparam int RX_OUT_WIDTH_PER_LINK [RX_NUM_LINK-1:0] = {RX_DUAL_LINK_OUT_WIDTH,RX_MAIN_LINK_OUT_WIDTH, RX_DUAL_LINK_OUT_WIDTH,RX_MAIN_LINK_OUT_WIDTH},
   localparam MAX_OUT_WIDTH = RX_MAIN_LINK_OUT_WIDTH
)(
   output logic [RX_NUM_LINK-1:0][MAX_OUT_WIDTH-1:0]                 rx_sample_data_fsrc,
   output logic [RX_NUM_LINK-1:0]                                    rx_sample_valid_fsrc,

   input  wire  [RX_NUM_LINK-1:0]                                    rx_glblclk,
   input  wire  [RX_NUM_LINK-1:0]                                    rx_transport_reset_gc,
   input  wire [RX_NUM_LINK-1:0][MAX_OUT_WIDTH-1:0]                  rx_sample_data,
   input  wire [RX_NUM_LINK-1:0]                                     rx_sample_valid,

   input  wire  [RX_NUM_LINK-1:0][7:0]                               np_param,
   input  wire  [RX_NUM_LINK-1:0][7:0]                               fsrc_frame_cnt_max,
   input  wire                                                       fsrc_en
);

   localparam RX_MAX_NP = 16;
   localparam FSRC_INVALID_SAMPLE = {1'b1, {(RX_MAX_NP-1){1'b0}}};

   function automatic logic [MAX_OUT_WIDTH-1:0] fsrc_invalid_sample_bus(input int np);
      logic [MAX_OUT_WIDTH-1:0] val = 0;
      int jj;
      logic [MAX_OUT_WIDTH-1:0] invalid_sample = FSRC_INVALID_SAMPLE>>(RX_MAX_NP-np);
      for(jj = 0; jj < (MAX_OUT_WIDTH/np); jj=jj+1) begin
          val |= invalid_sample << (np*jj);
      end
      return val;
   endfunction

   localparam logic [MAX_OUT_WIDTH-1:0] FSRC_INVALID_SAMPLE_NP_8 = fsrc_invalid_sample_bus(8);
   localparam logic [MAX_OUT_WIDTH-1:0] FSRC_INVALID_SAMPLE_NP_12 = fsrc_invalid_sample_bus(12);
   localparam logic [MAX_OUT_WIDTH-1:0] FSRC_INVALID_SAMPLE_NP_16 = fsrc_invalid_sample_bus(16);

   genvar ii;

   logic [RX_NUM_LINK-1:0]                                  fsrc_valid_cur;
   logic [RX_NUM_LINK-1:0]                                  fsrc_valid;
   logic [RX_NUM_LINK-1:0]                                  fsrc_frame_start;
   logic [RX_NUM_LINK-1:0][7:0]                             fsrc_frame_cnt;
   logic [RX_NUM_LINK-1:0][MAX_OUT_WIDTH-1:0]               fsrc_invalid_sample_expected;
   (*KEEP = "TRUE" *) logic [RX_NUM_LINK-1:0][MAX_OUT_WIDTH-1:0]          rx_sample_data_d;
   (*KEEP = "TRUE" *) logic [RX_NUM_LINK-1:0]                             rx_sample_valid_d;

   for(ii=0; ii < RX_NUM_LINK; ii=ii+1) begin : rx_fsrc_gen
      // Only look for valid samples when the frame boundary is at the start of a data word
      always_ff @(posedge rx_glblclk[ii]) begin
         if(rx_transport_reset_gc[ii]) begin
            fsrc_frame_cnt[ii] <= '0;
            fsrc_frame_start[ii] <= 1'b1;
         end else begin
            if(rx_sample_valid[ii]) begin
               if(fsrc_frame_cnt[ii] == fsrc_frame_cnt_max[ii]) begin
                  fsrc_frame_cnt[ii] <= '0;
                  fsrc_frame_start[ii] <= 1'b1;
               end else begin
                  fsrc_frame_cnt[ii] <= fsrc_frame_cnt[ii] + 1'b1;
                  fsrc_frame_start[ii] <= 1'b0;
               end
            end
         end
      end

      // Expected value of sample_assembly output bus if all samples are invalid
      always_comb begin
         case(np_param[ii])
            8'd7:    fsrc_invalid_sample_expected[ii] = FSRC_INVALID_SAMPLE_NP_8;
            8'd11:   fsrc_invalid_sample_expected[ii] = FSRC_INVALID_SAMPLE_NP_12;
            8'd15:   fsrc_invalid_sample_expected[ii] = FSRC_INVALID_SAMPLE_NP_16;
            default: fsrc_invalid_sample_expected[ii] = FSRC_INVALID_SAMPLE_NP_8;
         endcase
      end

      // FSRC gate capture until valid sample seen
      assign fsrc_valid_cur[ii] = rx_sample_valid[ii] && fsrc_frame_start[ii] && (rx_sample_data[ii][RX_OUT_WIDTH_PER_LINK[ii]-1:0] != fsrc_invalid_sample_expected[ii][RX_OUT_WIDTH_PER_LINK[ii]-1:0]);

      always_ff @(posedge rx_glblclk[ii]) begin
         if(rx_transport_reset_gc[ii]) begin
            fsrc_valid[ii] <= 1'b0;
         end else begin
            fsrc_valid[ii] <= fsrc_valid[ii] || fsrc_valid_cur[ii];
         end
      end

      always_ff @(posedge rx_glblclk[ii]) begin
         rx_sample_valid_d[ii] <= rx_sample_valid[ii];
         rx_sample_data_d[ii] <= rx_sample_data[ii];
      end

      always_ff @(posedge rx_glblclk[ii]) begin
         if(rx_transport_reset_gc[ii]) begin
            rx_sample_valid_fsrc[ii] <= 1'b0;
         end else begin
            rx_sample_valid_fsrc[ii] <= rx_sample_valid_d[ii] && (!fsrc_en || fsrc_valid[ii]);
         end
      end

      always_ff @(posedge rx_glblclk[ii]) begin
         rx_sample_data_fsrc[ii] <= rx_sample_data_d[ii];
      end
   end

endmodule


`default_nettype wire
