set_property -dict {PACKAGE_PIN Y11 IOSTANDARD LVCMOS33 } [get_ports tdd_out[0] ]
set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS33 } [get_ports tdd_out[1] ]
set_property -dict {PACKAGE_PIN Y10 IOSTANDARD LVCMOS33 } [get_ports tdd_out[2] ]
set_property -dict {PACKAGE_PIN AA9 IOSTANDARD LVCMOS33 } [get_ports tdd_out[3] ]

set_property -dict {PACKAGE_PIN W12 IOSTANDARD LVCMOS33 } [get_ports tdd_clk ]
set_property -dict {PACKAGE_PIN W11 IOSTANDARD LVCMOS33 } [get_ports tdd_sync_out ]
set_property -dict {PACKAGE_PIN V10 IOSTANDARD LVCMOS33 } [get_ports tdd_sync_in ]
