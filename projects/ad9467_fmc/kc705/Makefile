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
M_DEPS += ../../common/kc705/kc705_system_bd.tcl
M_DEPS += ../common/ad9467_bd.tcl
M_DEPS += ../../../library/axi_ad9467/axi_ad9467.xpr
M_DEPS += ../../../library/axi_dmac/axi_dmac.xpr

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
all: lib ad9467_fmc_kc705.xpr


.PHONY: clean
clean: clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(M_FLIST)
	make -C ../../../library/axi_ad9467 clean
	make -C ../../../library/axi_dmac clean


ad9467_fmc_kc705.xpr: lib $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) system_project.tcl >> ad9467_fmc_kc705_vivado.log 2>&1


.PHONY: lib
lib:
	make -C ../../../library/axi_ad9467
	make -C ../../../library/axi_dmac

####################################################################################
####################################################################################
