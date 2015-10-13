
# prcfg io

create_bd_port -dir O clk

create_bd_port -dir I  dma_dac_i0_enable
create_bd_port -dir O  dma_dac_i0_data
create_bd_port -dir I  dma_dac_i0_valid
create_bd_port -dir I  dma_dac_q0_enable
create_bd_port -dir O  dma_dac_q0_data
create_bd_port -dir I  dma_dac_q0_valid
create_bd_port -dir I  dma_dac_i1_enable
create_bd_port -dir O  dma_dac_i1_data
create_bd_port -dir I  dma_dac_i1_valid
create_bd_port -dir I  dma_dac_q1_enable
create_bd_port -dir O  dma_dac_q1_data
create_bd_port -dir I  dma_dac_q1_valid
create_bd_port -dir O  core_dac_i0_enable
create_bd_port -dir I  core_dac_i0_data
create_bd_port -dir O  core_dac_i0_valid
create_bd_port -dir O  core_dac_q0_enable
create_bd_port -dir I  core_dac_q0_data
create_bd_port -dir O  core_dac_q0_valid
create_bd_port -dir O  core_dac_i1_enable
create_bd_port -dir I  core_dac_i1_data
create_bd_port -dir O  core_dac_i1_valid
create_bd_port -dir O  core_dac_q1_enable
create_bd_port -dir I  core_dac_q1_data
create_bd_port -dir O  core_dac_q1_valid
create_bd_port -dir I  dma_adc_i0_enable
create_bd_port -dir I  dma_adc_i0_data
create_bd_port -dir I  dma_adc_i0_valid
create_bd_port -dir I  dma_adc_q0_enable
create_bd_port -dir I  dma_adc_q0_data
create_bd_port -dir I  dma_adc_q0_valid
create_bd_port -dir I  dma_adc_i1_enable
create_bd_port -dir I  dma_adc_i1_data
create_bd_port -dir I  dma_adc_i1_valid
create_bd_port -dir I  dma_adc_q1_enable
create_bd_port -dir I  dma_adc_q1_data
create_bd_port -dir I  dma_adc_q1_valid
create_bd_port -dir O  core_adc_i0_enable
create_bd_port -dir O  core_adc_i0_data
create_bd_port -dir O  core_adc_i0_valid
create_bd_port -dir O  core_adc_q0_enable
create_bd_port -dir O  core_adc_q0_data
create_bd_port -dir O  core_adc_q0_valid
create_bd_port -dir O  core_adc_i1_enable
create_bd_port -dir O  core_adc_i1_data
create_bd_port -dir O  core_adc_i1_valid
create_bd_port -dir O  core_adc_q1_enable
create_bd_port -dir O  core_adc_q1_data
create_bd_port -dir O  core_adc_q1_valid

create_bd_port -dir I -from 31 -to 0 up_dac_gpio_in
create_bd_port -dir I -from 31 -to 0 up_adc_gpio_in
create_bd_port -dir O -from 31 -to 0 up_dac_gpio_out
create_bd_port -dir O -from 31 -to 0 up_adc_gpio_out

# re-wiring

