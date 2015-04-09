####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := system_project.tcl
M_DEPS += ../../scripts/adi_env.tcl
M_DEPS += ../../common/a5gt/a5gt_system_assign.tcl
M_DEPS += system_timing.tcl
M_DEPS += ../../../library/common/altera/ad_jesd_align.v
M_DEPS += ../../../library/common/altera/ad_xcvr_rx_rst.v
M_DEPS += ../common/usdrx1_spi.v
M_DEPS += system_constr.sdc
M_DEPS += system_top.v
M_DEPS += system_bd.qsys
M_DEPS += ../../../library/axi_dmac/axi_dmac_hw.tcl
M_DEPS += ../../../library/common/sync_bits.v
M_DEPS += ../../../library/common/sync_gray.v
M_DEPS += ../../../library/common/up_axi.v
M_DEPS += ../../../library/util_axis_resize/util_axis_resize.v
M_DEPS += ../../../library/axi_dmac/fifo.v
M_DEPS += ../../../library/axi_dmac/address_gray.v
M_DEPS += ../../../library/axi_dmac/address_gray_pipelined.v
M_DEPS += ../../../library/axi_dmac/address_sync.v
M_DEPS += ../../../library/axi_dmac/inc_id.h
M_DEPS += ../../../library/axi_dmac/resp.h
M_DEPS += ../../../library/axi_dmac/address_generator.v
M_DEPS += ../../../library/axi_dmac/data_mover.v
M_DEPS += ../../../library/axi_dmac/request_arb.v
M_DEPS += ../../../library/axi_dmac/request_generator.v
M_DEPS += ../../../library/axi_dmac/response_handler.v
M_DEPS += ../../../library/axi_dmac/axi_register_slice.v
M_DEPS += ../../../library/axi_dmac/2d_transfer.v
M_DEPS += ../../../library/axi_dmac/dest_axi_mm.v
M_DEPS += ../../../library/axi_dmac/dest_axi_stream.v
M_DEPS += ../../../library/axi_dmac/dest_fifo_inf.v
M_DEPS += ../../../library/axi_dmac/src_axi_mm.v
M_DEPS += ../../../library/axi_dmac/src_axi_stream.v
M_DEPS += ../../../library/axi_dmac/src_fifo_inf.v
M_DEPS += ../../../library/axi_dmac/splitter.v
M_DEPS += ../../../library/axi_dmac/response_generator.v
M_DEPS += ../../../library/axi_dmac/axi_dmac.v
M_DEPS += ../../../library/axi_ad9250/axi_ad9250_hw.tcl
M_DEPS += ../../../library/common/altera/ad_rst.v
M_DEPS += ../../../library/common/ad_pnmon.v
M_DEPS += ../../../library/common/ad_datafmt.v
M_DEPS += ../../../library/common/up_axi.v
M_DEPS += ../../../library/common/up_xfer_cntrl.v
M_DEPS += ../../../library/common/up_xfer_status.v
M_DEPS += ../../../library/common/up_clock_mon.v
M_DEPS += ../../../library/common/up_drp_cntrl.v
M_DEPS += ../../../library/common/up_delay_cntrl.v
M_DEPS += ../../../library/common/up_adc_common.v
M_DEPS += ../../../library/common/up_adc_channel.v
M_DEPS += ../../../library/axi_ad9250/axi_ad9250_pnmon.v
M_DEPS += ../../../library/axi_ad9250/axi_ad9250_if.v
M_DEPS += ../../../library/axi_ad9250/axi_ad9250_channel.v
M_DEPS += ../../../library/axi_ad9250/axi_ad9250.v
M_DEPS += ../../../library/axi_ad9250/axi_ad9250_alt.v


M_ALTERA := quartus_sh --64bit -t 


M_FLIST := `find . -not -name '.'
M_FLIST += -not -name '*.tcl'
M_FLIST += -not -name '*.sdc'
M_FLIST += -not -name '*.qsys'
M_FLIST += -not -name '*.v'
M_FLIST += -not -name '*.xdc'
M_FLIST += -not -name '*.vhd'
M_FLIST += -not -name '*.prj'
M_FLIST += -not -name 'Makefile'
M_FLIST += -not -name '*.h' `


.PHONY: all
all: usdrx1.qpf



.PHONY: clean
clean:clean-all


.PHONY: clean-all
clean-all:
	rm -rf $(M_FLIST)



usdrx1.qpf: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_ALTERA) system_project.tcl  >> usdrx1_quartus.log 2>&1

####################################################################################
####################################################################################
