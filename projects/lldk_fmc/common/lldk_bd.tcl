# ltc2387

create_bd_port -dir O clk_gate
create_bd_port -dir O sampling_clk

create_bd_port -dir I rx_0_dco_p
create_bd_port -dir I rx_0_dco_n
create_bd_port -dir O rx_0_cnv
create_bd_port -dir I rx_0_da_p
create_bd_port -dir I rx_0_da_n
create_bd_port -dir I rx_0_db_p
create_bd_port -dir I rx_0_db_n

create_bd_port -dir I rx_1_dco_p
create_bd_port -dir I rx_1_dco_n
create_bd_port -dir O rx_1_cnv
create_bd_port -dir I rx_1_da_p
create_bd_port -dir I rx_1_da_n
create_bd_port -dir I rx_1_db_p
create_bd_port -dir I rx_1_db_n

create_bd_port -dir I rx_2_dco_p
create_bd_port -dir I rx_2_dco_n
create_bd_port -dir O rx_2_cnv
create_bd_port -dir I rx_2_da_p
create_bd_port -dir I rx_2_da_n
create_bd_port -dir I rx_2_db_p
create_bd_port -dir I rx_2_db_n

create_bd_port -dir I rx_3_dco_p
create_bd_port -dir I rx_3_dco_n
create_bd_port -dir O rx_3_cnv
create_bd_port -dir I rx_3_da_p
create_bd_port -dir I rx_3_da_n
create_bd_port -dir I rx_3_db_p
create_bd_port -dir I rx_3_db_n

# max7301

create_bd_port -dir I max_spi_csn_i
create_bd_port -dir O max_spi_csn_o
create_bd_port -dir I max_spi_clk_i
create_bd_port -dir O max_spi_clk_o
create_bd_port -dir I max_spi_sdo_i
create_bd_port -dir O max_spi_sdo_o
create_bd_port -dir I max_spi_sdi_i

create_bd_port -dir I dac1_spi_csn_i
create_bd_port -dir O dac1_spi_csn_o
create_bd_port -dir I dac1_spi_clk_i
create_bd_port -dir O dac1_spi_clk_o
create_bd_port -dir I dac1_spi_sdo_i
create_bd_port -dir O dac1_spi_sdo_o
create_bd_port -dir I dac1_spi_sdi_i

create_bd_port -dir I dac2_spi_csn_i
create_bd_port -dir O dac2_spi_csn_o
create_bd_port -dir I dac2_spi_clk_i
create_bd_port -dir O dac2_spi_clk_o
create_bd_port -dir I dac2_spi_sdo_i
create_bd_port -dir O dac2_spi_sdo_o
create_bd_port -dir I dac2_spi_sdi_i

# adc peripheral

ad_ip_instance axi_ltc2387 axi_ltc2387_0
ad_ip_parameter axi_ltc2387_0 CONFIG.ADC_RES 16
ad_ip_parameter axi_ltc2387_0 CONFIG.OUT_RES 16
ad_ip_parameter axi_ltc2387_0 CONFIG.TWOLANES 1
ad_ip_parameter axi_ltc2387_0 CONFIG.ADC_INIT_DELAY 27

ad_ip_instance axi_ltc2387 axi_ltc2387_1
ad_ip_parameter axi_ltc2387_1 CONFIG.ADC_RES 16
ad_ip_parameter axi_ltc2387_1 CONFIG.OUT_RES 16
ad_ip_parameter axi_ltc2387_1 CONFIG.TWOLANES 1
ad_ip_parameter axi_ltc2387_1 CONFIG.ADC_INIT_DELAY 27
ad_ip_parameter axi_ltc2387_1 CONFIG.IODELAY_CTRL 0

ad_ip_instance axi_ltc2387 axi_ltc2387_2
ad_ip_parameter axi_ltc2387_2 CONFIG.ADC_RES 16
ad_ip_parameter axi_ltc2387_2 CONFIG.OUT_RES 16
ad_ip_parameter axi_ltc2387_2 CONFIG.TWOLANES 1
ad_ip_parameter axi_ltc2387_2 CONFIG.ADC_INIT_DELAY 27
ad_ip_parameter axi_ltc2387_2 CONFIG.IO_DELAY_GROUP adc_if_delay_group2

