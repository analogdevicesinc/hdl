####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := axi_spi_engine_ip.tcl
M_DEPS += ../../scripts/adi_env.tcl
M_DEPS += ../../scripts/adi_ip.tcl
M_DEPS += axi_spi_engine.v
M_DEPS += ../../common/sync_bits.v
M_DEPS += ../../common/sync_gray.v
M_DEPS += ../../common/up_axi.v
M_DEPS += ../../common/ad_rst.v
M_DEPS += ../../util_axis_fifo/util_axis_fifo.xpr

M_VIVADO := vivado -mode batch -source

M_FLIST := *.cache
M_FLIST += *.data
M_FLIST += *.xpr
M_FLIST += *.log
M_FLIST += component.xml
M_FLIST += *.jou
M_FLIST +=  xgui
M_FLIST += .Xil



.PHONY: all dep clean clean-all
all: dep axi_spi_engine.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


axi_spi_engine.xpr: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) axi_spi_engine_ip.tcl  >> axi_spi_engine_ip.log 2>&1

dep:
	make -C ../../util_axis_fifo
####################################################################################
####################################################################################
