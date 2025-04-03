# AD719X-ASDZ/CoraZ7S HDL Project

## Building the project

The parameter configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/ad719x_asdz/coraz7s
make
```

The overwritable parameters from the environment are:

- ARDZ_PMOD_N - selects the type of connection to be used:
  - 0 - through the PMOD connector
  - 1 - through the Arduino shield

### Example configurations

#### Configuration using PMOD connector (default)

Connect the evaluation board PMOD to the PMOD JA connector of Cora.
This specific command is equivalent to running `make` only:

```
make ARDZ_PMOD_N=0
```

Corresponding device trees:

- [zynq-coraz7s-ad7190.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/zynq-coraz7s-ad7190.dts)
- [zynq-coraz7s-ad7192.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/zynq-coraz7s-ad7192.dts)
- [zynq-coraz7s-ad7193.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/zynq-coraz7s-ad7193.dts)
- [zynq-coraz7s-ad7194.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/zynq-coraz7s-ad7194.dts)
- [zynq-coraz7s-ad7195.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/zynq-coraz7s-ad7195.dts)

#### Configuration using Arduino shield

Connect the evaluation board to the Arduino shield (placing it on top of Cora).

```
make ARDZ_PMOD_N=1
```
