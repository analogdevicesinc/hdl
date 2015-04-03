####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
## Fri Apr  3 11:55:07 2015
####################################################################################
####################################################################################

M_DEPS := axi_mc_controller_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += ../common/up_axi.v
M_DEPS += ../common/ad_rst.v
M_DEPS += ../common/up_delay_cntrl.v
M_DEPS += ../common/up_drp_cntrl.v
M_DEPS += ../common/up_xfer_cntrl.v
M_DEPS += ../common/up_xfer_status.v
M_DEPS += ../common/up_clock_mon.v
M_DEPS += ../common/up_drp_cntrl.v
M_DEPS += ../common/up_delay_cntrl.v
M_DEPS += ../common/up_adc_common.v
M_DEPS += ../common/up_adc_channel.v
M_DEPS += motor_driver.v
M_DEPS += delay.v
M_DEPS += control_registers.v
M_DEPS += axi_mc_controller.v

C_VIVADO := vivado -mode batch -source

F_LIST := `find . -not -name '.' -not -name '*.tcl' -not -name '*.v' -not -name '*.xdc' -not -name '*.vhd' -not -name '*.prj' -not -name 'Makefile' -not -name '*.h' `


.PHONY: all
all: axi_mc_controller.xpr


.PHONY: clean
clean:clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(F_LIST)


axi_mc_controller.xpr: $(M_DEPS)
	rm -rf $(F_LIST)
	$(C_VIVADO) axi_mc_controller_ip.tcl  >> axi_mc_controller_ip.log 2>&1

####################################################################################
####################################################################################
