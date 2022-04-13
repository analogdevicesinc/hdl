# specify ADC resolution -- the design supports 16/18 bit resolutions
set adc_resolution 16

# specify number of channels -- the design supports one lane/two lanes
set two_lanes 2

#create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 dac_0_spi
#create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 dac_1_spi

#de aici

# ltc2387

#create_bd_port -dir I ref_clk
create_bd_port -dir O clk_gate
create_bd_port -dir O sampling_clk

create_bd_port -dir I rx_0_dco_p
create_bd_port -dir I rx_0_dco_n
create_bd_port -dir O rx_0_cnv
create_bd_port -dir I rx_0_da_p
create_bd_port -dir I rx_0_da_n
create_bd_port -dir I rx_0_db_p
create_bd_port -dir I rx_0_db_n

#
create_bd_port -dir I rx_1_dco_p
create_bd_port -dir I rx_1_dco_n
create_bd_port -dir O rx_1_cnv
create_bd_port -dir I rx_1_da_p
create_bd_port -dir I rx_1_da_n
create_bd_port -dir I rx_1_db_p
create_bd_port -dir I rx_1_db_n

#
create_bd_port -dir I rx_2_dco_p
create_bd_port -dir I rx_2_dco_n
create_bd_port -dir O rx_2_cnv
create_bd_port -dir I rx_2_da_p
create_bd_port -dir I rx_2_da_n
create_bd_port -dir I rx_2_db_p
create_bd_port -dir I rx_2_db_n

#
create_bd_port -dir I rx_3_dco_p
create_bd_port -dir I rx_3_dco_n
create_bd_port -dir O rx_3_cnv
create_bd_port -dir I rx_3_da_p
create_bd_port -dir I rx_3_da_n
create_bd_port -dir I rx_3_db_p
create_bd_port -dir I rx_3_db_n

#

create_bd_port -dir O  tx_0_1_cs
create_bd_port -dir O  tx_0_1_sclk
#create_bd_port -dir IO tx_0_1_sdio0
#create_bd_port -dir IO tx_0_1_sdio1
#create_bd_port -dir IO tx_0_1_sdio2
#create_bd_port -dir IO tx_0_1_sdio3

create_bd_port -dir O tx_0_1_sdt0
create_bd_port -dir O tx_0_1_sdt1
create_bd_port -dir O tx_0_1_sdt2
create_bd_port -dir O tx_0_1_sdt3

#create_bd_port -dir O tx_0_1_sdt

create_bd_port -dir I tx_0_1_sdi0
create_bd_port -dir I tx_0_1_sdi1
create_bd_port -dir I tx_0_1_sdi2
create_bd_port -dir I tx_0_1_sdi3
create_bd_port -dir O tx_0_1_sdo0
create_bd_port -dir O tx_0_1_sdo1
create_bd_port -dir O tx_0_1_sdo2
create_bd_port -dir O tx_0_1_sdo3

#
create_bd_port -dir O  tx_2_3_cs
create_bd_port -dir O  tx_2_3_sclk
#create_bd_port -dir IO tx_2_3_sdio0
#create_bd_port -dir IO tx_2_3_sdio1
#create_bd_port -dir IO tx_2_3_sdio2
#create_bd_port -dir IO tx_2_3_sdio3

create_bd_port -dir O tx_2_3_sdt0
create_bd_port -dir O tx_2_3_sdt1
create_bd_port -dir O tx_2_3_sdt2
create_bd_port -dir O tx_2_3_sdt3

#create_bd_port -dir O tx_2_3_sdt

create_bd_port -dir I tx_2_3_sdi0
create_bd_port -dir I tx_2_3_sdi1
create_bd_port -dir I tx_2_3_sdi2
create_bd_port -dir I tx_2_3_sdi3
create_bd_port -dir O tx_2_3_sdo0
create_bd_port -dir O tx_2_3_sdo1
create_bd_port -dir O tx_2_3_sdo2
create_bd_port -dir O tx_2_3_sdo3


if {$adc_resolution == 16} {
  set data_width 16
  if {$two_lanes == 0} {
    set gate_width 9
  } else {
    set gate_width 4
  }} elseif {$adc_resolution == 18} {
  set data_width 32
  if {$two_lanes == 0} {
    set gate_width 8
  } else {
    set gate_width 5
  }
};

# adc peripheral

