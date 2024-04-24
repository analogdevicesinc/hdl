###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

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

create_bd_port -dir I -from 94 -to 0 gpio_i
create_bd_port -dir O -from 94 -to 0 gpio_o
create_bd_port -dir O -from 94 -to 0 gpio_t

# adding clocks

create_bd_port -dir O clk_8MHz
create_bd_port -dir I clk_4MHz

create_bd_port -dir I debug_probe0
create_bd_port -dir I debug_probe1
create_bd_port -dir I debug_probe2
create_bd_port -dir I debug_probe3
create_bd_port -dir I debug_probe4
create_bd_port -dir I debug_probe5
create_bd_port -dir I debug_probe6
create_bd_port -dir I debug_probe7
create_bd_port -dir I debug_probe8
create_bd_port -dir I debug_probe9
create_bd_port -dir I debug_probe10
create_bd_port -dir I debug_probe11
create_bd_port -dir I debug_probe12
create_bd_port -dir I debug_probe13
create_bd_port -dir I debug_probe14
create_bd_port -dir I debug_probe15
create_bd_port -dir I debug_probe16
create_bd_port -dir I debug_probe17

# instance: sys_ps8

ad_ip_instance zynq_ultra_ps_e sys_ps8
apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e \
  -config {apply_board_preset 1}  [get_bd_cells sys_ps8]

ad_ip_parameter sys_ps8 CONFIG.PSU__PSS_REF_CLK__FREQMHZ 33.333333333
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__M_AXI_GP0 0
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__M_AXI_GP1 0
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__M_AXI_GP2 1
ad_ip_parameter sys_ps8 CONFIG.PSU__MAXIGP2__DATA_WIDTH 32
ad_ip_parameter sys_ps8 CONFIG.PSU__FPGA_PL0_ENABLE 1
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {IOPLL}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ 100
ad_ip_parameter sys_ps8 CONFIG.PSU__FPGA_PL1_ENABLE 1
ad_ip_parameter sys_ps8 CONFIG.PSU__FPGA_PL2_ENABLE 1
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL1_REF_CTRL__SRCSEL {IOPLL}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ 250
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL2_REF_CTRL__SRCSEL {IOPLL}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL2_REF_CTRL__FREQMHZ 500
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__IRQ0 1
ad_ip_parameter sys_ps8 CONFIG.PSU__USE__IRQ1 1
ad_ip_parameter sys_ps8 CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE 1

set_property -dict [list \
  CONFIG.PSU__SPI0__PERIPHERAL__ENABLE 1 \
  CONFIG.PSU__SPI0__PERIPHERAL__IO {EMIO} \
  CONFIG.PSU__SPI0__GRP_SS1__ENABLE 1 \
  CONFIG.PSU__SPI0__GRP_SS2__ENABLE 1 \
  CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__FREQMHZ 100 \
  CONFIG.PSU__SPI1__PERIPHERAL__ENABLE 1 \
  CONFIG.PSU__SPI1__PERIPHERAL__IO EMIO \
  CONFIG.PSU__SPI1__GRP_SS1__ENABLE 1 \
  CONFIG.PSU__SPI1__GRP_SS2__ENABLE 1 \
  CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__FREQMHZ 100 \
] [get_bd_cells sys_ps8]

# processor system reset instances for all the three system clocks

ad_ip_instance proc_sys_reset sys_rstgen
ad_ip_parameter sys_rstgen CONFIG.C_EXT_RST_WIDTH 1
ad_ip_instance proc_sys_reset sys_250m_rstgen
ad_ip_parameter sys_250m_rstgen CONFIG.C_EXT_RST_WIDTH 1
ad_ip_instance proc_sys_reset sys_500m_rstgen
ad_ip_parameter sys_500m_rstgen CONFIG.C_EXT_RST_WIDTH 1

# adding clock generator

ad_ip_instance  axi_clkgen axi_clkgen
ad_ip_parameter axi_clkgen CONFIG.ID 1
ad_ip_parameter axi_clkgen CONFIG.CLKIN_PERIOD 10
ad_ip_parameter axi_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter axi_clkgen CONFIG.VCO_MUL 8
ad_ip_parameter axi_clkgen CONFIG.CLK0_DIV 100


ad_connect axi_clkgen/clk    sys_cpu_clk
ad_connect axi_clkgen/clk_0  clk_8MHz



# adding ILA

