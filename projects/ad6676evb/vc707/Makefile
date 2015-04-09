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
M_DEPS += ../common/ad6676evb_bd.tcl
M_DEPS += ../../../library/axi_jesd_gt/axi_jesd_gt.xpr
M_DEPS += ../../../library/axi_dmac/axi_dmac.xpr
M_DEPS += ../../../library/util_bsplit/util_bsplit.xpr
M_DEPS += ../../../library/axi_ad6676/axi_ad6676.xpr

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
all: lib ad6676evb_vc707.xpr


.PHONY: clean
clean: clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(M_FLIST)
	make -C ../../../library/axi_jesd_gt clean
	make -C ../../../library/axi_dmac clean
	make -C ../../../library/util_bsplit clean
	make -C ../../../library/axi_ad6676 clean


ad6676evb_vc707.xpr: lib $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) system_project.tcl >> ad6676evb_vc707_vivado.log 2>&1


.PHONY: lib
lib:
	make -C ../../../library/axi_jesd_gt
	make -C ../../../library/axi_dmac
	make -C ../../../library/util_bsplit
	make -C ../../../library/axi_ad6676

####################################################################################
####################################################################################
