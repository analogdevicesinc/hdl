###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIJESD204
##
## The ADI JESD204 Core is released under the following license, which is
## different than all other HDL cores in this repository.
##
## Please read this, and understand the freedoms and responsibilities you have by
## using this source code/core.
##
## The JESD204 HDL, is copyright (C) 2016-2026 Analog Devices Inc.
##
## This core is free software, you can use run, copy, study, change, ask questions
## about and improve this core. Distribution of source, or resulting binaries
## (including those inside an FPGA or ASIC) require you to release the source of
## the entire project (excluding the system libraries provide by the
## tools/compiler/FPGA vendor). These are the terms of the GNU General Public
## License version 2 as published by the Free Software Foundation.
##
## This core  is distributed in the hope that it will be useful, but WITHOUT ANY
## WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
## PARTICULAR PURPOSE. See the GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License version 2
## along with this source code, and binary. If not, see
## <http://www.gnu.org/licenses/>.
##
## Commercial licenses (with commercial support) of this JESD204 core are also
## available under terms different than the General Public License (e.g. they do
## not require you to accompany any image (FPGA or ASIC) using the JESD204 core
## with any corresponding source code). For these alternate terms you must
## purchase a license from Analog Devices Technology Licensing Office. Users
## interested in such a license should contact jesd204-licensing@analog.com for
## more information. This commercial license is sub-licensable (if you purchase
## chips from Analog Devices, incorporate them into your PCB level product, and
## purchase a JESD204 license, end users of your product will also have a license
## to use this core in a commercial setting without releasing their source code).
##
## In addition, we kindly ask you to acknowledge ADI in any program, application
## or publication in which you use this JESD204 HDL core. (You are not required to
## do so; it is up to your common sense to decide whether you want to comply with
## this request or not.) For general publications, we suggest referencing: "The
## design and implementation of the JESD204 HDL Core used in this project is
## copyright (C) 2016-2026, Analog Devices, Inc."
###############################################################################

# Dual-clock FIFO between the PHY clock and the link clock of one JESD204C
# lane. The FIFO's own timing constraints cover its pointer synchronizers.
proc jesd204_add_cdc_fifo {name} {
  add_instance $name fifo
  foreach {param value} {
    GUI_CLOCKS_ARE_SYNCHRONIZED                   0
    GUI_Clock                                     4
    GUI_DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT 0
    GUI_Depth                                     32
    GUI_Empty                                     1
    GUI_Full                                      1
    GUI_LegacyRREQ                                1
    GUI_MAX_DEPTH                                 Auto
    GUI_RAM_BLOCK_TYPE                            Auto
    GUI_UsedW                                     1
    GUI_Width                                     66
    GUI_dc_aclr                                   1
    GUI_delaypipe                                 5
    GUI_diff_widths                               0
    GUI_output_width                              8
    GUI_read_aclr_synch                           1
    GUI_rsEmpty                                   1
    GUI_synStage                                  3
    GUI_write_aclr_synch                          1
    GUI_wsEmpty                                   0
    GUI_wsFull                                    1
  } {
    set_instance_parameter_value $name $param $value
  }
}
