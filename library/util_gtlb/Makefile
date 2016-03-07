####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := util_gtlb_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += ../common/up_xfer_status.v
M_DEPS += util_gtlb_constr.xdc
M_DEPS += util_gtlb.v
M_DEPS += ../interfaces/if_gt_qpll.xml
M_DEPS += ../interfaces/if_gt_qpll_rtl.xml
M_DEPS += ../interfaces/if_gt_pll.xml
M_DEPS += ../interfaces/if_gt_pll_rtl.xml
M_DEPS += ../interfaces/if_gt_rx.xml
M_DEPS += ../interfaces/if_gt_rx_rtl.xml
M_DEPS += ../interfaces/if_gt_tx.xml
M_DEPS += ../interfaces/if_gt_tx_rtl.xml

M_VIVADO := vivado -mode batch -source

M_FLIST := *.cache
M_FLIST += *.data
M_FLIST += *.xpr
M_FLIST += *.log
M_FLIST += component.xml
M_FLIST += *.jou
M_FLIST +=  xgui
M_FLIST += .Xil



.PHONY: all dep clean clean-all
all: dep util_gtlb.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


util_gtlb.xpr: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) util_gtlb_ip.tcl  >> util_gtlb_ip.log 2>&1

dep:
	make -C ../interfaces
####################################################################################
####################################################################################
