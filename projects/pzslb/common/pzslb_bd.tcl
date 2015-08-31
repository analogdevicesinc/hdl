
# lbfmc

set axi_gpio_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0]
set_property -dict [list CONFIG.C_IS_DUAL {1}] $axi_gpio_0
set axi_gpio_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1]
set_property -dict [list CONFIG.C_IS_DUAL {1}] $axi_gpio_1
set axi_gpio_2 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_2]
set_property -dict [list CONFIG.C_IS_DUAL {1}] $axi_gpio_2
set axi_gpio_3 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_3]
set_property -dict [list CONFIG.C_IS_DUAL {1}] $axi_gpio_3

set axi_pzslb_gt [create_bd_cell -type ip -vlnv analog.com:user:axi_jesd_gt:1.0 axi_pzslb_gt]
set_property -dict [list CONFIG.NUM_OF_LANES {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.QPLL1_ENABLE {0}] $axi_pzslb_gt
set_property -dict [list CONFIG.RX_NUM_OF_LANES {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_NUM_OF_LANES {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.RX_CLKBUF_ENABLE_0 {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_CLKBUF_ENABLE_0 {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_DATA_SEL_0 {0}] $axi_pzslb_gt


ad_connect  axi_daq2_gt/gt_qpll_0 util_daq2_gt/gt_qpll_0
ad_connect  axi_daq2_gt/gt_pll_0 util_daq2_gt/gt_pll_0
ad_connect  axi_daq2_gt/gt_rx_0 util_daq2_gt/gt_rx_0
ad_connect  axi_daq2_gt/gt_rx_ip_0 axi_ad9680_jesd/gt0_rx
ad_connect  axi_daq2_gt/rx_gt_comma_align_enb_0 axi_ad9680_jesd/rxencommaalign_out
ad_connect  axi_daq2_gt/gt_tx_0 util_daq2_gt/gt_tx_0
ad_connect  axi_daq2_gt/gt_tx_ip_0 axi_ad9144_jesd/gt0_tx

ad_cpu_interconnect 0x44A60000 axi_daq2_gt
ad_mem_hp3_interconnect sys_cpu_clk axi_daq2_gt/m_axi

create_bd_port -dir I -from 31 -to 0 gpio_0_0_i
create_bd_port -dir O -from 31 -to 0 gpio_0_0_o
create_bd_port -dir O -from 31 -to 0 gpio_0_0_t
create_bd_port -dir I -from 31 -to 0 gpio_0_1_i
create_bd_port -dir O -from 31 -to 0 gpio_0_1_o
create_bd_port -dir O -from 31 -to 0 gpio_0_1_t
create_bd_port -dir I -from 31 -to 0 gpio_1_0_i
create_bd_port -dir O -from 31 -to 0 gpio_1_0_o
create_bd_port -dir O -from 31 -to 0 gpio_1_0_t
create_bd_port -dir I -from 31 -to 0 gpio_1_1_i
create_bd_port -dir O -from 31 -to 0 gpio_1_1_o
create_bd_port -dir O -from 31 -to 0 gpio_1_1_t
create_bd_port -dir I -from 31 -to 0 gpio_2_0_i
create_bd_port -dir O -from 31 -to 0 gpio_2_0_o
create_bd_port -dir O -from 31 -to 0 gpio_2_0_t
create_bd_port -dir I -from 31 -to 0 gpio_2_1_i
create_bd_port -dir O -from 31 -to 0 gpio_2_1_o
create_bd_port -dir O -from 31 -to 0 gpio_2_1_t
create_bd_port -dir I -from 31 -to 0 gpio_3_0_i
create_bd_port -dir O -from 31 -to 0 gpio_3_0_o
create_bd_port -dir O -from 31 -to 0 gpio_3_0_t
create_bd_port -dir I -from 31 -to 0 gpio_3_1_i
create_bd_port -dir O -from 31 -to 0 gpio_3_1_o
create_bd_port -dir O -from 31 -to 0 gpio_3_1_t

ad_connect  gpio_0_0_i axi_gpio_0/gpio_io_i
ad_connect  gpio_0_0_o axi_gpio_0/gpio_io_o
ad_connect  gpio_0_0_t axi_gpio_0/gpio_io_t
ad_connect  gpio_0_1_i axi_gpio_0/gpio2_io_i
ad_connect  gpio_0_1_o axi_gpio_0/gpio2_io_o
ad_connect  gpio_0_1_t axi_gpio_0/gpio2_io_t
ad_connect  gpio_1_0_i axi_gpio_1/gpio_io_i
ad_connect  gpio_1_0_o axi_gpio_1/gpio_io_o
ad_connect  gpio_1_0_t axi_gpio_1/gpio_io_t
ad_connect  gpio_1_1_i axi_gpio_1/gpio2_io_i
ad_connect  gpio_1_1_o axi_gpio_1/gpio2_io_o
ad_connect  gpio_1_1_t axi_gpio_1/gpio2_io_t
ad_connect  gpio_2_0_i axi_gpio_2/gpio_io_i
ad_connect  gpio_2_0_o axi_gpio_2/gpio_io_o
ad_connect  gpio_2_0_t axi_gpio_2/gpio_io_t
ad_connect  gpio_2_1_i axi_gpio_2/gpio2_io_i
ad_connect  gpio_2_1_o axi_gpio_2/gpio2_io_o
ad_connect  gpio_2_1_t axi_gpio_2/gpio2_io_t
ad_connect  gpio_3_0_i axi_gpio_3/gpio_io_i
ad_connect  gpio_3_0_o axi_gpio_3/gpio_io_o
ad_connect  gpio_3_0_t axi_gpio_3/gpio_io_t
ad_connect  gpio_3_1_i axi_gpio_3/gpio2_io_i
ad_connect  gpio_3_1_o axi_gpio_3/gpio2_io_o
ad_connect  gpio_3_1_t axi_gpio_3/gpio2_io_t

ad_cpu_interconnect 0x41200000 axi_gpio_0
ad_cpu_interconnect 0x41210000 axi_gpio_1
ad_cpu_interconnect 0x41220000 axi_gpio_2
ad_cpu_interconnect 0x41230000 axi_gpio_3

create_bd_port -dir O up_clk
create_bd_port -dir O up_rst
create_bd_port -dir O up_rstn

ad_connect  sys_cpu_clk up_clk
ad_connect  sys_cpu_reset up_rst
ad_connect  sys_cpu_resetn up_rstn


