###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set adc_offload_type 0                        ; ## BRAM
set adc_offload_size [expr 2 * 1024]          ; ## 2 KB

set dac_offload_type 1                        ; ## BRAM
set dac_offload_size [expr 2*1024*1024*1024]  ; ## 2 GB

source ../common/adrv9009zu11eg_bd.tcl
source ../common/adrv2crr_fmc_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

set sys_cstring "RX:M=$ad_project_params(RX_JESD_M)\
L=$ad_project_params(RX_JESD_L)\
S=$ad_project_params(RX_JESD_S)\
TX:M=$ad_project_params(TX_JESD_M)\
L=$ad_project_params(TX_JESD_L)\
S=$ad_project_params(TX_JESD_S)\
RX_OS:M=$ad_project_params(RX_OS_JESD_M)\
L=$ad_project_params(RX_OS_JESD_L)\
S=$ad_project_params(RX_OS_JESD_S)"

sysid_gen_sys_init_file $sys_cstring

# Stingray

create_bd_port -dir O sys_clk
ad_connect sys_ps8/pl_clk0 sys_clk

# SPI and IIC for PMOD0 and PMOD1 (Stingray 0)
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_pmod
ad_ip_instance axi_iic axi_iic_pmod
ad_connect iic_pmod axi_iic_pmod/iic

ad_cpu_interrupt ps-14 mb-8 axi_iic_pmod/iic2intc_irpt
ad_cpu_interconnect 0x45100000 axi_iic_pmod

create_bd_port -dir O -from 7 -to 0 spi_pmod_csn_o
create_bd_port -dir I -from 7 -to 0 spi_pmod_csn_i
create_bd_port -dir I spi_pmod_clk_i
create_bd_port -dir O spi_pmod_clk_o
create_bd_port -dir I spi_pmod_sdo_i
create_bd_port -dir O spi_pmod_sdo_o
create_bd_port -dir I spi_pmod_sdi_i

# SPI at 10/16 = 625 KHz
ad_ip_instance axi_quad_spi axi_spi_pmod
ad_ip_parameter axi_spi_pmod CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_pmod CONFIG.C_NUM_SS_BITS 8
ad_ip_parameter axi_spi_pmod CONFIG.C_SCK_RATIO 16

ad_connect spi_pmod_csn_i axi_spi_pmod/ss_i
ad_connect spi_pmod_csn_o axi_spi_pmod/ss_o
ad_connect spi_pmod_clk_i axi_spi_pmod/sck_i
ad_connect spi_pmod_clk_o axi_spi_pmod/sck_o
ad_connect spi_pmod_sdo_i axi_spi_pmod/io0_i
ad_connect spi_pmod_sdo_o axi_spi_pmod/io0_o
ad_connect spi_pmod_sdi_i axi_spi_pmod/io1_i

ad_connect sys_ps8/pl_clk3 axi_spi_pmod/ext_spi_clk

ad_cpu_interrupt ps-15 mb-15 axi_spi_pmod/ip2intc_irpt
ad_cpu_interconnect 0x45200000 axi_spi_pmod

# SPI and IIC for PMOD0 and PMOD1 (Stingray 1)
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_pmod_2
ad_ip_instance axi_iic axi_iic_2_pmod
ad_connect iic_pmod_2 axi_iic_2_pmod/iic

ad_cpu_interrupt ps-2 mb-2 axi_iic_2_pmod/iic2intc_irpt
ad_cpu_interconnect 0x45300000 axi_iic_2_pmod

create_bd_port -dir O -from 7 -to 0 spi_pmod_2_csn_o
create_bd_port -dir I -from 7 -to 0 spi_pmod_2_csn_i
create_bd_port -dir I spi_pmod_2_clk_i
create_bd_port -dir O spi_pmod_2_clk_o
create_bd_port -dir I spi_pmod_2_sdo_i
create_bd_port -dir O spi_pmod_2_sdo_o
create_bd_port -dir I spi_pmod_2_sdi_i

# SPI at 10/16 = 625 KHz
ad_ip_instance axi_quad_spi axi_spi_pmod_2
ad_ip_parameter axi_spi_pmod_2 CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_pmod_2 CONFIG.C_NUM_SS_BITS 8
ad_ip_parameter axi_spi_pmod_2 CONFIG.C_SCK_RATIO 16

