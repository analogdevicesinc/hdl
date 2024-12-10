###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# source base VCU118 design
source ../../../../hdl/projects/common/vcu118/vcu118_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

ad_ip_parameter axi_ddr_cntrl CONFIG.C0_CLOCK_BOARD_INTERFACE default_250mhz_clk1
ad_ip_parameter axi_ddr_cntrl CONFIG.C0_DDR4_BOARD_INTERFACE ddr4_sdram_c1_062

ad_ip_parameter axi_dp_interconnect CONFIG.NUM_CLKS 3
ad_connect axi_dp_interconnect/aclk2 sys_250m_clk

ad_ip_instance axi_gpio axi_gpio_0 [list \
  C_ALL_OUTPUTS 1 \
  C_DOUT_DEFAULT 0x00000001 \
  C_GPIO_WIDTH 1 \
]

# ad_ip_instance axi_gpio corundum_reset_gpio [list \
#   C_ALL_OUTPUTS 1 \
#   C_DOUT_DEFAULT 0x00000001 \
#   C_GPIO_WIDTH 1 \
# ]

ad_connect axi_gpio_0/gpio_io_o sys_250m_rstgen/aux_reset_in
# ad_connect corundum_reset_gpio/gpio_io_o sys_250m_rstgen/aux_reset_in

ad_ip_instance clk_wiz clk_wiz_125mhz

ad_connect clk_wiz_125mhz/clk_in1 sys_250m_clk
ad_connect clk_wiz_125mhz/reset sys_250m_reset

ad_ip_instance proc_sys_reset sys_125m_rstgen
 
ad_connect sys_125m_rstgen/slowest_sync_clk clk_wiz_125mhz/clk_out1
ad_connect sys_125m_rstgen/ext_reset_in axi_ddr_cntrl/c0_ddr4_ui_clk_sync_rst

