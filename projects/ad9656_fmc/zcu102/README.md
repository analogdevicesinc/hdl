# AD9656-FMC/ZCU102 HDL Project

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

:warning: **When changing the default configuration, the timing_constr.xdc constraints should be updated as well!**

```
cd projects/ad9656_fmc/zcu102
make
```

All of the RX link modes can be found in the [AD9656 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/AD9656.pdf). We offer support for only a few of them.

If other configurations are desired, then the parameters from the HDL project (see below) need to be changed, as well as the No-OS project configurations.

The overwritable parameters from the environment are:

- JESD_MODE - link layer encoder mode used; 
  - 8B10B - 8b10b link layer defined in JESD204B, uses ADI IP as Physical layer
- RX_JESD_M - RX number of converters per link, only 4 is supported
- RX_JESD_L - RX number of lanes per link, default is 4 (Options: 1/2/4)
- RX_JESD_S - RX number of samples per converter per frame, only 1 is supported
- RX_JESD_NP - RX number of bits per sample, only 16 is supported
- RX_SAMPLES_PER_CHANNEL - RX number of samples per channel, default is 2 (Computed as: L * 32 / (M * N))

Corresponding No-OS project: [ad9656_fmc](https://github.com/analogdevicesinc/no-OS/tree/main/projects/ad9656_fmc)
