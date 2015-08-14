####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := system_project.tcl
M_DEPS += ../../scripts/adi_env.tcl
M_DEPS += ../../common/a5soc/a5soc_system_assign.tcl
M_DEPS += ../../../projects/scripts/adi_tquest.tcl
M_DEPS += ../../../library/common/altera/ad_jesd_align.v
M_DEPS += ../../../library/common/altera/ad_xcvr_rx_rst.v
M_DEPS += ../common/fmcjesdadc1_spi.v
M_DEPS += system_constr.sdc
M_DEPS += system_top.v
M_DEPS += system_bd.qsys


M_ALTERA := quartus_sh --64bit -t 


M_FLIST += *.log
M_FLIST += *_INFO.txt
M_FLIST += *_dump.txt
M_FLIST += db
M_FLIST += *.asm.rpt
M_FLIST += *.done
M_FLIST += *.eda.rpt
M_FLIST += *.fit.*
M_FLIST += *.map.*
M_FLIST += *.sta.*
M_FLIST += *.qsf
M_FLIST += *.qpf
M_FLIST += *.qws
M_FLIST += *.sof
M_FLIST += hc_output
M_FLIST += hps_isw_handoff
M_FLIST += hps_sdram_*.csv
M_FLIST += *ddr3_*.csv
M_FLIST += incremental_db
M_FLIST += reconfig_mif
M_FLIST += *.sopcinfo
M_FLIST +=  *.jdi
M_FLIST += *.pin



.PHONY: all clean clean-all
all: fmcjesdadc1_a5soc.sof



clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


fmcjesdadc1_a5soc.sof: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_ALTERA) system_project.tcl  >> fmcjesdadc1_a5soc_quartus.log 2>&1

####################################################################################
####################################################################################