ad_ip_instance corundum_core corundum_core [list \
  FPGA_ID 0x04b31093 \
  FW_ID 0x00000000 \
  FW_VER 0x00000100 \
  BOARD_ID 0x10ee9076 \
  BOARD_VER 0x01000000 \
  BUILD_DATE 0x17320231 \
  GIT_HASH 0x37f26075 \
  RELEASE_INFO 0x00000000 \
  IF_COUNT 1 \
  PORTS_PER_IF 1 \
  SCHED_PER_IF 1 \
  PORT_COUNT 1 \
  CLK_PERIOD_NS_NUM 4 \
  CLK_PERIOD_NS_DENOM 1 \
  PTP_CLK_PERIOD_NS_NUM 32 \
  PTP_CLK_PERIOD_NS_DENOM 5 \
  PTP_CLOCK_PIPELINE 0 \
  PTP_CLOCK_CDC_PIPELINE 0 \
  PTP_SEPARATE_TX_CLOCK 0 \
  PTP_SEPARATE_RX_CLOCK 0 \
  PTP_PORT_CDC_PIPELINE 0 \
  PTP_PEROUT_ENABLE 1 \
  PTP_PEROUT_COUNT 1 \
  EVENT_QUEUE_OP_TABLE_SIZE 32 \
  TX_QUEUE_OP_TABLE_SIZE 32 \
  RX_QUEUE_OP_TABLE_SIZE 32 \
  CQ_OP_TABLE_SIZE 32 \
  EQN_WIDTH 6 \
  TX_QUEUE_INDEX_WIDTH 13 \
  RX_QUEUE_INDEX_WIDTH 8 \
  CQN_WIDTH 14 \
  EQ_PIPELINE 3 \
  TX_QUEUE_PIPELINE 4 \
  RX_QUEUE_PIPELINE 3 \
  CQ_PIPELINE 5 \
  TX_DESC_TABLE_SIZE 32 \
  RX_DESC_TABLE_SIZE 32 \
  RX_INDIR_TBL_ADDR_WIDTH 8 \
  TX_SCHEDULER_OP_TABLE_SIZE 32 \
  TX_SCHEDULER_PIPELINE 4 \
  TDMA_INDEX_WIDTH 6 \
  PTP_TS_ENABLE 1 \
  PTP_TS_FMT_TOD 0 \
  PTP_TS_WIDTH 48 \
  TX_CPL_ENABLE 1 \
  TX_CPL_FIFO_DEPTH 32 \
  TX_TAG_WIDTH 16 \
  TX_CHECKSUM_ENABLE 1 \
  RX_HASH_ENABLE 1 \
  RX_CHECKSUM_ENABLE 1 \
  PFC_ENABLE 1 \
  LFC_ENABLE 1 \
  MAC_CTRL_ENABLE 0 \
  TX_FIFO_DEPTH 131072 \
  RX_FIFO_DEPTH 131072 \
  MAX_TX_SIZE 9214 \
  MAX_RX_SIZE 9214 \
  TX_RAM_SIZE 131072 \
  RX_RAM_SIZE 131072 \
  DDR_CH 2 \
  DDR_ENABLE 0 \
  DDR_GROUP_SIZE 1 \
  AXI_DDR_DATA_WIDTH 512 \
  AXI_DDR_ADDR_WIDTH 31 \
  AXI_DDR_STRB_WIDTH 64 \
  AXI_DDR_ID_WIDTH 8 \
  AXI_DDR_AWUSER_ENABLE 0 \
  AXI_DDR_WUSER_ENABLE 0 \
  AXI_DDR_BUSER_ENABLE 0 \
  AXI_DDR_ARUSER_ENABLE 0 \
  AXI_DDR_RUSER_ENABLE 0 \
  AXI_DDR_MAX_BURST_LEN 256 \
  AXI_DDR_NARROW_BURST 0 \
  AXI_DDR_FIXED_BURST 0 \
  AXI_DDR_WRAP_BURST 0 \
  HBM_CH 1 \
  HBM_ENABLE 0 \
  HBM_GROUP_SIZE 1 \
  AXI_HBM_DATA_WIDTH 256 \
  AXI_HBM_ADDR_WIDTH 32 \
  AXI_HBM_STRB_WIDTH 32 \
  AXI_HBM_ID_WIDTH 8 \
  AXI_HBM_AWUSER_ENABLE 0 \
  AXI_HBM_AWUSER_WIDTH 1 \
  AXI_HBM_WUSER_ENABLE 0 \
  AXI_HBM_WUSER_WIDTH 1 \
  AXI_HBM_BUSER_ENABLE 0 \
  AXI_HBM_BUSER_WIDTH 1 \
  AXI_HBM_ARUSER_ENABLE 0 \
  AXI_HBM_ARUSER_WIDTH 1 \
  AXI_HBM_RUSER_ENABLE 0 \
  AXI_HBM_RUSER_WIDTH 1 \
  AXI_HBM_MAX_BURST_LEN 256 \
  AXI_HBM_NARROW_BURST 0 \
  AXI_HBM_FIXED_BURST 0 \
  AXI_HBM_WRAP_BURST 0 \
  APP_ID 0x12340001 \
  APP_ENABLE 0 \
  APP_CTRL_ENABLE 1 \
  APP_DMA_ENABLE 1 \
  APP_AXIS_DIRECT_ENABLE 1 \
  APP_AXIS_SYNC_ENABLE 1 \
  APP_AXIS_IF_ENABLE 1 \
  APP_STAT_ENABLE 1 \
  APP_GPIO_IN_WIDTH 32 \
  APP_GPIO_OUT_WIDTH 32 \
  AXI_DATA_WIDTH 512 \
  AXI_ADDR_WIDTH 64 \
  AXI_STRB_WIDTH 64 \
  AXI_ID_WIDTH 8 \
  DMA_IMM_ENABLE 0 \
  DMA_IMM_WIDTH 32 \
  DMA_LEN_WIDTH 16 \
  DMA_TAG_WIDTH 16 \
  RAM_ADDR_WIDTH 17 \
  RAM_PIPELINE 2 \
  AXI_DMA_MAX_BURST_LEN 256 \
  AXI_DMA_READ_USE_ID 0 \
  AXI_DMA_WRITE_USE_ID 1 \
  AXI_DMA_READ_OP_TABLE_SIZE 256 \
  AXI_DMA_WRITE_OP_TABLE_SIZE 256 \
  IRQ_COUNT 8 \
  AXIL_CTRL_DATA_WIDTH 32 \
  AXIL_CTRL_ADDR_WIDTH 24 \
  AXIL_CTRL_STRB_WIDTH 4 \
  AXIL_IF_CTRL_ADDR_WIDTH 24 \
  AXIL_CSR_ADDR_WIDTH 19 \
  AXIL_CSR_PASSTHROUGH_ENABLE 0 \
  RB_NEXT_PTR 0x00001000 \
  AXIL_APP_CTRL_DATA_WIDTH 32 \
  AXIL_APP_CTRL_ADDR_WIDTH 24 \
  AXIL_APP_CTRL_STRB_WIDTH 4 \
  AXIS_DATA_WIDTH 512 \
  AXIS_KEEP_WIDTH 64 \
  AXIS_SYNC_DATA_WIDTH 512 \
  AXIS_IF_DATA_WIDTH 512 \
  AXIS_TX_USER_WIDTH 17 \
  AXIS_RX_USER_WIDTH 49\
  AXIS_RX_USE_READY 0 \
  AXIS_TX_PIPELINE 4 \
  AXIS_TX_FIFO_PIPELINE 4 \
  AXIS_TX_TS_PIPELINE 4 \
  AXIS_RX_PIPELINE 4 \
  AXIS_RX_FIFO_PIPELINE 4 \
  STAT_ENABLE 1 \
  STAT_DMA_ENABLE 1 \
  STAT_AXI_ENABLE 1 \
  STAT_INC_WIDTH 24 \
  STAT_ID_WIDTH 12 \
]

