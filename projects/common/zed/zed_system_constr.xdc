###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# constraints
# hdmi

set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports hdmi_out_clk]
set_property -dict {PACKAGE_PIN W17 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports hdmi_vsync]
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports hdmi_hsync]
set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports hdmi_data_e]
set_property -dict {PACKAGE_PIN Y13 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[0]}]
set_property -dict {PACKAGE_PIN AA13 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[1]}]
set_property -dict {PACKAGE_PIN AA14 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[2]}]
set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[3]}]
set_property -dict {PACKAGE_PIN AB15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[4]}]
set_property -dict {PACKAGE_PIN AB16 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[5]}]
set_property -dict {PACKAGE_PIN AA16 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[6]}]
set_property -dict {PACKAGE_PIN AB17 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[7]}]
set_property -dict {PACKAGE_PIN AA17 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[8]}]
set_property -dict {PACKAGE_PIN Y15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[9]}]
set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[10]}]
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[11]}]
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[12]}]
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[13]}]
set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[14]}]
set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[15]}]

# spdif

set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports spdif]

# i2s

set_property -dict {PACKAGE_PIN AB2 IOSTANDARD LVCMOS33} [get_ports i2s_mclk]
set_property -dict {PACKAGE_PIN AA6 IOSTANDARD LVCMOS33} [get_ports i2s_bclk]
set_property -dict {PACKAGE_PIN Y6 IOSTANDARD LVCMOS33} [get_ports i2s_lrclk]
set_property -dict {PACKAGE_PIN Y8 IOSTANDARD LVCMOS33} [get_ports i2s_sdata_out]
set_property -dict {PACKAGE_PIN AA7 IOSTANDARD LVCMOS33} [get_ports i2s_sdata_in]

# iic

set_property -dict {PACKAGE_PIN R7 IOSTANDARD LVCMOS33} [get_ports iic_scl]
set_property -dict {PACKAGE_PIN U7 IOSTANDARD LVCMOS33} [get_ports iic_sda]
set_property PACKAGE_PIN AA18 [get_ports {iic_mux_scl[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {iic_mux_scl[1]}]
set_property PULLTYPE PULLUP [get_ports {iic_mux_scl[1]}]
set_property PACKAGE_PIN Y16 [get_ports {iic_mux_sda[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {iic_mux_sda[1]}]
set_property PULLTYPE PULLUP [get_ports {iic_mux_sda[1]}]
set_property PACKAGE_PIN AB4 [get_ports {iic_mux_scl[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {iic_mux_scl[0]}]
set_property PULLTYPE PULLUP [get_ports {iic_mux_scl[0]}]
set_property PACKAGE_PIN AB5 [get_ports {iic_mux_sda[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {iic_mux_sda[0]}]
set_property PULLTYPE PULLUP [get_ports {iic_mux_sda[0]}]

# otg

set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS18} [get_ports otg_vbusoc]

# gpio (switches, leds and such)




# Define SPI clock
create_clock -period 40.000 -name spi0_clk [get_pins -hier */EMIOSPI0SCLKO]
create_clock -period 40.000 -name spi1_clk [get_pins -hier */EMIOSPI1SCLKO]





# qspi interface

set_property -dict {PACKAGE_PIN T22 IOSTANDARD LVCMOS33} [get_ports sys_rst_n_100m]
set_property -dict {PACKAGE_PIN T21 IOSTANDARD LVCMOS33} [get_ports ready]

set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS18} [get_ports sclk]
# SPI mode 0 idles sclk low — pull-down keeps the pin defined if the master
# ever tristates its driver (boot, reset, hot-plug).
set_property PULLTYPE PULLDOWN [get_ports sclk]

set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS18} [get_ports cs_n]
# cs_n is active-low, so a floating input reads as "asserted" and asynchronously
# clears the slave FSM. Pull-up keeps the pin defined against noise/tristate on
# the master GPIO — most common source of the spurious cs glitches seen on ILA.
set_property PULLTYPE PULLUP [get_ports cs_n]

set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS18} [get_ports {qspi_data[0]}]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS18} [get_ports {qspi_data[1]}]
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS18} [get_ports {qspi_data[2]}]
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS18} [get_ports {qspi_data[3]}]

# Output launch FF (io_o) is pulled into OLOGIC via an (* IOB = "TRUE" *)
# attribute on the reg in qspi_slave.v — scoping IOB to the FF rather than the
# port avoids also IOB-ing the input sampler (read_length_q_reg[0]) which
# would fail placement (Constraints 18-13333). Input samplers stay in fabric —
# fine at these sclk rates.

# Output-driver tuning for the jumper-wire link to the Alif DK-E8 master.
# Weak driver (DRIVE 8) reduces overshoot/ringing into the unterminated,
# impedance-uncontrolled jumper load. FAST slew stays because the 80 MHz
# launch-to-sample budget (6.25 ns half-period) cannot afford slow edges.
# If SI is still poor after build, try DRIVE 4.
set_property DRIVE 8 [get_ports {qspi_data[*]}]
set_property SLEW FAST [get_ports {qspi_data[*]}]

# QSPI SCLK from external master. 10.0 ns = 100 MHz — pushed to the limit of
# what the topology (LVCMOS18 over FMC + jumper wires) can plausibly support.
# Timing closure requires MMCM insertion-delay compensation in system_top.v
# and aggressive output_delay tuning below. Verify byte stream at the master
# before trusting the link.
create_clock -period 10.000 -name qspi_clk [get_ports sclk]

# SCLK is asynchronous to the PS-generated 200 MHz sys clock.
# The set_clock_groups constraint lives in zed_system_impl.xdc (impl-only),
# because clk_fpga_0 is not visible during OOC synthesis of the top level.

# Mode-0 half-cycle timing: master launches on negedge sclk, slave samples on posedge.
# Input path only carries CMD/ADDR/regwrite bytes (single-lane, once per
# transaction); not throughput-critical, existing pessimism is fine.
set_input_delay -clock qspi_clk -clock_fall -max 3.000 [get_ports {qspi_data[*]}]
set_input_delay -clock qspi_clk -clock_fall -min 0.500 [get_ports {qspi_data[*]}]
set_input_delay -clock qspi_clk -clock_fall -max 3.000 [get_ports cs_n]
set_input_delay -clock qspi_clk -clock_fall -min 0.500 [get_ports cs_n]

# Slave launches on negedge sclk, master samples on posedge — half-period
# budget at 100 MHz = 5.0 ns. Aggressive numbers to fit that budget:
# -max 2.0 assumes Alif E8 tSU ~1 ns + short jumper flight ~1 ns. If the
#         master's real tSU is larger this will fail — measure and adjust.
# -min -1.0 = Alif tH ~1 ns, allowed to change up to 1 ns after the sample.
set_output_delay -clock qspi_clk -max 2.000 [get_ports {qspi_data[*]}]
set_output_delay -clock qspi_clk -min -1.000 [get_ports {qspi_data[*]}]

# cs_n is also the async reset for the sclk-domain FSM and the negedge output
# register on the data lanes. The path from the pin to those async clears is
# not timed against sclk.
set_false_path -from [get_ports cs_n] -to [get_cells -hier -filter {NAME =~ *qspi_slave_inst/*_reg* && IS_SEQUENTIAL}]

# CDC synchronizer chains — pack tight and prevent optimization.
# -quiet: constraint file also runs at synthesis where cells may not yet exist.
set_property ASYNC_REG true [get_cells -quiet -hier -filter {NAME =~ *qspi_slave_inst*ra_sync_reg*}]






