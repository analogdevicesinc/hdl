
# prcfg io

create_bd_port -dir O clk
create_bd_port -dir I dma_dac_en
create_bd_port -dir O dma_dac_dvalid
create_bd_port -dir O -from 63 -to 0 dma_dac_ddata
create_bd_port -dir O dma_dac_dunf
create_bd_port -dir O core_dac_en
create_bd_port -dir I core_dac_dvalid
create_bd_port -dir I -from 63 -to 0 core_dac_ddata
create_bd_port -dir I core_dac_dunf
create_bd_port -dir O core_adc_dwr
create_bd_port -dir O core_adc_dsync
create_bd_port -dir O -from 63 -to 0 core_adc_ddata
create_bd_port -dir I core_adc_ovf
create_bd_port -dir I dma_adc_dwr
create_bd_port -dir I dma_adc_dsync
create_bd_port -dir I -from 63 -to 0 dma_adc_ddata
create_bd_port -dir O dma_adc_ovf
create_bd_port -dir I -from 31 -to 0 up_dac_gpio_in
create_bd_port -dir I -from 31 -to 0 up_adc_gpio_in
create_bd_port -dir O -from 31 -to 0 up_dac_gpio_out
create_bd_port -dir O -from 31 -to 0 up_adc_gpio_out

# re-wiring

delete_bd_objs [get_bd_nets -of_objects [get_bd_pins axi_ad9361_dac_dma/fifo_rd_en]]
delete_bd_objs [get_bd_nets -of_objects [get_bd_pins axi_ad9361_dac_dma/fifo_rd_valid]]
delete_bd_objs [get_bd_nets -of_objects [get_bd_pins axi_ad9361_dac_dma/fifo_rd_dout]]
delete_bd_objs [get_bd_nets -of_objects [get_bd_pins axi_ad9361_dac_dma/fifo_rd_underflow]]
delete_bd_objs [get_bd_nets -of_objects [get_bd_pins axi_ad9361_adc_dma/fifo_wr_en]]
delete_bd_objs [get_bd_nets -of_objects [get_bd_pins axi_ad9361_adc_dma/fifo_wr_sync]]
delete_bd_objs [get_bd_nets -of_objects [get_bd_pins axi_ad9361_adc_dma/fifo_wr_din]]
delete_bd_objs [get_bd_nets -of_objects [get_bd_pins axi_ad9361_adc_dma/fifo_wr_overflow]]

ad_connect  clk axi_ad9361/clk

ad_connect  dma_dac_en axi_ad9361_dac_dma/fifo_rd_en
ad_connect  dma_dac_dvalid axi_ad9361_dac_dma/fifo_rd_valid
ad_connect  dma_dac_ddata axi_ad9361_dac_dma/fifo_rd_dout
ad_connect  dma_dac_dunf axi_ad9361_dac_dma/fifo_rd_underflow
ad_connect  core_dac_en util_dac_unpack/dma_rd
ad_connect  core_dac_dvalid util_dac_unpack/fifo_valid
ad_connect  core_dac_ddata util_dac_unpack/dma_data
ad_connect  core_dac_dunf axi_ad9361/dac_dunf
ad_connect  up_dac_gpio_in axi_ad9361/up_dac_gpio_in
ad_connect  up_dac_gpio_out axi_ad9361/up_dac_gpio_out

ad_connect  dma_adc_dwr axi_ad9361_adc_dma/fifo_wr_en
ad_connect  dma_adc_dsync axi_ad9361_adc_dma/fifo_wr_sync
ad_connect  dma_adc_ddata axi_ad9361_adc_dma/fifo_wr_din
ad_connect  dma_adc_ovf axi_ad9361_adc_dma/fifo_wr_overflow
ad_connect  core_adc_dwr util_adc_pack/dvalid
ad_connect  core_adc_dsync util_adc_pack/dsync
ad_connect  core_adc_ddata util_adc_pack/ddata
ad_connect  core_adc_ovf axi_ad9361/adc_dovf
ad_connect  up_adc_gpio_in axi_ad9361/up_adc_gpio_in
ad_connect  up_adc_gpio_out axi_ad9361/up_adc_gpio_out

# monitoring

set ila_adc_core [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:5.0 ila_adc_core]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_adc_core
set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}] $ila_adc_core
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_adc_core
set_property -dict [list CONFIG.C_PROBE1_WIDTH {64}] $ila_adc_core
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_adc_core

ad_connect  clk ila_adc_core/clk
ad_connect  util_adc_pack/dvalid ila_adc_core/probe0
ad_connect  util_adc_pack/ddata ila_adc_core/probe1

set ila_dac_core [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:5.0 ila_dac_core]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_dac_core
set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}] $ila_dac_core
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_dac_core
set_property -dict [list CONFIG.C_PROBE1_WIDTH {64}] $ila_dac_core
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_dac_core

ad_connect  clk ila_dac_core/clk
ad_connect  util_dac_unpack/fifo_valid ila_dac_core/probe0
ad_connect  util_dac_unpack/dma_data ila_dac_core/probe1

set ila_adc_dma [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:5.0 ila_adc_dma]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_adc_dma
set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}] $ila_adc_dma
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_adc_dma
set_property -dict [list CONFIG.C_PROBE1_WIDTH {64}] $ila_adc_dma
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_adc_dma

ad_connect  clk ila_adc_dma/clk
ad_connect  axi_ad9361_adc_dma/fifo_wr_en ila_adc_dma/probe0
ad_connect  axi_ad9361_adc_dma/fifo_wr_din ila_adc_dma/probe1

set ila_dac_dma [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:5.0 ila_dac_dma]
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] $ila_dac_dma
set_property -dict [list CONFIG.C_NUM_OF_PROBES {2}] $ila_dac_dma
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] $ila_dac_dma
set_property -dict [list CONFIG.C_PROBE1_WIDTH {64}] $ila_dac_dma
set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] $ila_dac_dma

ad_connect  clk ila_dac_dma/clk
ad_connect  axi_ad9361_dac_dma/fifo_rd_en ila_dac_dma/probe0
ad_connect  axi_ad9361_dac_dma/fifo_rd_dout ila_dac_dma/probe1

