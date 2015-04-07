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
M_DEPS += system_bd.tcl
M_DEPS += ../../common/zed/zed_system_bd.tcl
M_DEPS += ../common/motcon2_fmc_bd.tcl
M_DEPS += ../../../library/util_cpack/util_cpack.xpr
M_DEPS += ../../../library/util_adc_pack/util_adc_pack.xpr
M_DEPS += ../../../library/axi_clkgen/axi_clkgen.xpr
M_DEPS += ../../../library/axi_spdif_tx/axi_spdif_tx.xpr
M_DEPS += ../../../library/axi_mc_speed/axi_mc_speed.xpr
M_DEPS += ../../../library/axi_mc_current_monitor/axi_mc_current_monitor.xpr
M_DEPS += ../../../library/axi_hdmi_tx/axi_hdmi_tx.xpr
M_DEPS += ../../../library/util_gmii_to_rgmii/util_gmii_to_rgmii.xpr
M_DEPS += ../../../library/axi_i2s_adi/axi_i2s_adi.xpr
M_DEPS += ../../../library/util_i2c_mixer/util_i2c_mixer.xpr
M_DEPS += ../../../library/axi_dmac/axi_dmac.xpr
M_DEPS += ../../../library/axi_mc_controller/axi_mc_controller.xpr

M_VIVADO := vivado -mode batch -source

M_FLIST := `find . -not -name '.'
M_FLIST += -not -name '*.tcl'
M_FLIST += -not -name '*.v'
M_FLIST += -not -name '*.xdc'
M_FLIST += -not -name '*.vhd'
M_FLIST += -not -name '*.prj'
M_FLIST += -not -name 'Makefile'
M_FLIST += -not -name '*.h' `


.PHONY: all
all: lib motcon2_fmc_zed.xpr


.PHONY: clean
clean: clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(M_FLIST)
	make -C ../../../library/util_cpack clean
	make -C ../../../library/util_adc_pack clean
	make -C ../../../library/axi_clkgen clean
	make -C ../../../library/axi_spdif_tx clean
	make -C ../../../library/axi_mc_speed clean
	make -C ../../../library/axi_mc_current_monitor clean
	make -C ../../../library/axi_hdmi_tx clean
	make -C ../../../library/util_gmii_to_rgmii clean
	make -C ../../../library/axi_i2s_adi clean
	make -C ../../../library/util_i2c_mixer clean
	make -C ../../../library/axi_dmac clean
	make -C ../../../library/axi_mc_controller clean


motcon2_fmc_zed.xpr: lib $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) system_project.tcl >> motcon2_fmc_zed_vivado.log 2>&1


.PHONY: lib
lib:
	make -C ../../../library/util_cpack
	make -C ../../../library/util_adc_pack
	make -C ../../../library/axi_clkgen
	make -C ../../../library/axi_spdif_tx
	make -C ../../../library/axi_mc_speed
	make -C ../../../library/axi_mc_current_monitor
	make -C ../../../library/axi_hdmi_tx
	make -C ../../../library/util_gmii_to_rgmii
	make -C ../../../library/axi_i2s_adi
	make -C ../../../library/util_i2c_mixer
	make -C ../../../library/axi_dmac
	make -C ../../../library/axi_mc_controller

####################################################################################
####################################################################################
