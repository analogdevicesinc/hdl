####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := system_project.tcl
M_DEPS += ../../scripts/adi_env.tcl
M_DEPS += ../../scripts/adi_project.tcl
M_DEPS += ../../scripts/adi_board.tcl
M_DEPS += system_top.v
M_DEPS += system_constr.xdc
M_DEPS += ../../common/zed/zed_system_constr.xdc
M_DEPS += ../../../library/common/ad_iobuf.v
M_DEPS += system_bd.tcl
M_DEPS += ../../common/zed/zed_system_bd.tcl
M_DEPS += ../../../library/axi_clkgen/axi_clkgen.xpr
M_DEPS += ../../../library/axi_dmac/axi_dmac.xpr
M_DEPS += ../../../library/axi_generic_adc/axi_generic_adc.xpr
M_DEPS += ../../../library/axi_hdmi_tx/axi_hdmi_tx.xpr
M_DEPS += ../../../library/axi_i2s_adi/axi_i2s_adi.xpr
M_DEPS += ../../../library/axi_spdif_tx/axi_spdif_tx.xpr
M_DEPS += ../../../library/spi_engine/axi_spi_engine/axi_spi_engine.xpr
M_DEPS += ../../../library/cn0363/cn0363_dma_sequencer/cn0363_dma_sequencer.xpr
M_DEPS += ../../../library/cn0363/cn0363_phase_data_sync/cn0363_phase_data_sync.xpr
M_DEPS += ../../../library/cordic_demod/cordic_demod.xpr
M_DEPS += ../../../library/spi_engine/spi_engine_execution/spi_engine_execution.xpr
M_DEPS += ../../../library/spi_engine/spi_engine_interconnect/spi_engine_interconnect.xpr
M_DEPS += ../../../library/spi_engine/spi_engine_offload/spi_engine_offload.xpr
M_DEPS += ../../../library/util_axis_resize/util_axis_resize.xpr
M_DEPS += ../../../library/util_i2c_mixer/util_i2c_mixer.xpr
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
M_FLIST += .Xil



.PHONY: all lib clean clean-all
all: lib cn0363_zed.sdk/system_top.hdf


clean: 
	rm -rf $(M_FLIST)


clean-all:clean
	make -C ../../../library/axi_clkgen clean
	make -C ../../../library/axi_dmac clean
	make -C ../../../library/axi_generic_adc clean
	make -C ../../../library/axi_hdmi_tx clean
	make -C ../../../library/axi_i2s_adi clean
	make -C ../../../library/axi_spdif_tx clean
	make -C ../../../library/spi_engine/axi_spi_engine clean
	make -C ../../../library/cn0363/cn0363_dma_sequencer clean
	make -C ../../../library/cn0363/cn0363_phase_data_sync clean
	make -C ../../../library/cordic_demod clean
	make -C ../../../library/spi_engine/spi_engine_execution clean
	make -C ../../../library/spi_engine/spi_engine_interconnect clean
	make -C ../../../library/spi_engine/spi_engine_offload clean
	make -C ../../../library/util_axis_resize clean
	make -C ../../../library/util_i2c_mixer clean
	make -C ../../../library/util_sigma_delta_spi clean


cn0363_zed.sdk/system_top.hdf: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) system_project.tcl >> cn0363_zed_vivado.log 2>&1


lib:
	make -C ../../../library/axi_clkgen
	make -C ../../../library/axi_dmac
	make -C ../../../library/axi_generic_adc
	make -C ../../../library/axi_hdmi_tx
	make -C ../../../library/axi_i2s_adi
	make -C ../../../library/axi_spdif_tx
	make -C ../../../library/spi_engine/axi_spi_engine
	make -C ../../../library/cn0363/cn0363_dma_sequencer
	make -C ../../../library/cn0363/cn0363_phase_data_sync
	make -C ../../../library/cordic_demod
	make -C ../../../library/spi_engine/spi_engine_execution
	make -C ../../../library/spi_engine/spi_engine_interconnect
	make -C ../../../library/spi_engine/spi_engine_offload
	make -C ../../../library/util_axis_resize
	make -C ../../../library/util_i2c_mixer
	make -C ../../../library/util_sigma_delta_spi

####################################################################################
####################################################################################
