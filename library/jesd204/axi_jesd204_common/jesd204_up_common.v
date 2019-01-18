//
// The ADI JESD204 Core is released under the following license, which is
// different than all other HDL cores in this repository.
//
// Please read this, and understand the freedoms and responsibilities you have
// by using this source code/core.
//
// The JESD204 HDL, is copyright © 2016-2017 Analog Devices Inc.
//
// This core is free software, you can use run, copy, study, change, ask
// questions about and improve this core. Distribution of source, or resulting
// binaries (including those inside an FPGA or ASIC) require you to release the
// source of the entire project (excluding the system libraries provide by the
// tools/compiler/FPGA vendor). These are the terms of the GNU General Public
// License version 2 as published by the Free Software Foundation.
//
// This core  is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License version 2
// along with this source code, and binary.  If not, see
// <http://www.gnu.org/licenses/>.
//
// Commercial licenses (with commercial support) of this JESD204 core are also
// available under terms different than the General Public License. (e.g. they
// do not require you to accompany any image (FPGA or ASIC) using the JESD204
// core with any corresponding source code.) For these alternate terms you must
// purchase a license from Analog Devices Technology Licensing Office. Users
// interested in such a license should contact jesd204-licensing@analog.com for
// more information. This commercial license is sub-licensable (if you purchase
// chips from Analog Devices, incorporate them into your PCB level product, and
// purchase a JESD204 license, end users of your product will also have a
// license to use this core in a commercial setting without releasing their
// source code).
//
// In addition, we kindly ask you to acknowledge ADI in any program, application
// or publication in which you use this JESD204 HDL core. (You are not required
// to do so; it is up to your common sense to decide whether you want to comply
// with this request or not.) For general publications, we suggest referencing :
// “The design and implementation of the JESD204 HDL Core used in this project
// is copyright © 2016-2017, Analog Devices, Inc.”
//