ad_ip_instance ethernet ethernet_core [list \
  TDMA_BER_ENABLE 0 \
  QSFP_CNT 1 \
  IF_COUNT 1 \
  PORTS_PER_IF 1 \
  SCHED_PER_IF 1 \
  PORT_COUNT 1 \
  PORT_MASK 0 \
  PTP_TS_FMT_TOD 0 \
  PTP_TS_WIDTH 48 \
  TX_TAG_WIDTH 16 \
  TDMA_INDEX_WIDTH 6 \
  PTP_TS_ENABLE 1 \
  AXIL_CTRL_DATA_WIDTH 32 \
  AXIL_CTRL_ADDR_WIDTH 24 \
  AXIL_CTRL_STRB_WIDTH 8 \
  AXIL_CSR_ADDR_WIDTH 18 \
  AXIL_IF_CTRL_ADDR_WIDTH 24 \
  ETH_RX_CLK_FROM_TX 0 \
  ETH_RS_FEC_ENABLE 1 \
  AXIS_DATA_WIDTH 512 \
  AXIS_KEEP_WIDTH 64 \
  AXIS_TX_USER_WIDTH 17 \
  AXIS_RX_USER_WIDTH 49 \
]

create_bd_intf_port -mode Master -vlnv analog.com:interface:if_qspi_rtl:1.0 qspi0
create_bd_intf_port -mode Master -vlnv analog.com:interface:if_qspi_rtl:1.0 qspi1
create_bd_intf_port -mode Master -vlnv analog.com:interface:if_qsfp_rtl:1.0 qsfp
create_bd_intf_port -mode Master -vlnv analog.com:interface:if_i2c_rtl:1.0 i2c

create_bd_port -dir O -from 0 -to 0 -type rst qsfp_rst
create_bd_port -dir O fpga_boot
create_bd_port -dir O -type clk qspi_clk
create_bd_port -dir I -type rst ptp_rst
set_property CONFIG.POLARITY ACTIVE_HIGH [get_bd_ports ptp_rst]
create_bd_port -dir I -type clk qsfp_mgt_refclk
create_bd_port -dir I -type clk qsfp_mgt_refclk_bufg

