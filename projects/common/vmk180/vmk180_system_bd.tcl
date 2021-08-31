
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

create_bd_port -dir I -from 31 -to 0 gpio_i
create_bd_port -dir O -from 31 -to 0 gpio_o
create_bd_port -dir O -from 31 -to 0 gpio_tn

# instance: versal_cips
create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips:2.1 sys_cips
apply_bd_automation -rule xilinx.com:bd_rule:versal_cips -config { configure_noc {Add new AXI NoC} num_ddr {1} pcie0_lane_width {None} pcie0_mode {None} pcie0_port_type {Endpoint Device} pcie1_lane_width {None} pcie1_mode {None} pcie1_port_type {Endpoint Device} pl_clocks {1} pl_resets {1}}  [get_bd_cells sys_cips]

set_property -dict [list \
  CONFIG.PMC_QSPI_GRP_FBCLK_ENABLE {1} \
  CONFIG.PMC_QSPI_PERIPHERAL_ENABLE {1} \
  CONFIG.PMC_QSPI_PERIPHERAL_MODE {Dual Parallel} \
  CONFIG.PMC_SD1_PERIPHERAL_ENABLE {1} \
  CONFIG.PMC_SD1_SLOT_TYPE {SD 3.0} \
  CONFIG.PMC_SD1_PERIPHERAL_IO {PMC_MIO 26 .. 36} \
  CONFIG.PMC_SD1_GRP_CD_ENABLE {1} \
  CONFIG.PMC_SD1_GRP_POW_ENABLE {1} \
  CONFIG.PMC_CRP_PL0_REF_CTRL_FREQMHZ {100} \
  CONFIG.PS_USE_PMCPL_CLK1 {1} \
  CONFIG.PMC_CRP_PL1_REF_CTRL_FREQMHZ {350} \
  CONFIG.PS_GPIO_EMIO_PERIPHERAL_ENABLE {1} \
  CONFIG.PS_ENET0_PERIPHERAL_ENABLE {1} \
  CONFIG.PS_ENET0_GRP_MDIO_ENABLE {1} \
  CONFIG.PS_ENET0_PERIPHERAL_IO {PS_MIO 0 .. 11} \
  CONFIG.PS_ENET0_GRP_MDIO_IO {PS_MIO 24 .. 25} \
  CONFIG.PS_ENET1_PERIPHERAL_ENABLE {1} \
  CONFIG.PS_ENET1_GRP_MDIO_ENABLE {0} \
  CONFIG.PS_ENET1_PERIPHERAL_IO {PS_MIO 12 .. 23} \
  CONFIG.PS_ENET1_GRP_MDIO_IO {PMC_MIO 50 .. 51} \
  CONFIG.PS_I2C0_PERIPHERAL_ENABLE {1} \
  CONFIG.PS_I2C0_PERIPHERAL_IO {PMC_MIO 46 .. 47} \
  CONFIG.PS_I2C1_PERIPHERAL_ENABLE {1} \
  CONFIG.PS_I2C1_PERIPHERAL_IO {PMC_MIO 44 .. 45} \
  CONFIG.PS_SPI0_GRP_SS1_ENABLE {1} \
  CONFIG.PS_SPI0_GRP_SS2_ENABLE {1} \
  CONFIG.PS_SPI0_PERIPHERAL_ENABLE {1} \
  CONFIG.PS_SPI0_PERIPHERAL_IO {EMIO} \
  CONFIG.PS_SPI1_GRP_SS1_ENABLE {1} \
  CONFIG.PS_SPI1_GRP_SS2_ENABLE {1} \
  CONFIG.PS_SPI1_PERIPHERAL_ENABLE {1} \
  CONFIG.PS_SPI1_PERIPHERAL_IO {EMIO} \
  CONFIG.PS_TTC1_PERIPHERAL_ENABLE {1} \
  CONFIG.PS_TTC2_PERIPHERAL_ENABLE {1} \
  CONFIG.PS_TTC3_PERIPHERAL_ENABLE {1} \
  CONFIG.PS_UART0_PERIPHERAL_ENABLE {1} \
  CONFIG.PS_UART0_PERIPHERAL_IO {PMC_MIO 42 .. 43} \
  CONFIG.PS_USB3_PERIPHERAL_ENABLE {1} \
  CONFIG.PS_WWDT0_PERIPHERAL_ENABLE {1} \
  CONFIG.PS_WWDT0_PERIPHERAL_IO {EMIO} \
  CONFIG.PS_WWDT0_CLOCK_IO {APB} \
  CONFIG.PS_USE_M_AXI_GP0 {1} \
  CONFIG.PS_M_AXI_GP0_DATA_WIDTH {32} \
  CONFIG.PS_USE_IRQ_8 {1} \
] [get_bd_cells sys_cips]