`timescale 1ns/100ps

module jesd204_up_common # (
  parameter PCORE_VERSION = 0,
  parameter PCORE_MAGIC = 0,
  parameter ID = 0,
  parameter NUM_LANES = 1,
  parameter NUM_LINKS = 1,
  parameter DATA_PATH_WIDTH = 2,
  parameter MAX_OCTETS_PER_FRAME = 256,
  parameter NUM_IRQS = 1,
  parameter EXTRA_CFG_WIDTH = 1
) (
  input up_clk,
  input ext_resetn,

  output up_reset,

  output up_reset_synchronizer,

  input core_clk,
  input core_reset_ext,
  output core_reset,

  input [11:0] up_raddr,
  output reg [31:0] up_rdata,

  input up_wreq,
  input [11:0] up_waddr,
  input [31:0] up_wdata,

  input [EXTRA_CFG_WIDTH-1:0] up_extra_cfg,

  input [NUM_IRQS-1:0] up_irq_trigger,
  output reg irq,

  output up_cfg_is_writeable,

  output reg [NUM_LANES-1:0] core_cfg_lanes_disable,
  output reg [NUM_LINKS-1:0] core_cfg_links_disable,
  output reg [7:0] core_cfg_beats_per_multiframe,
  output reg [7:0] core_cfg_octets_per_frame,
  output reg core_cfg_disable_scrambler,
  output reg core_cfg_disable_char_replacement,
  output reg [EXTRA_CFG_WIDTH-1:0] core_extra_cfg
);

localparam MAX_BEATS_PER_MULTIFRAME = (MAX_OCTETS_PER_FRAME * 32) / DATA_PATH_WIDTH;

reg [31:0] up_scratch = 32'h00000000;

reg [7:0] up_cfg_octets_per_frame = 'h00;
reg [9-DATA_PATH_WIDTH:0] up_cfg_beats_per_multiframe = 'h00;
reg [NUM_LANES-1:0] up_cfg_lanes_disable = {NUM_LANES{1'b0}};
reg [NUM_LINKS-1:0] up_cfg_links_disable = {NUM_LINKS{1'b0}};
reg up_cfg_disable_char_replacement = 1'b0;
reg up_cfg_disable_scrambler = 1'b0;

/* Reset for the register map */
reg [2:0] up_reset_vector = 3'b111;
assign up_reset = up_reset_vector[0];

/* Reset signal generation for the JESD core */
reg [4:0] core_reset_vector = 5'b11111;
assign core_reset = core_reset_vector[0];

/* Transfer the reset signal back to the up domain, used to keep the
 * synchronizers in reset until the core is ready. This is done in order to
 * prevent bogus data to propagate to the register map. */
reg [1:0] up_reset_synchronizer_vector = 2'b11;
assign up_reset_synchronizer = up_reset_synchronizer_vector[0];

/*
 * Synchronize the external core reset to the register map domain so the status
 * can be shown in the register map. This is useful for debugging.
 */
reg [1:0] up_core_reset_ext_synchronizer_vector = 2'b11;
wire up_core_reset_ext;

assign up_core_reset_ext = up_core_reset_ext_synchronizer_vector[0];

/* Transfer two cycles before the core comes out of reset */
wire core_cfg_transfer_en;
assign core_cfg_transfer_en = core_reset_vector[2] ^ core_reset_vector[1];

reg up_reset_core = 1'b1;

assign up_cfg_is_writeable = up_reset_core;

always @(posedge up_clk or negedge ext_resetn) begin
  if (ext_resetn == 1'b0) begin
    up_reset_vector <= 3'b111;
  end else begin
    up_reset_vector <= {1'b0,up_reset_vector[2:1]};
  end
end

wire core_reset_all = up_reset_core | core_reset_ext;

always @(posedge core_clk or posedge core_reset_all) begin
  if (core_reset_all == 1'b1) begin
    core_reset_vector <= 5'b11111;
  end else begin
    core_reset_vector <= {1'b0,core_reset_vector[4:1]};
  end
end

always @(posedge up_clk or posedge core_reset) begin
  if (core_reset == 1'b1) begin
    up_reset_synchronizer_vector <= 2'b11;
  end else begin
    up_reset_synchronizer_vector <= {1'b0,up_reset_synchronizer_vector[1]};
  end
end

always @(posedge up_clk or posedge core_reset_ext) begin
  if (core_reset_ext == 1'b1) begin
    up_core_reset_ext_synchronizer_vector <= 2'b11;
  end else begin
    up_core_reset_ext_synchronizer_vector <= {1'b0,up_core_reset_ext_synchronizer_vector[1]};
  end
end

always @(posedge core_clk) begin
  if (core_cfg_transfer_en == 1'b1) begin
    core_cfg_beats_per_multiframe <= up_cfg_beats_per_multiframe;
    core_cfg_octets_per_frame <= up_cfg_octets_per_frame;
    core_cfg_lanes_disable <= up_cfg_lanes_disable;
    core_cfg_links_disable <= up_cfg_links_disable;
    core_cfg_disable_scrambler <= up_cfg_disable_scrambler;
    core_cfg_disable_char_replacement <= up_cfg_disable_char_replacement;
    core_extra_cfg <= up_extra_cfg;
  end
end

/* Interupt handling */
reg [NUM_IRQS-1:0] up_irq_enable = {NUM_IRQS{1'b0}};
reg [NUM_IRQS-1:0] up_irq_source = 'h00;
reg [NUM_IRQS-1:0] up_irq_clear;
wire [NUM_IRQS-1:0] up_irq_pending;

assign up_irq_pending = up_irq_source & up_irq_enable;

always @(posedge up_clk) begin
  if (up_reset == 1'b1) begin
    irq <= 1'b0;
  end else begin
    irq <= |up_irq_pending;
  end
end

always @(posedge up_clk) begin
  if (up_reset == 1'b1) begin
    up_irq_source <= 'h00;
  end else begin
    up_irq_source <= (up_irq_source & ~up_irq_clear) | up_irq_trigger;
  end
end


wire [20:0] clk_mon_count;

always @(*) begin
  case (up_raddr)
  /* Standard registers */
  12'h000: up_rdata <= PCORE_VERSION;
  12'h001: up_rdata <= ID;
  12'h002: up_rdata <= up_scratch;
  12'h003: up_rdata <= PCORE_MAGIC;

  /* Core configuration */
  12'h004: up_rdata <= NUM_LANES;
  12'h005: up_rdata <= DATA_PATH_WIDTH;
  12'h006: up_rdata <= {24'b0, NUM_LINKS[7:0]};
  /* 0x07-0x0f reserved for future use */
  /* 0x10-0x1f reserved for core specific HDL configuration information */

  /* IRQ block */
  12'h020: up_rdata <= up_irq_enable;
  12'h021: up_rdata <= up_irq_pending;
  12'h022: up_rdata <= up_irq_source;
  /* 0x23-0x30 reserved for future use */

  /* JESD common control */
  12'h030: up_rdata <= up_reset_core;
  12'h031: up_rdata <= {up_core_reset_ext, up_reset_synchronizer}; /* core ready */
  12'h032: up_rdata <= {11'h00, clk_mon_count}; /* Make it 16.16 */
  /* 0x32-0x34 reserver for future use */

  12'h080: up_rdata <= up_cfg_lanes_disable;
  /* 0x82-0x83 reserved for future lane disable bits (max 128 lanes) */
  12'h084: up_rdata <= {
    /* 24-31 */ 8'h00, /* Reserved for future extensions of octets_per_frame */
    /* 16-23 */ up_cfg_octets_per_frame,
    /* 10-15 */ 6'b000000, /* Reserved for future extensions of beats_per_multiframe */
    /* 00-09 */ up_cfg_beats_per_multiframe,{DATA_PATH_WIDTH{1'b1}}
  };
  12'h85: up_rdata <= {
    /* 02-31 */ 30'h00, /* Reserved for future additions */
    /*    01 */ up_cfg_disable_char_replacement, /* Disable character replacement */
    /*    00 */ up_cfg_disable_scrambler /* Disable scrambler */
  };
  12'h086: up_rdata <= up_cfg_links_disable;
  /* 0x87-0x8f reserved for future use */

  /* 0x90-0x9f reserved for core specific configuration options */

  default: up_rdata <= 'h00;
  endcase
end

/* IRQ pending register is write-1-to-clear */
always @(*) begin
  if (up_wreq == 1'b1 && up_waddr == 12'h21) begin
    up_irq_clear <= up_wdata[NUM_IRQS-1:0];
  end else begin
    up_irq_clear <= {NUM_IRQS{1'b0}};
  end
end

always @(posedge up_clk) begin
  if (up_reset == 1'b1) begin
    up_scratch <= 'h00;
    up_irq_enable <= {NUM_IRQS{1'b0}};
    up_reset_core <= 1'b1;

    up_cfg_octets_per_frame <= 'h00;
    up_cfg_beats_per_multiframe <= 'h00;
    up_cfg_lanes_disable <= {NUM_LANES{1'b0}};
    up_cfg_links_disable <= {NUM_LINKS{1'b0}};

    up_cfg_disable_char_replacement <= 1'b0;
    up_cfg_disable_scrambler <= 1'b0;
  end else if (up_wreq == 1'b1) begin
    case (up_waddr)
    /* Standard registers */
    12'h002: up_scratch <= up_wdata;

    /* IRQ block */
    12'h020: up_irq_enable <= up_wdata[NUM_IRQS-1:0];

    /* JESD common control */
    12'h030: up_reset_core <= up_wdata[0];

    endcase

    /*
     * The configuration needs to be static while the core is
     * active. To enforce this writes to configuration registers
     * will be ignored while the core is out of reset.
     */
    if (up_cfg_is_writeable == 1'b1) begin
      case (up_waddr)
      12'h080: begin
        up_cfg_lanes_disable <= up_wdata[NUM_LANES-1:0];
      end
      12'h084: begin
        up_cfg_octets_per_frame <= up_wdata[23:16];
        up_cfg_beats_per_multiframe <= up_wdata[9:DATA_PATH_WIDTH];
      end
      12'h085: begin
        up_cfg_disable_char_replacement <= up_wdata[1];
        up_cfg_disable_scrambler <= up_wdata[0];
      end
      12'h086: begin
        up_cfg_links_disable <= up_wdata[NUM_LINKS-1:0];
      end
      endcase
    end
  end
end

up_clock_mon #(
  .TOTAL_WIDTH(21)
) i_clock_mon (
  .up_rstn(~up_reset),
  .up_clk(up_clk),
  .up_d_count(clk_mon_count),
  .d_rst(1'b0),
  .d_clk(core_clk)
);

endmodule
