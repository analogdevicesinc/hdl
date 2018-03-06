####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS += system_top.v
M_DEPS += system_project.tcl
M_DEPS += system_constr.xdc
M_DEPS += system_bd.tcl
M_DEPS += ../common/fmcadc2_spi.v
M_DEPS += ../common/fmcadc2_bd.tcl
M_DEPS += ../../scripts/adi_project.tcl
M_DEPS += ../../scripts/adi_env.tcl
M_DEPS += ../../scripts/adi_board.tcl
M_DEPS += ../../common/xilinx/adcfifo_bd.tcl
M_DEPS += ../../common/vc707/vc707_system_mig.prj
M_DEPS += ../../common/vc707/vc707_system_constr.xdc
M_DEPS += ../../common/vc707/vc707_system_bd.tcl
M_DEPS += ../../../library/xilinx/common/ad_iobuf.v
M_DEPS += ../../../library/jesd204/scripts/jesd204.tcl
M_DEPS += ../../../library/common/ad_sysref_gen.v
M_DEPS += ../../../library/axi_ad9625/axi_ad9625.xpr
M_DEPS += ../../../library/xilinx/axi_adxcvr/axi_adxcvr.xpr
M_DEPS += ../../../library/axi_dmac/axi_dmac.xpr
M_DEPS += ../../../library/jesd204/axi_jesd204_rx/axi_jesd204_rx.xpr
M_DEPS += ../../../library/jesd204/jesd204_rx/jesd204_rx.xpr
M_DEPS += ../../../library/util_adcfifo/util_adcfifo.xpr
M_DEPS += ../../../library/xilinx/util_adxcvr/util_adxcvr.xpr

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
M_FLIST += *.hw
M_FLIST += *.sim
M_FLIST += .Xil
M_FLIST += *.ip_user_files



.PHONY: all lib clean clean-all
all: lib fmcadc2_vc707.sdk/system_top.hdf


clean: 
	rm -rf $(M_FLIST)


clean-all:clean
	$(MAKE) -C ../../../library/axi_ad9625 clean
	$(MAKE) -C ../../../library/xilinx/axi_adxcvr clean
	$(MAKE) -C ../../../library/axi_dmac clean
	$(MAKE) -C ../../../library/jesd204/axi_jesd204_rx clean
	$(MAKE) -C ../../../library/jesd204/jesd204_rx clean
	$(MAKE) -C ../../../library/util_adcfifo clean
	$(MAKE) -C ../../../library/xilinx/util_adxcvr clean


fmcadc2_vc707.sdk/system_top.hdf: $(M_DEPS)
	-rm -rf $(M_FLIST)
	$(M_VIVADO) system_project.tcl >> fmcadc2_vc707_vivado.log 2>&1


lib:
	$(MAKE) -C ../../../library/axi_ad9625
	$(MAKE) -C ../../../library/xilinx/axi_adxcvr
	$(MAKE) -C ../../../library/axi_dmac
	$(MAKE) -C ../../../library/jesd204/axi_jesd204_rx
	$(MAKE) -C ../../../library/jesd204/jesd204_rx
	$(MAKE) -C ../../../library/util_adcfifo
	$(MAKE) -C ../../../library/xilinx/util_adxcvr

####################################################################################
####################################################################################