ad_ip_instance axi_ltc2387 axi_ltc2387_0
ad_ip_parameter axi_ltc2387_0 CONFIG.ADC_RES $adc_resolution
ad_ip_parameter axi_ltc2387_0 CONFIG.OUT_RES $data_width
ad_ip_parameter axi_ltc2387_0 CONFIG.TWOLANES $two_lanes
ad_ip_parameter axi_ltc2387_0 CONFIG.ADC_INIT_DELAY 27
#
ad_ip_instance axi_ltc2387 axi_ltc2387_1
ad_ip_parameter axi_ltc2387_1 CONFIG.ADC_RES $adc_resolution
ad_ip_parameter axi_ltc2387_1 CONFIG.OUT_RES $data_width
ad_ip_parameter axi_ltc2387_1 CONFIG.TWOLANES $two_lanes
ad_ip_parameter axi_ltc2387_1 CONFIG.ADC_INIT_DELAY 27
ad_ip_parameter axi_ltc2387_1 CONFIG.IODELAY_CTRL 0
#
ad_ip_instance axi_ltc2387 axi_ltc2387_2
ad_ip_parameter axi_ltc2387_2 CONFIG.ADC_RES $adc_resolution
ad_ip_parameter axi_ltc2387_2 CONFIG.OUT_RES $data_width
ad_ip_parameter axi_ltc2387_2 CONFIG.TWOLANES $two_lanes
ad_ip_parameter axi_ltc2387_2 CONFIG.ADC_INIT_DELAY 27
ad_ip_parameter axi_ltc2387_2 CONFIG.IO_DELAY_GROUP adc_if_delay_group2
#
ad_ip_instance axi_ltc2387 axi_ltc2387_3
ad_ip_parameter axi_ltc2387_3 CONFIG.ADC_RES $adc_resolution
ad_ip_parameter axi_ltc2387_3 CONFIG.OUT_RES $data_width
ad_ip_parameter axi_ltc2387_3 CONFIG.TWOLANES $two_lanes
ad_ip_parameter axi_ltc2387_3 CONFIG.ADC_INIT_DELAY 27
ad_ip_parameter axi_ltc2387_3 CONFIG.IO_DELAY_GROUP adc_if_delay_group2
ad_ip_parameter axi_ltc2387_3 CONFIG.IODELAY_CTRL 0


# axi pwm gen

ad_ip_instance axi_pwm_gen axi_pwm_gen
ad_ip_parameter axi_pwm_gen CONFIG.N_PWMS 2
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_0_WIDTH 2
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_0_PERIOD 13
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_1_WIDTH $gate_width
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_1_PERIOD 13
ad_ip_parameter axi_pwm_gen CONFIG.PULSE_1_OFFSET 0

# util_cpack2

ad_ip_instance util_cpack2 axi_ltc_cpack [list \
  NUM_OF_CHANNELS 4 \
  SAMPLE_DATA_WIDTH 16 \
]


# dma

ad_ip_instance axi_dmac axi_ltc2387_dma
ad_ip_parameter axi_ltc2387_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ltc2387_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ltc2387_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ltc2387_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ltc2387_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ltc2387_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ltc2387_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ltc2387_dma CONFIG.DMA_DATA_WIDTH_SRC $data_width
ad_ip_parameter axi_ltc2387_dma CONFIG.DMA_DATA_WIDTH_DEST 64

ad_ip_instance axi_clkgen axi_clkgen
ad_ip_parameter axi_clkgen CONFIG.ID 1
ad_ip_parameter axi_clkgen CONFIG.CLKIN_PERIOD 10
ad_ip_parameter axi_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter axi_clkgen CONFIG.VCO_MUL 6
ad_ip_parameter axi_clkgen CONFIG.CLK0_DIV 5
#ad_ip_parameter axi_clkgen CONFIG.VCO_MUL 9.75
#set_property -dict [list CONFIG.VCO_MUL {6}] [get_bd_cells axi_clkgen]
#ad_ip_parameter axi_clkgen CONFIG.ENABLE_CLKIN1 true
#ad_ip_parameter axi_clkgen CONFIG.ENABLE_CLKOUT1 true


# quad SPI

ad_ip_instance axi_quad_spi axi_quad_spi_0
ad_ip_parameter axi_quad_spi_0 CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_quad_spi_0 CONFIG.C_USE_STARTUP_INT 0
ad_ip_parameter axi_quad_spi_0 CONFIG.C_SPI_MODE 2
ad_ip_parameter axi_quad_spi_0 CONFIG.C_SCK_RATIO 2



