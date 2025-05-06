# EVAL-AD7606X-FMC/ZEDBOARD HDL Project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default
configuration.

If other configurations are desired, then the parameters from the HDL project (see below) need to be changed, as well as the Linux/no-OS project configurations.

All of the configuration modes can be found in the chosen chips's data sheet. We offer support for only a few of them.

- INTF - Defines the operation interface
    - 0 - Parallel
    - 1 - Serial
- NUM_OF_SDI - Defines the number of SDI lines used: 1, 2, 4 or 8
- ADC_N_BITS - Specifies the ADC resolution: 16 or 18 bits (only for the Parallel Interface)

For the serial interface (INTF=1), the following parameters will be used in make command:
- INTF
- NUM_OF_SDI.

For the parallel interface (INTF=0), the following parameters will be used in make command:
- INTF
- ADC_N_BITS.

:warning: When switching between Serial and Parallel Interface,
make sure to replicate this move in hardware too by changing the hardware switch (JP5). Rebuild the design if the variable has been changed.

### Example configurations

This specific command is equivalent to running `make` only:

#### INTF=0 (parallel interface), ADC_N_BITS=16 (default)

```
make INTF=0 ADC_N_BITS=16
```

#### INTF=0 ADC_N_BITS=18

```
make INTF=0 ADC_N_BITS=18
```

#### INTF=1 NUM_OF_SDI=1

```
make INTF=1 NUM_OF_SDI=1
```

#### INTF=1 NUM_OF_SDI=2

```
make INTF=1 NUM_OF_SDI=2
```

#### INTF=1 NUM_OF_SDI=4

```
make INTF=1 NUM_OF_SDI=4
```

#### INTF=1 NUM_OF_SDI=8

```
make INTF=1 NUM_OF_SDI=8
```

- [AD7606x No-OS Example Project](https://analogdevicesinc.github.io/no-OS/projects/ad7606x-fmc.html)
