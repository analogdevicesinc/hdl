###############################################################################
## Copyright (C) 2023-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set CACHE_COHERENCY false

# create board design
# default ports

create_bd_port -dir O -from 2 -to 0 spi0_csn
create_bd_port -dir O spi0_sclk
create_bd_port -dir O spi0_mosi
create_bd_port -dir I spi0_miso

create_bd_port -dir O -from 2 -to 0 spi1_csn
create_bd_port -dir O spi1_sclk
create_bd_port -dir O spi1_mosi
create_bd_port -dir I spi1_miso

create_bd_port -dir I -from 31 -to 0 gpio0_i
create_bd_port -dir O -from 31 -to 0 gpio0_o
create_bd_port -dir O -from 31 -to 0 gpio0_t
create_bd_port -dir I -from 31 -to 0 gpio1_i
create_bd_port -dir O -from 31 -to 0 gpio1_o
create_bd_port -dir O -from 31 -to 0 gpio1_t
create_bd_port -dir I -from 31 -to 0 gpio2_i
create_bd_port -dir O -from 31 -to 0 gpio2_o
create_bd_port -dir O -from 31 -to 0 gpio2_t

# instance: versal_cips and NoC
ad_ip_instance versal_cips sys_cips

apply_bd_automation -rule xilinx.com:bd_rule:cips -config { \
    board_preset {Yes} \
    boot_config {Custom} \
    configure_noc {Add new AXI NoC} \
    debug_config {JTAG} \
    design_flow {Full System} \
    mc_type {LPDDR} \
    num_mc_ddr {None} \
    num_mc_lpddr {1} \
    pl_clocks {2} \
    pl_resets {1} \
}  [get_bd_cells sys_cips]

