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

M_DEPS += system_top.v
M_DEPS += system_qsys.tcl
M_DEPS += system_project.tcl
M_DEPS += system_constr.sdc
M_DEPS += ../common/fmcomms2_qsys.tcl
M_DEPS += ../../scripts/adi_env.tcl
M_DEPS += ../../common/a10gx/a10gx_system_qsys.tcl
M_DEPS += ../../common/a10gx/a10gx_system_assign.tcl
M_DEPS += ../../../library/axi_ad9361/axi_ad9361_hw.tcl
M_DEPS += ../../../library/axi_dmac/2d_transfer.v
M_DEPS += ../../../library/axi_dmac/address_generator.v
M_DEPS += ../../../library/axi_dmac/axi_dmac.v
M_DEPS += ../../../library/axi_dmac/axi_dmac_hw.tcl
M_DEPS += ../../../library/axi_dmac/axi_register_slice.v
M_DEPS += ../../../library/axi_dmac/data_mover.v
M_DEPS += ../../../library/axi_dmac/dest_axi_mm.v
M_DEPS += ../../../library/axi_dmac/dest_axi_stream.v
M_DEPS += ../../../library/axi_dmac/dest_fifo_inf.v
M_DEPS += ../../../library/axi_dmac/inc_id.h
M_DEPS += ../../../library/axi_dmac/request_arb.v
M_DEPS += ../../../library/axi_dmac/request_generator.v
M_DEPS += ../../../library/axi_dmac/resp.h
M_DEPS += ../../../library/axi_dmac/response_generator.v
M_DEPS += ../../../library/axi_dmac/response_handler.v
M_DEPS += ../../../library/axi_dmac/splitter.v
M_DEPS += ../../../library/axi_dmac/src_axi_mm.v
M_DEPS += ../../../library/axi_dmac/src_axi_stream.v
M_DEPS += ../../../library/axi_dmac/src_fifo_inf.v
M_DEPS += ../../../library/common/ad_mem.v
M_DEPS += ../../../library/common/sync_bits.v
M_DEPS += ../../../library/common/sync_gray.v
M_DEPS += ../../../library/common/up_axi.v
M_DEPS += ../../../library/util_axis_fifo/address_gray.v
M_DEPS += ../../../library/util_axis_fifo/address_gray_pipelined.v
M_DEPS += ../../../library/util_axis_fifo/address_sync.v
M_DEPS += ../../../library/util_axis_fifo/util_axis_fifo.v
M_DEPS += ../../../library/util_axis_resize/util_axis_resize.v
M_DEPS += ../../../library/util_cpack/util_cpack.v
M_DEPS += ../../../library/util_cpack/util_cpack_dsf.v
M_DEPS += ../../../library/util_cpack/util_cpack_hw.tcl
M_DEPS += ../../../library/util_cpack/util_cpack_mux.v
M_DEPS += ../../../library/util_upack/util_upack.v
M_DEPS += ../../../library/util_upack/util_upack_dmx.v
M_DEPS += ../../../library/util_upack/util_upack_dsf.v
M_DEPS += ../../../library/util_upack/util_upack_hw.tcl
M_DEPS += ../../../library/util_wfifo/util_wfifo.v
M_DEPS += ../../../library/util_wfifo/util_wfifo_hw.tcl


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
all: fmcomms2_a10gx.sof



clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


fmcomms2_a10gx.sof: $(M_DEPS)
	-rm -rf $(M_FLIST)
	$(M_ALTERA) system_project.tcl  >> fmcomms2_a10gx_quartus.log 2>&1

####################################################################################
####################################################################################