ad_ip_instance axi_ltc2387 axi_ltc2387_3
ad_ip_parameter axi_ltc2387_3 CONFIG.ADC_RES 16
ad_ip_parameter axi_ltc2387_3 CONFIG.OUT_RES 16
ad_ip_parameter axi_ltc2387_3 CONFIG.TWOLANES 1
ad_ip_parameter axi_ltc2387_3 CONFIG.ADC_INIT_DELAY 28
ad_ip_parameter axi_ltc2387_3 CONFIG.IO_DELAY_GROUP adc_if_delay_group2
ad_ip_parameter axi_ltc2387_3 CONFIG.IODELAY_CTRL 0

# axi_pwm_gen

ad_ip_instance axi_pwm_gen axi_pwm_gen
ad_ip_parameter axi_pwm_gen CONFIG.N_PWMS 4
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_0_WIDTH 1
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_0_PERIOD 8
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_1_WIDTH 5
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_1_PERIOD 8
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_1_OFFSET 0

ad_ip_instance axi_pwm_gen axi_pwm_gen_1
ad_ip_parameter axi_pwm_gen_1 CONFIG.N_PWMS 4
ad_ip_parameter axi_pwm_gen_1 CONFIG.PULSE_0_WIDTH 1
ad_ip_parameter axi_pwm_gen_1 CONFIG.PULSE_0_PERIOD 8
ad_ip_parameter axi_pwm_gen_1 CONFIG.PULSE_1_WIDTH 5
ad_ip_parameter axi_pwm_gen_1 CONFIG.PULSE_1_PERIOD 8
ad_ip_parameter axi_pwm_gen_1 CONFIG.PULSE_1_OFFSET 0

# constant 1

create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_vcc_1

# sys_rstgen

ad_ip_instance proc_sys_reset pack_sys_rstgen
ad_ip_parameter pack_sys_rstgen CONFIG.C_EXT_RST_WIDTH 1

# util_cpack2

ad_ip_instance util_cpack2 util_ltc2387_adc_pack
ad_ip_parameter util_ltc2387_adc_pack CONFIG.NUM_OF_CHANNELS 4
ad_ip_parameter util_ltc2387_adc_pack CONFIG.SAMPLE_DATA_WIDTH 16

# dma

ad_ip_instance axi_dmac axi_ltc2387_dma
ad_ip_parameter axi_ltc2387_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ltc2387_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ltc2387_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ltc2387_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ltc2387_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ltc2387_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ltc2387_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ltc2387_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter axi_ltc2387_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_ip_instance axi_clkgen axi_clkgen
ad_ip_parameter axi_clkgen CONFIG.ID 1
ad_ip_parameter axi_clkgen CONFIG.CLKIN_PERIOD 10
ad_ip_parameter axi_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter axi_clkgen CONFIG.VCO_MUL 6
ad_ip_parameter axi_clkgen CONFIG.CLK0_DIV 5

ad_connect sys_ps7/FCLK_CLK0  axi_clkgen/clk
ad_connect axi_clkgen/clk_0   sampling_clk

ad_connect sys_ps7/FCLK_RESET0_N  pack_sys_rstgen/ext_reset_in
ad_connect axi_clkgen/clk_0       pack_sys_rstgen/slowest_sync_clk

# ltc adc connections

ad_connect sys_200m_clk axi_ltc2387_0/delay_clk

ad_connect axi_clkgen/clk_0  axi_ltc2387_0/ref_clk
ad_connect clk_gate          axi_ltc2387_0/clk_gate
ad_connect rx_0_dco_p        axi_ltc2387_0/dco_p
ad_connect rx_0_dco_n        axi_ltc2387_0/dco_n
ad_connect rx_0_da_n         axi_ltc2387_0/da_n
ad_connect rx_0_da_p         axi_ltc2387_0/da_p
ad_connect rx_0_db_n         axi_ltc2387_0/db_n
ad_connect rx_0_db_p         axi_ltc2387_0/db_p

ad_connect sys_200m_clk axi_ltc2387_1/delay_clk

ad_connect axi_clkgen/clk_0  axi_ltc2387_1/ref_clk
ad_connect clk_gate          axi_ltc2387_1/clk_gate
ad_connect rx_1_dco_p        axi_ltc2387_1/dco_p
ad_connect rx_1_dco_n        axi_ltc2387_1/dco_n
ad_connect rx_1_da_n         axi_ltc2387_1/da_n
ad_connect rx_1_da_p         axi_ltc2387_1/da_p
ad_connect rx_1_db_n         axi_ltc2387_1/db_n
ad_connect rx_1_db_p         axi_ltc2387_1/db_p

