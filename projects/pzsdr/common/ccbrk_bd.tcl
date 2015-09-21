
# lbfmc

ad_connect  sys_ps7/ENET1_GMII_RX_CLK GND
ad_connect  sys_ps7/ENET1_GMII_TX_CLK GND

set axi_gpio_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0]
set_property -dict [list CONFIG.C_IS_DUAL {1}] $axi_gpio_0

create_bd_port -dir I -from 31 -to 0 gpio_0_0_i
create_bd_port -dir O -from 31 -to 0 gpio_0_0_o
create_bd_port -dir O -from 31 -to 0 gpio_0_0_t
create_bd_port -dir I -from 31 -to 0 gpio_0_1_i
create_bd_port -dir O -from 31 -to 0 gpio_0_1_o
create_bd_port -dir O -from 31 -to 0 gpio_0_1_t

ad_connect  gpio_0_0_i axi_gpio_0/gpio_io_i
ad_connect  gpio_0_0_o axi_gpio_0/gpio_io_o
ad_connect  gpio_0_0_t axi_gpio_0/gpio_io_t
ad_connect  gpio_0_1_i axi_gpio_0/gpio2_io_i
ad_connect  gpio_0_1_o axi_gpio_0/gpio2_io_o
ad_connect  gpio_0_1_t axi_gpio_0/gpio2_io_t

set axi_gpio_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1]
set_property -dict [list CONFIG.C_IS_DUAL {1}] $axi_gpio_1

create_bd_port -dir I -from 31 -to 0 gpio_1_0_i
create_bd_port -dir O -from 31 -to 0 gpio_1_0_o
create_bd_port -dir O -from 31 -to 0 gpio_1_0_t
create_bd_port -dir I -from 31 -to 0 gpio_1_1_i
create_bd_port -dir O -from 31 -to 0 gpio_1_1_o
create_bd_port -dir O -from 31 -to 0 gpio_1_1_t

ad_connect  gpio_1_0_i axi_gpio_1/gpio_io_i
ad_connect  gpio_1_0_o axi_gpio_1/gpio_io_o
ad_connect  gpio_1_0_t axi_gpio_1/gpio_io_t
ad_connect  gpio_1_1_i axi_gpio_1/gpio2_io_i
ad_connect  gpio_1_1_o axi_gpio_1/gpio2_io_o
ad_connect  gpio_1_1_t axi_gpio_1/gpio2_io_t

set axi_gpio_2 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_2]
set_property -dict [list CONFIG.C_IS_DUAL {1}] $axi_gpio_2

create_bd_port -dir I -from 31 -to 0 gpio_2_0_i
create_bd_port -dir O -from 31 -to 0 gpio_2_0_o
create_bd_port -dir O -from 31 -to 0 gpio_2_0_t
create_bd_port -dir I -from 31 -to 0 gpio_2_1_i
create_bd_port -dir O -from 31 -to 0 gpio_2_1_o
create_bd_port -dir O -from 31 -to 0 gpio_2_1_t

ad_connect  gpio_2_0_i axi_gpio_2/gpio_io_i
ad_connect  gpio_2_0_o axi_gpio_2/gpio_io_o
ad_connect  gpio_2_0_t axi_gpio_2/gpio_io_t
ad_connect  gpio_2_1_i axi_gpio_2/gpio2_io_i
ad_connect  gpio_2_1_o axi_gpio_2/gpio2_io_o
ad_connect  gpio_2_1_t axi_gpio_2/gpio2_io_t

set axi_gpio_3 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_3]
set_property -dict [list CONFIG.C_IS_DUAL {1}] $axi_gpio_3

create_bd_port -dir I -from 31 -to 0 gpio_3_0_i
create_bd_port -dir O -from 31 -to 0 gpio_3_0_o
create_bd_port -dir O -from 31 -to 0 gpio_3_0_t
create_bd_port -dir I -from 31 -to 0 gpio_3_1_i
create_bd_port -dir O -from 31 -to 0 gpio_3_1_o
create_bd_port -dir O -from 31 -to 0 gpio_3_1_t

ad_connect  gpio_3_0_i axi_gpio_3/gpio_io_i
ad_connect  gpio_3_0_o axi_gpio_3/gpio_io_o
ad_connect  gpio_3_0_t axi_gpio_3/gpio_io_t
ad_connect  gpio_3_1_i axi_gpio_3/gpio2_io_i
ad_connect  gpio_3_1_o axi_gpio_3/gpio2_io_o
ad_connect  gpio_3_1_t axi_gpio_3/gpio2_io_t

