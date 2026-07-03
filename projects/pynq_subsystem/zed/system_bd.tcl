###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/scripts/adi_pd.tcl

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr
create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 fixed_io

# instance: sys_ps7

ad_ip_instance processing_system7 sys_ps7 [list \
    PCW_EN_RST1_PORT 0 \
    PCW_USE_DMA0 0 \
    PCW_USE_DMA1 0 \
    PCW_USE_DMA2 0 \
    PCW_USE_S_AXI_GP0 1 \
    PCW_USE_S_AXI_HP0 1 \
    PCW_USE_S_AXI_HP2 1 \
    PCW_GPIO_MIO_GPIO_ENABLE 0 \
    PCW_I2C0_PERIPHERAL_ENABLE 1 \
    PCW_SPI0_PERIPHERAL_ENABLE 0 \
    PCW_SPI1_PERIPHERAL_ENABLE 0 \
    PCW_GPIO_EMIO_GPIO_IO 7 \
    PCW_QSPI_GRP_SINGLE_SS_ENABLE 1 \
    PCW_EN_CLK1_PORT 1 \
    PCW_EN_CLK2_PORT 1 \
    PCW_EN_CLK3_PORT 1 \
    PCW_FPGA0_PERIPHERAL_FREQMHZ 100.0 \
    PCW_FPGA1_PERIPHERAL_FREQMHZ 142.0 \
    PCW_FPGA2_PERIPHERAL_FREQMHZ 200 \
    PCW_FPGA3_PERIPHERAL_FREQMHZ 100 \
    PCW_IMPORT_BOARD_PRESET ZedBoard \
    PCW_TTC0_PERIPHERAL_ENABLE 0 \
    PCW_USE_FABRIC_INTERRUPT 1 \
    PCW_IRQ_F2P_INTR 1 \
    PCW_GPIO_EMIO_GPIO_ENABLE 1 \
    PCW_IRQ_F2P_MODE REVERSE \
    PCW_SPI0_SPI0_IO EMIO \
    PCW_SPI1_SPI1_IO EMIO \
]
ad_connect  ddr           sys_ps7/DDR
ad_connect  fixed_io      sys_ps7/FIXED_IO
ad_connect  sys_cpu_clk  sys_ps7/FCLK_CLK0
ad_connect   sys_ps7/S_AXI_GP0_ACLK             sys_cpu_clk
ad_connect   sys_ps7/S_AXI_HP0_ACLK             sys_ps7/FCLK_CLK1
ad_connect   sys_ps7/S_AXI_HP2_ACLK             sys_ps7/FCLK_CLK3

source ../common/connect_pynq_subsystem.tcl

connect_pynq_subsystem 0x42000000 0x41800000
