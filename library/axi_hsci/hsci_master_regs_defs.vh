///////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
/// SPDX short identifier: ADIBSD
///////////////////////////////////////////////////////////////////////////////

`ifndef _DEFINE_SV_HSCI_MASTER_REGS
`define _DEFINE_SV_HSCI_MASTER_REGS

//
// ---- Constant Definitions ----
//
//    Module RegisterMap Constants
//        PROP_XXXX_AWIDTH     Module RegisterMap AddressWidth
//
//    Register Constants
//        RG_XXXX_ADDR        Address of the register
//        RG_XXXX_RESET       Reset value for the register
//
//    BitField defines
//        BF_XXXX_RESET       Reset value for the bitfield
//        BF_XXXX_WIDTH       Width of the bitfield
//
//    BitField register reference defines
//        BF_XXXX_LSB         LSB of the bitfield slice
//        BF_XXXX_MSB         MSB of the bitfield slice
//        BF_XXXX_ROFFSET     Offset of the slice in the register
//        BF_XXXX_RMSB        MSB of the slice in the register
//        BF_XXXX_RMASK       Mask of the slice in the register
//        BF_XXXX_RWIDTH      Width of the slice
//        BF_XXXX_RESET       Reset value of the slice
//

package hsci_master_regs_pkg;


  // ==========  Module RegisterMap constants  ==========
  parameter PROP_HSCI_MASTER_REGS_AWIDTH         = 'd16;    // Module Address Width property decimal value.

  // ==========  Register constants  ==========
  parameter RG_REVISION_ID_ADDR                  = 16'h0000;            //  Revision ID for SPI Master
  parameter RG_REVISION_ID_RESET                 = 32'h00000001;
  parameter RG_HSCI_MASTER_MODE_ADDR             = 16'h8001;            //  HSCI Master Mode Selection
  parameter RG_HSCI_MASTER_MODE_RESET            = 32'h00000010;
  parameter RG_HSCI_MASTER_XFER_NUM_ADDR         = 16'h8002;            //  HSCI Master Number of Transactions
  parameter RG_HSCI_MASTER_XFER_NUM_RESET        = 32'h00000000;
  parameter RG_HSCI_MASTER_ADDR_SIZE_ADDR        = 16'h8003;            //  HSCI Master Address Size
  parameter RG_HSCI_MASTER_ADDR_SIZE_RESET       = 32'h00000000;
  parameter RG_HSCI_MASTER_BYTE_NUM_ADDR         = 16'h8004;            //  HSCI Master Data Size
  parameter RG_HSCI_MASTER_BYTE_NUM_RESET        = 32'h00000000;
  parameter RG_HSCI_MASTER_TARGET_ADDR           = 16'h8005;            //  HSCI Master Target Chip Select
  parameter RG_HSCI_MASTER_TARGET_RESET          = 32'h00000000;
  parameter RG_HSCI_MASTER_CTRL_ADDR             = 16'h8006;            //  HSCI Master CTRL
  parameter RG_HSCI_MASTER_CTRL_RESET            = 32'h00000000;
  parameter RG_HSCI_MASTER_BRAM_ADDRESS_ADDR     = 16'h8007;            //  BRAM Sequence Start Addr
  parameter RG_HSCI_MASTER_BRAM_ADDRESS_RESET    = 32'h00000000;
  parameter RG_HSCI_MASTER_RUN_ADDR              = 16'h8008;            //  HSCI Master RUN Trigger
  parameter RG_HSCI_MASTER_RUN_RESET             = 32'h00000000;
  parameter RG_HSCI_MASTER_STATUS_ADDR           = 16'h8009;            //  HSCI Master Status
  parameter RG_HSCI_MASTER_STATUS_RESET          = 32'h00000000;
  parameter RG_HSCI_MASTER_LINKUP_CTRL_ADDR      = 16'h800A;            //  HSCI Master Linkup CTRL
  parameter RG_HSCI_MASTER_LINKUP_CTRL_RESET     = 32'h00000000;
  parameter RG_HSCI_MASTER_TEST_CTRL_ADDR        = 16'h800B;            //  HSCI Master Test CTRL
  parameter RG_HSCI_MASTER_TEST_CTRL_RESET       = 32'h00000000;
  parameter RG_HSCI_MASTER_LINKUP_STATUS_ADDR    = 16'h800C;            //  HSCI Master Linkup Status
  parameter RG_HSCI_MASTER_LINKUP_STATUS_RESET   = 32'h00000000;
  parameter RG_HSCI_MASTER_LINKUP_STATUS2_ADDR   = 16'h800D;            //  HSCI Master Linkup Status 2
  parameter RG_HSCI_MASTER_LINKUP_STATUS2_RESET  = 32'h00000000;
  parameter RG_HSCI_DEBUG_STATUS_ADDR            = 16'h800E;            //  HSCI Master FSM Status
  parameter RG_HSCI_DEBUG_STATUS_RESET           = 32'h00000000;
  parameter RG_MISO_TEST_BER_ADDR                = 16'h800F;            //  MISO Test BER
  parameter RG_MISO_TEST_BER_RESET               = 32'h00000000;
  parameter RG_HSCI_MASTER_LINK_ERR_INFO_ADDR    = 16'h8010;            //  HSCI Master Link Error Info
  parameter RG_HSCI_MASTER_LINK_ERR_INFO_RESET   = 32'h00000000;
  parameter RG_HSCI_RATE_CTRL_ADDR               = 16'h8011;            //  HSCI Rate Control
  parameter RG_HSCI_RATE_CTRL_RESET              = 32'h00000000;
  parameter RG_HSCI_MASTER_RST_ADDR              = 16'h8012;            //  HSCI Master Reset Controls
  parameter RG_HSCI_MASTER_RST_RESET             = 32'h00000000;
  parameter RG_HSCI_PHY_STATUS_ADDR              = 16'h8013;            //  HSCI PHY STATUS
  parameter RG_HSCI_PHY_STATUS_RESET             = 32'h00000000;
  parameter RG_HSCI_MASTER_SCRATCH_ADDR          = 16'h801F;            //  Scratch Register
  parameter RG_HSCI_MASTER_SCRATCH_RESET         = 32'h00000000;

  // ==========  BitFields  ==========

  // BitField: hsci_revision_id (r)
  //        bitfield defines
  parameter BF_HSCI_REVISION_ID_RESET             = 16'h1;
  parameter BF_HSCI_REVISION_ID_WIDTH             = 32'd16;
  //        register reference defines
  parameter BF_HSCI_REVISION_ID_LSB               = 32'd0;
  parameter BF_HSCI_REVISION_ID_MSB               = 32'd15;
  parameter BF_HSCI_REVISION_ID_ROFFSET           = 32'd0;
  parameter BF_HSCI_REVISION_ID_RMSB              = 32'd15;
  parameter BF_HSCI_REVISION_ID_RMASK             = 16'hffff;
  parameter BF_HSCI_REVISION_ID_RWIDTH            = 32'd16;
  typedef logic [15:0] hsci_revision_id_data_t;
  //        bitfield structures
  typedef struct packed {
    hsci_revision_id_data_t data;
  } hsci_revision_id_reg_t;

  // BitField: hsci_xfer_mode (r/w)
  //        bitfield defines
  parameter BF_HSCI_XFER_MODE_RESET               = 2'h0;
  parameter BF_HSCI_XFER_MODE_WIDTH               = 32'd2;
  //        register reference defines
  parameter BF_HSCI_XFER_MODE_LSB                 = 32'd0;
  parameter BF_HSCI_XFER_MODE_MSB                 = 32'd1;
  parameter BF_HSCI_XFER_MODE_ROFFSET             = 32'd0;
  parameter BF_HSCI_XFER_MODE_RMSB                = 32'd1;
  parameter BF_HSCI_XFER_MODE_RMASK               = 2'h3;
  parameter BF_HSCI_XFER_MODE_RWIDTH              = 32'd2;
  typedef logic [1:0] hsci_xfer_mode_data_t;
  //        bitfield structures
  typedef struct packed {
    hsci_xfer_mode_data_t data;
  } hsci_xfer_mode_reg_t;

  // BitField: ver_b__na (r/w)
  //        bitfield defines
  parameter BF_VER_B__NA_RESET                    = 1'h1;
  parameter BF_VER_B__NA_WIDTH                    = 32'd1;
  //        register reference defines
  parameter BF_VER_B__NA_LSB                      = 32'd0;
  parameter BF_VER_B__NA_MSB                      = 32'd0;
  parameter BF_VER_B__NA_ROFFSET                  = 32'd4;
  parameter BF_VER_B__NA_RMSB                     = 32'd4;
  parameter BF_VER_B__NA_RMASK                    = 5'h10;
  parameter BF_VER_B__NA_RWIDTH                   = 32'd1;
  typedef logic  ver_b__na_data_t;
  //        bitfield structures
  typedef struct packed {
    ver_b__na_data_t data;
  } ver_b__na_reg_t;

  // BitField: hsci_xfer_num (r/w)
  //        bitfield defines
  parameter BF_HSCI_XFER_NUM_RESET                = 16'h0;
  parameter BF_HSCI_XFER_NUM_WIDTH                = 32'd16;
  //        register reference defines
  parameter BF_HSCI_XFER_NUM_LSB                  = 32'd0;
  parameter BF_HSCI_XFER_NUM_MSB                  = 32'd15;
  parameter BF_HSCI_XFER_NUM_ROFFSET              = 32'd0;
  parameter BF_HSCI_XFER_NUM_RMSB                 = 32'd15;
  parameter BF_HSCI_XFER_NUM_RMASK                = 16'hffff;
  parameter BF_HSCI_XFER_NUM_RWIDTH               = 32'd16;
  typedef logic [15:0] hsci_xfer_num_data_t;
  //        bitfield structures
  typedef struct packed {
    hsci_xfer_num_data_t data;
  } hsci_xfer_num_reg_t;

  // BitField: hsci_addr_size (r/w)
  //        bitfield defines
  parameter BF_HSCI_ADDR_SIZE_RESET               = 3'h0;
  parameter BF_HSCI_ADDR_SIZE_WIDTH               = 32'd3;
  //        register reference defines
  parameter BF_HSCI_ADDR_SIZE_LSB                 = 32'd0;
  parameter BF_HSCI_ADDR_SIZE_MSB                 = 32'd2;
  parameter BF_HSCI_ADDR_SIZE_ROFFSET             = 32'd0;
  parameter BF_HSCI_ADDR_SIZE_RMSB                = 32'd2;
  parameter BF_HSCI_ADDR_SIZE_RMASK               = 3'h7;
  parameter BF_HSCI_ADDR_SIZE_RWIDTH              = 32'd3;
  typedef logic [2:0] hsci_addr_size_data_t;
  //        bitfield structures
  typedef struct packed {
    hsci_addr_size_data_t data;
  } hsci_addr_size_reg_t;

  // BitField: hsci_byte_num (r/w)
  //        bitfield defines
  parameter BF_HSCI_BYTE_NUM_RESET                = 17'h0;
  parameter BF_HSCI_BYTE_NUM_WIDTH                = 32'd17;
  //        register reference defines
  parameter BF_HSCI_BYTE_NUM_LSB                  = 32'd0;
  parameter BF_HSCI_BYTE_NUM_MSB                  = 32'd16;
  parameter BF_HSCI_BYTE_NUM_ROFFSET              = 32'd0;
  parameter BF_HSCI_BYTE_NUM_RMSB                 = 32'd16;
  parameter BF_HSCI_BYTE_NUM_RMASK                = 17'h1ffff;
  parameter BF_HSCI_BYTE_NUM_RWIDTH               = 32'd17;
  typedef logic [16:0] hsci_byte_num_data_t;
  //        bitfield structures
  typedef struct packed {
    hsci_byte_num_data_t data;
  } hsci_byte_num_reg_t;

  // BitField: spi_target (r/w)
  //        bitfield defines
  parameter BF_SPI_TARGET_RESET                   = 32'h0;
  parameter BF_SPI_TARGET_WIDTH                   = 32'd32;
  //        register reference defines
  parameter BF_SPI_TARGET_LSB                     = 32'd0;
  parameter BF_SPI_TARGET_MSB                     = 32'd31;
  parameter BF_SPI_TARGET_ROFFSET                 = 32'd0;
  parameter BF_SPI_TARGET_RMSB                    = 32'd31;
  parameter BF_SPI_TARGET_RMASK                   = 32'hffffffff;
  parameter BF_SPI_TARGET_RWIDTH                  = 32'd32;
  typedef logic [31:0] spi_target_data_t;
  //        bitfield structures
  typedef struct packed {
    spi_target_data_t data;
  } spi_target_reg_t;

  // BitField: hsci_cmd_sel (r/w)
  //        bitfield defines
  parameter BF_HSCI_CMD_SEL_RESET                 = 2'h0;
  parameter BF_HSCI_CMD_SEL_WIDTH                 = 32'd2;
  //        register reference defines
  parameter BF_HSCI_CMD_SEL_LSB                   = 32'd0;
  parameter BF_HSCI_CMD_SEL_MSB                   = 32'd1;
  parameter BF_HSCI_CMD_SEL_ROFFSET               = 32'd0;
  parameter BF_HSCI_CMD_SEL_RMSB                  = 32'd1;
  parameter BF_HSCI_CMD_SEL_RMASK                 = 2'h3;
  parameter BF_HSCI_CMD_SEL_RWIDTH                = 32'd2;
  typedef logic [1:0] hsci_cmd_sel_data_t;
  //        bitfield structures
  typedef struct packed {
    hsci_cmd_sel_data_t data;
  } hsci_cmd_sel_reg_t;

  // BitField: hsci_slave_ahb_tsize (r/w)
  //        bitfield defines
  parameter BF_HSCI_SLAVE_AHB_TSIZE_RESET         = 2'h0;
  parameter BF_HSCI_SLAVE_AHB_TSIZE_WIDTH         = 32'd2;
  //        register reference defines
  parameter BF_HSCI_SLAVE_AHB_TSIZE_LSB           = 32'd0;
  parameter BF_HSCI_SLAVE_AHB_TSIZE_MSB           = 32'd1;
  parameter BF_HSCI_SLAVE_AHB_TSIZE_ROFFSET       = 32'd4;
  parameter BF_HSCI_SLAVE_AHB_TSIZE_RMSB          = 32'd5;
  parameter BF_HSCI_SLAVE_AHB_TSIZE_RMASK         = 6'h30;
  parameter BF_HSCI_SLAVE_AHB_TSIZE_RWIDTH        = 32'd2;
  typedef logic [1:0] hsci_slave_ahb_tsize_data_t;
  //        bitfield structures
  typedef struct packed {
    hsci_slave_ahb_tsize_data_t data;
  } hsci_slave_ahb_tsize_reg_t;

  // BitField: hsci_bram_start_address (r/w)
  //        bitfield defines
  parameter BF_HSCI_BRAM_START_ADDRESS_RESET      = 16'h0;
  parameter BF_HSCI_BRAM_START_ADDRESS_WIDTH      = 32'd16;
  //        register reference defines
  parameter BF_HSCI_BRAM_START_ADDRESS_LSB        = 32'd0;
  parameter BF_HSCI_BRAM_START_ADDRESS_MSB        = 32'd15;
  parameter BF_HSCI_BRAM_START_ADDRESS_ROFFSET    = 32'd0;
  parameter BF_HSCI_BRAM_START_ADDRESS_RMSB       = 32'd15;
  parameter BF_HSCI_BRAM_START_ADDRESS_RMASK      = 16'hffff;
  parameter BF_HSCI_BRAM_START_ADDRESS_RWIDTH     = 32'd16;
  typedef logic [15:0] hsci_bram_start_address_data_t;
  //        bitfield structures
  typedef struct packed {
    hsci_bram_start_address_data_t data;
  } hsci_bram_start_address_reg_t;

  // BitField: hsci_run (r/w)
  //        bitfield defines
  parameter BF_HSCI_RUN_RESET                     = 1'h0;
  parameter BF_HSCI_RUN_WIDTH                     = 32'd1;
  //        register reference defines
  parameter BF_HSCI_RUN_LSB                       = 32'd0;
  parameter BF_HSCI_RUN_MSB                       = 32'd0;
  parameter BF_HSCI_RUN_ROFFSET                   = 32'd0;
  parameter BF_HSCI_RUN_RMSB                      = 32'd0;
  parameter BF_HSCI_RUN_RMASK                     = 1'h1;
  parameter BF_HSCI_RUN_RWIDTH                    = 32'd1;
  typedef logic  hsci_run_data_t;
  //        bitfield structures
  typedef struct packed {
    hsci_run_data_t data;
  } hsci_run_reg_t;

  typedef struct packed {
    logic          sclr;
  } hsci_run_status_t;

  // BitField: master_done (r)   Volatile
  //        bitfield defines
  parameter BF_MASTER_DONE_RESET                  = 1'h0;
  parameter BF_MASTER_DONE_WIDTH                  = 32'd1;
  //        register reference defines
  parameter BF_MASTER_DONE_LSB                    = 32'd0;
  parameter BF_MASTER_DONE_MSB                    = 32'd0;
  parameter BF_MASTER_DONE_ROFFSET                = 32'd0;
  parameter BF_MASTER_DONE_RMSB                   = 32'd0;
  parameter BF_MASTER_DONE_RMASK                  = 1'h1;
  parameter BF_MASTER_DONE_RWIDTH                 = 32'd1;
  typedef logic  master_done_data_t;

  typedef struct packed {
    master_done_data_t data;
  } master_done_status_t;

  // BitField: master_running (r)   Volatile
  //        bitfield defines
  parameter BF_MASTER_RUNNING_RESET               = 1'h0;
  parameter BF_MASTER_RUNNING_WIDTH               = 32'd1;
  //        register reference defines
  parameter BF_MASTER_RUNNING_LSB                 = 32'd0;
  parameter BF_MASTER_RUNNING_MSB                 = 32'd0;
  parameter BF_MASTER_RUNNING_ROFFSET             = 32'd1;
  parameter BF_MASTER_RUNNING_RMSB                = 32'd1;
  parameter BF_MASTER_RUNNING_RMASK               = 2'h2;
  parameter BF_MASTER_RUNNING_RWIDTH              = 32'd1;
  typedef logic  master_running_data_t;

  typedef struct packed {
    master_running_data_t data;
  } master_running_status_t;

  // BitField: master_wr_in_prog (r)   Volatile
  //        bitfield defines
  parameter BF_MASTER_WR_IN_PROG_RESET            = 1'h0;
  parameter BF_MASTER_WR_IN_PROG_WIDTH            = 32'd1;
  //        register reference defines
  parameter BF_MASTER_WR_IN_PROG_LSB              = 32'd0;
  parameter BF_MASTER_WR_IN_PROG_MSB              = 32'd0;
  parameter BF_MASTER_WR_IN_PROG_ROFFSET          = 32'd2;
  parameter BF_MASTER_WR_IN_PROG_RMSB             = 32'd2;
  parameter BF_MASTER_WR_IN_PROG_RMASK            = 3'h4;
  parameter BF_MASTER_WR_IN_PROG_RWIDTH           = 32'd1;
  typedef logic  master_wr_in_prog_data_t;

  typedef struct packed {
    master_wr_in_prog_data_t data;
  } master_wr_in_prog_status_t;

  // BitField: master_rd_in_prog (r)   Volatile
  //        bitfield defines
  parameter BF_MASTER_RD_IN_PROG_RESET            = 1'h0;
  parameter BF_MASTER_RD_IN_PROG_WIDTH            = 32'd1;
  //        register reference defines
  parameter BF_MASTER_RD_IN_PROG_LSB              = 32'd0;
  parameter BF_MASTER_RD_IN_PROG_MSB              = 32'd0;
  parameter BF_MASTER_RD_IN_PROG_ROFFSET          = 32'd3;
  parameter BF_MASTER_RD_IN_PROG_RMSB             = 32'd3;
  parameter BF_MASTER_RD_IN_PROG_RMASK            = 4'h8;
  parameter BF_MASTER_RD_IN_PROG_RWIDTH           = 32'd1;
  typedef logic  master_rd_in_prog_data_t;

  typedef struct packed {
    master_rd_in_prog_data_t data;
  } master_rd_in_prog_status_t;

  // BitField: miso_test_lfsr_acq (r)   Volatile
  //        bitfield defines
  parameter BF_MISO_TEST_LFSR_ACQ_RESET           = 1'h0;
  parameter BF_MISO_TEST_LFSR_ACQ_WIDTH           = 32'd1;
  //        register reference defines
  parameter BF_MISO_TEST_LFSR_ACQ_LSB             = 32'd0;
  parameter BF_MISO_TEST_LFSR_ACQ_MSB             = 32'd0;
  parameter BF_MISO_TEST_LFSR_ACQ_ROFFSET         = 32'd4;
  parameter BF_MISO_TEST_LFSR_ACQ_RMSB            = 32'd4;
  parameter BF_MISO_TEST_LFSR_ACQ_RMASK           = 5'h10;
  parameter BF_MISO_TEST_LFSR_ACQ_RWIDTH          = 32'd1;
  typedef logic  miso_test_lfsr_acq_data_t;

  typedef struct packed {
    miso_test_lfsr_acq_data_t data;
  } miso_test_lfsr_acq_status_t;

  // BitField: hsci_man_linkup_word (r/w)
  //        bitfield defines
  parameter BF_HSCI_MAN_LINKUP_WORD_RESET         = 10'h0;
  parameter BF_HSCI_MAN_LINKUP_WORD_WIDTH         = 32'd10;
  //        register reference defines
  parameter BF_HSCI_MAN_LINKUP_WORD_LSB           = 32'd0;
  parameter BF_HSCI_MAN_LINKUP_WORD_MSB           = 32'd9;
  parameter BF_HSCI_MAN_LINKUP_WORD_ROFFSET       = 32'd0;
  parameter BF_HSCI_MAN_LINKUP_WORD_RMSB          = 32'd9;
  parameter BF_HSCI_MAN_LINKUP_WORD_RMASK         = 10'h3ff;
  parameter BF_HSCI_MAN_LINKUP_WORD_RWIDTH        = 32'd10;
  typedef logic [9:0] hsci_man_linkup_word_data_t;
  //        bitfield structures
  typedef struct packed {
    hsci_man_linkup_word_data_t data;
  } hsci_man_linkup_word_reg_t;

  // BitField: hsci_man_linkup (r/w)
  //        bitfield defines
  parameter BF_HSCI_MAN_LINKUP_RESET              = 1'h0;
  parameter BF_HSCI_MAN_LINKUP_WIDTH              = 32'd1;
  //        register reference defines
  parameter BF_HSCI_MAN_LINKUP_LSB                = 32'd0;
  parameter BF_HSCI_MAN_LINKUP_MSB                = 32'd0;
  parameter BF_HSCI_MAN_LINKUP_ROFFSET            = 32'd10;
  parameter BF_HSCI_MAN_LINKUP_RMSB               = 32'd10;
  parameter BF_HSCI_MAN_LINKUP_RMASK              = 11'h400;
  parameter BF_HSCI_MAN_LINKUP_RWIDTH             = 32'd1;
  typedef logic  hsci_man_linkup_data_t;
  //        bitfield structures
  typedef struct packed {
    hsci_man_linkup_data_t data;
  } hsci_man_linkup_reg_t;

  // BitField: hsci_auto_linkup (r/w)
  //        bitfield defines
  parameter BF_HSCI_AUTO_LINKUP_RESET             = 1'h0;
  parameter BF_HSCI_AUTO_LINKUP_WIDTH             = 32'd1;
  //        register reference defines
  parameter BF_HSCI_AUTO_LINKUP_LSB               = 32'd0;
  parameter BF_HSCI_AUTO_LINKUP_MSB               = 32'd0;
  parameter BF_HSCI_AUTO_LINKUP_ROFFSET           = 32'd11;
  parameter BF_HSCI_AUTO_LINKUP_RMSB              = 32'd11;
  parameter BF_HSCI_AUTO_LINKUP_RMASK             = 12'h800;
  parameter BF_HSCI_AUTO_LINKUP_RWIDTH            = 32'd1;
  typedef logic  hsci_auto_linkup_data_t;
  //        bitfield structures
  typedef struct packed {
    hsci_auto_linkup_data_t data;
  } hsci_auto_linkup_reg_t;

  // BitField: mosi_clk_inv (r/w)
  //        bitfield defines
  parameter BF_MOSI_CLK_INV_RESET                 = 1'h0;
  parameter BF_MOSI_CLK_INV_WIDTH                 = 32'd1;
  //        register reference defines
  parameter BF_MOSI_CLK_INV_LSB                   = 32'd0;
  parameter BF_MOSI_CLK_INV_MSB                   = 32'd0;
  parameter BF_MOSI_CLK_INV_ROFFSET               = 32'd12;
  parameter BF_MOSI_CLK_INV_RMSB                  = 32'd12;
  parameter BF_MOSI_CLK_INV_RMASK                 = 13'h1000;
  parameter BF_MOSI_CLK_INV_RWIDTH                = 32'd1;
  typedef logic  mosi_clk_inv_data_t;
  //        bitfield structures
  typedef struct packed {
    mosi_clk_inv_data_t data;
  } mosi_clk_inv_reg_t;

  // BitField: miso_clk_inv (r/w)
  //        bitfield defines
  parameter BF_MISO_CLK_INV_RESET                 = 1'h0;
  parameter BF_MISO_CLK_INV_WIDTH                 = 32'd1;
  //        register reference defines
  parameter BF_MISO_CLK_INV_LSB                   = 32'd0;
  parameter BF_MISO_CLK_INV_MSB                   = 32'd0;
  parameter BF_MISO_CLK_INV_ROFFSET               = 32'd13;
  parameter BF_MISO_CLK_INV_RMSB                  = 32'd13;
  parameter BF_MISO_CLK_INV_RMASK                 = 14'h2000;
  parameter BF_MISO_CLK_INV_RWIDTH                = 32'd1;
  typedef logic  miso_clk_inv_data_t;
  //        bitfield structures
  typedef struct packed {
    miso_clk_inv_data_t data;
  } miso_clk_inv_reg_t;

  // BitField: hsci_mosi_test_mode (r/w)
  //        bitfield defines
  parameter BF_HSCI_MOSI_TEST_MODE_RESET          = 1'h0;
  parameter BF_HSCI_MOSI_TEST_MODE_WIDTH          = 32'd1;
  //        register reference defines
  parameter BF_HSCI_MOSI_TEST_MODE_LSB            = 32'd0;
  parameter BF_HSCI_MOSI_TEST_MODE_MSB            = 32'd0;
  parameter BF_HSCI_MOSI_TEST_MODE_ROFFSET        = 32'd0;
  parameter BF_HSCI_MOSI_TEST_MODE_RMSB           = 32'd0;
  parameter BF_HSCI_MOSI_TEST_MODE_RMASK          = 1'h1;
  parameter BF_HSCI_MOSI_TEST_MODE_RWIDTH         = 32'd1;
  typedef logic  hsci_mosi_test_mode_data_t;
  //        bitfield structures
  typedef struct packed {
    hsci_mosi_test_mode_data_t data;
  } hsci_mosi_test_mode_reg_t;

  // BitField: hsci_miso_test_mode (r/w)
  //        bitfield defines
  parameter BF_HSCI_MISO_TEST_MODE_RESET          = 1'h0;
  parameter BF_HSCI_MISO_TEST_MODE_WIDTH          = 32'd1;
  //        register reference defines
  parameter BF_HSCI_MISO_TEST_MODE_LSB            = 32'd0;
  parameter BF_HSCI_MISO_TEST_MODE_MSB            = 32'd0;
  parameter BF_HSCI_MISO_TEST_MODE_ROFFSET        = 32'd1;
  parameter BF_HSCI_MISO_TEST_MODE_RMSB           = 32'd1;
  parameter BF_HSCI_MISO_TEST_MODE_RMASK          = 2'h2;
  parameter BF_HSCI_MISO_TEST_MODE_RWIDTH         = 32'd1;
  typedef logic  hsci_miso_test_mode_data_t;
  //        bitfield structures
  typedef struct packed {
    hsci_miso_test_mode_data_t data;
  } hsci_miso_test_mode_reg_t;

  // BitField: hsci_capture_mode (r/w)
  //        bitfield defines
  parameter BF_HSCI_CAPTURE_MODE_RESET            = 1'h0;
  parameter BF_HSCI_CAPTURE_MODE_WIDTH            = 32'd1;
  //        register reference defines
  parameter BF_HSCI_CAPTURE_MODE_LSB              = 32'd0;
  parameter BF_HSCI_CAPTURE_MODE_MSB              = 32'd0;
  parameter BF_HSCI_CAPTURE_MODE_ROFFSET          = 32'd2;
  parameter BF_HSCI_CAPTURE_MODE_RMSB             = 32'd2;
  parameter BF_HSCI_CAPTURE_MODE_RMASK            = 3'h4;
  parameter BF_HSCI_CAPTURE_MODE_RWIDTH           = 32'd1;
  typedef logic  hsci_capture_mode_data_t;
  //        bitfield structures
  typedef struct packed {
    hsci_capture_mode_data_t data;
  } hsci_capture_mode_reg_t;

  // BitField: link_active (r)   Volatile
  //        bitfield defines
  parameter BF_LINK_ACTIVE_RESET                  = 1'h0;
  parameter BF_LINK_ACTIVE_WIDTH                  = 32'd1;
  //        register reference defines
  parameter BF_LINK_ACTIVE_LSB                    = 32'd0;
  parameter BF_LINK_ACTIVE_MSB                    = 32'd0;
  parameter BF_LINK_ACTIVE_ROFFSET                = 32'd0;
  parameter BF_LINK_ACTIVE_RMSB                   = 32'd0;
  parameter BF_LINK_ACTIVE_RMASK                  = 1'h1;
  parameter BF_LINK_ACTIVE_RWIDTH                 = 32'd1;
  typedef logic  link_active_data_t;

  typedef struct packed {
    link_active_data_t data;
  } link_active_status_t;

  // BitField: alink_txclk_adj (r)   Volatile
  //        bitfield defines
  parameter BF_ALINK_TXCLK_ADJ_RESET              = 4'h0;
  parameter BF_ALINK_TXCLK_ADJ_WIDTH              = 32'd4;
  //        register reference defines
  parameter BF_ALINK_TXCLK_ADJ_LSB                = 32'd0;
  parameter BF_ALINK_TXCLK_ADJ_MSB                = 32'd3;
  parameter BF_ALINK_TXCLK_ADJ_ROFFSET            = 32'd4;
  parameter BF_ALINK_TXCLK_ADJ_RMSB               = 32'd7;
  parameter BF_ALINK_TXCLK_ADJ_RMASK              = 8'hf0;
  parameter BF_ALINK_TXCLK_ADJ_RWIDTH             = 32'd4;
  typedef logic [3:0] alink_txclk_adj_data_t;

  typedef struct packed {
    alink_txclk_adj_data_t data;
  } alink_txclk_adj_status_t;

  // BitField: alink_txclk_inv (r)   Volatile
  //        bitfield defines
  parameter BF_ALINK_TXCLK_INV_RESET              = 1'h0;
  parameter BF_ALINK_TXCLK_INV_WIDTH              = 32'd1;
  //        register reference defines
  parameter BF_ALINK_TXCLK_INV_LSB                = 32'd0;
  parameter BF_ALINK_TXCLK_INV_MSB                = 32'd0;
  parameter BF_ALINK_TXCLK_INV_ROFFSET            = 32'd8;
  parameter BF_ALINK_TXCLK_INV_RMSB               = 32'd8;
  parameter BF_ALINK_TXCLK_INV_RMASK              = 9'h100;
  parameter BF_ALINK_TXCLK_INV_RWIDTH             = 32'd1;
  typedef logic  alink_txclk_inv_data_t;

  typedef struct packed {
    alink_txclk_inv_data_t data;
  } alink_txclk_inv_status_t;

  // BitField: txclk_adj_mismatch (r)   Volatile
  //        bitfield defines
  parameter BF_TXCLK_ADJ_MISMATCH_RESET           = 1'h0;
  parameter BF_TXCLK_ADJ_MISMATCH_WIDTH           = 32'd1;
  //        register reference defines
  parameter BF_TXCLK_ADJ_MISMATCH_LSB             = 32'd0;
  parameter BF_TXCLK_ADJ_MISMATCH_MSB             = 32'd0;
  parameter BF_TXCLK_ADJ_MISMATCH_ROFFSET         = 32'd10;
  parameter BF_TXCLK_ADJ_MISMATCH_RMSB            = 32'd10;
  parameter BF_TXCLK_ADJ_MISMATCH_RMASK           = 11'h400;
  parameter BF_TXCLK_ADJ_MISMATCH_RWIDTH          = 32'd1;
  typedef logic  txclk_adj_mismatch_data_t;

  typedef struct packed {
    txclk_adj_mismatch_data_t data;
  } txclk_adj_mismatch_status_t;

  // BitField: txclk_inv_mismatch (r)   Volatile
  //        bitfield defines
  parameter BF_TXCLK_INV_MISMATCH_RESET           = 1'h0;
  parameter BF_TXCLK_INV_MISMATCH_WIDTH           = 32'd1;
  //        register reference defines
  parameter BF_TXCLK_INV_MISMATCH_LSB             = 32'd0;
  parameter BF_TXCLK_INV_MISMATCH_MSB             = 32'd0;
  parameter BF_TXCLK_INV_MISMATCH_ROFFSET         = 32'd11;
  parameter BF_TXCLK_INV_MISMATCH_RMSB            = 32'd11;
  parameter BF_TXCLK_INV_MISMATCH_RMASK           = 12'h800;
  parameter BF_TXCLK_INV_MISMATCH_RWIDTH          = 32'd1;
  typedef logic  txclk_inv_mismatch_data_t;

  typedef struct packed {
    txclk_inv_mismatch_data_t data;
  } txclk_inv_mismatch_status_t;

  // BitField: alink_table (r)   Volatile
  //        bitfield defines
  parameter BF_ALINK_TABLE_RESET                  = 16'h0;
  parameter BF_ALINK_TABLE_WIDTH                  = 32'd16;
  //        register reference defines
  parameter BF_ALINK_TABLE_LSB                    = 32'd0;
  parameter BF_ALINK_TABLE_MSB                    = 32'd15;
  parameter BF_ALINK_TABLE_ROFFSET                = 32'd0;
  parameter BF_ALINK_TABLE_RMSB                   = 32'd15;
  parameter BF_ALINK_TABLE_RMASK                  = 16'hffff;
  parameter BF_ALINK_TABLE_RWIDTH                 = 32'd16;
  typedef logic [15:0] alink_table_data_t;

  typedef struct packed {
    alink_table_data_t data;
  } alink_table_status_t;

  // BitField: alink_fsm (r)   Volatile
  //        bitfield defines
  parameter BF_ALINK_FSM_RESET                    = 4'h0;
  parameter BF_ALINK_FSM_WIDTH                    = 32'd4;
  //        register reference defines
  parameter BF_ALINK_FSM_LSB                      = 32'd0;
  parameter BF_ALINK_FSM_MSB                      = 32'd3;
  parameter BF_ALINK_FSM_ROFFSET                  = 32'd16;
  parameter BF_ALINK_FSM_RMSB                     = 32'd19;
  parameter BF_ALINK_FSM_RMASK                    = 20'hf0000;
  parameter BF_ALINK_FSM_RWIDTH                   = 32'd4;
  typedef logic [3:0] alink_fsm_data_t;

  typedef struct packed {
    alink_fsm_data_t data;
  } alink_fsm_status_t;

  // BitField: enc_fsm (r)   Volatile
  //        bitfield defines
  parameter BF_ENC_FSM_RESET                      = 4'h0;
  parameter BF_ENC_FSM_WIDTH                      = 32'd4;
  //        register reference defines
  parameter BF_ENC_FSM_LSB                        = 32'd0;
  parameter BF_ENC_FSM_MSB                        = 32'd3;
  parameter BF_ENC_FSM_ROFFSET                    = 32'd0;
  parameter BF_ENC_FSM_RMSB                       = 32'd3;
  parameter BF_ENC_FSM_RMASK                      = 4'hf;
  parameter BF_ENC_FSM_RWIDTH                     = 32'd4;
  typedef logic [3:0] enc_fsm_data_t;

  typedef struct packed {
    enc_fsm_data_t data;
  } enc_fsm_status_t;

  // BitField: dec_fsm (r)   Volatile
  //        bitfield defines
  parameter BF_DEC_FSM_RESET                      = 3'h0;
  parameter BF_DEC_FSM_WIDTH                      = 32'd3;
  //        register reference defines
  parameter BF_DEC_FSM_LSB                        = 32'd0;
  parameter BF_DEC_FSM_MSB                        = 32'd2;
  parameter BF_DEC_FSM_ROFFSET                    = 32'd4;
  parameter BF_DEC_FSM_RMSB                       = 32'd6;
  parameter BF_DEC_FSM_RMASK                      = 7'h70;
  parameter BF_DEC_FSM_RWIDTH                     = 32'd3;
  typedef logic [2:0] dec_fsm_data_t;

  typedef struct packed {
    dec_fsm_data_t data;
  } dec_fsm_status_t;

  // BitField: capture_word (r)   Volatile
  //        bitfield defines
  parameter BF_CAPTURE_WORD_RESET                 = 10'h0;
  parameter BF_CAPTURE_WORD_WIDTH                 = 32'd10;
  //        register reference defines
  parameter BF_CAPTURE_WORD_LSB                   = 32'd0;
  parameter BF_CAPTURE_WORD_MSB                   = 32'd9;
  parameter BF_CAPTURE_WORD_ROFFSET               = 32'd8;
  parameter BF_CAPTURE_WORD_RMSB                  = 32'd17;
  parameter BF_CAPTURE_WORD_RMASK                 = 18'h3ff00;
  parameter BF_CAPTURE_WORD_RWIDTH                = 32'd10;
  typedef logic [9:0] capture_word_data_t;

  typedef struct packed {
    capture_word_data_t data;
  } capture_word_status_t;

  // BitField: parity_error (r)   Volatile
  //        bitfield defines
  parameter BF_PARITY_ERROR_RESET                 = 1'h0;
  parameter BF_PARITY_ERROR_WIDTH                 = 32'd1;
  //        register reference defines
  parameter BF_PARITY_ERROR_LSB                   = 32'd0;
  parameter BF_PARITY_ERROR_MSB                   = 32'd0;
  parameter BF_PARITY_ERROR_ROFFSET               = 32'd18;
  parameter BF_PARITY_ERROR_RMSB                  = 32'd18;
  parameter BF_PARITY_ERROR_RMASK                 = 19'h40000;
  parameter BF_PARITY_ERROR_RWIDTH                = 32'd1;
  typedef logic  parity_error_data_t;

  typedef struct packed {
    parity_error_data_t data;
  } parity_error_status_t;

  // BitField: unkown_instruction_error (r)   Volatile
  //        bitfield defines
  parameter BF_UNKOWN_INSTRUCTION_ERROR_RESET     = 1'h0;
  parameter BF_UNKOWN_INSTRUCTION_ERROR_WIDTH     = 32'd1;
  //        register reference defines
  parameter BF_UNKOWN_INSTRUCTION_ERROR_LSB       = 32'd0;
  parameter BF_UNKOWN_INSTRUCTION_ERROR_MSB       = 32'd0;
  parameter BF_UNKOWN_INSTRUCTION_ERROR_ROFFSET   = 32'd19;
  parameter BF_UNKOWN_INSTRUCTION_ERROR_RMSB      = 32'd19;
  parameter BF_UNKOWN_INSTRUCTION_ERROR_RMASK     = 20'h80000;
  parameter BF_UNKOWN_INSTRUCTION_ERROR_RWIDTH    = 32'd1;
  typedef logic  unkown_instruction_error_data_t;

  typedef struct packed {
    unkown_instruction_error_data_t data;
  } unkown_instruction_error_status_t;

  // BitField: slave_error_code (r)   Volatile
  //        bitfield defines
  parameter BF_SLAVE_ERROR_CODE_RESET             = 8'h0;
  parameter BF_SLAVE_ERROR_CODE_WIDTH             = 32'd8;
  //        register reference defines
  parameter BF_SLAVE_ERROR_CODE_LSB               = 32'd0;
  parameter BF_SLAVE_ERROR_CODE_MSB               = 32'd7;
  parameter BF_SLAVE_ERROR_CODE_ROFFSET           = 32'd20;
  parameter BF_SLAVE_ERROR_CODE_RMSB              = 32'd27;
  parameter BF_SLAVE_ERROR_CODE_RMASK             = 28'hff00000;
  parameter BF_SLAVE_ERROR_CODE_RWIDTH            = 32'd8;
  typedef logic [7:0] slave_error_code_data_t;

  typedef struct packed {
    slave_error_code_data_t data;
  } slave_error_code_status_t;

  // BitField: miso_test_ber (r)   Volatile
  //        bitfield defines
  parameter BF_MISO_TEST_BER_RESET                = 32'h0;
  parameter BF_MISO_TEST_BER_WIDTH                = 32'd32;
  //        register reference defines
  parameter BF_MISO_TEST_BER_LSB                  = 32'd0;
  parameter BF_MISO_TEST_BER_MSB                  = 32'd31;
  parameter BF_MISO_TEST_BER_ROFFSET              = 32'd0;
  parameter BF_MISO_TEST_BER_RMSB                 = 32'd31;
  parameter BF_MISO_TEST_BER_RMASK                = 32'hffffffff;
  parameter BF_MISO_TEST_BER_RWIDTH               = 32'd32;
  typedef logic [31:0] miso_test_ber_data_t;

  typedef struct packed {
    miso_test_ber_data_t data;
  } miso_test_ber_status_t;

  // BitField: hsci_link_err_info (r)   Volatile
  //        bitfield defines
  parameter BF_HSCI_LINK_ERR_INFO_RESET           = 31'h0;
  parameter BF_HSCI_LINK_ERR_INFO_WIDTH           = 32'd31;
  //        register reference defines
  parameter BF_HSCI_LINK_ERR_INFO_LSB             = 32'd0;
  parameter BF_HSCI_LINK_ERR_INFO_MSB             = 32'd30;
  parameter BF_HSCI_LINK_ERR_INFO_ROFFSET         = 32'd0;
  parameter BF_HSCI_LINK_ERR_INFO_RMSB            = 32'd30;
  parameter BF_HSCI_LINK_ERR_INFO_RMASK           = 31'h7fffffff;
  parameter BF_HSCI_LINK_ERR_INFO_RWIDTH          = 32'd31;
  typedef logic [30:0] hsci_link_err_info_data_t;

  typedef struct packed {
    hsci_link_err_info_data_t data;
  } hsci_link_err_info_status_t;

  // BitField: scratch_reg (r/w)
  //        bitfield defines
  parameter BF_SCRATCH_REG_RESET                  = 32'h0;
  parameter BF_SCRATCH_REG_WIDTH                  = 32'd32;
  //        register reference defines
  parameter BF_SCRATCH_REG_LSB                    = 32'd0;
  parameter BF_SCRATCH_REG_MSB                    = 32'd31;
  parameter BF_SCRATCH_REG_ROFFSET                = 32'd0;
  parameter BF_SCRATCH_REG_RMSB                   = 32'd31;
  parameter BF_SCRATCH_REG_RMASK                  = 32'hffffffff;
  parameter BF_SCRATCH_REG_RWIDTH                 = 32'd32;
  typedef logic [31:0] scratch_reg_data_t;
  //        bitfield structures
  typedef struct packed {
    scratch_reg_data_t data;
  } scratch_reg_reg_t;

  // BitField: hsci_mmcm_drp_trig (r/w)
  //        bitfield defines
  parameter BF_HSCI_MMCM_DRP_TRIG_RESET           = 1'h0;
  parameter BF_HSCI_MMCM_DRP_TRIG_WIDTH           = 32'd1;
  //        register reference defines
  parameter BF_HSCI_MMCM_DRP_TRIG_LSB             = 32'd0;
  parameter BF_HSCI_MMCM_DRP_TRIG_MSB             = 32'd0;
  parameter BF_HSCI_MMCM_DRP_TRIG_ROFFSET         = 32'd0;
  parameter BF_HSCI_MMCM_DRP_TRIG_RMSB            = 32'd0;
  parameter BF_HSCI_MMCM_DRP_TRIG_RMASK           = 1'h1;
  parameter BF_HSCI_MMCM_DRP_TRIG_RWIDTH          = 32'd1;
  typedef logic  hsci_mmcm_drp_trig_data_t;
  //        bitfield structures
  typedef struct packed {
    hsci_mmcm_drp_trig_data_t data;
  } hsci_mmcm_drp_trig_reg_t;

  // BitField: hsci_rate_sel (r/w)
  //        bitfield defines
  parameter BF_HSCI_RATE_SEL_RESET                = 2'h0;
  parameter BF_HSCI_RATE_SEL_WIDTH                = 32'd2;
  //        register reference defines
  parameter BF_HSCI_RATE_SEL_LSB                  = 32'd0;
  parameter BF_HSCI_RATE_SEL_MSB                  = 32'd1;
  parameter BF_HSCI_RATE_SEL_ROFFSET              = 32'd1;
  parameter BF_HSCI_RATE_SEL_RMSB                 = 32'd2;
  parameter BF_HSCI_RATE_SEL_RMASK                = 3'h6;
  parameter BF_HSCI_RATE_SEL_RWIDTH               = 32'd2;
  typedef logic [1:0] hsci_rate_sel_data_t;
  //        bitfield structures
  typedef struct packed {
    hsci_rate_sel_data_t data;
  } hsci_rate_sel_reg_t;

  // BitField: hsci_pll_reset (r/w)
  //        bitfield defines
  parameter BF_HSCI_PLL_RESET_RESET               = 1'h0;
  parameter BF_HSCI_PLL_RESET_WIDTH               = 32'd1;
  //        register reference defines
  parameter BF_HSCI_PLL_RESET_LSB                 = 32'd0;
  parameter BF_HSCI_PLL_RESET_MSB                 = 32'd0;
  parameter BF_HSCI_PLL_RESET_ROFFSET             = 32'd8;
  parameter BF_HSCI_PLL_RESET_RMSB                = 32'd8;
  parameter BF_HSCI_PLL_RESET_RMASK               = 9'h100;
  parameter BF_HSCI_PLL_RESET_RWIDTH              = 32'd1;
  typedef logic  hsci_pll_reset_data_t;
  //        bitfield structures
  typedef struct packed {
    hsci_pll_reset_data_t data;
  } hsci_pll_reset_reg_t;

  // BitField: hsci_master_clear_errors (r/w)
  //        bitfield defines
  parameter BF_HSCI_MASTER_CLEAR_ERRORS_RESET     = 1'h0;
  parameter BF_HSCI_MASTER_CLEAR_ERRORS_WIDTH     = 32'd1;
  //        register reference defines
  parameter BF_HSCI_MASTER_CLEAR_ERRORS_LSB       = 32'd0;
  parameter BF_HSCI_MASTER_CLEAR_ERRORS_MSB       = 32'd0;
  parameter BF_HSCI_MASTER_CLEAR_ERRORS_ROFFSET   = 32'd4;
  parameter BF_HSCI_MASTER_CLEAR_ERRORS_RMSB      = 32'd4;
  parameter BF_HSCI_MASTER_CLEAR_ERRORS_RMASK     = 5'h10;
  parameter BF_HSCI_MASTER_CLEAR_ERRORS_RWIDTH    = 32'd1;
  typedef logic  hsci_master_clear_errors_data_t;
  //        bitfield structures
  typedef struct packed {
    hsci_master_clear_errors_data_t data;
  } hsci_master_clear_errors_reg_t;

  // BitField: hsci_master_rstn (r/w)
  //        bitfield defines
  parameter BF_HSCI_MASTER_RSTN_RESET             = 1'h0;
  parameter BF_HSCI_MASTER_RSTN_WIDTH             = 32'd1;
  //        register reference defines
  parameter BF_HSCI_MASTER_RSTN_LSB               = 32'd0;
  parameter BF_HSCI_MASTER_RSTN_MSB               = 32'd0;
  parameter BF_HSCI_MASTER_RSTN_ROFFSET           = 32'd8;
  parameter BF_HSCI_MASTER_RSTN_RMSB              = 32'd8;
  parameter BF_HSCI_MASTER_RSTN_RMASK             = 9'h100;
  parameter BF_HSCI_MASTER_RSTN_RWIDTH            = 32'd1;
  typedef logic  hsci_master_rstn_data_t;
  //        bitfield structures
  typedef struct packed {
    hsci_master_rstn_data_t data;
  } hsci_master_rstn_reg_t;

  // BitField: hsci_reset_seq_done (r)   Volatile
  //        bitfield defines
  parameter BF_HSCI_RESET_SEQ_DONE_RESET          = 1'h0;
  parameter BF_HSCI_RESET_SEQ_DONE_WIDTH          = 32'd1;
  //        register reference defines
  parameter BF_HSCI_RESET_SEQ_DONE_LSB            = 32'd0;
  parameter BF_HSCI_RESET_SEQ_DONE_MSB            = 32'd0;
  parameter BF_HSCI_RESET_SEQ_DONE_ROFFSET        = 32'd0;
  parameter BF_HSCI_RESET_SEQ_DONE_RMSB           = 32'd0;
  parameter BF_HSCI_RESET_SEQ_DONE_RMASK          = 1'h1;
  parameter BF_HSCI_RESET_SEQ_DONE_RWIDTH         = 32'd1;
  typedef logic  hsci_reset_seq_done_data_t;

  typedef struct packed {
    hsci_reset_seq_done_data_t data;
  } hsci_reset_seq_done_status_t;

  // BitField: hsci_phy_pll_locked (r)   Volatile
  //        bitfield defines
  parameter BF_HSCI_PHY_PLL_LOCKED_RESET          = 1'h0;
  parameter BF_HSCI_PHY_PLL_LOCKED_WIDTH          = 32'd1;
  //        register reference defines
  parameter BF_HSCI_PHY_PLL_LOCKED_LSB            = 32'd0;
  parameter BF_HSCI_PHY_PLL_LOCKED_MSB            = 32'd0;
  parameter BF_HSCI_PHY_PLL_LOCKED_ROFFSET        = 32'd1;
  parameter BF_HSCI_PHY_PLL_LOCKED_RMSB           = 32'd1;
  parameter BF_HSCI_PHY_PLL_LOCKED_RMASK          = 2'h2;
  parameter BF_HSCI_PHY_PLL_LOCKED_RWIDTH         = 32'd1;
  typedef logic  hsci_phy_pll_locked_data_t;

  typedef struct packed {
    hsci_phy_pll_locked_data_t data;
  } hsci_phy_pll_locked_status_t;

  // BitField: hsci_vtc_rdy_tx (r)   Volatile
  //        bitfield defines
  parameter BF_HSCI_VTC_RDY_TX_RESET              = 1'h0;
  parameter BF_HSCI_VTC_RDY_TX_WIDTH              = 32'd1;
  //        register reference defines
  parameter BF_HSCI_VTC_RDY_TX_LSB                = 32'd0;
  parameter BF_HSCI_VTC_RDY_TX_MSB                = 32'd0;
  parameter BF_HSCI_VTC_RDY_TX_ROFFSET            = 32'd2;
  parameter BF_HSCI_VTC_RDY_TX_RMSB               = 32'd2;
  parameter BF_HSCI_VTC_RDY_TX_RMASK              = 3'h4;
  parameter BF_HSCI_VTC_RDY_TX_RWIDTH             = 32'd1;
  typedef logic  hsci_vtc_rdy_tx_data_t;

  typedef struct packed {
    hsci_vtc_rdy_tx_data_t data;
  } hsci_vtc_rdy_tx_status_t;

  // BitField: hsci_vtc_rdy_rx (r)   Volatile
  //        bitfield defines
  parameter BF_HSCI_VTC_RDY_RX_RESET              = 1'h0;
  parameter BF_HSCI_VTC_RDY_RX_WIDTH              = 32'd1;
  //        register reference defines
  parameter BF_HSCI_VTC_RDY_RX_LSB                = 32'd0;
  parameter BF_HSCI_VTC_RDY_RX_MSB                = 32'd0;
  parameter BF_HSCI_VTC_RDY_RX_ROFFSET            = 32'd3;
  parameter BF_HSCI_VTC_RDY_RX_RMSB               = 32'd3;
  parameter BF_HSCI_VTC_RDY_RX_RMASK              = 4'h8;
  parameter BF_HSCI_VTC_RDY_RX_RWIDTH             = 32'd1;
  typedef logic  hsci_vtc_rdy_rx_data_t;

  typedef struct packed {
    hsci_vtc_rdy_rx_data_t data;
  } hsci_vtc_rdy_rx_status_t;

  // BitField: hsci_dly_rdy_tx (r)   Volatile
  //        bitfield defines
  parameter BF_HSCI_DLY_RDY_TX_RESET              = 1'h0;
  parameter BF_HSCI_DLY_RDY_TX_WIDTH              = 32'd1;
  //        register reference defines
  parameter BF_HSCI_DLY_RDY_TX_LSB                = 32'd0;
  parameter BF_HSCI_DLY_RDY_TX_MSB                = 32'd0;
  parameter BF_HSCI_DLY_RDY_TX_ROFFSET            = 32'd4;
  parameter BF_HSCI_DLY_RDY_TX_RMSB               = 32'd4;
  parameter BF_HSCI_DLY_RDY_TX_RMASK              = 5'h10;
  parameter BF_HSCI_DLY_RDY_TX_RWIDTH             = 32'd1;
  typedef logic  hsci_dly_rdy_tx_data_t;

  typedef struct packed {
    hsci_dly_rdy_tx_data_t data;
  } hsci_dly_rdy_tx_status_t;

  // BitField: hsci_dly_rdy_rx (r)   Volatile
  //        bitfield defines
  parameter BF_HSCI_DLY_RDY_RX_RESET              = 1'h0;
  parameter BF_HSCI_DLY_RDY_RX_WIDTH              = 32'd1;
  //        register reference defines
  parameter BF_HSCI_DLY_RDY_RX_LSB                = 32'd0;
  parameter BF_HSCI_DLY_RDY_RX_MSB                = 32'd0;
  parameter BF_HSCI_DLY_RDY_RX_ROFFSET            = 32'd5;
  parameter BF_HSCI_DLY_RDY_RX_RMSB               = 32'd5;
  parameter BF_HSCI_DLY_RDY_RX_RMASK              = 6'h20;
  parameter BF_HSCI_DLY_RDY_RX_RWIDTH             = 32'd1;
  typedef logic  hsci_dly_rdy_rx_data_t;

  typedef struct packed {
    hsci_dly_rdy_rx_data_t data;
  } hsci_dly_rdy_rx_status_t;

  // ==========  Register Input and Output Structures  ==========
  typedef struct packed {
    hsci_revision_id_reg_t hsci_revision_id;
    hsci_xfer_mode_reg_t hsci_xfer_mode;
    ver_b__na_reg_t ver_b__na;
    hsci_xfer_num_reg_t hsci_xfer_num;
    hsci_addr_size_reg_t hsci_addr_size;
    hsci_byte_num_reg_t hsci_byte_num;
    spi_target_reg_t spi_target;
    hsci_cmd_sel_reg_t hsci_cmd_sel;
    hsci_slave_ahb_tsize_reg_t hsci_slave_ahb_tsize;
    hsci_bram_start_address_reg_t hsci_bram_start_address;
    hsci_run_reg_t hsci_run;
    hsci_man_linkup_word_reg_t hsci_man_linkup_word;
    hsci_man_linkup_reg_t hsci_man_linkup;
    hsci_auto_linkup_reg_t hsci_auto_linkup;
    mosi_clk_inv_reg_t mosi_clk_inv;
    miso_clk_inv_reg_t miso_clk_inv;
    hsci_mosi_test_mode_reg_t hsci_mosi_test_mode;
    hsci_miso_test_mode_reg_t hsci_miso_test_mode;
    hsci_capture_mode_reg_t hsci_capture_mode;
    scratch_reg_reg_t scratch_reg;
    hsci_mmcm_drp_trig_reg_t hsci_mmcm_drp_trig;
    hsci_rate_sel_reg_t hsci_rate_sel;
    hsci_pll_reset_reg_t hsci_pll_reset;
    hsci_master_clear_errors_reg_t hsci_master_clear_errors;
    hsci_master_rstn_reg_t hsci_master_rstn;
  } hsci_master_regs_regs_t;

  typedef struct packed {
    hsci_run_status_t hsci_run;
    master_done_status_t master_done;
    master_running_status_t master_running;
    master_wr_in_prog_status_t master_wr_in_prog;
    master_rd_in_prog_status_t master_rd_in_prog;
    miso_test_lfsr_acq_status_t miso_test_lfsr_acq;
    link_active_status_t link_active;
    alink_txclk_adj_status_t alink_txclk_adj;
    alink_txclk_inv_status_t alink_txclk_inv;
    txclk_adj_mismatch_status_t txclk_adj_mismatch;
    txclk_inv_mismatch_status_t txclk_inv_mismatch;
    alink_table_status_t alink_table;
    alink_fsm_status_t alink_fsm;
    enc_fsm_status_t enc_fsm;
    dec_fsm_status_t dec_fsm;
    capture_word_status_t capture_word;
    parity_error_status_t parity_error;
    unkown_instruction_error_status_t unkown_instruction_error;
    slave_error_code_status_t slave_error_code;
    miso_test_ber_status_t miso_test_ber;
    hsci_link_err_info_status_t hsci_link_err_info;
    hsci_reset_seq_done_status_t hsci_reset_seq_done;
    hsci_phy_pll_locked_status_t hsci_phy_pll_locked;
    hsci_vtc_rdy_tx_status_t hsci_vtc_rdy_tx;
    hsci_vtc_rdy_rx_status_t hsci_vtc_rdy_rx;
    hsci_dly_rdy_tx_status_t hsci_dly_rdy_tx;
    hsci_dly_rdy_rx_status_t hsci_dly_rdy_rx;
  } hsci_master_regs_status_t;





