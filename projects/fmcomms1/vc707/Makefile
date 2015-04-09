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
M_DEPS += ../../common/xilinx/sys_wfifo.tcl
M_DEPS += ../common/fmcomms1_bd.tcl
M_DEPS += ../../../library/axi_ad9122/axi_ad9122.xpr
M_DEPS += ../../../library/util_wfifo/util_wfifo.xpr
M_DEPS += ../../../library/axi_dmac/axi_dmac.xpr
M_DEPS += ../../../library/axi_ad9643/axi_ad9643.xpr

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
all: lib fmcomms1_vc707.xpr


.PHONY: clean
clean: clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(M_FLIST)
	make -C ../../../library/axi_ad9122 clean
	make -C ../../../library/util_wfifo clean
	make -C ../../../library/axi_dmac clean
	make -C ../../../library/axi_ad9643 clean


fmcomms1_vc707.xpr: lib $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) system_project.tcl >> fmcomms1_vc707_vivado.log 2>&1


.PHONY: lib
lib:
	make -C ../../../library/axi_ad9122
	make -C ../../../library/util_wfifo
	make -C ../../../library/axi_dmac
	make -C ../../../library/axi_ad9643

####################################################################################
####################################################################################
