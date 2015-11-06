
# lbfmc

ad_connect  sys_ps7/ENET1_GMII_RX_CLK GND
ad_connect  sys_ps7/ENET1_GMII_TX_CLK GND

# un-used io (gt)

set axi_pzslb_gt [create_bd_cell -type ip -vlnv analog.com:user:axi_jesd_gt:1.0 axi_pzslb_gt]
set_property -dict [list CONFIG.NUM_OF_LANES {4}] $axi_pzslb_gt
set_property -dict [list CONFIG.QPLL1_ENABLE {0}] $axi_pzslb_gt
set_property -dict [list CONFIG.RX_NUM_OF_LANES {4}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_NUM_OF_LANES {4}] $axi_pzslb_gt
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
set_property -dict [list CONFIG.RX_CLKBUF_ENABLE_1 {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_CLKBUF_ENABLE_1 {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_DATA_SEL_1 {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.CPLL_FBDIV_1 {2}] $axi_pzslb_gt
set_property -dict [list CONFIG.RX_OUT_DIV_1 {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_OUT_DIV_1 {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_1 {10}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_1 {10}] $axi_pzslb_gt
set_property -dict [list CONFIG.PMA_RSV_1 {0x00018480}] $axi_pzslb_gt
set_property -dict [list CONFIG.RX_CDR_CFG_1 {0x03000023ff20400020}] $axi_pzslb_gt
set_property -dict [list CONFIG.RX_CLKBUF_ENABLE_2 {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_CLKBUF_ENABLE_2 {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_DATA_SEL_2 {2}] $axi_pzslb_gt
set_property -dict [list CONFIG.CPLL_FBDIV_2 {2}] $axi_pzslb_gt
set_property -dict [list CONFIG.RX_OUT_DIV_2 {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_OUT_DIV_2 {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_2 {10}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_2 {10}] $axi_pzslb_gt
set_property -dict [list CONFIG.PMA_RSV_2 {0x00018480}] $axi_pzslb_gt
set_property -dict [list CONFIG.RX_CDR_CFG_2 {0x03000023ff20400020}] $axi_pzslb_gt
set_property -dict [list CONFIG.RX_CLKBUF_ENABLE_3 {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_CLKBUF_ENABLE_3 {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_DATA_SEL_3 {3}] $axi_pzslb_gt
set_property -dict [list CONFIG.CPLL_FBDIV_3 {2}] $axi_pzslb_gt
set_property -dict [list CONFIG.RX_OUT_DIV_3 {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_OUT_DIV_3 {1}] $axi_pzslb_gt
set_property -dict [list CONFIG.RX_CLK25_DIV_3 {10}] $axi_pzslb_gt
set_property -dict [list CONFIG.TX_CLK25_DIV_3 {10}] $axi_pzslb_gt
set_property -dict [list CONFIG.PMA_RSV_3 {0x00018480}] $axi_pzslb_gt
set_property -dict [list CONFIG.RX_CDR_CFG_3 {0x03000023ff20400020}] $axi_pzslb_gt

set util_pzslb_gtlb_0 [create_bd_cell -type ip -vlnv analog.com:user:util_gtlb:1.0 util_pzslb_gtlb_0]
set util_pzslb_gtlb_1 [create_bd_cell -type ip -vlnv analog.com:user:util_gtlb:1.0 util_pzslb_gtlb_1]
set util_pzslb_gtlb_2 [create_bd_cell -type ip -vlnv analog.com:user:util_gtlb:1.0 util_pzslb_gtlb_2]
set util_pzslb_gtlb_3 [create_bd_cell -type ip -vlnv analog.com:user:util_gtlb:1.0 util_pzslb_gtlb_3]

ad_cpu_interconnect 0x44A60000 axi_pzslb_gt
ad_mem_hp3_interconnect sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_cpu_clk axi_pzslb_gt/m_axi

create_bd_port -dir I gt_ref_clk
create_bd_port -dir I gt_rx_0_p
create_bd_port -dir I gt_rx_0_n
create_bd_port -dir O gt_tx_0_p
create_bd_port -dir O gt_tx_0_n
create_bd_port -dir I gt_rx_1_p
create_bd_port -dir I gt_rx_1_n
create_bd_port -dir O gt_tx_1_p
create_bd_port -dir O gt_tx_1_n
create_bd_port -dir I gt_rx_2_p
create_bd_port -dir I gt_rx_2_n
create_bd_port -dir O gt_tx_2_p
create_bd_port -dir O gt_tx_2_n
create_bd_port -dir I gt_rx_3_p
create_bd_port -dir I gt_rx_3_n
create_bd_port -dir O gt_tx_3_p
create_bd_port -dir O gt_tx_3_n

ad_connect  sys_cpu_clk util_pzslb_gtlb_0/up_clk
ad_connect  sys_cpu_resetn util_pzslb_gtlb_0/up_rstn
ad_connect  util_pzslb_gtlb_0/qpll_ref_clk gt_ref_clk
ad_connect  util_pzslb_gtlb_0/cpll_ref_clk gt_ref_clk
ad_connect  util_pzslb_gtlb_0/rx_p gt_rx_0_p
ad_connect  util_pzslb_gtlb_0/rx_n gt_rx_0_n
ad_connect  util_pzslb_gtlb_0/tx_p gt_tx_0_p
ad_connect  util_pzslb_gtlb_0/tx_n gt_tx_0_n
ad_connect  sys_cpu_clk util_pzslb_gtlb_1/up_clk
ad_connect  sys_cpu_resetn util_pzslb_gtlb_1/up_rstn
ad_connect  util_pzslb_gtlb_1/qpll_ref_clk gt_ref_clk
ad_connect  util_pzslb_gtlb_1/cpll_ref_clk gt_ref_clk
ad_connect  util_pzslb_gtlb_1/rx_p gt_rx_1_p
ad_connect  util_pzslb_gtlb_1/rx_n gt_rx_1_n
ad_connect  util_pzslb_gtlb_1/tx_p gt_tx_1_p
ad_connect  util_pzslb_gtlb_1/tx_n gt_tx_1_n
ad_connect  sys_cpu_clk util_pzslb_gtlb_2/up_clk
ad_connect  sys_cpu_resetn util_pzslb_gtlb_2/up_rstn
ad_connect  util_pzslb_gtlb_2/qpll_ref_clk gt_ref_clk
ad_connect  util_pzslb_gtlb_2/cpll_ref_clk gt_ref_clk
ad_connect  util_pzslb_gtlb_2/rx_p gt_rx_2_p
ad_connect  util_pzslb_gtlb_2/rx_n gt_rx_2_n
ad_connect  util_pzslb_gtlb_2/tx_p gt_tx_2_p
ad_connect  util_pzslb_gtlb_2/tx_n gt_tx_2_n
ad_connect  sys_cpu_clk util_pzslb_gtlb_3/up_clk
ad_connect  sys_cpu_resetn util_pzslb_gtlb_3/up_rstn
ad_connect  util_pzslb_gtlb_3/qpll_ref_clk gt_ref_clk
ad_connect  util_pzslb_gtlb_3/cpll_ref_clk gt_ref_clk
ad_connect  util_pzslb_gtlb_3/rx_p gt_rx_3_p
ad_connect  util_pzslb_gtlb_3/rx_n gt_rx_3_n
ad_connect  util_pzslb_gtlb_3/tx_p gt_tx_3_p
ad_connect  util_pzslb_gtlb_3/tx_n gt_tx_3_n
ad_connect  axi_pzslb_gt/gt_qpll_0 util_pzslb_gtlb_0/gt_qpll_0
ad_connect  axi_pzslb_gt/gt_pll_0 util_pzslb_gtlb_0/gt_pll_0
ad_connect  axi_pzslb_gt/gt_rx_0 util_pzslb_gtlb_0/gt_rx_0
ad_connect  axi_pzslb_gt/gt_tx_0 util_pzslb_gtlb_0/gt_tx_0
ad_connect  axi_pzslb_gt/gt_rx_ip_0 util_pzslb_gtlb_0/gt_rx_ip_0
ad_connect  axi_pzslb_gt/gt_tx_ip_0 util_pzslb_gtlb_0/gt_tx_ip_0
ad_connect  axi_pzslb_gt/rx_gt_comma_align_enb_0 util_pzslb_gtlb_0/rx_gt_comma_align_enb_0 
ad_connect  axi_pzslb_gt/gt_pll_1 util_pzslb_gtlb_1/gt_pll_0
ad_connect  axi_pzslb_gt/gt_rx_1 util_pzslb_gtlb_1/gt_rx_0
ad_connect  axi_pzslb_gt/gt_tx_1 util_pzslb_gtlb_1/gt_tx_0
ad_connect  axi_pzslb_gt/gt_rx_ip_1 util_pzslb_gtlb_1/gt_rx_ip_0
ad_connect  axi_pzslb_gt/gt_tx_ip_1 util_pzslb_gtlb_1/gt_tx_ip_0
ad_connect  axi_pzslb_gt/rx_gt_comma_align_enb_1 util_pzslb_gtlb_1/rx_gt_comma_align_enb_0 
ad_connect  axi_pzslb_gt/gt_pll_2 util_pzslb_gtlb_2/gt_pll_0
ad_connect  axi_pzslb_gt/gt_rx_2 util_pzslb_gtlb_2/gt_rx_0
ad_connect  axi_pzslb_gt/gt_tx_2 util_pzslb_gtlb_2/gt_tx_0
ad_connect  axi_pzslb_gt/gt_rx_ip_2 util_pzslb_gtlb_2/gt_rx_ip_0
ad_connect  axi_pzslb_gt/gt_tx_ip_2 util_pzslb_gtlb_2/gt_tx_ip_0
ad_connect  axi_pzslb_gt/rx_gt_comma_align_enb_2 util_pzslb_gtlb_2/rx_gt_comma_align_enb_0 
ad_connect  axi_pzslb_gt/gt_pll_3 util_pzslb_gtlb_3/gt_pll_0
ad_connect  axi_pzslb_gt/gt_rx_3 util_pzslb_gtlb_3/gt_rx_0
ad_connect  axi_pzslb_gt/gt_tx_3 util_pzslb_gtlb_3/gt_tx_0
ad_connect  axi_pzslb_gt/gt_rx_ip_3 util_pzslb_gtlb_3/gt_rx_ip_0
ad_connect  axi_pzslb_gt/gt_tx_ip_3 util_pzslb_gtlb_3/gt_tx_ip_0
ad_connect  axi_pzslb_gt/rx_gt_comma_align_enb_3 util_pzslb_gtlb_3/rx_gt_comma_align_enb_0 

# un-used io (regular)

set axi_gpreg [create_bd_cell -type ip -vlnv analog.com:user:axi_gpreg:1.0 axi_gpreg]
set_property -dict [list CONFIG.NUM_OF_CLK_MONS {8}] $axi_gpreg
set_property -dict [list CONFIG.BUF_ENABLE_0 {0}] $axi_gpreg
set_property -dict [list CONFIG.BUF_ENABLE_1 {0}] $axi_gpreg
set_property -dict [list CONFIG.BUF_ENABLE_2 {0}] $axi_gpreg
set_property -dict [list CONFIG.BUF_ENABLE_3 {0}] $axi_gpreg
set_property -dict [list CONFIG.BUF_ENABLE_4 {0}] $axi_gpreg
set_property -dict [list CONFIG.BUF_ENABLE_5 {0}] $axi_gpreg
set_property -dict [list CONFIG.BUF_ENABLE_6 {0}] $axi_gpreg
set_property -dict [list CONFIG.BUF_ENABLE_7 {0}] $axi_gpreg
set_property -dict [list CONFIG.NUM_OF_IO {7}] $axi_gpreg

ad_cpu_interconnect 0x41200000 axi_gpreg

ad_connect  util_pzslb_gtlb_0/rx_clk axi_gpreg/d_clk_0
ad_connect  util_pzslb_gtlb_0/tx_clk axi_gpreg/d_clk_1
ad_connect  util_pzslb_gtlb_1/rx_clk axi_gpreg/d_clk_2
ad_connect  util_pzslb_gtlb_1/tx_clk axi_gpreg/d_clk_3
ad_connect  util_pzslb_gtlb_2/rx_clk axi_gpreg/d_clk_4
ad_connect  util_pzslb_gtlb_2/tx_clk axi_gpreg/d_clk_5
ad_connect  util_pzslb_gtlb_3/rx_clk axi_gpreg/d_clk_6
ad_connect  util_pzslb_gtlb_3/tx_clk axi_gpreg/d_clk_7

create_bd_port -dir I -from 31 -to 0 gp_in_0
create_bd_port -dir I -from 31 -to 0 gp_in_1
create_bd_port -dir I -from 31 -to 0 gp_in_2
create_bd_port -dir O -from 31 -to 0 gp_out_0
create_bd_port -dir O -from 31 -to 0 gp_out_1
create_bd_port -dir O -from 31 -to 0 gp_out_2

ad_connect  gp_in_0 axi_gpreg/up_gp_in_0
ad_connect  gp_in_1 axi_gpreg/up_gp_in_1
ad_connect  gp_in_2 axi_gpreg/up_gp_in_2
ad_connect  gp_out_0 axi_gpreg/up_gp_out_0
ad_connect  gp_out_1 axi_gpreg/up_gp_out_1
ad_connect  gp_out_2 axi_gpreg/up_gp_out_2
ad_connect  axi_gpreg/up_gp_in_3 util_pzslb_gtlb_0/up_gp_out
ad_connect  axi_gpreg/up_gp_out_3 util_pzslb_gtlb_0/up_gp_in
ad_connect  axi_gpreg/up_gp_in_4 util_pzslb_gtlb_1/up_gp_out
ad_connect  axi_gpreg/up_gp_out_4 util_pzslb_gtlb_1/up_gp_in
ad_connect  axi_gpreg/up_gp_in_5 util_pzslb_gtlb_2/up_gp_out
ad_connect  axi_gpreg/up_gp_out_5 util_pzslb_gtlb_2/up_gp_in
ad_connect  axi_gpreg/up_gp_in_6 util_pzslb_gtlb_3/up_gp_out
ad_connect  axi_gpreg/up_gp_out_6 util_pzslb_gtlb_3/up_gp_in

## temporary (remove ila indirectly)

delete_bd_objs [get_bd_cells ila_adc]
delete_bd_objs [get_bd_nets axi_ad9361_tdd_dbg] [get_bd_cells ila_tdd]

