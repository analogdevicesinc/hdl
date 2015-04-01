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
M_DEPS += ../../scripts/adi_board.tcl
M_DEPS += system_bd.tcl
M_DEPS += ../../common/vc707/vc707_system_bd.tcl
M_DEPS += ../common/ad6676evb_bd.tcl
M_DEPS += ../../../library/axi_jesd_gt.xpr
M_DEPS += ../../../library/axi_dmac.xpr
M_DEPS += ../../../library/util_bsplit.xpr
M_DEPS += ../../../library/axi_ad6676.xpr


C_VIVADO := vivado -mode batch -script


.PHONY: all
all: lib ad6676evb_vc707.xpr


.PHONY: clean
clean:
	$(C_VIVADO) $(CLEAN_SCRIPT)


.PHONY: clean-all
clean-all: clean
	make -C ../../../library/axi_jesd_gt clean
	make -C ../../../library/axi_dmac clean
	make -C ../../../library/util_bsplit clean
	make -C ../../../library/axi_ad6676 clean


ad6676evb_vc707.xpr: lib $(M_DEPS)
	$(C_VIVADO) $(CLEAN_SCRIPT)
	$(C_VIVADO) system_project.tcl


.PHONY: lib
lib:
	make -C ../../../library/axi_jesd_gt
	make -C ../../../library/axi_dmac
	make -C ../../../library/util_bsplit
	make -C ../../../library/axi_ad6676

####################################################################################
####################################################################################
