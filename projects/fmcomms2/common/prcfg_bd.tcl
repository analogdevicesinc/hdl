
# This file modifies the block design of the fmcomms2/zc706 project such
# that it can interface the partial reconfigurable module.
# The partial reconfigurable module in inserted in the data path of the
# fmcomms2/zc706 project between the util_ad9361_dac_upack and 
# the axi_ad9361_dac_fifo and between the util_ad9361adc_pack and the
# util_ad9361_adc_fifo module.

create_bd_port -dir O clk

create_bd_port -dir O  core_dac_i0_enable
create_bd_port -dir O  core_dac_q0_enable
create_bd_port -dir O  core_dac_i1_enable
create_bd_port -dir O  core_dac_q1_enable
create_bd_port -dir O  core_dac_i0_valid
create_bd_port -dir I  core_dac_i0_valid_in
create_bd_port -dir I  core_dac_q0_valid_in
create_bd_port -dir I  core_dac_i1_valid_in
create_bd_port -dir I  core_dac_q1_valid_in
create_bd_port -dir I  core_dac_underflow
create_bd_port -dir I  -from 15 -to 0 core_dac_i0_data
create_bd_port -dir I  -from 15 -to 0 core_dac_q0_data
create_bd_port -dir I  -from 15 -to 0 core_dac_i1_data
create_bd_port -dir I  -from 15 -to 0 core_dac_q1_data

create_bd_port -dir I  dma_dac_i0_enable
create_bd_port -dir I  dma_dac_q0_enable
create_bd_port -dir I  dma_dac_i1_enable
create_bd_port -dir I  dma_dac_q1_enable
create_bd_port -dir I  dma_dac_rd_enable
create_bd_port -dir O  dma_dac_rd_valid
create_bd_port -dir O  dma_dac_rd_underflow
create_bd_port -dir O  -from 15 -to 0 dma_dac_i0_data
create_bd_port -dir O  -from 15 -to 0 dma_dac_q0_data
create_bd_port -dir O  -from 15 -to 0 dma_dac_i1_data
create_bd_port -dir O  -from 15 -to 0 dma_dac_q1_data

create_bd_port -dir O  core_adc_i0_enable
create_bd_port -dir O  core_adc_q0_enable
create_bd_port -dir O  core_adc_i1_enable
create_bd_port -dir O  core_adc_q1_enable
create_bd_port -dir O  core_adc_i0_valid
create_bd_port -dir O  -from 15 -to 0 core_adc_i0_data
create_bd_port -dir O  -from 15 -to 0 core_adc_q0_data
create_bd_port -dir O  -from 15 -to 0 core_adc_i1_data
create_bd_port -dir O  -from 15 -to 0 core_adc_q1_data
create_bd_port -dir I  core_adc_overflow

create_bd_port -dir I  dma_adc_i0_enable
create_bd_port -dir I  dma_adc_q0_enable
create_bd_port -dir I  dma_adc_i1_enable
create_bd_port -dir I  dma_adc_q1_enable
create_bd_port -dir I  dma_adc_wr_en
create_bd_port -dir I  -from 15 -to 0 dma_adc_i0_data
create_bd_port -dir I  -from 15 -to 0 dma_adc_q0_data
create_bd_port -dir I  -from 15 -to 0 dma_adc_i1_data
create_bd_port -dir I  -from 15 -to 0 dma_adc_q1_data
create_bd_port -dir O  dma_adc_wr_overflow

create_bd_port -dir I  -from 31 -to 0 up_dac_gpio_in
create_bd_port -dir I  -from 31 -to 0 up_adc_gpio_in
create_bd_port -dir O  -from 31 -to 0 up_dac_gpio_out
create_bd_port -dir O  -from 31 -to 0 up_adc_gpio_out

# re-wiring, split between ad9361 core & upack/cpack modules

ad_connect  util_ad9361_divclk/clk_out clk

