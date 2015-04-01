####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
## Wed Apr  1 16:22:09 2015
####################################################################################
####################################################################################

M_DEPS := system_project.tcl
M_DEPS += ../../scripts/adi_env.tcl
M_DEPS += ../../scripts/adi_project.tcl
M_DEPS += system_bd.tcl
M_DEPS += ../../common/zed/zed_system_bd.tcl
M_DEPS += ../common/motcon1_fmc_bd.tcl
M_DEPS += ../../../library/controllerperipheralhdladi_pcore.xpr
M_DEPS += ../../../library/axi_mc_speed.xpr
M_DEPS += ../../../library/util_i2c_mixer.xpr
M_DEPS += ../../../library/util_adc_pack.xpr
M_DEPS += ../../../library/axi_mc_controller.xpr
M_DEPS += ../../../library/axi_dmac.xpr
M_DEPS += ../../../library/axi_spdif_tx.xpr
M_DEPS += ../../../library/axi_mc_current_monitor.xpr
M_DEPS += ../../../library/axi_i2s_adi.xpr
M_DEPS += ../../../library/axi_clkgen.xpr
M_DEPS += ../../../library/axi_hdmi_tx.xpr


C_VIVADO := vivado -mode batch -script


.PHONY: all
all: lib motcon1_fmc_zed.xpr


.PHONY: clean
clean:
	$(C_VIVADO) $(CLEAN_SCRIPT)


.PHONY: clean-all
clean-all: clean
	make -C ../../../library/controllerperipheralhdladi_pcore clean
	make -C ../../../library/axi_mc_speed clean
	make -C ../../../library/util_i2c_mixer clean
	make -C ../../../library/util_adc_pack clean
	make -C ../../../library/axi_mc_controller clean
	make -C ../../../library/axi_dmac clean
	make -C ../../../library/axi_spdif_tx clean
	make -C ../../../library/axi_mc_current_monitor clean
	make -C ../../../library/axi_i2s_adi clean
	make -C ../../../library/axi_clkgen clean
	make -C ../../../library/axi_hdmi_tx clean


motcon1_fmc_zed.xpr: lib $(M_DEPS)
	$(C_VIVADO) $(CLEAN_SCRIPT)
	$(C_VIVADO) system_project.tcl


.PHONY: lib
lib:
	make -C ../../../library/controllerperipheralhdladi_pcore
	make -C ../../../library/axi_mc_speed
	make -C ../../../library/util_i2c_mixer
	make -C ../../../library/util_adc_pack
	make -C ../../../library/axi_mc_controller
	make -C ../../../library/axi_dmac
	make -C ../../../library/axi_spdif_tx
	make -C ../../../library/axi_mc_current_monitor
	make -C ../../../library/axi_i2s_adi
	make -C ../../../library/axi_clkgen
	make -C ../../../library/axi_hdmi_tx

####################################################################################
####################################################################################
