# AD738X-FMC/LFCPNX HDL Project

## Building the project

The parameters configurable through the `make` command, can be found below, as
well as in the **system_project_pb.tcl** file which contains the default configurations.

```
cd projects/ad738x_fmc/lfcpnx
make
```

The overwritable parameters from the environment:

- ALERT_SPI_N - If set to 1 the sdi[1] and sdi[3] ports are connected to gpio
  inputs and there is only a single accessible SPI sdi[0] data line for serial data.
- NUM_OF_SDI - Defines the number of SDI lines used: 1, 2, 4 (if the ALERT_SPI_N=0).
- SYSMEM_INIT_FILE - the file path to the system memory initialization file
  (<path_to>/<sysmem_file>.mem). It can be used to build a project with an
  already initialized system memory, otherwise you can load it using the
  OCM debugger from Lattice Propel SDK.

### Example configurations

#### Default configuration

This specific command is equivalent to running `make` only:

```
make ALERT_SPI_N=0 NUM_OF_SDI=1
```

#### Default configuration with SYSMEM_INIT_FILE

```
make SYSMEM_INIT_FILE=<path_to>/<sysmem_file>.mem
```

NOTE:

The Software support is still work in progress and can be found here: https://github.com/analogdevicesinc/no-OS/tree/ad738x_fmcz_lattice/projects/ad738x_fmcz
