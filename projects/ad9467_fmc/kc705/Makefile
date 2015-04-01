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
M_DEPS += ../../common/kc705/kc705_system_bd.tcl
M_DEPS += ../common/ad9467_bd.tcl
M_DEPS += ../../../library/axi_dmac.xpr
M_DEPS += ../../../library/axi_ad9467.xpr


C_VIVADO := vivado -mode batch -script


.PHONY: all
all: lib ad9467_fmc_kc705.xpr


.PHONY: clean
clean:
	$(C_VIVADO) $(CLEAN_SCRIPT)


.PHONY: clean-all
clean-all: clean
	make -C ../../../library/axi_dmac clean
	make -C ../../../library/axi_ad9467 clean


ad9467_fmc_kc705.xpr: lib $(M_DEPS)
	$(C_VIVADO) $(CLEAN_SCRIPT)
	$(C_VIVADO) system_project.tcl


.PHONY: lib
lib:
	make -C ../../../library/axi_dmac
	make -C ../../../library/axi_ad9467

####################################################################################
####################################################################################