/*----------------------------------------*/
/*  Function for MMR WR Access Validation */
/*----------------------------------------*/

function  automatic MMR_Rd_Valid_HSCI_MASTER_REGS( input  [15:0] adr );
  logic valid;
  begin
    case( adr )
      16'h0000 : valid = 1'b1;
      16'h8001 : valid = 1'b1;
      16'h8002 : valid = 1'b1;
      16'h8003 : valid = 1'b1;
      16'h8004 : valid = 1'b1;
      16'h8005 : valid = 1'b1;
      16'h8006 : valid = 1'b1;
      16'h8007 : valid = 1'b1;
      16'h8008 : valid = 1'b1;
      16'h8009 : valid = 1'b1;
      16'h800a : valid = 1'b1;
      16'h800b : valid = 1'b1;
      16'h800c : valid = 1'b1;
      16'h800d : valid = 1'b1;
      16'h800e : valid = 1'b1;
      16'h800f : valid = 1'b1;
      16'h8010 : valid = 1'b1;
      16'h8011 : valid = 1'b1;
      16'h8012 : valid = 1'b1;
      16'h8013 : valid = 1'b1;
      16'h801f : valid = 1'b1;
      default    : valid = 1'b0;
    endcase
    MMR_Rd_Valid_HSCI_MASTER_REGS = valid;
  end
