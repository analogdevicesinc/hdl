####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
## Wed Apr  1 16:22:09 2015
####################################################################################
####################################################################################

M_DEPS := system_project.tcl
M_DEPS += ../../scripts/adi_env.tcl
M_DEPS += ../../scripts/adi_prcfg_project.tcl
M_DEPS += system_bd.tcl
M_DEPS += ../../common/mitx045/mitx045_system_bd.tcl
M_DEPS += ../../fmcomms2/common/fmcomms2_bd.tcl
M_DEPS += ../../fmcomms2_pr/common/prcfg_setup.tcl
M_DEPS += ../../../library/util_dac_unpack.xpr
M_DEPS += ../../../library/util_adc_pack.xpr
M_DEPS += ../../../library/axi_dmac.xpr
M_DEPS += ../../../library/axi_spdif_tx.xpr
M_DEPS += ../../../library/axi_ad9361.xpr
M_DEPS += ../../../library/axi_i2s_adi.xpr
M_DEPS += ../../../library/axi_clkgen.xpr
M_DEPS += ../../../library/axi_hdmi_tx.xpr


C_VIVADO := vivado -mode batch -script


.PHONY: all
all: lib fmcomms2_pr_mitx045.xpr


.PHONY: clean
clean:
	$(C_VIVADO) $(CLEAN_SCRIPT)


.PHONY: clean-all
clean-all: clean
	make -C ../../../library/util_dac_unpack clean
	make -C ../../../library/util_adc_pack clean
	make -C ../../../library/axi_dmac clean
	make -C ../../../library/axi_spdif_tx clean
	make -C ../../../library/axi_ad9361 clean
	make -C ../../../library/axi_i2s_adi clean
	make -C ../../../library/axi_clkgen clean
	make -C ../../../library/axi_hdmi_tx clean


fmcomms2_pr_mitx045.xpr: lib $(M_DEPS)
	$(C_VIVADO) $(CLEAN_SCRIPT)
	$(C_VIVADO) system_project.tcl


.PHONY: lib
lib:
	make -C ../../../library/util_dac_unpack
	make -C ../../../library/util_adc_pack
	make -C ../../../library/axi_dmac
	make -C ../../../library/axi_spdif_tx
	make -C ../../../library/axi_ad9361
	make -C ../../../library/axi_i2s_adi
	make -C ../../../library/axi_clkgen
	make -C ../../../library/axi_hdmi_tx

####################################################################################
####################################################################################
