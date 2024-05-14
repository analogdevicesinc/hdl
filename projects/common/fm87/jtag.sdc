###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_time_format -unit ns -decimal_places 3

# This is the main entry point called at the end of this SDC file.
proc set_jtag_timing_constraints { } {
    # If the timing characteristic outside of FPGA is well understood, and
    # there is a need to provide more slack to allow flexible placement of
    # JTAG logic in the FPGA core, use the timing constraints for both
    # timing analysis and fitter; otherwise, use the default fitter timing
    # constraints.

    # ---customize here---
    set use_fitter_specific_constraint 1

    if { $use_fitter_specific_constraint && [string equal quartus_fit $::TimingAnalyzerInfo(nameofexecutable)] } {
        # Define a different set of timing spec to influence place-and-route
        # result in the jtag clock domain. The slacks outside of FPGA are
        # maximized.

        set_default_quartus_fit_timing_directive
    }  else {
        # Define a set of timing constraints that describe the JTAG paths
        # for the Timing Analyzer to analyze. The Timing Analyzer timing reports show whether
        # the JTAG logic in the FPGA core will operates in this setup.

        set_jtag_timing_spec_for_timing_analysis
    }
}

proc set_default_quartus_fit_timing_directive { } {
    # A10 supports max 33.3Mhz clock
    set jtag_33Mhz_t_period 30

    create_clock -name {altera_reserved_tck} -period $jtag_33Mhz_t_period [get_ports {altera_reserved_tck}]
    set_clock_groups -asynchronous -group {altera_reserved_tck}
    # Force fitter to place register driving TDO pin to be as close to
    # the JTAG controller as possible to maximize the slack outside of FPGA.
    set_max_delay -to [get_ports { altera_reserved_tdo } ] 0
}

proc set_jtag_timing_spec_for_timing_analysis { } {
    derive_clock_uncertainty

    # There are few possible JTAG chain configurations:
    # a. This device is the only device in the JTAG chain
    # b. This device is the first one in the JTAG chain
    # c. This device is in the middle of the JTAG chain
    # d. This device is the last one in the JTAG chain

    # No matter where the device is in the chain. The tck and tms are driven
    # directly from JTAG hardware.
    set_tck_timing_spec
    set_tms_timing_spec

    # Depending on where the device is located along the chain, tdi can be
    # either driven by blaster hw (a. b.) or driven by another device in the
    # chain(c. d.)
    # ---customize here---
    set tdi_is_driven_by_blaster 1

    if { $tdi_is_driven_by_blaster } {
        set_tdi_timing_spec_when_driven_by_blaster
    } else {
        set_tdi_timing_spec_when_driven_by_device
    }

    # Depending on where the device is located along the chain, tdo can
    # drive either blaster hw (a. d.) or another device in the chain (b. c.)
    # ---customize here---
    set tdo_drive_blaster 1

    if { $tdo_drive_blaster } {
        set_tdo_timing_spec_when_drive_blaster
    } else {
        set_tdo_timing_spec_when_drive_device
    }

    set_optional_ntrst_timing_spec

    # Cut a few timing paths that are not related to JTAG logic in
    # the FPGA core, such as security mode.
    set_false_path -from [get_ports {altera_reserved_tdi}] -to [get_ports {altera_reserved_tdo}]
    if { [get_collection_size [get_registers -nowarn *~jtag_reg]] > 0 } {
        set_false_path -from [get_registers *~jtag_reg] -to [get_ports {altera_reserved_tdo}]
    }

}

proc set_tck_timing_spec { } {
    # USB Blaster 1 uses 6 MHz clock = 166.666 ns period
    set ub1_t_period 166.666
    # USB Blaster 2 uses 24 MHz clock = 41.666 ns period
    set ub2_default_t_period 41.666
    # USB Blaster 2 running at 16 MHz clock safe mode = 62.5 ns period
    set ub2_safe_t_period 62.5

    # ---customize here---
    set tck_t_period $ub2_safe_t_period

    create_clock -name {altera_reserved_tck} -period $tck_t_period  [get_ports {altera_reserved_tck}]
    set_clock_groups -asynchronous -group {altera_reserved_tck}
}

proc get_tck_delay_max { } {
    set tck_blaster_tco_max 14.603
    set tck_cable_max 11.627

    # tck delay on the PCB depends on the trace length from JTAG 10-pin
    # header to FPGA on board. In general on the PCB, the signal travels
    # at the speed of ~160 ps/inch (1000 mils = 1 inch).
    # ---customize here---
    set tck_header_trace_max 0.5

    return [expr $tck_blaster_tco_max + $tck_cable_max + $tck_header_trace_max]
}

proc get_tck_delay_min { } {
    set tck_blaster_tco_min 14.603
    set tck_cable_min 10.00

    # tck delay on the PCB depends on the trace length from JTAG 10-pin
    # header to FPGA on board. In general on the PCB, the signal travels
    # at the speed of ~160 ps/inch (1000 mils = 1 inch).
    # ---customize here---
    set tck_header_trace_min 0.1

    return [expr $tck_blaster_tco_min + $tck_cable_min + $tck_header_trace_min]
}

proc set_tms_timing_spec { } {
    set tms_blaster_tco_max 9.468
    set tms_blaster_tco_min 9.468

    set tms_cable_max 11.627
    set tms_cable_min 10.0

    # tms delay on the PCB depends on the trace length from JTAG 10-pin
    # header to FPGA on board. In general on the PCB, the signal travels
    # at the speed of ~160 ps/inch (1000 mils = 1 inch).
    # ---customize here---
    set tms_header_trace_max 0.5
    set tms_header_trace_min 0.1

    set tms_in_max [expr $tms_cable_max + $tms_header_trace_max + $tms_blaster_tco_max - [get_tck_delay_min]]
    set tms_in_min [expr $tms_cable_min + $tms_header_trace_min + $tms_blaster_tco_min - [get_tck_delay_max]]

    set_input_delay -add_delay -clock_fall -clock altera_reserved_tck -max $tms_in_max [get_ports {altera_reserved_tms}]
    set_input_delay -add_delay -clock_fall -clock altera_reserved_tck -min $tms_in_min [get_ports {altera_reserved_tms}]
}