# NOC
set_property -dict [list \
  CONFIG.MC_BOARD_INTRF_EN {true} \
  CONFIG.MC0_CONFIG_NUM {config17} \
  CONFIG.MC1_CONFIG_NUM {config17} \
  CONFIG.MC2_CONFIG_NUM {config17} \
  CONFIG.MC3_CONFIG_NUM {config17} \
  CONFIG.CH0_DDR4_0_BOARD_INTERFACE {ddr4_dimm1} \
  CONFIG.MC_INPUT_FREQUENCY0 {200.000} \
  CONFIG.MC_INPUTCLK0_PERIOD {5000} \
  CONFIG.MC_MEMORY_DEVICETYPE {UDIMMs} \
  CONFIG.MC_MEMORY_SPEEDGRADE {DDR4-3200AA(22-22-22)} \
  CONFIG.MC_TRCD {13750} \
  CONFIG.MC_TRP {13750} \
  CONFIG.MC_DDR4_2T {Disable} \
  CONFIG.MC_CASLATENCY {22} \
  CONFIG.MC_TRC {45750} \
  CONFIG.MC_TRPMIN {13750} \
  CONFIG.MC_CONFIG_NUM {config17} \
  CONFIG.MC_F1_TRCD {13750} \
  CONFIG.MC_F1_TRCDMIN {13750} \
  CONFIG.MC_F1_LPDDR4_MR1 {0x000} \
  CONFIG.MC_F1_LPDDR4_MR2 {0x000} \
  CONFIG.MC_F1_LPDDR4_MR3 {0x000} \
  CONFIG.MC_F1_LPDDR4_MR11 {0x000} \
  CONFIG.MC_F1_LPDDR4_MR13 {0x000} \
  CONFIG.MC_F1_LPDDR4_MR22 {0x000} \
] [get_bd_cells axi_noc_0]

set_property CONFIG.FREQ_HZ 200000000 [get_bd_intf_ports /sys_clk0_0]

# processor system reset instances for all the three system clocks

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

ad_connect  sys_cpu_clk sys_cips/m_axi_fpd_aclk

# gpio

ad_connect gpio_i sys_cips/lpd_gpio_i
ad_connect gpio_o sys_cips/lpd_gpio_o
ad_connect gpio_tn sys_cips/lpd_gpio_tn

## generic system clocks&resets pointers

set sys_cpu_clk           [get_bd_nets sys_cpu_clk]
set sys_dma_clk           [get_bd_nets sys_350m_clk]

set sys_cpu_reset         [get_bd_nets sys_cpu_reset]
set sys_cpu_resetn        [get_bd_nets sys_cpu_resetn]
set sys_dma_reset         [get_bd_nets sys_350m_reset]
set sys_dma_resetn        [get_bd_nets sys_350m_resetn]

# spi

ad_connect  sys_cips/spi0_sclk_o spi0_sclk
ad_connect  sys_cips/spi0_sclk_i GND
ad_connect  sys_cips/spi0_m_o spi0_mosi
ad_connect  sys_cips/spi0_m_i spi0_miso
ad_connect  sys_cips/spi0_s_i GND
ad_connect  sys_cips/spi0_ss_o_n spi0_csn
ad_connect  sys_cips/spi0_ss_i_n VCC

ad_connect  sys_cips/spi1_sclk_o spi1_sclk
ad_connect  sys_cips/spi1_sclk_i GND
ad_connect  sys_cips/spi1_m_o spi1_mosi
ad_connect  sys_cips/spi1_m_i spi1_miso
ad_connect  sys_cips/spi1_s_i GND
ad_connect  sys_cips/spi1_ss_o_n spi1_csn
ad_connect  sys_cips/spi1_ss_i_n VCC

# interrupts