disconnect_bd_net [get_bd_nets -of_objects [get_bd_pins util_ad9361_dac_upack/dac_enable_0]] [get_bd_pins util_ad9361_dac_upack/dac_enable_0]
disconnect_bd_net [get_bd_nets -of_objects [get_bd_pins util_ad9361_dac_upack/dac_valid_0]] [get_bd_pins util_ad9361_dac_upack/dac_valid_0]
disconnect_bd_net [get_bd_nets -of_objects [get_bd_pins util_ad9361_dac_upack/dac_data_0]] [get_bd_pins util_ad9361_dac_upack/dac_data_0]
disconnect_bd_net [get_bd_nets -of_objects [get_bd_pins util_ad9361_dac_upack/dac_enable_1]] [get_bd_pins util_ad9361_dac_upack/dac_enable_1]
disconnect_bd_net [get_bd_nets -of_objects [get_bd_pins util_ad9361_dac_upack/dac_valid_1]] [get_bd_pins util_ad9361_dac_upack/dac_valid_1]
disconnect_bd_net [get_bd_nets -of_objects [get_bd_pins util_ad9361_dac_upack/dac_data_1]] [get_bd_pins util_ad9361_dac_upack/dac_data_1]
disconnect_bd_net [get_bd_nets -of_objects [get_bd_pins util_ad9361_dac_upack/dac_enable_2]] [get_bd_pins util_ad9361_dac_upack/dac_enable_2]
disconnect_bd_net [get_bd_nets -of_objects [get_bd_pins util_ad9361_dac_upack/dac_valid_2]] [get_bd_pins util_ad9361_dac_upack/dac_valid_2]
disconnect_bd_net [get_bd_nets -of_objects [get_bd_pins util_ad9361_dac_upack/dac_data_2]] [get_bd_pins util_ad9361_dac_upack/dac_data_2]
disconnect_bd_net [get_bd_nets -of_objects [get_bd_pins util_ad9361_dac_upack/dac_enable_3]] [get_bd_pins util_ad9361_dac_upack/dac_enable_3]
disconnect_bd_net [get_bd_nets -of_objects [get_bd_pins util_ad9361_dac_upack/dac_valid_3]] [get_bd_pins util_ad9361_dac_upack/dac_valid_3]
disconnect_bd_net [get_bd_nets -of_objects [get_bd_pins util_ad9361_dac_upack/dac_data_3]] [get_bd_pins util_ad9361_dac_upack/dac_data_3]

disconnect_bd_net [get_bd_nets -of_objects [get_bd_pins util_ad9361_adc_pack/adc_enable_0]] [get_bd_pins util_ad9361_adc_pack/adc_enable_0]
disconnect_bd_net [get_bd_nets -of_objects [get_bd_pins util_ad9361_adc_pack/adc_valid_0]] [get_bd_pins util_ad9361_adc_pack/adc_valid_0]
disconnect_bd_net [get_bd_nets -of_objects [get_bd_pins util_ad9361_adc_pack/adc_data_0]] [get_bd_pins util_ad9361_adc_pack/adc_data_0]
disconnect_bd_net [get_bd_nets -of_objects [get_bd_pins util_ad9361_adc_pack/adc_enable_1]] [get_bd_pins util_ad9361_adc_pack/adc_enable_1]
disconnect_bd_net [get_bd_nets -of_objects [get_bd_pins util_ad9361_adc_pack/adc_valid_1]] [get_bd_pins util_ad9361_adc_pack/adc_valid_1]
disconnect_bd_net [get_bd_nets -of_objects [get_bd_pins util_ad9361_adc_pack/adc_data_1]] [get_bd_pins util_ad9361_adc_pack/adc_data_1]
disconnect_bd_net [get_bd_nets -of_objects [get_bd_pins util_ad9361_adc_pack/adc_enable_2]] [get_bd_pins util_ad9361_adc_pack/adc_enable_2]
disconnect_bd_net [get_bd_nets -of_objects [get_bd_pins util_ad9361_adc_pack/adc_valid_2]] [get_bd_pins util_ad9361_adc_pack/adc_valid_2]
disconnect_bd_net [get_bd_nets -of_objects [get_bd_pins util_ad9361_adc_pack/adc_data_2]] [get_bd_pins util_ad9361_adc_pack/adc_data_2]
disconnect_bd_net [get_bd_nets -of_objects [get_bd_pins util_ad9361_adc_pack/adc_enable_3]] [get_bd_pins util_ad9361_adc_pack/adc_enable_3]
disconnect_bd_net [get_bd_nets -of_objects [get_bd_pins util_ad9361_adc_pack/adc_valid_3]] [get_bd_pins util_ad9361_adc_pack/adc_valid_3]
disconnect_bd_net [get_bd_nets -of_objects [get_bd_pins util_ad9361_adc_pack/adc_data_3]] [get_bd_pins util_ad9361_adc_pack/adc_data_3]

ad_connect  clk axi_ad9361/clk

