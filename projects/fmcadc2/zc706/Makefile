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
M_DEPS += ../common/fmcadc2_spi.v
M_DEPS += system_top.v
M_DEPS += system_constr.xdc
M_DEPS += ../../../library/common/ad_iobuf.v
M_DEPS += ../../common/zc706/zc706_system_mig_constr.xdc
M_DEPS += ../../common/zc706/zc706_system_constr.xdc
M_DEPS += system_bd.tcl
M_DEPS += ../../common/zc706/zc706_system_bd.tcl
M_DEPS += ../../common/zc706/zc706_system_plddr3.tcl
M_DEPS += ../common/fmcadc2_bd.tcl
M_DEPS += ../../common/zc706/zc706_system_mig.prj
M_DEPS += ../../../library/axi_ad9625/axi_ad9625.xpr
M_DEPS += ../../../library/axi_adcfifo/axi_adcfifo.xpr
M_DEPS += ../../../library/axi_clkgen/axi_clkgen.xpr
M_DEPS += ../../../library/axi_dmac/axi_dmac.xpr
M_DEPS += ../../../library/axi_hdmi_tx/axi_hdmi_tx.xpr
M_DEPS += ../../../library/axi_jesd_gt/axi_jesd_gt.xpr
M_DEPS += ../../../library/axi_spdif_tx/axi_spdif_tx.xpr
M_DEPS += ../../../library/util_bsplit/util_bsplit.xpr

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
all: lib fmcadc2_zc706.sdk/system_top.hdf


clean: 
	rm -rf $(M_FLIST)


clean-all:clean
	make -C ../../../library/axi_ad9625 clean
	make -C ../../../library/axi_adcfifo clean
	make -C ../../../library/axi_clkgen clean
	make -C ../../../library/axi_dmac clean
	make -C ../../../library/axi_hdmi_tx clean
	make -C ../../../library/axi_jesd_gt clean
	make -C ../../../library/axi_spdif_tx clean
	make -C ../../../library/util_bsplit clean


fmcadc2_zc706.sdk/system_top.hdf: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) system_project.tcl >> fmcadc2_zc706_vivado.log 2>&1


lib:
	make -C ../../../library/axi_ad9625
	make -C ../../../library/axi_adcfifo
	make -C ../../../library/axi_clkgen
	make -C ../../../library/axi_dmac
	make -C ../../../library/axi_hdmi_tx
	make -C ../../../library/axi_jesd_gt
	make -C ../../../library/axi_spdif_tx
	make -C ../../../library/util_bsplit

####################################################################################
####################################################################################
