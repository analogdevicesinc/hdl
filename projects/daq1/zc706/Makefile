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
M_DEPS += ../common/daq1_spi.v
M_DEPS += ../common/daq1_bd.tcl
M_DEPS += ../../scripts/adi_project.tcl
M_DEPS += ../../scripts/adi_env.tcl
M_DEPS += ../../scripts/adi_board.tcl
M_DEPS += ../../common/zc706/zc706_system_constr.xdc
M_DEPS += ../../common/zc706/zc706_system_bd.tcl
M_DEPS += ../../common/zc706/zc706_plddr3_constr.xdc
M_DEPS += ../../common/zc706/zc706_plddr3_adcfifo_bd.tcl
M_DEPS += ../../../library/xilinx/common/ad_iobuf.v
M_DEPS += ../../../library/axi_ad9122/axi_ad9122.xpr
M_DEPS += ../../../library/axi_ad9684/axi_ad9684.xpr
M_DEPS += ../../../library/xilinx/axi_adcfifo/axi_adcfifo.xpr
M_DEPS += ../../../library/axi_clkgen/axi_clkgen.xpr
M_DEPS += ../../../library/axi_dmac/axi_dmac.xpr
M_DEPS += ../../../library/axi_hdmi_tx/axi_hdmi_tx.xpr
M_DEPS += ../../../library/axi_spdif_tx/axi_spdif_tx.xpr
M_DEPS += ../../../library/util_cpack/util_cpack.xpr
M_DEPS += ../../../library/util_upack/util_upack.xpr

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
all: lib daq1_zc706.sdk/system_top.hdf


clean: 
	rm -rf $(M_FLIST)


clean-all:clean
	$(MAKE) -C ../../../library/axi_ad9122 clean
	$(MAKE) -C ../../../library/axi_ad9684 clean
	$(MAKE) -C ../../../library/xilinx/axi_adcfifo clean
	$(MAKE) -C ../../../library/axi_clkgen clean
	$(MAKE) -C ../../../library/axi_dmac clean
	$(MAKE) -C ../../../library/axi_hdmi_tx clean
	$(MAKE) -C ../../../library/axi_spdif_tx clean
	$(MAKE) -C ../../../library/util_cpack clean
	$(MAKE) -C ../../../library/util_upack clean


daq1_zc706.sdk/system_top.hdf: $(M_DEPS)
	-rm -rf $(M_FLIST)
	$(M_VIVADO) system_project.tcl >> daq1_zc706_vivado.log 2>&1


lib:
	$(MAKE) -C ../../../library/axi_ad9122
	$(MAKE) -C ../../../library/axi_ad9684
	$(MAKE) -C ../../../library/xilinx/axi_adcfifo
	$(MAKE) -C ../../../library/axi_clkgen
	$(MAKE) -C ../../../library/axi_dmac
	$(MAKE) -C ../../../library/axi_hdmi_tx
	$(MAKE) -C ../../../library/axi_spdif_tx
	$(MAKE) -C ../../../library/util_cpack
	$(MAKE) -C ../../../library/util_upack

####################################################################################
####################################################################################
