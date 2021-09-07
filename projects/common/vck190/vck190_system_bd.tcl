
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

# instance: versal_cips
create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips:2.1 sys_cips
set_property -dict [list \
  CONFIG.PS_BOARD_INTERFACE	cips_fixed_io \
  CONFIG.PMC_SD1_PERIPHERAL_ENABLE {1} \
  CONFIG.PMC_SD1_SLOT_TYPE {SD 3.0} \
  CONFIG.PMC_SD1_PERIPHERAL_IO {PMC_MIO 26 .. 36} \
  CONFIG.PMC_SD1_GRP_CD_ENABLE {1} \
  CONFIG.PMC_SD1_GRP_POW_ENABLE {1} \
  CONFIG.PMC_CRP_PL0_REF_CTRL_FREQMHZ {100} \
  CONFIG.PS_USE_PMCPL_CLK1 {1} \
  CONFIG.PMC_CRP_PL1_REF_CTRL_FREQMHZ {350} \
  CONFIG.PS_GPIO_EMIO_PERIPHERAL_ENABLE {1} \
  CONFIG.PS_USE_M_AXI_GP0 {1} \
  CONFIG.PS_M_AXI_GP0_DATA_WIDTH {128} \
  CONFIG.PS_SPI0_GRP_SS1_ENABLE {1} \
  CONFIG.PS_SPI0_GRP_SS2_ENABLE {1} \
  CONFIG.PS_SPI0_PERIPHERAL_ENABLE {1} \
  CONFIG.PS_SPI0_PERIPHERAL_IO {EMIO} \
  CONFIG.PS_SPI1_GRP_SS1_ENABLE {1} \
  CONFIG.PS_SPI1_GRP_SS2_ENABLE {1} \
  CONFIG.PS_SPI1_PERIPHERAL_ENABLE {1} \
  CONFIG.PS_SPI1_PERIPHERAL_IO {EMIO} \
] [get_bd_cells sys_cips]

apply_bd_automation -rule xilinx.com:bd_rule:versal_cips -config { configure_noc {Add new AXI NoC} num_ddr {1} pcie0_lane_width {None} pcie0_mode {None} pcie0_port_type {Endpoint Device} pcie1_lane_width {None} pcie1_mode {None} pcie1_port_type {Endpoint Device} pl_clocks {1} pl_resets {1}}  [get_bd_cells sys_cips]

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
  CONFIG.sys_clk0_BOARD_INTERFACE {ddr4_dimm1_sma_clk} \
] [get_bd_cells axi_noc_0]

set_property CONFIG.FREQ_HZ 200000000 [get_bd_intf_ports /sys_clk0_0]

set_property -dict [list CONFIG.ASSOCIATED_BUSIF {S01_AXI}] [get_bd_pins /axi_noc_0/aclk1]
set_property -dict [list CONFIG.ASSOCIATED_BUSIF {S02_AXI}] [get_bd_pins /axi_noc_0/aclk2]
set_property -dict [list CONFIG.ASSOCIATED_BUSIF {S03_AXI}] [get_bd_pins /axi_noc_0/aclk3]
set_property -dict [list CONFIG.ASSOCIATED_BUSIF {S04_AXI}] [get_bd_pins /axi_noc_0/aclk4]
set_property -dict [list CONFIG.ASSOCIATED_BUSIF {S05_AXI}] [get_bd_pins /axi_noc_0/aclk5]

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

# gpio
ad_ip_instance util_vector_logic gpio_t_inverter [list \
  C_OPERATION {not} \
  C_SIZE {32} \
]
ad_connect  sys_cips/lpd_gpio_tn  gpio_t_inverter/Op1

ad_connect gpio0_i sys_cips/lpd_gpio_i
ad_connect gpio0_o sys_cips/lpd_gpio_o
ad_connect gpio0_t gpio_t_inverter/Res

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

ad_cpu_interconnect 0x44000000 axi_gpio

ad_cpu_interrupt ps-0 mb-xx axi_gpio/ip2intc_irpt

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

# system id

ad_ip_instance axi_sysid axi_sysid_0
ad_ip_instance sysid_rom rom_sys_0

ad_connect  axi_sysid_0/rom_addr   	    rom_sys_0/rom_addr
ad_connect  axi_sysid_0/sys_rom_data   	rom_sys_0/rom_data
ad_connect  sys_cpu_clk                 rom_sys_0/clk

ad_cpu_interconnect 0x45000000 axi_sysid_0

# interrupts