set axi_pzslb_gt [create_bd_cell -type ip -vlnv analog.com:user:axi_jesd_gt:1.0 axi_pzslb_gt]
set_property -dict [list CONFIG.NUM_OF_LANES {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.QPLL1_ENABLE {0}] $axi_pzslb_gt
set_property -dict [list CONFIG.RX_NUM_OF_LANES {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_NUM_OF_LANES {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.RX_CLKBUF_ENABLE_0 {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_CLKBUF_ENABLE_0 {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_DATA_SEL_0 {0}] $axi_pzslb_gt
set_property -dict [list CONFIG.CPLL_FBDIV_0 {2}] $axi_pzslb_gt
set_property -dict [list CONFIG.RX_OUT_DIV_0 {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_OUT_DIV_0 {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_0 {10}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_0 {10}] $axi_pzslb_gt
set_property -dict [list CONFIG.PMA_RSV_0 {0x00018480}] $axi_pzslb_gt
set_property -dict [list CONFIG.RX_CDR_CFG_0 {0x03000023ff20400020}] $axi_pzslb_gt

set util_pzslb_gtlb [create_bd_cell -type ip -vlnv analog.com:user:util_gtlb:1.0 util_pzslb_gtlb]

create_bd_port -dir I fmc_gt_ref_clk0
create_bd_port -dir I fmc_gt_ref_clk1
create_bd_port -dir I fmc_gt_rx_p
create_bd_port -dir I fmc_gt_rx_n
create_bd_port -dir O fmc_gt_tx_p
create_bd_port -dir O fmc_gt_tx_n

ad_connect  sys_cpu_clk util_pzslb_gtlb/up_clk
ad_connect  sys_cpu_resetn util_pzslb_gtlb/up_rstn
ad_connect  util_pzslb_gtlb/qpll_ref_clk fmc_gt_ref_clk0
ad_connect  util_pzslb_gtlb/cpll_ref_clk fmc_gt_ref_clk1
ad_connect  axi_pzslb_gt/gt_qpll_0 util_pzslb_gtlb/gt_qpll_0
ad_connect  axi_pzslb_gt/gt_pll_0 util_pzslb_gtlb/gt_pll_0
ad_connect  util_pzslb_gtlb/rx_p fmc_gt_rx_p
ad_connect  util_pzslb_gtlb/rx_n fmc_gt_rx_n
ad_connect  axi_pzslb_gt/gt_rx_0 util_pzslb_gtlb/gt_rx_0
ad_connect  util_pzslb_gtlb/tx_p fmc_gt_tx_p
ad_connect  util_pzslb_gtlb/tx_n fmc_gt_tx_n
ad_connect  axi_pzslb_gt/gt_tx_0 util_pzslb_gtlb/gt_tx_0
ad_connect  axi_pzslb_gt/rx_gt_comma_align_enb_0 util_pzslb_gtlb/rx_gt_comma_align_enb_0 
ad_connect  axi_pzslb_gt/gt_rx_ip_0 util_pzslb_gtlb/gt_rx_ip_0
ad_connect  axi_pzslb_gt/gt_tx_ip_0 util_pzslb_gtlb/gt_tx_ip_0

ad_cpu_interconnect 0x44A60000 axi_pzslb_gt
ad_mem_hp3_interconnect sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_cpu_clk axi_pzslb_gt/m_axi

ad_cpu_interconnect 0x41200000 axi_gpio_0
ad_cpu_interconnect 0x41210000 axi_gpio_1
ad_cpu_interconnect 0x41220000 axi_gpio_2
ad_cpu_interconnect 0x41230000 axi_gpio_3

create_bd_port -dir O up_clk
create_bd_port -dir O up_rst
create_bd_port -dir O up_rstn
create_bd_port -dir I up_pn_err_clr
create_bd_port -dir I up_pn_oos_clr
create_bd_port -dir O up_pn_err
create_bd_port -dir O up_pn_oos

ad_connect  sys_cpu_clk up_clk
ad_connect  sys_cpu_reset up_rst
ad_connect  sys_cpu_resetn up_rstn
ad_connect  up_pn_err_clr util_pzslb_gtlb/up_pn_err_clr
ad_connect  up_pn_oos_clr util_pzslb_gtlb/up_pn_oos_clr
ad_connect  up_pn_err util_pzslb_gtlb/up_pn_err
ad_connect  up_pn_oos util_pzslb_gtlb/up_pn_oos

delete_bd_objs [get_bd_cells ila_adc]
delete_bd_objs [get_bd_nets axi_ad9361_tdd_dbg] [get_bd_cells ila_tdd]

