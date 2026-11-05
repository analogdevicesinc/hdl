# QUAD-ADA4356/ZED HDL Project

- VADJ with which it was tested in hardware: 2.5V

## Building the project

The parameters configurable through the `make` command can be found below, as
well as in the **system_project.tcl** file; it contains the default
configuration.

```
cd projects/quad_ada4356/zed
make TDD_SUPPORT=1
```

Plain `make` gives the same design as `TDD_SUPPORT=1`, but the build folder is
named only from the parameters given on the command line, so it builds in
`zed/` itself instead of `TDDSUPPORT1/`. Pass the parameter explicitly so the
outputs (including `boot_bin/BOOT.BIN`) land where you expect them.

### Build parameters

- `TDD_SUPPORT` — capture gating (default `1`)
  - `1`: an `axi_tdd` instance at `0x44A80000` drives `trig_fmc_out` on channel 0
    and gates each DMA on channels 1–4. The DMAs are built with
    `SYNC_TRANSFER_START=1`, so a submitted transfer stalls until TDD pulses its
    sync — triggered, one buffer per trigger. The TDD's own `sync_start_enable`
    must be armed or nothing fires.
  - `0`: no `axi_tdd`. The DMAs are built with `SYNC_TRANSFER_START=0` and each
    transfer starts the moment software submits it — ungated/free-running.
    `trig_fmc_out` is tied low; `trig_fmc_in` is unused.

Note that `SYNC_TRANSFER_START` is hardwired from the build parameter
(`axi_dmac_regmap_request.v`), so gating cannot be changed at runtime. Neither
mode is cyclic — `CYCLIC` is 0 in both, so a transfer is still one buffer and an
uninterrupted stream depends on the driver refilling buffers back to back.

### Example configurations

#### TDD-gated capture (default)

This specific command builds the default configuration, in `TDDSUPPORT1/`:

```
make TDD_SUPPORT=1
```

#### Free-running capture, no TDD

```
make TDD_SUPPORT=0     # -> TDDSUPPORT0/quad_ada4356_zed.xpr
```

## Design details

### IDELAYCTRL grouping

On the Zedboard (XC7Z020), the FMC LPC pins span two IO banks:
- **Bank 34**: ADA4356 instances 0 and 1 (DUT A and B) — FMC LA00–LA10
- **Bank 35**: ADA4356 instances 2 and 3 (DUT C and D) — FMC LA17–LA27

Each bank requires its own IDELAYCTRL, so two IO delay groups are used:
- `adc_if_delay_group_0` — instances 0,1 (instance 0 creates IDELAYCTRL)
- `adc_if_delay_group_1` — instances 2,3 (instance 2 creates IDELAYCTRL)
