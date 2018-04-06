

module dmac_dma_write_tb;
  parameter VCD_FILE = "dma_write_tb.vcd";

  `include "tb_base.v"

  reg req_valid = 1'b1;
  wire req_ready;
  reg [23:0] req_length = 'h03;
  wire awvalid;
  wire awready;
  wire [31:0] awaddr;
  wire [7:0] awlen;
  wire [2:0] awsize;
  wire [1:0] awburst;
  wire [2:0] awprot;
  wire [3:0] awcache;

  wire wlast;
  wire wvalid;
  wire wready;
  wire [3:0] wstrb;
  wire [31:0] wdata;

  reg [31:0] fifo_wr_din = 'b0;
  reg fifo_wr_rq = 'b0;
  wire fifo_wr_xfer_req;

  wire bready;
  wire bvalid;
  wire [1:0] bresp;

  always @(posedge clk) begin
    if (reset != 1'b1 && req_ready == 1'b1) begin
      req_valid <= 1'b1;
      req_length <= req_length + 'h4;
    end
  end

  axi_write_slave #(
    .DATA_WIDTH(32)
  ) i_write_slave (
    .clk(clk),
    .reset(reset),

    .awvalid(awvalid),
    .awready(awready),
    .awaddr(awaddr),
    .awlen(awlen),
    .awsize(awsize),
    .awburst(awburst),
    .awprot(awprot),
    .awcache(awcache),

    .wready(wready),
    .wvalid(wvalid),
    .wdata(wdata),
    .wstrb(wstrb),
    .wlast(wlast),

    .bvalid(bvalid),
    .bready(bready),
    .bresp(bresp)
  );

  dmac_request_arb #(
    .DMA_DATA_WIDTH_SRC(32),
    .DMA_DATA_WIDTH_DEST(32)
  ) request_arb (
    .m_dest_axi_aclk (clk),
    .m_dest_axi_aresetn(resetn),

    .m_axi_awvalid(awvalid),
    .m_axi_awready(awready),
    .m_axi_awaddr(awaddr),
    .m_axi_awlen(awlen),
    .m_axi_awsize(awsize),
    .m_axi_awburst(awburst),
    .m_axi_awprot(awprot),
    .m_axi_awcache(awcache),

    .m_axi_wready(wready),
    .m_axi_wvalid(wvalid),
    .m_axi_wdata(wdata),
    .m_axi_wstrb(wstrb),
    .m_axi_wlast(wlast),

    .m_axi_bvalid(bvalid),
    .m_axi_bready(bready),
    .m_axi_bresp(bresp),

    .req_aclk(clk),
    .req_aresetn(resetn),

    .enable(1'b1),
    .pause(1'b0),

    .eot(eot),

    .req_valid(req_valid),
    .req_ready(req_ready),
    .req_dest_address(30'h7e09000),
    .req_length(req_length),
    .req_sync_transfer_start(1'b0),

    .fifo_wr_clk(clk),
    .fifo_wr_en(fifo_wr_en),
    .fifo_wr_din(fifo_wr_din),
    .fifo_wr_overflow(fifo_wr_overflow),
    .fifo_wr_sync(1'b1),
    .fifo_wr_xfer_req(fifo_wr_xfer_req)
  );

  always @(posedge clk) begin
    if (reset) begin
      fifo_wr_din <= 'b0;
      fifo_wr_rq <= 'b0;
    end else begin
      if (fifo_wr_en) begin
        fifo_wr_din <= fifo_wr_din + 'h4;
      end
      fifo_wr_rq <= (($random % 4) == 0);
    end
  end

  assign fifo_wr_en = fifo_wr_rq & fifo_wr_xfer_req;

  always @(posedge clk) begin
    if (reset) begin
      failed <= 'b0;
    end else begin
      failed <= failed |
                i_write_slave.failed |
                fifo_wr_overflow;
    end
  end

endmodule
