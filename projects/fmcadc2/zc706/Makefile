####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
## Fri Apr  3 11:55:07 2015
####################################################################################
####################################################################################

M_DEPS := system_project.tcl
M_DEPS += ../../scripts/adi_env.tcl
M_DEPS += ../../scripts/adi_project.tcl
M_DEPS += ../../scripts/adi_board.tcl
M_DEPS += system_bd.tcl
M_DEPS += ../../common/zc706/zc706_system_bd.tcl
M_DEPS += ../../common/zc706/zc706_system_plddr3.tcl
M_DEPS += ../common/fmcadc2_bd.tcl
M_DEPS += ../../../library/axi_jesd_gt/axi_jesd_gt.xpr
M_DEPS += ../../../library/axi_ad9625/axi_ad9625.xpr
M_DEPS += ../../../library/util_bsplit/util_bsplit.xpr
M_DEPS += ../../../library/axi_adcfifo/axi_adcfifo.xpr
M_DEPS += ../../../library/axi_dmac/axi_dmac.xpr
M_DEPS += ../../../library/axi_spdif_tx/axi_spdif_tx.xpr
M_DEPS += ../../../library/axi_clkgen/axi_clkgen.xpr
M_DEPS += ../../../library/axi_hdmi_tx/axi_hdmi_tx.xpr

C_VIVADO := vivado -mode batch -source

F_LIST := `find . -not -name '.' -not -name '*.tcl' -not -name '*.v' -not -name '*.xdc' -not -name '*.vhd' -not -name '*.prj' -not -name 'Makefile' -not -name '*.h' `


.PHONY: all
all: lib fmcadc2_zc706.xpr


.PHONY: clean
clean: clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(F_LIST)
	make -C ../../../library/axi_jesd_gt clean
	make -C ../../../library/axi_ad9625 clean
	make -C ../../../library/util_bsplit clean
	make -C ../../../library/axi_adcfifo clean
	make -C ../../../library/axi_dmac clean
	make -C ../../../library/axi_spdif_tx clean
	make -C ../../../library/axi_clkgen clean
	make -C ../../../library/axi_hdmi_tx clean


fmcadc2_zc706.xpr: lib $(M_DEPS)
	rm -rf $(F_LIST)
	$(C_VIVADO) system_project.tcl >> fmcadc2_zc706_vivado.log 2>&1


.PHONY: lib
lib:
	make -C ../../../library/axi_jesd_gt
	make -C ../../../library/axi_ad9625
	make -C ../../../library/util_bsplit
	make -C ../../../library/axi_adcfifo
	make -C ../../../library/axi_dmac
	make -C ../../../library/axi_spdif_tx
	make -C ../../../library/axi_clkgen
	make -C ../../../library/axi_hdmi_tx

####################################################################################
####################################################################################
