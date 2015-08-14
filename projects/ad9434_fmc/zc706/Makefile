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
M_DEPS += ../../common/zc706/zc706_system_constr.xdc
M_DEPS += system_bd.tcl
M_DEPS += ../../common/zc706/zc706_system_bd.tcl
M_DEPS += ../common/ad9434_bd.tcl
M_DEPS += ../../../library/axi_ad9434/axi_ad9434.xpr
M_DEPS += ../../../library/axi_clkgen/axi_clkgen.xpr
M_DEPS += ../../../library/axi_dmac/axi_dmac.xpr
M_DEPS += ../../../library/axi_hdmi_tx/axi_hdmi_tx.xpr
M_DEPS += ../../../library/axi_spdif_tx/axi_spdif_tx.xpr

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
all: lib ad9434_fmc_zc706.sdk/system_top.hdf


clean: 
	rm -rf $(M_FLIST)


clean-all:clean
	make -C ../../../library/axi_ad9434 clean
	make -C ../../../library/axi_clkgen clean
	make -C ../../../library/axi_dmac clean
	make -C ../../../library/axi_hdmi_tx clean
	make -C ../../../library/axi_spdif_tx clean


ad9434_fmc_zc706.sdk/system_top.hdf: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) system_project.tcl >> ad9434_fmc_zc706_vivado.log 2>&1


lib:
	make -C ../../../library/axi_ad9434
	make -C ../../../library/axi_clkgen
	make -C ../../../library/axi_dmac
	make -C ../../../library/axi_hdmi_tx
	make -C ../../../library/axi_spdif_tx

####################################################################################
####################################################################################
