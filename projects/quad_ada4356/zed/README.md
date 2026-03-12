# Quad ADA4356/ZED HDL Project

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/quad_ada4356/zed
make
```

The overwritable parameters from the environment:

- BUFMRCE_EN - Enable BUFMRCE buffer for multi-region clock alignment.
  values:
   - 0 (default) - Standard clock buffering
   - 1 - BUFMRCE-based clock gating (needed when ADC instances span multiple clock regions)

### Example configurations

#### Default configuration

This specific command is equivalent to running `make` only:

```
cd projects/quad_ada4356/zed
make BUFMRCE_EN=0
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

| Instance              | Base address |
|-----------------------|--------------|
| axi_ada4355_adc_0     | 0x44A00000   |
| axi_ada4355_adc_1     | 0x44A10000   |
| axi_ada4355_adc_2     | 0x44A20000   |
| axi_ada4355_adc_3     | 0x44A30000   |
| axi_ada4355_dma_0     | 0x44A40000   |
| axi_ada4355_dma_1     | 0x44A50000   |
| axi_ada4355_dma_2     | 0x44A60000   |
| axi_ada4355_dma_3     | 0x44A70000   |

### GPIO map

| GPIO bit | Signal        | Direction |
|----------|---------------|-----------|
| [31:0]   | gpio_bd       | inout     |
| [32]     | trig_fmc_in   | inout     |
| [33]     | trig_fmc_out  | inout     |
| [34]     | csb_duta      | inout     |
| [35]     | csb_dutb      | inout     |
| [36]     | csb_dutc      | inout     |
| [37]     | csb_dutd      | inout     |
| [38]     | csb_ad9510    | inout     |
| [39]     | int_max7329   | input     |

### Instance-to-FMC pin mapping

| Instance | DUT | DCO clock       | IO Bank |
|----------|-----|-----------------|---------|
| 0        | A   | FMC_LA01_CC     | 34      |
| 1        | B   | FMC_LA00_CC     | 34      |
| 2        | C   | FMC_LA17_CC     | 35      |
| 3        | D   | FMC_LA18_CC     | 35      |
