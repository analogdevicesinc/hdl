<!-- no_dts -->

# AD7616-SDZ/ZED HDL Project

- VADJ with which it was tested in hardware: 3.3V

## Building the project

The parameter configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/ad7616_sdz/zed
make
```

The overwritable parameter from the environment:

- INTF - specifies the interface to be used; 
  - 0 - parallel interface (default)
  - 1 - serial interface

- NUM_OF_SDI - specifies the number of SDI lines used when **serial interface** is set;
  - 1 - one SDI line
  - 2 - two SDI lines (default)

Depending on the required interface mode, some hardware modifications need to be done.
  - SL5 - unmounted - Parallel interface
  - SL5 - mounted - Serial interface
Note: This switch is a hardware switch. Please rebuild the design if the variable has been changed.

### Example configurations

#### Parallel interface (default)

This specific command is equivalent to running `make` only:

```
make INTF=0
```

#### Serial interface

```
make INTF=1 NUM_OF_SDI=1
```
```
make INTF=1 NUM_OF_SDI=2
```

Corresponding No-OS project for both configurations: [ad7616-sdz](https://github.com/analogdevicesinc/no-OS/tree/main/projects/ad7616-sdz)