proc set_tdi_timing_spec_when_driven_by_blaster { } {
    set tdi_blaster_tco_max 8.551
    set tdi_blaster_tco_min 8.551

    set tdi_cable_max 11.627
    set tdi_cable_min 10.0

    # tms delay on the PCB depends on the trace length from JTAG 10-pin
    # header to FPGA on board. In general on the PCB, the signal travels
    # at the speed of ~160 ps/inch (1000 mils = 1 inch).
    # ---customize here---
    set tdi_header_trace_max 0.5
    set tdi_header_trace_min 0.1

    set tdi_in_max [expr $tdi_cable_max + $tdi_header_trace_max + $tdi_blaster_tco_max - [get_tck_delay_min]]
    set tdi_in_min [expr $tdi_cable_min + $tdi_header_trace_min + $tdi_blaster_tco_min - [get_tck_delay_max]]

    #TDI launches at the falling edge of TCK per standard
    set_input_delay -add_delay -clock_fall -clock altera_reserved_tck -max $tdi_in_max [get_ports {altera_reserved_tdi}]
    set_input_delay -add_delay -clock_fall -clock altera_reserved_tck -min $tdi_in_min [get_ports {altera_reserved_tdi}]
}

proc set_tdi_timing_spec_when_driven_by_device { } {
    # TCO timing spec of tdo on the device driving this tdi input
    # ---customize here---
    set previous_device_tdo_tco_max 10.0
    set previous_device_tdo_tco_min 10.0

    # tdi delay on the PCB depends on the trace length from JTAG 10-pin
    # header to FPGA on board. In general on the PCB, the signal travels
    # at the speed of ~160 ps/inch (1000 mils = 1 inch).
    # ---customize here---
    set tdi_trace_max 0.5
    set tdi_trace_min 0.1

    set tdi_in_max [expr $previous_device_tdo_tco_max + $tdi_trace_max - [get_tck_delay_min]]
    set tdi_in_min [expr $previous_device_tdo_tco_min + $tdi_trace_min - [get_tck_delay_max]]

    #TDI launches at the falling edge of TCK per standard
    set_input_delay -add_delay -clock_fall -clock altera_reserved_tck -max $tdi_in_max [get_ports {altera_reserved_tdi}]
    set_input_delay -add_delay -clock_fall -clock altera_reserved_tck -min $tdi_in_min [get_ports {altera_reserved_tdi}]
}

proc set_tdo_timing_spec_when_drive_blaster { } {
    set tdo_blaster_tsu 5.831
    set tdo_blaster_th -1.651

    set tdo_cable_max 11.627
    set tdo_cable_min 10.0

    # tdi delay on the PCB depends on the trace length from JTAG 10-pin
    # header to FPGA on board. In general on the PCB, the signal travels
    # at the speed of ~160 ps/inch (1000 mils = 1 inch).
    # ---customize here---
    set tdo_header_trace_max 0.5
    set tdo_header_trace_min 0.1

    set tdo_out_max [expr $tdo_cable_max + $tdo_header_trace_max + $tdo_blaster_tsu + [get_tck_delay_max]]
    set tdo_out_min [expr $tdo_cable_min + $tdo_header_trace_min - $tdo_blaster_th + [get_tck_delay_min]]

    #TDO does not latch inside the USB Blaster II at the rising edge of TCK,
    # it actually is latched one half cycle later in packed mode
    # (equivalent to 1 JTAG fall-to-fall cycles)
    set_output_delay -add_delay -clock_fall -clock altera_reserved_tck -max $tdo_out_max [get_ports {altera_reserved_tdo}]
    set_output_delay -add_delay -clock_fall -clock altera_reserved_tck -min $tdo_out_min [get_ports {altera_reserved_tdo}]
}

proc set_tdo_timing_spec_when_drive_device { } {
    # TCO timing spec of tdi on the device driven by this tdo output
    # ---customize here---
    set next_device_tdi_tco_max 10.0
    set next_device_tdi_tco_min 10.0

    # tdi delay on the PCB depends on the trace length from JTAG 10-pin
    # header to FPGA on board. In general on the PCB, the signal travels
    # at the speed of ~160 ps/inch (1000 mils = 1 inch).
    # ---customize here---
    set tdo_trace_max 0.5
    set tdo_trace_min 0.1

    set tdo_out_max [expr $next_device_tdi_tco_max + $tdo_trace_max + [get_tck_delay_max]]
    set tdo_out_min [expr $next_device_tdi_tco_min + $tdo_trace_min + [get_tck_delay_min]]

    #TDO latches at the rising edge of TCK per standard
    set_output_delay -add_delay -clock altera_reserved_tck -max $tdo_out_max [get_ports {altera_reserved_tdo}]
    set_output_delay -add_delay -clock altera_reserved_tck -min $tdo_out_min [get_ports {altera_reserved_tdo}]
}

proc set_optional_ntrst_timing_spec { } {
    # ntrst is an optional JTAG pin to asynchronously reset the device JTAG controller.
    # There is no path from this pin to any FPGA core fabric.
    if { [get_collection_size [get_ports -nowarn {altera_reserved_ntrst}]] > 0 } {
        set_false_path -from [get_ports {altera_reserved_ntrst}]
    }
}

set_jtag_timing_constraints
