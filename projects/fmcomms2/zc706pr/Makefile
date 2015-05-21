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
M_DEPS += ../zc706/system_bd.tcl
M_DEPS += ../../common/zc706/zc706_system_bd.tcl
M_DEPS += ../../common/xilinx/sys_wfifo.tcl
M_DEPS += ../common/fmcomms2_bd.tcl
M_DEPS += ../../../library/axi_ad9361/axi_ad9361.xpr
M_DEPS += ../../../library/axi_clkgen/axi_clkgen.xpr
M_DEPS += ../../../library/axi_dmac/axi_dmac.xpr
M_DEPS += ../../../library/axi_hdmi_tx/axi_hdmi_tx.xpr
M_DEPS += ../../../library/axi_spdif_tx/axi_spdif_tx.xpr
M_DEPS += ../../../library/util_adc_pack/util_adc_pack.xpr
M_DEPS += ../../../library/util_dac_unpack/util_dac_unpack.xpr
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
all: lib fmcomms2_zc706pr.sdk/system_top.hdf


clean: 
	rm -rf $(M_FLIST)


clean-all:clean
	make -C ../../../library/axi_ad9361 clean
	make -C ../../../library/axi_clkgen clean
	make -C ../../../library/axi_dmac clean
	make -C ../../../library/axi_hdmi_tx clean
	make -C ../../../library/axi_spdif_tx clean
	make -C ../../../library/util_adc_pack clean
	make -C ../../../library/util_dac_unpack clean
	make -C ../../../library/util_wfifo clean


fmcomms2_zc706pr.sdk/system_top.hdf: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) system_project.tcl >> fmcomms2_zc706pr_vivado.log 2>&1


lib:
	make -C ../../../library/axi_ad9361
	make -C ../../../library/axi_clkgen
	make -C ../../../library/axi_dmac
	make -C ../../../library/axi_hdmi_tx
	make -C ../../../library/axi_spdif_tx
	make -C ../../../library/util_adc_pack
	make -C ../../../library/util_dac_unpack
	make -C ../../../library/util_wfifo

####################################################################################
####################################################################################