endfunction /* MMR_Rd_Valid_HSCI_MASTER_REGS */

/*----------------------------------------*/
/*  Function for MMR WR Access Validation */
/*----------------------------------------*/

function automatic MMR_Wr_Valid_HSCI_MASTER_REGS( input  [15:0] adr );
  logic valid;
  begin
    case( adr )
      16'h8001 : valid = 1'b1;
      16'h8002 : valid = 1'b1;
      16'h8003 : valid = 1'b1;
      16'h8004 : valid = 1'b1;
      16'h8005 : valid = 1'b1;
      16'h8006 : valid = 1'b1;
      16'h8007 : valid = 1'b1;
      16'h8008 : valid = 1'b1;
      16'h800a : valid = 1'b1;
      16'h800b : valid = 1'b1;
      16'h8010 : valid = 1'b1;
      16'h8011 : valid = 1'b1;
      16'h8012 : valid = 1'b1;
      16'h8013 : valid = 1'b1;
      16'h801f : valid = 1'b1;
      default    : valid = 1'b0;
    endcase
    MMR_Wr_Valid_HSCI_MASTER_REGS = valid;
  end
endfunction /* MMR_Wr_Valid_HSCI_MASTER_REGS */

endpackage

`endif        // end ifndef _DEFINE_SV_HSCI_MASTER_REGS
