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
  parameter   IO_DELAY_GROUP = "dev_if_delay_group") (

  // physical interface (receive)

  input               trx_clk,
  input               trx_iq,
  input       [11:0]  trx_data,

  // physical interface (transmit)

  output              tx_clk,
  output              tx_iq,
  output      [11:0]  tx_data,

  // clock (common to both receive and transmit)

  input               rst,
  output              l_clk,
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
  input   [13:0]  up_dac_dld,
  input   [69:0]  up_dac_dwdata,
  output  [69:0]  up_dac_drdata,
  input           delay_clk,
  input           delay_rst,
  output          delay_locked);

  // internal registers

  reg     [11:0]  rx_data_p = 0;
  reg     [11:0]  tx_data_p = 'd0;
  reg     [11:0]  tx_data_n = 'd0;
  reg             tx_n_iq = 'd0;
  reg             tx_p_iq = 'd0;

  // internal signals

  wire    [11:0]  rx_data_p_s;
  wire    [11:0]  rx_data_n_s;
  wire            rx_iq_p_s;
  wire            rx_iq_n_s;

  wire            feedback_clk;
  wire            tx_clk_pll;

  genvar          l_inst;

  always @(posedge l_clk) begin
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
      tx_p_iq     <= 1'b1;
      tx_n_iq     <= 1'b0;
    end
  end

  always @(posedge l_clk) begin
    if (rst == 1'b1) begin
      adc_status <= 1'b0;
    end else begin
      adc_status <= 1'b1;
    end
  end

  // device clock interface (receive clock)

  BUFG i_clk_gbuf (
    .I (trx_clk),
    .O (l_clk));

  // receive data interface, ibuf -> idelay -> iddr

  generate
  for (l_inst = 0; l_inst <= 11; l_inst = l_inst + 1) begin: g_rx_data
  ad_lvds_in #(
    .SINGLE_ENDED (1),
    .DEVICE_TYPE (DEVICE_TYPE),
    .IODELAY_CTRL (0),
    .IODELAY_GROUP (IO_DELAY_GROUP))
  i_rx_data (
    .rx_clk (l_clk),
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
    .IODELAY_CTRL (1),
    .IODELAY_GROUP (IO_DELAY_GROUP))
  i_rx_iq (
    .rx_clk (l_clk),
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

  // transmit data interface, oddr -> obuf

  generate
  for (l_inst = 0; l_inst <= 11; l_inst = l_inst + 1) begin: g_tx_data
  ad_lvds_out #(
    .DEVICE_TYPE (DEVICE_TYPE),
    .SINGLE_ENDED (1),
    .IODELAY_ENABLE (DAC_IODELAY_ENABLE),
    .IODELAY_CTRL (0),
    .IODELAY_GROUP (IO_DELAY_GROUP))
  i_tx_data (
    .tx_clk (dac_clk),
    .tx_data_p (tx_data_p[l_inst]),
    .tx_data_n (tx_data_n[l_inst]),
    .tx_data_out_p (tx_data[l_inst]),
    .tx_data_out_n (),
    .up_clk (up_clk),
    .up_dld (up_dac_dld[l_inst]),
    .up_dwdata (up_dac_dwdata[((l_inst*5)+4):(l_inst*5)]),
    .up_drdata (up_dac_drdata[((l_inst*5)+4):(l_inst*5)]),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked ());
  end
  endgenerate

  // transmit iq interface, oddr -> obuf

  ad_lvds_out #(
    .DEVICE_TYPE (DEVICE_TYPE),
    .SINGLE_ENDED (1),
    .IODELAY_ENABLE (DAC_IODELAY_ENABLE),
    .IODELAY_CTRL (0),
    .IODELAY_GROUP (IO_DELAY_GROUP))
  i_tx_iq (
    .tx_clk (dac_clk),
    .tx_data_p (tx_p_iq),
    .tx_data_n (tx_n_iq),
    .tx_data_out_p (tx_iq),
    .tx_data_out_n (),
    .up_clk (up_clk),
    .up_dld (up_dac_dld[12]),
    .up_dwdata (up_dac_dwdata[64:60]),
    .up_drdata (up_dac_drdata[64:60]),
    .delay_clk (delay_clk),
    .delay_rst (delay_rst),
    .delay_locked ());

  // transmit clock interface, oddr -> obuf
  PLLE2_BASE #(
    .BANDWIDTH("OPTIMIZED"), // OPTIMIZED, HIGH, LOW
    .CLKFBOUT_MULT(15), // Multiply value for all CLKOUT, (2-64)
    .CLKFBOUT_PHASE(0.0), // Phase offset in degrees of CLKFB, (-360.000-360.000).
    .CLKIN1_PERIOD(10.0), // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
    // CLKOUT0_DIVIDE - CLKOUT5_DIVIDE: Divide amount for each CLKOUT (1-128)
    .CLKOUT0_DIVIDE(20),
    .CLKOUT1_DIVIDE(20),
    .CLKOUT2_DIVIDE(1),
    .CLKOUT3_DIVIDE(1),
    .CLKOUT4_DIVIDE(1),
    .CLKOUT5_DIVIDE(1),
    // CLKOUT0_DUTY_CYCLE - CLKOUT5_DUTY_CYCLE: Duty cycle for each CLKOUT (0.001-0.999).
    .CLKOUT0_DUTY_CYCLE(0.5),
    .CLKOUT1_DUTY_CYCLE(0.5),
    .CLKOUT2_DUTY_CYCLE(0.5),
    .CLKOUT3_DUTY_CYCLE(0.5),
    .CLKOUT4_DUTY_CYCLE(0.5),
    .CLKOUT5_DUTY_CYCLE(0.5),
    // CLKOUT0_PHASE - CLKOUT5_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
    .CLKOUT0_PHASE(90.0),
    .CLKOUT1_PHASE(0.0),
    .CLKOUT2_PHASE(0.0),
    .CLKOUT3_PHASE(0.0),
    .CLKOUT4_PHASE(0.0),
    .CLKOUT5_PHASE(0.0),
    .DIVCLK_DIVIDE(1), // Master division value, (1-56)
    .REF_JITTER1(0.0), // Reference input jitter in UI, (0.000-0.999).
    .STARTUP_WAIT("FALSE") // Delay DONE until PLL Locks, ("TRUE"/"FALSE")
    )
    PLLE2_BASE_inst (
    // Clock Outputs: 1-bit (each) output: User configurable clock outputs
    .CLKOUT0(tx_clk_pll), // 1-bit output: CLKOUT0
    .CLKOUT1(dac_clk), // 1-bit output: CLKOUT1
    .CLKOUT2(), // 1-bit output: CLKOUT2
    .CLKOUT3(), // 1-bit output: CLKOUT3
    .CLKOUT4(), // 1-bit output: CLKOUT4
    .CLKOUT5(), // 1-bit output: CLKOUT5
    // Feedback Clocks: 1-bit (each) output: Clock feedback ports
    .CLKFBOUT(feedback_clk), // 1-bit output: Feedback clock
    .LOCKED(), // 1-bit output: LOCK
    .CLKIN1(l_clk), // 1-bit input: Input clock
    // Control Ports: 1-bit (each) input: PLL control ports
    .PWRDWN(1'b0), // 1-bit input: Power-down
    .RST(rst), // 1-bit input: Reset
    // Feedback Clocks: 1-bit (each) input: Clock feedback ports
    .CLKFBIN(feedback_clk) // 1-bit input: Feedback clock
    );

  ODDR #(
    .DDR_CLK_EDGE ("SAME_EDGE"),
    .INIT (1'b0),
    .SRTYPE ("ASYNC"))
  i_tx_clk_oddr(
    .CE (1'b1),
    .R (1'b0),
    .S (1'b0),
    .C (tx_clk_pll),
    .D1 (1'b1),
    .D2 (1'b0),
    .Q (tx_clk));

endmodule

// ***************************************************************************
// ***************************************************************************
