create_bd_port -dir O ldacb_tgp
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 xadc_vaux1
# pwm gen

ad_ip_instance  axi_pwm_gen             axi_ad5706r_pwm_gen
ad_ip_parameter axi_ad5706r_pwm_gen     CONFIG.ASYNC_CLK_EN 1
ad_ip_parameter axi_ad5706r_pwm_gen     CONFIG.PULSE_0_WIDTH 5
ad_ip_parameter axi_ad5706r_pwm_gen     CONFIG.PULSE_0_PERIOD 10

ad_connect axi_ad5706r_pwm_gen/pwm_0    ldacb_tgp
ad_connect axi_ad5706r_pwm_gen/ext_clk  $sys_cpu_clk   

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
ad_cpu_interconnect 0x44a50000          xadc_in



