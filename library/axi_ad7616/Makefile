####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS += ../common/ad_edge_detect.v
M_DEPS += ../common/up_axi.v
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += axi_ad7616.v
M_DEPS += axi_ad7616_control.v
M_DEPS += axi_ad7616_ip.tcl
M_DEPS += axi_ad7616_maxis2wrfifo.v
M_DEPS += axi_ad7616_pif.v

M_DEPS += ../spi_engine/axi_spi_engine/axi_spi_engine.xpr
M_DEPS += ../spi_engine/spi_engine_execution/spi_engine_execution.xpr
M_DEPS += ../spi_engine/spi_engine_interconnect/spi_engine_interconnect.xpr
M_DEPS += ../spi_engine/spi_engine_offload/spi_engine_offload.xpr

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
all: dep axi_ad7616.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


axi_ad7616.xpr: $(M_DEPS)
	-rm -rf $(M_FLIST)
	$(M_VIVADO) axi_ad7616_ip.tcl  >> axi_ad7616_ip.log 2>&1

dep:
	make -C ../spi_engine/axi_spi_engine/
	make -C ../spi_engine/spi_engine_execution/
	make -C ../spi_engine/spi_engine_interconnect/
	make -C ../spi_engine/spi_engine_offload/
####################################################################################
####################################################################################
