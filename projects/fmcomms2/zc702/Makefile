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
M_DEPS += ../../common/zc702/zc702_system_bd.tcl
M_DEPS += ../../common/xilinx/sys_wfifo.tcl
M_DEPS += ../common/fmcomms2_bd.tcl
M_DEPS += ../../../library/axi_spdif_tx/axi_spdif_tx.xpr
M_DEPS += ../../../library/util_adc_pack/util_adc_pack.xpr
M_DEPS += ../../../library/axi_clkgen/axi_clkgen.xpr
M_DEPS += ../../../library/util_dac_unpack/util_dac_unpack.xpr
M_DEPS += ../../../library/axi_dmac/axi_dmac.xpr
M_DEPS += ../../../library/util_wfifo/util_wfifo.xpr
M_DEPS += ../../../library/axi_ad9361/axi_ad9361.xpr
M_DEPS += ../../../library/axi_hdmi_tx/axi_hdmi_tx.xpr

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
all: lib fmcomms2_zc702.xpr


.PHONY: clean
clean: clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(M_FLIST)
	make -C ../../../library/axi_spdif_tx clean
	make -C ../../../library/util_adc_pack clean
	make -C ../../../library/axi_clkgen clean
	make -C ../../../library/util_dac_unpack clean
	make -C ../../../library/axi_dmac clean
	make -C ../../../library/util_wfifo clean
	make -C ../../../library/axi_ad9361 clean
	make -C ../../../library/axi_hdmi_tx clean


fmcomms2_zc702.xpr: lib $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) system_project.tcl >> fmcomms2_zc702_vivado.log 2>&1


.PHONY: lib
lib:
	make -C ../../../library/axi_spdif_tx
	make -C ../../../library/util_adc_pack
	make -C ../../../library/axi_clkgen
	make -C ../../../library/util_dac_unpack
	make -C ../../../library/axi_dmac
	make -C ../../../library/util_wfifo
	make -C ../../../library/axi_ad9361
	make -C ../../../library/axi_hdmi_tx

####################################################################################
####################################################################################
