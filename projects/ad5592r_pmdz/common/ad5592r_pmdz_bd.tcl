create_bd_port -dir O  pwm_led_0
create_bd_port -dir O  pwm_led_1
create_bd_port -dir O  pwm_led_2
create_bd_port -dir O  pwm_led_3

ad_ip_instance axi_pwm_custom axi_pwm_led_generator

ad_connect axi_pwm_led_generator/pwm_led_0       pwm_led_0
ad_connect axi_pwm_led_generator/pwm_led_1       pwm_led_1
ad_connect axi_pwm_led_generator/pwm_led_2       pwm_led_2
ad_connect axi_pwm_led_generator/pwm_led_3       pwm_led_3




ad_cpu_interconnect 0x44a00000 axi_pwm_led_generator