# tx data path
ad_connect  dma_dac_i0_enable util_ad9361_dac_upack/dac_enable_0
ad_connect  dma_dac_i0_data util_ad9361_dac_upack/dac_data_0
ad_connect  dma_dac_i0_valid util_ad9361_dac_upack/dac_valid_0
ad_connect  dma_dac_q0_enable util_ad9361_dac_upack/dac_enable_1
ad_connect  dma_dac_q0_data util_ad9361_dac_upack/dac_data_1
ad_connect  dma_dac_q0_valid util_ad9361_dac_upack/dac_valid_1
ad_connect  dma_dac_i1_enable util_ad9361_dac_upack/dac_enable_2
ad_connect  dma_dac_i1_data util_ad9361_dac_upack/dac_data_2
ad_connect  dma_dac_i1_valid util_ad9361_dac_upack/dac_valid_2
ad_connect  dma_dac_q1_enable util_ad9361_dac_upack/dac_enable_3
ad_connect  dma_dac_q1_data util_ad9361_dac_upack/dac_data_3
ad_connect  dma_dac_q1_valid util_ad9361_dac_upack/dac_valid_3

ad_connect  core_dac_i0_enable axi_ad9361/dac_enable_i0
ad_connect  core_dac_i0_data axi_ad9361/dac_data_i0
ad_connect  core_dac_i0_valid axi_ad9361/dac_valid_i0
ad_connect  core_dac_q0_enable axi_ad9361/dac_enable_q0
ad_connect  core_dac_q0_data axi_ad9361/dac_data_q0
ad_connect  core_dac_q0_valid axi_ad9361/dac_valid_q0
ad_connect  core_dac_i1_enable axi_ad9361/dac_enable_i1
ad_connect  core_dac_i1_data axi_ad9361/dac_data_i1
ad_connect  core_dac_i1_valid axi_ad9361/dac_valid_i1
ad_connect  core_dac_q1_enable axi_ad9361/dac_enable_q1
ad_connect  core_dac_q1_data axi_ad9361/dac_data_q1
ad_connect  core_dac_q1_valid axi_ad9361/dac_valid_q1

# rx data path
ad_connect  dma_adc_i0_enable util_ad9361_adc_pack/adc_enable_0
ad_connect  dma_adc_i0_data util_ad9361_adc_pack/adc_data_0
ad_connect  dma_adc_i0_valid util_ad9361_adc_pack/adc_valid_0
ad_connect  dma_adc_q0_enable util_ad9361_adc_pack/adc_enable_1
ad_connect  dma_adc_q0_data util_ad9361_adc_pack/adc_data_1
ad_connect  dma_adc_q0_valid util_ad9361_adc_pack/adc_valid_1
ad_connect  dma_adc_i1_enable util_ad9361_adc_pack/adc_enable_2
ad_connect  dma_adc_i1_data util_ad9361_adc_pack/adc_data_2
ad_connect  dma_adc_i1_valid util_ad9361_adc_pack/adc_valid_2
ad_connect  dma_adc_q1_enable util_ad9361_adc_pack/adc_enable_3
ad_connect  dma_adc_q1_data util_ad9361_adc_pack/adc_data_3
ad_connect  dma_adc_q1_valid util_ad9361_adc_pack/adc_valid_3

ad_connect  core_adc_i0_enable util_ad9361_adc_fifo/dout_enable_0
ad_connect  core_adc_i0_data util_ad9361_adc_fifo/dout_data_0
ad_connect  core_adc_i0_valid util_ad9361_adc_fifo/dout_valid_0
ad_connect  core_adc_q0_enable util_ad9361_adc_fifo/dout_enable_1
ad_connect  core_adc_q0_data util_ad9361_adc_fifo/dout_data_1
ad_connect  core_adc_q0_valid util_ad9361_adc_fifo/dout_valid_1
ad_connect  core_adc_i1_enable util_ad9361_adc_fifo/dout_enable_2
ad_connect  core_adc_i1_data util_ad9361_adc_fifo/dout_data_2
ad_connect  core_adc_i1_valid util_ad9361_adc_fifo/dout_valid_2
ad_connect  core_adc_q1_enable util_ad9361_adc_fifo/dout_enable_3
ad_connect  core_adc_q1_data util_ad9361_adc_fifo/dout_data_3
ad_connect  core_adc_q1_valid util_ad9361_adc_fifo/dout_valid_3

ad_connect  up_dac_gpio_in axi_ad9361/up_dac_gpio_in
ad_connect  up_adc_gpio_in axi_ad9361/up_adc_gpio_in
ad_connect  up_dac_gpio_out axi_ad9361/up_dac_gpio_out
ad_connect  up_adc_gpio_out axi_ad9361/up_adc_gpio_out

