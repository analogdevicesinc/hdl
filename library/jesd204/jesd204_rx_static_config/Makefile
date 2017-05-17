####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS += ../../scripts/adi_env.tcl
M_DEPS += ../../scripts/adi_ip.tcl
M_DEPS += jesd204_rx_static_config_ip.tcl
M_DEPS += rx_static_config.v

M_DEPS += ../../jesd204/interfaces/jesd204_rx_cfg.xml
M_DEPS += ../../jesd204/interfaces/jesd204_rx_cfg_rtl.xml

M_VIVADO := vivado -mode batch -source

M_FLIST := *.cache
M_FLIST += *.data
M_FLIST += *.xpr
M_FLIST += *.log
M_FLIST += component.xml
M_FLIST += *.jou
M_FLIST +=  xgui
M_FLIST += *.ip_user_files
M_FLIST += *.srcs
M_FLIST += *.hw
M_FLIST += *.sim
M_FLIST += .Xil



.PHONY: all dep clean clean-all
all: dep jesd204_rx_static_config.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


jesd204_rx_static_config.xpr: $(M_DEPS)
	-rm -rf $(M_FLIST)
	$(M_VIVADO) jesd204_rx_static_config_ip.tcl  >> jesd204_rx_static_config_ip.log 2>&1

dep:
	make -C ../../jesd204/interfaces/
####################################################################################
####################################################################################