ad_connect spi_pmod_2_csn_i axi_spi_pmod_2/ss_i
ad_connect spi_pmod_2_csn_o axi_spi_pmod_2/ss_o
ad_connect spi_pmod_2_clk_i axi_spi_pmod_2/sck_i
ad_connect spi_pmod_2_clk_o axi_spi_pmod_2/sck_o
ad_connect spi_pmod_2_sdo_i axi_spi_pmod_2/io0_i
ad_connect spi_pmod_2_sdo_o axi_spi_pmod_2/io0_o
ad_connect spi_pmod_2_sdi_i axi_spi_pmod_2/io1_i

ad_connect sys_ps8/pl_clk3 axi_spi_pmod_2/ext_spi_clk

# TODO:
ad_cpu_interrupt ps-3 mb-3 axi_spi_pmod_2/ip2intc_irpt
ad_cpu_interconnect 0x45400000 axi_spi_pmod_2

# SPI for FMC interposer
create_bd_port -dir O -from 7 -to 0 spi_fmc_csn_o
create_bd_port -dir I -from 7 -to 0 spi_fmc_csn_i
create_bd_port -dir I spi_fmc_clk_i
create_bd_port -dir O spi_fmc_clk_o
create_bd_port -dir I spi_fmc_sdo_i
create_bd_port -dir O spi_fmc_sdo_o
create_bd_port -dir I spi_fmc_sdi_i

# SPI at 100/16 = 6.25 MHz
ad_ip_instance axi_quad_spi axi_spi_fmc
ad_ip_parameter axi_spi_fmc CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_spi_fmc CONFIG.C_NUM_SS_BITS 8
ad_ip_parameter axi_spi_fmc CONFIG.C_SCK_RATIO 16
ad_ip_parameter axi_spi_fmc CONFIG.Multiples16 1

ad_connect spi_fmc_csn_i axi_spi_fmc/ss_i
ad_connect spi_fmc_csn_o axi_spi_fmc/ss_o
ad_connect spi_fmc_clk_i axi_spi_fmc/sck_i
ad_connect spi_fmc_clk_o axi_spi_fmc/sck_o
ad_connect spi_fmc_sdo_i axi_spi_fmc/io0_i
ad_connect spi_fmc_sdo_o axi_spi_fmc/io0_o
ad_connect spi_fmc_sdi_i axi_spi_fmc/io1_i

ad_connect sys_ps8/pl_clk0 axi_spi_fmc/ext_spi_clk

ad_cpu_interrupt ps-4 mb-4 axi_spi_fmc/ip2intc_irpt

ad_cpu_interconnect 0x45500000 axi_spi_fmc

# GPIOs
create_bd_port -dir I -from 31 -to 0 fmc_gpio0_i
create_bd_port -dir O -from 31 -to 0 fmc_gpio0_o
create_bd_port -dir O -from 31 -to 0 fmc_gpio0_t
create_bd_port -dir I -from 31 -to 0 fmc_gpio2_i
create_bd_port -dir O -from 31 -to 0 fmc_gpio2_o
create_bd_port -dir O -from 31 -to 0 fmc_gpio2_t

ad_ip_instance axi_gpio axi_fmc_gpio
ad_ip_parameter axi_fmc_gpio CONFIG.C_IS_DUAL 1
ad_ip_parameter axi_fmc_gpio CONFIG.C_GPIO_WIDTH 32
ad_ip_parameter axi_fmc_gpio CONFIG.C_GPIO2_WIDTH 32
ad_ip_parameter axi_fmc_gpio CONFIG.C_INTERRUPT_PRESENT 1

ad_connect fmc_gpio0_i axi_fmc_gpio/gpio_io_i
ad_connect fmc_gpio0_o axi_fmc_gpio/gpio_io_o
ad_connect fmc_gpio0_t axi_fmc_gpio/gpio_io_t
ad_connect fmc_gpio2_i axi_fmc_gpio/gpio2_io_i
ad_connect fmc_gpio2_o axi_fmc_gpio/gpio2_io_o
ad_connect fmc_gpio2_t axi_fmc_gpio/gpio2_io_t

ad_cpu_interconnect 0x46000000 axi_fmc_gpio

# interconnect (mem/dac)

ad_cpu_interrupt ps-5 mb-5 axi_fmc_gpio/ip2intc_irpt

# Connect TDD
create_bd_port -dir I tdd_sync
create_bd_port -dir O tdd_enabled
create_bd_port -dir O tdd_rx_en
create_bd_port -dir O tdd_tx_en
create_bd_port -dir O tdd_tx_stingray_en
create_bd_port -dir O tdd_channel_0
create_bd_port -dir O tdd_channel_1
create_bd_port -dir O tdd_sync_out
create_bd_port -dir O tdd_pa_on
create_bd_port -dir O tdd_tr
create_bd_port -dir O tdd_xud_trx0
create_bd_port -dir O tdd_xud_trx1
create_bd_port -dir O tdd_xud_trx2
create_bd_port -dir O tdd_xud_trx3
create_bd_port -dir O tdd_rx_load
create_bd_port -dir O tdd_tx_load

