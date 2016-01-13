
# create board design
# interface ports

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr
create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 fixed_io

create_bd_port -dir O spi0_csn_2_o
create_bd_port -dir O spi0_csn_1_o
create_bd_port -dir O spi0_csn_0_o
create_bd_port -dir I spi0_csn_i
create_bd_port -dir I spi0_clk_i
create_bd_port -dir O spi0_clk_o
create_bd_port -dir I spi0_sdo_i
create_bd_port -dir O spi0_sdo_o
create_bd_port -dir I spi0_sdi_i

create_bd_port -dir O spi1_csn_2_o
create_bd_port -dir O spi1_csn_1_o
create_bd_port -dir O spi1_csn_0_o
create_bd_port -dir I spi1_csn_i
create_bd_port -dir I spi1_clk_i
create_bd_port -dir O spi1_clk_o
create_bd_port -dir I spi1_sdo_i
create_bd_port -dir O spi1_sdo_o
create_bd_port -dir I spi1_sdi_i

create_bd_port -dir I -from 63 -to 0 gpio_i
create_bd_port -dir O -from 63 -to 0 gpio_o
create_bd_port -dir O -from 63 -to 0 gpio_t

# instance: sys_ps7

set sys_ps7  [create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 sys_ps7]
source $ad_hdl_dir/projects/common/microzed/microzed_system_ps7.tcl
set_property -dict [list CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0}] $sys_ps7
set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO {64}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI0_SPI0_IO {EMIO}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_SPI1_SPI1_IO {EMIO}] $sys_ps7

# interface connections

ad_connect  ddr           sys_ps7/DDR
ad_connect  gpio_i        sys_ps7/GPIO_I
ad_connect  gpio_o        sys_ps7/GPIO_O
ad_connect  gpio_t        sys_ps7/GPIO_T
ad_connect  fixed_io      sys_ps7/FIXED_IO

# spi connections

ad_connect  spi0_csn_2_o sys_ps7/SPI0_SS2_O
ad_connect  spi0_csn_1_o sys_ps7/SPI0_SS1_O
ad_connect  spi0_csn_0_o sys_ps7/SPI0_SS_O
ad_connect  spi0_csn_i sys_ps7/SPI0_SS_I
ad_connect  spi0_clk_i sys_ps7/SPI0_SCLK_I
ad_connect  spi0_clk_o sys_ps7/SPI0_SCLK_O
ad_connect  spi0_sdo_i sys_ps7/SPI0_MOSI_I
ad_connect  spi0_sdo_o sys_ps7/SPI0_MOSI_O
ad_connect  spi0_sdi_i sys_ps7/SPI0_MISO_I

ad_connect  spi1_csn_2_o sys_ps7/SPI1_SS2_O
ad_connect  spi1_csn_1_o sys_ps7/SPI1_SS1_O
ad_connect  spi1_csn_0_o sys_ps7/SPI1_SS_O
ad_connect  spi1_csn_i sys_ps7/SPI1_SS_I
ad_connect  spi1_clk_i sys_ps7/SPI1_SCLK_I
ad_connect  spi1_clk_o sys_ps7/SPI1_SCLK_O
ad_connect  spi1_sdo_i sys_ps7/SPI1_MOSI_I
ad_connect  spi1_sdo_o sys_ps7/SPI1_MOSI_O
ad_connect  spi1_sdi_i sys_ps7/SPI1_MISO_I


