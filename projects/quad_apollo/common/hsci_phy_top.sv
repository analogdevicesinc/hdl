`timescale 1ps/1ps
module hsci_phy_top (

  input wire          pll_inclk,
  input wire   [0:1]  hsci_pll_reset,

  output logic [0:1]  hsci_pclk,
  output logic [0:1]  hsci_pll_locked,

  output logic [0:3]  hsci_mosi_d_p,
  output logic [0:3]  hsci_mosi_d_n,

  input wire   [0:3]  hsci_miso_d_p,
  input wire   [0:3]  hsci_miso_d_n,

  output logic [0:3]  hsci_mosi_clk_p,
  output logic [0:3]  hsci_mosi_clk_n,

  input wire   [0:3]  hsci_miso_clk_p,
  input wire   [0:3]  hsci_miso_clk_n,

  input  wire  [7:0]  hsci_menc_clk_0,
  input  wire  [7:0]  hsci_menc_clk_1,
  input  wire  [7:0]  hsci_menc_clk_2,
  input  wire  [7:0]  hsci_menc_clk_3,

  input  wire  [7:0]  hsci_mosi_data_0,
  input  wire  [7:0]  hsci_mosi_data_1,
  input  wire  [7:0]  hsci_mosi_data_2,
  input  wire  [7:0]  hsci_mosi_data_3,

  output logic [7:0]  hsci_miso_data_0,
  output logic [7:0]  hsci_miso_data_1,
  output logic [7:0]  hsci_miso_data_2,
  output logic [7:0]  hsci_miso_data_3,

  // Status Signals
  output logic [0:3]  vtc_rdy_bsc_tx,
  output logic [0:3]  dly_rdy_bsc_tx,
  output logic [0:3]  vtc_rdy_bsc_rx,
  output logic [0:3]  dly_rdy_bsc_rx,
  output logic [0:1]  rst_seq_done

);
   //TX
   logic [7:0]       hsci_mosi_data_br [0:3];
   logic [7:0]       hsci_mosi_data    [0:3];

   // RX
   logic [7:0]       hsci_miso_data_br [0:3];
   logic [7:0]       hsci_miso_data    [0:3];
   logic [7:0]       hsci_miso_clk_d   [0:3];
   logic             fifo_empty_6;
   logic             fifo_empty_8;
   logic             fifo_empty_45;
   logic             fifo_empty_47;
   logic             fifo_empty_0;
   logic             fifo_empty_2;
   logic             fifo_empty_39;
   logic             fifo_empty_41;

   // PLL
  //  logic             shared_pll0_clkoutphy_out;
  //  logic             shared_pll0_clkoutphy_out_1;
  //  logic             pll0_clkout1;
  //  logic             pll0_clkout1_1;

   assign hsci_mosi_data[0] = hsci_mosi_data_0;
   assign hsci_mosi_data[1] = hsci_mosi_data_1;
   assign hsci_mosi_data[2] = hsci_mosi_data_2;
   assign hsci_mosi_data[3] = hsci_mosi_data_3;

   assign hsci_miso_data_0  = hsci_miso_data[0];
   assign hsci_miso_data_1  = hsci_miso_data[1];
   assign hsci_miso_data_2  = hsci_miso_data[2];
   assign hsci_miso_data_3  = hsci_miso_data[3];

   function integer hssio_i;
     input integer i;
     hssio_i = i > 1 ? 1 : 0;
   endfunction

   genvar i, j;
   generate
   for (i = 0; i < 4; i ++) begin
     for (j = 0; j < 8; j ++) begin
       assign hsci_mosi_data_br[i][7 - j] = hsci_mosi_data[i][j];
       assign hsci_miso_data[i][7 - j] = (rst_seq_done[hssio_i(i)]) ? hsci_miso_data_br[i][j] : 8'h0;
     end
   end
   endgenerate

   high_speed_selectio_wiz_0 hssio_wiz_0 (
    .fifo_rd_clk_6                  (hsci_pclk[0]),
    .fifo_rd_clk_8                  (hsci_pclk[0]),
    .fifo_rd_clk_45                 (hsci_pclk[0]),
    .fifo_rd_clk_47                 (hsci_pclk[0]),
    .fifo_rd_en_6                   (1'b0),
    .fifo_rd_en_8                   (1'b1 & !fifo_empty_8 & rst_seq_done[0]),
    .fifo_rd_en_45                  (1'b0),
    .fifo_rd_en_47                  (1'b1 & !fifo_empty_47 & rst_seq_done[0]),
    .fifo_empty_6                   (fifo_empty_6),
    .fifo_empty_8                   (fifo_empty_8),
    .fifo_empty_45                  (fifo_empty_45),
    .fifo_empty_47                  (fifo_empty_47),
    .dly_rdy_bsc1                   (dly_rdy_bsc_rx[1]),
    .vtc_rdy_bsc1                   (vtc_rdy_bsc_rx[1]),
    .en_vtc_bsc1                    (1'b1),
    .vtc_rdy_bsc5                   (vtc_rdy_bsc_tx[0]),
    .dly_rdy_bsc5                   (dly_rdy_bsc_tx[0]),
    .en_vtc_bsc5                    (1'b1),
    .dly_rdy_bsc6                   (dly_rdy_bsc_tx[1]),
    .vtc_rdy_bsc6                   (vtc_rdy_bsc_tx[1]),
    .en_vtc_bsc6                    (1'b1),
    .dly_rdy_bsc7                   (dly_rdy_bsc_rx[0]),
    .vtc_rdy_bsc7                   (vtc_rdy_bsc_rx[0]),
    .en_vtc_bsc7                    (1'b1),
    .rst_seq_done                   (rst_seq_done[0]),
    .shared_pll0_clkoutphy_out      (),
    .pll0_clkout0                   (hsci_pclk[0]),
    .rst                            (hsci_pll_reset[0]),
    .clk                            (pll_inclk),
    .pll0_locked                    (hsci_pll_locked[0]),
    // .pll0_clkout1                   (pll0_clkout1),
    .data_in_p_0                    (hsci_miso_d_p[0]),
    .data_in_n_0                    (hsci_miso_d_n[0]),
    .data_to_fabric_data_in_p_0     (hsci_miso_data_br[0]),
    .data_in_p_1                    (hsci_miso_d_p[1]),
    .data_in_n_1                    (hsci_miso_d_n[1]),
    .data_to_fabric_data_in_p_1     (hsci_miso_data_br[1]),
    .clk_in_p_0                     (hsci_miso_clk_p[0]),
    .clk_in_n_0                     (hsci_miso_clk_n[0]),
    .data_to_fabric_clk_in_p_0      (hsci_miso_clk_d[0]),
    .clk_in_p_1                     (hsci_miso_clk_p[1]),
    .clk_in_n_1                     (hsci_miso_clk_n[1]),
    .data_to_fabric_clk_in_p_1      (hsci_miso_clk_d[1]),
    .data_out_p_0                   (hsci_mosi_d_p[0]),
    .data_out_n_0                   (hsci_mosi_d_n[0]),
    .data_from_fabric_data_out_p_0  (hsci_mosi_data_br[0]),
    .data_out_p_1                   (hsci_mosi_d_p[1]),
    .data_out_n_1                   (hsci_mosi_d_n[1]),
    .data_from_fabric_data_out_p_1  (hsci_mosi_data_br[1]),
    .clk_out_p_0                    (hsci_mosi_clk_p[0]),
    .clk_out_n_0                    (hsci_mosi_clk_n[0]),
    .data_from_fabric_clk_out_p_0   (hsci_menc_clk_0),
    .clk_out_p_1                    (hsci_mosi_clk_p[1]),
    .clk_out_n_1                    (hsci_mosi_clk_n[1]),
    .data_from_fabric_clk_out_p_1   (hsci_menc_clk_1)
  );

  high_speed_selectio_wiz_1 hssio_wiz_1 (
    .fifo_rd_clk_0                  (hsci_pclk[1]),
    .fifo_rd_clk_2                  (hsci_pclk[1]),
    .fifo_rd_clk_39                 (hsci_pclk[1]),
    .fifo_rd_clk_41                 (hsci_pclk[1]),
    .fifo_rd_en_0                   (1'b0),
    .fifo_rd_en_2                   (1'b1 & !fifo_empty_2 & rst_seq_done[1]),
    .fifo_rd_en_39                  (1'b0),
    .fifo_rd_en_41                  (1'b1 & !fifo_empty_41 & rst_seq_done[1]),
    .fifo_empty_0                   (fifo_empty_0),
    .fifo_empty_2                   (fifo_empty_2),
    .fifo_empty_39                  (fifo_empty_39),
    .fifo_empty_41                  (fifo_empty_41),
    .dly_rdy_bsc0                   (dly_rdy_bsc_rx[3]),
    .vtc_rdy_bsc0                   (vtc_rdy_bsc_rx[3]),
    .en_vtc_bsc0                    (1'b1),
    .vtc_rdy_bsc1                   (vtc_rdy_bsc_tx[3]),
    .dly_rdy_bsc1                   (dly_rdy_bsc_tx[3]),
    .en_vtc_bsc1                    (1'b1),
    .dly_rdy_bsc6                   (dly_rdy_bsc_rx[2]),
    .vtc_rdy_bsc6                   (vtc_rdy_bsc_rx[2]),
    .en_vtc_bsc6                    (1'b1),
    .dly_rdy_bsc7                   (dly_rdy_bsc_tx[2]),
    .vtc_rdy_bsc7                   (vtc_rdy_bsc_tx[2]),
    .en_vtc_bsc7                    (1'b1),
    .rst_seq_done                   (rst_seq_done[1]),
    .shared_pll0_clkoutphy_out      (),
    .pll0_clkout0                   (hsci_pclk[1]),
    .rst                            (hsci_pll_reset[1]),
    .clk                            (pll_inclk),
    .pll0_locked                    (hsci_pll_locked[1]),
    // .pll0_clkout1                   (pll0_clkout1_1),
    .data_in_p_2                    (hsci_miso_d_p[2]),
    .data_in_n_2                    (hsci_miso_d_n[2]),
    .data_to_fabric_data_in_p_2     (hsci_miso_data_br[2]),
    .data_in_p_3                    (hsci_miso_d_p[3]),
    .data_in_n_3                    (hsci_miso_d_n[3]),
    .data_to_fabric_data_in_p_3     (hsci_miso_data_br[3]),
    .clk_in_p_2                     (hsci_miso_clk_p[2]),
    .clk_in_n_2                     (hsci_miso_clk_n[2]),
    .data_to_fabric_clk_in_p_2      (hsci_miso_clk_d[2]),
    .clk_in_p_3                     (hsci_miso_clk_p[3]),
    .clk_in_n_3                     (hsci_miso_clk_n[3]),
    .data_to_fabric_clk_in_p_3      (hsci_miso_clk_d[3]),
    .data_out_p_2                   (hsci_mosi_d_p[2]),
    .data_out_n_2                   (hsci_mosi_d_n[2]),
    .data_from_fabric_data_out_p_2  (hsci_mosi_data_br[2]),
    .data_out_p_3                   (hsci_mosi_d_p[3]),
    .data_out_n_3                   (hsci_mosi_d_n[3]),
    .data_from_fabric_data_out_p_3  (hsci_mosi_data_br[3]),
    .clk_out_p_2                    (hsci_mosi_clk_p[2]),
    .clk_out_n_2                    (hsci_mosi_clk_n[2]),
    .data_from_fabric_clk_out_p_2   (hsci_menc_clk_2),
    .clk_out_p_3                    (hsci_mosi_clk_p[3]),
    .clk_out_n_3                    (hsci_mosi_clk_n[3]),
    .data_from_fabric_clk_out_p_3   (hsci_menc_clk_3)
  );

endmodule
