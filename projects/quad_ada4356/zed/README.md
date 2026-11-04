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

### AXI address map

| Instance              | Base address | Notes                  |
|-----------------------|--------------|------------------------|
| axi_ada4355_adc_0     | 0x44A00000   |                        |
| axi_ada4355_adc_1     | 0x44A10000   |                        |
| axi_ada4355_adc_2     | 0x44A20000   |                        |
| axi_ada4355_adc_3     | 0x44A30000   |                        |
| axi_ada4355_dma_0     | 0x44A40000   |                        |
| axi_ada4355_dma_1     | 0x44A50000   |                        |
| axi_ada4355_dma_2     | 0x44A60000   |                        |
| axi_ada4355_dma_3     | 0x44A70000   |                        |
| axi_tdd_0             | 0x44A80000   | `TDD_SUPPORT=1` only   |

### GPIO map

| GPIO bit | Signal        | Direction | Notes                                          |
|----------|---------------|-----------|------------------------------------------------|
| [31:0]   | gpio_bd       | inout     | Zedboard LEDs, switches, buttons               |
| [32]     | csb_duta      | inout     | ADA4356 A SPI chip select, active low          |
| [33]     | csb_dutb      | inout     | ADA4356 B SPI chip select, active low          |
| [34]     | csb_dutc      | inout     | ADA4356 C SPI chip select, active low          |
| [35]     | csb_dutd      | inout     | ADA4356 D SPI chip select, active low          |
| [36]     | csb_ad9510    | inout     | AD9517-4 SPI chip select (schematic net name)  |
| [37]     | apd_supp_en   | inout     | APD supply enable                              |

`trig_fmc_in` / `trig_fmc_out` are not on GPIO; they connect to the `axi_tdd`
controller. The APD bias potentiometer is on PS SPI1 (`csb_apd_pot` is its
chip select 0).

### Instance-to-FMC pin mapping

| Instance | DUT | DCO clock       | DCO pin | Clock-capable | IO Bank |
|----------|-----|-----------------|---------|---------------|---------|
| 0        | A   | FMC_LA01_CC     | N19     | SRCC          | 34      |
| 1        | B   | FMC_LA00_CC     | M19     | MRCC          | 34      |
| 2        | C   | FMC_LA17_CC     | B19     | MRCC          | 35      |
| 3        | D   | FMC_LA18_CC     | D20     | SRCC          | 35      |

Only an MRCC pin can drive a BUFMRCE, so only B and C could ever share their
DCO with another bank; each instance clocks its own capture from its own DCO.