set my_ila [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 my_ila]
   set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $my_ila
   set_property -dict [list CONFIG.C_NUM_OF_PROBES {20}]  $my_ila
   set_property -dict [list CONFIG.C_TRIGIN_EN {false}]   $my_ila
   set_property -dict [list CONFIG.C_DATA_DEPTH {8192}]   $my_ila
   set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}]    $my_ila
   set_property -dict [list CONFIG.C_ADV_TRIGGER {true} ] $my_ila
   set_property -dict [list CONFIG.C_PROBE1_MU_CNT {2} ]  $my_ila
   set_property -dict [list CONFIG.C_PROBE0_MU_CNT {2} ]  $my_ila
   set_property -dict [list CONFIG.ALL_PROBE_SAME_MU_CNT {2}] $my_ila
   set_property -dict [list CONFIG.C_PROBE0_WIDTH  {1}] $my_ila
   set_property -dict [list CONFIG.C_PROBE1_WIDTH  {1}] $my_ila
   set_property -dict [list CONFIG.C_PROBE2_WIDTH  {1}] $my_ila
   set_property -dict [list CONFIG.C_PROBE3_WIDTH  {1}] $my_ila
   set_property -dict [list CONFIG.C_PROBE4_WIDTH  {1}] $my_ila
   set_property -dict [list CONFIG.C_PROBE5_WIDTH  {1}] $my_ila
   set_property -dict [list CONFIG.C_PROBE6_WIDTH  {1}] $my_ila
   set_property -dict [list CONFIG.C_PROBE7_WIDTH  {1}] $my_ila
   set_property -dict [list CONFIG.C_PROBE8_WIDTH  {1}] $my_ila
   set_property -dict [list CONFIG.C_PROBE9_WIDTH  {1}] $my_ila
   set_property -dict [list CONFIG.C_PROBE10_WIDTH {1}] $my_ila
   set_property -dict [list CONFIG.C_PROBE11_WIDTH {1}] $my_ila
   set_property -dict [list CONFIG.C_PROBE12_WIDTH {1}] $my_ila
   set_property -dict [list CONFIG.C_PROBE13_WIDTH {1}] $my_ila
   set_property -dict [list CONFIG.C_PROBE14_WIDTH {1}] $my_ila
   set_property -dict [list CONFIG.C_PROBE15_WIDTH {1}] $my_ila
   set_property -dict [list CONFIG.C_PROBE16_WIDTH {1}] $my_ila
   set_property -dict [list CONFIG.C_PROBE17_WIDTH {1}] $my_ila
   set_property -dict [list CONFIG.C_PROBE18_WIDTH {1}] $my_ila
   set_property -dict [list CONFIG.C_PROBE19_WIDTH {1}] $my_ila


   
   ad_connect my_ila/clk sys_cpu_clk
   ad_connect my_ila/probe0 debug_probe0
   ad_connect my_ila/probe1 debug_probe1
   ad_connect my_ila/probe2 debug_probe2
   ad_connect my_ila/probe3 debug_probe3
   ad_connect my_ila/probe4 debug_probe4
   ad_connect my_ila/probe5 debug_probe5
   ad_connect my_ila/probe6 debug_probe6
   ad_connect my_ila/probe7 debug_probe7
   ad_connect my_ila/probe8 debug_probe8
   ad_connect my_ila/probe9 debug_probe9
   ad_connect my_ila/probe10 debug_probe10
   ad_connect my_ila/probe11 debug_probe11
   ad_connect my_ila/probe12 debug_probe12
   ad_connect my_ila/probe13 debug_probe13
   ad_connect my_ila/probe14 debug_probe14
   ad_connect my_ila/probe15 debug_probe15
   ad_connect my_ila/probe16 debug_probe16
   ad_connect my_ila/probe17 debug_probe17
   ad_connect my_ila/probe18 axi_clkgen/clk_0
   ad_connect my_ila/probe19 clk_4MHz

# system reset/clock definitions

ad_connect  sys_cpu_clk sys_ps8/pl_clk0
ad_connect  sys_250m_clk sys_ps8/pl_clk1
ad_connect  sys_500m_clk sys_ps8/pl_clk2

ad_connect  sys_ps8/pl_resetn0 sys_rstgen/ext_reset_in
ad_connect  sys_cpu_clk sys_rstgen/slowest_sync_clk
ad_connect  sys_ps8/pl_resetn0 sys_250m_rstgen/ext_reset_in
ad_connect  sys_250m_clk sys_250m_rstgen/slowest_sync_clk
ad_connect  sys_ps8/pl_resetn0 sys_500m_rstgen/ext_reset_in
ad_connect  sys_500m_clk sys_500m_rstgen/slowest_sync_clk

ad_connect  sys_cpu_reset sys_rstgen/peripheral_reset
ad_connect  sys_cpu_resetn sys_rstgen/peripheral_aresetn
ad_connect  sys_250m_reset sys_250m_rstgen/peripheral_reset
ad_connect  sys_250m_resetn sys_250m_rstgen/peripheral_aresetn
ad_connect  sys_500m_reset sys_500m_rstgen/peripheral_reset
ad_connect  sys_500m_resetn sys_500m_rstgen/peripheral_aresetn

