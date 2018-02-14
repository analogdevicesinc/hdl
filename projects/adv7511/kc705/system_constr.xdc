
# hdmi

set_property -dict  {PACKAGE_PIN  K18   IOSTANDARD  LVCMOS25} [get_ports hdmi_out_clk]
set_property -dict  {PACKAGE_PIN  J18   IOSTANDARD  LVCMOS25} [get_ports hdmi_hsync]
set_property -dict  {PACKAGE_PIN  H20   IOSTANDARD  LVCMOS25} [get_ports hdmi_vsync]
set_property -dict  {PACKAGE_PIN  H17   IOSTANDARD  LVCMOS25} [get_ports hdmi_data_e]
set_property -dict  {PACKAGE_PIN  B23   IOSTANDARD  LVCMOS25} [get_ports hdmi_data[0]]
set_property -dict  {PACKAGE_PIN  A23   IOSTANDARD  LVCMOS25} [get_ports hdmi_data[1]]
set_property -dict  {PACKAGE_PIN  E23   IOSTANDARD  LVCMOS25} [get_ports hdmi_data[2]]
set_property -dict  {PACKAGE_PIN  D23   IOSTANDARD  LVCMOS25} [get_ports hdmi_data[3]]
set_property -dict  {PACKAGE_PIN  F25   IOSTANDARD  LVCMOS25} [get_ports hdmi_data[4]]
set_property -dict  {PACKAGE_PIN  E25   IOSTANDARD  LVCMOS25} [get_ports hdmi_data[5]]
set_property -dict  {PACKAGE_PIN  E24   IOSTANDARD  LVCMOS25} [get_ports hdmi_data[6]]
set_property -dict  {PACKAGE_PIN  D24   IOSTANDARD  LVCMOS25} [get_ports hdmi_data[7]]
set_property -dict  {PACKAGE_PIN  F26   IOSTANDARD  LVCMOS25} [get_ports hdmi_data[8]]
set_property -dict  {PACKAGE_PIN  E26   IOSTANDARD  LVCMOS25} [get_ports hdmi_data[9]]
set_property -dict  {PACKAGE_PIN  G23   IOSTANDARD  LVCMOS25} [get_ports hdmi_data[10]]
set_property -dict  {PACKAGE_PIN  G24   IOSTANDARD  LVCMOS25} [get_ports hdmi_data[11]]
set_property -dict  {PACKAGE_PIN  J19   IOSTANDARD  LVCMOS25} [get_ports hdmi_data[12]]
set_property -dict  {PACKAGE_PIN  H19   IOSTANDARD  LVCMOS25} [get_ports hdmi_data[13]]
set_property -dict  {PACKAGE_PIN  L17   IOSTANDARD  LVCMOS25} [get_ports hdmi_data[14]]
set_property -dict  {PACKAGE_PIN  L18   IOSTANDARD  LVCMOS25} [get_ports hdmi_data[15]]

# spdif

set_property -dict  {PACKAGE_PIN  J17   IOSTANDARD  LVCMOS25} [get_ports spdif]

# spi -- because the interface is not used, the leaf registers of the output lines
# should be set to IOB FALSE to prevent a CRITICAL WARNING

set_property IOB FALSE [get_cells i_system_wrapper/system_i/axi_spi/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/IO0_I_REG]
set_property IOB FALSE [get_cells i_system_wrapper/system_i/axi_spi/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/IO1_I_REG]