set_property -dict [list \
  CONFIG.CLOCK_MODE {Custom} \
  CONFIG.CPM_CONFIG { \
    CPM_PCIE0_MODES {None} \
  } \
  CONFIG.DEVICE_INTEGRITY_MODE {Custom} \
  CONFIG.IO_CONFIG_MODE {Custom} \
  CONFIG.PS_PL_CONNECTIVITY_MODE {Custom} \
  CONFIG.PS_PMC_CONFIG { \
    CLOCK_MODE {Custom} \
    DDR_MEMORY_MODE {Connectivity to DDR via NOC} \
    DEBUG_MODE {JTAG} \
    DESIGN_MODE {1} \
    DEVICE_INTEGRITY_MODE {Sysmon temperature voltage and external IO monitoring} \
    IO_CONFIG_MODE {Custom} \
    PMC_CRP_PL0_REF_CTRL_FREQMHZ {100} \
    PMC_GPIO0_MIO_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 0 .. 25}}} \
    PMC_GPIO1_MIO_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 26 .. 51}}} \
    PMC_MIO37 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA high} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
    PMC_QSPI_FBCLK {{ENABLE 1} {IO {PMC_MIO 6}}} \
    PMC_QSPI_PERIPHERAL_DATA_MODE {x4} \
    PMC_QSPI_PERIPHERAL_ENABLE {1} \
    PMC_QSPI_PERIPHERAL_MODE {Dual Parallel} \
    PMC_REF_CLK_FREQMHZ {33.3333} \
    PMC_SD1 {{CD_ENABLE 1} {CD_IO {PMC_MIO 28}} {POW_ENABLE 1} {POW_IO {PMC_MIO 51}} {RESET_ENABLE 0} {RESET_IO {PMC_MIO 12}} {WP_ENABLE 0} {WP_IO {PMC_MIO 1}}} \
    PMC_SD1_PERIPHERAL {{CLK_100_SDR_OTAP_DLY 0x3} {CLK_200_SDR_OTAP_DLY 0x2} {CLK_50_DDR_ITAP_DLY 0x2A} {CLK_50_DDR_OTAP_DLY 0x3} {CLK_50_SDR_ITAP_DLY 0x25} {CLK_50_SDR_OTAP_DLY 0x4} {ENABLE 1} {IO {PMC_MIO 26 .. 36}}} \
    PMC_SD1_SLOT_TYPE {SD 3.0 AUTODIR} \
    PMC_USE_PMC_NOC_AXI0 {1} \
    PS_BOARD_INTERFACE {ps_pmc_fixed_io} \
    PS_ENET0_MDIO {{ENABLE 1} {IO {PS_MIO 24 .. 25}}} \
    PS_ENET0_PERIPHERAL {{ENABLE 1} {IO {PS_MIO 0 .. 11}}} \
    PS_GEN_IPI0_ENABLE {1} \
    PS_GEN_IPI0_MASTER {A72} \
    PS_GEN_IPI1_ENABLE {1} \
    PS_GEN_IPI2_ENABLE {1} \
    PS_GEN_IPI3_ENABLE {1} \
    PS_GEN_IPI4_ENABLE {1} \
    PS_GEN_IPI5_ENABLE {1} \
    PS_GEN_IPI6_ENABLE {1} \
    PS_GPIO_EMIO_PERIPHERAL_ENABLE {1} \
    PS_HSDP_EGRESS_TRAFFIC {JTAG} \
    PS_HSDP_INGRESS_TRAFFIC {JTAG} \
    PS_HSDP_MODE {NONE} \
    PS_I2C0_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 46 .. 47}}} \
    PS_I2C1_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 44 .. 45}}} \
    PS_I2CSYSMON_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 39 .. 40}}} \
    PS_IRQ_USAGE {{CH0 1} {CH1 1} {CH10 1} {CH11 1} {CH12 1} {CH13 1} {CH14 1} {CH15 1} {CH2 1} {CH3 1} {CH4 1} {CH5 1} {CH6 1} {CH7 1} {CH8 1} {CH9 1}} \
    PS_MIO7 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
    PS_MIO9 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
    PS_NUM_FABRIC_RESETS {1} \
    PS_PCIE_EP_RESET1_IO {PS_MIO 18} \
    PS_PCIE_EP_RESET2_IO {PS_MIO 19} \
    PS_PCIE_RESET {ENABLE 1} \
    PS_PL_CONNECTIVITY_MODE {Custom} \
    PS_SPI0 {{GRP_SS0_ENABLE 1} {GRP_SS0_IO {EMIO}} {GRP_SS1_ENABLE 1} {GRP_SS1_IO {EMIO}} {GRP_SS2_ENABLE 1} {GRP_SS2_IO {EMIO}} {PERIPHERAL_ENABLE 1} {PERIPHERAL_IO EMIO}} \
    PS_SPI1 {{GRP_SS0_ENABLE 1} {GRP_SS0_IO {EMIO}} {GRP_SS1_ENABLE 1} {GRP_SS1_IO {EMIO}} {GRP_SS2_ENABLE 1} {GRP_SS2_IO {EMIO}} {PERIPHERAL_ENABLE 1} {PERIPHERAL_IO EMIO}} \
    PS_UART0_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 42 .. 43}}} \
    PS_USB3_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 13 .. 25}}} \
    PS_USE_FPD_CCI_NOC {1} \
    PS_USE_FPD_CCI_NOC0 {1} \
    PS_USE_M_AXI_FPD {1} \
    PS_USE_NOC_LPD_AXI0 {1} \
    PS_USE_PMCPL_CLK0 {1} \
    PS_USE_PMCPL_CLK1 {1} \
    SMON_ALARMS {Set_Alarms_On} \
    SMON_ENABLE_TEMP_AVERAGING {0} \
    SMON_INTERFACE_TO_USE {I2C} \
    SMON_MEAS126 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCAUX} {SUPPLY_NUM 0}} \
    SMON_MEAS127 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCAUX_PMC} {SUPPLY_NUM 1}} \
    SMON_MEAS148 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_PMC} {SUPPLY_NUM 2}} \
    SMON_MEAS149 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_PSFP} {SUPPLY_NUM 3}} \
    SMON_MEAS150 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_PSLP} {SUPPLY_NUM 4}} \
    SMON_MEAS152 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_SOC} {SUPPLY_NUM 5}} \
    SMON_MEAS153 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VP_VN} {SUPPLY_NUM 6}} \
    SMON_PMBUS_ADDRESS {0x18} \
    SMON_TEMP_AVERAGING_SAMPLES {0} \
  } \
  CONFIG.PS_PMC_CONFIG_APPLIED {1} \
] [get_bd_cells sys_cips]

set_property -dict [list \
  CONFIG.MC_CHANNEL_INTERLEAVING {true} \
  CONFIG.MC_CH_INTERLEAVING_SIZE {256_Bytes} \
] [get_bd_cells axi_noc_0]

ad_ip_instance proc_sys_reset sys_rstgen
ad_ip_parameter sys_rstgen CONFIG.C_EXT_RST_WIDTH 1
ad_ip_instance proc_sys_reset sys_350m_rstgen
ad_ip_parameter sys_350m_rstgen CONFIG.C_EXT_RST_WIDTH 1

# system reset/clock definitions

ad_connect  sys_cpu_clk sys_cips/pl0_ref_clk
ad_connect  sys_350m_clk sys_cips/pl1_ref_clk

