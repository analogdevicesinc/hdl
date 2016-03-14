####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS := util_jesd_gt_ip.tcl
M_DEPS += ../scripts/adi_env.tcl
M_DEPS += ../scripts/adi_ip.tcl
M_DEPS += util_jesd_gt.v
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
all: dep util_jesd_gt.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


util_jesd_gt.xpr: $(M_DEPS)
	rm -rf $(M_FLIST)
	$(M_VIVADO) util_jesd_gt_ip.tcl  >> util_jesd_gt_ip.log 2>&1

dep:
	make -C ../interfaces
####################################################################################
####################################################################################