ad_ip_instance axi_quad_spi axi_quad_spi_1
ad_ip_parameter axi_quad_spi_1 CONFIG.C_USE_STARTUP 0
ad_ip_parameter axi_quad_spi_1 CONFIG.C_USE_STARTUP_INT 0
ad_ip_parameter axi_quad_spi_1 CONFIG.C_SPI_MODE 2
ad_ip_parameter axi_quad_spi_1 CONFIG.C_SCK_RATIO 2




# connections

ad_connect sys_ps7/FCLK_CLK0  axi_quad_spi_0/ext_spi_clk
ad_connect sys_ps7/FCLK_CLK0  axi_quad_spi_0/s_axi_aclk
ad_connect sys_ps7/FCLK_CLK0  axi_quad_spi_1/ext_spi_clk
ad_connect sys_ps7/FCLK_CLK0  axi_quad_spi_1/s_axi_aclk

ad_connect sys_ps7/FCLK_CLK0  axi_clkgen/clk
ad_connect axi_clkgen/clk_0  axi_ltc_cpack/clk
ad_connect axi_clkgen/clk_0  sampling_clk
#ad_connect axi_clkgen/clk_0  ref_clk_0
#ad_connect axi_clkgen/clk_0  ref_clk_1
#ad_connect axi_clkgen/clk_0  ref_clk_2
#ad_connect axi_clkgen/clk_0  ref_clk_3

# quad spi connections

#ad_connect axi_quad_spi_0/SPI_0       dac_0_spi
#ad_connect axi_quad_spi_1/SPI_0       dac_1_spi
ad_connect axi_quad_spi_0/io0_i  tx_0_1_sdi0
ad_connect axi_quad_spi_0/io0_o  tx_0_1_sdo0
ad_connect axi_quad_spi_0/io0_t  tx_0_1_sdt0
ad_connect axi_quad_spi_0/io1_i  tx_0_1_sdi1
ad_connect axi_quad_spi_0/io1_o  tx_0_1_sdo1
ad_connect axi_quad_spi_0/io1_t  tx_0_1_sdt1
ad_connect axi_quad_spi_0/io2_i  tx_0_1_sdi2
ad_connect axi_quad_spi_0/io2_o  tx_0_1_sdo2
ad_connect axi_quad_spi_0/io2_t  tx_0_1_sdt2
ad_connect axi_quad_spi_0/io3_i  tx_0_1_sdi3
ad_connect axi_quad_spi_0/io3_o  tx_0_1_sdo3
ad_connect axi_quad_spi_0/io3_t  tx_0_1_sdt3
ad_connect axi_quad_spi_0/sck_o  tx_0_1_sclk
ad_connect axi_quad_spi_0/ss_o   tx_0_1_cs
ad_connect axi_quad_spi_0/ss_i   axi_quad_spi_0/ss_o

ad_connect axi_quad_spi_1/io0_i  tx_2_3_sdi0
ad_connect axi_quad_spi_1/io0_o  tx_2_3_sdo0
ad_connect axi_quad_spi_1/io0_t  tx_2_3_sdt0
ad_connect axi_quad_spi_1/io1_i  tx_2_3_sdi1
ad_connect axi_quad_spi_1/io1_o  tx_2_3_sdo1
ad_connect axi_quad_spi_1/io1_t  tx_2_3_sdt1
ad_connect axi_quad_spi_1/io2_i  tx_2_3_sdi2
ad_connect axi_quad_spi_1/io2_o  tx_2_3_sdo2
ad_connect axi_quad_spi_1/io2_t  tx_2_3_sdt2
ad_connect axi_quad_spi_1/io3_i  tx_2_3_sdi3
ad_connect axi_quad_spi_1/io3_o  tx_2_3_sdo3
ad_connect axi_quad_spi_1/io3_t  tx_2_3_sdt3
ad_connect axi_quad_spi_1/sck_o  tx_2_3_sclk
ad_connect axi_quad_spi_1/ss_o   tx_2_3_cs
ad_connect axi_quad_spi_1/ss_i   axi_quad_spi_1/ss_o


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
#
ad_connect sys_200m_clk axi_ltc2387_1/delay_clk

ad_connect axi_clkgen/clk_0  axi_ltc2387_1/ref_clk
ad_connect clk_gate          axi_ltc2387_1/clk_gate
ad_connect rx_1_dco_p        axi_ltc2387_1/dco_p
ad_connect rx_1_dco_n        axi_ltc2387_1/dco_n
ad_connect rx_1_da_n         axi_ltc2387_1/da_n
ad_connect rx_1_da_p         axi_ltc2387_1/da_p
ad_connect rx_1_db_n         axi_ltc2387_1/db_n
ad_connect rx_1_db_p         axi_ltc2387_1/db_p
#
ad_connect sys_200m_clk axi_ltc2387_2/delay_clk