create_bd_port -dir O -type clk clk_125mhz
create_bd_port -dir O -type clk clk_250mhz

ad_connect clk_wiz_125mhz/clk_out1 clk_125mhz
ad_connect sys_250m_clk clk_250mhz

ad_connect corundum_core/m_axis_tx ethernet_core/axis_eth_tx
ad_connect corundum_core/s_axis_rx ethernet_core/axis_eth_rx
ad_connect corundum_core/ctrl_reg ethernet_core/ctrl_reg
ad_connect corundum_core/flow_control_tx ethernet_core/flow_control_tx
ad_connect corundum_core/flow_control_rx ethernet_core/flow_control_rx
ad_connect corundum_core/ethernet_ptp_tx ethernet_core/ethernet_ptp_tx
ad_connect corundum_core/ethernet_ptp_rx ethernet_core/ethernet_ptp_rx
ad_connect corundum_core/axis_tx_ptp ethernet_core/axis_tx_ptp

ad_connect corundum_core/s_axis_stat_tvalid GND
ad_connect corundum_core/ddr_clk GND
ad_connect corundum_core/ddr_rst GND
ad_connect corundum_core/ddr_status GND
ad_connect corundum_core/hbm_clk GND
ad_connect corundum_core/hbm_rst GND
ad_connect corundum_core/hbm_status GND
ad_connect corundum_core/app_jtag_tdi GND
ad_connect corundum_core/app_jtag_tms GND
ad_connect corundum_core/app_jtag_tck GND
ad_connect corundum_core/app_gpio_in GND

ad_connect corundum_core/clk sys_250m_clk
ad_connect corundum_core/rst sys_250m_reset
ad_connect corundum_core/tx_clk ethernet_core/eth_tx_clk
ad_connect corundum_core/tx_rst ethernet_core/eth_tx_rst
ad_connect corundum_core/rx_clk ethernet_core/eth_rx_clk
ad_connect corundum_core/rx_rst ethernet_core/eth_rx_rst
ad_connect corundum_core/ptp_clk qsfp_mgt_refclk_bufg
ad_connect corundum_core/ptp_rst ptp_rst
ad_connect corundum_core/ptp_sample_clk clk_wiz_125mhz/clk_out1

ad_connect ethernet_core/clk sys_250m_clk
ad_connect ethernet_core/rst sys_250m_reset
ad_connect ethernet_core/clk_125mhz clk_wiz_125mhz/clk_out1
ad_connect ethernet_core/rst_125mhz sys_125m_rstgen/peripheral_reset
ad_connect ethernet_core/qsfp_drp_clk clk_wiz_125mhz/clk_out1
ad_connect ethernet_core/qsfp_drp_rst sys_125m_rstgen/peripheral_reset
ad_connect ethernet_core/qsfp_mgt_refclk qsfp_mgt_refclk
ad_connect ethernet_core/qsfp_mgt_refclk_bufg qsfp_mgt_refclk_bufg
ad_connect ethernet_core/qsfp_rst qsfp_rst
ad_connect ethernet_core/fpga_boot fpga_boot
ad_connect ethernet_core/qspi_clk qspi_clk

ad_connect ethernet_core/qspi0 qspi0
ad_connect ethernet_core/qspi1 qspi1
ad_connect ethernet_core/qsfp qsfp
ad_connect ethernet_core/i2c i2c

ad_cpu_interconnect 0x50000000 corundum_core s_axil_ctrl
ad_cpu_interconnect 0x51000000 corundum_core s_axil_app_ctrl
ad_cpu_interconnect 0x52000000 axi_gpio_0
# ad_cpu_interconnect 0x52000000 corundum_reset_gpio/s_axi

ad_mem_hp1_interconnect sys_250m_clk corundum_core/m_axi

ad_cpu_interrupt "ps-5" "mb-5" corundum_core/irq

delete_bd_objs [get_bd_intf_ports iic_main] [get_bd_cells axi_iic_main]
ad_connect sys_concat_intc/In9 GND
