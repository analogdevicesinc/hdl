####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

ifeq ($(NIOS2_MMU),)
  NIOS2_MMU := 1
endif

export ALT_NIOS_MMU_ENABLED := $(NIOS2_MMU)

M_DEPS += system_top.v
M_DEPS += system_qsys.tcl
M_DEPS += system_project.tcl
M_DEPS += system_constr.sdc
M_DEPS += ../scripts/adi_tquest.tcl
M_DEPS += ../scripts/adi_project_alt.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../../library/altera/common/ad_mul.v
M_DEPS += ../../library/altera/common/up_clock_mon_constr.sdc
M_DEPS += ../../library/altera/common/up_rst_constr.sdc
M_DEPS += ../../library/altera/common/up_xfer_cntrl_constr.sdc
M_DEPS += ../../library/altera/common/up_xfer_status_constr.sdc
M_DEPS += ../../library/axi_dmac/2d_transfer.v
M_DEPS += ../../library/axi_dmac/address_generator.v
M_DEPS += ../../library/axi_dmac/axi_dmac.v
M_DEPS += ../../library/axi_dmac/axi_dmac_constr.sdc
M_DEPS += ../../library/axi_dmac/axi_dmac_hw.tcl
M_DEPS += ../../library/axi_dmac/axi_register_slice.v
M_DEPS += ../../library/axi_dmac/data_mover.v
M_DEPS += ../../library/axi_dmac/dest_axi_mm.v
M_DEPS += ../../library/axi_dmac/dest_axi_stream.v
M_DEPS += ../../library/axi_dmac/dest_fifo_inf.v
M_DEPS += ../../library/axi_dmac/inc_id.h
M_DEPS += ../../library/axi_dmac/request_arb.v
M_DEPS += ../../library/axi_dmac/request_generator.v
M_DEPS += ../../library/axi_dmac/resp.h
M_DEPS += ../../library/axi_dmac/response_generator.v
M_DEPS += ../../library/axi_dmac/response_handler.v
M_DEPS += ../../library/axi_dmac/splitter.v
M_DEPS += ../../library/axi_dmac/src_axi_mm.v
M_DEPS += ../../library/axi_dmac/src_axi_stream.v
M_DEPS += ../../library/axi_dmac/src_fifo_inf.v
M_DEPS += ../../library/axi_hdmi_tx/axi_hdmi_tx.v
M_DEPS += ../../library/axi_hdmi_tx/axi_hdmi_tx_constr.sdc
M_DEPS += ../../library/axi_hdmi_tx/axi_hdmi_tx_core.v
M_DEPS += ../../library/axi_hdmi_tx/axi_hdmi_tx_es.v
M_DEPS += ../../library/axi_hdmi_tx/axi_hdmi_tx_hw.tcl
M_DEPS += ../../library/axi_hdmi_tx/axi_hdmi_tx_vdma.v
M_DEPS += ../../library/common/ad_csc_1.v
M_DEPS += ../../library/common/ad_csc_1_add.v
M_DEPS += ../../library/common/ad_csc_1_mul.v
M_DEPS += ../../library/common/ad_csc_RGB2CrYCb.v
M_DEPS += ../../library/common/ad_mem.v
M_DEPS += ../../library/common/ad_rst.v
M_DEPS += ../../library/common/ad_ss_444to422.v
M_DEPS += ../../library/common/up_axi.v
M_DEPS += ../../library/common/up_clock_mon.v
M_DEPS += ../../library/common/up_hdmi_tx.v
M_DEPS += ../../library/common/up_xfer_cntrl.v
M_DEPS += ../../library/common/up_xfer_status.v
M_DEPS += ../../library/scripts/adi_env.tcl
M_DEPS += ../../library/scripts/adi_ip_alt.tcl
M_DEPS += ../../library/util_axis_fifo/address_gray.v
M_DEPS += ../../library/util_axis_fifo/address_gray_pipelined.v
M_DEPS += ../../library/util_axis_fifo/address_sync.v
M_DEPS += ../../library/util_axis_fifo/util_axis_fifo.v
M_DEPS += ../../library/util_axis_resize/util_axis_resize.v
M_DEPS += ../../library/util_cdc/sync_bits.v
M_DEPS += ../../library/util_cdc/sync_gray.v


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
all: de10nano.sof



clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


de10nano.sof: $(M_DEPS)
	-rm -rf $(M_FLIST)
	$(M_ALTERA) system_project.tcl  >> de10nano_quartus.log 2>&1

####################################################################################
####################################################################################
