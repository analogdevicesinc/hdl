
# prcfg io

create_bd_port -dir O clk

create_bd_port -dir O  core_dac_i0_enable
create_bd_port -dir O  core_dac_q0_enable
create_bd_port -dir O  core_dac_i1_enable
create_bd_port -dir O  core_dac_q1_enable
create_bd_port -dir O  core_dac_i0_valid
create_bd_port -dir O  core_dac_q0_valid
create_bd_port -dir O  core_dac_i1_valid
create_bd_port -dir O  core_dac_q1_valid
create_bd_port -dir I  -from 15 -to 0 core_dac_i0_data
create_bd_port -dir I  -from 15 -to 0 core_dac_q0_data
create_bd_port -dir I  -from 15 -to 0 core_dac_i1_data
create_bd_port -dir I  -from 15 -to 0 core_dac_q1_data

create_bd_port -dir I  dma_dac_i0_enable
create_bd_port -dir I  dma_dac_q0_enable
create_bd_port -dir I  dma_dac_i1_enable
create_bd_port -dir I  dma_dac_q1_enable
create_bd_port -dir I  dma_dac_i0_valid
create_bd_port -dir I  dma_dac_q0_valid
create_bd_port -dir I  dma_dac_i1_valid
create_bd_port -dir I  dma_dac_q1_valid
create_bd_port -dir O  -from 15 -to 0 dma_dac_i0_data
create_bd_port -dir O  -from 15 -to 0 dma_dac_q0_data
create_bd_port -dir O  -from 15 -to 0 dma_dac_i1_data
create_bd_port -dir O  -from 15 -to 0 dma_dac_q1_data

create_bd_port -dir O  core_adc_i0_enable
create_bd_port -dir O  core_adc_q0_enable
create_bd_port -dir O  core_adc_i1_enable
create_bd_port -dir O  core_adc_q1_enable
create_bd_port -dir O  core_adc_i0_valid
create_bd_port -dir O  core_adc_q0_valid
create_bd_port -dir O  core_adc_i1_valid
create_bd_port -dir O  core_adc_q1_valid
create_bd_port -dir O  -from 15 -to 0 core_adc_i0_data
create_bd_port -dir O  -from 15 -to 0 core_adc_q0_data
create_bd_port -dir O  -from 15 -to 0 core_adc_i1_data
create_bd_port -dir O  -from 15 -to 0 core_adc_q1_data

create_bd_port -dir I  dma_adc_i0_enable
create_bd_port -dir I  dma_adc_q0_enable
create_bd_port -dir I  dma_adc_i1_enable
create_bd_port -dir I  dma_adc_q1_enable
create_bd_port -dir I  dma_adc_i0_valid
create_bd_port -dir I  dma_adc_q0_valid
create_bd_port -dir I  dma_adc_i1_valid
create_bd_port -dir I  dma_adc_q1_valid
create_bd_port -dir I  -from 15 -to 0 dma_adc_i0_data
create_bd_port -dir I  -from 15 -to 0 dma_adc_q0_data
create_bd_port -dir I  -from 15 -to 0 dma_adc_i1_data
create_bd_port -dir I  -from 15 -to 0 dma_adc_q1_data

create_bd_port -dir I  -from 31 -to 0 up_dac_gpio_in
create_bd_port -dir I  -from 31 -to 0 up_adc_gpio_in
create_bd_port -dir O  -from 31 -to 0 up_dac_gpio_out
create_bd_port -dir O  -from 31 -to 0 up_adc_gpio_out

# re-wiring, split between ad9361 core & upack/cpack modules

ad_connect  axi_ad9361_clk clk

