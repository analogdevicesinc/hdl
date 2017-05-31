####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS += ../../common/up_axi.v
M_DEPS += ../../common/up_clock_mon.v
M_DEPS += ../../scripts/adi_env.tcl
M_DEPS += ../../scripts/adi_ip.tcl
M_DEPS += ../../xilinx/common/up_clock_mon_constr.xdc
M_DEPS += axi_jesd204_tx.v
M_DEPS += axi_jesd204_tx_constr.xdc
M_DEPS += axi_jesd204_tx_ip.tcl
M_DEPS += jesd204_up_tx.v

M_DEPS += ../../jesd204/axi_jesd204_common/axi_jesd204_common.xpr
M_DEPS += ../../util_cdc/util_cdc.xpr

M_DEPS += ../../jesd204/interfaces/jesd204_tx_cfg.xml
M_DEPS += ../../jesd204/interfaces/jesd204_tx_cfg_rtl.xml
M_DEPS += ../../jesd204/interfaces/jesd204_tx_ctrl.xml
M_DEPS += ../../jesd204/interfaces/jesd204_tx_ctrl_rtl.xml
M_DEPS += ../../jesd204/interfaces/jesd204_tx_event.xml
M_DEPS += ../../jesd204/interfaces/jesd204_tx_event_rtl.xml
M_DEPS += ../../jesd204/interfaces/jesd204_tx_ilas_config.xml
M_DEPS += ../../jesd204/interfaces/jesd204_tx_ilas_config_rtl.xml
M_DEPS += ../../jesd204/interfaces/jesd204_tx_status.xml
M_DEPS += ../../jesd204/interfaces/jesd204_tx_status_rtl.xml

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
all: dep axi_jesd204_tx.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


axi_jesd204_tx.xpr: $(M_DEPS)
	-rm -rf $(M_FLIST)
	$(M_VIVADO) axi_jesd204_tx_ip.tcl  >> axi_jesd204_tx_ip.log 2>&1

dep:
	make -C ../../jesd204/axi_jesd204_common/
	make -C ../../util_cdc/
	make -C ../../jesd204/interfaces/
####################################################################################
####################################################################################
