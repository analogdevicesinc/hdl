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
M_DEPS += ../../common/kc705/kc705_system_bd.tcl
M_DEPS += ../../common/xilinx/sys_dmafifo.tcl
M_DEPS += ../common/daq2_bd.tcl
M_DEPS += ../../../library/axi_jesd_gt.xpr
M_DEPS += ../../../library/axi_dmac.xpr
M_DEPS += ../../../library/util_ccat.xpr
M_DEPS += ../../../library/util_bsplit.xpr
M_DEPS += ../../../library/axi_ad9144.xpr
M_DEPS += ../../../library/axi_ad9680.xpr
M_DEPS += ../../../library/axi_fifo2f.xpr


C_VIVADO := vivado -mode batch -script


.PHONY: all
all: lib daq2_kc705.xpr


.PHONY: clean
clean:
	$(C_VIVADO) $(CLEAN_SCRIPT)


.PHONY: clean-all
clean-all: clean
	make -C ../../../library/axi_jesd_gt clean
	make -C ../../../library/axi_dmac clean
	make -C ../../../library/util_ccat clean
	make -C ../../../library/util_bsplit clean
	make -C ../../../library/axi_ad9144 clean
	make -C ../../../library/axi_ad9680 clean
	make -C ../../../library/axi_fifo2f clean


daq2_kc705.xpr: lib $(M_DEPS)
	$(C_VIVADO) $(CLEAN_SCRIPT)
	$(C_VIVADO) system_project.tcl


.PHONY: lib
lib:
	make -C ../../../library/axi_jesd_gt
	make -C ../../../library/axi_dmac
	make -C ../../../library/util_ccat
	make -C ../../../library/util_bsplit
	make -C ../../../library/axi_ad9144
	make -C ../../../library/axi_ad9680
	make -C ../../../library/axi_fifo2f

####################################################################################
####################################################################################
