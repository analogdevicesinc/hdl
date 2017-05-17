####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS += ../../scripts/adi_env.tcl
M_DEPS += ../../scripts/adi_ip.tcl
M_DEPS += align_mux.v
M_DEPS += elastic_buffer.v
M_DEPS += ilas_monitor.v
M_DEPS += jesd204_rx_constr.xdc
M_DEPS += jesd204_rx_ip.tcl
M_DEPS += lane_latency_monitor.v
M_DEPS += rx.v
M_DEPS += rx_cgs.v
M_DEPS += rx_ctrl.v
M_DEPS += rx_lane.v

M_DEPS += ../../jesd204/jesd204_common/jesd204_common.xpr

M_DEPS += ../../jesd204/interfaces/jesd204_rx_cfg.xml
M_DEPS += ../../jesd204/interfaces/jesd204_rx_cfg_rtl.xml
M_DEPS += ../../jesd204/interfaces/jesd204_rx_event.xml
M_DEPS += ../../jesd204/interfaces/jesd204_rx_event_rtl.xml
M_DEPS += ../../jesd204/interfaces/jesd204_rx_ilas_config.xml
M_DEPS += ../../jesd204/interfaces/jesd204_rx_ilas_config_rtl.xml
M_DEPS += ../../jesd204/interfaces/jesd204_rx_status.xml
M_DEPS += ../../jesd204/interfaces/jesd204_rx_status_rtl.xml

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
all: dep jesd204_rx.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


jesd204_rx.xpr: $(M_DEPS)
	-rm -rf $(M_FLIST)
	$(M_VIVADO) jesd204_rx_ip.tcl  >> jesd204_rx_ip.log 2>&1

dep:
	make -C ../../jesd204/jesd204_common/
####################################################################################
####################################################################################
