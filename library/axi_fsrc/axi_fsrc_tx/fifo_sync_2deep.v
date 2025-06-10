`timescale 1ns/1ns

module fifo_sync_2deep #(
  parameter DWIDTH  = 8,
  parameter DORESET = 1'b1,
  parameter REGISTER_INTERFACE = 1'b0
) (
  input   wire              aclk,
  input   wire              aresetn,

  input   wire              m_tready,
  output  wire [DWIDTH-1:0] m_tdata,
  output  wire              m_tvalid,
  output  wire              m_tvalid_next,

  output  wire              s_tready,
  output  wire              s_tready_next,
  input   wire [DWIDTH-1:0] s_tdata,
  input   wire              s_tvalid,

  output  reg  [1:0]        cnt
);

  reg               wptr;
  reg               rptr;
  wire              fifo_we;
  wire              fifo_re;
  reg [DWIDTH-1:0]  data[1:0];

  assign  fifo_we   = s_tvalid & s_tready;
  assign  fifo_re   = m_tvalid & m_tready;

  assign s_tready_next = !(|cnt) || fifo_re || (!cnt[1] && !fifo_we);
  assign m_tvalid_next = cnt[1] || fifo_we || (cnt[0] && !fifo_re);

  if(!REGISTER_INTERFACE) begin : no_reg_gen
    assign  s_tready  = ~cnt[1];
    assign  m_tvalid  = |cnt;
    assign  m_tdata   = data[rptr];
  end else begin : reg_gen
    reg               s_tready_r;
    reg               m_tvalid_r;
    reg [DWIDTH-1:0]  dout;

    always @(posedge aclk) begin
      if(~aresetn) begin
        s_tready_r <= 1'b0;
        m_tvalid_r <= 1'b0;
      end else begin
        s_tready_r <= s_tready_next;
        m_tvalid_r <= m_tvalid_next;
      end
    end

    always @(posedge aclk) begin
      if (~aresetn & DORESET) begin
        dout <= {DWIDTH{1'b0}};
      end else begin
        if((cnt == 2'b00) && fifo_we) begin
          dout <= s_tdata;
        end else if(fifo_re) begin
          if(cnt == 2'b01) begin
            dout <= s_tdata;
          end else begin
            dout <= data[~rptr];
          end
        end
      end
    end

    assign s_tready = s_tready_r;
    assign m_tvalid = m_tvalid_r;
    assign m_tdata  = dout;
  end

  always @(posedge aclk) begin
    if(~aresetn) begin
      cnt <= 2'd0;
    end else begin
      case({fifo_we,fifo_re})
      2'b01   : cnt <= cnt - 1;
      2'b10   : cnt <= cnt + 1;
      default : cnt <= cnt;
      endcase
    end
  end

  always @(posedge aclk) wptr <= ~aresetn ? 1'b0 : fifo_we ? ~wptr : wptr;
  always @(posedge aclk) rptr <= ~aresetn ? 1'b0 : fifo_re ? ~rptr : rptr;

  always @(posedge aclk) begin
    if (~aresetn & DORESET) begin
      data[0] <= {DWIDTH{1'b0}};
      data[1] <= {DWIDTH{1'b0}};
    end else begin
      if(fifo_we) begin
        data[wptr] <= s_tdata;
      end
    end
  end

endmodule
