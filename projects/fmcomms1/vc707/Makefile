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
M_DEPS += system_top.v
M_DEPS += system_constr.xdc
M_DEPS += ../../../library/common/ad_iobuf.v
M_DEPS += ../../common/vc707/vc707_system_constr.xdc
M_DEPS += system_bd.tcl
M_DEPS += ../../common/vc707/vc707_system_bd.tcl
M_DEPS += ../../common/xilinx/sys_wfifo.tcl
M_DEPS += ../common/fmcomms1_bd.tcl
M_DEPS += ../../common/vc707/vc707_system_mig.prj
M_DEPS += ../../../library/axi_ad9122/axi_ad9122.xpr
M_DEPS += ../../../library/axi_ad9643/axi_ad9643.xpr
M_DEPS += ../../../library/axi_dmac/axi_dmac.xpr
M_DEPS += ../../../library/util_wfifo/util_wfifo.xpr

M_VIVADO := vivado -mode batch -source

M_FLIST := *.cache
M_FLIST += *.data
M_FLIST += *.xpr
M_FLIST += *.log
M_FLIST += *.jou
M_FLIST +=  xgui
M_FLIST += *.runs
M_FLIST += *.srcs
M_FLIST += *.sdk
M_FLIST += .Xil



.PHONY: all lib clean clean-all
all: lib fmcomms1_vc707.sdk/system_top.hdf


clean: 
	rm -rf $(M_FLIST)


clean-all:clean
	make -C ../../../library/axi_ad9122 clean
	make -C ../../../library/axi_ad9643 clean
	make -C ../../../library/axi_dmac clean
	make -C ../../../library/util_wfifo clean


fmcomms1_vc707.sdk/system_top.hdf: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) system_project.tcl >> fmcomms1_vc707_vivado.log 2>&1


lib:
	make -C ../../../library/axi_ad9122
	make -C ../../../library/axi_ad9643
	make -C ../../../library/axi_dmac
	make -C ../../../library/util_wfifo

####################################################################################
####################################################################################