ad_reconct  util_ad9361_dac_upack/dac_enable_0 dma_dac_i0_enable
ad_reconct  util_ad9361_dac_upack/dac_enable_1 dma_dac_q0_enable
ad_reconct  util_ad9361_dac_upack/dac_enable_2 dma_dac_i1_enable
ad_reconct  util_ad9361_dac_upack/dac_enable_3 dma_dac_q1_enable
ad_reconct  util_ad9361_dac_upack/dac_valid_0 dma_dac_i0_valid
ad_reconct  util_ad9361_dac_upack/dac_valid_1 dma_dac_q0_valid
ad_reconct  util_ad9361_dac_upack/dac_valid_2 dma_dac_i1_valid
ad_reconct  util_ad9361_dac_upack/dac_valid_3 dma_dac_q1_valid
ad_reconct  util_ad9361_dac_upack/dac_data_0 dma_dac_i0_data
ad_reconct  util_ad9361_dac_upack/dac_data_1 dma_dac_q0_data
ad_reconct  util_ad9361_dac_upack/dac_data_2 dma_dac_i1_data
ad_reconct  util_ad9361_dac_upack/dac_data_3 dma_dac_q1_data
ad_reconct  axi_ad9361/dac_enable_i0 core_dac_i0_enable
ad_reconct  axi_ad9361/dac_enable_q0 core_dac_q0_enable
ad_reconct  axi_ad9361/dac_enable_i1 core_dac_i1_enable
ad_reconct  axi_ad9361/dac_enable_q1 core_dac_q1_enable
ad_reconct  axi_ad9361/dac_valid_i0 core_dac_i0_valid
ad_reconct  axi_ad9361/dac_valid_q0 core_dac_q0_valid
ad_reconct  axi_ad9361/dac_valid_i1 core_dac_i1_valid
ad_reconct  axi_ad9361/dac_valid_q1 core_dac_q1_valid
ad_reconct  axi_ad9361/dac_data_i0 core_dac_i0_data
ad_reconct  axi_ad9361/dac_data_q0 core_dac_q0_data
ad_reconct  axi_ad9361/dac_data_i1 core_dac_i1_data
ad_reconct  axi_ad9361/dac_data_q1 core_dac_q1_data

ad_reconct  util_ad9361_adc_fifo/din_enable_0 dma_adc_i0_enable
ad_reconct  util_ad9361_adc_fifo/din_enable_1 dma_adc_q0_enable
ad_reconct  util_ad9361_adc_fifo/din_enable_2 dma_adc_i1_enable
ad_reconct  util_ad9361_adc_fifo/din_enable_3 dma_adc_q1_enable
ad_reconct  util_ad9361_adc_fifo/din_valid_0 dma_adc_i0_valid
ad_reconct  util_ad9361_adc_fifo/din_valid_1 dma_adc_q0_valid
ad_reconct  util_ad9361_adc_fifo/din_valid_2 dma_adc_i1_valid
ad_reconct  util_ad9361_adc_fifo/din_valid_3 dma_adc_q1_valid
ad_reconct  util_ad9361_adc_fifo/din_data_0 dma_adc_i0_data
ad_reconct  util_ad9361_adc_fifo/din_data_1 dma_adc_q0_data
ad_reconct  util_ad9361_adc_fifo/din_data_2 dma_adc_i1_data
ad_reconct  util_ad9361_adc_fifo/din_data_3 dma_adc_q1_data
ad_reconct  axi_ad9361/adc_enable_i0 core_adc_i0_enable
ad_reconct  axi_ad9361/adc_enable_q0 core_adc_q0_enable
ad_reconct  axi_ad9361/adc_enable_i1 core_adc_i1_enable
ad_reconct  axi_ad9361/adc_enable_q1 core_adc_q1_enable
ad_reconct  axi_ad9361/adc_valid_i0 core_adc_i0_valid
ad_reconct  axi_ad9361/adc_valid_q0 core_adc_q0_valid
ad_reconct  axi_ad9361/adc_valid_i1 core_adc_i1_valid
ad_reconct  axi_ad9361/adc_valid_q1 core_adc_q1_valid
ad_reconct  axi_ad9361/adc_data_i0 core_adc_i0_data
ad_reconct  axi_ad9361/adc_data_q0 core_adc_q0_data
ad_reconct  axi_ad9361/adc_data_i1 core_adc_i1_data
ad_reconct  axi_ad9361/adc_data_q1 core_adc_q1_data

ad_reconct  axi_ad9361/up_dac_gpio_in up_dac_gpio_in
ad_reconct  axi_ad9361/up_adc_gpio_in up_adc_gpio_in
ad_reconct  axi_ad9361/up_dac_gpio_out up_dac_gpio_out
ad_reconct  axi_ad9361/up_adc_gpio_out up_adc_gpio_out

