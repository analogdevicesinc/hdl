//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// This interface includes both the transmit and receive components -
// They both uses the same clock (sourced from the receiving side).
// assumes RX_IQ is 1 for I and 0 for Q (RX_IFIRST = 1 , RXIQ_HILO = 1)

`timescale 1ns/100ps

module axi_ad9963_if #(

  // this parameter controls the buffer type based on the target device.

  parameter   DEVICE_TYPE = 0,
  parameter   DAC_IODELAY_ENABLE = 0,
  parameter   ADC_IODELAY_ENABLE = 0,
  parameter   IO_DELAY_GROUP = "dev_if_delay_group") (

  // physical interface (receive)

  input               trx_clk,
  input               trx_iq,
  input       [11:0]  trx_data,

  // physical interface (transmit)

  input               tx_clk,
  output              tx_iq,
  output      [11:0]  tx_data,

  // clock (common to both receive and transmit)

  input               adc_rst,
  input               dac_rst,
  output              adc_clk,
  output              dac_clk,

  // receive data path interface

  output reg          adc_valid,
  output reg  [23:0]  adc_data,
  output reg          adc_status,

  // transmit data path interface

  input           dac_valid,
  input   [23:0]  dac_data,

  // delay interface

  input           up_clk,
  input   [12:0]  up_adc_dld,
  input   [64:0]  up_adc_dwdata,
  output  [64:0]  up_adc_drdata,
  input           delay_clk,
  input           delay_rst,
  output          delay_locked);

  // internal registers

  reg     [11:0]  rx_data_p = 0;
  reg     [11:0]  tx_data_p = 'd0;
  reg     [11:0]  tx_data_n = 'd0;

  // internal signals

  wire    [11:0]  rx_data_p_s;
  wire    [11:0]  rx_data_n_s;
  wire            rx_iq_p_s;
  wire            rx_iq_n_s;

  wire            tx_clk_serdes;
  wire            div_clk;

  genvar          l_inst;

  always @(posedge adc_clk) begin
    if( rx_iq_p_s == 1'b1) begin
      adc_data  <= {rx_data_n_s, rx_data_p_s} ;  // data[11:00] I
      adc_valid <= 1'b1;                        // data[23:12] Q
    end else begin
      rx_data_p <= rx_data_p_s;               // if this happens it means that risedge data is sampled on falledge
      adc_data  <= {rx_data_p, rx_data_n_s} ;  // so we take current N data with previous P data
      adc_valid <= 1'b1;                      // in order to have data sampled at the same instance sent to the DMA
    end
  end

  always @(posedge dac_clk) begin
    if(dac_valid == 1'b1) begin
      tx_data_p   <= dac_data[11:0] ;
      tx_data_n   <= dac_data[23:12];
    end
  end

  always @(posedge adc_clk) begin
    if (adc_rst == 1'b1) begin
      adc_status <= 1'b0;
    end else begin
      adc_status <= 1'b1;
    end
  end

  // device clock interface (receive clock)

  BUFG i_clk_gbuf (
    .I (trx_clk),
    .O (adc_clk));

  // receive data interface, ibuf -> idelay -> iddr

  generate
  for (l_inst = 0; l_inst <= 11; l_inst = l_inst + 1) begin: g_rx_data
  ad_lvds_in #(
    .SINGLE_ENDED (1),
    .DEVICE_TYPE (DEVICE_TYPE),
    .IODELAY_ENABLE (ADC_IODELAY_ENABLE),
    .IODELAY_CTRL (0),
    .IODELAY_GROUP (IO_DELAY_GROUP))
  i_rx_data (
    .rx_clk (adc_clk),
    .rx_data_in_p (trx_data[l_inst]),
    .rx_data_in_n (1'b0),
    .rx_data_p (rx_data_p_s[l_inst]),
    .rx_data_n (rx_data_n_s[l_inst]),
    .up_clk (up_clk),
    .up_dld (up_adc_dld[l_inst]),
    .up_dwdata (up_adc_dwdata[((l_inst*5)+4):(l_inst*5)]),
    .up_drdata (up_adc_drdata[((l_inst*5)+4):(l_inst*5)]),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked ());
  end
  endgenerate

  // receive iq interface, ibuf -> idelay -> iddr

  ad_lvds_in #(
    .SINGLE_ENDED (1),
    .DEVICE_TYPE (DEVICE_TYPE),
    .IODELAY_ENABLE (ADC_IODELAY_ENABLE),
    .IODELAY_CTRL (1),
    .IODELAY_GROUP (IO_DELAY_GROUP))
  i_rx_iq (
    .rx_clk (adc_clk),
    .rx_data_in_p (trx_iq),
    .rx_data_in_n (1'b0),
    .rx_data_p (rx_iq_p_s),
    .rx_data_n (rx_iq_n_s),
    .up_clk (up_clk),
    .up_dld (up_adc_dld[12]),
    .up_dwdata (up_adc_dwdata[64:60]),
    .up_drdata (up_adc_drdata[64:60]),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked (delay_locked));

  // transmit data interface

  BUFG dac_bufg (
    .I(div_clk),
    .O(dac_clk));

  ad_serdes_clk #(
    .DEVICE_TYPE(DEVICE_TYPE),
    .DDR_OR_SDR_N(0),
    .MMCM_OR_BUFR_N (1'b0),
    .CLKIN_DS_OR_SE_N(0),
    .SERDES_FACTOR(2)) 
  tx_serdes_clk (
    .rst(1'b0),
    .clk_in_p(tx_clk),
    .clk_in_n(1'b0),
    .clk(tx_clk_serdes),
    .div_clk(div_clk),
    .out_clk(),
    .loaden(),
    .phase(),
    .up_clk(1'b0),
    .up_rstn(1'b0),
    .up_drp_sel(1'b0),
    .up_drp_wr(1'b0),
    .up_drp_addr(12'h0),
    .up_drp_wdata(32'h0),
    .up_drp_rdata(),
    .up_drp_ready(),
    .up_drp_locked());

  ad_serdes_out #(
    .DEVICE_TYPE (DEVICE_TYPE),
    .DDR_OR_SDR_N (1'b0),
    .SERDES_FACTOR(2),
    .DATA_WIDTH (13))
  i_serdes_out_data (
    .rst (dac_rst),
    .clk (tx_clk_serdes),
    .div_clk (div_clk),
    .loaden (1'b0),
    .data_s0 ({1'b1,tx_data_p}),
    .data_s1 ({1'b0,tx_data_n}),
    .data_s2 (13'h0),
    .data_s3 (13'h0),
    .data_s4 (13'h0),
    .data_s5 (13'h0),
    .data_s6 (13'h0),
    .data_s7 (13'h0),
    .data_out_se ({tx_iq,tx_data}),
    .data_out_p (),
    .data_out_n ());

endmodule

// ***************************************************************************
// ***************************************************************************
