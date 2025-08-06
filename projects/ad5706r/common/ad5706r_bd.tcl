create_bd_port -dir O ldacb_tgp
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 xadc_vaux1

create_bd_port -dir I axi_quad_spi_csn_i
create_bd_port -dir O axi_quad_spi_csn_o
create_bd_port -dir I axi_quad_spi_clk_i
create_bd_port -dir O axi_quad_spi_clk_o
create_bd_port -dir I axi_quad_spi_sdo_i
create_bd_port -dir O axi_quad_spi_sdo_o
create_bd_port -dir I axi_quad_spi_sdi_i

# pwm gen

ad_ip_instance  axi_pwm_gen             axi_ad5706r_pwm_gen
ad_ip_parameter axi_ad5706r_pwm_gen     CONFIG.ASYNC_CLK_EN 1
ad_ip_parameter axi_ad5706r_pwm_gen     CONFIG.PULSE_0_WIDTH 5
ad_ip_parameter axi_ad5706r_pwm_gen     CONFIG.PULSE_0_PERIOD 10

ad_connect axi_ad5706r_pwm_gen/pwm_0    ldacb_tgp
ad_connect axi_ad5706r_pwm_gen/ext_clk  $sys_cpu_clk   

# AXI Quad SPI
ad_ip_instance axi_quad_spi ad5706r_spi
ad_ip_parameter ad5706r_spi CONFIG.C_USE_STARTUP 0
ad_ip_parameter ad5706r_spi CONFIG.C_USE_STARTUP_INT 0
ad_ip_parameter ad5706r_spi CONFIG.C_SPI_MODE 0
ad_ip_parameter ad5706r_spi CONFIG.C_SCK_RATIO 2
ad_ip_parameter ad5706r_spi CONFIG.C_NUM_TRANSFER_BITS 8
ad_ip_parameter ad5706r_spi CONFIG.C_NUM_SS_BITS 1

ad_connect sys_ps7/FCLK_CLK0  ad5706r_spi/ext_spi_clk
ad_connect sys_ps7/FCLK_CLK0  ad5706r_spi/s_axi_aclk
ad_connect axi_quad_spi_csn_i ad5706r_spi/ss_i
ad_connect axi_quad_spi_csn_o ad5706r_spi/ss_o
ad_connect axi_quad_spi_clk_i ad5706r_spi/sck_i
ad_connect axi_quad_spi_clk_o ad5706r_spi/sck_o
ad_connect axi_quad_spi_sdo_i ad5706r_spi/io0_i
ad_connect axi_quad_spi_sdo_o ad5706r_spi/io0_o
ad_connect axi_quad_spi_sdi_i ad5706r_spi/io1_i

# Xilinx's XADC

ad_ip_instance xadc_wiz xadc_in

ad_ip_parameter xadc_in CONFIG.TIMING_MODE Continuous
ad_ip_parameter xadc_in CONFIG.XADC_STARUP_SELECTION channel_sequencer
ad_ip_parameter xadc_in CONFIG.SEQUENCER_MODE Continuous
ad_ip_parameter xadc_in CONFIG.ENABLE_VCCDDRO_ALARM false
ad_ip_parameter xadc_in CONFIG.ENABLE_VCCPAUX_ALARM false
ad_ip_parameter xadc_in CONFIG.ENABLE_VCCPINT_ALARM false
ad_ip_parameter xadc_in CONFIG.ENABLE_AXI4STREAM false
ad_ip_parameter xadc_in CONFIG.ENABLE_EXTERNAL_MUX false
ad_ip_parameter xadc_in CONFIG.CHANNEL_ENABLE_VP_VN false
ad_ip_parameter xadc_in CONFIG.CHANNEL_ENABLE_VAUXP1_VAUXN1 true
ad_ip_parameter xadc_in CONFIG.OT_ALARM false
ad_ip_parameter xadc_in CONFIG.SINGLE_CHANNEL_SELECTION TEMPERATURE
ad_ip_parameter xadc_in CONFIG.USER_TEMP_ALARM false
ad_ip_parameter xadc_in CONFIG.VCCAUX_ALARM false
ad_ip_parameter xadc_in CONFIG.VCCINT_ALARM false

ad_connect xadc_in/Vaux1                xadc_vaux1

# interconnects (cpu)
ad_cpu_interconnect 0x44a00000          axi_ad5706r_pwm_gen
ad_cpu_interconnect 0x44a10000          ad5706r_spi
ad_cpu_interconnect 0x44a50000          xadc_in

# interrupts
ad_cpu_interrupt ps-8 mb-8 ad5706r_spi/ip2intc_irpt
