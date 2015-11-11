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
M_DEPS += ../common/ccfmc_bd.tcl
M_DEPS += ../../scripts/adi_project.tcl
M_DEPS += ../../scripts/adi_env.tcl
M_DEPS += ../../scripts/adi_board.tcl
M_DEPS += ../../fmcomms2/common/fmcomms2_bd.tcl
M_DEPS += ../../common/xilinx/sys_wfifo.tcl
M_DEPS += ../../common/pzsdr/pzsdr_system_ps7.tcl
M_DEPS += ../../common/pzsdr/pzsdr_system_constr.xdc
M_DEPS += ../../common/pzsdr/pzsdr_system_bd.tcl
M_DEPS += ../../../library/common/ad_iobuf.v
M_DEPS += ../../../library/axi_ad9361/axi_ad9361.xpr
M_DEPS += ../../../library/axi_clkgen/axi_clkgen.xpr
M_DEPS += ../../../library/axi_dmac/axi_dmac.xpr
M_DEPS += ../../../library/axi_gpreg/axi_gpreg.xpr
M_DEPS += ../../../library/axi_hdmi_tx/axi_hdmi_tx.xpr
M_DEPS += ../../../library/axi_i2s_adi/axi_i2s_adi.xpr
M_DEPS += ../../../library/axi_jesd_gt/axi_jesd_gt.xpr
M_DEPS += ../../../library/axi_spdif_tx/axi_spdif_tx.xpr
M_DEPS += ../../../library/util_cpack/util_cpack.xpr
M_DEPS += ../../../library/util_gtlb/util_gtlb.xpr
M_DEPS += ../../../library/util_tdd_sync/util_tdd_sync.xpr
M_DEPS += ../../../library/util_upack/util_upack.xpr
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
all: lib ccfmc_pzsdr.sdk/system_top.hdf


clean: 
	rm -rf $(M_FLIST)


clean-all:clean
	make -C ../../../library/axi_ad9361 clean
	make -C ../../../library/axi_clkgen clean
	make -C ../../../library/axi_dmac clean
	make -C ../../../library/axi_gpreg clean
	make -C ../../../library/axi_hdmi_tx clean
	make -C ../../../library/axi_i2s_adi clean
	make -C ../../../library/axi_jesd_gt clean
	make -C ../../../library/axi_spdif_tx clean
	make -C ../../../library/util_cpack clean
	make -C ../../../library/util_gtlb clean
	make -C ../../../library/util_tdd_sync clean
	make -C ../../../library/util_upack clean
	make -C ../../../library/util_wfifo clean


ccfmc_pzsdr.sdk/system_top.hdf: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) system_project.tcl >> ccfmc_pzsdr_vivado.log 2>&1


lib:
	make -C ../../../library/axi_ad9361
	make -C ../../../library/axi_clkgen
	make -C ../../../library/axi_dmac
	make -C ../../../library/axi_gpreg
	make -C ../../../library/axi_hdmi_tx
	make -C ../../../library/axi_i2s_adi
	make -C ../../../library/axi_jesd_gt
	make -C ../../../library/axi_spdif_tx
	make -C ../../../library/util_cpack
	make -C ../../../library/util_gtlb
	make -C ../../../library/util_tdd_sync
	make -C ../../../library/util_upack
	make -C ../../../library/util_wfifo

####################################################################################
####################################################################################
