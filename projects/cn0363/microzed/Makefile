####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS += system_top.v
M_DEPS += system_project.tcl
M_DEPS += system_constr.xdc
M_DEPS += system_bd.tcl
M_DEPS += ../common/cn0363_bd.tcl
M_DEPS += ../../scripts/adi_project.tcl
M_DEPS += ../../scripts/adi_env.tcl
M_DEPS += ../../scripts/adi_board.tcl
M_DEPS += ../../common/microzed/microzed_system_ps7.tcl
M_DEPS += ../../common/microzed/microzed_system_constr.xdc
M_DEPS += ../../common/microzed/microzed_system_bd.tcl
M_DEPS += ../../../library/xilinx/common/ad_iobuf.v
M_DEPS += ../../../library/axi_dmac/axi_dmac.xpr
M_DEPS += ../../../library/axi_generic_adc/axi_generic_adc.xpr
M_DEPS += ../../../library/spi_engine/axi_spi_engine/axi_spi_engine.xpr
M_DEPS += ../../../library/cn0363/cn0363_dma_sequencer/cn0363_dma_sequencer.xpr
M_DEPS += ../../../library/cn0363/cn0363_phase_data_sync/cn0363_phase_data_sync.xpr
M_DEPS += ../../../library/cordic_demod/cordic_demod.xpr
M_DEPS += ../../../library/spi_engine/spi_engine_execution/spi_engine_execution.xpr
M_DEPS += ../../../library/spi_engine/spi_engine_interconnect/spi_engine_interconnect.xpr
M_DEPS += ../../../library/spi_engine/spi_engine_offload/spi_engine_offload.xpr
M_DEPS += ../../../library/util_axis_resize/util_axis_resize.xpr
M_DEPS += ../../../library/util_sigma_delta_spi/util_sigma_delta_spi.xpr

M_VIVADO := vivado -mode batch -source

M_FLIST := *.cache
M_FLIST += *.data
M_FLIST += *.xpr
M_FLIST += *.log
M_FLIST += *.jou
M_FLIST +=  xgui
M_FLIST += *.runs
M_FLIST += *.srcs
M_FLIST += *.sdk
M_FLIST += *.hw
M_FLIST += *.sim
M_FLIST += .Xil
M_FLIST += *.ip_user_files



.PHONY: all lib clean clean-all
all: lib cn0363_microzed.sdk/system_top.hdf


clean: 
	rm -rf $(M_FLIST)


clean-all:clean
	$(MAKE) -C ../../../library/axi_dmac clean
	$(MAKE) -C ../../../library/axi_generic_adc clean
	$(MAKE) -C ../../../library/spi_engine/axi_spi_engine clean
	$(MAKE) -C ../../../library/cn0363/cn0363_dma_sequencer clean
	$(MAKE) -C ../../../library/cn0363/cn0363_phase_data_sync clean
	$(MAKE) -C ../../../library/cordic_demod clean
	$(MAKE) -C ../../../library/spi_engine/spi_engine_execution clean
	$(MAKE) -C ../../../library/spi_engine/spi_engine_interconnect clean
	$(MAKE) -C ../../../library/spi_engine/spi_engine_offload clean
	$(MAKE) -C ../../../library/util_axis_resize clean
	$(MAKE) -C ../../../library/util_sigma_delta_spi clean


cn0363_microzed.sdk/system_top.hdf: $(M_DEPS)
	-rm -rf $(M_FLIST)
	$(M_VIVADO) system_project.tcl >> cn0363_microzed_vivado.log 2>&1


lib:
	$(MAKE) -C ../../../library/axi_dmac
	$(MAKE) -C ../../../library/axi_generic_adc
	$(MAKE) -C ../../../library/spi_engine/axi_spi_engine
	$(MAKE) -C ../../../library/cn0363/cn0363_dma_sequencer
	$(MAKE) -C ../../../library/cn0363/cn0363_phase_data_sync
	$(MAKE) -C ../../../library/cordic_demod
	$(MAKE) -C ../../../library/spi_engine/spi_engine_execution
	$(MAKE) -C ../../../library/spi_engine/spi_engine_interconnect
	$(MAKE) -C ../../../library/spi_engine/spi_engine_offload
	$(MAKE) -C ../../../library/util_axis_resize
	$(MAKE) -C ../../../library/util_sigma_delta_spi

####################################################################################
####################################################################################
