//////////////////////////////////////////////////////////////////////////////////
// Company:     Analog Devices, Inc.
// Author:      MBB
// SystemVerilog interface definition for AMBA AXI4-Lite bus
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ns
interface axi4_lite #(
   DATA_WIDTH = 32,
   ADDR_WIDTH = 32
);

   localparam WSTRB_WIDTH = DATA_WIDTH/8;

   // Write address channel
   logic                   awvalid;
   logic                   awready;
   logic [2:0]             awprot;
   logic [ADDR_WIDTH-1:0]  awaddr;
   
   // Write data channel
   logic                   wvalid;
   logic                   wready;
   logic [WSTRB_WIDTH-1:0] wstrb;
   logic [DATA_WIDTH-1:0]  wdata;
   
   // Write response channel
   logic                   bvalid;
   logic                   bready;
   logic [1:0]             bresp;
   
   // Read address channel
   logic                   arvalid;
   logic                   arready;
   logic [2:0]             arprot;
   logic [ADDR_WIDTH-1:0]  araddr;
   
   // Read response channel
   logic                   rvalid;
   logic                   rready;
   logic [1:0]             rresp;
   logic [DATA_WIDTH-1:0]  rdata;
   
   modport master (
      output awvalid, awprot, awaddr, wvalid, wstrb, wdata, bready, arvalid, arprot, araddr, rready,
      input awready, wready, bvalid, bresp, arready, rvalid, rresp, rdata
   );
   
   modport slave (
      output awready, wready, bvalid, bresp, arready, rvalid, rresp, rdata,
      input awvalid, awprot, awaddr, wvalid, wstrb, wdata, bready, arvalid, arprot, araddr, rready
   );
   
endinterface