ad_reconct  util_ad9361_dac_upack/enable_0 dma_dac_i0_enable
ad_reconct  util_ad9361_dac_upack/enable_1 dma_dac_q0_enable
ad_reconct  util_ad9361_dac_upack/enable_2 dma_dac_i1_enable
ad_reconct  util_ad9361_dac_upack/enable_3 dma_dac_q1_enable
ad_reconct  util_ad9361_dac_upack/fifo_rd_en dma_dac_rd_enable
ad_reconct  util_ad9361_dac_upack/fifo_rd_valid dma_dac_rd_valid
ad_reconct  util_ad9361_dac_upack/fifo_rd_underflow dma_dac_rd_underflow
ad_reconct  util_ad9361_dac_upack/fifo_rd_data_0 dma_dac_i0_data
ad_reconct  util_ad9361_dac_upack/fifo_rd_data_1 dma_dac_q0_data
ad_reconct  util_ad9361_dac_upack/fifo_rd_data_2 dma_dac_i1_data
ad_reconct  util_ad9361_dac_upack/fifo_rd_data_3 dma_dac_q1_data
ad_reconct  axi_ad9361_dac_fifo/din_enable_0 core_dac_i0_enable
ad_reconct  axi_ad9361_dac_fifo/din_enable_1 core_dac_q0_enable
ad_reconct  axi_ad9361_dac_fifo/din_enable_2 core_dac_i1_enable
ad_reconct  axi_ad9361_dac_fifo/din_enable_3 core_dac_q1_enable
ad_reconct  axi_ad9361_dac_fifo/din_valid_0 core_dac_i0_valid
ad_reconct  axi_ad9361_dac_fifo/din_valid_in_0 core_dac_i0_valid_in
ad_reconct  axi_ad9361_dac_fifo/din_valid_in_1 core_dac_q0_valid_in
ad_reconct  axi_ad9361_dac_fifo/din_valid_in_2 core_dac_i1_valid_in
ad_reconct  axi_ad9361_dac_fifo/din_valid_in_3 core_dac_q1_valid_in
ad_reconct  axi_ad9361_dac_fifo/din_unf core_dac_underflow
ad_reconct  axi_ad9361_dac_fifo/din_data_0 core_dac_i0_data
ad_reconct  axi_ad9361_dac_fifo/din_data_1 core_dac_q0_data
ad_reconct  axi_ad9361_dac_fifo/din_data_2 core_dac_i1_data
ad_reconct  axi_ad9361_dac_fifo/din_data_3 core_dac_q1_data

ad_reconct  util_ad9361_adc_pack/enable_0 dma_adc_i0_enable
ad_reconct  util_ad9361_adc_pack/enable_1 dma_adc_q0_enable
ad_reconct  util_ad9361_adc_pack/enable_2 dma_adc_i1_enable
ad_reconct  util_ad9361_adc_pack/enable_3 dma_adc_q1_enable
ad_reconct  util_ad9361_adc_pack/fifo_wr_en dma_adc_wr_en
ad_reconct  util_ad9361_adc_pack/fifo_wr_data_0 dma_adc_i0_data
ad_reconct  util_ad9361_adc_pack/fifo_wr_data_1 dma_adc_q0_data
ad_reconct  util_ad9361_adc_pack/fifo_wr_data_2 dma_adc_i1_data
ad_reconct  util_ad9361_adc_pack/fifo_wr_data_3 dma_adc_q1_data
ad_reconct  util_ad9361_adc_pack/fifo_wr_overflow dma_adc_wr_overflow
ad_reconct  util_ad9361_adc_fifo/dout_enable_0 core_adc_i0_enable
ad_reconct  util_ad9361_adc_fifo/dout_enable_1 core_adc_q0_enable
ad_reconct  util_ad9361_adc_fifo/dout_enable_2 core_adc_i1_enable
ad_reconct  util_ad9361_adc_fifo/dout_enable_3 core_adc_q1_enable
ad_reconct  util_ad9361_adc_fifo/dout_valid_0 core_adc_i0_valid
ad_reconct  util_ad9361_adc_fifo/dout_data_0 core_adc_i0_data
ad_reconct  util_ad9361_adc_fifo/dout_data_1 core_adc_q0_data
ad_reconct  util_ad9361_adc_fifo/dout_data_2 core_adc_i1_data
ad_reconct  util_ad9361_adc_fifo/dout_data_3 core_adc_q1_data
ad_reconct  util_ad9361_adc_fifo/dout_ovf core_adc_overflow

ad_reconct  axi_ad9361/up_dac_gpio_in up_dac_gpio_in
ad_reconct  axi_ad9361/up_adc_gpio_in up_adc_gpio_in
ad_reconct  axi_ad9361/up_dac_gpio_out up_dac_gpio_out
ad_reconct  axi_ad9361/up_adc_gpio_out up_adc_gpio_out

