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
M_DEPS += ../../../library/common/ad_iobuf.v
M_DEPS += system_top.v
M_DEPS += system_constr.xdc
M_DEPS += ../../common/kc705/kc705_system_constr.xdc
M_DEPS += system_bd.tcl
M_DEPS += ../../common/kc705/kc705_system_bd.tcl
M_DEPS += ../common/ad9467_bd.tcl
M_DEPS += ../../common/kc705/kc705_system_mig.prj
M_DEPS += ../../../library/axi_ad9467/axi_ad9467.xpr
M_DEPS += ../../../library/axi_dmac/axi_dmac.xpr

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
all: lib ad9467_fmc_kc705.sdk/system_top.hdf


clean: 
	rm -rf $(M_FLIST)


clean-all:clean
	make -C ../../../library/axi_ad9467 clean
	make -C ../../../library/axi_dmac clean


ad9467_fmc_kc705.sdk/system_top.hdf: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) system_project.tcl >> ad9467_fmc_kc705_vivado.log 2>&1


lib:
	make -C ../../../library/axi_ad9467
	make -C ../../../library/axi_dmac

####################################################################################
####################################################################################
