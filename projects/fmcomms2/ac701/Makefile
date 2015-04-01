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
M_DEPS += ../../common/ac701/ac701_system_bd.tcl
M_DEPS += ../common/fmcomms2_bd.tcl
M_DEPS += ../../../library/util_dac_unpack.xpr
M_DEPS += ../../../library/util_adc_pack.xpr
M_DEPS += ../../../library/axi_dmac.xpr
M_DEPS += ../../../library/axi_ad9361.xpr


C_VIVADO := vivado -mode batch -script


.PHONY: all
all: lib fmcomms2_ac701.xpr


.PHONY: clean
clean:
	$(C_VIVADO) $(CLEAN_SCRIPT)


.PHONY: clean-all
clean-all: clean
	make -C ../../../library/util_dac_unpack clean
	make -C ../../../library/util_adc_pack clean
	make -C ../../../library/axi_dmac clean
	make -C ../../../library/axi_ad9361 clean


fmcomms2_ac701.xpr: lib $(M_DEPS)
	$(C_VIVADO) $(CLEAN_SCRIPT)
	$(C_VIVADO) system_project.tcl


.PHONY: lib
lib:
	make -C ../../../library/util_dac_unpack
	make -C ../../../library/util_adc_pack
	make -C ../../../library/axi_dmac
	make -C ../../../library/axi_ad9361

####################################################################################
####################################################################################
