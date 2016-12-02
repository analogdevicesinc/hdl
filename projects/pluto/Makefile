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
M_DEPS += ../scripts/adi_project.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_board.tcl
M_DEPS += ../../library/xilinx/common/ad_iobuf.v
M_DEPS += ../../library/axi_ad9361/axi_ad9361.xpr
M_DEPS += ../../library/axi_dmac/axi_dmac.xpr
M_DEPS += ../../library/util_fir_dec/util_fir_dec.xpr
M_DEPS += ../../library/util_fir_int/util_fir_int.xpr

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
all: lib pluto.sdk/system_top.hdf


clean: 
	rm -rf $(M_FLIST)


clean-all:clean
	make -C ../../library/axi_ad9361 clean
	make -C ../../library/axi_dmac clean
	make -C ../../library/util_fir_dec clean
	make -C ../../library/util_fir_int clean


pluto.sdk/system_top.hdf: $(M_DEPS)
	-rm -rf $(M_FLIST)
	$(M_VIVADO) system_project.tcl >> pluto_vivado.log 2>&1


lib:
	make -C ../../library/axi_ad9361
	make -C ../../library/axi_dmac
	make -C ../../library/util_fir_dec
	make -C ../../library/util_fir_int

####################################################################################
####################################################################################