ad_connect sys_200m_clk axi_ltc2387_2/delay_clk

ad_connect axi_clkgen/clk_0  axi_ltc2387_2/ref_clk
ad_connect clk_gate          axi_ltc2387_2/clk_gate
ad_connect rx_2_dco_p        axi_ltc2387_2/dco_p
ad_connect rx_2_dco_n        axi_ltc2387_2/dco_n
ad_connect rx_2_da_n         axi_ltc2387_2/da_n
ad_connect rx_2_da_p         axi_ltc2387_2/da_p
ad_connect rx_2_db_n         axi_ltc2387_2/db_n
ad_connect rx_2_db_p         axi_ltc2387_2/db_p

ad_connect sys_200m_clk axi_ltc2387_3/delay_clk

ad_connect axi_clkgen/clk_0  axi_ltc2387_3/ref_clk
ad_connect clk_gate          axi_ltc2387_3/clk_gate
ad_connect rx_3_dco_p        axi_ltc2387_3/dco_p
ad_connect rx_3_dco_n        axi_ltc2387_3/dco_n
ad_connect rx_3_da_n         axi_ltc2387_3/da_n
ad_connect rx_3_da_p         axi_ltc2387_3/da_p
ad_connect rx_3_db_n         axi_ltc2387_3/db_n
ad_connect rx_3_db_p         axi_ltc2387_3/db_p

ad_connect rx_0_cnv   axi_pwm_gen/pwm_0
ad_connect rx_1_cnv   axi_pwm_gen/pwm_0
ad_connect rx_2_cnv   axi_pwm_gen/pwm_0
ad_connect rx_3_cnv   axi_pwm_gen/pwm_0
ad_connect clk_gate   axi_pwm_gen/pwm_1

ad_connect axi_clkgen/clk_0   axi_pwm_gen/ext_clk
ad_connect sys_cpu_resetn     axi_pwm_gen/s_axi_aresetn
ad_connect sys_cpu_clk        axi_pwm_gen/s_axi_aclk
ad_connect axi_clkgen/clk_0   axi_pwm_gen_1/ext_clk
ad_connect sys_cpu_resetn     axi_pwm_gen_1/s_axi_aresetn
ad_connect sys_cpu_clk        axi_pwm_gen_1/s_axi_aclk

ad_connect axi_clkgen/clk_0                  util_ltc2387_adc_pack/clk
ad_connect pack_sys_rstgen/peripheral_reset  util_ltc2387_adc_pack/reset
ad_connect axi_ltc2387_0/adc_valid           util_ltc2387_adc_pack/fifo_wr_en

for {set i 0} {$i < 4} {incr i} {
  ad_connect axi_ltc2387_$i/adc_data  util_ltc2387_adc_pack/fifo_wr_data_$i
  ad_connect const_vcc_1/dout  util_ltc2387_adc_pack/enable_$i
}

ad_connect axi_clkgen/clk_0         axi_ltc2387_dma/fifo_wr_clk
ad_connect axi_ltc2387_0/adc_valid  axi_ltc2387_dma/fifo_wr_en

ad_connect util_ltc2387_adc_pack/fifo_wr_overflow  axi_ltc2387_0/adc_dovf
ad_connect util_ltc2387_adc_pack/fifo_wr_overflow  axi_ltc2387_1/adc_dovf
ad_connect util_ltc2387_adc_pack/fifo_wr_overflow  axi_ltc2387_2/adc_dovf
ad_connect util_ltc2387_adc_pack/fifo_wr_overflow  axi_ltc2387_3/adc_dovf
ad_connect util_ltc2387_adc_pack/packed_fifo_wr    axi_ltc2387_dma/fifo_wr

# quad SPI

ad_ip_instance axi_quad_spi max_spi
ad_ip_parameter max_spi CONFIG.C_USE_STARTUP 0
ad_ip_parameter max_spi CONFIG.C_USE_STARTUP_INT 0
ad_ip_parameter max_spi CONFIG.C_SPI_MODE 0
ad_ip_parameter max_spi CONFIG.C_SCK_RATIO 16
ad_ip_parameter max_spi CONFIG.C_NUM_TRANSFER_BITS 16