ad_connect  sys_cips/pl0_resetn sys_rstgen/ext_reset_in
ad_connect  sys_cpu_clk sys_rstgen/slowest_sync_clk
ad_connect  sys_cips/pl0_resetn sys_350m_rstgen/ext_reset_in
ad_connect  sys_350m_clk sys_350m_rstgen/slowest_sync_clk

ad_connect  sys_cpu_reset sys_rstgen/peripheral_reset
ad_connect  sys_cpu_resetn sys_rstgen/peripheral_aresetn
ad_connect  sys_350m_reset sys_350m_rstgen/peripheral_reset
ad_connect  sys_350m_resetn sys_350m_rstgen/peripheral_aresetn

# gpio
ad_connect gpio0_i sys_cips/lpd_gpio_i
ad_connect gpio0_o sys_cips/lpd_gpio_o
ad_connect gpio0_t sys_cips/lpd_gpio_t

# gpio extension witn 64 IOs
ad_ip_instance axi_gpio axi_gpio
ad_ip_parameter axi_gpio CONFIG.C_IS_DUAL 1
ad_ip_parameter axi_gpio CONFIG.C_GPIO_WIDTH 32
ad_ip_parameter axi_gpio CONFIG.C_GPIO2_WIDTH 32
ad_ip_parameter axi_gpio CONFIG.C_INTERRUPT_PRESENT 1

ad_connect gpio1_i axi_gpio/gpio_io_i
ad_connect gpio1_o axi_gpio/gpio_io_o
ad_connect gpio1_t axi_gpio/gpio_io_t
ad_connect gpio2_i axi_gpio/gpio2_io_i
ad_connect gpio2_o axi_gpio/gpio2_io_o
ad_connect gpio2_t axi_gpio/gpio2_io_t

## generic system clocks&resets pointers

set sys_cpu_clk           [get_bd_nets sys_cpu_clk]
set sys_dma_clk           [get_bd_nets sys_350m_clk]

set sys_cpu_reset         [get_bd_nets sys_cpu_reset]
set sys_cpu_resetn        [get_bd_nets sys_cpu_resetn]
set sys_dma_reset         [get_bd_nets sys_350m_reset]
set sys_dma_resetn        [get_bd_nets sys_350m_resetn]

# spi

ad_ip_instance xlconcat spi0_csn_sources
ad_ip_parameter spi0_csn_sources config.num_ports {3}
ad_connect spi0_csn_sources/dout spi0_csn

ad_connect  sys_cips/spi0_sck_o spi0_sclk
ad_connect  sys_cips/spi0_sck_i GND
ad_connect  sys_cips/spi0_io0_o spi0_mosi
ad_connect  sys_cips/spi0_io0_i spi0_miso
ad_connect  sys_cips/spi0_io1_i GND
ad_connect  sys_cips/spi0_ss_o  spi0_csn_sources/in0
ad_connect  sys_cips/spi0_ss1_o spi0_csn_sources/in1
ad_connect  sys_cips/spi0_ss2_o spi0_csn_sources/in2
ad_connect  sys_cips/spi0_ss_i  VCC

ad_ip_instance xlconcat spi1_csn_sources
ad_ip_parameter spi1_csn_sources config.num_ports {3}
ad_connect spi1_csn_sources/dout spi1_csn

ad_connect  sys_cips/spi1_sck_o spi1_sclk
ad_connect  sys_cips/spi1_sck_i GND
ad_connect  sys_cips/spi1_io0_o spi1_mosi
ad_connect  sys_cips/spi1_io0_i spi1_miso
ad_connect  sys_cips/spi1_io1_i GND
ad_connect  sys_cips/spi1_ss_o  spi1_csn_sources/in0
ad_connect  sys_cips/spi1_ss1_o spi1_csn_sources/in1
ad_connect  sys_cips/spi1_ss2_o spi1_csn_sources/in2
ad_connect  sys_cips/spi1_ss_i  VCC

# system id

ad_ip_instance axi_sysid axi_sysid_0
ad_ip_instance sysid_rom rom_sys_0

ad_connect  axi_sysid_0/rom_addr   	    rom_sys_0/rom_addr
ad_connect  axi_sysid_0/sys_rom_data   	rom_sys_0/rom_data
ad_connect  sys_cpu_clk                 rom_sys_0/clk

# interconnect

ad_cpu_interconnect 0x44000000 axi_gpio
ad_cpu_interconnect 0x45000000 axi_sysid_0

# interrupts

ad_cpu_interrupt ps-0 mb-xx axi_gpio/ip2intc_irpt