# rx side monitoring

set ila_rx_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:5.1 ila_rx_0]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_rx_0
set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}] $ila_rx_0
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_rx_0
set_property -dict [list CONFIG.C_PROBE1_WIDTH {16}] $ila_rx_0
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_rx_0

ad_connect  sys_cpu_clk ila_rx_0/clk
ad_connect  util_ad9361_adc_pack/adc_valid_0 ila_rx_0/probe0
ad_connect  util_ad9361_adc_pack/adc_data_0 ila_rx_0/probe1

set ila_rx_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:5.1 ila_rx_1]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_rx_1
set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}] $ila_rx_1
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_rx_1
set_property -dict [list CONFIG.C_PROBE1_WIDTH {16}] $ila_rx_1
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_rx_1

ad_connect  sys_cpu_clk ila_rx_1/clk
ad_connect  util_ad9361_adc_pack/adc_valid_0 ila_rx_1/probe0
ad_connect  util_ad9361_adc_pack/adc_data_0 ila_rx_1/probe1

set ila_rx_2 [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:5.1 ila_rx_2]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_rx_2
set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}] $ila_rx_2
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_rx_2
set_property -dict [list CONFIG.C_PROBE1_WIDTH {16}] $ila_rx_2
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_rx_2

ad_connect  sys_cpu_clk ila_rx_2/clk
ad_connect  util_ad9361_adc_pack/adc_valid_0 ila_rx_2/probe0
ad_connect  util_ad9361_adc_pack/adc_data_0 ila_rx_2/probe1

set ila_rx_3 [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:5.1 ila_rx_3]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_rx_3
set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}] $ila_rx_3
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_rx_3
set_property -dict [list CONFIG.C_PROBE1_WIDTH {16}] $ila_rx_3
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_rx_3

ad_connect  sys_cpu_clk ila_rx_3/clk
ad_connect  util_ad9361_adc_pack/adc_valid_0 ila_rx_3/probe0
ad_connect  util_ad9361_adc_pack/adc_data_0 ila_rx_3/probe1

# rx side monitoring

set ila_tx_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:5.1 ila_tx_0]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_tx_0
set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}] $ila_tx_0
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_tx_0
set_property -dict [list CONFIG.C_PROBE1_WIDTH {16}] $ila_tx_0
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_tx_0

ad_connect  axi_ad9361/l_clk ila_tx_0/clk
ad_connect  util_ad9361_adc_fifo/dout_valid_0 ila_tx_0/probe0
ad_connect  util_ad9361_adc_fifo/dout_data_0 ila_tx_0/probe1

set ila_tx_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:5.1 ila_tx_1]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_tx_1
set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}] $ila_tx_1
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_tx_1
set_property -dict [list CONFIG.C_PROBE1_WIDTH {16}] $ila_tx_1
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_tx_1

ad_connect  axi_ad9361/l_clk ila_tx_1/clk
ad_connect  util_ad9361_adc_fifo/dout_valid_1 ila_tx_1/probe0
ad_connect  util_ad9361_adc_fifo/dout_data_1 ila_tx_1/probe1

set ila_tx_2 [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:5.1 ila_tx_2]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_tx_2
set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}] $ila_tx_2
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_tx_2
set_property -dict [list CONFIG.C_PROBE1_WIDTH {16}] $ila_tx_2
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_tx_2

ad_connect  axi_ad9361/l_clk ila_tx_2/clk
ad_connect  util_ad9361_adc_fifo/dout_valid_2 ila_tx_2/probe0
ad_connect  util_ad9361_adc_fifo/dout_data_2 ila_tx_2/probe1

set ila_tx_3 [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:5.1 ila_tx_3]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_tx_3
set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}] $ila_tx_3
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_tx_3
set_property -dict [list CONFIG.C_PROBE1_WIDTH {16}] $ila_tx_3
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_tx_3

ad_connect  axi_ad9361/l_clk ila_tx_3/clk
ad_connect  util_ad9361_adc_fifo/dout_valid_3 ila_tx_3/probe0
ad_connect  util_ad9361_adc_fifo/dout_data_3 ila_tx_3/probe1

