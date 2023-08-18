// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2017-2019, 2021, 2022 Analog Devices, Inc. All rights reserved.
// SPDX short identifier: ADIJESD204
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_jesd204_tx_regmap_tb;
  parameter VCD_FILE = "axi_jesd204_tx_regmap_tb.vcd";
  parameter NUM_LANES = 2;
  parameter NUM_LINKS = 2;

  `define TIMEOUT 1000000
  `include "tb_base.v"

  reg [1:0] core_status_state = 2'b00;
  reg [NUM_LINKS-1:0] core_status_sync = {NUM_LINKS{1'b0}};

  wire s_axi_aclk = clk;
  wire s_axi_aresetn = ~reset;

  reg s_axi_awvalid = 1'b0;
  reg s_axi_wvalid = 1'b0;
  reg [13:0] s_axi_awaddr = 'h00;
  reg [31:0] s_axi_wdata = 'h00;
  wire [1:0] s_axi_bresp;
  wire s_axi_awready;
  wire s_axi_wready;
  wire s_axi_bready = 1'b1;
  wire [3:0] s_axi_wstrb = 4'b1111;
  wire [2:0] s_axi_awprot = 3'b000;
  wire [2:0] s_axi_arprot = 3'b000;
  wire [1:0] s_axi_rresp;
  wire [31:0] s_axi_rdata;

  reg [31:0] expected_reg_mem[0:1023];

  task write_reg;
  input [31:0] addr;
  input [31:0] value;
  begin
    @(posedge s_axi_aclk)
    s_axi_awvalid <= 1'b1;
    s_axi_wvalid <= 1'b1;
    s_axi_awaddr <= addr;
    s_axi_wdata <= value;
    @(posedge s_axi_aclk)
    while (s_axi_awvalid || s_axi_wvalid) begin
      @(posedge s_axi_aclk)
      if (s_axi_awready)
        s_axi_awvalid <= 1'b0;
      if (s_axi_wready)
        s_axi_wvalid <= 1'b0;
    end
  end
  endtask

  reg [13:0] s_axi_araddr = 'h0;
  reg s_axi_arvalid = 'h0;
  reg s_axi_rready = 'h0;
  wire s_axi_arready;
  wire s_axi_rvalid;

  task read_reg;
  input [31:0] addr;
  output [31:0] value;
  begin
    s_axi_arvalid <= 1'b1;
    s_axi_araddr <= addr;
    s_axi_rready <= 1'b1;
    @(posedge s_axi_aclk) #0;
    while (s_axi_arvalid) begin
      if (s_axi_arready == 1'b1) begin
        s_axi_arvalid <= 1'b0;
      end
      @(posedge s_axi_aclk) #0;
    end

    while (s_axi_rready) begin
      if (s_axi_rvalid == 1'b1) begin
        value <= s_axi_rdata;
        s_axi_rready <= 1'b0;
      end
      @(posedge s_axi_aclk) #0;
    end
  end
  endtask

  task read_reg_check;
  input [31:0] addr;
  output match;
  reg [31:0] value;
  reg [31:0] expected;
  begin
    read_reg(addr, value);
    expected = expected_reg_mem[addr[13:2]];
    match <= value === expected;
    if (value !== expected) begin
      $display("Address %h, Expected %h, Found %h", addr, expected, value);
    end
  end
  endtask

  reg read_match = 1'b1;

  always @(posedge clk) begin
    if (read_match == 1'b0) begin
      failed <= 1'b1;
    end
  end

  task set_reset_reg_value;
  input [31:0] addr;
  input [31:0] value;
  begin
    expected_reg_mem[addr[13:2]] <= value;
  end
  endtask

  task initialize_expected_reg_mem;
  integer i;
  begin
    for (i = 0; i < 1024; i = i + 1)
      expected_reg_mem[i] <= 'h00;
    /* Non zero power-on-reset values */
    set_reset_reg_value('h00, 32'h00010661); /* PCORE version register */
    set_reset_reg_value('h0c, 32'h32303454); /* PCORE magic register */
    set_reset_reg_value('h10, NUM_LANES); /* Number of lanes */
    set_reset_reg_value('h14, 'h2); /* Datapath width */
    set_reset_reg_value('h18, NUM_LINKS); /* Number of links */
    set_reset_reg_value('hc0, 'h1); /* Link disable */
    set_reset_reg_value('hc4, 'h1); /* Core state */
//    set_reset_reg_value('hc8, 'h80000); /* clock monitor */
    set_reset_reg_value('h210, 'h3); /* OCTETS_PER_MULTIFRAME */

    set_reset_reg_value('h244, 'h3); /* MFRAMES_PER_ILAS */
  end
  endtask

  task check_all_registers;
  integer i;
  begin
    for (i = 0; i < 'h400; i = i + 4) begin
      read_reg_check(i, read_match);
    end
  end
  endtask

  task write_reg_and_update;
  input [31:0] addr;
  input [31:0] value;
  integer i;
  begin
    write_reg(addr, value);
    expected_reg_mem[addr[13:2]] <= value;

    /* Special case for ILAS */
    if (addr >= 'h310 && addr < 'h310 + 32 * NUM_LANES) begin
      for (i = 0; i < NUM_LANES; i = i + 1) begin
        case (addr[3:2])
        2'b01: expected_reg_mem['h310/4 + i * 8 + 1][31:5] <= value[31:5];
        2'b11: expected_reg_mem['h310/4 + i * 8 + 3][23:0] <= value[23:0];
        default: expected_reg_mem['h310/4 + i * 8 + addr[3:2]] <= value;
        endcase
      end
    end

    if (addr == 'hc0) begin
      expected_reg_mem['hc4/4][0] <= value[0];
    end
  end
  endtask

  task invert_register;
  input [31:0] addr;
  reg [31:0] value;
  begin
    read_reg(addr, value);
    write_reg(addr, ~value);
  end
  endtask

  task invert_all_registers;
  integer i;
  begin
    for (i = 0; i < 'h400; i = i + 4) begin
      invert_register(i);
    end
  end
  endtask

  integer i;
  initial begin
    initialize_expected_reg_mem();
    @(posedge s_axi_aresetn)
    check_all_registers();

    /* Check scratch */
    write_reg_and_update('h08, 32'h12345678);
    check_all_registers();

    /* Check IRQ mask */
    write_reg_and_update('h80, 32'h0);
    check_all_registers();

    /* Check lanes disable */
    write_reg_and_update('h200, {NUM_LANES{1'b1}});
    check_all_registers();

    /* Check JESD common config */
    write_reg_and_update('h210, 32'hff03ff);
    check_all_registers();
    write_reg_and_update('h214, 32'h03);
    check_all_registers();

    /* Check links disable */
    write_reg_and_update('h218, {NUM_LINKS{1'b1}});
    check_all_registers();

    /* Check JESD TX configuration */
    write_reg_and_update('h240, 32'h07);
    check_all_registers();

    /* Check mframes per ILAS - RO at the moment */
    write_reg('h244, 32'hff);
    check_all_registers();

    /* Check status register */
    core_status_state = 2'b01;  /* CGS */
    set_reset_reg_value('h280, 32'h00000001);
    check_all_registers();
    core_status_state = 2'b10; /* ILAS */
    set_reset_reg_value('h280, 32'h00000002);
    check_all_registers();
    core_status_state = 2'b11; /* DATA */
    set_reset_reg_value('h280, 32'h00000003);
    check_all_registers();
    core_status_state = 2'b00; /* WAIT */
    set_reset_reg_value('h280, 32'h00000000);
    check_all_registers();

    core_status_sync = {NUM_LINKS{1'b1}}; /* SYNC deasserted */
    set_reset_reg_value('h280, ({NUM_LINKS{1'b1}} << 4));
    check_all_registers();
    core_status_sync = {NUM_LINKS{1'b0}}; /* SYNC asserted */
    set_reset_reg_value('h280, 32'h00000000);
    check_all_registers();

    /* ILAS register */
    for (i = 0; i < NUM_LANES; i = i + 1) begin
      write_reg_and_update('h310 + i * 32, 32'h0fff0000);
      write_reg_and_update('h314 + i * 32, 32'h1fff9f1f ^ i);
      write_reg_and_update('h318 + i * 32, 32'hffffdfff ^ i);
      write_reg_and_update('h31c + i * 32, 32'h0f00009f ^ (2 << 24));
    end
    check_all_registers();

    /* Reset core */
    write_reg_and_update('hc0, 32'h0);
    check_all_registers();

    /* Should be read-only when core is out of reset */
    invert_register('h200);
    invert_register('h210);
    invert_register('h214);
    invert_register('h218);
    invert_register('h240);
    invert_register('h244);
    for (i = 0; i < NUM_LANES; i = i + 1) begin
      invert_register('h310 + i * 32);
      invert_register('h314 + i * 32);
      invert_register('h318 + i * 32);
      invert_register('h31c + i * 32);
    end

    check_all_registers();

    /* Check that reset works for all registers */
    do_trigger_reset();
    initialize_expected_reg_mem();
    check_all_registers();
    invert_all_registers();
    do_trigger_reset();
    check_all_registers();
  end

  reg core_clk = 1'b0;
  always @(*) #4 core_clk <= ~core_clk;

  axi_jesd204_tx #(
    .NUM_LANES(NUM_LANES),
    .NUM_LINKS(NUM_LINKS)
  ) i_axi (
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    .s_axi_awvalid(s_axi_awvalid),
    .s_axi_awaddr(s_axi_awaddr),
    .s_axi_awready(s_axi_awready),
    .s_axi_awprot(s_axi_awprot),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(s_axi_wstrb),
    .s_axi_wready(s_axi_wready),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bresp(s_axi_bresp),
    .s_axi_bready(s_axi_bready),
    .s_axi_arvalid(s_axi_arvalid),
    .s_axi_araddr(s_axi_araddr),
    .s_axi_arready(s_axi_arready),
    .s_axi_arprot(s_axi_arprot),
    .s_axi_rvalid(s_axi_rvalid),
    .s_axi_rready(s_axi_rready),
    .s_axi_rresp(s_axi_rresp),
    .s_axi_rdata(s_axi_rdata),

    .core_clk(core_clk),
    .core_reset_ext(1'b0),

    .core_ilas_config_rd(1'b1),
    .core_ilas_config_addr(2'b00),

    .device_event_sysref_alignment_error(1'b0),
    .device_event_sysref_edge(1'b0),

    .core_status_state(core_status_state),
    .core_status_sync(core_status_sync),

    .status_synth_params0(NUM_LANES),
    .status_synth_params1(2),
    .status_synth_params2(NUM_LINKS));

endmodule
