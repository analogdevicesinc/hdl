

module dmac_dma_read_tb;
  parameter VCD_FILE = "dma_read_tb.vcd";

  `include "tb_base.v"

  localparam TRANSFER_ADDR = 32'h80000000;
  localparam TRANSFER_LEN = 24'h203;

  reg req_valid = 1'b1;
  wire req_ready;
  reg [23:0] req_length = 'h03;

  wire awvalid;
  wire awready;
  wire [31:0] araddr;
  wire [7:0] arlen;
  wire [2:0] arsize;
  wire [1:0] arburst;
  wire [2:0] arprot;
  wire [3:0] arcache;

  wire rlast;
  wire rvalid;
  wire rready;
  wire [1:0] rresp;
  wire [31:0] rdata;

  always @(posedge clk) begin
    if (reset != 1'b1 && req_ready == 1'b1) begin
      req_valid <= 1'b1;
      req_length <= req_length + 4;
    end
  end

  axi_read_slave #(
    .DATA_WIDTH(32)
  ) i_write_slave (
    .clk(clk),
    .reset(reset),

    .arvalid(arvalid),
    .arready(arready),
    .araddr(araddr),
    .arlen(arlen),
    .arsize(arsize),
    .arburst(arburst),
    .arprot(arprot),
    .arcache(arcache),

    .rready(rready),
    .rvalid(rvalid),
    .rdata(rdata),
    .rresp(rresp),
    .rlast(rlast)
  );

  wire fifo_rd_en = 1'b1;
  wire fifo_rd_valid;
  wire fifo_rd_underflow;
  wire [31:0] fifo_rd_dout;
  reg [31:0] fifo_rd_dout_cmp = TRANSFER_ADDR;
  reg fifo_rd_dout_mismatch = 1'b0;
  reg [31:0] fifo_rd_dout_limit = 'h0;

  dmac_request_arb #(
    .DMA_TYPE_SRC(0),
    .DMA_TYPE_DEST(2),
    .DMA_DATA_WIDTH_SRC(32),
    .DMA_DATA_WIDTH_DEST(32),
    .FIFO_SIZE(8)
  ) request_arb (
    .m_src_axi_aclk (clk),
    .m_src_axi_aresetn(resetn),

    .m_axi_arvalid(arvalid),
    .m_axi_arready(arready),
    .m_axi_araddr(araddr),
    .m_axi_arlen(arlen),
    .m_axi_arsize(arsize),
    .m_axi_arburst(arburst),
    .m_axi_arprot(arprot),
    .m_axi_arcache(arcache),

    .m_axi_rready(rready),
    .m_axi_rvalid(rvalid),
    .m_axi_rdata(rdata),
    .m_axi_rresp(rresp),

    .req_aclk(clk),
    .req_aresetn(resetn),

    .enable(1'b1),
    .pause(1'b0),

    .eot(eot),

    .req_valid(req_valid),
    .req_ready(req_ready),
    .req_dest_address(TRANSFER_ADDR[31:2]),
    .req_src_address(TRANSFER_ADDR[31:2]),
    .req_length(req_length),
    .req_sync_transfer_start(1'b0),

    .fifo_rd_clk(clk),
    .fifo_rd_en(fifo_rd_en),
    .fifo_rd_valid(fifo_rd_valid),
    .fifo_rd_underflow(fifo_rd_underflow),
    .fifo_rd_dout(fifo_rd_dout)
  );

  always @(posedge clk) begin
    if (reset == 1'b1) begin
      fifo_rd_dout_cmp <= TRANSFER_ADDR;
      fifo_rd_dout_mismatch <= 1'b0;
    end else begin
      fifo_rd_dout_mismatch <= 1'b0;

      if (fifo_rd_valid == 1'b1) begin
        if (fifo_rd_dout_cmp < TRANSFER_ADDR + fifo_rd_dout_limit) begin
          fifo_rd_dout_cmp <= (fifo_rd_dout_cmp + 'h4);
        end else begin
          fifo_rd_dout_cmp <= TRANSFER_ADDR;
          fifo_rd_dout_limit <= fifo_rd_dout_limit + 'h4;
        end
        if (fifo_rd_dout_cmp != fifo_rd_dout) begin
          fifo_rd_dout_mismatch <= 1'b1;
        end
      end
    end
  end

  always @(posedge clk) begin
    failed <= failed | fifo_rd_dout_mismatch;
  end

endmodule
