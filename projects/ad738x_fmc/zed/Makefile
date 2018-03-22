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
M_DEPS += ../common/ad738x_bd.tcl
M_DEPS += ../../scripts/adi_project.tcl
M_DEPS += ../../scripts/adi_env.tcl
M_DEPS += ../../scripts/adi_board.tcl
M_DEPS += ../../common/zed/zed_system_constr.xdc
M_DEPS += ../../common/zed/zed_system_bd.tcl
M_DEPS += ../../../library/xilinx/common/ad_iobuf.v
M_DEPS += ../../../library/axi_clkgen/axi_clkgen.xpr
M_DEPS += ../../../library/axi_dmac/axi_dmac.xpr
M_DEPS += ../../../library/axi_hdmi_tx/axi_hdmi_tx.xpr
M_DEPS += ../../../library/axi_i2s_adi/axi_i2s_adi.xpr
M_DEPS += ../../../library/axi_spdif_tx/axi_spdif_tx.xpr
M_DEPS += ../../../library/spi_engine/axi_spi_engine/axi_spi_engine.xpr
M_DEPS += ../../../library/spi_engine/spi_engine_execution/spi_engine_execution.xpr
M_DEPS += ../../../library/spi_engine/spi_engine_interconnect/spi_engine_interconnect.xpr
M_DEPS += ../../../library/spi_engine/spi_engine_offload/spi_engine_offload.xpr
M_DEPS += ../../../library/util_axis_upscale/util_axis_upscale.xpr
M_DEPS += ../../../library/util_i2c_mixer/util_i2c_mixer.xpr
M_DEPS += ../../../library/util_pulse_gen/util_pulse_gen.xpr

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
all: lib ad738x_fmc_zed.sdk/system_top.hdf


clean: 
	rm -rf $(M_FLIST)


clean-all:clean
	$(MAKE) -C ../../../library/axi_clkgen clean
	$(MAKE) -C ../../../library/axi_dmac clean
	$(MAKE) -C ../../../library/axi_hdmi_tx clean
	$(MAKE) -C ../../../library/axi_i2s_adi clean
	$(MAKE) -C ../../../library/axi_spdif_tx clean
	$(MAKE) -C ../../../library/spi_engine/axi_spi_engine clean
	$(MAKE) -C ../../../library/spi_engine/spi_engine_execution clean
	$(MAKE) -C ../../../library/spi_engine/spi_engine_interconnect clean
	$(MAKE) -C ../../../library/spi_engine/spi_engine_offload clean
	$(MAKE) -C ../../../library/util_axis_upscale clean
	$(MAKE) -C ../../../library/util_i2c_mixer clean
	$(MAKE) -C ../../../library/util_pulse_gen clean


ad738x_fmc_zed.sdk/system_top.hdf: $(M_DEPS)
	-rm -rf $(M_FLIST)
	$(M_VIVADO) system_project.tcl >> ad738x_fmc_zed_vivado.log 2>&1


lib:
	$(MAKE) -C ../../../library/axi_clkgen
	$(MAKE) -C ../../../library/axi_dmac
	$(MAKE) -C ../../../library/axi_hdmi_tx
	$(MAKE) -C ../../../library/axi_i2s_adi
	$(MAKE) -C ../../../library/axi_spdif_tx
	$(MAKE) -C ../../../library/spi_engine/axi_spi_engine
	$(MAKE) -C ../../../library/spi_engine/spi_engine_execution
	$(MAKE) -C ../../../library/spi_engine/spi_engine_interconnect
	$(MAKE) -C ../../../library/spi_engine/spi_engine_offload
	$(MAKE) -C ../../../library/util_axis_upscale
	$(MAKE) -C ../../../library/util_i2c_mixer
	$(MAKE) -C ../../../library/util_pulse_gen

####################################################################################
####################################################################################