## connections

ad_connect sys_ps7/FCLK_CLK0  max_spi/ext_spi_clk
ad_connect sys_ps7/FCLK_CLK0  max_spi/s_axi_aclk

ad_connect max_spi_csn_i max_spi/ss_i
ad_connect max_spi_csn_o max_spi/ss_o
ad_connect max_spi_clk_i max_spi/sck_i
ad_connect max_spi_clk_o max_spi/sck_o
ad_connect max_spi_sdo_i max_spi/io0_i
ad_connect max_spi_sdo_o max_spi/io0_o
ad_connect max_spi_sdi_i max_spi/io1_i

ad_ip_instance axi_quad_spi dac1_spi
ad_ip_parameter dac1_spi CONFIG.C_USE_STARTUP 0
ad_ip_parameter dac1_spi CONFIG.C_USE_STARTUP_INT 0
ad_ip_parameter dac1_spi CONFIG.C_SPI_MODE 0
ad_ip_parameter dac1_spi CONFIG.C_SCK_RATIO 16

## connections

ad_connect axi_clkgen/clk_0   dac1_spi/ext_spi_clk
ad_connect sys_ps7/FCLK_CLK0  dac1_spi/s_axi_aclk

ad_connect dac1_spi_csn_i dac1_spi/ss_i
ad_connect dac1_spi_csn_o dac1_spi/ss_o
ad_connect dac1_spi_clk_i dac1_spi/sck_i
ad_connect dac1_spi_clk_o dac1_spi/sck_o
ad_connect dac1_spi_sdo_i dac1_spi/io0_i
ad_connect dac1_spi_sdo_o dac1_spi/io0_o
ad_connect dac1_spi_sdi_i dac1_spi/io1_i

ad_ip_instance axi_quad_spi dac2_spi
ad_ip_parameter dac2_spi CONFIG.C_USE_STARTUP 0
ad_ip_parameter dac2_spi CONFIG.C_USE_STARTUP_INT 0
ad_ip_parameter dac2_spi CONFIG.C_SPI_MODE 0
ad_ip_parameter dac2_spi CONFIG.C_SCK_RATIO 16

## connections

ad_connect axi_clkgen/clk_0   dac2_spi/ext_spi_clk
ad_connect sys_ps7/FCLK_CLK0  dac2_spi/s_axi_aclk

ad_connect dac2_spi_csn_i dac2_spi/ss_i
ad_connect dac2_spi_csn_o dac2_spi/ss_o
ad_connect dac2_spi_clk_i dac2_spi/sck_i
ad_connect dac2_spi_clk_o dac2_spi/sck_o
ad_connect dac2_spi_sdo_i dac2_spi/io0_i
ad_connect dac2_spi_sdo_o dac2_spi/io0_o
ad_connect dac2_spi_sdi_i dac2_spi/io1_i

# address mapping

ad_cpu_interconnect 0x44A00000 axi_ltc2387_0
ad_cpu_interconnect 0x44A10000 axi_ltc2387_1
ad_cpu_interconnect 0x44A20000 axi_ltc2387_2
ad_cpu_interconnect 0x44A30000 axi_ltc2387_3
ad_cpu_interconnect 0x44A40000 axi_ltc2387_dma
ad_cpu_interconnect 0x44B00000 axi_clkgen
ad_cpu_interconnect 0x44B10000 axi_pwm_gen
ad_cpu_interconnect 0x44B20000 max_spi
ad_cpu_interconnect 0x44B30000 dac1_spi
ad_cpu_interconnect 0x44B40000 dac2_spi
ad_cpu_interconnect 0x44C10000 axi_pwm_gen_1

# interconnect (adc)

ad_mem_hp2_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_cpu_clk axi_ltc2387_dma/m_dest_axi

ad_connect $sys_cpu_resetn axi_ltc2387_dma/m_dest_axi_aresetn

# interrupts

ad_cpu_interrupt ps-13 mb-13 axi_ltc2387_dma/irq
ad_cpu_interrupt ps-8 mb-8 max_spi/ip2intc_irpt
ad_cpu_interrupt ps-7 mb-7 dac1_spi/ip2intc_irpt
ad_cpu_interrupt ps-6 mb-6 dac2_spi/ip2intc_irpt