ad_connect axi_clkgen/clk_0  axi_ltc2387_2/ref_clk
ad_connect clk_gate          axi_ltc2387_2/clk_gate
ad_connect rx_2_dco_p        axi_ltc2387_2/dco_p
ad_connect rx_2_dco_n        axi_ltc2387_2/dco_n
ad_connect rx_2_da_n         axi_ltc2387_2/da_n
ad_connect rx_2_da_p         axi_ltc2387_2/da_p
ad_connect rx_2_db_n         axi_ltc2387_2/db_n
ad_connect rx_2_db_p         axi_ltc2387_2/db_p
#
ad_connect sys_200m_clk axi_ltc2387_3/delay_clk

ad_connect axi_clkgen/clk_0  axi_ltc2387_3/ref_clk
ad_connect clk_gate          axi_ltc2387_3/clk_gate
ad_connect rx_3_dco_p        axi_ltc2387_3/dco_p
ad_connect rx_3_dco_n        axi_ltc2387_3/dco_n
ad_connect rx_3_da_n         axi_ltc2387_3/da_n
ad_connect rx_3_da_p         axi_ltc2387_3/da_p
ad_connect rx_3_db_n         axi_ltc2387_3/db_n
ad_connect rx_3_db_p         axi_ltc2387_3/db_p


# cpack connections
# ad_connect axi_ltc2387_0/adc_valid  axi_ltc_cpack/fifo_wr_en
for {set i 0} {$i < 4} {incr i} {
  #ad_connect axi_ltc2387_0/adc_valid  axi_ltc_cpack/enable_$i
  ad_connect axi_ltc2387_$i/adc_valid  axi_ltc_cpack/enable_$i
  ad_connect axi_ltc2387_$i/adc_data  axi_ltc_cpack/fifo_wr_data_$i
}
# ad_connect axi_ltc2387_0/adc_dovf   axi_ltc_cpack/fifo_wr_overflow

ad_connect axi_ltc_cpack/packed_fifo_wr  axi_ltc2387_dma/fifo_wr
# ad_connect axi_ltc_cpack/fifo_wr_en  axi_ltc2387_dma/fifo_wr_en
# ad_connect axi_ltc_cpack/packed_fifo_wr_data   axi_ltc2387_dma/fifo_wr_din
# ad_connect axi_ltc_cpack/fifo_wr_overflow   axi_ltc2387_dma/fifo_wr_overflow


ad_connect cnv        axi_pwm_gen/pwm_0
ad_connect clk_gate   axi_pwm_gen/pwm_1

ad_connect axi_clkgen/clk_0       axi_pwm_gen/ext_clk
ad_connect sys_cpu_resetn         axi_pwm_gen/s_axi_aresetn
ad_connect sys_cpu_clk            axi_pwm_gen/s_axi_aclk
ad_connect axi_clkgen/clk_0       axi_ltc2387_dma/fifo_wr_clk




# address mapping

ad_cpu_interconnect 0x44A00000 axi_ltc2387_0
ad_cpu_interconnect 0x44A30000 axi_ltc2387_1
ad_cpu_interconnect 0x44A60000 axi_ltc2387_2
ad_cpu_interconnect 0x44A90000 axi_ltc2387_3
ad_cpu_interconnect 0x44AC0000 axi_ltc2387_dma
ad_cpu_interconnect 0x44AF0000 axi_pwm_gen
ad_cpu_interconnect 0x44B00000 axi_clkgen
ad_cpu_interconnect 0x44B30000 axi_quad_spi_0
ad_cpu_interconnect 0x44B60000 axi_quad_spi_1

# interconnect (adc)

ad_mem_hp2_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_cpu_clk axi_ltc2387_dma/m_dest_axi
ad_connect  $sys_cpu_resetn axi_ltc2387_dma/m_dest_axi_aresetn
ad_connect  $sys_cpu_reset axi_ltc_cpack/reset

# interrupts

ad_cpu_interrupt ps-13 mb-13 axi_ltc2387_dma/irq
ad_cpu_interrupt ps-12 mb-12 axi_quad_spi_0/ip2intc_irpt
ad_cpu_interrupt ps-11 mb-11 axi_quad_spi_1/ip2intc_irpt

#pana aici


#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
set sys_cstring "sys rom custom string placeholder"
sysid_gen_sys_init_file $sys_cstring
