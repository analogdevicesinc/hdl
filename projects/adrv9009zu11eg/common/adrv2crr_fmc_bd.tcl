###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_bd_port -dir I axi_fan_tacho_i
create_bd_port -dir O axi_fan_pwm_o

# fan control

ad_ip_instance axi_fan_control axi_fan_control_0
ad_ip_parameter axi_fan_control_0 CONFIG.ID 1
ad_ip_parameter axi_fan_control_0 CONFIG.PWM_FREQUENCY_HZ 1000
ad_ip_parameter axi_fan_control_0 CONFIG.INTERNAL_SYSMONE 1

ad_ip_instance xlconstant const_gnd_0
ad_ip_parameter const_gnd_0 CONFIG.CONST_WIDTH {10}
ad_ip_parameter const_gnd_0 CONFIG.CONST_VAL {0}

ad_connect axi_fan_tacho_i axi_fan_control_0/tacho
ad_connect axi_fan_pwm_o axi_fan_control_0/pwm
ad_connect const_gnd_0/dout axi_fan_control_0/temp_in

# interconnect

ad_cpu_interconnect 0x40000000 axi_fan_control_0

# interrupts

ad_cpu_interrupt ps-14 mb-14 axi_fan_control_0/irq
