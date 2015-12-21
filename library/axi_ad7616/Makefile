####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := axi_ad7616_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += axi_ad7616.v
M_DEPS += ../spi_engine_execution/spi_engine_execution.xpr
M_DEPS += ../axi_spi_engine/axi_spi_engine.xpr
M_DEPS += ../spi_engine_offload/spi_engine_offload.xpr
M_DEPS += ../spi_engine_interconnect/spi_engine_interconnect.xpr

M_VIVADO := vivado -mode batch -source

M_FLIST := *.cache
M_FLIST += *.data
M_FLIST += *.xpr
M_FLIST += *.log
M_FLIST += component.xml
M_FLIST += *.jou
M_FLIST +=  xgui
M_FLIST += .Xil
M_FLIST += *.hw
M_FLIST += *.sim



.PHONY: all dep clean clean-all
all: dep axi_ad7616.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


axi_ad7616.xpr: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) axi_ad7616_ip.tcl  >> axi_ad7616_ip.log 2>&1

dep:
	make -C ../spi_engine_execution
	make -C ../axi_spi_engine
	make -C ../spi_engine_offload
	make -C ../spi_engine_interconnect
####################################################################################
####################################################################################
