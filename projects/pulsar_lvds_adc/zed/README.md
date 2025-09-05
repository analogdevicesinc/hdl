<!-- no_dts -->

# PULSAR-LVDS-ADC/ZED HDL Project

- VADJ with which it was tested in hardware: 2.5V

## Building the project

The parameter configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/pulsar_lvds_adc/zed
make
```

The overwritable parameter from the environment:

- RESOLUTION_16_18N - defines the resolution of the ADC (16 or 18 bits);
  - 0 - 16 bits
  - 1 - 18 bits

### Example configurations

#### 16-bit resolution (default) - corresponding to AD7960

This specific command is equivalent to running `make` only:

```
make RESOLUTION_16_18N=0
```

#### 18-bit resolution - corresponding to AD7625/AD7626/AD7961

```
make RESOLUTION_16_18N=1
```

Corresponding No-OS project: [ad796x_fmcz](https://github.com/analogdevicesinc/no-OS/tree/main/projects/ad796x_fmcz)
