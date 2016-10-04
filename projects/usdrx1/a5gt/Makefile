####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

ifeq ($(MMU),)
  MMU := 1
endif

export ALT_NIOS_MMU_ENABLED := $(MMU)

M_DEPS += system_project.tcl
M_DEPS += ../common/usdrx1_spi.v
M_DEPS += ../../scripts/adi_env.tcl
M_DEPS += ../../common/a5gt/a5gt_system_bd.qsys
M_DEPS += ../../common/a5gt/a5gt_system_assign.tcl
M_DEPS += ../../../library/common/altera/ad_xcvr_rx_rst.v
M_DEPS += ../../../library/common/altera/ad_jesd_align.v
M_DEPS += ../../../library/altera_avalon_pio/altera_avalon_pio_hw.tcl
M_DEPS += ../../../library/altera_avalon_spi/altera_avalon_spi_hw.tcl
M_DEPS += ../../../library/altera_clock_bridge/altera_clock_bridge_hw.tcl
M_DEPS += ../../../library/altera_eth_tse/altera_eth_tse_hw.tcl
M_DEPS += ../../../library/altera_irq_bridge/altera_irq_bridge_hw.tcl
M_DEPS += ../../../library/altera_nios2_gen2/altera_nios2_gen2_hw.tcl
M_DEPS += ../../../library/altera_pll/altera_pll_hw.tcl
M_DEPS += ../../../library/altera_reset_bridge/altera_reset_bridge_hw.tcl


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
M_FLIST += *.cdf
M_FLIST += *.sld
M_FLIST += *.qdf
M_FLIST += hc_output
M_FLIST += system_bd
M_FLIST += hps_isw_handoff
M_FLIST += hps_sdram_*.csv
M_FLIST += *ddr3_*.csv
M_FLIST += incremental_db
M_FLIST += reconfig_mif
M_FLIST += *.sopcinfo
M_FLIST +=  *.jdi
M_FLIST += *.pin
M_FLIST += *_summary.csv
M_FLIST += *.dpf



.PHONY: all clean clean-all
all: usdrx1_a5gt.sof



clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


usdrx1_a5gt.sof: $(M_DEPS)
	-rm -rf $(M_FLIST)
	$(M_ALTERA) system_project.tcl  >> usdrx1_a5gt_quartus.log 2>&1

####################################################################################
####################################################################################
