# ADRV9364Z7020 SDR SOM 

This folder contains the ADRV9364Z7020 SOM projects for each of the carrier boards.

# Supported SOM & Carriers

|Directory      | Description                                        |
|---------------|----------------------------------------------------|
|ccbob\_cmos    | ADRV9364Z7020\-SOM (CMOS Mode) \+ ADRV1CRR\-BOB    |
|ccbob\_lvds    | ADRV9364Z7020\-SOM (LVDS Mode) \+ ADRV1CRR\-BOB    |
|ccpackrf\_lvds | ADRV9364Z7020\-SOM (LVDS Mode) \+ ADRV1CRR\-PACKRF |
|ccusb\_lvds    | ADRV9364Z7020\-SOM (LVDS Mode) \+ ADRV1CRR\-USB    |

## Board Design Files (Vivado IPI)

|Directory/File               | Description                            |
|-----------------------------|----------------------------------------|
|common/ADRV9364Z7020\_bd.tcl | ADRV9364Z7020\-SOM board design file.  |
|common/ccbob\_bd.tcl         | carrier, break out board design file.  |
|common/ccpackrf\_bd.tcl      | carrier, packrf board design file.     |
|common/ccusb\_bd.tcl         | carrier, usb board design file.        |

FMC & BOB carrier designs includes loopback daughtercards for connectivity testing.

## Board Constraint Files (pin-out & io-standard)

|Directory/File                          | Description                                     |
|----------------------------------------|-------------------------------------------------|
|common/ADRV9364Z7020\_constr.xdc        | ADRV9364Z7020\-SOM base constraints file.       |
|common/ADRV9364Z7020\_constr\_cmos.xdc  | ADRV9364Z7020\-SOM CMOS mode constraints file.  |
|common/ADRV9364Z7020\_constr\_lvds.xdc  | ADRV9364Z7020\-SOM LVDS mode constraints file.  |
|common/ccbob\_constr.xdc                | carrier, break out board constraints file.      |
|common/ccpackrf\_constr.xdc             | carrier, packrf board constraints file.         |
|common/ccusb\_constr.xdc                | carrier, usb board constraints file.            |

FMC & BOB carrier designs includes loopback daughtercards for connectivity testing.

## Building, Generating Bit Files (easy & efficient method)
```
[some-directory]> git clone -b dev git@github.com:analogdevicesinc/hdl.git
[some-directory]> make -C hdl/projects/adrv9364z7020/ccbob_cmos
```

## Building, Generating Elf Files (easy & efficient method)
```
[some-directory]> git clone -b dev git@github.com:analogdevicesinc/no-OS.git
[some-directory]> make -C no-OS/adrv9364z7020/ccbob_cmos
```

## Running, a quick test (easy & efficient method)
```
[some-directory]> make -C no-OS/adrv9364z7020/ccbob_cmos run
```

# ADRV9364Z7020 HDL Project

Here are some pointers to help you:
  * [Board Product Page](https://www.analog.com/adrv9364-z7020)
  * Parts : [RF Agile Transceiver](https://www.analog.com/ad9364)
  * Project Doc: https://wiki.analog.com/resources/eval/user-guides/adrv9364-z7020
  * HDL Doc:  https://wiki.analog.com/resources/eval/user-guides/ad-fmcomms4-ebz
  * Linux Drivers: https://wiki.analog.com/resources/tools-software/linux-drivers/iio-transceiver/ad9361