if {$TDD_SUPPORT} {
  set tdd_sync_in_net [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_pins axi_tdd_0/sync_in]]]
  set tdd_sync_in_pin [get_bd_pins axi_tdd_0/sync_in]

  ad_disconnect $tdd_sync_in_net               $tdd_sync_in_pin

  ad_ip_parameter axi_adrv9009_som_rx_dma CONFIG.SYNC_TRANSFER_START 1
  # ad_ip_parameter axi_adrv9009_som_rx_dma CONFIG.DMA_LENGTH_WIDTH 30

  ad_connect axi_tdd_0/sync_in tdd_sync
  ad_connect axi_tdd_0/tdd_channel_1  axi_adrv9009_som_rx_dma/s_axis_user
  ad_connect axi_tdd_0/tdd_channel_2  tdd_enabled
  ad_connect axi_tdd_0/tdd_channel_3  tdd_rx_en
  ad_connect axi_tdd_0/tdd_channel_4  tdd_tx_en
  ad_connect axi_tdd_0/tdd_channel_5  tdd_tx_stingray_en

  ad_connect axi_tdd_0/tdd_channel_0  tdd_channel_0
  ad_connect axi_tdd_0/tdd_channel_1  tdd_channel_1
  ad_connect axi_tdd_0/sync_out       tdd_sync_out

  ad_connect axi_tdd_0/tdd_channel_6  tdd_pa_on
  ad_connect axi_tdd_0/tdd_channel_7  tdd_tr

  ad_connect axi_tdd_0/tdd_channel_8  tdd_xud_trx0
  ad_connect axi_tdd_0/tdd_channel_9  tdd_xud_trx1
  ad_connect axi_tdd_0/tdd_channel_10 tdd_xud_trx2
  ad_connect axi_tdd_0/tdd_channel_11 tdd_xud_trx3

  ad_connect axi_tdd_0/tdd_channel_12 tdd_rx_load
  ad_connect axi_tdd_0/tdd_channel_13 tdd_tx_load
}

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
  C_AXI_DATA_WIDTH 32 \
  C_INTERFACE_MODE 1 \
  C_INTERFACE_TYPE 3 \
]

# Aurora

create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 gt_diff_refclk
create_bd_intf_port -mode Slave -vlnv xilinx.com:display_aurora:GT_Serial_Transceiver_Pins_RX_rtl:1.0 gt_serial_rx
create_bd_intf_port -mode Master -vlnv xilinx.com:display_aurora:GT_Serial_Transceiver_Pins_TX_rtl:1.0 gt_serial_tx

set_property -dict [list CONFIG.FREQ_HZ {122880000}] [get_bd_intf_ports gt_diff_refclk]

ad_ip_instance aurora_8b10b aurora_8b10b [list \
  SupportLevel 1 \
  C_AURORA_LANES 2 \
  C_LINE_RATE 2.4576 \
  C_REFCLK_FREQUENCY 122.88 \
  interface_mode {Streaming} \
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

# Additional interrupt controller for aurora
ad_ip_instance axi_intc axi_intc [list \
  C_IRQ_CONNECTION 1 \
]

ad_ip_instance xlconcat xlconcat_0
set_property CONFIG.NUM_PORTS {4} [get_bd_cells xlconcat_0]

for {set j 0} {$j < 4} {incr j} {
  ad_ip_instance xlslice xlslice_${j}
  set_property -dict [list \
    CONFIG.DIN_FROM ${j} \
    CONFIG.DIN_TO ${j} \
    CONFIG.DIN_WIDTH {4} \
  ] [get_bd_cells xlslice_${j}]

  ad_connect axi_chip2chip/axi_c2c_s2m_intr_out xlslice_${j}/Din
  ad_connect xlslice_${j}/Dout xlconcat_0/In${j}
}

ad_connect xlconcat_0/dout axi_intc/intr

# Interconnect

ad_cpu_interconnect 0x4A000000 cmd_spi
ad_cpu_interconnect 0x4A100000 axi_intc
ad_cpu_interconnect 0x90000000 axi_chip2chip

set_property range 64K [get_bd_addr_segs {sys_ps8/Data/SEG_data_axi_chip2chip}]

# Interrupts

ad_cpu_interrupt ps-0 mb-0 cmd_spi/ip2intc_irpt
ad_cpu_interrupt ps-1 mb-x axi_intc/irq

assign_bd_address
