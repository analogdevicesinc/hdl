###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

source ../common/adsy2301_3_bd.tcl

# GPIO

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_pins

create_bd_port -dir I -from 5 -to 0 gpio_pins_i
create_bd_port -dir O -from 5 -to 0 gpio_pins_o
create_bd_port -dir O -from 5 -to 0 gpio_pins_t

# 0 - output
# 1 - input
# 0. FPGA_BOOT_GOOD / INIT_B - bidirectional - low / high / input (high good / low bad)
# 1. RX_LOAD - out
# 2. TX_LOAD - out
# 3. TR_PULSE - out
# 4. UDC_PG - in
# 5. FPGA_TRIG - out

ad_ip_instance axi_gpio gpio_ctrl [list \
  C_IS_DUAL 0 \
  C_GPIO_WIDTH 6 \
  C_TRI_DEFAULT 0x00000010 \
]

ad_connect gpio_ctrl/gpio_io_i gpio_pins_i
ad_connect gpio_ctrl/gpio_io_o gpio_pins_o
ad_connect gpio_ctrl/gpio_io_t gpio_pins_t

# CMD SPI

create_bd_port -dir O cmd_spi_sclk
create_bd_port -dir O cmd_spi_csb
create_bd_port -dir O cmd_spi_mosi
create_bd_port -dir I cmd_spi_miso

ad_ip_instance axi_quad_spi cmd_spi [list \
  C_USE_STARTUP 0 \
  C_NUM_SS_BITS 1 \
  C_SCK_RATIO 2 \
]

ad_connect cmd_spi/sck_o cmd_spi_sclk
ad_connect cmd_spi/ss_o cmd_spi_csb
ad_connect cmd_spi/io0_o cmd_spi_mosi
ad_connect cmd_spi/io1_i cmd_spi_miso

# Chip2chip

ad_ip_instance axi_chip2chip axi_chip2chip [list \
  C_AXI_STB_WIDTH 16 \
  C_AXI_DATA_WIDTH 128 \
  C_NUM_OF_IO 32 \
  C_INTERFACE_MODE 1 \
  C_INTERFACE_TYPE 2 \
  C_AURORA_WIDTH 2 \
]

# Aurora

create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 gt_diff_refclk
create_bd_intf_port -mode Slave -vlnv xilinx.com:display_aurora64b66b:GT_Serial_Transceiver_Pins_RX_rtl:1.0 gt_serial_rx
create_bd_intf_port -mode Master -vlnv xilinx.com:display_aurora64b66b:GT_Serial_Transceiver_Pins_TX_rtl:1.0 gt_serial_tx

set_property -dict [list CONFIG.FREQ_HZ {300000000}] [get_bd_intf_ports gt_diff_refclk]

ad_ip_instance aurora_64b66b aurora_64b66b [list \
  SupportLevel 1 \
  C_AURORA_LANES 2 \
  C_LINE_RATE 12.5 \
  C_REFCLK_FREQUENCY 300 \
  interface_mode {Streaming} \
  C_START_QUAD {Quad_X1Y2} \
  C_START_LANE {X1Y9} \
  C_REFCLK_SOURCE {MGTREFCLK0_of_Quad_X1Y2} \
  C_GT_LOC_2 2 \
  CHANNEL_ENABLE {X1Y9 X1Y10} \
]

ad_connect gt_diff_refclk aurora_64b66b/GT_DIFF_REFCLK1
ad_connect gt_serial_rx aurora_64b66b/GT_SERIAL_RX
ad_connect gt_serial_tx aurora_64b66b/GT_SERIAL_TX

ad_connect axi_chip2chip/axi_c2c_phy_clk aurora_64b66b/user_clk_out
ad_connect axi_chip2chip/axi_c2c_aurora_channel_up aurora_64b66b/channel_up
ad_connect aurora_64b66b/init_clk axi_chip2chip/aurora_init_clk
ad_connect axi_chip2chip/aurora_mmcm_not_locked aurora_64b66b/mmcm_not_locked_out
ad_connect axi_chip2chip/aurora_reset_pb aurora_64b66b/reset_pb
ad_connect axi_chip2chip/aurora_pma_init_out aurora_64b66b/pma_init
ad_connect axi_chip2chip/AXIS_TX aurora_64b66b/USER_DATA_S_AXIS_TX
ad_connect axi_chip2chip/AXIS_RX aurora_64b66b/USER_DATA_M_AXIS_RX
ad_connect sys_ps8/pl_clk0 aurora_64b66b/init_clk

# Reconfigure PS
# - Additional general SPI clock @ 10 MHz
set_property -dict [list \
  CONFIG.PSU__CRL_APB__PL3_REF_CTRL__FREQMHZ {20} \
  CONFIG.PSU__FPGA_PL3_ENABLE {1} \
] [get_bd_cells sys_ps8]

ad_connect sys_ps8/pl_clk3 cmd_spi/ext_spi_clk

# Interconnect

ad_cpu_interconnect 0x80000000 cmd_spi
ad_cpu_interconnect 0x80010000 gpio_ctrl
ad_cpu_interconnect 0x90000000 axi_chip2chip

# Interrupts

ad_cpu_interrupt ps-0 mb-0 cmd_spi/ip2intc_irpt
