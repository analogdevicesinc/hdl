module dma_interceptor (
  input           axis_aclk,
  input           reset,

  input           enable,

  output          adc_dma_sync,

(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TVALID" *)
  input           s_axis_valid,
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TLAST" *)
  input           s_axis_last,
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TDATA" *)
  input [63:0]    s_axis_data,
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TREADY" *)
  output          s_axis_ready,

(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TVALID" *)
  output          m_axis_valid,
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TREADY" *)
  input           m_axis_ready,
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TDATA" *)
  output [63:0]   m_axis_data,

  input           tdd_active
  );

  assign m_axis_valid = s_axis_valid;
  assign m_axis_data = s_axis_data;

  reg running = 1'b0;
  
  reg enable_d_0;
  reg enable_d_1;
  reg enable_d_2;
  
  /* Enable synchronization stage - this signal might originate from a GPIO or
  * other source which is not running on the current clock domain. Additionally,
  * this signal is not timing critical, and is usually only set once, depending
  * on the current application. */
  always @(posedge axis_aclk)
  begin
    if (reset) begin
      enable_d_0 <= 'b0;
      enable_d_1 <= 'b0;
      enable_d_2 <= 'b0;
    end else begin
      enable_d_0 <= enable;
      enable_d_1 <= enable_d_0;
      enable_d_2 <= enable_d_1;
    end
  end
  
  reg [3:0] tdd_active_d;
  
  always @(posedge axis_aclk)
  begin
    if (reset) begin
      tdd_active_d <= 'b0;
    end else begin
      tdd_active_d[0] <= tdd_active;
      tdd_active_d[3:1] <= tdd_active_d[2:0];
    end
  end
  
  assign adc_dma_sync = (!enable_d_2) | (tdd_active & !tdd_active_d[3]);
  
  always @(posedge axis_aclk)
  begin
    if (reset) begin
      running <= 'b0;
    end else begin
      if (!running) begin
        running <= tdd_active;
      end else begin
        if (s_axis_valid & s_axis_ready) begin
          running <= !s_axis_last;
        end
      end
    end
  end
  
  assign s_axis_ready = m_axis_ready & (!enable_d_2 | running);

endmodule
