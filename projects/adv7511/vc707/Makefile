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
M_DEPS += ../../common/vc707/vc707_system_bd.tcl
M_DEPS += ../../adv7511/common/adv7511_bd.tcl
M_DEPS += ../../../library/axi_clkgen/axi_clkgen.xpr
M_DEPS += ../../../library/axi_hdmi_tx/axi_hdmi_tx.xpr
M_DEPS += ../../../library/axi_spdif_tx/axi_spdif_tx.xpr

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
all: lib adv7511_vc707.xpr


.PHONY: clean
clean: clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(M_FLIST)
	make -C ../../../library/axi_clkgen clean
	make -C ../../../library/axi_hdmi_tx clean
	make -C ../../../library/axi_spdif_tx clean


adv7511_vc707.xpr: lib $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) system_project.tcl >> adv7511_vc707_vivado.log 2>&1


.PHONY: lib
lib:
	make -C ../../../library/axi_clkgen
	make -C ../../../library/axi_hdmi_tx
	make -C ../../../library/axi_spdif_tx

####################################################################################
####################################################################################