# generic system clocks&resets pointers

set sys_cpu_clk            [get_bd_nets sys_cpu_clk]
set sys_dma_clk            [get_bd_nets sys_250m_clk]
set sys_iodelay_clk        [get_bd_nets sys_500m_clk]

set  sys_cpu_reset         [get_bd_nets sys_cpu_reset]
set  sys_cpu_resetn        [get_bd_nets sys_cpu_resetn]
set  sys_dma_reset         [get_bd_nets sys_250m_reset]
set  sys_dma_resetn        [get_bd_nets sys_250m_resetn]
set  sys_iodelay_reset     [get_bd_nets sys_500m_reset]
set  sys_iodelay_resetn    [get_bd_nets sys_500m_resetn]

# gpio

ad_connect  gpio_i sys_ps8/emio_gpio_i
ad_connect  gpio_o sys_ps8/emio_gpio_o
ad_connect  gpio_t sys_ps8/emio_gpio_t

# spi

ad_ip_instance xlconcat spi0_csn_concat
ad_ip_parameter spi0_csn_concat CONFIG.NUM_PORTS 3
ad_connect  sys_ps8/emio_spi0_ss_o_n spi0_csn_concat/In0
ad_connect  sys_ps8/emio_spi0_ss1_o_n spi0_csn_concat/In1
ad_connect  sys_ps8/emio_spi0_ss2_o_n spi0_csn_concat/In2
ad_connect  spi0_csn_concat/dout spi0_csn
ad_connect  sys_ps8/emio_spi0_sclk_o spi0_sclk
ad_connect  sys_ps8/emio_spi0_m_o spi0_mosi
ad_connect  sys_ps8/emio_spi0_m_i spi0_miso
ad_connect  sys_ps8/emio_spi0_ss_i_n VCC
ad_connect  sys_ps8/emio_spi0_sclk_i GND
ad_connect  sys_ps8/emio_spi0_s_i GND

ad_ip_instance xlconcat spi1_csn_concat
ad_ip_parameter spi1_csn_concat CONFIG.NUM_PORTS 3
ad_connect  sys_ps8/emio_spi1_ss_o_n spi1_csn_concat/In0
ad_connect  sys_ps8/emio_spi1_ss1_o_n spi1_csn_concat/In1
ad_connect  sys_ps8/emio_spi1_ss2_o_n spi1_csn_concat/In2
ad_connect  spi1_csn_concat/dout spi1_csn
ad_connect  sys_ps8/emio_spi1_sclk_o spi1_sclk
ad_connect  sys_ps8/emio_spi1_m_o spi1_mosi
ad_connect  sys_ps8/emio_spi1_m_i spi1_miso
ad_connect  sys_ps8/emio_spi1_ss_i_n VCC
ad_connect  sys_ps8/emio_spi1_sclk_i GND
ad_connect  sys_ps8/emio_spi1_s_i GND

# system id

ad_ip_instance axi_sysid axi_sysid_0
ad_ip_instance sysid_rom rom_sys_0

ad_connect  axi_sysid_0/rom_addr   	rom_sys_0/rom_addr
ad_connect  axi_sysid_0/sys_rom_data   	rom_sys_0/rom_data
ad_connect  sys_cpu_clk                 rom_sys_0/clk

ad_cpu_interconnect 0x45000000 axi_sysid_0
ad_cpu_interconnect 0x44A00000 axi_clkgen

# interrupts	

ad_ip_instance xlconcat sys_concat_intc_0
ad_ip_parameter sys_concat_intc_0 CONFIG.NUM_PORTS 8

ad_ip_instance xlconcat sys_concat_intc_1
ad_ip_parameter sys_concat_intc_1 CONFIG.NUM_PORTS 8

ad_connect  sys_concat_intc_0/dout sys_ps8/pl_ps_irq0
ad_connect  sys_concat_intc_1/dout sys_ps8/pl_ps_irq1

ad_connect  sys_concat_intc_1/In7 GND
ad_connect  sys_concat_intc_1/In6 GND
ad_connect  sys_concat_intc_1/In5 GND
ad_connect  sys_concat_intc_1/In4 GND
ad_connect  sys_concat_intc_1/In3 GND
ad_connect  sys_concat_intc_1/In2 GND
ad_connect  sys_concat_intc_1/In1 GND
ad_connect  sys_concat_intc_1/In0 GND
ad_connect  sys_concat_intc_0/In7 GND
ad_connect  sys_concat_intc_0/In6 GND
ad_connect  sys_concat_intc_0/In5 GND
ad_connect  sys_concat_intc_0/In4 GND
ad_connect  sys_concat_intc_0/In3 GND
ad_connect  sys_concat_intc_0/In2 GND
ad_connect  sys_concat_intc_0/In1 GND
ad_connect  sys_concat_intc_0/In0 GND

