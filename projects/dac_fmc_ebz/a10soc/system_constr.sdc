#
# Copyright 2018 (c) Analog Devices, Inc. All rights reserved.
#
# In this HDL repository, there are many different and unique modules, consisting
# of various HDL (Verilog or VHDL) components. The individual modules are
# developed independently, and may be accompanied by separate and unique license
# terms.
#
# The user should read each of these license terms, and understand the
# freedoms and responsibilities that he or she has by using this source/core.
#
# This core is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.
#
# Redistribution and use of source or resulting binaries, with or without modification
# of this file, are permitted under one of the following two license terms:
#
#   1. The GNU General Public License version 2 as published by the
#      Free Software Foundation, which can be found in the top level directory
#      of this repository (LICENSE_GPL2), and also online at:
#      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
#
# OR
#
#   2. An ADI specific BSD license, which can be found in the top level directory
#      of this repository (LICENSE_ADIBSD), and also on-line at:
#      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
#      This will allow to generate bit files and not release the source code,
#      as long as it attaches to an ADI device.
#

create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]

# Maximum lane rate of 14.2 Gbps however the dacfifo does not meet the 355 MHz requirement, reducing it to 333MHz
create_clock -period  "3 ns" -name tx_ref_clk         [get_ports {tx_ref_clk}]

# Asynchronous GPIOs

foreach async_input {gpio_bd_i[*]} {
   set_false_path -from [get_ports $async_input]
}

foreach async_output {gpio_bd_o[*] txen_0 txen_1 spi_en_n} {
   set_false_path -to [get_ports $async_output]
}
derive_pll_clocks
derive_clock_uncertainty
