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
M_DEPS += ../../common/vc707/vc707_system_bd.tcl
M_DEPS += ../../common/xilinx/sys_wfifo.tcl
M_DEPS += ../common/fmcomms2_bd.tcl
M_DEPS += ../../../library/util_dac_unpack/util_dac_unpack.xpr
M_DEPS += ../../../library/util_adc_pack/util_adc_pack.xpr
M_DEPS += ../../../library/util_wfifo/util_wfifo.xpr
M_DEPS += ../../../library/axi_dmac/axi_dmac.xpr
M_DEPS += ../../../library/axi_ad9361/axi_ad9361.xpr

C_VIVADO := vivado -mode batch -source

F_LIST := `find . -not -name '.' -not -name '*.tcl' -not -name '*.v' -not -name '*.xdc' -not -name '*.vhd' -not -name '*.prj' -not -name 'Makefile' -not -name '*.h' `


.PHONY: all
all: lib fmcomms2_vc707.xpr


.PHONY: clean
clean: clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(F_LIST)
	make -C ../../../library/util_dac_unpack clean
	make -C ../../../library/util_adc_pack clean
	make -C ../../../library/util_wfifo clean
	make -C ../../../library/axi_dmac clean
	make -C ../../../library/axi_ad9361 clean


fmcomms2_vc707.xpr: lib $(M_DEPS)
	rm -rf $(F_LIST)
	$(C_VIVADO) system_project.tcl >> fmcomms2_vc707_vivado.log 2>&1


.PHONY: lib
lib:
	make -C ../../../library/util_dac_unpack
	make -C ../../../library/util_adc_pack
	make -C ../../../library/util_wfifo
	make -C ../../../library/axi_dmac
	make -C ../../../library/axi_ad9361

####################################################################################
####################################################################################
