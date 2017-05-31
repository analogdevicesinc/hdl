####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS += ../common/ad_rst.v
M_DEPS += ../common/up_axi.v
M_DEPS += ../common/up_clock_mon.v
M_DEPS += ../common/up_dac_common.v
M_DEPS += ../common/up_xfer_cntrl.v
M_DEPS += ../common/up_xfer_status.v
M_DEPS += ../common/util_pulse_gen.v
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += axi_ad5766.v
M_DEPS += axi_ad5766_ip.tcl
M_DEPS += up_ad5766_sequencer.v

M_DEPS += ../util_cdc/util_cdc.xpr

M_DEPS += ../interfaces/fifo_rd.xml
M_DEPS += ../interfaces/fifo_rd_rtl.xml
M_DEPS += ../spi_engine/interfaces/spi_engine_ctrl.xml
M_DEPS += ../spi_engine/interfaces/spi_engine_ctrl_rtl.xml
M_DEPS += ../spi_engine/interfaces/spi_engine_offload_ctrl.xml
M_DEPS += ../spi_engine/interfaces/spi_engine_offload_ctrl_rtl.xml

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
all: dep axi_ad5766.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


axi_ad5766.xpr: $(M_DEPS)
	-rm -rf $(M_FLIST)
	$(M_VIVADO) axi_ad5766_ip.tcl  >> axi_ad5766_ip.log 2>&1

dep:
	make -C ../util_cdc/
####################################################################################
####################################################################################
