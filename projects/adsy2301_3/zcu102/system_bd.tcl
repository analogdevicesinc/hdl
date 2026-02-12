###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

source ../common/adsy2301_3_carrier_bd.tcl

# Chip2chip

ad_ip_instance axi_chip2chip axi_chip2chip [list \
  C_AXI_STB_WIDTH 16 \
  C_AXI_DATA_WIDTH 32 \
  C_INTERFACE_MODE 1 \
  C_INTERFACE_TYPE 3 \
]

# Aurora

create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 gt_diff_refclk
create_bd_intf_port -mode Slave -vlnv xilinx.com:display_aurora:GT_Serial_Transceiver_Pins_RX_rtl:1.0 gt_serial_rx
create_bd_intf_port -mode Master -vlnv xilinx.com:display_aurora:GT_Serial_Transceiver_Pins_TX_rtl:1.0 gt_serial_tx

set_property -dict [list CONFIG.FREQ_HZ {156250000}] [get_bd_intf_ports gt_diff_refclk]

ad_ip_instance aurora_8b10b aurora_8b10b [list \
  SupportLevel 1 \
  C_AURORA_LANES 2 \
  C_LINE_RATE 3.125 \
  C_REFCLK_FREQUENCY 156.25 \
  interface_mode {Streaming} \
  C_START_QUAD {Quad_X1Y2} \
  C_START_LANE {X1Y9} \
  C_REFCLK_SOURCE {MGTREFCLK0 of Quad X1Y2} \
  C_GT_LOC_2 2 \
  CHANNEL_ENABLE {X1Y9 X1Y10} \
]

ad_connect gt_diff_refclk aurora_8b10b/GT_DIFF_REFCLK1
ad_connect gt_serial_rx aurora_8b10b/GT_SERIAL_RX
ad_connect gt_serial_tx aurora_8b10b/GT_SERIAL_TX

ad_connect axi_chip2chip/axi_c2c_phy_clk aurora_8b10b/user_clk_out
ad_connect axi_chip2chip/axi_c2c_aurora_channel_up aurora_8b10b/channel_up
ad_connect aurora_8b10b/init_clk_in axi_chip2chip/aurora_init_clk
ad_connect axi_chip2chip/aurora_mmcm_not_locked aurora_8b10b/pll_not_locked_out
ad_connect axi_chip2chip/AXIS_TX aurora_8b10b/USER_DATA_S_AXI_TX
ad_connect axi_chip2chip/AXIS_RX aurora_8b10b/USER_DATA_M_AXI_RX
ad_connect axi_chip2chip/aurora_pma_init_in sys_cpu_reset
ad_connect sys_ps8/pl_clk0 aurora_8b10b/init_clk_in
ad_connect aurora_8b10b/reset axi_chip2chip/aurora_reset_pb
ad_connect aurora_8b10b/gt_reset sys_cpu_reset

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

set_property range 64K [get_bd_addr_segs {sys_ps8/Data/SEG_data_axi_chip2chip}]

# Interrupts

disconnect_bd_net /GND_1_dout [get_bd_pins sys_concat_intc_0/In5]
disconnect_bd_net /GND_1_dout [get_bd_pins sys_concat_intc_0/In6]
disconnect_bd_net /GND_1_dout [get_bd_pins sys_concat_intc_0/In7]
ad_ip_parameter sys_concat_intc_0 CONFIG.NUM_PORTS 5

ad_cpu_interrupt ps-0 mb-0 cmd_spi/ip2intc_irpt
ad_cpu_interrupt ps-1 mb-1 axi_chip2chip/axi_c2c_s2m_intr_out

# System ID

source $ad_hdl_dir/projects/scripts/adi_pd.tcl

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 10
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 10

sysid_gen_sys_init_file
