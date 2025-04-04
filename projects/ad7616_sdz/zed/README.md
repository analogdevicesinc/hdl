# Ed7616-SDZ/Zed HDL Project

## Building the project

The parameter configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/ad7616_sdz/zed
make
```

The overwritable parameter from the environment:

- INTF - specifies the interface to be used; 
  - 0 - Parallel interface
  - 1 - Serial interface

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
make INTF=1
```

Corresponding No-OS project for both configurations: [ad7616-sdz](https://github.com/analogdevicesinc/no-OS/tree/main/projects/ad7616-sdz)
