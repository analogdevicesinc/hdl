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
M_DEPS += ../common/cftl_cip_bd.tcl
M_DEPS += ../../../library/axi_clkgen/axi_clkgen.xpr
M_DEPS += ../../../library/util_pmod_fmeter/util_pmod_fmeter.xpr
M_DEPS += ../../../library/axi_spdif_tx/axi_spdif_tx.xpr
M_DEPS += ../../../library/axi_i2s_adi/axi_i2s_adi.xpr
M_DEPS += ../../../library/axi_hdmi_tx/axi_hdmi_tx.xpr
M_DEPS += ../../../library/util_pmod_adc/util_pmod_adc.xpr
M_DEPS += ../../../library/axi_dmac/axi_dmac.xpr
M_DEPS += ../../../library/util_i2c_mixer/util_i2c_mixer.xpr

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
all: lib cftl_cip_zed.xpr


.PHONY: clean
clean: clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(M_FLIST)
	make -C ../../../library/axi_clkgen clean
	make -C ../../../library/util_pmod_fmeter clean
	make -C ../../../library/axi_spdif_tx clean
	make -C ../../../library/axi_i2s_adi clean
	make -C ../../../library/axi_hdmi_tx clean
	make -C ../../../library/util_pmod_adc clean
	make -C ../../../library/axi_dmac clean
	make -C ../../../library/util_i2c_mixer clean


cftl_cip_zed.xpr: lib $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) system_project.tcl >> cftl_cip_zed_vivado.log 2>&1


.PHONY: lib
lib:
	make -C ../../../library/axi_clkgen
	make -C ../../../library/util_pmod_fmeter
	make -C ../../../library/axi_spdif_tx
	make -C ../../../library/axi_i2s_adi
	make -C ../../../library/axi_hdmi_tx
	make -C ../../../library/util_pmod_adc
	make -C ../../../library/axi_dmac
	make -C ../../../library/util_i2c_mixer

####################################################################################
####################################################################################
